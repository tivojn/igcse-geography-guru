"""
Vercel Serverless API for IGCSE Geography Guru
"""
from http.server import BaseHTTPRequestHandler
import json
import os
import re
import urllib.request
import urllib.error
import uuid

# Test Yourself data is now stored in Supabase

SUPABASE_URL = os.environ.get('SUPABASE_URL', 'https://wamzijrgngnvuzczxoqx.supabase.co')
SUPABASE_KEY = os.environ.get('SUPABASE_SERVICE_KEY', '')

# Model lists
CLAUDE_MODELS = [
    {"id": "claude-sonnet-4-20250514", "name": "Claude Sonnet 4 (Latest)"},
    {"id": "claude-opus-4-20250514", "name": "Claude Opus 4"},
    {"id": "claude-haiku-4-5-20251001", "name": "Claude Haiku 4.5 (Fast)"},
]
GEMINI_MODELS = [
    {"id": "gemini-2.0-flash", "name": "Gemini 2.0 Flash (Latest)"},
    {"id": "gemini-1.5-pro", "name": "Gemini 1.5 Pro"},
    {"id": "gemini-1.5-flash", "name": "Gemini 1.5 Flash"},
]
OPENAI_MODELS = [
    {"id": "gpt-4o", "name": "GPT-4o (Latest)"},
    {"id": "gpt-4o-mini", "name": "GPT-4o Mini (Fast)"},
    {"id": "gpt-4-turbo", "name": "GPT-4 Turbo"},
]

sessions = {}

def supabase_get(table, params=None):
    url = f"{SUPABASE_URL}/rest/v1/{table}"
    if params:
        url += '?' + '&'.join(f"{k}={v}" for k, v in params.items())
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
    }
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except:
        return []

def supabase_upsert(table, data):
    url = f"{SUPABASE_URL}/rest/v1/{table}"
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json',
        'Prefer': 'resolution=merge-duplicates,return=representation'
    }
    req = urllib.request.Request(url, data=json.dumps(data).encode(), headers=headers, method='POST')
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

def validate_claude_key(api_key):
    """Validate Claude API key by making a minimal request"""
    url = "https://api.anthropic.com/v1/messages"
    headers = {
        'x-api-key': api_key,
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json'
    }
    data = json.dumps({
        "model": "claude-haiku-4-5-20251001",
        "max_tokens": 1,
        "messages": [{"role": "user", "content": "hi"}]
    }).encode()
    req = urllib.request.Request(url, data=data, headers=headers, method='POST')
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            return {"valid": True, "models": CLAUDE_MODELS}
    except urllib.error.HTTPError as e:
        if e.code == 401:
            return {"valid": False, "error": "Invalid API key"}
        elif e.code == 400:
            return {"valid": True, "models": CLAUDE_MODELS}  # Bad request but key is valid
        return {"valid": False, "error": f"Error: {e.code}"}
    except Exception as e:
        return {"valid": False, "error": str(e)}

def validate_gemini_key(api_key):
    """Validate Gemini API key and fetch available models"""
    return validate_gemini_key_with_models(api_key)

def validate_openai_key(api_key):
    """Validate OpenAI API key and fetch available models"""
    url = "https://api.openai.com/v1/models"
    headers = {'Authorization': f'Bearer {api_key}'}
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            data = json.loads(response.read().decode('utf-8'))
            # Filter to chat models only
            chat_models = []
            for m in data.get('data', []):
                mid = m.get('id', '')
                if any(x in mid for x in ['gpt-4', 'gpt-3.5', 'o1', 'o3']):
                    if 'instruct' not in mid and 'audio' not in mid and 'realtime' not in mid:
                        chat_models.append({"id": mid, "name": mid})
            # Sort and deduplicate, prioritize newer models
            chat_models.sort(key=lambda x: x['id'], reverse=True)
            # Add friendly names for common models
            friendly = {
                'gpt-4o': 'GPT-4o (Latest)',
                'gpt-4o-mini': 'GPT-4o Mini (Fast)',
                'gpt-4-turbo': 'GPT-4 Turbo',
                'gpt-4': 'GPT-4',
                'gpt-3.5-turbo': 'GPT-3.5 Turbo',
                'o1': 'o1 (Reasoning)',
                'o1-mini': 'o1 Mini',
                'o1-preview': 'o1 Preview',
            }
            for m in chat_models:
                if m['id'] in friendly:
                    m['name'] = friendly[m['id']]
            return {"valid": True, "models": chat_models[:15] if chat_models else OPENAI_MODELS}
    except urllib.error.HTTPError as e:
        if e.code == 401:
            return {"valid": False, "error": "Invalid API key"}
        return {"valid": False, "error": f"Error: {e.code}"}
    except Exception as e:
        return {"valid": False, "error": str(e)}

