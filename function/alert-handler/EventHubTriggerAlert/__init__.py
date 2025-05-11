import os
import requests

def process_event(data):
    payload = {
        "deviceId": data.get("DeviceId", "unknown"),
        "temperature": data.get("Temperature"),
    }

    logic_app_url = os.environ.get("LOGICAPP_ENDPOINT")
    if not logic_app_url:
        print("❌ LOGICAPP_ENDPOINT is not set.")
        return

    try:
        response = requests.post(logic_app_url, json=payload)
        response.raise_for_status()
        print(f"✅ Sent to Logic App: {response.status_code}")
    except Exception as e:
        print(f"❌ Failed to call Logic App: {e}")

