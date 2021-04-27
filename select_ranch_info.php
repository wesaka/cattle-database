<?php

header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

// takes raw data from the request
$json = file_get_contents('php://input');

// Converts it into a PHP object
$data = json_decode($json, true);

// Get if we are dealing with local or production database
$db_url = $_SERVER['HTTP_HOST'];
$db_host = 'localhost'; //Should contain the "Database Host" value
$db_name = '3815023_wes'; //Should contain the "Database Name" value
$db_user = 'root'; //Should contain the "Database User" value
$db_pass = ''; //Should contain the "Database Password" value

if (strpos($db_url, 'localhost') === false) {
    $db_host = 'localhost';
    $db_name = 'id16605669_cattle';
    $db_user = 'id16605669_admin';
    $db_pass = 'hF1XqJad2pUC}NNm'; // I'll leave this as plaintext as this is a disposable database really
}

$mysqli_connection = new MySQLi($db_host, $db_user, $db_pass, $db_name);

if ($mysqli_connection->connect_error) {
    echo "Could not connect to $db_name, error: " . $mysqli_connection->connect_error;
    return;
}
$uid = $data['uid'];
$cattle_info_result = mysqli_query($mysqli_connection, "SELECT * FROM ranches WHERE owner = $uid");
echo json_encode(mysqli_fetch_assoc($cattle_info_result));


