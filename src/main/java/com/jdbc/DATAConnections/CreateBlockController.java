package com.jdbc.DATAConnections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.Map;

@Controller
public class CreateBlockController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private JavaMailSender mailSender;

    // GET: Show Create Block Form
    @GetMapping("/create_block_page")
    public String showCreateBlockPage(Model model, @ModelAttribute("message") String message) {
        String sql = "SELECT jsname, jid FROM junior_supervisor";
        List<Map<String, Object>> supervisors = jdbcTemplate.queryForList(sql);
        String sql1 = "SELECT * FROM student ORDER BY roll_no ASC";

        List<Map<String, Object>> student = jdbcTemplate.queryForList(sql1);
        model.addAttribute("student", student);
        model.addAttribute("supervisors", supervisors);

        if (message != null && !message.isEmpty()) {
            model.addAttribute("message", message);
        }

        return "create_block"; // JSP page
    }

    // POST: Handle Form Submission
    @PostMapping("/create_block")
    public RedirectView createBlock(
            @RequestParam("bid") String blockId,
            @RequestParam("subject") String subject,
            @RequestParam("exam_type") String examType,
            @RequestParam("exam_date") String examDate,
            @RequestParam("start_time") String startTime,
            @RequestParam("end_time") String endTime,
            @RequestParam("bst") String blockStrength,
            @RequestParam("asjunior") String supervisorId,
            @RequestParam(value = "selectedStudents", required = false) String[] selectedIndexes,
            @RequestParam Map<String, String> allParams,
            RedirectAttributes redirectAttributes) {

        try {
            int parsedBlockId = Integer.parseInt(blockId);
            int parsedBlockStrength = Integer.parseInt(blockStrength);
            Date sqlExamDate = Date.valueOf(examDate);
            Time sqlStartTime = Time.valueOf(startTime + ":00");
            Time sqlEndTime = Time.valueOf(endTime + ":00");

            // Check if block ID exists
            String checkBlockSQL = "SELECT COUNT(*) FROM Block_Information WHERE block_id = ?";
            Integer blockCount = jdbcTemplate.queryForObject(checkBlockSQL, Integer.class, parsedBlockId);
            if (blockCount != null && blockCount > 0) {
                redirectAttributes.addFlashAttribute("message", "Error: Block with ID " + blockId + " already exists!");
                return new RedirectView("/create_block_page");
            }

            // Insert into Block_Information
            String insertSQL = "INSERT INTO Block_Information " +
                    "(block_id, supervisor_id, subject, exam_type, exam_date, start_time, end_time, block_strength) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            jdbcTemplate.update(insertSQL, parsedBlockId, supervisorId, subject, examType, sqlExamDate, sqlStartTime, sqlEndTime, parsedBlockStrength);

            // Create block table
            String blockTableName = "Block_" + blockId;
            String createTableSQL = "CREATE TABLE IF NOT EXISTS " + blockTableName + " (" +
                    "student_id INT PRIMARY KEY AUTO_INCREMENT, " +
                    "student_name VARCHAR(100), " +
                    "roll_number INT, " +
                    "ern_no VARCHAR(20), " +
                    "block_id INT, " +
                    "status VARCHAR(5) DEFAULT 'A', " +
                    "answer_sheet_NO VARCHAR(225), " +
                    "FOREIGN KEY (block_id) REFERENCES Block_Information(block_id))";
            jdbcTemplate.execute(createTableSQL);

            // Insert students & send emails
            if (selectedIndexes != null) {
            	int seatNumber=1;
                for (String idx : selectedIndexes) {
                    String name = allParams.get("name" + idx);
                    String roll = allParams.get("roll" + idx);
                    String ern = allParams.get("ern" + idx);
                    String status = allParams.getOrDefault("status" + idx, "A");

                    // Insert into block table
                    String insertStudentSQL = "INSERT INTO " + blockTableName + " " +
                            "(student_name, roll_number, ern_no, block_id, status) VALUES (?, ?, ?, ?, ?)";
                    jdbcTemplate.update(insertStudentSQL, name, Integer.parseInt(roll), ern, parsedBlockId, status);

                    // Send email inside try-catch using for-each
                    try {
                    	
                        String emailQuery = "SELECT mail FROM student WHERE ern = ?";
                        String email = jdbcTemplate.queryForObject(emailQuery, String.class, ern);

                        SimpleMailMessage message = new SimpleMailMessage();
                        message.setFrom("examcell.dyp@gmail.com"); // ✅ use your email
                        message.setTo(email);
                        message.setSubject("Block Assignment for Exam");

                        String emailBody = String.format(
                            "Hello %s,\n\n" +
                            "You have been assigned to the following exam block:\n" +
                            		"Seat Number: %d\n"+
                            "Block ID: %s\n" +
                            
                            "Subject: %s\n" +
                            "Exam Type: %s\n" +
                            "Date: %s\n" +
                            "Time: %s to %s\n\n" +
                            "Please be present 15 minutes before the exam.\n\n" +
                            "All The Best !\n"+
                            "Regards,\nExam Cell",
                            name, seatNumber ,blockId, subject, examType, examDate, startTime, endTime
                        );

                        message.setText(emailBody);
                        mailSender.send(message);
                        

                    } catch (Exception mailEx) {
                        System.out.println("❌ Failed to send email to ERN: " + ern + ". Reason: " + mailEx.getMessage());
                    }
                    
                    seatNumber++;
                }
            }

                
            

            redirectAttributes.addFlashAttribute("message", "Block created, students added, and emails sent!");

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("message", "Error: " + e.getMessage());
        }

        return new RedirectView("/create_block_page");
    }
}
