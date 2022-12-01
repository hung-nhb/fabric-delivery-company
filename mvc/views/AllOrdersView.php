<?php
if ($data["orderList"]){
    foreach ($data["orderList"] as $key => $value) {
        echo $value["SID"];
        echo $value["OID"];
        echo $value["Date"];
        echo $value["Status"];
        echo $value["Note"];
    }
}
?>