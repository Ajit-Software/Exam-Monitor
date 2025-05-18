<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="/css/register_js.css">
</head>
<body>
    <div class="nav">
        <a href="/home" alt="HOME">HOME</a>
    </div>
    <div class="text">
        <h2 id="rsj">REGISTER JUNIOR SUPERVISOR</h2>
    </div>
    
    <div class="container">
		<form action="/register_js" method="POST">

            <label for="jsname">Name:</label>
            <input type="text" name="jsname" id="jsname" required />

            <label for="">ID:</label>
            <input type="text" name="jid" id="jid" required />

            <label for="jpassword"> Password:</label>
            <input type="password" name="jpassword" id="jpassword" required/>

            <br>
            <br>
            <br>
            <button type="submit" id="jsubmit" align="center">Submit</button>

        </form>
    </div>


	<% if (request.getAttribute("message") != null) { %>
	    <script>alert("<%= request.getAttribute("message") %>");</script>
	<% } else if (request.getAttribute("fail") != null) { %>
	    <script>alert("<%= request.getAttribute("fail") %>");</script>
	<% } %>
</body>
</html>