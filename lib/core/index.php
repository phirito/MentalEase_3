<?php
require_once 'controllers/AuthController.php';

$authController = new AuthController();

$requestMethod = $_SERVER["REQUEST_METHOD"];
$path = explode("/", trim($_SERVER['PATH_INFO'], "/"));

// Route the requests
if ($requestMethod == 'POST' && $path[0] == 'signup') {
    $data = json_decode(file_get_contents("php://input"), true);
    $response = $authController->signUp($data);
    echo json_encode(['message' => $response]);

} elseif ($requestMethod == 'POST' && $path[0] == 'signin') {
    $data = json_decode(file_get_contents("php://input"), true);
    $response = $authController->signIn($data);
    echo json_encode(['message' => $response]);

} else {
    echo json_encode(['message' => 'Invalid request']);
}
?>
