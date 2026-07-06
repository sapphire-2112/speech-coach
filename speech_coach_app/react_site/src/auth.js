const AUTH_KEY = 'sapphireSpeechCoachSession';
const USERS_KEY = 'sapphireSpeechCoachUsers';

export function loadSession() {
  try {
    return JSON.parse(localStorage.getItem(AUTH_KEY));
  } catch {
    return null;
  }
}

export function signInUser({ name, mobile, city }) {
  const cleanName = (name || '').trim();
  const cleanMobile = (mobile || '').trim();
  const user = {
    id: cleanMobile || cleanName.toLowerCase().replace(/\s+/g, '-') || `guest-${Date.now()}`,
    name: cleanName || 'Speaker',
    mobile: cleanMobile,
    city: (city || '').trim(),
    joinedAt: new Date().toISOString()
  };

  const users = loadUsers();
  const existing = users.find((item) => item.id === user.id);
  const nextUser = existing ? { ...existing, ...user, joinedAt: existing.joinedAt } : user;
  const nextUsers = [nextUser, ...users.filter((item) => item.id !== user.id)].slice(0, 10);

  localStorage.setItem(USERS_KEY, JSON.stringify(nextUsers));
  localStorage.setItem(AUTH_KEY, JSON.stringify(nextUser));
  return nextUser;
}

export function signOutUser() {
  localStorage.removeItem(AUTH_KEY);
}

function loadUsers() {
  try {
    return JSON.parse(localStorage.getItem(USERS_KEY)) || [];
  } catch {
    return [];
  }
}
