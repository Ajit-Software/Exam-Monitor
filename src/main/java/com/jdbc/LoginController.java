package com.jdbc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    private UserService userService;

    // Handle GET request to show the login page
    @GetMapping("/")
    public String showLoginPage() {
        return "login"; // Ensure login.jsp exists in WEB-INF/views/
    }

    // Handle POST request for login
    @PostMapping("/login")
    public String login(@RequestParam String username, 
                        @RequestParam String password, 
                        Model model,
                        HttpSession session) { // Add HttpSession here

        boolean isValid = userService.validateUser(username, password);

        if (isValid) {
            String userType = userService.getUserType();

            // Save to session
            session.setAttribute("username", username);
            session.setAttribute("type", userType);

            // Optionally still pass to model if needed for JSP
            model.addAttribute("username", username);
            model.addAttribute("type", userType);

            if ("Suppervisor".equals(userType)) {
                return "SuppHome"; // or redirect:/SuppHome if using mapping
            }

            return "home";
        } else {
            model.addAttribute("error", "Invalid Credentials");
            return "login";
        }
    }

}
