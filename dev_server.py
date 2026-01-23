#!/usr/bin/env python3
"""
Simple dev server that serves both static files and the API
"""
from http.server import HTTPServer, SimpleHTTPRequestHandler
import sys
import os
import io

# Add api directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Load environment variables from .env.local
def load_env():
    env_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), '.env.local')
    if os.path.exists(env_file):
        with open(env_file) as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    os.environ[key.strip()] = value.strip().strip('"').strip("'")
        print(f"Loaded environment from {env_file}")

load_env()

class DevHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        # Serve from public directory
        super().__init__(*args, directory='public', **kwargs)

    def _handle_api(self, method):
        # Import here to avoid circular imports
        from api.index import handler as APIHandler

        # Create a new handler instance for this request
        # We need to re-set the path without /api prefix
        original_path = self.path
        self.path = self.path[4:]  # Remove /api prefix

        # Create handler and call method
        try:
            # The BaseHTTPRequestHandler expects to be initialized differently
            # So we'll just call the methods directly on ourselves after patching
            # Import the handler class and create instance

            # Trick: create handler that shares our connection
            class ProxyHandler(APIHandler):
                pass

            proxy = ProxyHandler.__new__(ProxyHandler)
            proxy.request = self.request
            proxy.client_address = self.client_address
            proxy.server = self.server
            proxy.requestline = self.requestline
            proxy.command = self.command
            proxy.path = self.path
            proxy.request_version = self.request_version
            proxy.headers = self.headers
            proxy.rfile = self.rfile
            proxy.wfile = self.wfile
            proxy.close_connection = True

            if method == 'GET':
                proxy.do_GET()
            elif method == 'POST':
                proxy.do_POST()
            elif method == 'PUT':
                proxy.do_PUT()
            elif method == 'DELETE':
                proxy.do_DELETE()
        except Exception as e:
            import traceback
            print(f"API Error: {traceback.format_exc()}")
            self.send_error(500, f"API Error: {str(e)}")

    def do_GET(self):
        if self.path.startswith('/api/'):
            self._handle_api('GET')
        else:
            super().do_GET()

    def do_POST(self):
        if self.path.startswith('/api/'):
            self._handle_api('POST')
        else:
            self.send_error(405, "POST not allowed for static files")

    def do_PUT(self):
        if self.path.startswith('/api/'):
            self._handle_api('PUT')
        else:
            self.send_error(405, "PUT not allowed for static files")

    def do_DELETE(self):
        if self.path.startswith('/api/'):
            self._handle_api('DELETE')
        else:
            self.send_error(405, "DELETE not allowed for static files")

if __name__ == '__main__':
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 3456

    # Kill any existing server on this port
    os.system(f'lsof -ti:{port} | xargs kill 2>/dev/null')

    print(f"Starting dev server on http://localhost:{port}")
    print("Press Ctrl+C to stop")

    server = HTTPServer(('localhost', port), DevHandler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nShutting down...")
        server.shutdown()
