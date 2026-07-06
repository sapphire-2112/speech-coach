import { useEffect, useMemo, useRef, useState } from 'react';
import { API_BASE, checkPronunciation } from './api.js';
import { AudioRecorder } from './audio.js';
import { loadSession, signInUser, signOutUser } from './auth.js';
import { allLevels, getLevel, levelGroups, PASS_SCORE } from './levels.js';
import { isUnlocked, loadProgressForUser, saveAttempt } from './progress.js';

const TOOL_TABS = ['translate', 'grammar'];

export default function App() {
  const [user, setUser] = useState(() => loadSession());
  const [progress, setProgress] = useState(() => loadProgressForUser(loadSession()?.id));
  const [activeLevelId, setActiveLevelId] = useState(1);
  const [screen, setScreen] = useState(user ? 'map' : 'auth');
  const [status, setStatus] = useState('ready');
  const [result, setResult] = useState(null);
  const [error, setError] = useState('');
  const [recordingSeconds, setRecordingSeconds] = useState(0);
  const [toolTab, setToolTab] = useState('translate');
  const [coachText, setCoachText] = useState('I am preparing for my interview and I want to speak clearly.');
  const recorderRef = useRef(null);

  const activeLevel = useMemo(() => getLevel(activeLevelId), [activeLevelId]);
  const completedCount = allLevels.filter((level) => progress.completed[level.id]?.bestScore >= PASS_SCORE).length;
  const nextOpen = allLevels.find((level) => isUnlocked(level, progress) && (progress.completed[level.id]?.bestScore || 0) < PASS_SCORE) || allLevels[0];
  const level = Math.max(1, Math.floor(progress.xp / 100) + 1);
  const levelXp = progress.xp % 100;
  const lastAttempt = progress.attempts[0];
  const weakSounds = getWeakSounds(progress.attempts);
  const coachToolOutput = useMemo(() => runCoachTool(coachText, toolTab), [coachText, toolTab]);

  useEffect(() => {
    if (status !== 'recording') {
      setRecordingSeconds(0);
      return undefined;
    }

    const timer = window.setInterval(() => {
      setRecordingSeconds((value) => value + 1);
    }, 1000);

    return () => window.clearInterval(timer);
  }, [status]);

  function handleAuth(event) {
    event.preventDefault();
    const formData = new FormData(event.currentTarget);
    const nextUser = signInUser({
      name: formData.get('name'),
      mobile: formData.get('mobile'),
      city: formData.get('city')
    });
    setUser(nextUser);
    setProgress(loadProgressForUser(nextUser.id));
    setScreen('map');
  }

  function handleSignOut() {
    signOutUser();
    setUser(null);
    setProgress(loadProgressForUser('guest'));
    setScreen('auth');
  }

  function startLevel(levelItem) {
    if (!isUnlocked(levelItem, progress)) return;
    setActiveLevelId(levelItem.id);
    setResult(null);
    setError('');
    setStatus('ready');
    setScreen('practice');
  }

  async function handleRecord() {
    if (status === 'recording') {
      await stopRecording();
      return;
    }

    try {
      const recorder = new AudioRecorder();
      await recorder.start();
      recorderRef.current = recorder;
      setError('');
      setStatus('recording');
    } catch {
      setError('Microphone permission blocked. Allow mic access and try again.');
    }
  }

  async function stopRecording() {
    if (!recorderRef.current) return;
    setStatus('processing');

    try {
      const audioBlob = await recorderRef.current.stop();
      recorderRef.current = null;
      const pronunciation = await checkPronunciation(activeLevel.target, audioBlob);
      const score = normalizeScore(pronunciation.score);
      const saved = saveAttempt(progress, activeLevel, score, user?.id, pronunciation);
      setProgress(saved.next);
      setResult({ pronunciation, score, ...saved });
      setScreen('result');
      setStatus('ready');
    } catch (err) {
      setStatus('ready');
      setError(err.message || 'Could not analyze audio. Check backend and try again.');
    }
  }

  function listen() {
    if (!('speechSynthesis' in window)) return;
    window.speechSynthesis.cancel();
    const utterance = new SpeechSynthesisUtterance(activeLevel.target);
    utterance.lang = 'en-IN';
    utterance.rate = activeLevel.type === 'paragraph' ? 0.78 : 0.88;
    window.speechSynthesis.speak(utterance);
  }

  if (screen === 'auth') {
    return <AuthScreen onSubmit={handleAuth} />;
  }

  return (
    <div className="app-shell">
      <header className="topbar">
        <div className="brand">
          <span className="brand-mark">S</span>
          <div>
            <strong>Sapphire Speech Coach</strong>
            <small>{user?.name || 'AI communication coach'} / Level {level}</small>
          </div>
        </div>
        <div className="top-stats">
          <Stat label="XP" value={progress.xp} />
          <Stat label="Streak" value={`${progress.streak}d`} />
          <Stat label="Done" value={`${completedCount}/${allLevels.length}`} />
          <button className="icon-text-button" type="button" onClick={handleSignOut}>Logout</button>
        </div>
      </header>

      <main>
        {screen === 'map' && (
          <section className="game-shell">
            <aside className="game-nav" aria-label="Coach navigation">
              <div className="profile-badge">
                <span className="avatar-ring">SC</span>
                <strong>Sapphire Coach</strong>
                <small>Level {level} Speaker</small>
              </div>
              <div className="nav-stack">
                <button className="nav-item nav-item--active" type="button">Path</button>
                <button className="nav-item" type="button" onClick={() => startLevel(nextOpen)}>Practice</button>
                <button className="nav-item" type="button">Analytics</button>
                <button className="nav-item" type="button" onClick={() => setScreen('tools')}>Coach Tools</button>
              </div>
              <button className="session-button" type="button" onClick={() => startLevel(nextOpen)}>
                Start Session
              </button>
            </aside>

            <section className="path-stage" aria-label="Speaking level path">
              <div className="stage-head">
                <div>
                  <p className="eyebrow">AI speaking path</p>
                  <h1>Clear speech quest</h1>
                  <p>Pass each level with 75% or more to unlock the next speaking challenge.</p>
                </div>
                <button className="primary-action" type="button" onClick={() => startLevel(nextOpen)}>
                  Continue Level {nextOpen.id}
                </button>
              </div>

              <div className="journey-line">
                {allLevels.map((levelItem, index) => {
                  const best = progress.completed[levelItem.id]?.bestScore || 0;
                  const unlocked = isUnlocked(levelItem, progress);
                  const current = levelItem.id === nextOpen.id;
                  const done = best >= PASS_SCORE;
                  return (
                    <button
                      className={`path-node ${done ? 'path-node--done' : ''} ${current ? 'path-node--current' : ''}`}
                      disabled={!unlocked}
                      key={levelItem.id}
                      type="button"
                      style={{ '--offset': `${index % 2 === 0 ? -34 : 34}px` }}
                      onClick={() => startLevel(levelItem)}
                    >
                      <span className="node-copy">
                        <strong>{levelItem.label}</strong>
                        <small>{levelItem.focus}</small>
                      </span>
                      <span className="node-orb">{done ? 'OK' : current ? '*' : unlocked ? levelItem.id : 'L'}</span>
                      <em>{best ? `${best}%` : unlocked ? 'Open' : 'Locked'}</em>
                    </button>
                  );
                })}
              </div>
            </section>

            <aside className="mission-rail" aria-label="Daily coach panel">
              <div className="mini-stats">
                <Stat label="Streak" value={`${progress.streak}d`} />
                <Stat label="Total XP" value={progress.xp} />
              </div>
              <div className="coach-card">
                <div className="coach-screen">
                  <span>Coach Ready</span>
                </div>
              </div>
              <div className="objective-card">
                <p className="eyebrow">Daily Objective</p>
                <h2>{nextOpen.label}</h2>
                <p>Master this level with 75% clarity to unlock Level {Math.min(nextOpen.id + 1, allLevels.length)}.</p>
                <div className="xp-track" aria-label="Level progress">
                  <span style={{ width: `${progress.completed[nextOpen.id]?.bestScore || 0}%` }} />
                </div>
                <button className="primary-action" type="button" onClick={() => startLevel(nextOpen)}>
                  Begin Warmup
                </button>
              </div>
              <div className="objective-card">
                <p className="eyebrow">Weak Sounds</p>
                <h2>{weakSounds.length ? weakSounds.join(' / ') : 'No weak sound yet'}</h2>
                <p>{lastAttempt ? `Latest score: ${lastAttempt.score}% in ${lastAttempt.label}.` : 'Your first attempt will create analytics.'}</p>
              </div>
            </aside>
          </section>
        )}

        {screen === 'practice' && (
          <section className="practice-panel">
            <button className="ghost-button" type="button" onClick={() => setScreen('map')}>
              Back to Map
            </button>
            <p className="eyebrow">{activeLevel.groupTitle} / Level {activeLevel.id}</p>
            <h1>{activeLevel.label}</h1>
            <div className="target-card">
              <span>{activeLevel.type}</span>
              <p>{activeLevel.target}</p>
              <small>Focus: {activeLevel.focus}</small>
            </div>
            <LiveCoach status={status} seconds={recordingSeconds} levelType={activeLevel.type} />
            <div className="practice-actions">
              <button className="secondary-action" type="button" onClick={listen}>
                Listen First
              </button>
              <button className={`record-button ${status === 'recording' ? 'record-button--active' : ''}`} type="button" onClick={handleRecord}>
                {status === 'recording' ? 'Stop' : status === 'processing' ? 'Analyzing...' : 'Record'}
              </button>
            </div>
            <p className="api-note">Backend: {API_BASE}</p>
            {error && <div className="error-box">{error}</div>}
          </section>
        )}

        {screen === 'result' && result && (
          <ResultScreen result={result} activeLevel={activeLevel} onRetry={() => startLevel(activeLevel)} onMap={() => setScreen('map')} />
        )}

        {screen === 'tools' && (
          <section className="practice-panel">
            <button className="ghost-button" type="button" onClick={() => setScreen('map')}>
              Back to Map
            </button>
            <p className="eyebrow">Secondary Coach Tools</p>
            <h1>Translation and grammar support</h1>
            <div className="tool-tabs" role="tablist" aria-label="Coach tools">
              {TOOL_TABS.map((tab) => (
                <button className={toolTab === tab ? 'tool-tab tool-tab--active' : 'tool-tab'} key={tab} type="button" onClick={() => setToolTab(tab)}>
                  {tab}
                </button>
              ))}
            </div>
            <textarea value={coachText} onChange={(event) => setCoachText(event.target.value)} />
            <div className="tool-output">
              <strong>{coachToolOutput.title}</strong>
              <p>{coachToolOutput.text}</p>
            </div>
          </section>
        )}
      </main>
    </div>
  );
}

