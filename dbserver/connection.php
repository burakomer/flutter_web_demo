<?php

$host = "localhost";
$user = "root";
$port = 3306;
$password = "12345";
$db = "companydb";

$action = $_POST["action"] ?? null;

if ($action == null) {
    echo "Action is not specified!";
    return;
}

$condition = $_POST["condition"] ?? null;
$procedure = $_POST["procedure"] ?? null;
$props = $_POST["props"] ?? null;

$conn = mysqli_connect($host, $user, $password, $db, $port);

if ($conn->connect_error) {
    die("Connection Failed" . $conn->connect_error);
    return;
}

function selectString($table, $condition, $order_by) {
    $query = "SELECT * FROM $table";
    if ($condition) {
        $query = $query . " WHERE $condition";
    }
    if ($order_by) {
        $query = $query . " ORDER BY $order_by";
    }
    return $query;
}

function select($conn, $table, $condition, $order_by){
    $db_data = array();
    $query = selectString($table, $condition, $order_by);

    $result = $conn->query($query);
    if ($result !== false && $result->num_rows > 0) {
        while ($row = $result->fetch_assoc()){
            $db_data[] = $row;
        }
        echo json_encode($db_data);
    } else {
        echo "No rows.";
    }
    $conn->close();
    return;
}

function insert($conn, $table, $columns, $values){
    $query = "INSERT INTO companydb.{$table} ($columns) VALUES ($values)";
    $conn->query($query);
    $last_id = $conn->insert_id;
    return $last_id;
}

if ($action == "select") {
    return select($conn, $table, $condition, null);
}


if ($action == "call") {
    $db_data = array();
    $query = "CALL companydb.{$procedure}($props)";

    $result = $conn->query($query);
    if ($result !== false && $result->num_rows > 0) {
        while ($row = $result->fetch_assoc()){
            $db_data[] = $row;
        }
        echo json_encode($db_data);
    } else {
        echo "No rows.";
    }
    $conn->close();
    return;
}

?>