<?php
class OrderModel extends Database
{
    function get_orders_by_user($user_id)
    {
        $sql = "SELECT * FROM make_order A JOIN `order` B ON A.OID = B.OID WHERE CID = '$user_id'";
        $data = $this->get_list($sql);
        return $data;
    }
}
