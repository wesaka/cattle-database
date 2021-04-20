<?php
header('Access-Control-Allow-Origin: *');

$db_host = 'fdb30.awardspace.net'; //Should contain the "Database Host" value
$db_name = '3815023_wes'; //Should contain the "Database Name" value
$db_user = '3815023_wes'; //Should contain the "Database User" value
$db_pass = ''; //Should contain the "Database Password" value

$mysqli_connection = new MySQLi($db_host, $db_user, $db_pass, $db_name);

if ($mysqli_connection->connect_error) {
    echo "Could not connect to $db_user, error: " . $mysqli_connection->connect_error;
} else {
    echo "Connected to $db_user!";
}

$showtablequery = "SELECT * FROM owners";
$showtablequery_result = mysqli_query($mysqli_connection, $showtablequery);

while ($showtablerow = mysqli_fetch_array($showtablequery_result)) {
    echo $showtablerow[0] . "<br />";
}

$mysqli_connection->close();
echo "<hr> mysqli_connection closed!";


