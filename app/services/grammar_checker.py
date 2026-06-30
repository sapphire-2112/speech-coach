import os
import json

from dotenv import load_dotenv
from google import genai

load_dotenv()

client = genai.Client(
    api_key=os.getenv("API")
)
PROMPT = """
You are an English Grammar Evaluator.

Expected sentence:
{correct}

Student sentence:
{spoken}

Compare them.

Return ONLY valid JSON.

{{
    "score": 0,
    "feedback": [
        "...",
        "...",
        "..."
    ]
}}
"""

def check_grammar(correct, spoken):

    prompt = PROMPT.format(
        correct=correct,
        spoken=spoken
    )

    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=prompt
    )

    print("========== RAW RESPONSE ==========")
    print(response)
    print("========== TEXT ==========")
    print(response.text)

    return response.text

if __name__ == "__main__":

    result = check_grammar(

        "She goes to school every day.",

        "She go to school every day."
    )

    print(result)