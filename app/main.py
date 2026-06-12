from fastapi import FastAPI, UploadFile, File

from app.services.cmu_service import get_phonemes
from app.phonemes.cmu_map import CMU_TO_INTERNAL
from app.core.normalizer import normalize
from app.core.comparator import compare
from app.core.scorer import score
from app.core.feedback import generate_feedback
from app.services.recognizer import recognize_audio
from app.phonemes.word_dict import WORD_DICT
from app.core.matcher import find_best_match
from app.services.whisper_service import transcribe
from app.services.translator import translate_to_english
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles

import shutil

app = FastAPI()
app.mount(
    "/static",
    StaticFiles(directory="static"),
    name="static"
)
@app.get("/", response_class=HTMLResponse)
def home():

    with open(
        "templates/index.html",
        "r"
    ) as f:
        return f.read()


@app.post("/translate")
async def translate_audio(audio: UploadFile = File(...)):

    file_path = "input.wav"

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(audio.file, buffer)

    transcript = transcribe(file_path)

    translation = translate_to_english(transcript)

    return {
        "transcript": transcript,
        "translation": translation
    }


@app.post("/check/{word}")
async def check(word: str, audio: UploadFile = File(...)):

    
    print("CHECK ENDPOINT HIT")

    # Step 1: save uploaded audio file
    file_path = "input.wav"
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(audio.file, buffer)

    print("FILE SAVED:", file_path)

    # Step 2: convert audio → phonemes
    from app.core.spoken_normalizer import normalize_spoken

    print("CALLING RECOGNIZER...")
    spoken_raw = recognize_audio(file_path)
    print("RAW SPOKEN:", spoken_raw)

    spoken = normalize_spoken(spoken_raw)
    print("NORMALIZED SPOKEN:", spoken)

    # Step 3: get expected phonemes (from test dict or fallback)
    target = word.lower()
    if target in WORD_DICT:
        expected = WORD_DICT[target]
        print("FOUND IN WORD_DICT:", expected)
    else:
        expected_cmu = get_phonemes(word)
        expected = normalize(expected_cmu, CMU_TO_INTERNAL)
        print("FALLBACK TO CMU:", expected)

    # Step 4: compare exact match
    results = compare(expected, spoken)

    # Step 5: score
    sc = score(results)

    # Step 6: feedback
    fb = generate_feedback(results)

    return {
        "expected_word": target,
        "detected_word": target,
        "spoken": spoken,
        "score": sc,
        "feedback": fb
    }