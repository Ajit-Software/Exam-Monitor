package com.jdbc;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/qr")
@CrossOrigin(origins = "*")
public class QRCodeReceiverController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/save")
    public ResponseEntity<String> saveQRCode(@RequestBody Map<String, String> payload) {
        String qrData = payload.get("data");
        String blockId = payload.get("blockId");

        System.out.println("Received QR Code: " + qrData);
        System.out.println("Received Block ID: " + blockId);

        if (!blockId.matches("\\d+")) {
            return ResponseEntity.badRequest().body("Invalid block ID.");
        }

        String tableName = "block_" + blockId;
        String selectSql = "SELECT student_name FROM " + tableName + " WHERE ern_no = ?";

        String studentName = jdbcTemplate.execute(selectSql, (PreparedStatement ps) -> {
            ps.setString(1, qrData);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("student_name");
                } else {
                    return null;
                }
            }
        });

        if (studentName == null) {
            return ResponseEntity.status(404).body("No student found with ERN: " + qrData);
        }

        String updateSql = "UPDATE " + tableName + " SET status = 'P' WHERE ern_no = ?";
        int updatedRows = jdbcTemplate.update(updateSql, qrData);

        if (updatedRows > 0) {
            return ResponseEntity.ok("Marked Present: " + studentName);
        } else {
            return ResponseEntity.status(500).body("Student found, but status not updated.");
        }
    }

    
    
    @PostMapping("/assign")
    public ResponseEntity<String> assignAnswerSheet(@RequestBody Map<String, String> payload) {
        String ern = payload.get("ern");
        String answerSheet = payload.get("answerSheet");
        String blockId = payload.get("blockId");

        if (!blockId.matches("\\d+")) {
            return ResponseEntity.badRequest().body("Invalid block ID.");
        }

        // Check if scanned answer sheet starts with EN — likely an ERN, not a valid answer sheet
        if (answerSheet != null && answerSheet.startsWith("EN")) {
            return ResponseEntity.badRequest().body("Invalid QR: Please scan the answer sheet QR code, not the student ERN.");
        }

        String tableName = "block_" + blockId;

        String updateSql = "UPDATE " + tableName + " SET answer_sheet_NO = ? WHERE ern_no = ?";
        int updatedRows = jdbcTemplate.update(updateSql, answerSheet, ern);

        if (updatedRows > 0) {
            return ResponseEntity.ok("Answer sheet QR assigned to student " + ern);
        } else {
            return ResponseEntity.ok("Failed to assign answer sheet QR.");
        }
    }

    

}
