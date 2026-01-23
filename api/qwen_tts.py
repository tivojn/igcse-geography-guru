"""
Qwen3-TTS Module for IGCSE Geography Guru
Based on vibevoice project implementation
https://dashscope-intl.aliyuncs.com/api/v1/services/aigc/text2audio/generation
"""

import base64
import struct
import io
import json
import urllib.request
import urllib.error

# Preset voices available for Qwen3-TTS
QWEN_PRESET_VOICES = [
    {"voice_id": "Cherry", "name": "Cherry", "description": "Female, Friendly", "language": "en"},
    {"voice_id": "Ethan", "name": "Ethan", "description": "Male, Standard", "language": "en"},
    {"voice_id": "Serena", "name": "Serena", "description": "Female, Professional", "language": "en"},
    {"voice_id": "Chelsie", "name": "Chelsie", "description": "Female, Warm", "language": "en"},
]


def pcm_to_wav(pcm_data: bytes, sample_rate: int = 24000) -> bytes:
    """Convert raw PCM audio data to WAV format."""
    wav_buffer = io.BytesIO()
    num_channels = 1
    sample_width = 2  # 16-bit

    # Write WAV header
    wav_buffer.write(b'RIFF')
    wav_buffer.write(struct.pack('<I', 36 + len(pcm_data)))
    wav_buffer.write(b'WAVE')
    wav_buffer.write(b'fmt ')
    wav_buffer.write(struct.pack('<I', 16))  # Subchunk1Size
    wav_buffer.write(struct.pack('<H', 1))   # AudioFormat (PCM)
    wav_buffer.write(struct.pack('<H', num_channels))
    wav_buffer.write(struct.pack('<I', sample_rate))
    wav_buffer.write(struct.pack('<I', sample_rate * num_channels * sample_width))  # ByteRate
    wav_buffer.write(struct.pack('<H', num_channels * sample_width))  # BlockAlign
    wav_buffer.write(struct.pack('<H', sample_width * 8))  # BitsPerSample
    wav_buffer.write(b'data')
    wav_buffer.write(struct.pack('<I', len(pcm_data)))
    wav_buffer.write(pcm_data)

    return wav_buffer.getvalue()


def validate_api_key(api_key: str) -> dict:
    """
    Validate an AliCloud API key by making a test request.
    Uses the voice customization list endpoint.
    """
    if not api_key or not api_key.strip():
        return {"valid": False, "error": "API key is empty"}

    url = "https://dashscope-intl.aliyuncs.com/api/v1/services/audio/tts/customization"
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }
    data = json.dumps({
        "model": "qwen-voice-design",
        "input": {
            "action": "list",
            "target_model": "qwen3-tts-vd-realtime-2025-12-16"
        }
    }).encode()

    try:
        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=15) as response:
            if response.status == 200:
                return {"valid": True, "message": "API key is valid!"}
            else:
                return {"valid": False, "error": f"HTTP {response.status}"}
    except urllib.error.HTTPError as e:
        if e.code == 401:
            return {"valid": False, "error": "Invalid API key"}
        else:
            error_body = e.read().decode('utf-8')[:200] if e.fp else f"HTTP {e.code}"
            return {"valid": False, "error": f"API error: {error_body}"}
    except urllib.error.URLError as e:
        return {"valid": False, "error": f"Connection error: {str(e)}"}
    except Exception as e:
        return {"valid": False, "error": str(e)}


