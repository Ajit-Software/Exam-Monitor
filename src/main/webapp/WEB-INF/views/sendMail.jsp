<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Send Mail to Student</title>
</head>
<body>
    <h2>Send Email to Student</h2>

    <form action="/students/send_mail" method="post">
        <label for="ern">Enter ERN:</label>
        <input type="text" id="ern" name="ern" required>
        <br><br>
        <input type="submit" value="Send Email">
    </form>

    <br>
    <p>${message}</p>
</body>
</html>
