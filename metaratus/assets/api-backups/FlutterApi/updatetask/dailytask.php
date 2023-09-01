<?php
header('Content-Type: application/json');
$db_name = "clientonboarding";
$db_server = "localhost";
$db_user = "root";
$db_pass = "";

$db = new PDO("mysql:host={$db_server};dbname={$db_name};charset=utf8", $db_user, $db_pass);
$db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$iDate = $_POST['cli_date'];
$date = str_replace("/","-",$iDate);
$date = strtotime($date);
$date = date('Y-m-d',$date);

$task =  $_POST['cli_task'];
$progress = $_POST['cli_progress'];
$devid =  $_POST['cli_devid'];
$projid = $_POST['cli_projid'];

$stmt = $db->prepare("INSERT INTO cli_daily_task (cli_date, cli_task, cli_progress, cli_devid, cli_projid) VALUES (?, ?, ?, ?, ?)");
$result = $stmt->execute([$date, $task, $progress, $devid, $projid]);

$stmts = $db->prepare("UPDATE cli_project SET proj_progress = ? WHERE id = ?;");
$stmts->execute([$progress, $projid]);

echo json_encode([
'success' => $result
]);
