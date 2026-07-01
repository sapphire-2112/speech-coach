let mediaRecorder;
let audioChunks = [];
let audioBlob = null;

let grammarId = null;
let grammarLevel = "easy";

const loadBtn = document.getElementById("loadGrammar");
const startBtn = document.getElementById("startRecord");
const stopBtn = document.getElementById("stopRecord");
const submitBtn = document.getElementById("submitGrammar");

// Load Question
loadBtn.onclick = async () => {

    const response = await fetch("/grammar/easy");
    const data = await response.json();

    grammarId = data.id;

    document.getElementById("scenario").innerText = data.scenario;
    document.getElementById("wrongSentence").innerText = data.wrong;

    document.getElementById("grade").innerText = "";
    document.getElementById("score").innerText = "";
    document.getElementById("feedback").innerHTML = "";

    console.log(data);
};

// Start Recording
startBtn.onclick = async () => {

    const stream = await navigator.mediaDevices.getUserMedia({
        audio: true
    });

    mediaRecorder = new MediaRecorder(stream);

    audioChunks = [];

    mediaRecorder.ondataavailable = (event) => {
        audioChunks.push(event.data);
    };

    mediaRecorder.onstop = () => {

        audioBlob = new Blob(audioChunks, {
            type: "audio/wav"
        });

        console.log("Recording finished");
    };

    mediaRecorder.start();

    startBtn.disabled = true;
    stopBtn.disabled = false;
};

// Stop Recording
stopBtn.onclick = () => {

    mediaRecorder.stop();

    startBtn.disabled = false;
    stopBtn.disabled = true;
};

// Submit
submitBtn.onclick = async () => {

    if (!audioBlob) {
        alert("Please record audio first.");
        return;
    }

    if (grammarId == null) {
        alert("Load a question first.");
        return;
    }

    const formData = new FormData();

    formData.append(
        "audio",
        audioBlob,
        "grammar.wav"
    );

    formData.append(
        "level",
        grammarLevel
    );

    formData.append(
        "sentence_id",
        grammarId
    );

    const response = await fetch("/grammar/check", {
        method: "POST",
        body: formData
    });

    const result = await response.json();

    console.log(result);

    document.getElementById("grade").innerText =
        result.grade;

    document.getElementById("score").innerText =
        result.score + "/100";

    const feedback =
        document.getElementById("feedback");

    feedback.innerHTML = "";

    result.feedback.forEach(item => {

        const li = document.createElement("li");

        li.innerText = item;

        feedback.appendChild(li);

    });

};