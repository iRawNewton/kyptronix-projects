<?php

// Get the parameters from the Flutter app
$devUsername = $_POST['cli_username'];
$devPassword = $_POST['cli_password'];

// Connect to the MySQL database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "clientonboarding";

$conn = new mysqli($servername, $username, $password, $dbname);

// // Check if the connection was successful
// if ($conn->connect_error) {
//     die("Connection failed: " . $conn->connect_error);
// }

// Query the database
$sql = "SELECT cli_username, cli_password, id FROM cli_dev WHERE cli_username='$devUsername' AND cli_password='$devPassword'";
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