function AuthScreen({ onSubmit }) {
  return (
    <main className="auth-shell">
      <section className="auth-panel">
        <div>
          <p className="eyebrow">Phase 1 Access</p>
          <h1>Sapphire Speech Coach</h1>
          <p>AI-powered communication practice for Indian students who know English but want to speak it confidently.</p>
        </div>
        <form className="auth-form" onSubmit={onSubmit}>
          <label>
            Name
            <input name="name" minLength="2" placeholder="Arpit Sharma" required />
          </label>
          <label>
            Mobile or Student ID
            <input name="mobile" placeholder="9876543210" required />
          </label>
          <label>
            City
            <input name="city" placeholder="Jaipur" />
          </label>
          <button className="primary-action" type="submit">Start Coaching</button>
        </form>
      </section>
    </main>
  );
}

function LiveCoach({ status, seconds, levelType }) {
  const targetSeconds = levelType === 'paragraph' ? 28 : levelType === 'sentence' ? 12 : 6;
  const pace = Math.min(100, Math.round((seconds / targetSeconds) * 100));
  const prompt =
    status === 'recording'
      ? seconds < 2
        ? 'Start steady'
        : seconds > targetSeconds
          ? 'Wrap naturally'
          : 'Keep rhythm'
      : status === 'processing'
        ? 'Analyzing speech'
        : 'Ready for clear speech';

  return (
    <div className="live-coach">
      <div>
        <strong>{prompt}</strong>
        <span>{seconds}s recorded</span>
      </div>
      <div className="meter">
        <span style={{ width: `${pace}%` }} />
      </div>
    </div>
  );
}

