<table border="1">
    <caption>
        <h2>All Order of
            <?php echo $data["fullName"] ?>
        </h2>
    </caption>
    <tr>
        <th width="100">Order ID</th>
        <th width="150">Saler</th>
        <th width="150">Date created</th>
        <th width="150">Status</th>
        <th width="500">Note</th>
    </tr>
    <?php if ($data["orderList"]) {
        foreach ($data["orderList"] as $key => $value) { ?>
            <tr>
                <td align="center"><?php echo $value["OID"] ?></td>
                <td align="center"><?php echo $value["First and Middle Name"] . " " . $value["Name"] ?></td>
                <td align="center"><?php echo $value["Date"] ?></td>
                <td align="center"><?php echo $value["Status"] ?></td>
                <td><?php echo $value["Note"] ?></td>
            </tr>
    <?php }
    } ?>
</table>