<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>

<%
    List<Map<String, Object>> blockList = (List<Map<String, Object>>) request.getAttribute("blocks");
    String message = (String) request.getAttribute("message");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Manage Blocks</title>
  <link rel="stylesheet" type="text/css" href="css/manage_block.css">
</head>
<body>

  <h2>Manage Blocks</h2>

  <% if (message != null) { %>
    <div class="message"><%= message %></div>
  <% } %>

  <table>
    <thead>
      <tr>
        <th>Actions</th>
        <th>Block ID</th>
        <th>Supervisor</th>
        <th>Subject</th>
        <th>Exam Type</th>
        <th>Exam Date</th>
        <th>Start Time</th>
        <th>End Time</th>
        <th>Strength</th>
      </tr>
    </thead>
    <tbody>
      <% if (blockList != null && !blockList.isEmpty()) {
           for (Map<String, Object> block : blockList) {
             int bid = (Integer) block.get("block_id");
             String supervisor = (String) block.get("supervisor_name");
             String subject = (String) block.get("subject");
             String examType = (String) block.get("exam_type");
             String examDate = block.get("exam_date").toString();
             String startTime = block.get("start_time").toString();
             String endTime = block.get("end_time").toString();
             int strength = (Integer) block.get("block_strength");
      %>
        <tr>
          <td>
            <form action="/delete_block" method="post" style="display:inline;" onsubmit="return confirm('Delete this block?');">
              <input type="hidden" name="block_id" value="<%= bid %>">
              <button type="submit" class="delete-btn">Delete</button>
            </form>
           
          </td>
          <td><%= bid %></td>
          <td><%= supervisor != null ? supervisor : "N/A" %></td>
          <td><%= subject %></td>
          <td><%= examType %></td>
          <td><%= examDate %></td>
          <td><%= startTime %></td>
          <td><%= endTime %></td>
          <td><%= strength %></td>
        </tr>
      <% }} else { %>
        <tr><td colspan="9">No blocks available.</td></tr>
      <% } %>
    </tbody>
  </table>

  <button class="create-btn" onclick="location.href='/create_block_page'">Create Block</button>

</body>
</html>
