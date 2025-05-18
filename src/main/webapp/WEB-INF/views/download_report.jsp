
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Download Report</title>
    <link rel="stylesheet" href="/css/download_report.css">
</head>


<body>
	
	<%
	    String error = (String) request.getAttribute("error");
	    if (error != null) {
	%>
	    <div id="errorMessage" style="color:red; text-align:center; margin-bottom: 20px;">
	        <%= error %>
	    </div>

	    <script>
	        // Automatically hide the error message after 5 seconds
	        setTimeout(function () {
	            var msgDiv = document.getElementById("errorMessage");
	            if (msgDiv) {
	                msgDiv.style.display = "none";
	            }
	        }, 5000);
	    </script>
	<%
	    }
	%>

    <div class="nav">
        <a href="/home">HOME</a>
    </div>
    <div class="text">
        <h2>DOWNLOAD REPORT</h2>
    </div>
    <br>
    <div class="exambox">
        <form action="download_pdf" method="get">
			<label for="blockId">Block ID:</label>
			<input type="text" id="date" name="blockId" required />
        <span>

        <label for="date">DATE:</label>
        <input type="date" id="date" name="date" required />

    </span> 
   <br>
   <br>
    <button type="submit" id="download_report">Download</button>
</div>


</body>
</html>