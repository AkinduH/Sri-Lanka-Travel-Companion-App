from speechmatics.models import ConnectionSettings, BatchTranscriptionConfig
from speechmatics.batch_client import BatchClient
from httpx import HTTPStatusError
import os
from dotenv import load_dotenv

load_dotenv()

API_KEY = os.getenv("SPEECHMATICS_API_KEY")
PATH_TO_FILE = "C:/Users/Akindu Himan/OneDrive/Documents/Sound Recordings/Recording.m4a"
LANGUAGE = "en"

# Open the client using a context manager
with BatchClient(API_KEY) as client:
    try:
        job_id = client.submit_job(PATH_TO_FILE, BatchTranscriptionConfig(LANGUAGE))
        print(f'job {job_id} submitted successfully, waiting for transcript')

        # Note that in production, you should set up notifications instead of polling.
        # Notifications are described here: https://docs.speechmatics.com/features-other/notifications
        transcript = client.wait_for_completion(job_id, transcription_format='txt')
        # To see the full output, try setting transcription_format='json-v2'.
        print(transcript)
    except HTTPStatusError as e:
        if e.response.status_code == 401:
            print('Invalid API key - Check your API_KEY at the top of the code!')
        elif e.response.status_code == 400:
            print(e.response.json()['detail'])
        else:
            raise e