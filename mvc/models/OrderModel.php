<?php
class OrderModel extends Database
{
    function get_all_products()
    {
        $sql = "SELECT * FROM product";
        $data = $this->get_list($sql);
        return $data;
    }

    function get_products_of_order($order_id)
    {
        $sql = "call show_detail_order($order_id)";
        $data = $this->get_list($sql);
        return $data;
    }
    function create_order($id)
    {
        $sql = "SELECT MAX(`OID`) FROM `Order`";
        $data = $this->get_one($sql);
        $oid = $data["MAX(`OID`)"] + 1;
        $sql = "INSERT INTO `Order` VALUES ('$oid', '2022-12-31', 'Waiting', 'Wait at least 1 day to confirm order')";
        $this->query($sql);
        $sql = "INSERT INTO Make_order VALUES ('$oid', (SELECT SID FROM Saler ORDER BY RAND() LIMIT 1), '$id')";
        $this->query($sql);
    }

    function get_all_orders($id)
    {
        $sql = "SELECT DISTINCT `Make_Order`.OID as OrderID,`Make_Order`.SID as SalerID,`Make_Order`.CID as CustomerID, `First and Middle Name`, `Name`, Customer.Debt, Customer_Type.`Debt_limit` as maxDebt, `Status` as _status, `Date` as _date, `Note`, confirmOrder(`Make_Order`.OID) as isAccepted 
        FROM 
        (((`Make_Order` JOIN `Order` ON `Make_Order`.OID = `Order`.OID) JOIN Customer ON `Make_Order`.CID = `Customer`.CID) JOIN `User` ON  `Customer`.CID = `User`.UID) JOIN Customer_Type
        ON  Customer.`Type` = Customer_Type.`Type`
        WHERE SID = '$id'";
        $data = $this->get_list($sql);
        return $data;
    }

    function get_orders_by_user($user_id)
    {
        $sql = "SELECT * FROM (make_order A JOIN `order` B ON A.OID = B.OID) JOIN user ON A.SID = `UID` WHERE CID = '$user_id'";
        $data = $this->get_list($sql);
        return $data;
    }

    function get_user($user_id)
    {
        $sql = "SELECT * FROM user WHERE UID = '$user_id'";
        $data = $this->get_one($sql);
        return $data["First and Middle Name"] . " " . $data["Name"];
    }

    function get_order($order)
    {
        $sql = "SELECT * FROM  order WHERE OID = '$order'";
        $data = $this->get_list($sql);
        return $data;
    }
    function get_total($date, $pid)
    {
        $sql = "call show_total_meters_of_product_in_day('$date', $pid)";
        $data = $this->get_list($sql);
        return $data;
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
    function getAllCustomer()
    {
        $sql = "SELECT CID, `First and Middle Name`, `Name`, Debt, Debt_limit, `Type` as _type, Phone, `Address`, countTotalOrder(Customer.CID) AS totalOrder FROM
        Customer JOIN `User` ON Customer.CID = `User`.UID ORDER BY countTotalOrder(Customer.CID) DESC";
        $data = $this->get_list($sql);
        return $data;
    }
    function updateOrderById($order_id, $newStatus, $newNote)
    {
        $sql = "CALL update_after_confirm_order('$order_id', '$newStatus', '$newNote')";
        $this->query($sql);
    }
}