def generate_tts(text: str, voice_id: str, api_key: str) -> dict:
    """
    Generate TTS audio using Qwen3-TTS.

    Args:
        text: The text to convert to speech
        voice_id: The voice ID (e.g., 'Cherry', 'Ethan', 'Serena', 'Chelsie')
        api_key: AliCloud DashScope API key

    Returns:
        dict with 'audio_base64' and 'format' on success, or 'error' on failure
    """
    if not text or not text.strip():
        return {"error": "No text provided"}

    if not api_key or not api_key.strip():
        return {"error": "No API key provided"}

    # Use Qwen3-TTS via multimodal-generation endpoint
    # Reference: https://www.alibabacloud.com/help/en/model-studio/qwen-tts
    url = "https://dashscope-intl.aliyuncs.com/api/v1/services/aigc/multimodal-generation/generation"
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }

    # Qwen3-TTS request format (official documentation)
    payload = {
        "model": "qwen3-tts-flash",
        "input": {
            "text": text,
            "voice": voice_id,
            "language_type": "English"
        }
    }

    data = json.dumps(payload).encode()

    try:
        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=60) as response:
            result = json.loads(response.read().decode('utf-8'))

            # Extract audio from response
            # API can return either a URL or base64 data
            output = result.get("output", {})
            audio_obj = output.get("audio", {})
            audio_url = audio_obj.get("url", "")
            audio_data_b64 = audio_obj.get("data", "")

            if audio_url:
                # Fetch audio from URL
                audio_req = urllib.request.Request(audio_url)
                with urllib.request.urlopen(audio_req, timeout=60) as audio_resp:
                    audio_bytes = audio_resp.read()
                    # Return as base64 (already in WAV/MP3 format from URL)
                    return {
                        "audio_base64": base64.b64encode(audio_bytes).decode('utf-8'),
                        "format": "wav"
                    }
            elif audio_data_b64:
                # Decode base64 PCM audio
                pcm_data = base64.b64decode(audio_data_b64)
                # Convert PCM to WAV
                wav_data = pcm_to_wav(pcm_data, sample_rate=24000)
                return {
                    "audio_base64": base64.b64encode(wav_data).decode('utf-8'),
                    "format": "wav"
                }
            else:
                return {"error": f"No audio in response: {json.dumps(result)[:500]}"}

    except urllib.error.HTTPError as e:
        error_body = ""
        try:
            error_body = e.read().decode('utf-8')[:500]
        except:
            error_body = f"HTTP {e.code}"
        return {"error": f"API error ({e.code}): {error_body}"}
    except urllib.error.URLError as e:
        return {"error": f"Connection error: {str(e)}"}
    except json.JSONDecodeError as e:
        return {"error": f"Invalid JSON response: {str(e)}"}
    except Exception as e:
        import traceback
        traceback.print_exc()
        return {"error": f"TTS generation failed: {str(e)}"}


def get_voices() -> list:
    """Get list of available preset voices."""
    return QWEN_PRESET_VOICES


def list_custom_voices(api_key: str) -> dict:
    """
    List all custom voices (designed and cloned) from AliCloud.

    Returns:
        dict with 'voices' list on success, or 'error' on failure
    """
    if not api_key or not api_key.strip():
        return {"error": "No API key provided"}

    url = "https://dashscope-intl.aliyuncs.com/api/v1/services/audio/tts/customization"
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }

    custom_voices = []

    # List designed voices
    try:
        data = json.dumps({
            "model": "qwen-voice-design",
            "input": {
                "action": "list",
                "target_model": "qwen3-tts-vd-realtime-2025-12-16"
            }
        }).encode()

        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=30) as response:
            result = json.loads(response.read().decode('utf-8'))
            voices = result.get("output", {}).get("voices", [])
            for v in voices:
                custom_voices.append({
                    "voice_id": v.get("voice", ""),
                    "name": v.get("voice", ""),
                    "description": f"Custom designed voice",
                    "language": v.get("language", "en"),
                    "voice_type": "designed",
                    "is_preset": False,
                    "created_at": v.get("created_at", "")
                })
    except Exception as e:
        print(f"[Qwen TTS] Error listing designed voices: {e}")

    # List cloned voices
    try:
        data = json.dumps({
            "model": "qwen-voice-enrollment",
            "input": {
                "action": "list",
                "target_model": "qwen3-tts-vc-realtime-2025-11-27"
            }
        }).encode()

        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=30) as response:
            result = json.loads(response.read().decode('utf-8'))
            voices = result.get("output", {}).get("voices", [])
            for v in voices:
                custom_voices.append({
                    "voice_id": v.get("voice", ""),
                    "name": v.get("voice", ""),
                    "description": f"Cloned voice",
                    "language": v.get("language", "en"),
                    "voice_type": "cloned",
                    "is_preset": False,
                    "created_at": v.get("created_at", "")
                })
    except Exception as e:
        print(f"[Qwen TTS] Error listing cloned voices: {e}")

    return {"voices": custom_voices}


