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

# In-memory sessions (resets on cold start)
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
    except Exception as e:
        return {"_error": str(e), "_url": url, "_has_key": bool(SUPABASE_KEY)}

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

    def do_OPTIONS(self):
        self.send_response(200)
        self._cors_headers()
        self.end_headers()

    def do_GET(self):
        path = self.path.replace('/api', '').split('?')[0]

        # Health check
        if path in ['/', '/health']:
            self._json_response(200, {"status": "healthy"})
            return

        # Topics list
        if path == '/topics':
            topics = supabase_get('topics', {'select': '*', 'order': 'theme_number,topic_number'})
            if isinstance(topics, dict) and '_error' in topics:
                self._json_response(200, topics)  # Return debug info
                return
            themes = {}
            for t in topics:
                n = t['theme_number']
                if n not in themes:
                    themes[n] = {"theme_number": n, "theme_name": t['theme_name'], "topics": []}
                themes[n]['topics'].append({"id": t['id'], "topic_number": t['topic_number'],
                    "topic_name": t['topic_name'], "textbook_pages": t.get('textbook_pages')})
            self._json_response(200, list(themes.values()))
            return

        # Topic detail
        if path.startswith('/topics/') and not any(x in path for x in ['/flashcards', '/quiz', '/test']):
            topic_id = path.split('/')[-1]
            topics = supabase_get('topics', {'id': f'eq.{topic_id}'})
            defs = supabase_get('definitions', {'topic_id': f'eq.{topic_id}'})
            questions = supabase_get('questions', {'topic_id': f'eq.{topic_id}'})
            topic = topics[0] if topics else None
            self._json_response(200, {"topic": topic, "definitions": defs, "questions": questions, "content": {}})
            return

        # Flashcards
        if '/flashcards' in path:
            topic_id = path.split('/')[2]
            defs = supabase_get('definitions', {'topic_id': f'eq.{topic_id}'})
            self._json_response(200, defs)
            return

        # Quiz
        if '/quiz' in path:
            topic_id = path.split('/')[2]
            questions = supabase_get('questions', {'topic_id': f'eq.{topic_id}'})
            self._json_response(200, questions)
            return

        # Test yourself
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

        # AI settings
        if '/ai/settings' in path:
            self._json_response(200, {"settings": {}})
            return

        # Progress
        if path == '/progress':
            self._json_response(200, {"by_topic": [], "overall": {"questions_attempted": 0, "questions_correct": 0, "accuracy": 0}, "weak_points_count": 0})
            return

        self._json_response(404, {"error": "Not found"})

    def do_POST(self):
        path = self.path.replace('/api', '').split('?')[0]

        content_length = int(self.headers.get('Content-Length', 0))
        body = json.loads(self.rfile.read(content_length).decode('utf-8')) if content_length > 0 else {}

        # Login
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

        # Logout
        if '/auth/logout' in path:
            self._json_response(200, {"success": True})
            return

        # Default for other POST endpoints
        self._json_response(200, {"success": True})
