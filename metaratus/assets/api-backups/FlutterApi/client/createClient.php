<?php
header('Content-Type: application/json');

$db_name = "clientonboarding";
$db_server = "localhost";
$db_user = "root";
$db_pass = "";

$db = new PDO("mysql:host={$db_server};dbname={$db_name};charset=utf8", $db_user, $db_pass);
$db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

// if(isset($_POST[]!='')){
$id = $_POST['cli_userid'];
$pass =  $_POST['cli_pass'];
$name = $_POST['cli_name'];
$email =  $_POST['cli_email'];
$phone = $_POST['cli_phone'];


$stmt = $db->prepare("INSERT INTO cli_client_table (cli_userid, cli_pass, cli_name, cli_email, cli_phone) VALUES (?, ?, ?, ?, ?)");
$result = $stmt->execute([$id, $pass, $name, $email, $phone]);

echo json_encode([
'success' => $result
]);
// }