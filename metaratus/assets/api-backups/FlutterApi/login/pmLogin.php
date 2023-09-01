<?php

// Get the parameters from the Flutter app
$pmUsername = $_POST['cli_username'];
$pmPassword = $_POST['cli_password'];

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
$sql = "SELECT cli_username, cli_password FROM cli_pm WHERE cli_username='$pmUsername' AND cli_password='$pmPassword'";
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
    echo 'No user found';
}

// Close the connection
$conn->close();

?>