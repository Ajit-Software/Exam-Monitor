package com.jdbc;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


//import com.itextpdf.text.List;


@Controller
public class ViewController {
//
//	@GetMapping("/attendance")
//    public String goToAttendance() {
//        return "attendance"; // maps to /WEB-INF/view/create_block.jsp
//    }
	
	 @Autowired
	    private JdbcTemplate jdbcTemplate;
	 
	 
	 
	 
	 
	 
	 
	 
	

	     // ... your @GetMapping("/manage_block") method here ...

	     @PostMapping("/delete_block")
	     public String deleteBlock(@RequestParam("block_id") int blockId,
	                               RedirectAttributes redirectAttrs) {
	         // Delete the block
	    	 String sql1 = "DROP table block_"+blockId;
	          jdbcTemplate.execute(sql1); 
	         String sql2 = "DELETE FROM block_information WHERE block_id = ?";
	         int rows = jdbcTemplate.update(sql2, blockId);

	         // Feedback message
	         if (rows > 0) {
	             redirectAttrs.addFlashAttribute("message", 
	                 "Block " + blockId + " deleted successfully.");
	         } else {
	             redirectAttrs.addFlashAttribute("message", 
	                 "No block found with ID " + blockId + ".");
	         }

	         // Redirect back to the manage page
	         return "redirect:/manage_block";
	     }
	 

	 @GetMapping("/manage_block")
	 public String showManageBlockPage(Model model) {
		 String sql = """
				    SELECT 
				        b.block_id, b.subject, b.exam_type, b.exam_date, b.start_time, b.end_time, b.block_strength,
				        b.supervisor_id,
				        js.jsname AS supervisor_name,
				        
				        js.jid AS supervisor_jid
				    FROM block_information b
				    JOIN junior_supervisor js ON b.supervisor_id = js.jid
				    ORDER BY b.block_id ASC
				""";
	     List<Map<String, Object>> blocks = jdbcTemplate.queryForList(sql);
	     model.addAttribute("blocks", blocks);
	     return "manage_block"; // JSP or Thymeleaf view name
	 }



	
//	@GetMapping("/manage_block")
//	public String showManageBlockPage() {
//	    return "manage_block"; // refers to manage_block.jsp
//	}

	@GetMapping("/delete_block_page")
	public String showDeleteBlockPage(Model model) {
	    // Add blocks to model if needed
	    return "delete_block"; // create delete_block.jsp accordingly
	}

	

	    @GetMapping("/scan")
	    public String showScannerPage() {
	        return "scan"; // Maps to /WEB-INF/views/qrscanner.jsp
	    }
	

	
	 @GetMapping("/home")
	    public String goToHome() {
	        return "home"; // maps to /WEB-INF/view/create_block.jsp
	    }
	
	
//    @GetMapping("/create_block_page")
//    public String getCreateBlock() {
//        return "create_block"; // maps to /WEB-INF/view/create_block.jsp
//    }
    
    @GetMapping("/senior_super")
    public String getSenior_super_Home() {
        return "home"; // maps to /WEB-INF/view/create_block.jsp
    }
    
//    @GetMapping("/download")
//    public String getReport() {
//        return "download_report"; // maps to /WEB-INF/view/create_block.jsp
//    }
    
    
//    @GetMapping("/add_student")
//    public String getstudent() {
//        return "add_student"; // maps to /WEB-INF/view/create_block.jsp
//    }
    
//    @GetMapping("/register_js")
//    public String add_JS() {
//        return "register_js"; // maps to /WEB-INF/view/create_block.jsp
//        
//        
//        
//    }
        
    @GetMapping("/download_report")
    public String download_Report() {
        return "download_report"; // maps to /WEB-INF/view/create_block.jsp
        
        
        
    }
    
    
}

