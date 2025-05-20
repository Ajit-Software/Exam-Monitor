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
    <script src="https://unpkg.com/jsqr/dist/jsQR.js"></script>
    <link rel="stylesheet" href="/css/attedence.css">
</head>
<body>

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

<% Object error = request.getAttribute("error"); %>
<% if (error != null) { %>
    <div class="error-message"><%= error.toString() %></div>
<% } else { %>



	<h2 class="center-text">Scan a Student QR Code</h2>
	<div class="qr-scanner-container">
	    <video id="qr-video" width="300" height="200" autoplay></video>
	    <p id="camera-error">Unable to access camera. Please check browser permissions.</p>
	    <button id="startScanBtn" onclick="startScanning()">Start Scanning</button>
	    <p id="qr-status"></p>
	</div>

	
	<div class="table-wrapper">
	    <div class="scrollable-table">
	        <table class="table">

            <tr>
                <th style="width: 100px;">ERN</th>
                <th style="width: 200px;">NAME</th>
                <th style="width: 100px;">STATUS</th>
                <th style="width: 100px;">AnswerSheet</th>
            </tr>
            <% if (students != null && !students.isEmpty()) {
                for (Map<String, Object> student : students) {
                    String ern = (String) student.get("ern");
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
<% } %>

<script src="/JS/attendance.js"></script>
</body>
</html>