function ResultScreen({ result, activeLevel, onRetry, onMap }) {
  const breakdown = result.pronunciation.score_breakdown || {};
  return (
    <section className="result-panel">
      <p className="eyebrow">Instant Feedback</p>
      <div className="score-layout">
        <div className={`score-orb ${result.passed ? 'score-orb--pass' : 'score-orb--retry'}`}>
          <strong>{result.score}</strong>
          <span>Score</span>
        </div>
        <div>
          <h1>{result.passed ? 'Level Passed' : 'Retry Needed'}</h1>
          <p>{result.passed ? `Great. You earned ${result.xpEarned} XP.` : 'Slow down, speak each sound clearly, and try again.'}</p>
        </div>
      </div>
      <div className="breakdown-grid">
        <Stat label="Clear" value={breakdown.correct || 0} />
        <Stat label="Accent OK" value={breakdown.accent_match || 0} />
        <Stat label="Close" value={breakdown.close || 0} />
        <Stat label="Needs Work" value={(breakdown.wrong || 0) + (breakdown.missing || 0) + (breakdown.extra || 0)} />
      </div>
      <div className="feedback-list">
        {result.pronunciation.summary && <div>{result.pronunciation.summary}</div>}
        {(result.pronunciation.feedback || []).map((item) => (
          <div key={item}>{item}</div>
        ))}
      </div>
      {result.pronunciation.mistakes?.length > 0 && (
        <div className="mistake-panel">
          <h2>Your Mistakes</h2>
          {result.pronunciation.mistakes.map((item, index) => (
            <article key={`${item.expected}-${item.spoken}-${index}`}>
              <strong>{item.type.replace('_', ' ')}</strong>
              <span>Expected {item.expected || '-'} / Heard {item.spoken || '-'}</span>
              <p>{item.tip}</p>
            </article>
          ))}
        </div>
      )}
      {result.pronunciation.improvements?.length > 0 && (
        <div className="mistake-panel">
          <h2>How To Improve</h2>
          {result.pronunciation.improvements.map((item) => (
            <article key={item}>
              <p>{item}</p>
            </article>
          ))}
        </div>
      )}
      {result.pronunciation.comparison?.length > 0 && (
        <div className="sound-grid" aria-label="Sound breakdown">
          {result.pronunciation.comparison.slice(0, 60).map((item, index) => (
            <span className={`sound-pill sound-pill--${item.type}`} title={item.tip} key={`${item.expected}-${item.spoken}-${index}`}>
              {item.spoken || item.expected || '-'}
            </span>
          ))}
        </div>
      )}
      <div className="practice-actions">
        <button className="secondary-action" type="button" onClick={onRetry}>
          Try Again
        </button>
        <button className="primary-action" type="button" onClick={onMap}>
          Back to Map
        </button>
      </div>
      <small className="api-note">Target: {activeLevel.target}</small>
    </section>
  );
}

