<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JS HOME</title>
    <link rel="stylesheet" href="/css/js_home.css">
</head>
<body>
    <div class="jsnav">
		<h2>Welcome, ${username}!</h2>

		<h2>Welcome, ${type}!</h2>
        
		<button type="button" onclick="window.location.href='/'">Log Out</button>

    </div>
    <div class="jplan">
        <a href="/attendance" alt="" id="tplan">
            <div class="img1">
                <img src="/images/js1.jpeg" alt="img1">
            </div>
        </a>
<h3>today's plan</h3>
    </div>
</body>
</html>








