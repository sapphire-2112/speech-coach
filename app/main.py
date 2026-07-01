from fastapi import FastAPI, UploadFile, File, Form
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
from app.services.gemini_service import translate_to_english
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from app.services.tts_service import generate_audio
import time
from app.services.grammar_service import get_random_sentence
from app.services.grammar_checker import check_grammar
from app.services.grammar_service import get_sentence_by_id
import shutil
from fastapi import Request
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse
templates = Jinja2Templates(directory="templates")
app = FastAPI()
app.mount(
    "/static",
    StaticFiles(directory="static"),
    name="static"
)

@app.get("/grammar", response_class=HTMLResponse)
async def grammar_page(request: Request):
    return templates.TemplateResponse(
        request=request,
        name="grammar.html",
        context={}
    )

@app.get("/", response_class=HTMLResponse)
def home():

    with open(
        "templates/index.html",
        "r"
    ) as f:
        return f.read()
    

@app.post("/grammar/check")
async def grammar_check(
    level: str = Form(...),
    sentence_id: int = Form(...),
    audio: UploadFile = File(...)
):

    file_path = "grammar.wav"

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(audio.file, buffer)

    spoken = transcribe(file_path)

    sentence = get_sentence_by_id(level, sentence_id)

    correct = sentence["correct"]

    result = check_grammar(correct, spoken)

    return result


@app.post("/translate")
async def translate_audio(audio: UploadFile = File(...)):

    file_path = "input.wav"

    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(audio.file, buffer)

    transcript = transcribe(file_path)

    translation = translate_to_english(transcript)

    print(type(translation))
    print(translation)  

    await generate_audio(translation)

    start=time.time()
    transcript = transcribe(file_path)
    print("Whisper:", time.time() - start)
    start = time.time()
    translation = translate_to_english(transcript)
    print("Translation:", time.time() - start)
    start = time.time()
    await generate_audio(translation)
    print("TTS:", time.time() - start)

    return {
        "transcript": transcript,
        "translation": translation
    }

@app.get("/grammar/{level}")
async def grammar(level: str):

    sentence = get_random_sentence(level)

    return {
        "id": sentence["id"],
        "scenario": sentence["scenario"],
        "wrong": sentence["wrong"]
    }

@app.get("/audio")
async def audio():

    return FileResponse(
        "output.mp3",
        media_type="audio/mpeg"
    )


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