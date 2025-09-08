import os
from openai import OpenAI
from dotenv import load_dotenv

# Load the .env file
load_dotenv()
api_key = os.getenv("OPENAI_API_KEY")

# Create the OpenAI client
client = OpenAI(api_key=api_key)

END_QUESTION_TOKEN = "f5ta3$@a"

# Load training data once at startup
with open("./use_cases/use_ai_assistant/training_data.txt", "r", encoding="utf-8") as f:
    training_data = f.read().strip()


def get_multiline_input(end_token=END_QUESTION_TOKEN):
    print(f"Enter your question (end with the following token on a new line, ")
    print(f"Enter just the token with no question to escape main.py):")
    print(f"Token:")
    print(f"{end_token}")
    print(f"============================================")

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
        print("Blank input detected. Exiting to CMD.")
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

    print("\n--- GPT Response ---")
    print(response.choices[0].message.content)
    print("\n---------------------\n")
