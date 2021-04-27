<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PATCH, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Origin, Content-Type, X-Auth-Token');

// takes raw data from the request
$json = file_get_contents('php://input');

// Converts it into a PHP object
$data = json_decode($json, true);

// Get if we are dealing with local or production database
$db_url = $data['db_url'];
unset($data['db_url']);
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
$buyer = $data['buyer'];
$date = '\''.$data['date'].'\'';
$price = $data['price'];

$result = mysqli_query($mysqli_connection, "SELECT (SELECT UID from owners WHERE username = '$buyer') AS buyerId, (SELECT owner FROM cattle WHERE UID = $uid) AS sellerId");

if ($result){
    $row = mysqli_fetch_assoc($result);
    $buyer_id = $row['buyerId'];
    $seller_id = $row['sellerId'];

    // Insert the transation into the sold table and update the new owner in the cattle table
    $result_sell = mysqli_query($mysqli_connection, "INSERT INTO sold(cattle_uid, seller_uid, buyer_uid, price, date) VALUES($uid, $seller_id, $buyer_id, $price, $date)" );
    if ($result_sell) {
        echo 1;
    } else {
        echo $result;
        echo 0;
    }
} else {
    echo 0;
}
//
//if ($mysqli_connection->query("INSERT INTO cattle($keysString) VALUES ($valuesString)")) {
//    $owner = $data['owner'];
//    $cattle_info_result = mysqli_query($mysqli_connection, "SELECT UID, tag FROM cattle WHERE owner = $owner");
//    $cattle_array = array();
//
//    while ($row = mysqli_fetch_assoc($cattle_info_result)) {
//        array_push($cattle_array, $row);
//    }
//
//    echo json_encode($cattle_array);
//} else {
//    echo 0;
//}