def design_voice(voice_prompt: str, preferred_name: str, language: str, preview_text: str, api_key: str) -> dict:
    """
    Create a custom voice from a text description.

    Args:
        voice_prompt: Text description of desired voice characteristics
        preferred_name: Name for the custom voice (alphanumeric + underscore, max 16 chars)
        language: Target language (e.g., 'en', 'zh', 'ja')
        preview_text: Text to generate preview audio
        api_key: AliCloud DashScope API key

    Returns:
        dict with 'voice_id' and 'preview_audio' on success, or 'error' on failure
    """
    if not api_key or not api_key.strip():
        return {"error": "No API key provided"}

    if not voice_prompt or not voice_prompt.strip():
        return {"error": "Voice description is required"}

    # Sanitize preferred_name
    import re
    preferred_name = re.sub(r'[^a-zA-Z0-9_]', '', preferred_name)[:16] or 'custom_voice'

    url = "https://dashscope-intl.aliyuncs.com/api/v1/services/audio/tts/customization"
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }

    payload = {
        "model": "qwen-voice-design",
        "input": {
            "action": "create",
            "target_model": "qwen3-tts-vd-realtime-2025-12-16",
            "voice_prompt": voice_prompt,
            "preview_text": preview_text or "Hello, this is a preview of my new custom voice.",
            "preferred_name": preferred_name,
            "language": language or "en"
        },
        "parameters": {
            "sample_rate": 24000,
            "response_format": "mp3"
        }
    }

    data = json.dumps(payload).encode()

    try:
        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=120) as response:
            result = json.loads(response.read().decode('utf-8'))

            output = result.get("output", {})
            voice_id = output.get("voice", "")
            preview_audio = output.get("preview_audio", {})
            preview_data = preview_audio.get("data", "")

            if not voice_id:
                return {"error": f"No voice ID returned: {json.dumps(result)[:300]}"}

            return {
                "voice_id": voice_id,
                "preview_audio": preview_data,
                "format": "mp3"
            }

    except urllib.error.HTTPError as e:
        error_body = ""
        try:
            error_body = e.read().decode('utf-8')[:500]
        except:
            error_body = f"HTTP {e.code}"
        return {"error": f"API error ({e.code}): {error_body}"}
    except Exception as e:
        return {"error": f"Voice design failed: {str(e)}"}


