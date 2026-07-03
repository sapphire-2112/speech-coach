import edge_tts

VOICE_MAP = {
    "American English": "en-US-AriaNeural",
    "British English": "en-GB-SoniaNeural",
    "Indian English": "en-IN-NeerjaNeural"
}


async def generate_audio(text, accent="American English", slow=False):

    voice = VOICE_MAP.get(
        accent,
        "en-US-AriaNeural"
    )

    rate = "-40%" if slow else "+0%"

    communicate = edge_tts.Communicate(
        text=text,
        voice=voice,
        rate=rate
    )

    await communicate.save("output.mp3")

    return "output.mp3"