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


DELIMITER $$
DROP FUNCTION IF EXISTS countTotalOrder;

CREATE FUNCTION countTotalOrder (CustomerID char(6)) 
RETURNS int
DETERMINISTIC
BEGIN
    DECLARE totalOrder int DEFAULT 0;
    SELECT COUNT(*) into totalOrder FROM `Make_Order` WHERE `Make_Order`.CID = CustomerID;
    RETURN totalOrder;
END $$
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

DROP TRIGGER IF EXISTS before_insert_sale;

DELIMITER $$
CREATE TRIGGER before_insert_sale BEFORE INSERT ON Sale
FOR EACH ROW
BEGIN
	DECLARE currDebt, maxDebt int;
    DECLARE iQuantity, iMeters, iPID, iInventory_on_hand int;
    DECLARE exit_loop BOOLEAN;
    
	DECLARE item_cursor CURSOR FOR
        SELECT Quantity, Meters, PID
        FROM `Order` JOIN Contain
        ON `Order`.OID = Contain.OID
        WHERE `Order`.OID = NEW.OID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = TRUE;
    
    SET exit_loop = False;
	SET @price = calculateOrderPrice(NEW.OID) * (1 + 0.08);	
	SET @CustomerID = (SELECT CID
					  FROM Make_Order
                      WHERE OID = NEW.OID);
	SET @`type` = (SELECT Type
					FROM Customer
					WHERE CID = @CustomerID);
    
	SELECT Debt INTO currDebt 
    FROM Customer 
    WHERE Customer.CID = @CustomerID;
    
    SELECT Debt_limit INTO maxDebt
    FROM Customer_Type 
    WHERE Customer_Type.`Type` = @`type`;
    
    -- Check debt limit
    IF (currDebt + @price > maxDebt) 
    THEN 		
			SET @`text` = CONCAT('Customer ', @CustomerID, ' has exceeded debt limit in ', @`type`);
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @`text`;
    END IF;
    
    -- Check inventory availability
	OPEN item_cursor;
    item_loop: LOOP
        FETCH item_cursor INTO iQuantity, iMeters, iPID;
        IF exit_loop THEN
            CLOSE item_cursor;
            LEAVE item_loop;        
        END IF;
		IF ((iQuantity * 5 + iMeters) > (SELECT Inventory_on_hand FROM Product WHERE iPID = Product.PID)) 
			THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'We are sorry! Our company does not have enough inventory on hand for your order.';
        END IF;
    END LOOP item_loop;
    SET exit_loop = FALSE;
END $$
DELIMITER ;


DROP TRIGGER IF EXISTS after_insert_sale;
DELIMITER $$
CREATE TRIGGER after_insert_sale AFTER INSERT ON Sale
FOR EACH ROW
BEGIN
	DECLARE iPID, iInventory_on_hand, iQuantity, iMeters int;
    DECLARE exit_loop BOOLEAN;
    
	DECLARE inventory_cursor CURSOR FOR
		SELECT Product.PID, Inventory_on_hand, Quantity, Meters
        FROM Contain JOIN `Product`
        ON Contain.PID = `Product`.PID
        WHERE Contain.OID = NEW.OID;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = TRUE;
    
	SET @price = calculateOrderPrice(NEW.OID);	
	SET @CustomerID = (SELECT CID
					  FROM Make_order
                      WHERE OID = NEW.OID);
	-- Update Debt
    UPDATE Customer
    SET Debt = Debt + @price * (1 + (SELECT VAT FROM Sales_time WHERE StID = NEW.StID))
    WHERE CID = @CustomerID;

    -- Update inventory_on_hand
	OPEN inventory_cursor;
    inventory_loop: LOOP
        FETCH inventory_cursor INTO iPID, iInventory_on_hand, iQuantity, iMeters;
        
        UPDATE Product
		SET Inventory_on_hand = iInventory_on_hand - (iQuantity * 5 + iMeters)
        WHERE Product.PID = iPID;
        
        IF exit_loop THEN
            CLOSE inventory_cursor;
            LEAVE inventory_loop;        
        END IF;
    END LOOP inventory_loop;   
	SET exit_loop = False;
    
    -- Update Order
    UPDATE `Order`
    SET `Status` = 'Processing'
    WHERE OID = NEW.OID;
END $$
DELIMITER ;
