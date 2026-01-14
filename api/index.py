"""
Vercel Serverless API for IGCSE Geography Guru
With RAG (Retrieval-Augmented Generation) for PDF Chat
"""
from http.server import BaseHTTPRequestHandler
import json
import os
import re
import urllib.request
import urllib.error
import uuid
import base64
from io import BytesIO

# Test Yourself data is now stored in Supabase

SUPABASE_URL = os.environ.get('SUPABASE_URL', 'https://wamzijrgngnvuzczxoqx.supabase.co')
SUPABASE_KEY = os.environ.get('SUPABASE_SERVICE_KEY', '')

# OpenAI API for embeddings (user provides their own key)
OPENAI_EMBEDDING_MODEL = 'text-embedding-3-small'
OPENAI_EMBEDDING_DIMENSION = 1536

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

def list_openai_models(api_key, timeout=15):
    """Fetch all models from OpenAI API"""
    url = "https://api.openai.com/v1/models"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Accept": "application/json",
        "User-Agent": "igcse-geography-guru/1.0",
    }
    req = urllib.request.Request(url, headers=headers, method="GET")

    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            body = resp.read().decode("utf-8")
            payload = json.loads(body)
        models = payload.get("data", [])
        return [m.get("id") for m in models if isinstance(m, dict) and "id" in m]

    except urllib.error.HTTPError as e:
        raw = e.read().decode("utf-8", errors="replace")
        try:
            err_payload = json.loads(raw)
            err_msg = err_payload.get("error", {}).get("message", raw[:200])
        except json.JSONDecodeError:
            err_msg = raw[:200]

        if e.code == 401:
            raise ValueError("Invalid API key (401 Unauthorized)")
        if e.code == 403:
            raise PermissionError(f"Access forbidden (403): {err_msg}")
        raise RuntimeError(f"OpenAI API error {e.code}: {err_msg}")

    except urllib.error.URLError as e:
        raise ConnectionError(f"Network error: {e}")


def filter_chat_models(model_ids):
    """Filter to chat-capable models and return with friendly names"""
    # Exclude non-chat models (be specific to avoid excluding valid chat models)
    exclude = ['whisper', 'tts-', 'dall-e', 'embedding', 'moderation',
               'instruct', '-audio', 'realtime', 'similarity',
               'text-embedding', 'text-davinci', 'text-curie', 'text-babbage', 'text-ada',
               'davinci-002', 'curie', 'babbage-002', 'ada', 'transcribe', 'diarize',
               'gpt-image', 'sora', 'codex']
    include = ['gpt-3', 'gpt-4', 'gpt-5', 'o1', 'o3', 'o4', 'o5', 'chatgpt']

    chat_models = []
    for mid in model_ids:
        mid_lower = mid.lower()
        if any(p in mid_lower for p in include):
            if not any(ex in mid_lower for ex in exclude):
                chat_models.append({"id": mid, "name": mid})

    # Sort: newest/best models first
    def sort_key(m):
        mid = m['id']
        if 'gpt-5' in mid: return (0, mid)  # GPT-5.x first
        if mid.startswith('o3'): return (1, mid)
        if mid.startswith('o1'): return (2, mid)
        if 'gpt-4o' in mid: return (3, mid)
        if 'gpt-4' in mid: return (4, mid)
        if 'gpt-3.5' in mid: return (5, mid)
        return (6, mid)
    chat_models.sort(key=sort_key)

    # Add friendly names
    friendly = {
        # GPT-5.x series
        'gpt-5.2': 'GPT-5.2 (Latest)',
        'gpt-5.2-pro': 'GPT-5.2 Pro',
        'gpt-5.1': 'GPT-5.1',
        'gpt-5': 'GPT-5',
        'gpt-5-pro': 'GPT-5 Pro',
        'gpt-5-mini': 'GPT-5 Mini (Fast)',
        'gpt-5-nano': 'GPT-5 Nano (Fastest)',
        'gpt-5-search-api': 'GPT-5 Search',
        # GPT-4.x series
        'gpt-4.1': 'GPT-4.1',
        'gpt-4.1-mini': 'GPT-4.1 Mini',
        'gpt-4.1-nano': 'GPT-4.1 Nano',
        'gpt-4o': 'GPT-4o (Flagship)',
        'gpt-4o-mini': 'GPT-4o Mini (Fast & Cheap)',
        'gpt-4o-search-preview': 'GPT-4o Search',
        'gpt-4o-mini-search-preview': 'GPT-4o Mini Search',
        'gpt-4-turbo': 'GPT-4 Turbo',
        'gpt-4': 'GPT-4',
        'gpt-3.5-turbo': 'GPT-3.5 Turbo',
        # o-series
        'o3-pro': 'o3 Pro (Most Powerful)',
        'o3': 'o3 (Advanced)',
        'o3-mini': 'o3 Mini',
        'o4-mini': 'o4 Mini',
        'o1-pro': 'o1 Pro',
        'o1': 'o1 (Reasoning)',
        'o1-mini': 'o1 Mini',
        'chatgpt-4o-latest': 'ChatGPT-4o Latest',
    }
    for m in chat_models:
        if m['id'] in friendly:
            m['name'] = friendly[m['id']]

    return chat_models[:40]  # Return up to 40 models


