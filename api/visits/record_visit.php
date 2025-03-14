<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

// Get posted data
$data = json_decode(file_get_contents("php://input"));

if (!isset($data->store_id) || !isset($data->action_type)) {
    http_response_code(400);
    echo json_encode(array("message" => "Missing required data"));
    exit();
}

$query = "INSERT INTO patient_visits 
            (store_id, session_id, user_ip, user_agent, action_type) 
          VALUES 
            (:store_id, :session_id, :user_ip, :user_agent, :action_type)";

try {
    $stmt = $db->prepare($query);
    
    // Generate session ID if not provided
    $session_id = isset($data->session_id) ? $data->session_id : session_id();
    
    $stmt->bindParam(":store_id", $data->store_id);
    $stmt->bindParam(":session_id", $session_id);
    $stmt->bindParam(":user_ip", $_SERVER['REMOTE_ADDR']);
    $stmt->bindParam(":user_agent", $_SERVER['HTTP_USER_AGENT']);
    $stmt->bindParam(":action_type", $data->action_type);

    if($stmt->execute()) {
        http_response_code(201);
        echo json_encode(array("message" => "Visit recorded successfully"));
    } else {
        http_response_code(503);
        echo json_encode(array("message" => "Unable to record visit"));
    }
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Database error: " . $e->getMessage()));
}
?>