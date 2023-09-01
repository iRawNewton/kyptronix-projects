<?php

// Get the parameters from the Flutter app
$projectClientID = $_POST['proj_cli_id']; //******************************* */

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
$sql = "SELECT cli_client_table.cli_name, cli_project.proj_name, cli_project.proj_progress 
        from cli_client_table,cli_project
        WHERE cli_client_table.id = cli_project.proj_cli_id 
        AND cli_project.proj_cli_id = '$projectClientID'";
        
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