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
        $orders = $this->model->get_orders_by_user('CT0001');
        $this->data["render"] = "AllOrdersView";
        $this->data["orderList"] = $orders;
        $this->view("Layout", $this->data);
    }
}
