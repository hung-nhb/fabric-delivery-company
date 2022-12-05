<form action="/OrderController/ViewOrder/">
    Order ID: <input type="text" name="id">
    <input type="submit">
</form>
<table border="1">
    <caption class="caption-view-order">
        Detail of Order
        <?php if (isset($_GET["id"])) echo $_GET["id"];
        ?>
    </caption>
    <tr>
        <th width="100">Order ID</th>
        <th width="100">Packet ID</th>
        <th width="100">Product Name</th>
        <th width="100">Product Type</th>
        <th width="100">Product Color</th>
        <th width="50">Quantity</th>
        <th width="50">Meters</th>
    </tr>
    <?php if ($data["productList"]) {
        foreach ($data["productList"] as $key => $value) { ?>
    <tr>
        <td align="center"><?php echo $value["OID"] ?></td>
        <td align="center"><?php echo $value["PaID"] ?></td>
        <td align="center"><?php echo $value["Name"] ?></td>
        <td align="center"><?php echo $value["Type"] ?></td>
        <td align="center"><?php echo $value["Color"] ?></td>
        <td align="center"><?php echo $value["Quantity"] ?></td>
        <td align="center"><?php echo $value["Meters"] ?></td>
    </tr>
    <?php }
    } ?>
</table>