import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const slides = [
  {
    title: 'Start your speaking journey 🚀',
    description: 'Practice English speaking daily in a fun way',
    imageUrl: 'https://lh3.googleusercontent.com/aida/AP1WRLtA0lUPXIcYVo0VCrGTsBLkeWXPlCvhsajO-OvXC23TguI_KtkO6goD_WPsbH_6YsmfH6J6YSHRdWlvF_GgCW8nPdQe13vGC8Y3p5oZenrwLIn_Jf6mMFOSkIQU5PpAY5-LC6TtxruWaydkuqAaOree5RgJlmiyemK2XGQK4UrbX9NfJWnv6JZ7hHE-aeFpdqD1YWKLqb2tI4M7avtrEOguomSKLIArMTfKixNUzawnH-YwuHfiu7LDyUk',
    accent: 'rgba(74, 222, 128, 0.25)',
  },
  {
    title: 'Get instant AI feedback 🎯',
    description: 'Improve pronunciation and fluency with real-time suggestions',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAb98vQfNlf8Bp3rhvatV3IgZ3_awk-JHTcnpYKskfRazxkhswbD9ZniIn_bxr7EpTDb-4pn9iQW6yXqJ6CUhHjdejPYEyOvi7Ei7z5xEtv_9-eW5nH5sOWYxeV40EE-UQ4f6CK_92L2qCsDJYQrYZuEdlEvlmpAgDqLl49hVwicR6ZX1m0FTXaSDD0C3UIds6RYkbLyLdb7tVP5FvSKl2BoIr8NiXxo56ZubtX7aBUNv8ea1KEpRTdb6039JY26NDfNKFCcepwPnc',
    accent: 'rgba(64, 194, 253, 0.25)',
  },
  {
    title: 'Level up every day 🔥',
    description: 'Build streaks, track progress, and improve daily',
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuABmDNg6xTO1hYz--EAsK0tAQ-XIgiu31FyyJF_Nuz7wCbJY4INpd__TfFtiU8uk3JAHZW4kpQKHc5Vy1xFzSzw8L0srDoqDLJps4bauIQM-jsud81vQX21t6UefzY0C2kM5itJLdR_qsUMAiiXl476hVx69bsBsBSrQsIG81k51ECnMTJLb7Tcm3_RzJwC2TFua8M9Nyxf_LHDXi8l3KKKzXGp3jj4-uh4MWPJxfgnQTT5Q-vDkfCAfQw9l-ALnLbc8fomeftEu1U',
    accent: 'rgba(255, 180, 126, 0.25)',
  },
];

export default function OnboardingScreen() {
  const navigate = useNavigate();
  const [currentPage, setCurrentPage] = useState(0);

  const nextPage = () => {
    if (currentPage < slides.length - 1) {
      setCurrentPage((value) => value + 1);
      return;
    }

    window.localStorage.setItem('onboardingComplete', 'true');
    navigate('/login', { replace: true });
  };

  const currentSlide = slides[currentPage];

  return (
    <div className="onboarding-screen" style={{ background: `linear-gradient(135deg, ${currentSlide.accent}, #f7f9fb)` }}>
      <div className="onboarding-topbar">
        <div className="brand-pill">
          <span>🎤</span>
          <strong>Speech Coach</strong>
        </div>
        <button type="button" className="text-link" onClick={() => navigate('/login', { replace: true })}>
          Skip
        </button>
      </div>

      <div className="onboarding-content">
        <img src={currentSlide.imageUrl} alt={currentSlide.title} className="onboarding-hero" />
        <h2>{currentSlide.title}</h2>
        <p>{currentSlide.description}</p>
      </div>

      <div className="onboarding-footer">
        <div className="dots">
          {slides.map((slide, index) => (
            <span key={slide.title} className={index === currentPage ? 'dot active' : 'dot'} />
          ))}
        </div>
        <button type="button" className="primary-btn" onClick={nextPage}>
          {currentPage === slides.length - 1 ? 'Get Started' : 'Next'}
        </button>
      </div>
    </div>
  );
}