function Stat({ label, value }) {
  return (
    <div className="stat">
      <strong>{value}</strong>
      <span>{label}</span>
    </div>
  );
}

function normalizeScore(score) {
  const numeric = Number(score || 0);
  if (numeric <= 1) return Math.round(numeric * 100);
  return Math.round(numeric);
}

function getWeakSounds(attempts) {
  const counts = {};
  attempts.forEach((attempt) => {
    (attempt.weakSounds || []).forEach((sound) => {
      counts[sound] = (counts[sound] || 0) + 1;
    });
  });
  return Object.entries(counts)
    .sort((left, right) => right[1] - left[1])
    .slice(0, 3)
    .map(([sound]) => sound);
}

function runCoachTool(text, tab) {
  const clean = text.trim();
  if (!clean) {
    return { title: 'No text', text: 'Type one sentence to get support.' };
  }

  if (tab === 'translate') {
    return {
      title: 'Hindi Meaning',
      text: simpleTranslate(clean)
    };
  }

  return {
    title: 'Grammar Suggestion',
    text: grammarSuggestion(clean)
  };
}

function simpleTranslate(text) {
  const dictionary = {
    interview: 'interview',
    confidence: 'atmavishwas',
    clearly: 'saaf tareeke se',
    project: 'project',
    speak: 'bolna',
    practicing: 'practice kar raha hoon'
  };
  return text
    .split(/\s+/)
    .map((word) => dictionary[word.toLowerCase().replace(/[.,]/g, '')] || word)
    .join(' ');
}

function grammarSuggestion(text) {
  let suggestion = text
    .replace(/\bi am\b/gi, 'I am')
    .replace(/\bi\b/g, 'I')
    .replace(/\s+/g, ' ')
    .trim();
  if (suggestion && !/[.!?]$/.test(suggestion)) suggestion += '.';
  return suggestion;
}
