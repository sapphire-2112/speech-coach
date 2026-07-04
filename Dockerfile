FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsndfile1 \
    espeak-ng \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Optional: pre-download Wav2Vec model
RUN python -c "from transformers import Wav2Vec2Processor, Wav2Vec2ForCTC; \
MODEL='facebook/wav2vec2-xlsr-53-espeak-cv-ft'; \
Wav2Vec2Processor.from_pretrained(MODEL); \
Wav2Vec2ForCTC.from_pretrained(MODEL)"

COPY . .

EXPOSE 7860

CMD ["uvicorn","app.main:app","--host","0.0.0.0","--port","7860"]