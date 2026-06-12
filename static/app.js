let mediaRecorder;
let audioChunks = [];

const startBtn = document.getElementById("startBtn");
const stopBtn = document.getElementById("stopBtn");

startBtn.onclick = async () => {

    const stream =
        await navigator.mediaDevices.getUserMedia({
            audio: true
        });

    mediaRecorder = new MediaRecorder(stream);

    audioChunks = [];

    mediaRecorder.ondataavailable = event => {
        audioChunks.push(event.data);
    };

    mediaRecorder.start();

    startBtn.disabled = true;
    stopBtn.disabled = false;
};

stopBtn.onclick = () => {

    mediaRecorder.stop();

    mediaRecorder.onstop = async () => {

        const audioBlob =
            new Blob(audioChunks, {
                type: "audio/wav"
            });

        const formData = new FormData();

        formData.append(
            "audio",
            audioBlob,
            "recording.wav"
        );

        const response =
            await fetch("/translate", {
                method: "POST",
                body: formData
            });

        const result =
            await response.json();

        document.getElementById(
            "transcript"
        ).innerText =
            result.transcript;

        document.getElementById(
            "translation"
        ).innerText =
            result.translation;
    };

    startBtn.disabled = false;
    stopBtn.disabled = true;
};