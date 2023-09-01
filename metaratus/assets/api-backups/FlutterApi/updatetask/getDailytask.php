<?php

// Get the parameters from the Flutter app
$devID = $_POST['dev_id'];

// Connect to the MySQL database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clientonboarding";

$conn = new mysqli($servername, $username, $password, $dbname);

// Check if the connection was successful
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Query the database
$sql = "SELECT cli_daily_task.cli_date, cli_daily_task.cli_task, cli_daily_task.cli_progress, cli_project.proj_name 
        FROM cli_daily_task,cli_project 
        WHERE cli_daily_task.cli_projid=cli_project.id 
        AND cli_daily_task.cli_devid='$devID'";
        
$result = $conn->query($sql);

// Check if there are any results
if ($result->num_rows > 0) {
    // Convert the results to a JSON object
    $response = array();
    while ($row = $result->fetch_assoc()) {
        $response[] = $row;
    }
    echo json_encode($response);
} else {
    // Return an error message
    echo 'Found Nothing';
}

// Close the connection
$conn->close();

?>