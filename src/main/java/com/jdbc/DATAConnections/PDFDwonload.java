package com.jdbc.DATAConnections;

import java.util.List;
import java.util.Map;

import com.itextpdf.text.Document;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.PdfPTable;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class PDFDwonload {
	
	 @GetMapping("/download")
	 public String showReportPage() {
     return "download_report";
    // maps to /WEB-INF/view/create_block.jsp
	    }

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/download_pdf")
    public String downloadPDF(
            HttpServletRequest request,
            HttpServletResponse response,
            @RequestParam("blockId") int blockId,
            @RequestParam("date") String examDate,
            Model model
    ) throws Exception {

    	String sql = "SELECT bi.*, js.jsname " +
                "FROM block_information bi " +
                "LEFT JOIN junior_supervisor js ON bi.supervisor_id = js.jid " +
                "WHERE bi.block_id = ? AND bi.exam_date = ?";
   List<Map<String, Object>> blockInfoList = jdbcTemplate.queryForList(sql, blockId, examDate);

        if (blockInfoList.isEmpty()) {
            model.addAttribute("error", "No block information found for Block ID: " + blockId + " on " + examDate);
            return "download_report";
        }

        String blockTableName = "block_" + blockId;
        List<Map<String, Object>> students;
        try {
            String studentSql = "SELECT ern_no, student_name, roll_number, status ,answer_sheet_NO FROM " + blockTableName;
            students = jdbcTemplate.queryForList(studentSql);
        } catch (Exception e) {
            model.addAttribute("error", "Student table for Block ID " + blockId + " does not exist.");
            return "download_report";
        }

        if (students.isEmpty()) {
            model.addAttribute("error", "No students found in Block ID: " + blockId);
            return "download_report";
        }

        // Generate PDF if everything is valid
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=attendance_report.pdf");

        Map<String, Object> blockInfo = blockInfoList.get(0);
        String supervisorName = blockInfo.get("jsname") != null ? blockInfo.get("jsname").toString() : "__________________";

        String subject = (String) blockInfo.get("subject");
        String examType = (String) blockInfo.get("exam_type");
        String startTime = String.valueOf(blockInfo.get("start_time"));
        String endTime = String.valueOf(blockInfo.get("end_time"));
        int strength = (int) blockInfo.get("block_strength");

        Document document = new Document();
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();
       
        document.add(new Paragraph("Exam Report"));
        document.add(new Paragraph("Suppervisor Name: " +supervisorName));

        document.add(new Paragraph("Block ID: " + blockId));
        document.add(new Paragraph("Subject: " + subject));
        document.add(new Paragraph("Exam Type: " + examType));
        document.add(new Paragraph("Exam Date: " + examDate));
        document.add(new Paragraph("Time: " + startTime + " - " + endTime));
        document.add(new Paragraph("Block Strength: " + strength));
        document.add(new Paragraph(" "));

        PdfPTable table = new PdfPTable(6); // 6 columns
        table.setWidths(new float[] {1, 4, 2, 3, 2, 4}); // Adjust as needed

        table.addCell("SR. NO");
       
        table.addCell("Name");
        table.addCell("Roll_No");
        table.addCell("ERN");
        table.addCell("status");
        table.addCell("Answer_Sheet");

        int count = 1;
        for (Map<String, Object> student : students) {
            table.addCell(String.valueOf(count));
           
            table.addCell(student.get("student_name").toString());
            table.addCell(student.get("roll_number").toString());
            table.addCell(student.get("ern_no").toString());
            table.addCell(student.get("status").toString());
            table.addCell(student.get("answer_sheet_NO") != null ? student.get("answer_sheet_NO").toString() : "-");
            count++;
        }

        document.add(table);
        
        document.add(new Paragraph(" ")); // Add some spacing
        Paragraph signature = new Paragraph("\n\n\nSupervisor Signature");
        signature.setAlignment(Paragraph.ALIGN_RIGHT);
        document.add(signature);

        document.close();

        return null; // PDF was written directly to response
    }

//    @GetMapping("/download_report")
//    public String showReportPage() {
//        return "download_report";
//    }
}
