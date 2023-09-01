<?php
header('Content-Type: application/json');
include "../FlutterApi/db.php";

$id = $_POST['cli_id'];
$pass = $_POST['cli_pass'];
$name = (int) $_POST['cli_name'];
$email = $_POST['cli_email'];
$phone = $_POST['cli_phone'];
$project_name = (int) $_POST['cli_project_name'];
$project_desc = $_POST['cli_project_desc'];

$stmt = $db->prepare("UPDATE cli_client_table SET cli_pass = ?, cli_name = ?, cli_email = ?, cli_phone = ?, cli_project_name = ?, cli_project_desc WHERE cli_id = ?");
$result =  $stmt->execute([$pass, $name, $email, $phone, $project_name, $project_desc]);

echo json_encode([
'success' => $result
]);