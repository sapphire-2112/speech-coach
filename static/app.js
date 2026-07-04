console.log("APP.JS LOADED");
console.log(document.getElementById("loadGrammar"));
let mediaRecorder;
let audioChunks = [];
let recordedAudio = null;

const startBtn = document.getElementById("startBtn");
const stopBtn = document.getElementById("stopBtn");
const translateBtn = document.getElementById("translateBtn");

// --------------------
// START RECORDING
// --------------------

startBtn.onclick = async () => {

    const stream = await navigator.mediaDevices.getUserMedia({
        audio: true
    });

    mediaRecorder = new MediaRecorder(stream);

    audioChunks = [];

    mediaRecorder.ondataavailable = (event) => {
        audioChunks.push(event.data);
    };

    mediaRecorder.start();

    startBtn.disabled = true;
    stopBtn.disabled = false;
};

// --------------------
// STOP RECORDING
// --------------------

stopBtn.onclick = () => {

    mediaRecorder.stop();

    mediaRecorder.onstop = () => {

        recordedAudio = new Blob(audioChunks, {
            type: "audio/wav"
        });


        translateBtn.disabled = false;
    };

    startBtn.disabled = false;
    stopBtn.disabled = true;
};

// --------------------
// TRANSLATE
// --------------------

translateBtn.onclick = async () => {

    if (!recordedAudio) {
        alert("Please record some audio first.");
        return;
    }

    const formData = new FormData();

    formData.append(
        "audio",
        recordedAudio,
        "recording.wav"
    );

    formData.append(
        "accent",
        document.getElementById("accent").value
    );

    formData.append(
        "slow",
        false
    );

    const response = await fetch("/translate", {
        method: "POST",
        body: formData
    });

    const result = await response.json();

    document.getElementById("transcript").innerText =
        result.transcript;

    document.getElementById("translation").innerText =
        result.translation;

    window.lastTranslation = result.translation;

    document.getElementById("speakBtn").disabled = false;
    document.getElementById("slowSpeakBtn").disabled = false;
};

// --------------------
// NORMAL PRONUNCIATION
// --------------------

document.getElementById("speakBtn").onclick = () => {

    const audio = new Audio(
        "/audio?t=" + Date.now()
    );

    audio.play();
};

// --------------------
// SLOW PRONUNCIATION
// --------------------

document.getElementById("slowSpeakBtn").onclick = async () => {

    const formData = new FormData();

    formData.append(
        "text",
        window.lastTranslation
    );

    formData.append(
        "accent",
        document.getElementById("accent").value
    );

    formData.append(
        "slow",
        true
    );

    await fetch("/tts", {
        method: "POST",
        body: formData
    });

    const audio = new Audio(
        "/audio?t=" + Date.now()
    );

    audio.play();
};
