<?php
class OrderController extends Controller
{
    public $data = [];
    protected $model;

    function __construct()
    {
        $this->model = $this->model("OrderModel");
    }

    function CreateOrder()
    {
        $this->data["id"] = "";
        if (isset($_GET["id"])) {
            $this->data["id"] = $_GET["id"];
        }
        $this->data["productList"] = $this->model->get_all_products();
        $this->data["order"] = [];
        foreach ($this->data["productList"] as $key => $value) {
            $this->data["order"][$value["PID"] . "-quantity"] = 0;
            $this->data["order"][$value["PID"] . "-meters"] = 0;
            if (isset($_GET[$value["PID"] . "-quantity"]) && isset($_GET[$value["PID"] . "-meters"])) {
                $this->data["order"][$value["PID"] . "-quantity"] = $_GET[$value["PID"] . "-quantity"];
                $this->data["order"][$value["PID"] . "-meters"] = $_GET[$value["PID"] . "-meters"];
            }
        }

        if (isset($_GET["submit"])) {
            $this->model->create_order($this->data["id"], $this->data["order"]);
            header("Location: http://localhost:3000/OrderController/AllOrders/?id=" . $_GET["id"]);
        }
        $this->data["render"] = "CreateOrderView";
        $this->view("Layout", $this->data);
    }

    function AllOrders()
    {
        $this->data["orderList"] = [];
        $this->data["fullName"] = "";
        if (isset($_GET["id"])) {
            $this->data["orderList"] = $this->model->get_orders_by_user($_GET["id"]);
            $this->data["fullName"] = $this->model->get_user($_GET["id"]);
        }
        $this->data["render"] = "AllOrdersView";
        $this->view("Layout", $this->data);
    }

    function ViewOrder()
    {
        $this->data["productList"] = [];
        if (isset($_GET["id"])) {
            $this->data["productList"] = $this->model->get_products_of_order($_GET["id"]);
        }
        $this->data["render"] = "ViewOrder";
        $this->view("Layout", $this->data);
    }

    function Analyze()
    {
        $this->data["analysis"] = [];
        if (isset($_GET["date"]) && isset($_GET["pid"])) {
            $this->data["analysis"] = $this->model->get_total($_GET["date"], $_GET["pid"]);
        }
        $this->data["render"] = "Analyze";
        $this->view("SalerLayout", $this->data);
    }

    function confirmOrder()
    {
        $this->data["id"] = "";
        if (isset($_GET["id"])) {
            $this->data["id"] = $_GET["id"];
        }
        $this->data["orderList"] = $this->model->get_all_orders($this->data["id"]);
        $this->data["render"] = "ConfirmOrderView";
        $this->view("SalerLayout", $this->data);
    }

    function AllCustomer()
    {
        $this->data["customerList"] = $this->model->getAllCustomer();
        $this->data["render"] = "AllCustomerView";
        $this->view("SalerLayout", $this->data);
    }
}
