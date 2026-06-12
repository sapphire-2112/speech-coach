from faster_whisper import WhisperModel

model = WhisperModel("small", compute_type="int8")

segments, info = model.transcribe(
    "test.wav",
    language="hi",
    task="transcribe"
)

print("Language:", info.language)

for seg in segments:
    print(seg.text)