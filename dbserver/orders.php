<?php

$table = "orders";

include 'connection.php';

if ($action == "insert") {
    try {
        $columns = "customerid";
        $values = "'{$_POST["customerid"]}'";

        $order_id = insert($conn, $table, $columns, $values);

        $details = json_decode($_POST["details"], $flags = JSON_OBJECT_AS_ARRAY);

        $columns = "orderid, productid, quantity";
        foreach ($details as $detail) {
            $values = "'$order_id', '{$detail["productid"]}', '{$detail["quantity"]}'";
            insert($conn, "orderdetails", $columns, $values);
        }

        echo "Order $order_id is inserted successfully!";
    } catch (\Throwable $th) {
        echo $th;
    }
    return;
}