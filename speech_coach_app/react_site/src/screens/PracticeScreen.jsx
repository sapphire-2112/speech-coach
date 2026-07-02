import { useState, useRef } from 'react';
import { useNavigate } from 'react-router-dom';
import { LEVELS } from '../data/levels';
import './PracticeScreen.css';

export default function PracticeScreen() {
  const navigate = useNavigate();
  const [levelIndex, setLevelIndex] = useState(0);
  const [itemIndex, setItemIndex] = useState(0);
  
  const currentLevel = LEVELS[levelIndex];
  const targetText = currentLevel.items[itemIndex];
  
  const [isRecording, setIsRecording] = useState(false);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState(null);
  
  const mediaRecorder = useRef(null);
  const audioChunks = useRef([]);

  const startRecording = async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      mediaRecorder.current = new MediaRecorder(stream);
      audioChunks.current = [];

      mediaRecorder.current.ondataavailable = (event) => {
        audioChunks.current.push(event.data);
      };

      mediaRecorder.current.onstop = async () => {
        const audioBlob = new Blob(audioChunks.current, { type: 'audio/wav' });
        await sendAudioToBackend(audioBlob);
      };

      mediaRecorder.current.start();
      setIsRecording(true);
      setResult(null);
    } catch (error) {
      alert("Microphone permission denied or not available!");
    }
  };

  const stopRecording = () => {
    if (mediaRecorder.current && isRecording) {
      mediaRecorder.current.stop();
      setIsRecording(false);
      mediaRecorder.current.stream.getTracks().forEach(track => track.stop());
    }
  };

  const sendAudioToBackend = async (audioBlob) => {
    setLoading(true);
    const formData = new FormData();
    formData.append('audio', audioBlob, 'input.wav');

    // Remove punctuation from the URL parameter to avoid backend routing errors
    const safeTarget = targetText.replace(/[^a-zA-Z ]/g, "").replace(/\s+/g, "_");

    try {
      const apiBase = import.meta.env.VITE_API_URL || '/api';
      const response = await fetch(`${apiBase}/check/${safeTarget}`, {
        method: 'POST',
        body: formData,
      });

      if (!response.ok) throw new Error("Backend error");
      
      const data = await response.json();
      setResult(data);
    } catch (error) {
      console.error(error);
      alert("Failed to analyze audio. Ensure the backend is running.");
    } finally {
      setLoading(false);
    }
  };

  const handleNext = () => {
    if (itemIndex < currentLevel.items.length - 1) {
      setItemIndex(itemIndex + 1);
    } else if (levelIndex < LEVELS.length - 1) {
      // Level up!
      setLevelIndex(levelIndex + 1);
      setItemIndex(0);
      alert(`🎉 Level Up! Welcome to ${LEVELS[levelIndex + 1].title}`);
    } else {
      alert("🏆 You have completed all levels!");
    }
    setResult(null);
  };

  return (
    <div className="practice-screen">
      <header className="practice-header">
        <button className="back-btn" onClick={() => navigate('/home')}>← Back</button>
        <div className="level-badge">{currentLevel.title}</div>
      </header>

      <main className="practice-main">
        <div className="instruction-box">
          <h2>Tap the mic and say:</h2>
          <h1 className={currentLevel.type === 'paragraph' ? "target-paragraph" : "target-word"}>
            "{targetText}"
          </h1>
        </div>

        {/* Gamified Recording Button */}
        <div className="mic-container">
          <button 
            className={`mic-button ${isRecording ? 'recording' : ''}`}
            onMouseDown={startRecording}
            onMouseUp={stopRecording}
            onTouchStart={startRecording}
            onTouchEnd={stopRecording}
          >
            🎤
          </button>
          <p className="mic-hint">
            {isRecording ? "Release to Send..." : "Hold to Record"}
          </p>
        </div>

        {/* Loading State */}
        {loading && (
          <div className="loading-state">
            <div className="spinner"></div>
            <p>Analyzing your Indian accent perfectly... 🧠</p>
          </div>
        )}

        {/* Result Card */}
        {result && !loading && (
          <div className="result-card fade-in">
            <div className="score-circle">
              <h2>{Math.round(result.score * 100)}%</h2>
              <span>Accuracy</span>
            </div>
            
            <div className="feedback-section">
              <h3>Feedback</h3>
              <p>{result.feedback}</p>
            </div>

            <div className="phonemes-breakdown">
              <h3>What we heard:</h3>
              <div className="pills">
                {result.spoken.map((sound, i) => (
                  <span key={i} className="phoneme-pill">
                    {sound}
                  </span>
                ))}
              </div>
            </div>

            <button className="next-word-btn" onClick={handleNext}>
              {itemIndex < currentLevel.items.length - 1 ? 'Next Challenge 🚀' : 'Next Level 🌟'}
            </button>
          </div>
        )}
      </main>
    </div>
  );
}
