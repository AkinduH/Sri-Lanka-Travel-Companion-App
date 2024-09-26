import os
from huggingface_hub import InferenceClient
from dotenv import load_dotenv

load_dotenv()

client = InferenceClient(
    "mistralai/Mistral-7B-Instruct-v0.1",
    token=os.getenv("HuggingFace_API_KEY"),
)

for message in client.chat_completion(
	messages=[{"role": "user", "content": "Hi how are you?"}],
	max_tokens=500,
	stream=True,
):
    print(message.choices[0].delta.content, end="")