def clone_voice(audio_base64: str, audio_format: str, preferred_name: str, language: str, api_key: str) -> dict:
    """
    Clone a voice from an audio sample.

    Args:
        audio_base64: Base64-encoded audio data
        audio_format: Audio format ('mp3', 'wav', or 'm4a')
        preferred_name: Name for the cloned voice (max 16 chars)
        language: Target language
        api_key: AliCloud DashScope API key

    Returns:
        dict with 'voice_id' on success, or 'error' on failure
    """
    if not api_key or not api_key.strip():
        return {"error": "No API key provided"}

    if not audio_base64:
        return {"error": "No audio provided"}

    # Sanitize preferred_name
    import re
    preferred_name = re.sub(r'[^a-zA-Z0-9_]', '', preferred_name)[:16] or 'cloned_voice'

    # Build data URI
    mime_types = {
        "mp3": "audio/mpeg",
        "wav": "audio/wav",
        "m4a": "audio/mp4",
    }
    mime_type = mime_types.get(audio_format.lower(), "audio/wav")
    data_uri = f"data:{mime_type};base64,{audio_base64}"

    url = "https://dashscope-intl.aliyuncs.com/api/v1/services/audio/tts/customization"
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }

    # Try multiple target models for compatibility
    target_models = [
        "qwen3-tts-vc-realtime-2025-11-27",
    ]

    for target_model in target_models:
        payload = {
            "model": "qwen-voice-enrollment",
            "input": {
                "action": "create",
                "target_model": target_model,
                "preferred_name": preferred_name,
                "audio": {
                    "data": data_uri
                }
            }
        }

        if language:
            payload["input"]["language"] = language

        data = json.dumps(payload).encode()

        try:
            req = urllib.request.Request(url, data=data, headers=headers, method='POST')
            with urllib.request.urlopen(req, timeout=120) as response:
                result = json.loads(response.read().decode('utf-8'))

                output = result.get("output", {})
                voice_id = output.get("voice", "")

                if voice_id:
                    return {"voice_id": voice_id}
                else:
                    return {"error": f"No voice ID returned: {json.dumps(result)[:300]}"}

        except urllib.error.HTTPError as e:
            error_body = ""
            try:
                error_body = e.read().decode('utf-8')[:500]
            except:
                error_body = f"HTTP {e.code}"
            # Continue to next model on error
            continue
        except Exception as e:
            continue

    return {"error": "Voice cloning failed with all target models"}


def delete_voice(voice_id: str, voice_type: str, api_key: str) -> dict:
    """
    Delete a custom voice.

    Args:
        voice_id: The voice ID to delete
        voice_type: 'designed' or 'cloned'
        api_key: AliCloud DashScope API key

    Returns:
        dict with 'success' on success, or 'error' on failure
    """
    if not api_key or not api_key.strip():
        return {"error": "No API key provided"}

    if not voice_id:
        return {"error": "No voice ID provided"}

    url = "https://dashscope-intl.aliyuncs.com/api/v1/services/audio/tts/customization"
    headers = {
        'Authorization': f'Bearer {api_key}',
        'Content-Type': 'application/json'
    }

    if voice_type == "cloned":
        model = "qwen-voice-enrollment"
        target_model = "qwen3-tts-vc-realtime-2025-11-27"
    else:
        model = "qwen-voice-design"
        target_model = "qwen3-tts-vd-realtime-2025-12-16"

    payload = {
        "model": model,
        "input": {
            "action": "delete",
            "target_model": target_model,
            "voice": voice_id
        }
    }

    data = json.dumps(payload).encode()

    try:
        req = urllib.request.Request(url, data=data, headers=headers, method='POST')
        with urllib.request.urlopen(req, timeout=30) as response:
            return {"success": True}

    except urllib.error.HTTPError as e:
        error_body = ""
        try:
            error_body = e.read().decode('utf-8')[:500]
        except:
            error_body = f"HTTP {e.code}"
        return {"error": f"Delete failed ({e.code}): {error_body}"}
    except Exception as e:
        return {"error": f"Delete failed: {str(e)}"}


