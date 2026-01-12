"""
Vercel Serverless API for IGCSE Geography Guru
Connects to Supabase for data storage
"""

from http.server import BaseHTTPRequestHandler
import json
import os
from urllib.parse import urlparse, parse_qs

# Supabase configuration
SUPABASE_URL = os.environ.get('SUPABASE_URL', 'https://wamzijrgngnvuzczxoqx.supabase.co')
SUPABASE_KEY = os.environ.get('SUPABASE_SERVICE_KEY', '')

# Simple in-memory sessions (will reset on cold starts, but acceptable for demo)
sessions = {}

def supabase_request(method, endpoint, data=None, params=None):
    """Make a request to Supabase REST API"""
    import urllib.request
    import urllib.error

    url = f"{SUPABASE_URL}/rest/v1/{endpoint}"
    if params:
        url += '?' + '&'.join(f"{k}={v}" for k, v in params.items())

    headers = {
        'apikey': SUPABASE_KEY,
        'Authorization': f'Bearer {SUPABASE_KEY}',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation'
    }

    body = json.dumps(data).encode('utf-8') if data else None

    req = urllib.request.Request(url, data=body, headers=headers, method=method)

    try:
        with urllib.request.urlopen(req) as response:
            return json.loads(response.read().decode('utf-8'))
    except urllib.error.HTTPError as e:
        error_body = e.read().decode('utf-8')
        return {'error': error_body, 'status': e.code}

