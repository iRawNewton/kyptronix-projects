<?php
header('Content-Type: application/json');
include "../FlutterApi/db.php";

$id = (int) $_POST['cli_id'];
$stmt = $db->prepare("DELETE FROM cli_client_table WHERE cli_id = ?");
$result = $stmt->execute([$id]);

echo json_encode([
'cli_id' => $id,
'success' => $result
]);