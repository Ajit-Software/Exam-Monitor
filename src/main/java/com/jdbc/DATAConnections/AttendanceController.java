package com.jdbc.DATAConnections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.SessionAttribute;

import java.util.List;
import java.util.Map;

@Controller
public class AttendanceController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/attendance")
    public String showAttendanceForm(Model model, @SessionAttribute("username") String username) {
        System.out.println("Supervisor ID: " + username);

        if (username == null || username.isEmpty()) {
            return "redirect:/login"; // Redirect to login if session is missing
        }

        // SQL to fetch block info and supervisor name
        String blockInfoSql = "SELECT b.*, js.jsname " +
                              "FROM block_information b " +
                              "JOIN junior_supervisor js ON b.supervisor_id = js.jid " +
                              "WHERE b.supervisor_id = ?";

        List<Map<String, Object>> blockInfoList = jdbcTemplate.queryForList(blockInfoSql, username);

        if (!blockInfoList.isEmpty()) {
            Map<String, Object> blockInfo = blockInfoList.get(0); // first block info
            int blockId = (int) blockInfo.get("block_id");
            String blockTable = "block_" + blockId;

            // Query students in this block
            String studentSql = "SELECT ern_no AS ern, student_name AS name, status, answer_sheet_NO FROM " + blockTable;
            List<Map<String, Object>> studentList = jdbcTemplate.queryForList(studentSql);

            model.addAttribute("students", studentList);
            model.addAttribute("BlockInfo", blockInfoList); // ✅ Send list to match JSP expectation
        } else {
            model.addAttribute("error", "No block assigned to this supervisor.");
        }

        return "attendance"; // Returns attendance.jsp
    }
}
