<table class="table table-bordered table-striped table-hover" border="1">
  <tr style="align-items:center; text-align: center;">
    <th width="100">CustomerID</th>
    <th width="100">First and Middle Name</th>
    <th width="100">Name</th>
    <th width="100">Debt</th>
    <th width="100">Debt Limit</th>
    <th width="100">Type</th>
    <th width="100">Phone</th>
    <th width="100">Address</th>
    <th width="100">Total Order</th>
  </tr>
  <?php if ($data["customerList"]) {
    foreach ($data["customerList"] as $key => $value) { ?>
  <tr>
    <td align="center">
      <?php echo $value["CID"] ?>
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
      <?php echo $value["Debt_limit"] ?>
    </td>
    <td align="center">
      <?php echo $value["_type"] ?>
    </td>
    <td align="center">
      <?php echo $value["Phone"] ?>
    </td>
    <td align="center">
      <?php echo $value["Address"] ?>
    </td>
    <td align="center">
      <?php echo $value["totalOrder"] ?>
    </td>
  </tr>
  <?php }
  } ?>
</table>