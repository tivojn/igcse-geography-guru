"""
Vercel Serverless API for IGCSE Geography Guru
"""
from http.server import BaseHTTPRequestHandler
import json
import os
import urllib.request
import urllib.error
import uuid

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
    """Validate Gemini API key by listing models"""
    url = f"https://generativelanguage.googleapis.com/v1beta/models?key={api_key}"
    req = urllib.request.Request(url)
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            return {"valid": True, "models": GEMINI_MODELS}
    except urllib.error.HTTPError as e:
        if e.code == 400 or e.code == 401 or e.code == 403:
            return {"valid": False, "error": "Invalid API key"}
        return {"valid": False, "error": f"Error: {e.code}"}
    except Exception as e:
        return {"valid": False, "error": str(e)}

def validate_openai_key(api_key):
    """Validate OpenAI API key by listing models"""
    url = "https://api.openai.com/v1/models"
    headers = {'Authorization': f'Bearer {api_key}'}
    req = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(req, timeout=10) as response:
            return {"valid": True, "models": OPENAI_MODELS}
    except urllib.error.HTTPError as e:
        if e.code == 401:
            return {"valid": False, "error": "Invalid API key"}
        return {"valid": False, "error": f"Error: {e.code}"}
    except Exception as e:
        return {"valid": False, "error": str(e)}

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
            from content_data import TEST_YOURSELF
            parts = path.split('/')
            if len(parts) > 2:
                topic_id = parts[-1]
                data = TEST_YOURSELF.get(topic_id, {})
                questions = [{"number": q["id"], "question": q["q"], "answer": q["a"]} for q in data.get("questions", [])]
                self._json_response(200, questions)
            else:
                self._json_response(200, TEST_YOURSELF)
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

        self._json_response(200, {"success": True})

    def do_PUT(self):
        # Handle PUT same as POST for settings
        self.do_POST()
