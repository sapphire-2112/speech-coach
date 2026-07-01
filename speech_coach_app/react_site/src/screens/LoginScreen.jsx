import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';

const mascotUrl = 'https://lh3.googleusercontent.com/aida/AP1WRLtA0lUPXIcYVo0VCrGTsBLkeWXPlCvhsajO-OvXC23TguI_KtkO6goD_WPsbH_6YsmfH6J6YSHRdWlvF_GgCW8nPdQe13vGC8Y3p5oZenrwLIn_Jf6mMFOSkIQU5PpAY5-LC6TtxruWaydkuqAaOree5RgJlmiyemK2XGQK4UrbX9NfJWnv6JZ7hHE-aeFpdqD1YWKLqb2tI4M7avtrEOguomSKLIArMTfKixNUzawnH-YwuHfiu7LDyUk';

export default function LoginScreen() {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [message, setMessage] = useState('');

  const handleSubmit = (event) => {
    event.preventDefault();
    if (!email || !password) {
      setMessage('Please enter your email and password.');
      return;
    }

    window.localStorage.setItem('isLoggedIn', 'true');
    navigate('/home', { replace: true });
  };

  return (
    <div className="auth-shell">
      <div className="auth-card">
        <img src={mascotUrl} alt="Speech Coach mascot" className="auth-hero" />
        <h2>Welcome Back 👋</h2>
        <p>Login to continue your speaking journey</p>

        <form onSubmit={handleSubmit} className="auth-form">
          <div className="message-box">Let's continue your progress!</div>

          <label className="field-label">Email</label>
          <input
            type="email"
            value={email}
            onChange={(event) => setEmail(event.target.value)}
            placeholder="hello@speechcoach.com"
          />

          <label className="field-label">Password</label>
          <div className="password-field">
            <input
              type={showPassword ? 'text' : 'password'}
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              placeholder="Enter your password"
            />
            <button type="button" onClick={() => setShowPassword((value) => !value)}>
              {showPassword ? 'Hide' : 'Show'}
            </button>
          </div>

          <div className="forgot-link">Forgot password?</div>
          {message ? <div className="form-message">{message}</div> : null}

          <button type="submit" className="primary-btn full">Login</button>
        </form>

        <div className="auth-footer">
          <span>Don&apos;t have an account?</span>
          <Link to="/signup">Sign up</Link>
        </div>
      </div>
    </div>
  );
}
