from speechmatics.models import BatchTranscriptionConfig
from speechmatics.batch_client import BatchClient
from httpx import HTTPStatusError
import os
from dotenv import load_dotenv
import time

from speechmatics.models import *
import speechmatics

load_dotenv()

API_KEY = os.getenv("SPEECHMATICS_API_KEY")
PATH_TO_FILE = "C:/Users/Akindu Himan/OneDrive/Documents/Sound Recordings/Recording.m4a"
LANGUAGE = "en"
        
# Create a transcription client from config defaults
sm_client = speechmatics.client.WebsocketClient(API_KEY)

last_transcript = ""

def handle_final_transcript(message):
    global last_transcript
    last_transcript = message['metadata']['transcript']
    print("Final:", last_transcript)


sm_client.add_event_handler(
    event_name=ServerMessageType.AddTranscript,
    event_handler=handle_final_transcript,
)

conf = TranscriptionConfig(
    language=LANGUAGE, enable_partials=True, max_delay=5, enable_entities=True,
)

start_time = time.time()

with open(PATH_TO_FILE, "rb") as fd:
    try:
        sm_client.run_synchronously(fd, conf)
    except KeyboardInterrupt:
        print("\nTranscription stopped.")

end_time = time.time()
process_duration = end_time - start_time
print(f"Process duration: {process_duration:.2f} seconds")





# # Open the client using a context manager
# with BatchClient(API_KEY) as client:
#     try:
#         job_id = client.submit_job(PATH_TO_FILE, BatchTranscriptionConfig(LANGUAGE))
#         print(f'job {job_id} submitted successfully, waiting for transcript')

#         # Reduce polling interval to check for completion more frequently
#         transcript = client.wait_for_completion(job_id, transcription_format='txt')
#         print(transcript)
#     except HTTPStatusError as e:
#         if e.response.status_code == 401:
#             print('Invalid API key - Check your API_KEY at the top of the code!')
#         elif e.response.status_code == 400:
#             print(e.response.json()['detail'])
#         else:
#             raise e