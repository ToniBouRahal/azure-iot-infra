import azure.functions as func
from EventHubTriggerAlert import process_event as handler
import json
import logging

app = func.FunctionApp()

@app.function_name(name="EventHubTriggerAlert")
@app.event_hub_message_trigger(
    arg_name="event",
    event_hub_name="telemetry-events",
    connection="EVENTHUB_CONNECTION",
    cardinality="one",
    # consumer_group="functioncg"
)
def eventhub_trigger(event: func.EventHubEvent):
    try:
        data = json.loads(event.get_body().decode("utf-8"))
        handler(data)
    except Exception as e:
        logging.error(f"⚠️ Failed to process message: {str(e)}")
