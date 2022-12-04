<?php
class SalerModel extends Database
{
    function get_total($date, $pid) {
        $sql = "call show_total_meters_of_product_in_day($date, $pid)";
        $data = $this->get_list($sql);
        return $data;
    }
}