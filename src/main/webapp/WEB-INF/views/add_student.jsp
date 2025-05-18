<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Student</title>
    <link rel="stylesheet" href="/css/add_student.css">
</head>
<body>
	<div class="nav">
	        <a href="/home" alt="HOME">HOME</a>
	    </div>
		
    <div class="container">
        <div class="right-panel">
            <form action="/add_student1" method="POST">

                <label>Student Name:</label>
                <input type="text" name="name" required />

                <label>Class:</label>
                <input type="text" name="studentClass" required />

                <label>Division:</label>
                <input type="text" name="division" required />

                <label>ERN:</label>
                <input type="text" name="ern" required />
				<label for="email">Email:</label>
				<input type="email" id="email" name="mail" required />


                <br><br>
                <button type="submit" class="submit">Submit</button>
            </form>
        </div>
    </div>

	<% if (request.getAttribute("message") != null) { %>
	    <script>alert("<%= request.getAttribute("message") %>");</script>
	<% } else if (request.getAttribute("fail") != null) { %>
	    <script>alert("<%= request.getAttribute("fail") %>");</script>
	<% } %>
</body>

</html>
