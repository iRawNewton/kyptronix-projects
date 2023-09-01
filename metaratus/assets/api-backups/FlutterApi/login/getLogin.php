<?php
header('Content-Type: application/json');
include "../FlutterApi/db.php";


$id = $_POST['cli_id'];
$pass =  $_POST['cli_pass'];
$id = $_POST['1001'];
$pass =  $_POST['root'];

$stmt = $db->prepare("SELECT * FROM cli_client_table WHERE cli_id = ?, and cli_pass = ?,");
$result = $stmt->execute([$id, $pass ]);

echo json_encode([
'success' => $result
]);