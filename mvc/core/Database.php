<?php
class Database
{
    public $con;
    protected $servername = "localhost";
    protected $username = "root";
    protected $password = "";
    protected $dbname = "fabric_delivery_company";

    function __construct()
    {
        $this->con = mysqli_connect($this->servername, $this->username, $this->password);
        mysqli_select_db($this->con, $this->dbname);
        mysqli_query($this->con, "SET NAMES 'utf8'");
    }

    function __destruct()
    {
        if ($this->con) {
            mysqli_close($this->con);
        }
    }

    function query($sql = '')
    {
        $result = mysqli_query($this->con, $sql);
        if ($result) {
            return $result;
        } else {
            return mysqli_error($this->con);
        }
    }

    function get_list($sql = '')
    {
        $data = [];
        $result = $this->query($sql);
        if ($result) {
            while ($row = mysqli_fetch_assoc($result)) {
                $data[] = $row;
            }
        }
        return $data;
    }
}
