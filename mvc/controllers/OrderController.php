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
        $this->data["render"] = "CreateOrderView";
        $this->view("Layout", $this->data);
    }

    function AllOrders()
    {
        $this->data["orderList"] = [];
        if (isset($_GET["id"])) {
            $orders = $this->model->get_orders_by_user($_GET["id"]);
            $this->data["orderList"] = $orders;
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
}