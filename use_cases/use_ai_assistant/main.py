import os
from openai import OpenAI
from dotenv import load_dotenv

# Load the .env file
load_dotenv()
api_key = os.getenv("OPENAI_API_KEY")

# Create the OpenAI client
client = OpenAI(api_key=api_key)

END_QUESTION_TOKEN = "f5ta3$@a"
TRAINING_FILE = "use_cases/use_ai_assistant/training_data.txt"

# Load training data once at startup
if os.path.exists(TRAINING_FILE):
    with open(TRAINING_FILE, "r", encoding="utf-8") as f:
        training_data = f.read().strip()
else:
    training_data = ""


def get_multiline_input(end_token=END_QUESTION_TOKEN):
    print(f"Enter your question. This question can be multi-line")
    print(f"To submit your question, copy and paste the token on a new line")
    print(f"Enter just the token with no question to stop using AI Assistant")
    print(f"Token:")
    print(f"{end_token}")
    print(f"")

    lines = []
    while True:
        line = input()
        if line.strip() == end_token:
            break
        lines.append(line)
    return "\n".join(lines).strip()


# REPL loop for follow-up questions
while True:
    user_input = get_multiline_input()

    # Exit if input is blank (only end token was submitted)
    if user_input == "":
        print("Goodbye!")
        break

    if user_input.lower() in ["exit", "quit"]:
        print("Exiting.")
        break

    # Combine training data + user input
    full_prompt = f"{training_data}\n\nUser question:\n{user_input}"

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[{"role": "user", "content": full_prompt}],
        temperature=1.0,
        max_tokens=1000
    )

    gpt_response = response.choices[0].message.content

    print("\n--- GPT Response ---")
    print(gpt_response)
    print("\n---------------------\n")

    # Append new Q&A to training_data.txt
    with open(TRAINING_FILE, "a", encoding="utf-8") as f:
        f.write(f"\n\nUser question:\n{user_input}\n\nGPT response:\n{gpt_response}\n")

    # Keep training_data in memory updated
    training_data += f"\n\nUser question:\n{user_input}\n\nGPT response:\n{gpt_response}\n"
