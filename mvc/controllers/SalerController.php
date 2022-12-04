<?php

class SalerController extends Controller
{
    public $data = [];
    protected $model;

    function __construct()
    {
        $this->model = $this->model("SalerModel");
    }

    function Analyze()
    {
        $this->data["analysis"] = [];
        if (isset($_GET["date"]) && isset($_GET["pid"])) {
            $this->data["analysis"] = $this->model->get_total($_GET["date"], $_GET["pid"]);
            
        }
        $this->data["render"] = "Analyze";
        $this->view("SalerPage", $this->data);
    }
}