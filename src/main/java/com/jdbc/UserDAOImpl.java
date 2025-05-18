package com.jdbc;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class UserDAOImpl implements UserDAO {
    
	String user_type;
	@Override
	public String getUserType() {
	    return user_type;
	}


	

	@Autowired
    private JdbcTemplate jdbcTemplate;
    
   
    @Override
    public boolean checkUser(String username, String password) {
        try {
        	String sql = "SELECT user_type FROM users WHERE username = ? AND password = ?";
        	Map<String, Object> user = jdbcTemplate.queryForMap(sql, username, password);

            
            // Set user_type for later retrieval
            user_type = (String) user.get("user_type");

            return true; // User found
        } catch (Exception e) {
            return false; // No user found
        }
    }

}