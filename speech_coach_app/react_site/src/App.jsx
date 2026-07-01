import { BrowserRouter, Navigate, Route, Routes } from 'react-router-dom';
import './App.css';
import SplashScreen from './screens/SplashScreen';
import LoginScreen from './screens/LoginScreen';
import SignupScreen from './screens/SignupScreen';
import OnboardingScreen from './screens/OnboardingScreen';
import DashboardScreen from './screens/DashboardScreen';

function App() {
  const onboardingComplete = window.localStorage.getItem('onboardingComplete') === 'true';

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<SplashScreen />} />
        <Route path="/splash" element={<SplashScreen />} />
        <Route path="/login" element={<LoginScreen />} />
        <Route path="/signup" element={<SignupScreen />} />
        <Route path="/onboarding" element={<OnboardingScreen />} />
        <Route path="/home" element={<DashboardScreen />} />
        <Route path="*" element={<Navigate to={onboardingComplete ? '/login' : '/onboarding'} replace />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
