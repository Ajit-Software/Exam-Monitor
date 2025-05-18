package com.jdbc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Map;

@Controller
public class MailViewController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private JavaMailSender mailSender;

    @GetMapping("/mail-form")
    public String showMailForm() {
        return "sendMail";
    }

    @PostMapping("/students/send_mail")
    public String sendMail(@RequestParam String ern, Model model) {
        try {
            // Get student email and name from DB based on ERN
            Map<String, Object> result = jdbcTemplate.queryForMap(
                "SELECT mail, name FROM student WHERE ern = ?", ern
            );

            String mail = (String) result.get("mail");
            String name = (String) result.get("name");

            if (mail == null || mail.isEmpty()) {
                model.addAttribute("message", "No email found for ERN: " + ern);
                return "sendMail";
            }

            sendEmailUsingGmail("vikrantkamble2803@gmail.com", name, model);

        } catch (Exception e) {
            e.printStackTrace();  // Logs the full stack trace
            model.addAttribute("message", "Error: " + e.getMessage());
        }

        return "sendMail";
    }

    private void sendEmailUsingGmail(String toEmail, String name, Model model) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom("ajitkasabe114@gmail.com");  // Must match your Gmail username
            message.setTo(toEmail);
            message.setSubject("Hello " + name);
            message.setText("Dear " + name + ",\n\nThis is a test email from your Spring Boot application.");

            mailSender.send(message);

            model.addAttribute("message", "Email sent successfully to " + toEmail);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", "Error sending email: " + e.getMessage());
        }
    }
}
