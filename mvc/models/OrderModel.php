<?php
class OrderModel extends Database
{
    function get_all_products()
    {
        $sql = "SELECT * FROM product";
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
        $sql = "INSERT INTO Make_order VALUES ('$oid', (SELECT SID FROM Saler ORDER BY RAND() LIMIT 1), '$id')";
        $this->query($sql);
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
}
