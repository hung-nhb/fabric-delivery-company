<form action="/OrderController/AllOrders/">
    Customer ID: <input type="text" name="id">
    <input type="submit">
</form>
<table border="1">
    <caption class="caption-all-orders">
        All Order of
        <?php if (isset($_GET["id"])) echo $_GET["id"];
        else echo "Someone"; ?>
    </caption>
    <tr>
        <th width="100">Order ID</th>
        <th width="100">Saler ID</th>
        <th width="150">Date created</th>
        <th width="100">Status</th>
        <th width="400">Note</th>
    </tr>
    <?php if ($data["orderList"]) {
        foreach ($data["orderList"] as $key => $value) { ?>
            <tr>
                <td align="center"><?php echo $value["OID"] ?></td>
                <td align="center"><?php echo $value["SID"] ?></td>
                <td align="center"><?php echo $value["Date"] ?></td>
                <td align="center"><?php echo $value["Status"] ?></td>
                <td><?php echo $value["Note"] ?></td>
            </tr>
    <?php }
    } ?>
</table>