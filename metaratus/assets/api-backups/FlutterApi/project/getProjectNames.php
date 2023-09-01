<?php
header('Content-Type: application/json');
$db_name = "clientonboarding";
$db_server = "localhost";
$db_user = "root";
$db_pass = "";

$db = new PDO("mysql:host={$db_server};dbname={$db_name};charset=utf8", $db_user, $db_pass);
$db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$devid = $_POST['proj_dev_id'];

$res = $db->prepare("SELECT id, proj_name FROM cli_project where proj_dev_id = ?");
$res->execute([$devid]);
$result = $res->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($result);


