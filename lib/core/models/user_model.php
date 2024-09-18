<?php
require_once '../config/db.php';

class User {
    private $conn;
    private $collection;

    public function __construct() {
        $database = new Database();
        $this->conn = $database->getConnection();
    }

    public function createUser($data) {
        try {
            $this->collection->insertOne($data);
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    public function getUser($filter) {
        try {
            $result = $this->collection->findOne($filter);
            return $result;
        } catch (Exception $e) {
            return null;
        }
    }

    public function updateUser($filter, $data) {
        try {
            $this->collection->updateOne($filter, ['$set' => $data]);
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    public function deleteUser($filter) {
        try {
            $this->collection->deleteOne($filter);
            return true;
        } catch (Exception $e) {
            return false;
        }
    }
}
?>
