<form action="/OrderController/ViewOrder/" style="margin: 1rem 0;">
    <input style="display: none;" name="id" value=<?php echo $data["id"] ?> />
    Order ID: <input type="text" name="oid">
    <input type="submit">
</form>
<table class="table table-bordered table-striped table-hover" border="1">
    <caption class="caption-view-order">
        Detail of Order
        <?php if (isset($_GET["id"])) echo $_GET["oid"];
        ?>
    </caption>
    <tr style="align-items:center; text-align: center;">
        <th width="100">Product Name</th>
        <th width="100">Product Type</th>
        <th width="100">Product Color</th>
        <th width="50">Quantity</th>
        <th width="50">Meters</th>
    </tr>
    <?php if ($data["productList"]) {
        foreach ($data["productList"] as $key => $value) { ?>
            <tr>
                <td align="center"><?php echo $value["Name"] ?></td>
                <td align="center"><?php echo $value["Type"] ?></td>
                <td align="center"><?php echo $value["Color"] ?></td>
                <td align="center"><?php echo $value["Quantity"] ?></td>
                <td align="center"><?php echo $value["Meters"] ?></td>
            </tr>
    <?php }
    } ?>
</table>