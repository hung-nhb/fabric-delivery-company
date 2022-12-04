<?php
class OrderModel extends Database
{
    function get_all_products()
    {
        $sql = "SELECT * FROM Product";
        $data = $this->get_list($sql);
        return $data;
    }

    function create_order($id, $order)
    {
        $sql = "SELECT MAX(`OID`) FROM `Order`";
        $data = $this->get_one($sql);
        $oid = $data["MAX(`OID`)"] + 1;
        $sql = "INSERT INTO `Order` VALUES ('$oid', '2022-12-31', 'Waiting', 'Wait at least 1 day to confirm order')";
        $this->query($sql);
        $sql = "INSERT INTO Make_Order VALUES ('$oid', (SELECT SID FROM Saler ORDER BY RAND() LIMIT 1), '$id')";
        $this->query($sql);
    }
    function get_all_orders()
    {
        $sql = "SELECT `Order`.OID as OrderID, `Customer`.CID as CustomerID, `First and Middle Name`,`Name`, Debt, Debt_limit as maxDebt, `Status` as _status, `Date` as _date, Note, confirmOrder(`Order`.OID) as isAvailable 
        FROM (`Order` JOIN Make_Order ON `Order`.OID = Make_Order.OID) 
        JOIN Customer ON Make_Order.CID = Customer.CID
        JOIN `User` ON Customer.CID = `User`.UID";
        $data = $this->get_list($sql);
        return $data;
    }
    function get_orders_by_user($user_id)
    {
        $sql = "SELECT * FROM (Make_Order A JOIN `Order` B ON A.OID = B.OID) JOIN User ON A.SID = `UID` WHERE CID = '$user_id'";
        $data = $this->get_list($sql);
        return $data;
    }

    function get_user($user_id)
    {
        $sql = "SELECT * FROM User WHERE UID = '$user_id'";
        $data = $this->get_one($sql);
        return $data["First and Middle Name"] . " " . $data["Name"];
    }
    function confirm_order($order_id)
    {
        $sql = "SELECT *, confirmOrder('$order_id') as Confirm_Order";
        $data = $this->get_one($sql);
        return $data["Confirm_Order"];
    }
    function calculate_order_price($order_id)
    {
        $sql = "SELECT calculateOrderPrice('$order_id') as Order_Price";
        $data = $this->get_one($sql);
        return $data["Order_Price"];
    }
}