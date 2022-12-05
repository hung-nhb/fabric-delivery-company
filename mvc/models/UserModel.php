<?php
class UserModel extends Database
{
    function get_user_by_username_and_password($username, $password)
    {
        $sql = "SELECT * FROM `Account` WHERE Username = '$username' AND `Password` = '$password'";
        $data = $this->get_one($sql);
        return $data;
    }

    function get_uid($username)
    {
        $sql = "SELECT * FROM User WHERE Username = '$username'";
        $data = $this->get_one($sql);
        return $data;
    }
}
