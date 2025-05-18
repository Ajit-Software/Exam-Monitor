package com.jdbc.DATAConnections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class JuniorSupervisorController {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    @GetMapping("/register_js")
    public String showForm() {
        return "register_js"; // Return the JSP page for the form
    }

    
    
    @PostMapping("/register_js")
    public String submitForm(@RequestParam("jsname") String jsname,
                             @RequestParam("jid") String jid,
                             @RequestParam("jpassword") String jpassword,
                             Model model) {
        try {
            // Simple email format validation
        	if (!jid.matches("^[A-Za-z0-9._%+-]+@gmail\\.com$")) {
        	    model.addAttribute("fail", "Only Gmail addresses are allowed.");
        	    return "register_js";
        	}


            // Optional: check password not empty or too weak
            if (jpassword.length() < 6) {
                model.addAttribute("fail", "Password must be at least 6 characters.");
                return "register_js";
            }

            String sql = "INSERT INTO junior_supervisor (jid, jsname, jpassword) VALUES (?, ?, ?)";
            String sql1 = "INSERT INTO users (username, password, user_type) VALUES (?, ?, ?)";

            jdbcTemplate.update(sql1, jid, jpassword, "Suppervisor");
            jdbcTemplate.update(sql, jid, jsname, jpassword);

            model.addAttribute("message", "Junior Supervisor registered successfully!");
        } catch (Exception e) {
            model.addAttribute("fail", "Error while registering: " + e.getMessage());
        }

        return "register_js";
    }
}