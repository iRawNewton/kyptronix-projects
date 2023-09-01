<?php
header('Content-Type: application/json');
include "../FlutterApi/db.php";

$res = $db->prepare("SELECT cli_userid, cli_pass, cli_name, cli_email, cli_phone, cli_project_name, cli_project_desc FROM cli_client_table");
$res->execute();
$result = $res->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($result);


