package com.jdbc.DATAConnections;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class StudentController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @GetMapping("/add_student")
    public String showForm() {
        return "add_student"; // Return the JSP page for the form
    }

    @PostMapping("/add_student1")
    public String submitForm(@RequestParam("name") String name,
                             @RequestParam("studentClass") String studentClass,
                             @RequestParam("division") String division,
                             @RequestParam("ern") String ernStr,
                             @RequestParam("mail") String mail,
                             Model model) {
        try {
            // Optional: validate ERN format if needed
            if (ernStr.length()>10 || ernStr.length()<10 ) {
                model.addAttribute("fail", "ERN must be 10 digit valid number.");
                return "add_student";
            }

            // Optional: validate division length
            if (division.length() > 1) {
                model.addAttribute("fail", "Division must be a single character.");
                return "add_student";
            }

            // Insert the student data into the database
            String sql = "INSERT INTO student (ern, name, class, division,mail) VALUES (?, ?, ?, ?,?)";
            jdbcTemplate.update(sql, ernStr, name, studentClass, division,mail);

            model.addAttribute("message", "Student added successfully!");
        } catch (Exception e) {
            model.addAttribute("fail", "Error while adding student: " + e.getMessage());
        }

        return "add_student"; // Always return to the form page
    }
}

