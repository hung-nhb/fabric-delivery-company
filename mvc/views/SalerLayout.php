<?php
$DOMAIN = 'http://localhost:3000';
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE-edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="<?php $DOMAIN ?>/public/style.css" />
    <title>Saler</title>
</head>

<body>
    <div class="header">
        <?php if ($data["render"] == "ConfirmOrderView" || $data["render"] = "AllCustomerView")
            echo "Saler Page" ?>
    </div>
    <div class="content">
        <div class="navbar__custom">
            <div class="btn from-left" onclick="location.pathname='/OrderController/AllCustomer/'">View All Customer
            </div>
            <div class="btn from-left" onclick="location.pathname='/OrderController/ConfirmOrder/'">Confirm Order
            </div>
            <div class="btn from-left" onclick="location.pathname='/OrderController/Analyze/'">Analyze
            </div>
        </div>
        <div class="view">
            <?php require_once $data["render"] . '.php' ?>
        </div>
    </div>
</body>

</html>