DELIMITER $$
DROP FUNCTION IF EXISTS calculateOrderPrice;

CREATE FUNCTION calculateOrderPrice (OrderID char(6)) 
RETURNS int
DETERMINISTIC
BEGIN
    DECLARE totalPrice int default 0;
	DECLARE iQuantity, iMeters int;
    DECLARE unitPrice int default 2;
    DECLARE exit_loop BOOLEAN;  
    DECLARE item_cursor CURSOR FOR
        SELECT Quantity, Meters
        FROM `Order` JOIN `Contain`
        ON `Order`.OID = `Contain`.OID
        WHERE `Order`.OID = OrderID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = TRUE;
    OPEN item_cursor;
    item_loop: LOOP
        FETCH item_cursor INTO iQuantity, iMeters;
        IF exit_loop THEN
            CLOSE item_cursor;
            LEAVE item_loop;        
        END IF;
		SET totalPrice = totalPrice + (iQuantity * 5 + iMeters) * unitPrice;
    END LOOP item_loop;
    RETURN totalPrice;
 END$$
DELIMITER ;

DROP FUNCTION IF EXISTS confirmOrder;

DELIMITER $$
CREATE FUNCTION confirmOrder (OrderID char(6)) 
RETURNS bool
DETERMINISTIC
BEGIN
	DECLARE currDebt, maxDebt int;
    DECLARE iQuantity, iMeters, iPID int;
    DECLARE exit_loop BOOLEAN;
	DECLARE item_cursor CURSOR FOR
        SELECT Quantity, Meters, PID
        FROM `Order` JOIN `Contain`
        ON `Order`.OID = `Contain`.OID
        WHERE `Order`.OID = OrderID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = TRUE;
    
    -- Check OrderID exists 
	IF NOT EXISTS (SELECT * FROM `Order` WHERE OrderID = `Order`.OID) THEN RETURN FALSE;
    END IF;
    
    -- Check Debt_limit exists 
    SELECT Debt INTO currDebt FROM Customer WHERE Customer.CID = (SELECT CID FROM Make_Order WHERE Make_Order.OID = OrderID);
    SELECT Debt_limit INTO maxDebt FROM Customer_Type 
    WHERE Customer_Type.`Type` = (SELECT `Type` FROM Customer WHERE Customer.CID = (SELECT CID FROM Make_Order WHERE Make_Order.OID = OrderID));
    IF (currDebt + calculateOrderPrice(OrderID) > maxDebt) THEN RETURN FALSE;
    END IF;
    
    -- Check inventory availability
    OPEN item_cursor;
    item_loop: LOOP
        FETCH item_cursor INTO iQuantity, iMeters, iPID;
        IF exit_loop THEN
            CLOSE item_cursor;
            LEAVE item_loop;        
        END IF;
		IF (iQuantity * 5 + iMeters > (SELECT Inventory_on_hand FROM Product WHERE iPID = Product.PID)) THEN RETURN FALSE;
        END IF;
    END LOOP item_loop;
	RETURN TRUE;
END $$
DELIMITER ;