def validate_gemini_key_with_models(api_key):
    """Validate Gemini API key and fetch available models"""
    url = f"https://generativelanguage.googleapis.com/v1beta/models?key={api_key}"
    req = urllib.request.Request(url)
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            data = json.loads(response.read().decode('utf-8'))
            models = []
            for m in data.get('models', []):
                name = m.get('name', '').replace('models/', '')
                display = m.get('displayName', name)
                # Filter to generative models
                if 'gemini' in name.lower():
                    models.append({"id": name, "name": display})
            models.sort(key=lambda x: x['name'], reverse=True)
            return {"valid": True, "models": models[:10] if models else GEMINI_MODELS}
    except urllib.error.HTTPError as e:
        if e.code in [400, 401, 403]:
            return {"valid": False, "error": "Invalid API key"}
        return {"valid": False, "error": f"Error: {e.code}"}
    except Exception as e:
        return {"valid": False, "error": str(e)}

# AI Provider Call Functions
def call_claude(api_key, model, prompt, max_tokens=1024):
    """Call Claude API"""
    url = "https://api.anthropic.com/v1/messages"
    headers = {
        'x-api-key': api_key,
        'anthropic-version': '2023-06-01',
        'Content-Type': 'application/json'
    }
    data = json.dumps({
        "model": model,
        "max_tokens": max_tokens,
        "messages": [{"role": "user", "content": prompt}]
    }).encode()
    req = urllib.request.Request(url, data=data, headers=headers, method='POST')
    try:
        with urllib.request.urlopen(req, timeout=60) as response:
            result = json.loads(response.read().decode('utf-8'))
            return {"success": True, "content": result.get('content', [{}])[0].get('text', '')}
    except urllib.error.HTTPError as e:
        error_body = e.read().decode('utf-8') if e.fp else str(e)
        return {"success": False, "error": f"Claude API error: {e.code} - {error_body}"}
    except Exception as e:
        return {"success": False, "error": str(e)}

def call_openai(api_key, model, prompt, max_tokens=1024):
    """Call OpenAI API"""
    url = "https://api.openai.com/v1/chat/completions"
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }
    data = json.dumps({
        "model": model,
        "max_tokens": max_tokens,
        "messages": [{"role": "user", "content": prompt}]
    }).encode()
    req = urllib.request.Request(url, data=data, headers=headers, method='POST')
    try:
        with urllib.request.urlopen(req, timeout=60) as response:
            result = json.loads(response.read().decode('utf-8'))
            return {"success": True, "content": result.get('choices', [{}])[0].get('message', {}).get('content', '')}
    except urllib.error.HTTPError as e:
        error_body = e.read().decode('utf-8') if e.fp else str(e)
        return {"success": False, "error": f"OpenAI API error: {e.code} - {error_body}"}
    except Exception as e:
        return {"success": False, "error": str(e)}

def call_gemini(api_key, model, prompt, max_tokens=1024):
    """Call Gemini API"""
    url = f"https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent?key={api_key}"
    headers = {'Content-Type': 'application/json'}
    data = json.dumps({
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {"maxOutputTokens": max_tokens}
    }).encode()
    req = urllib.request.Request(url, data=data, headers=headers, method='POST')
    try:
        with urllib.request.urlopen(req, timeout=60) as response:
            result = json.loads(response.read().decode('utf-8'))
            content = result.get('candidates', [{}])[0].get('content', {}).get('parts', [{}])[0].get('text', '')
            return {"success": True, "content": content}
    except urllib.error.HTTPError as e:
        error_body = e.read().decode('utf-8') if e.fp else str(e)
        return {"success": False, "error": f"Gemini API error: {e.code} - {error_body}"}
    except Exception as e:
        return {"success": False, "error": str(e)}

