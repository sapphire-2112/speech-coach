import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';

const mascotUrl = 'https://lh3.googleusercontent.com/aida/AP1WRLtA0lUPXIcYVo0VCrGTsBLkeWXPlCvhsajO-OvXC23TguI_KtkO6goD_WPsbH_6YsmfH6J6YSHRdWlvF_GgCW8nPdQe13vGC8Y3p5oZenrwLIn_Jf6mMFOSkIQU5PpAY5-LC6TtxruWaydkuqAaOree5RgJlmiyemK2XGQK4UrbX9NfJWnv6JZ7hHE-aeFpdqD1YWKLqb2tI4M7avtrEOguomSKLIArMTfKixNUzawnH-YwuHfiu7LDyUk';

export default function SignupScreen() {
  const navigate = useNavigate();
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [message, setMessage] = useState('');

  const handleSubmit = (event) => {
    event.preventDefault();
    if (!name || !email || !password) {
      setMessage('Please fill in all fields.');
      return;
    }

    window.localStorage.setItem('isLoggedIn', 'true');
    window.localStorage.setItem('onboardingComplete', 'true');
    navigate('/home', { replace: true });
  };

  return (
    <div className="auth-shell signup-shell">
      <div className="auth-card">
        <img src={mascotUrl} alt="Speech Coach mascot" className="auth-hero" />
        <h2>Start Your Journey 🚀</h2>
        <p>Create your Speech Coach account</p>

        <form onSubmit={handleSubmit} className="auth-form">
          <div className="message-box">Let's improve your speaking today!</div>

          <label className="field-label">Full Name</label>
          <input value={name} onChange={(event) => setName(event.target.value)} placeholder="Enter your name" />

          <label className="field-label">Email</label>
          <input type="email" value={email} onChange={(event) => setEmail(event.target.value)} placeholder="hello@speechcoach.com" />

          <label className="field-label">Password</label>
          <div className="password-field">
            <input type={showPassword ? 'text' : 'password'} value={password} onChange={(event) => setPassword(event.target.value)} placeholder="Create a password" />
            <button type="button" onClick={() => setShowPassword((value) => !value)}>
              {showPassword ? 'Hide' : 'Show'}
            </button>
          </div>

          {message ? <div className="form-message">{message}</div> : null}
          <button type="submit" className="primary-btn full">Create Account</button>
        </form>

        <div className="auth-footer">
          <span>Already have an account?</span>
          <Link to="/login">Login</Link>
        </div>
      </div>
    </div>
  );
}
