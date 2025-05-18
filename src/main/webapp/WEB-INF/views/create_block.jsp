<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Create Block with Student Table</title>
  <link rel="stylesheet" href="/css/create_block.css" />
</head>

<% String message = (String) request.getAttribute("message"); %>
<% if (message != null && !message.isEmpty()) { %>
  <div id="flashMessage" style="color: green; font-weight: bold; text-align: center; margin-bottom: 1rem;">
    <%= message %>
  </div>
  <script>
    setTimeout(() => {
      const msg = document.getElementById("flashMessage");
      if (msg) {
        msg.style.display = "none";
      }
    }, 5000);
  </script>
<% } %>

<body>
  <a href="/senior_super" id="home">HOME</a>

  <div class="container">
    <h2>Create Block</h2>

    <form action="/create_block" method="POST">
      <label for="bid">Block Id:</label>
      <input type="text" id="bid" name="bid" required>

      <label for="bst">Block Strength:</label>
      <input type="text" id="bst" name="bst">

      <label for="subject">Subject:</label>
      <input type="text" id="subject" name="subject" required>

      <label for="exam_type">Exam Type:</label>
      <input type="text" id="exam_type" name="exam_type" required>

      <label for="exam_date">Exam Date:</label>
      <input type="date" id="exam_date" name="exam_date" required>

      <label for="start_time">Exam Start:</label>
      <input type="time" id="start_time" name="start_time" required>

      <label for="end_time">Exam End:</label>
      <input type="time" id="end_time" name="end_time" required>

      <label for="asjunior">Assign Junior Supervisor:</label>
      <select id="asjunior" name="asjunior">
        <option value="">Select</option>
        <%
          List<Map<String, Object>> supervisors = (List<Map<String, Object>>) request.getAttribute("supervisors");
          if (supervisors != null) {
            for (Map<String, Object> supervisor : supervisors) {
              String supervisorName = (String) supervisor.get("jsname");
              String supervisorId = (String) supervisor.get("jid");
        %>
          <option value="<%= supervisorId %>"><%= supervisorName %></option>
        <% 
            }
          }
        %>
      </select>

      <button type="button" class="btn" onclick="showStudentTable()">Add Student</button>

      <div class="table-wrapper">
        <table id="studentTable">
          <colgroup>
            <col style="width: 15%">
            <col style="width: 20%">
            <col style="width: 35%">
            <col style="width: 15%">
            <col style="width: 15%">
          </colgroup>
          <thead>
            <tr>
              <th>Roll No</th>
              <th>ERN No</th>
              <th>Name</th>
              <th>Div</th>
              <th>SELECT STUDENT</th>
            </tr>
          </thead>
          <tbody>
            <%
              List<Map<String, Object>> studentList = (List<Map<String, Object>>) request.getAttribute("student");
              if (studentList != null) {
                int index = 0;
                for (Map<String, Object> stud : studentList) {
                  int rollNo = (Integer) stud.get("roll_no");
                  String ernNo = (String) stud.get("ern");
                  String name = (String) stud.get("name");
                  String div = (String) stud.get("division");
            %>
            <tr>
              <td><input type="text" name="roll<%=index%>" value="<%= rollNo %>" title="<%= rollNo %>" /></td>
              <td><input type="text" name="ern<%=index%>" value="<%= ernNo %>" title="<%= ernNo %>" /></td>
              <td><input type="text" name="name<%=index%>" value="<%= name %>" title="<%= name %>" /></td>
              <td><input type="text" name="div<%=index%>" value="<%= div %>" title="<%= div %>" /></td>
              <td><input type="checkbox" name="selectedStudents" value="<%=index%>" /></td>
            </tr>
            <%
                  index++;
                }
              }
            %>
          </tbody>
        </table>
      </div>

      <button type="submit" class="btn" id="submitBtn">Submit</button>
    </form>
  </div>

  <script>
    function showStudentTable() {
      document.getElementById('studentTable').style.display = 'table';
      document.getElementById('submitBtn').style.display = 'block';
    }

    document.addEventListener('DOMContentLoaded', () => {
      const checkboxes = document.querySelectorAll('input[type="checkbox"][name="selectedStudents"]');
      checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', () => {
          const strengthInput = document.getElementById('bst');
          const max = parseInt(strengthInput.value);

          if (isNaN(max) || max <= 0) {
            alert("Please enter a valid Block Strength before selecting students.");
            checkbox.checked = false;
            return;
          }

          const checkedCount = Array.from(checkboxes).filter(cb => cb.checked).length;

          if (checkedCount > max) {
            alert(`You can select only ${max} student(s) based on Block Strength.`);
            checkbox.checked = false;
          }
        });
      });
    });
  </script>

</body>
</html>
