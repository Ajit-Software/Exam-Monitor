package com.jdbc;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService {
    
    @Autowired
    private UserDAO userDAO;

   // @Override
    public boolean validateUser(String username, String password) {
        return userDAO.checkUser(username, password);
    }

   // @Override
    public String getUserType() {
        return userDAO.getUserType();
    }

}
