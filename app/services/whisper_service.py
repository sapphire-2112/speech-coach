from faster_whisper import WhisperModel

WhisperModel("small", compute_type="int8")
def transcribe(audio_path):

    segments, info = model.transcribe(
    audio_path,
    language="hi",
    task="transcribe"
)

    print("Language:", info.language)
    print("Language Probability:", info.language_probability)

    texts = []

    for seg in segments:
        print("SEGMENT:", seg.text)
        texts.append(seg.text)

    return " ".join(texts)