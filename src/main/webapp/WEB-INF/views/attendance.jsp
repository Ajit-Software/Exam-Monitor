<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%
    List<Map<String, Object>> students = (List<Map<String, Object>>) request.getAttribute("students");
    List<Map<String, Object>> blockDetails = (List<Map<String, Object>>) request.getAttribute("BlockInfo");
    Map<String, Object> blockInfo = (blockDetails != null && !blockDetails.isEmpty()) ? blockDetails.get(0) : null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/css/attedence.css">
    <script src="https://unpkg.com/jsqr/dist/jsQR.js"></script>
    <style>
        .highlight {
            background-color: #d4edda;
            transition: background-color 0.5s ease;
        }

        #qr-status {
            margin-top: 15px;
            font-weight: bold;
            color: #2c3e50;
        }

        #camera-error {
            color: red;
            font-weight: bold;
            margin-top: 10px;
        }

        /* Make the button sticky */
        #startScanBtn {
            position: sticky;
            top: 20px;
            z-index: 100;
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-bottom: 20px;
            transition: background-color 0.3s ease;
        }

        #startScanBtn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
        }

        #startScanBtn:hover:not(:disabled) {
            background-color: #218838;
        }

        /* Navbar styling */
        .navbar {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            padding: 20px;
            background-color: #007bff;
            color: white;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .navbar-item {
            flex: 1;
            margin: 5px;
        }

        .navbar-item label {
            font-weight: bold;
        }

        .navbar-item input {
            width: 100%;
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ccc;
            background-color: #f1f1f1;
            margin-top: 5px;
        }

        /* Table Styles */
        .table-wrapper {
            margin: 20px 0;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        table th, table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        table th {
            background-color: #007bff;
            color: white;
        }

        table td {
            background-color: #f9f9f9;
        }

        table tr:hover {
            background-color: #f1f1f1;
        }

        table tr.highlight {
            background-color: #d4edda;
            animation: highlight-row 1s ease-in-out;
        }

        @keyframes highlight-row {
            0% {
                background-color: #d4edda;
            }
            100% {
                background-color: #f9f9f9;
            }
        }

        @media screen and (max-width: 600px) {
            .navbar-item {
                min-width: 100%;
            }
        }

        @media screen and (max-width: 768px) {
            .navbar {
                flex-direction: column;
            }

            .navbar-item {
                width: 100%;
                margin: 10px 0;
            }

            table th, table td {
                padding: 10px;
            }

            table {
                font-size: 14px;
            }

            #qr-video {
                width: 100%;
                height: auto;
            }

            #startScanBtn {
                width: 100%;
            }
        }

        @media screen and (max-width: 480px) {
            .navbar-item input {
                font-size: 14px;
            }

            table {
                font-size: 12px;
            }

            #startScanBtn {
                font-size: 14px;
            }

            #qr-status {
                font-size: 14px;
            }
        }

        /* Custom scrollbar for large tables */
        .table-wrapper {
            max-height: 400px;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #007bff #f1f1f1;
        }

        .table-wrapper::-webkit-scrollbar {
            width: 8px;
        }

        .table-wrapper::-webkit-scrollbar-thumb {
            background-color: #007bff;
            border-radius: 4px;
        }

        .table-wrapper::-webkit-scrollbar-track {
            background-color: #f1f1f1;
        }

    </style>
	
</head>
<body>

<!-- NAVBAR -->
<div class="navbar">
    <div class="navbar-item"><label for="date">Date:</label>
        <input type="text" id="date" value="<%= blockInfo != null ? blockInfo.get("exam_date") : "" %>" readonly>
    </div>
    <div class="navbar-item"><label for="exam-type">Exam Type:</label>
        <input type="text" id="exam-type" value="<%= blockInfo != null ? blockInfo.get("exam_type") : "" %>" readonly>
    </div>
    <div class="navbar-item"><label for="time-period">Time Period:</label>
        <input type="text" id="time-period" value="<%= blockInfo != null ? blockInfo.get("start_time") + " - " + blockInfo.get("end_time") : "" %>" readonly>
    </div>
    <div class="navbar-item"><label for="block-number">Block No:</label>
        <input type="text" id="block-number" value="<%= blockInfo != null ? blockInfo.get("block_id") : "" %>" readonly>
    </div>
    <div class="navbar-item"><label for="subject">Subject:</label>
        <input type="text" id="subject" value="<%= blockInfo != null ? blockInfo.get("subject") : "" %>" readonly>
    </div>
    <div class="navbar-item"><label for="supervisor-name">Supervisor:</label>
        		<input type="text" id="supervisor-name" value="<%= blockInfo != null ? blockInfo.get("jsname") : "" %>" readonly>

    </div>
