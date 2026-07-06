from fastapi import FastAPI, UploadFile, File, Query
from fastapi.middleware.cors import CORSMiddleware

from app.services.cmu_service import get_phonemes
from app.phonemes.cmu_map import CMU_TO_INTERNAL
from app.core.normalizer import normalize
from app.core.comparator import compare
from app.core.scorer import score, score_breakdown
from app.core.feedback import generate_feedback
from app.services.recognizer import recognize_audio
from app.phonemes.word_dict import WORD_DICT
from app.core.matcher import find_best_match

import shutil

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def root():
    return {"message": "Pronunciation Engine Running"}

@app.post("/check/{word}")
async def check(
    word: str,
    audio: UploadFile = File(...),
    accent: str = Query(default="indian", pattern="^(indian|auto|neutral)$")
):
    
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

    # Step 4: compare sounds with Indian-speaker-aware tolerance
    results = compare(expected, spoken, accent=accent)

    # Step 5: score on a 0-100 scale with vowel/consonant weighting
    sc = score(results)
    breakdown = score_breakdown(results)

    # Step 6: feedback with mistakes and improvement drills
    fb = generate_feedback(results, sc)

    return {
        "expected_word": target,
        "detected_word": target,
        "expected_phonemes": expected,
        "spoken_phonemes": spoken,
        "comparison": results,
        "score": sc,
        "score_breakdown": breakdown,
        "feedback": fb["feedback"],
        "summary": fb["summary"],
        "mistakes": fb["mistakes"],
        "improvements": fb["improvements"],
        "accent_used": accent,
    }
