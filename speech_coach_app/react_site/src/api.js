const API_BASE = import.meta.env.VITE_API_BASE || 'http://127.0.0.1:8000';

export async function checkPronunciation(target, audioBlob) {
  const formData = new FormData();
  formData.append('audio', audioBlob, 'recording.wav');

  const response = await fetch(`${API_BASE}/check/${encodeURIComponent(target)}?accent=indian`, {
    method: 'POST',
    body: formData
  });

  const text = await response.text();
  let data = {};

  if (text) {
    try {
      data = JSON.parse(text);
    } catch {
      data = { detail: text };
    }
  }

  if (!response.ok) {
    throw new Error(data.detail || `Server error ${response.status}`);
  }

  return data;
}

export { API_BASE };
