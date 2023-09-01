<?php

// Get the parameters from the Flutter app
$param1 = $_POST['cli_userid'];
$param2 = $_POST['cli_pass'];

// Connect to the MySQL database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clientonboarding";

$conn = new mysqli($servername, $username, $password, $dbname);
 
// Check if the connection was successful
// if ($conn->connect_error) {
//     die("Connection failed: " . $conn->connect_error);
// }

// Query the database
$sql = "SELECT id, cli_userid, cli_pass, cli_name FROM cli_client_table WHERE cli_userid='$param1' AND cli_pass='$param2'";
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