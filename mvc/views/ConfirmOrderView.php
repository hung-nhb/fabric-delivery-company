<table class="table table-bordered table-striped table-hover" border="1">
    <tr style="align-items:center; text-align: center;">
        <th width="100">OrderID</th>
        <th width="100">SalerID</th>
        <th width="100">CustomerID</th>
        <th width="100">First and Middle Name</th>
        <th width="100">Name</th>
        <th width="100">Debt</th>
        <th width="100">Debt Limit</th>
        <th width="100">Status</th>
        <th width="100">Date created</th>
        <th width="100">Note</th>
        <th width="200">Option</th>
    </tr>
    <?php if ($data["orderList"]) {
        foreach ($data["orderList"] as $key => $value) { ?>
    <tr>
        <td align="center">
            <?php echo $value["OrderID"] ?>
        </td>
        <td align="center">
            <?php echo $value["SalerID"] ?>
        </td>
        <td align="center">
            <?php echo $value["CustomerID"] ?>
        </td>
        <td align="center">
            <?php echo $value["First and Middle Name"] ?>
        </td>
        <td align="center">
            <?php echo $value["Name"] ?>
        </td>
        <td align="center">
            <?php echo $value["Debt"] ?>
        </td>
        <td align="center">
            <?php echo $value["maxDebt"] ?>
        </td>
        <td align="center">
            <?php echo $value["_status"] ?>
        </td>
        <td align="center">
            <?php echo $value["_date"] ?>
        </td>
        <td align="center">
            <?php echo $value["Note"] ?>
        </td>
        <td align="center">
            <form action="?abc&">
                <input style="display: none;" name="id" value=<?php echo $data["id"] ?> />
                <input style="display: none;" name="oid" value=<?php echo $value["OrderID"] ?> />
                <button type="submit" name="submit" value="accept" class="btn btn-success">Confirm</button>
                <button type="submit" name="submit" value="reject" class="btn btn-danger">Reject</button>
            </form>
        </td>
    </tr>
    <?php }
    } ?>
</table>
<div>
    <h3>An order can be allowed to be accepted if: </h3>
    <ol>
        <li style="padding-bottom:20px;">Customer debt is not exceed debt limit.</li>
        <li>The product is available in store</li>
    </ol>
</div>