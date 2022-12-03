<?php
class UserModel extends Database
{
    function get_user_by_username_and_password($username, $password)
    {
        $sql = "SELECT * FROM `account` WHERE username = '$username' AND `password` = '$password'";
        $data = $this->get_one($sql);
        return $data;
    }

    function get_uid ($username) {
        $sql = "SELECT * FROM user WHERE Username = '$username'";
        $data = $this->get_one($sql);
        return $data;
    }
}
