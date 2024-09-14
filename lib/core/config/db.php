<?php
require 'vendor/autoload.php'; // Autoload Composer dependencies

class Database {
    private $host = "cluster0.mongodb.net"; // Replace with your MongoDB host
    private $db_name = "mentalease_db"; // Replace with your database name
    private $username = "your_username"; // Replace with your MongoDB username
    private $password = "your_password"; // Replace with your MongoDB password
    public $conn;

    public function getConnection() {
        $this->conn = null;

        try {
            // MongoDB Atlas connection string
            $connectionString = "mongodb+srv://atlas-sql-66cc083c37711e2fd5f7af5e-zc10l.a.query.mongodb.net/mentaleasedb2?ssl=true&authSource=admin{$this->username}:{$this->password}@{$this->host}/{$this->db_name}?retryWrites=true&w=majority";
            
            // For local MongoDB instance, use the below connection string
            // $connectionString = "mongodb://localhost:27017/{$this->db_name}";

            $this->conn = new MongoDB\Client($connectionString);
        } catch (MongoDB\Driver\Exception\Exception $e) {
            echo "Connection error: " . $e->getMessage();
            exit;
        }

        return $this->conn;
    }
}
?>
