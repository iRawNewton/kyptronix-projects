<?php
header('Content-Type: application/json');
//include "../db.php";
$db = mysqli_connect("localhost","root","","clientonboarding") or die("error");
$name = $_POST['proj_name'];
$desc =  $_POST['proj_desc'];

$startDate = $_POST['proj_startdate'];
$sdate = str_replace("/","-",$startDate);
$sdate = strtotime($sdate);
$sdate = date('Y-m-d',$sdate);
// $timestamp = strtotime($startDate);
// $sdate = date('Y-m-d',$timestamp); 

$endDate = $_POST['proj_enddate'];
$edate = str_replace("/","-",$endDate);
$edate = strtotime($edate);
$edate = date('Y-m-d',$edate);

$cli_id =  $_POST['proj_cli_id'];
$dev_id =  $_POST['proj_dev_id'];

//$stmt = $db->prepare("INSERT INTO cli_project (proj_name, proj_desc, proj_startdate, proj_enddate, proj_cli_id, proj_dev_id) VALUES (?, ?, ?, ?, ?, ?)");
//$result = $stmt->execute([$name, $desc, $sdate, $edate, $cli_id, $dev_id]);
$stmt = "INSERT INTO cli_project(proj_name,proj_desc,proj_startdate, proj_enddate, proj_cli_id, proj_dev_id)
VALUES('$name','$desc','$sdate','$edate','$cli_id','$dev_id')";

$result = mysqli_query($db,$stmt);
echo json_encode([
'success' => $stmt
]);