class handler(BaseHTTPRequestHandler):
    def _cors_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')

    def _json_response(self, status, data):
        self.send_response(status)
        self.send_header('Content-Type', 'application/json')
        self._cors_headers()
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())

    def _get_user_id(self):
        auth = self.headers.get('Authorization', '').replace('Bearer ', '')
        return sessions.get(auth)

    def do_OPTIONS(self):
        self.send_response(200)
        self._cors_headers()
        self.end_headers()

    def do_GET(self):
        path = self.path.replace('/api', '').split('?')[0]

        if path in ['/', '/health']:
            self._json_response(200, {"status": "healthy"})
            return

        if path == '/topics':
            topics = supabase_get('topics', {'select': '*', 'order': 'theme_number,topic_number'})
            themes = {}
            for t in topics:
                n = t['theme_number']
                if n not in themes:
                    themes[n] = {"theme_number": n, "theme_name": t['theme_name'], "topics": []}
                themes[n]['topics'].append({"id": t['id'], "topic_number": t['topic_number'],
                    "topic_name": t['topic_name'], "textbook_pages": t.get('textbook_pages')})
            self._json_response(200, list(themes.values()))
            return

        if path.startswith('/topics/') and not any(x in path for x in ['/flashcards', '/quiz', '/test']):
            topic_id = path.split('/')[-1]
            topics = supabase_get('topics', {'id': f'eq.{topic_id}'})
            defs = supabase_get('definitions', {'topic_id': f'eq.{topic_id}'})
            questions = supabase_get('questions', {'topic_id': f'eq.{topic_id}'})
            topic = topics[0] if topics else None
            self._json_response(200, {"topic": topic, "definitions": defs, "questions": questions, "content": {}})
            return

        if '/flashcards' in path:
            topic_id = path.split('/')[2]
            defs = supabase_get('definitions', {'topic_id': f'eq.{topic_id}'})
            self._json_response(200, defs)
            return

        if '/quiz' in path:
            topic_id = path.split('/')[2]
            questions = supabase_get('questions', {'topic_id': f'eq.{topic_id}'})
            self._json_response(200, questions)
            return

        if '/test-yourself' in path:
            parts = path.split('/')
            if len(parts) > 2:
                topic_id = parts[-1]
                # Fetch from Supabase
                questions = supabase_get('test_yourself', {
                    'topic_id': f'eq.{topic_id}',
                    'select': '*',
                    'order': 'question_number'
                })
                # Format response
                formatted = [{"number": q["question_number"], "question": q["question"], "answer": q["answer"]} for q in questions]
                self._json_response(200, formatted)
            else:
                # Return all topics
                questions = supabase_get('test_yourself', {'select': '*', 'order': 'topic_id,question_number'})
                self._json_response(200, questions)
            return

        if '/ai/settings' in path:
            user_id = self._get_user_id()
            settings = supabase_get('ai_settings', {'user_id': f'eq.{user_id}'}) if user_id else []
            s = settings[0] if settings else {}
            # Mask API keys
            for k in ['claude_api_key', 'gemini_api_key', 'openai_api_key']:
                if s.get(k):
                    s[k] = '•' * 20 + s[k][-4:]
            self._json_response(200, {
                "settings": s,
                "models": {"claude": CLAUDE_MODELS, "gemini": GEMINI_MODELS, "openai": OPENAI_MODELS}
            })
            return

        # Fetch models dynamically for a provider
        if '/ai/models/' in path:
            provider = path.split('/')[-1]
            user_id = self._get_user_id()

            if not user_id:
                self._json_response(200, {"models": [], "error": "Not logged in"})
                return

            settings = supabase_get('ai_settings', {'user_id': f'eq.{user_id}'})
            if not settings:
                self._json_response(200, {"models": [], "error": "No settings found"})
                return

            s = settings[0]
            api_key = s.get(f'{provider}_api_key')

            if not api_key:
                # Return static models if no API key
                if provider == 'claude':
                    self._json_response(200, {"models": CLAUDE_MODELS})
                elif provider == 'gemini':
                    self._json_response(200, {"models": GEMINI_MODELS})
                elif provider == 'openai':
                    self._json_response(200, {"models": OPENAI_MODELS})
                else:
                    self._json_response(200, {"models": []})
                return

            # Fetch models dynamically
            if provider == 'claude':
                # Claude doesn't have a models API, return static list
                self._json_response(200, {"models": CLAUDE_MODELS})
            elif provider == 'gemini':
                result = validate_gemini_key_with_models(api_key)
                self._json_response(200, {"models": result.get('models', GEMINI_MODELS)})
            elif provider == 'openai':
                result = validate_openai_key(api_key)
                self._json_response(200, {"models": result.get('models', OPENAI_MODELS)})
            else:
                self._json_response(200, {"models": []})
            return

        if path == '/progress':
            self._json_response(200, {"by_topic": [], "overall": {"questions_attempted": 0, "questions_correct": 0, "accuracy": 0}, "weak_points_count": 0})
            return

        self._json_response(404, {"error": "Not found"})

    def do_POST(self):
        path = self.path.replace('/api', '').split('?')[0]
        content_length = int(self.headers.get('Content-Length', 0))
        body = json.loads(self.rfile.read(content_length).decode('utf-8')) if content_length > 0 else {}

        if '/auth/login' in path:
            username = body.get('username', '')
            password = body.get('password', '')
            users = supabase_get('users', {'username': f'eq.{username}', 'select': '*'})
            if users and len(users) > 0:
                user = users[0]
                if user.get('password') == password:
                    token = str(uuid.uuid4())
                    sessions[token] = user['id']
                    self._json_response(200, {
                        "token": token,
                        "user": {"id": user['id'], "username": user['username'], "display_name": user.get('display_name')}
                    })
                    return
            self._json_response(401, {"error": "Invalid credentials"})
            return

        if '/auth/logout' in path:
            self._json_response(200, {"success": True})
            return

        # Validate API key
        if '/ai/validate-key' in path:
            provider = body.get('provider', '')
            api_key = body.get('api_key', '')

            if not provider or not api_key:
                self._json_response(400, {"valid": False, "error": "Missing provider or API key"})
                return

            if provider == 'claude':
                result = validate_claude_key(api_key)
            elif provider == 'gemini':
                result = validate_gemini_key(api_key)
            elif provider == 'openai':
                result = validate_openai_key(api_key)
            else:
                result = {"valid": False, "error": "Unknown provider"}

            # If valid, save to database
            if result.get('valid'):
                user_id = self._get_user_id()
                if user_id:
                    data = {
                        'user_id': user_id,
                        f'{provider}_api_key': api_key,
                        f'{provider}_validated': True
                    }
                    supabase_upsert('ai_settings', data)

            self._json_response(200, result)
            return

        # Update AI settings
        if '/ai/settings' in path:
            user_id = self._get_user_id()
            if user_id:
                data = {'user_id': user_id}
                for key in ['default_provider', 'claude_model', 'gemini_model', 'openai_model']:
                    if key in body:
                        data[key] = body[key]
                supabase_upsert('ai_settings', data)
            self._json_response(200, {"success": True})
            return

        # AI Generate Questions
        if '/ai/generate-questions' in path:
            user_id = self._get_user_id()
            if not user_id:
                self._json_response(401, {"error": "Please log in to use AI features"})
                return

            # Get user's AI settings
            settings = supabase_get('ai_settings', {'user_id': f'eq.{user_id}'})
            if not settings:
                self._json_response(400, {"error": "Please configure AI settings first"})
                return

            s = settings[0]
            provider = s.get('default_provider', 'claude')
            api_key = s.get(f'{provider}_api_key')
            model = s.get(f'{provider}_model')

            if not api_key:
                self._json_response(400, {"error": f"Please add your {provider.title()} API key in Settings"})
                return

            # Get the source question
            question_id = body.get('question_id')
            num_questions = body.get('num_questions', 3)

            if not question_id:
                self._json_response(400, {"error": "Missing question_id"})
                return

            # Fetch the original question
            questions = supabase_get('questions', {'id': f'eq.{question_id}'})
            if not questions:
                self._json_response(404, {"error": "Question not found"})
                return

            original = questions[0]

            # Build the prompt
            prompt = f"""Generate {num_questions} similar IGCSE Geography exam questions based on this question:

Original Question: {original.get('question_text', '')}
Command Word: {original.get('command_word', '')}
Marks: {original.get('marks', 2)}
Topic: {original.get('topic_id', '')}

Requirements:
1. Use the same command word ({original.get('command_word', 'describe')})
2. Target the same mark allocation ({original.get('marks', 2)} marks)
3. Test similar concepts but with different scenarios/examples
4. Follow IGCSE Geography exam style

Return ONLY a JSON array with this format:
[
  {{"question_text": "...", "command_word": "{original.get('command_word', 'describe')}", "marks": {original.get('marks', 2)}, "mark_scheme": "..."}}
]"""

            # Call the appropriate AI provider
            if provider == 'claude':
                result = call_claude(api_key, model or 'claude-haiku-4-5-20251001', prompt)
            elif provider == 'openai':
                result = call_openai(api_key, model or 'gpt-4o-mini', prompt)
            elif provider == 'gemini':
                result = call_gemini(api_key, model or 'gemini-2.0-flash', prompt)
            else:
                self._json_response(400, {"error": f"Unknown provider: {provider}"})
                return

            if not result.get('success'):
                self._json_response(500, {"error": result.get('error', 'AI generation failed')})
                return

            # Parse the AI response
            content = result.get('content', '')
            try:
                # Extract JSON from response
                json_match = re.search(r'\[[\s\S]*\]', content)
                if json_match:
                    generated = json.loads(json_match.group())
                    # Add topic_id and save to database
                    saved_questions = []
                    for q in generated:
                        q['topic_id'] = original.get('topic_id')
                        q['ai_generated'] = True
                        saved = supabase_upsert('questions', q)
                        if saved and not saved.get('error'):
                            saved_questions.append(saved[0] if isinstance(saved, list) else saved)

                    self._json_response(200, {"questions": saved_questions, "generated": len(saved_questions)})
                    return
                else:
                    self._json_response(500, {"error": "Could not parse AI response"})
                    return
            except json.JSONDecodeError as e:
                self._json_response(500, {"error": f"Invalid JSON from AI: {str(e)}"})
                return

        # AI Chat (general)
        if '/ai/chat' in path:
            user_id = self._get_user_id()
            if not user_id:
                self._json_response(401, {"error": "Please log in to use AI features"})
                return

            settings = supabase_get('ai_settings', {'user_id': f'eq.{user_id}'})
            if not settings:
                self._json_response(400, {"error": "Please configure AI settings first"})
                return

            s = settings[0]
            provider = s.get('default_provider', 'claude')
            api_key = s.get(f'{provider}_api_key')
            model = s.get(f'{provider}_model')

            if not api_key:
                self._json_response(400, {"error": f"Please add your {provider.title()} API key in Settings"})
                return

            prompt = body.get('message', '')
            if not prompt:
                self._json_response(400, {"error": "Missing message"})
                return

            if provider == 'claude':
                result = call_claude(api_key, model or 'claude-haiku-4-5-20251001', prompt)
            elif provider == 'openai':
                result = call_openai(api_key, model or 'gpt-4o-mini', prompt)
            elif provider == 'gemini':
                result = call_gemini(api_key, model or 'gemini-2.0-flash', prompt)
            else:
                self._json_response(400, {"error": f"Unknown provider: {provider}"})
                return

            if result.get('success'):
                self._json_response(200, {"response": result.get('content', '')})
            else:
                self._json_response(500, {"error": result.get('error', 'AI request failed')})
            return

        self._json_response(200, {"success": True})

    def do_PUT(self):
        # Handle PUT same as POST for settings
        self.do_POST()
