<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once '../config/database.php';

$database = new Database();
$db = $database->getConnection();

// Get posted data
$data = json_decode(file_get_contents("php://input"));

if (!isset($data->latitude) || !isset($data->longitude)) {
    http_response_code(400);
    echo json_encode(array("message" => "Missing latitude or longitude"));
    exit();
}

$latitude = floatval($data->latitude);
$longitude = floatval($data->longitude);
$radius = 10; // 10 miles radius

// Haversine formula to calculate distance
$query = "SELECT 
            store_id,
            name,
            contact_number,
            address,
            city,
            country,
            latitude,
            longitude,
            (
                3959 * acos(
                    cos(radians(:latitude)) * 
                    cos(radians(latitude)) * 
                    cos(radians(longitude) - radians(:longitude)) + 
                    sin(radians(:latitude)) * 
                    sin(radians(latitude))
                )
            ) AS distance 
          FROM stores 
          WHERE status = 'active'
          HAVING distance < :radius 
          ORDER BY distance";

try {
    $stmt = $db->prepare($query);
    $stmt->bindParam(":latitude", $latitude);
    $stmt->bindParam(":longitude", $longitude);
    $stmt->bindParam(":radius", $radius);
    $stmt->execute();

    $stores = array();
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $store = array(
            "id" => $row['store_id'],
            "name" => $row['name'],
            "contact" => $row['contact_number'],
            "address" => $row['address'],
            "city" => $row['city'],
            "country" => $row['country'],
            "latitude" => $row['latitude'],
            "longitude" => $row['longitude'],
            "distance" => round($row['distance'], 2)
        );
        array_push($stores, $store);
    }

    http_response_code(200);
    echo json_encode($stores);
} catch(PDOException $e) {
    http_response_code(500);
    echo json_encode(array("message" => "Database error: " . $e->getMessage()));
}
?>