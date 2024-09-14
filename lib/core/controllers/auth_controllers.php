<?php
require_once '../models/User.php';

class AuthController {
    private $userModel;

    public function __construct() {
        $this->userModel = new User();
    }

    public function signUp($data) {
        // Check if user already exists
        $existingUser = $this->userModel->getUser(['email' => $data['email']]);
        if ($existingUser) {
            return "User already exists.";
        }

        // Create a new user
        $data['password'] = password_hash($data['password'], PASSWORD_DEFAULT);
        $this->userModel->createUser($data);

        return "User created successfully.";
    }

    public function signIn($data) {
        // Find user by email
        $user = $this->userModel->getUser(['email' => $data['email']]);
        if ($user && password_verify($data['password'], $user['password'])) {
            return "Sign-In successful.";
        } else {
            return "Invalid credentials.";
        }
    }
}
?>
