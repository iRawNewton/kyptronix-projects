<?php
header('Content-Type: application/json');
include "../FlutterApi/db.php";

$res = $db->prepare("SELECT id, cli_name FROM cli_dev");
$res->execute();
$result = $res->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($result);