def validate_openai_key(api_key):
    """Validate OpenAI API key and fetch available chat models"""
    try:
        all_models = list_openai_models(api_key)
        chat_models = filter_chat_models(all_models)
        return {"valid": True, "models": chat_models if chat_models else OPENAI_MODELS}
    except ValueError as e:
        return {"valid": False, "error": str(e)}
    except PermissionError as e:
        return {"valid": False, "error": str(e)}
    except (RuntimeError, ConnectionError) as e:
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
    # Newer models (o1, o3, gpt-4o, gpt-5) use max_completion_tokens instead of max_tokens
    uses_new_param = any(x in model.lower() for x in ['o1', 'o3', 'o4', 'o5', 'gpt-4o', 'gpt-5'])
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}]
    }
    if uses_new_param:
        payload["max_completion_tokens"] = max_tokens
    else:
        payload["max_tokens"] = max_tokens
    data = json.dumps(payload).encode()
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

# ============================================
# RAG HELPER FUNCTIONS
# ============================================

def get_openai_embedding(api_key, text):
    """Generate embedding using OpenAI text-embedding-3-small"""
    url = "https://api.openai.com/v1/embeddings"
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }
    data = json.dumps({
        "model": OPENAI_EMBEDDING_MODEL,
        "input": text
    }).encode()
    req = urllib.request.Request(url, data=data, headers=headers, method='POST')
    try:
        with urllib.request.urlopen(req, timeout=30) as response:
            result = json.loads(response.read().decode('utf-8'))
            embedding = result.get('data', [{}])[0].get('embedding', [])
            return {"success": True, "embedding": embedding}
    except urllib.error.HTTPError as e:
        error_body = e.read().decode('utf-8') if e.fp else str(e)
        return {"success": False, "error": f"OpenAI Embedding error: {e.code} - {error_body}"}
    except Exception as e:
        return {"success": False, "error": str(e)}

def chunk_text(text, chunk_size=500, overlap=50):
    """Split text into overlapping chunks"""
    words = text.split()
    chunks = []
    start = 0
    while start < len(words):
        end = start + chunk_size
        chunk = ' '.join(words[start:end])
        chunks.append(chunk)
        start = end - overlap
    return chunks

def supabase_post(table, data):
    """POST to Supabase (insert only, no upsert)"""
    url = f"{SUPABASE_URL}/rest/v1/{table}"
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
    }
    req = urllib.request.Request(url, data=json.dumps(data).encode(), headers=headers, method='POST')
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

def supabase_patch(table, data, filters):
    """PATCH to Supabase (update)"""
    url = f"{SUPABASE_URL}/rest/v1/{table}?" + '&'.join(f"{k}={v}" for k, v in filters.items())
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
    }
    req = urllib.request.Request(url, data=json.dumps(data).encode(), headers=headers, method='PATCH')
    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

def supabase_delete(table, filters):
    """DELETE from Supabase"""
    url = f"{SUPABASE_URL}/rest/v1/{table}?" + '&'.join(f"{k}={v}" for k, v in filters.items())
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
    }
    req = urllib.request.Request(url, headers=headers, method='DELETE')
    try:
        with urllib.request.urlopen(req) as response:
            return {"success": True}
    except Exception as e:
        return {"error": str(e)}

