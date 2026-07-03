import os

from dotenv import load_dotenv
from google import genai

load_dotenv()

client = genai.Client(
    api_key=os.getenv("API")
)

PROMPT = """
You are an English speaking coach.

The user speaks Hindi or Hinglish.

The transcript may contain speech recognition mistakes.

Your task:
- Convert the transcript into fluent, natural English.
- Write the sentence in {accent} English.

Rules:
- Preserve names of people.
- Preserve software names.
- Preserve anime, movie and book titles.
- Preserve company and brand names.
- Preserve technical terms.
- Keep the original meaning.
- Do not explain anything.
- Return ONLY the final English sentence.
"""

def translate_to_english(text: str, accent: str):

    prompt = PROMPT.format(
        accent=accent
    )

    response = client.models.generate_content(
        model="gemini-2.5-flash",
        contents=f"{prompt}\n\nTranscript:\n{text}"
    )

    return response.text.strip()