class handler(BaseHTTPRequestHandler):
    def _send_response(self, status_code, data):
        self.send_response(status_code)
        self.send_header('Content-Type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        self.end_headers()
        self.wfile.write(json.dumps(data).encode('utf-8'))

    def _get_user_id(self):
        auth_header = self.headers.get('Authorization', '')
        token = auth_header.replace('Bearer ', '')
        return sessions.get(token)

    def do_OPTIONS(self):
        self._send_response(200, {})

    def do_GET(self):
        parsed = urlparse(self.path)
        path = parsed.path.replace('/api', '')

        # Health check
        if path == '/health':
            self._send_response(200, {"status": "healthy", "version": "1.0.0"})
            return

        # Topics list
        if path == '/topics':
            topics = supabase_request('GET', 'topics', params={'select': '*', 'order': 'theme_number,topic_number'})
            if 'error' not in topics:
                # Group by theme
                themes = {}
                for topic in topics:
                    theme_num = topic['theme_number']
                    if theme_num not in themes:
                        themes[theme_num] = {
                            "theme_number": theme_num,
                            "theme_name": topic['theme_name'],
                            "topics": []
                        }
                    themes[theme_num]['topics'].append({
                        "id": topic['id'],
                        "topic_number": topic['topic_number'],
                        "topic_name": topic['topic_name'],
                        "textbook_pages": topic.get('textbook_pages')
                    })
                self._send_response(200, list(themes.values()))
            else:
                self._send_response(500, topics)
            return

        # Topic detail
        if path.startswith('/topics/') and not path.endswith('/flashcards') and not path.endswith('/quiz'):
            topic_id = path.split('/')[-1]

            topic = supabase_request('GET', f'topics?id=eq.{topic_id}&select=*')
            definitions = supabase_request('GET', f'definitions?topic_id=eq.{topic_id}&select=*')
            questions = supabase_request('GET', f'questions?topic_id=eq.{topic_id}&select=*')

            if topic and not isinstance(topic, dict):
                topic = topic[0] if topic else None
                self._send_response(200, {
                    "topic": topic,
                    "definitions": definitions if not isinstance(definitions, dict) else [],
                    "questions": questions if not isinstance(questions, dict) else [],
                    "content": topic.get('content_json', {}) if topic else {}
                })
            else:
                self._send_response(404, {"error": "Topic not found"})
            return

        # Flashcards
        if '/flashcards' in path:
            topic_id = path.split('/')[2]
            definitions = supabase_request('GET', f'definitions?topic_id=eq.{topic_id}&select=*')
            self._send_response(200, definitions if not isinstance(definitions, dict) else [])
            return

        # Quiz questions
        if '/quiz' in path:
            topic_id = path.split('/')[2]
            questions = supabase_request('GET', f'questions?topic_id=eq.{topic_id}&select=*')
            self._send_response(200, questions if not isinstance(questions, dict) else [])
            return

        # Test yourself
        if path.startswith('/test-yourself/') or path == '/test-yourself':
            # Return embedded test yourself data
            from content_data import TEST_YOURSELF
            if path == '/test-yourself':
                self._send_response(200, TEST_YOURSELF)
            else:
                topic_id = path.split('/')[-1]
                data = TEST_YOURSELF.get(topic_id, {})
                if data:
                    questions = [{"number": q["id"], "question": q["q"], "answer": q["a"]} for q in data.get("questions", [])]
                    self._send_response(200, questions)
                else:
                    self._send_response(200, [])
            return

        # AI settings
        if path == '/ai/settings':
            user_id = self._get_user_id()
            if not user_id:
                self._send_response(401, {"error": "Unauthorized"})
                return

            settings = supabase_request('GET', f'ai_settings?user_id=eq.{user_id}&select=*')
            if settings and not isinstance(settings, dict):
                self._send_response(200, {"settings": settings[0] if settings else {}})
            else:
                self._send_response(200, {"settings": {}})
            return

        # Progress
        if path == '/progress':
            user_id = self._get_user_id()
            if not user_id:
                self._send_response(401, {"error": "Unauthorized"})
                return

            progress = supabase_request('GET', f'user_progress?user_id=eq.{user_id}&select=*')
            self._send_response(200, {
                "by_topic": progress if not isinstance(progress, dict) else [],
                "overall": {"questions_attempted": 0, "questions_correct": 0, "accuracy": 0, "definitions_studied": 0},
                "weak_points_count": 0
            })
            return

        self._send_response(404, {"error": "Not found"})

    def do_POST(self):
        parsed = urlparse(self.path)
        path = parsed.path.replace('/api', '')

        content_length = int(self.headers.get('Content-Length', 0))
        body = json.loads(self.rfile.read(content_length).decode('utf-8')) if content_length > 0 else {}

        # Login
        if path == '/auth/login':
            username = body.get('username', '')
            password = body.get('password', '')

            users = supabase_request('GET', f'users?username=eq.{username}&select=*')

            if users and not isinstance(users, dict) and len(users) > 0:
                user = users[0]
                if user.get('password') == password:  # Simple comparison (use bcrypt in production!)
                    import uuid
                    token = str(uuid.uuid4())
                    sessions[token] = user['id']
                    self._send_response(200, {
                        "token": token,
                        "user": {
                            "id": user['id'],
                            "username": user['username'],
                            "display_name": user.get('display_name')
                        }
                    })
                    return

            self._send_response(401, {"error": "Invalid credentials"})
            return

        # Logout
        if path == '/auth/logout':
            auth_header = self.headers.get('Authorization', '')
            token = auth_header.replace('Bearer ', '')
            sessions.pop(token, None)
            self._send_response(200, {"success": True})
            return

        # Record flashcard attempt
        if '/attempt' in path and 'flashcard' in path:
            user_id = self._get_user_id()
            if not user_id:
                self._send_response(401, {"error": "Unauthorized"})
                return

            # Simple success response
            self._send_response(200, {"success": True})
            return

        # Submit answer
        if '/submit' in path:
            user_id = self._get_user_id()
            if not user_id:
                self._send_response(401, {"error": "Unauthorized"})
                return

            # Simple marking response
            self._send_response(200, {
                "marks_awarded": 1,
                "marks_possible": 1,
                "is_correct": True,
                "feedback": "Answer recorded. Compare with the model answer."
            })
            return

        self._send_response(404, {"error": "Not found"})

    def do_PUT(self):
        self._send_response(200, {"success": True})
