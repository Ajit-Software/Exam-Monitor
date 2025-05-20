let video = document.getElementById('qr-video');
let scannerInterval;
let lastStudentErn = null;

function startScanning() {
    document.getElementById("camera-error").style.display = "none";
    document.getElementById("startScanBtn").disabled = true;

    navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
        .then(function (stream) {
            video.srcObject = stream;
            scannerInterval = setInterval(scanQRCode, 100);
        })
        .catch(function (err) {
            console.error("Camera error: " + err);
            document.getElementById("camera-error").style.display = "block";
            document.getElementById("startScanBtn").disabled = false;
        });
}

function scanQRCode() {
    if (video.readyState === video.HAVE_ENOUGH_DATA) {
        const canvas = document.createElement("canvas");
        const context = canvas.getContext("2d");
        canvas.height = video.videoHeight;
        canvas.width = video.videoWidth;
        context.drawImage(video, 0, 0, canvas.width, canvas.height);

        const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
        const qrCode = jsQR(imageData.data, canvas.width, canvas.height, { inversionAttempts: "dontInvert" });

        if (qrCode) {
            const scannedData = qrCode.data.trim();
            clearInterval(scannerInterval);
            document.getElementById("startScanBtn").disabled = false;

            if (!lastStudentErn) {
                if (scannedData.startsWith("EN")) {
                    lastStudentErn = scannedData;
                    sendQRCodeToServer(scannedData);
                } else {
                    updateQRStatus("Error: Expected Student ERN Number QR", true);
                    setTimeout(startScanning, 1500);
                }
            } else {
                if (!scannedData.startsWith("EN")) {
                    assignAnswerSheetToStudent(lastStudentErn, scannedData);
                    lastStudentErn = null;
                    setTimeout(startScanning, 1500);
                } else {
                    updateQRStatus("Error: Expected Answer Sheet QR, but got another student QR", true);
                    setTimeout(startScanning, 1500);
                }
            }
        }
    }
}

function sendQRCodeToServer(qrCodeData) {
    const blockId = document.getElementById('block-number').value;

    fetch("/api/qr/save", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ data: qrCodeData, blockId: blockId })
    })
    .then(res => {
        if (!res.ok) {
            return res.text().then(msg => { throw new Error(msg); });
        }
        return res.text();
    })
    .then(() => {
        updateStudentStatusInTable(qrCodeData);
        updateQRStatus("Student marked present. Now scan the answer sheet QR code.");
    })
    .catch(error => {
        console.error('Error:', error);
        updateQRStatus("Error: " + error.message, true);
        lastStudentErn = null;
        setTimeout(startScanning, 1500);
    });
}

function assignAnswerSheetToStudent(ern, answerSheetCode) {
    const blockId = document.getElementById('block-number').value;

    fetch("/api/qr/assign", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ern: ern, answerSheet: answerSheetCode, blockId: blockId })
    })
    .then(res => res.text())
    .then(() => {
        updateAnswerSheetInTable(ern, answerSheetCode);
        updateQRStatus("Answer sheet assigned.");
    })
    .catch(error => {
        console.error('Error:', error);
        updateQRStatus("Error assigning answer sheet.", true);
    });
}

function updateStudentStatusInTable(ern) {
    const rows = document.querySelectorAll("table tbody tr");
    rows.forEach(row => {
        const ernCell = row.querySelector("td");
        if (ernCell && ernCell.textContent.trim() === ern.trim()) {
            const statusCell = row.cells[2];
            statusCell.textContent = 'P';

            row.classList.remove("highlight");
            void row.offsetWidth;
            row.classList.add("highlight");

            row.scrollIntoView({ behavior: 'smooth', block: 'center' });
            setTimeout(() => row.classList.remove("highlight"), 2000);
        }
    });
}

function updateAnswerSheetInTable(ern, code) {
    const rows = document.querySelectorAll(".table tr");
    rows.forEach(row => {
        const cells = row.getElementsByTagName("td");
        if (cells.length > 0 && cells[0].innerText.trim() === ern.trim()) {
            cells[3].innerText = code;

            row.classList.add("highlight");
            row.scrollIntoView({ behavior: 'smooth', block: 'center' });
            setTimeout(() => row.classList.remove("highlight"), 2000);
        }
    });
}

function updateQRStatus(message, isError = false) {
    const statusEl = document.getElementById("qr-status");
    statusEl.style.color = isError ? "red" : "#2c3e50";
    statusEl.innerText = message;
}
