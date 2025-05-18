package com.jdbc;

public interface UserService {
    boolean validateUser(String username, String password);
    String getUserType();
}
