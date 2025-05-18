<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Exam Records Management</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        html, body {
            height: 100%;
        }
        .login-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            background-color: #f5f5f5;
        }
        .form-signin {
            width: 100%;
            max-width: 400px;
            padding: 15px;
            margin: auto;
        }
        .form-signin .card {
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
        }
        .form-signin .card-body {
            padding: 2rem;
        }
        .form-signin .form-floating {
            margin-bottom: 1rem;
        }
        .brand-logo {
            width: 300px;
            height: 100px;
            margin-bottom: 1.5rem;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <main class="form-signin">
            <div class="card">
                <div class="card-body">
                    <div class="text-center mb-4">
                        <img class="brand-logo" src="/images/loginlogo.jpg" alt="Logo" th:src="@{/images/loginlogo.jpg}">
                        <h1 class="h3 mb-3 fw-normal">Login</h1>
                    </div>
                    
                   <form action="login" method="post">
                        <div class="form-floating">
                            <input type="text" class="form-control" id="username" name="username" placeholder="Username" required>
                            <label for="username">Username</label>
                        </div>
                        
                        <div class="form-floating">
                            <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                            <label for="password">Password</label>
                        </div>

                        <div class="form-check text-start my-3">
                            <input class="form-check-input" type="checkbox" id="remember-me" name="remember-me">
                            <label class="form-check-label" for="remember-me">
                                Remember me
                            </label>
                        </div>

						
						
						<div th:if="${param.error}" class="alert alert-danger fadeout-alert" role="alert">
						    Invalid username or password
						</div>

						<style>
						@keyframes fadeout {
						    0%   { opacity: 1; }
						    80%  { opacity: 1; }
						    100% { opacity: 0; display: none; }
						}

						.fadeout-alert {
						    animation: fadeout 3s forwards;
						}
						</style>

                        <button class="w-100 btn btn-lg btn-primary" type="submit">Sign in</button>
                    </form>
                </div>
            </div>
        </main>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 
























