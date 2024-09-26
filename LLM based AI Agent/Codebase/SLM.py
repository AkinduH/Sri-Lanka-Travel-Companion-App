from huggingface_hub import InferenceClient

client = InferenceClient(
    "mistralai/Mistral-7B-Instruct-v0.1",
    token="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",
)

for message in client.chat_completion(
	messages=[{"role": "user", "content": "Hi how are you?"}],
	max_tokens=500,
	stream=True,
):
    print(message.choices[0].delta.content, end="")