def supabase_rpc(function_name, params):
    """Call Supabase RPC function"""
    url = f"{SUPABASE_URL}/rest/v1/rpc/{function_name}"
    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json'
    }
    req = urllib.request.Request(url, data=json.dumps(params).encode(), headers=headers, method='POST')
    try:
        with urllib.request.urlopen(req, timeout=30) as response:
            return json.loads(response.read().decode('utf-8'))
    except Exception as e:
        return {"error": str(e)}

def upload_to_supabase_storage(bucket, path, file_data, content_type='application/pdf'):
    """Upload file to Supabase storage"""
    url = f"{SUPABASE_URL}/storage/v1/object/{bucket}/{path}"
    headers = {
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': content_type
    }
    req = urllib.request.Request(url, data=file_data, headers=headers, method='POST')
    try:
        with urllib.request.urlopen(req, timeout=60) as response:
            return {"success": True, "path": path}
    except urllib.error.HTTPError as e:
        error_msg = e.read().decode('utf-8') if e.fp else str(e)
        # Try PUT if POST fails (for overwriting)
        req = urllib.request.Request(url, data=file_data, headers=headers, method='PUT')
        try:
            with urllib.request.urlopen(req, timeout=60) as response:
                return {"success": True, "path": path}
        except Exception as e2:
            return {"success": False, "error": f"PUT failed: {str(e2)}, POST error: {error_msg}"}
    except Exception as e:
        return {"success": False, "error": f"Upload exception: {str(e)}"}

