<form action="/OrderController/Analyze/">
    Date: <input type="text" name="date">
    Product ID: <input type="text" name="pid">
    <input type="submit">
</form>
<table border="1">
    <caption class="caption-view-order">
        Product ID
        <?php if (isset($_GET["pid"])) echo $_GET["pid"];
        ?> in date <?php if (isset($_GET["date"])) echo $_GET["date"];?>
    </caption>
    <tr>
        <th width="100">Product Name</th>
        <th width="100">Product Type</th>
        <th width="100">Product Color</th>
        <th width="50">Quantity</th>
        <th width="50">Meters</th>
    </tr>
    <?php if ($data["analysis"]) {
        foreach ($data["analysis"] as $key => $value) { ?>
    <tr>

        <td align="center"><?php echo $value["Name"] ?></td>
        <td align="center"><?php echo $value["Type"] ?></td>
        <td align="center"><?php echo $value["Color"] ?></td>
        <td align="center"><?php echo $value["TotalQuantity"] ?></td>
        <td align="center"><?php echo $value["TotalMeters"] ?></td>
    </tr>
    <?php }
    } ?>
</table>