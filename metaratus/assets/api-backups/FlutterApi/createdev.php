<?php
header('Content-Type: application/json');
include "../FlutterApi/db.php";

$username = $_POST['cli_username'];
$password =  $_POST['cli_password'];
$name = $_POST['cli_name'];
$phone = $_POST['cli_phone'];
$email =  $_POST['cli_email'];

$stmt = $db->prepare("INSERT INTO cli_dev (cli_username, cli_password, cli_name, cli_phone, cli_email) VALUES (?, ?, ?, ?, ?)");
$result = $stmt->execute([$username, $password, $name, $phone, $email]);

echo json_encode([
'success' => $result
]);