</div>

<!-- ERROR -->
<% Object error = request.getAttribute("error"); %>
<% if (error != null) { %>
    <div style="color: red; font-weight: bold; margin: 20px 0;"><%= error.toString() %></div>
<% } else { %>

<!-- SCANNER SECTION -->
<h2>Scan a Student QR Code</h2>
<video id="qr-video" width="300" height="200" autoplay></video>
<p id="camera-error" style="display:none;">Unable to access camera. Please check browser permissions.</p>
<button id="startScanBtn" onclick="startScanning()">Start Scanning</button>
<p id="qr-status"></p>

<!-- TABLE -->
<div class="container">
    <div class="table-wrapper">
        <table class="table">
            <tr>
                <th style="width: 100px;">ERN</th>
                <th style="width: 200px;">NAME</th>
                <th style="width: 100px;">STATUS</th>
                <th style="width: 100px;">AnswerSheet</th>
            </tr>
            <% if (students != null && !students.isEmpty()) {
                for (Map<String, Object> student : students) {
                    String ern =(String) student.get("ern");
                    String name = (String) student.get("name");
                    String status = student.get("status") != null ? (String) student.get("status") : "A";
                    String ans_sheet_No = (String) student.get("answer_sheet_NO");
            %>
            <tr>
                <td><%= ern %></td>
                <td><%= name %></td>
                <td><%= status %></td>
                <td><%= ans_sheet_No %></td>
            </tr>
            <% } } else { %>
            <tr><td colspan="4">No students found for this block.</td></tr>
            <% } %>
        </table>
    </div>
</div>

<script>
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
	    .then(data => {
	        updateStudentStatusInTable(qrCodeData);
	        updateQRStatus("Student marked present. Now scan the answer sheet QR code.");
	        lastStudentErn = qrCodeData; // set only if success
	    })
	    .catch(error => {
	        console.error('Error:', error);
	        updateQRStatus("Error: " + error.message, true);
	        lastStudentErn = null; // reset if error
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
            .then(data => {
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
	        const ernCell = row.querySelector("td"); // ERN assumed to be in first column
	        if (ernCell && ernCell.textContent.trim() === ern.trim()) {
	            const statusCell = row.cells[2];
	            statusCell.textContent = 'P';

	            row.classList.remove("highlight");
	            void row.offsetWidth; // force reflow for animation restart
	            row.classList.add("highlight");

	            // Scroll to the student row smoothly
	            row.scrollIntoView({ behavior: 'smooth', block: 'center' });

	            // Optionally remove highlight after animation
	            setTimeout(() => row.classList.remove("highlight"), 2000);
	        }
	    });
	}


	function updateAnswerSheetInTable(ern, code) {
	    const rows = document.querySelectorAll(".table tr");
	    rows.forEach(row => {
	        const cells = row.getElementsByTagName("td");
	        if (cells.length > 0 && cells[0].innerText.trim() === ern.trim()) {
	            // Update the answer sheet column
	            cells[3].innerText = code;
	            
	            // Highlight the student row
	            row.classList.add("highlight");
	            
	            // Scroll to the row if it's not visible
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
                setTimeout(() => row.classList.remove("highlight"), 2000);
            }
        });
    }

    function updateQRStatus(message, isError = false) {
        const statusEl = document.getElementById("qr-status");
        statusEl.style.color = isError ? "red" : "#2c3e50";
        statusEl.innerText = message;
    }
</script>
<% } %>
</body>
</html>
