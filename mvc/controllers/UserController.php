<?php
class UserController extends Controller
{
    public $data = [];
    protected $model;

    function __construct()
    {
        $this->model = $this->model("UserModel");
    }

    function Login()
    {
        if (isset($_GET["username"]) && isset($_GET["password"])) {
            $user = $this->model->get_user_by_username_and_password($_GET["username"], $_GET["password"]);
            if ($user != "") {
                $id = $this->model->get_uid($user["Username"]);
                if ($user["Type"] == "Customer") {
                    header("Location: http://localhost:3000/OrderController/CreateOrder/?id=" . $id["UID"]);
                } else {
                    header("Location: http://localhost:3000/SalerController/Analyze/?id=" . $id["UID"]);
                }
            } else {
                header("Location: http://localhost:3000/UserController/Login");
            }
        }
        $this->view("UserView", $this->data);
    }

}