def generate_tts_custom_voice(text: str, voice_id: str, voice_type: str, api_key: str) -> dict:
    """
    Generate TTS using a custom (designed or cloned) voice.
    Uses WebSocket Realtime API (OpenAI-compatible protocol).
    Based on vibevoice implementation.
    """
    if not text or not text.strip():
        return {"error": "No text provided"}

    if not api_key or not api_key.strip():
        return {"error": "No API key provided"}

    try:
        import websocket
        import ssl
        import threading
    except ImportError:
        return {"error": "websocket-client not installed. Run: pip install websocket-client"}

    # Choose model based on voice type
    if voice_type == "cloned":
        model = "qwen3-tts-vc-realtime-2025-11-27"
    else:
        model = "qwen3-tts-vd-realtime-2025-12-16"

    # WebSocket URL with model as query param (vibevoice format)
    ws_url = f"wss://dashscope-intl.aliyuncs.com/api-ws/v1/realtime?model={model}"

    audio_chunks = []
    error_msg = [None]
    done_event = threading.Event()
    state = {"phase": "connecting"}

    def on_message(ws, message):
        try:
            data = json.loads(message)
            event_type = data.get("type", "")

            if event_type == "session.created":
                state["phase"] = "session_created"
                # Send session.update with voice settings
                ws.send(json.dumps({
                    "type": "session.update",
                    "session": {
                        "voice": voice_id,
                        "response_format": "pcm",
                        "sample_rate": 24000,
                        "mode": "server_commit"
                    }
                }))

            elif event_type == "session.updated":
                state["phase"] = "session_updated"
                # Send the text input
                ws.send(json.dumps({
                    "type": "input_text_buffer.append",
                    "text": text
                }))
                # Commit the input
                ws.send(json.dumps({
                    "type": "input_text_buffer.commit"
                }))

            elif event_type == "response.audio.delta":
                # Decode and collect audio chunk
                audio_data = data.get("delta", "")
                if audio_data:
                    audio_chunks.append(base64.b64decode(audio_data))

            elif event_type == "response.audio.done":
                done_event.set()

            elif event_type == "session.finished":
                done_event.set()

            elif event_type == "error":
                error_info = data.get("error", {})
                error_msg[0] = error_info.get("message", f"Unknown error: {data}")
                done_event.set()

        except Exception as e:
            error_msg[0] = f"Message parse error: {str(e)}"
            done_event.set()

    def on_error(ws, error):
        error_msg[0] = str(error)
        done_event.set()

    def on_close(ws, close_status_code, close_msg):
        done_event.set()

    def on_open(ws):
        state["phase"] = "connected"
        # Wait for session.created message from server

    # Create WebSocket with auth header
    ws = websocket.WebSocketApp(
        ws_url,
        header=[f"Authorization: Bearer {api_key}"],
        on_open=on_open,
        on_message=on_message,
        on_error=on_error,
        on_close=on_close
    )

    # Run in thread with timeout
    ws_thread = threading.Thread(
        target=lambda: ws.run_forever(sslopt={"cert_reqs": ssl.CERT_NONE})
    )
    ws_thread.daemon = True
    ws_thread.start()

    # Wait for completion (max 60 seconds)
    done_event.wait(timeout=60)
    ws.close()

    if error_msg[0]:
        return {"error": f"TTS error: {error_msg[0]}"}

    if not audio_chunks:
        return {"error": f"No audio received. State: {state['phase']}"}

    # Combine audio chunks (PCM data)
    pcm_data = b"".join(audio_chunks)

    # Convert PCM to WAV
    wav_data = pcm_to_wav(pcm_data, sample_rate=24000)

    return {
        "audio_base64": base64.b64encode(wav_data).decode('utf-8'),
        "format": "wav"
    }


# For testing
if __name__ == "__main__":
    import sys

    if len(sys.argv) < 3:
        print("Usage: python qwen_tts.py <api_key> <text> [voice]")
        print("Voices: Cherry, Ethan, Serena, Chelsie")
        sys.exit(1)

    api_key = sys.argv[1]
    text = sys.argv[2]
    voice = sys.argv[3] if len(sys.argv) > 3 else "Cherry"

    print(f"Generating TTS for: '{text}' with voice: {voice}")

    result = generate_tts(text, voice, api_key)

    if "error" in result:
        print(f"Error: {result['error']}")
        sys.exit(1)

    # Save to file
    audio_data = base64.b64decode(result["audio_base64"])
    output_file = "test_output.wav"
    with open(output_file, "wb") as f:
        f.write(audio_data)
    print(f"Audio saved to {output_file}")
