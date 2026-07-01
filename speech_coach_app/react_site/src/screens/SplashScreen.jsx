import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';

const mascotUrl = 'https://lh3.googleusercontent.com/aida/AP1WRLtA0lUPXIcYVo0VCrGTsBLkeWXPlCvhsajO-OvXC23TguI_KtkO6goD_WPsbH_6YsmfH6J6YSHRdWlvF_GgCW8nPdQe13vGC8Y3p5oZenrwLIn_Jf6mMFOSkIQU5PpAY5-LC6TtxruWaydkuqAaOree5RgJlmiyemK2XGQK4UrbX9NfJWnv6JZ7hHE-aeFpdqD1YWKLqb2tI4M7avtrEOguomSKLIArMTfKixNUzawnH-YwuHfiu7LDyUk';

export default function SplashScreen() {
  const navigate = useNavigate();
  const [progress, setProgress] = useState(0.1);
  const [floatOffset, setFloatOffset] = useState(0);

  useEffect(() => {
    const timer = window.setInterval(() => {
      setFloatOffset((prev) => (prev === 0 ? 10 : 0));
    }, 900);

    const progressTimer = window.setTimeout(() => setProgress(0.84), 180);
    const routeTimer = window.setTimeout(() => {
      const onboardingComplete = window.localStorage.getItem('onboardingComplete') === 'true';
      navigate(onboardingComplete ? '/login' : '/onboarding', { replace: true });
    }, 2600);

    return () => {
      window.clearInterval(timer);
      window.clearTimeout(progressTimer);
      window.clearTimeout(routeTimer);
    };
  }, [navigate]);

  return (
    <div className="splash-screen">
      <div className="splash-inner">
        <div className="mascot-wrap" style={{ transform: `translateY(${floatOffset}px)` }}>
          <img src={mascotUrl} alt="Speech Coach mascot" className="mascot" />
        </div>
        <h1>Speech Coach</h1>
        <p>Level up your speaking, one day at a time ✨</p>
        <div className="progress-shell">
          <div className="progress-bar">
            <div className="progress-fill" style={{ width: `${progress * 100}%` }} />
          </div>
          <span>Preparing your speaking world...</span>
        </div>
      </div>
    </div>
  );
}
