<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>QR Code Scanner</title>
    <script src="https://unpkg.com/jsqr/dist/jsQR.js"></script>
</head>
<body>
    <h2>Scan a QR Code</h2>
    <video id="qr-video" width="300" height="200" autoplay></video>
    <button onclick="startScanning()">Start Scanning</button>
    <p id="qr-status"></p>  <!-- This will display the decoded QR code -->

    <script>
        let video = document.getElementById('qr-video');
        let scannerInterval;

        // Start the video stream and scanning
        function startScanning() {
            navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
                .then(function(stream) {
                    video.srcObject = stream;
                    scannerInterval = setInterval(scanQRCode, 100);
                })
                .catch(function(err) {
                    console.error("Error accessing camera: " + err);
                });
        }

        // Scan for QR codes in each video frame
        function scanQRCode() {
            if (video.readyState === video.HAVE_ENOUGH_DATA) {
                const canvas = document.createElement("canvas");
                const context = canvas.getContext("2d");
                canvas.height = video.videoHeight;
                canvas.width = video.videoWidth;
                context.drawImage(video, 0, 0, canvas.width, canvas.height);

                const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
                const qrCode = jsQR(imageData.data, canvas.width, canvas.height, {
                    inversionAttempts: "dontInvert",
                });

                if (qrCode) {
                    clearInterval(scannerInterval);
                    alert("QR Code scanned: " + qrCode.data);  // Show decoded value in alert
                    sendQRCodeToServer(qrCode.data);
                }
            }
        }

        // Send the QR code data to your Spring Boot server
        function sendQRCodeToServer(qrCodeData) {
            fetch("/api/qr/save", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({ data: qrCodeData }), // Send the QR data in the correct format
            })
            .then(response => response.text())  // Expecting the QR code value back directly
            .then(data => {
                // Display the decoded QR code value in the status paragraph
                document.getElementById('qr-status').innerText = "Decoded QR Code Value: " + data; 
            })
            .catch((error) => {
                console.error('Error:', error);
            });
        }
    </script>
</body>
</html>
