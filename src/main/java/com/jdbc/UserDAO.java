package com.jdbc;

public interface UserDAO {
    boolean checkUser(String username, String password);

	String getUserType();
}
