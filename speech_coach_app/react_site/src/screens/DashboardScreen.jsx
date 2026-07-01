import { useEffect, useState } from 'react';

const mascotUrl = 'https://lh3.googleusercontent.com/aida/AP1WRLtA0lUPXIcYVo0VCrGTsBLkeWXPlCvhsajO-OvXC23TguI_KtkO6goD_WPsbH_6YsmfH6J6YSHRdWlvF_GgCW8nPdQe13vGC8Y3p5oZenrwLIn_Jf6mMFOSkIQU5PpAY5-LC6TtxruWaydkuqAaOree5RgJlmiyemK2XGQK4UrbX9NfJWnv6JZ7hHE-aeFpdqD1YWKLqb2tI4M7avtrEOguomSKLIArMTfKixNUzawnH-YwuHfiu7LDyUk';
const fireUrl = 'https://lh3.googleusercontent.com/aida/AP1WRLvv4VUF0ght5bJn2Uh6ocHGhAtK15D98NS6dhns6sgmFUf0UeB9_TPKmhzxtZfzOikMe6E1Qbp_4vWAB3iji-mmfw18qQDB45XSfgqcPxTe5HhsoX3tL0mxuUIz3RxV63UYpb8ZlXmE8ls1Rd2TG0itirUGPW-HUFfQlYDKnlWwU0b8UilizRWGhAzSyrqjqOeS_H4ieQGmA-HZ0eMQrHr1om-KpTy5Huuu0HAKegsZsJIxpJHNJx6nu_E';

export default function DashboardScreen() {
  const [selectedNavIndex, setSelectedNavIndex] = useState(0);
  const [streakCount, setStreakCount] = useState(0);
  const [loadingStreak, setLoadingStreak] = useState(true);
  const [lastVisitDate, setLastVisitDate] = useState(null);

  useEffect(() => {
    const timer = window.setTimeout(() => {
      setStreakCount(5);
      setLastVisitDate('Today');
      setLoadingStreak(false);
    }, 700);

    return () => window.clearTimeout(timer);
  }, []);

  const resetStreak = () => {
    setStreakCount(0);
    setLastVisitDate(null);
    setLoadingStreak(false);
  };

  return (
    <div className="dashboard-screen">
      <header className="dashboard-header">
        <div className="brand-pill">
          <span>🎤</span>
          <strong>Speech Coach</strong>
        </div>
        <img src={mascotUrl} alt="Profile" className="profile-avatar" />
      </header>

      <main className="dashboard-main">
        <section className="hero-copy">
          <h2>Hello 👋, Ready to level up today?</h2>
          <p>Keep your streak alive 🔥</p>
        </section>

        <section className="streak-card">
          <img src={fireUrl} alt="Fire streak" className="streak-icon" />
          <div>
            <h3>{loadingStreak ? 'Loading streak...' : streakCount === 0 ? 'No active streak' : `${streakCount} day streak`}</h3>
            <p>{loadingStreak ? 'Checking today’s visit' : streakCount === 0 ? 'Start your streak today' : lastVisitDate ? `Last visit: ${lastVisitDate}` : 'Start your streak today'}</p>
            <button type="button" className="secondary-btn" onClick={resetStreak}>Reset streak</button>
            <span className="streak-caption">Mastering the flow!</span>
          </div>
        </section>

        <section className="action-card">
          <div className="action-icon">🎤</div>
          <h3>Next Adventure</h3>
          <p>Practice daily greetings and conversational fillers to sound like a pro.</p>
          <button type="button" className="primary-btn">Start Speaking Practice 🎤</button>
        </section>

        <section className="progress-card">
          <div className="progress-heading">
            <div className="level-badge">L3</div>
            <div>
              <h3>Level 3</h3>
              <p>Daily XP: 450/500</p>
            </div>
          </div>
          <div className="progress-bar large">
            <div className="progress-fill" style={{ width: '90%' }} />
          </div>
          <p className="progress-copy">Only 50 XP more to hit today's goal! You're crushing it.</p>
        </section>

        <section className="feature-list">
          <h3>Features</h3>
          <article className="feature-card green-card">
            <div className="feature-icon">📚</div>
            <h4>Vocabulary 📚</h4>
            <p>Learn new words daily and expand your range of expression.</p>
            <span>12 words today</span>
          </article>
          <article className="feature-card blue-card">
            <div className="feature-icon">✍️</div>
            <h4>Grammar ✍️</h4>
            <p>Fix your sentence structure with interactive real-time drills.</p>
            <span>3 lessons left</span>
          </article>
          <article className="feature-card orange-card">
            <div className="feature-icon">👤</div>
            <h4>Profile 👤</h4>
            <p>Track your progress and review your speech history achievements.</p>
            <span>Top 5% Learner</span>
          </article>
        </section>
      </main>

      <nav className="bottom-nav">
        {['Home', 'Lessons', 'Stats', 'Profile'].map((label, index) => (
          <button
            key={label}
            type="button"
            className={selectedNavIndex === index ? 'nav-item active' : 'nav-item'}
            onClick={() => setSelectedNavIndex(index)}
          >
            <span>{['🏠', '📘', '📊', '👤'][index]}</span>
            <strong>{label}</strong>
          </button>
        ))}
      </nav>
    </div>
  );
}
