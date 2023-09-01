<?php
header('Content-Type: application/json');
$db_name = "clientonboarding";
$db_server = "localhost";
$db_user = "root";
$db_pass = "";

$db = new PDO("mysql:host={$db_server};dbname={$db_name};charset=utf8", $db_user, $db_pass);
$db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

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