def get_public_url(bucket, path):
    """Get public URL for a file in Supabase storage"""
    return f"{SUPABASE_URL}/storage/v1/object/public/{bucket}/{path}"

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
                # Path could be /api/test-yourself/{topic_number} or /api/topics/{id}/test-yourself
                topic_identifier = parts[-2] if parts[-1] == 'test-yourself' else parts[-1]

                # If it looks like a topic_number (e.g., '1.1'), look up the topic_id
                if '.' in str(topic_identifier):
                    topic_lookup = supabase_get('topics', {
                        'topic_number': f'eq.{topic_identifier}',
                        'select': 'id'
                    })
                    topic_id = topic_lookup[0]['id'] if topic_lookup else None
                else:
                    topic_id = topic_identifier

                if topic_id:
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
                    self._json_response(200, [])
            else:
                # Return all topics
                questions = supabase_get('test_yourself', {'select': '*', 'order': 'topic_id,question_number'})
                self._json_response(200, questions)
            return

        if '/ai/settings' in path:
            user_id = self._get_user_id()
            settings = None
            if user_id:
                settings = supabase_get('ai_settings', {'user_id': f'eq.{user_id}'})
            if not settings:
                # Fallback: get first ai_settings record (for single-user/demo mode)
                settings = supabase_get('ai_settings', {'select': '*', 'limit': '1'})
            s = settings[0] if settings else {}

            # Fetch dynamic models for validated providers
            models = {"claude": CLAUDE_MODELS, "gemini": GEMINI_MODELS, "openai": OPENAI_MODELS}

            # If OpenAI key is validated, fetch dynamic model list
            if s.get('openai_validated') and s.get('openai_api_key'):
                try:
                    result = validate_openai_key(s['openai_api_key'])
                    if result.get('valid') and result.get('models'):
                        models['openai'] = result['models']
                except:
                    pass  # Fall back to static models

            # If Gemini key is validated, fetch dynamic model list
            if s.get('gemini_validated') and s.get('gemini_api_key'):
                try:
                    result = validate_gemini_key_with_models(s['gemini_api_key'])
                    if result.get('valid') and result.get('models'):
                        models['gemini'] = result['models']
                except:
                    pass  # Fall back to static models

            # Mask API keys for response
            for k in ['claude_api_key', 'gemini_api_key', 'openai_api_key']:
                if s.get(k):
                    s[k] = '•' * 20 + s[k][-4:]

            self._json_response(200, {
                "settings": s,
                "models": models
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

        # ============================================
        # NEW ENDPOINTS FOR UPGRADED FEATURES
        # ============================================

        # Exam Questions with Model Answers
        if path == '/exam-questions':
            questions = supabase_get('exam_questions', {'select': '*', 'order': 'topic_id'})
            self._json_response(200, questions)
            return

        if path.startswith('/exam-questions/'):
            topic_id = path.split('/')[-1]
            questions = supabase_get('exam_questions', {
                'topic_id': f'eq.{topic_id}',
                'select': '*',
                'order': 'marks'
            })
            self._json_response(200, questions)
            return

        # Case Studies
        if path == '/case-studies':
            case_studies = supabase_get('case_studies', {'select': '*', 'order': 'topic_id'})
            self._json_response(200, case_studies)
            return

        if path.startswith('/case-studies/topic/'):
            topic_id = path.split('/')[-1]
            case_studies = supabase_get('case_studies', {
                'topic_id': f'eq.{topic_id}',
                'select': '*'
            })
            self._json_response(200, case_studies)
            return

        if path.startswith('/case-studies/') and '/topic/' not in path:
            case_id = path.split('/')[-1]
            case_studies = supabase_get('case_studies', {'id': f'eq.{case_id}'})
            self._json_response(200, case_studies[0] if case_studies else {})
            return

        # Tips
        if path == '/tips':
            tips = supabase_get('tips', {'select': '*', 'order': 'topic_id'})
            self._json_response(200, tips)
            return

        if path.startswith('/tips/'):
            topic_id = path.split('/')[-1]
            tips = supabase_get('tips', {
                'topic_id': f'eq.{topic_id}',
                'select': '*'
            })
            self._json_response(200, tips)
            return

        # Common Errors
        if path == '/common-errors':
            errors = supabase_get('common_errors', {'select': '*', 'order': 'topic_id'})
            self._json_response(200, errors)
            return

        if path.startswith('/common-errors/'):
            topic_id = path.split('/')[-1]
            errors = supabase_get('common_errors', {
                'topic_id': f'eq.{topic_id}',
                'select': '*'
            })
            self._json_response(200, errors)
            return

        # Learning Objectives
        if path == '/learning-objectives':
            objectives = supabase_get('learning_objectives', {'select': '*', 'order': 'topic_id,order_num'})
            self._json_response(200, objectives)
            return

        if path.startswith('/learning-objectives/'):
            topic_id = path.split('/')[-1]
            objectives = supabase_get('learning_objectives', {
                'topic_id': f'eq.{topic_id}',
                'select': '*',
                'order': 'order_num'
            })
            self._json_response(200, objectives)
            return

        # Sample Answers with Teacher Comments
        if path == '/sample-answers':
            answers = supabase_get('sample_answers', {'select': '*', 'order': 'topic_id'})
            self._json_response(200, answers)
            return

        if path.startswith('/sample-answers/'):
            topic_id = path.split('/')[-1]
            answers = supabase_get('sample_answers', {
                'topic_id': f'eq.{topic_id}',
                'select': '*'
            })
            self._json_response(200, answers)
            return

        # Combined topic content (all new features for a topic)
        if path.startswith('/topic-content/'):
            topic_id = path.split('/')[-1]
            content = {
                'exam_questions': supabase_get('exam_questions', {'topic_id': f'eq.{topic_id}', 'select': '*'}),
                'case_studies': supabase_get('case_studies', {'topic_id': f'eq.{topic_id}', 'select': '*'}),
                'tips': supabase_get('tips', {'topic_id': f'eq.{topic_id}', 'select': '*'}),
                'common_errors': supabase_get('common_errors', {'topic_id': f'eq.{topic_id}', 'select': '*'}),
                'learning_objectives': supabase_get('learning_objectives', {'topic_id': f'eq.{topic_id}', 'select': '*', 'order': 'order_num'}),
                'sample_answers': supabase_get('sample_answers', {'topic_id': f'eq.{topic_id}', 'select': '*'})
            }
            self._json_response(200, content)
            return

        # Stats endpoint for dashboard
        if path == '/stats':
            topics_count = len(supabase_get('topics', {'select': 'id'}))
            definitions_count = len(supabase_get('definitions', {'select': 'id'}))
            test_yourself_count = len(supabase_get('test_yourself', {'select': 'id'}))
            exam_questions_count = len(supabase_get('exam_questions', {'select': 'id'}))
            case_studies_count = len(supabase_get('case_studies', {'select': 'id'}))
            tips_count = len(supabase_get('tips', {'select': 'id'}))
            common_errors_count = len(supabase_get('common_errors', {'select': 'id'}))
            self._json_response(200, {
                'topics': topics_count,
                'definitions': definitions_count,
                'test_yourself': test_yourself_count,
                'exam_questions': exam_questions_count,
                'case_studies': case_studies_count,
                'tips': tips_count,
                'common_errors': common_errors_count
            })
            return

        # ============================================
        # RAG ENDPOINTS
        # ============================================

        # Get user's PDF documents
        if path == '/pdf/documents':
            docs = supabase_get('pdf_documents', {'select': '*', 'order': 'created_at.desc'})
            # Add public URLs
            for doc in docs:
                doc['public_url'] = get_public_url('documents', doc.get('storage_path', ''))
            self._json_response(200, docs)
            return

        # Get single PDF document
        if path.startswith('/pdf/documents/') and not path.endswith('/chunks'):
            doc_id = path.split('/')[-1]
            docs = supabase_get('pdf_documents', {'id': f'eq.{doc_id}'})
            if docs:
                doc = docs[0]
                doc['public_url'] = get_public_url('documents', doc.get('storage_path', ''))
                self._json_response(200, doc)
            else:
                self._json_response(404, {"error": "Document not found"})
            return

        # Get chunks for a document
        if path.endswith('/chunks'):
            doc_id = path.split('/')[-2]
            chunks = supabase_get('pdf_chunks', {
                'document_id': f'eq.{doc_id}',
                'select': 'id,chunk_index,page_number,content',
                'order': 'chunk_index'
            })
            self._json_response(200, chunks)
            return

        # Get user settings (for API keys)
        if path == '/user-settings':
            settings = supabase_get('user_settings', {'select': '*', 'limit': '1'})
            if settings:
                s = settings[0]
                # Mask API keys
                if s.get('openai_api_key'):
                    s['openai_api_key'] = '•' * 20 + s['openai_api_key'][-4:]
                if s.get('anthropic_api_key'):
                    s['anthropic_api_key'] = '•' * 20 + s['anthropic_api_key'][-4:]
            self._json_response(200, settings[0] if settings else {})
            return

        # Get chat history
        if path.startswith('/rag/chat/history/'):
            doc_id = path.split('/')[-1]
            messages = supabase_get('chat_messages', {
                'document_id': f'eq.{doc_id}',
                'select': '*',
                'order': 'created_at'
            })
            self._json_response(200, messages)
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
                # Use a default user_id for demo/single-user mode if no session
                if not user_id:
                    user_id = '00000000-0000-0000-0000-000000000001'

                # Check if settings already exist for this user
                existing = supabase_get('ai_settings', {'user_id': f'eq.{user_id}'})
                data = {
                    'user_id': user_id,
                    f'{provider}_api_key': api_key,
                    f'{provider}_validated': True
                }
                if existing:
                    # Update existing record
                    supabase_patch('ai_settings', data, {'user_id': f'eq.{user_id}'})
                else:
                    # Insert new record
                    supabase_post('ai_settings', data)

            self._json_response(200, result)
            return

        # Update AI settings
        if '/ai/settings' in path:
            user_id = self._get_user_id()
            # Use default user_id for demo/single-user mode if no session
            if not user_id:
                user_id = '00000000-0000-0000-0000-000000000001'
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

        # ============================================
        # RAG POST ENDPOINTS
        # ============================================

        # Save user settings (API keys)
        if '/user-settings' in path:
            data = {
                'id': body.get('id') or str(uuid.uuid4()),
            }
            if 'openai_api_key' in body:
                data['openai_api_key'] = body['openai_api_key']
            if 'anthropic_api_key' in body:
                data['anthropic_api_key'] = body['anthropic_api_key']
            if 'default_llm' in body:
                data['default_llm'] = body['default_llm']

            # Check if settings exist
            existing = supabase_get('user_settings', {'select': 'id', 'limit': '1'})
            if existing:
                result = supabase_patch('user_settings', data, {'id': f'eq.{existing[0]["id"]}'})
            else:
                result = supabase_post('user_settings', data)

            self._json_response(200, {"success": True, "data": result})
            return

        # Create document record only (file uploaded directly to Supabase from browser)
        if '/pdf/create-record' in path:
            doc_id = body.get('id')
            filename = body.get('filename', 'document.pdf')
            original_filename = body.get('original_filename', filename)
            storage_path = body.get('storage_path', '')
            file_size = body.get('file_size', 0)

            if not doc_id:
                self._json_response(400, {"error": "Missing document id"})
                return

            try:
                doc_data = {
                    'id': doc_id,
                    'filename': filename,
                    'original_filename': original_filename,
                    'storage_path': storage_path,
                    'file_size': file_size,
                    'status': 'pending'
                }
                doc_result = supabase_post('pdf_documents', doc_data)

                if doc_result and not doc_result.get('error'):
                    doc = doc_result[0] if isinstance(doc_result, list) else doc_result
                    doc['public_url'] = get_public_url('documents', storage_path) if storage_path else ''
                    self._json_response(200, doc)
                else:
                    db_error = doc_result.get('error') if doc_result else 'Unknown DB error'
                    self._json_response(500, {"error": f"Failed to create document record: {db_error}"})
                return
            except Exception as e:
                self._json_response(500, {"error": f"Create record error: {str(e)}"})
                return

        # Upload PDF and create document record (legacy - for small files via base64)
        if '/pdf/upload' in path:
            # Expect base64-encoded PDF data
            pdf_base64 = body.get('file_data', '')
            filename = body.get('filename', 'document.pdf')

            if not pdf_base64:
                self._json_response(400, {"error": "No file data provided"})
                return

            try:
                # Decode base64
                pdf_data = base64.b64decode(pdf_base64)

                # Generate unique document ID
                doc_id = str(uuid.uuid4())
                # Sanitize filename for storage path (remove special chars)
                safe_filename = re.sub(r'[^\w\-_.]', '_', filename)
                storage_path = f"{doc_id}/{safe_filename}"

                # Try to upload to Supabase storage (optional - don't fail if storage unavailable)
                storage_success = False
                storage_error = None
                try:
                    upload_result = upload_to_supabase_storage('documents', storage_path, pdf_data)
                    storage_success = upload_result.get('success', False)
                    if not storage_success:
                        storage_error = upload_result.get('error', 'Unknown storage error')
                except Exception as storage_exc:
                    storage_error = str(storage_exc)

                # Create document record even if storage fails
                # (We can still process text extracted client-side)
                doc_data = {
                    'id': doc_id,
                    'filename': safe_filename,
                    'original_filename': filename,
                    'storage_path': storage_path if storage_success else '',
                    'file_size': len(pdf_data),
                    'status': 'pending'
                }
                doc_result = supabase_post('pdf_documents', doc_data)

                if doc_result and not doc_result.get('error'):
                    doc = doc_result[0] if isinstance(doc_result, list) else doc_result
                    doc['public_url'] = get_public_url('documents', storage_path) if storage_success else ''
                    doc['storage_warning'] = storage_error if storage_error else None
                    self._json_response(200, doc)
                else:
                    db_error = doc_result.get('error') if doc_result else 'Unknown DB error'
                    self._json_response(500, {"error": f"Failed to create document record: {db_error}"})
                return

            except base64.binascii.Error as e:
                self._json_response(400, {"error": f"Invalid file data (base64 decode failed): {str(e)}"})
                return
            except Exception as e:
                self._json_response(500, {"error": f"Upload error: {str(e)}"})
                return

        # Process PDF - extract text and generate embeddings
        if '/pdf/process' in path:
            doc_id = body.get('document_id')
            openai_api_key = body.get('openai_api_key')
            use_stored_key = body.get('use_stored_key', False)
            pages_text = body.get('pages_text', [])  # Array of {page_number, text}

            if not doc_id:
                self._json_response(400, {"error": "Missing document_id"})
                return

            # If use_stored_key is True, get key from ai_settings
            if use_stored_key or not openai_api_key:
                # Try user-specific settings first, then fall back to any settings
                user_id = self._get_user_id()
                settings = None
                if user_id:
                    settings = supabase_get('ai_settings', {'user_id': f'eq.{user_id}'})
                if not settings:
                    # Fallback: get first ai_settings record (for single-user/demo mode)
                    settings = supabase_get('ai_settings', {'select': '*', 'limit': '1'})
                if settings and settings[0].get('openai_api_key'):
                    openai_api_key = settings[0]['openai_api_key']

            if not openai_api_key:
                self._json_response(400, {"error": "Missing OpenAI API key. Please configure it in Settings first."})
                return

            if not pages_text:
                self._json_response(400, {"error": "Missing pages_text"})
                return

            try:
                # Update document status
                supabase_patch('pdf_documents', {'status': 'processing'}, {'id': f'eq.{doc_id}'})

                # Process each page and create chunks
                all_chunks = []
                chunk_index = 0

                for page_data in pages_text:
                    page_number = page_data.get('page_number', 1)
                    text = page_data.get('text', '')

                    if not text.strip():
                        continue

                    # Chunk the page text
                    page_chunks = chunk_text(text, chunk_size=400, overlap=50)

                    for chunk_content in page_chunks:
                        if len(chunk_content.strip()) < 20:
                            continue

                        # Generate embedding
                        embed_result = get_openai_embedding(openai_api_key, chunk_content)

                        if not embed_result.get('success'):
                            continue

                        embedding = embed_result.get('embedding', [])

                        # Store chunk
                        chunk_data = {
                            'document_id': doc_id,
                            'chunk_index': chunk_index,
                            'page_number': page_number,
                            'content': chunk_content,
                            'token_count': len(chunk_content.split()),
                            'embedding': embedding
                        }

                        supabase_post('pdf_chunks', chunk_data)
                        all_chunks.append({'chunk_index': chunk_index, 'page_number': page_number})
                        chunk_index += 1

                # Update document status
                supabase_patch('pdf_documents', {
                    'status': 'ready',
                    'page_count': len(pages_text)
                }, {'id': f'eq.{doc_id}'})

                self._json_response(200, {
                    "success": True,
                    "chunks_created": len(all_chunks),
                    "pages_processed": len(pages_text)
                })
                return

            except Exception as e:
                supabase_patch('pdf_documents', {
                    'status': 'error',
                    'error_message': str(e)
                }, {'id': f'eq.{doc_id}'})
                self._json_response(500, {"error": f"Processing error: {str(e)}"})
                return

        # RAG Chat - query documents and generate response (supports multi-doc)
        if '/rag/chat' in path:
            question = body.get('question', '')
            document_ids = body.get('document_ids', [])  # Array of doc IDs for multi-doc RAG
            document_id = body.get('document_id')  # Legacy single doc support
            openai_api_key = body.get('openai_api_key')
            use_stored_key = body.get('use_stored_key', False)
            llm_provider = body.get('llm_provider', 'openai')
            llm_api_key = body.get('llm_api_key')
            llm_model = body.get('llm_model', 'gpt-4o-mini')

            # Support both old (document_id) and new (document_ids) params
            if document_id and not document_ids:
                document_ids = [document_id]

            if not question:
                self._json_response(400, {"error": "Missing question"})
                return

            # If use_stored_key is True, get key from ai_settings
            if use_stored_key or not openai_api_key:
                # Try user-specific settings first, then fall back to any settings
                user_id = self._get_user_id()
                settings = None
                if user_id:
                    settings = supabase_get('ai_settings', {'user_id': f'eq.{user_id}'})
                if not settings:
                    # Fallback: get first ai_settings record (for single-user/demo mode)
                    settings = supabase_get('ai_settings', {'select': '*', 'limit': '1'})
                if settings:
                    s = settings[0]
                    if not openai_api_key and s.get('openai_api_key'):
                        openai_api_key = s['openai_api_key']
                    if not llm_api_key:
                        # Use appropriate LLM key based on provider
                        llm_api_key = s.get(f'{llm_provider}_api_key') or openai_api_key
                        llm_model = s.get(f'{llm_provider}_model') or llm_model

            if not openai_api_key:
                self._json_response(400, {"error": "Missing OpenAI API key. Please configure it in Settings first."})
                return

            if not llm_api_key:
                llm_api_key = openai_api_key  # Use OpenAI key if no separate LLM key

            try:
                # Generate embedding for question
                embed_result = get_openai_embedding(openai_api_key, question)

                if not embed_result.get('success'):
                    self._json_response(500, {"error": f"Embedding error: {embed_result.get('error')}"})
                    return

                query_embedding = embed_result.get('embedding', [])

                # Get document info for filenames (for multi-doc context)
                doc_info = {}
                if document_ids:
                    docs = supabase_get('pdf_documents', {'select': 'id,original_filename'})
                    doc_info = {d['id']: d.get('original_filename', 'Document') for d in (docs or [])}

                # Search for similar chunks - either per-doc or across all
                all_chunks = []

                if document_ids:
                    # Multi-doc: search each document and combine results
                    chunks_per_doc = max(3, 8 // len(document_ids))  # More chunks if fewer docs
                    for doc_id in document_ids:
                        search_params = {
                            'query_embedding': query_embedding,
                            'match_count': chunks_per_doc,
                            'filter_document_id': doc_id
                        }
                        chunks = supabase_rpc('search_pdf_chunks', search_params)
                        if chunks and not isinstance(chunks, dict):
                            for c in chunks:
                                c['doc_filename'] = doc_info.get(doc_id, 'Document')
                            all_chunks.extend(chunks)
                else:
                    # Search all documents
                    search_params = {
                        'query_embedding': query_embedding,
                        'match_count': 8
                    }
                    all_chunks = supabase_rpc('search_pdf_chunks', search_params) or []

                # Sort by similarity and take top results
                all_chunks = sorted(all_chunks, key=lambda x: x.get('similarity', 0), reverse=True)[:8]

                # Build context from similar chunks
                context_parts = []
                sources = []
                for chunk in all_chunks:
                    doc_name = chunk.get('doc_filename', 'Document')
                    page_num = chunk.get('page_number', '?')
                    content = chunk.get('content', '')

                    if len(document_ids) > 1:
                        context_parts.append(f"[{doc_name} - Page {page_num}]: {content}")
                    else:
                        context_parts.append(f"[Page {page_num}]: {content}")

                    sources.append({
                        'page_number': page_num,
                        'document_id': chunk.get('document_id'),
                        'document_name': doc_name,
                        'content': content[:200] + '...' if len(content) > 200 else content,
                        'similarity': chunk.get('similarity', 0)
                    })

                context = '\n\n'.join(context_parts)

                # Build prompt for LLM
                multi_doc_note = "from multiple documents" if len(document_ids) > 1 else "from the study guide"
                prompt = f"""You are an IGCSE Geography study assistant. Answer the question based on the following context {multi_doc_note}.

CONTEXT:
{context}

QUESTION: {question}

INSTRUCTIONS:
1. Answer based primarily on the context provided
2. If the context doesn't contain enough information, say so
3. Reference specific pages when relevant (e.g., "As mentioned on Page X..." or "In [document name], Page X...")
4. Keep the answer clear and suitable for IGCSE level students

ANSWER:"""

                # Call LLM
                if llm_provider == 'openai':
                    result = call_openai(llm_api_key, llm_model, prompt, max_tokens=1024)
                elif llm_provider == 'claude':
                    result = call_claude(llm_api_key, llm_model, prompt, max_tokens=1024)
                elif llm_provider == 'gemini':
                    result = call_gemini(llm_api_key, llm_model, prompt, max_tokens=1024)
                else:
                    result = call_openai(llm_api_key, llm_model, prompt, max_tokens=1024)

                if not result.get('success'):
                    self._json_response(500, {"error": f"LLM error: {result.get('error')}"})
                    return

                answer = result.get('content', '')

                self._json_response(200, {
                    "answer": answer,
                    "sources": sources
                })
                return

            except Exception as e:
                self._json_response(500, {"error": f"Chat error: {str(e)}"})
                return

        # Delete PDF document
        if '/pdf/delete' in path:
            doc_id = body.get('document_id')
            if not doc_id:
                self._json_response(400, {"error": "Missing document_id"})
                return

            # Delete chunks first
            supabase_delete('pdf_chunks', {'document_id': f'eq.{doc_id}'})
            # Delete document record
            supabase_delete('pdf_documents', {'id': f'eq.{doc_id}'})
            # Note: Storage file cleanup would need additional implementation

            self._json_response(200, {"success": True})
            return

        self._json_response(200, {"success": True})

    def do_PUT(self):
        # Handle PUT same as POST for settings
        self.do_POST()
