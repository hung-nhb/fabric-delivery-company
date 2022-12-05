<h2 style="display: flex; justify-content: center;">Create New Order</h2>
<div class="product-list">
    <?php if ($data["productList"]) {
        foreach ($data["productList"] as $key => $value) { ?>
            <div class="product-item">
                <div class="product-info">
                    <div>
                        <img src=<?php echo '/images/' . $value["Image"] . '.jpg' ?> alt="img" class="product-image" />
                    </div>
                    <div>
                        <span class="product-title">Name: </span><?php echo $value["Name"] ?><br />
                        <span class="product-title">Type: </span><?php echo $value["Type"] ?><br />
                        <span class="product-title">Color: </span><?php echo $value["Color"] ?><br />
                        <span class="product-title">Detail: </span><?php echo $value["Detail"] ?><br />
                        <span class="product-title">Supplier: </span><?php echo $value["Supplier"] ?> <br />
                    </div>
                </div>
                <div class="product-number-title">
                    <div>Quantity</div>
                    <div>Meters</div>
                </div>
                <form>
                    <div class="product-number">
                        <div>
                            <button onclick="decreaseValue('<?php echo $value["PID"] . "-quantity" ?>')">-</button>
                            <input type="number" class="product-quantity" id=<?php echo $value["PID"] . "-quantity" ?> value=<?php echo $data["order"][$value["PID"] . "-quantity"] ?> name=<?php echo $value["PID"] . "-quantity" ?> />
                            <button onclick="increaseValue('<?php echo $value["PID"] . "-quantity" ?>', '<?php echo $value["Inventory_on_hand"] ?>', 'quantity')">+</button>
                        </div>
                        <div>
                            <button onclick="decreaseValue('<?php echo $value["PID"]  . "-meters" ?>')">-</button>
                            <input type="number" class="product-quantity" id=<?php echo $value["PID"] . "-meters" ?> value=<?php echo $data["order"][$value["PID"] . "-meters"] ?> name=<?php echo $value["PID"] . "-meters" ?> />
                            <button onclick="increaseValue('<?php echo $value["PID"]  . "-meters" ?>', '<?php echo $value["Inventory_on_hand"] ?>', 'meters')">+</button>
                        </div>
                    </div>
                    <div class="product-available">
                        Available: <?php echo $value["Inventory_on_hand"] ?> meters
                    </div>
            </div>
    <?php }
    } ?>
</div>
<input style="display: none;" name="id" value=<?php echo $data["id"] ?> />
<div style="display: flex; justify-content: center;">
    <button class="button-create-order" type="submit" name="submit" value="OK">Create</button>
</div>
</form>

<script>
    function increaseValue(id, maxNumber, type) {
        var value = parseInt(document.getElementById(id).value, 10);
        value = isNaN(value) ? 0 : value;
        if (type == "quantity") {
            value = (value + 1) * 5 > maxNumber ? maxNumber / 5 : value + 1;
        } else {
            value = value == maxNumber ? maxNumber : value + 1;
        }
        document.getElementById(id).value = value;
    }

    function decreaseValue(id) {
        var value = parseInt(document.getElementById(id).value, 10);
        value = isNaN(value) ? 0 : value;
        value < 1 ? value = 1 : '';
        value--;
        document.getElementById(id).value = value;
    }
</script>