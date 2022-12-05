USE fabric_delivery_company;
DROP PROCEDURE IF EXISTS create_order;
    
    DELIMITER $$
    CREATE PROCEDURE create_order (CustomerID char(6))
    BEGIN
    INSERT INTO `Order`(`Date`, `Status`, `Note`)
    VALUES (current_date(), 'Waiting', NULL);
    
    -- UPDATE MAKE_ORDER
    SET @SalerID = (SELECT SID FROM Saler ORDER BY RAND() LIMIT 1);
    INSERT INTO Make_Order
    VALUES(last_insert_id(), @SalerID ,CustomerID);
    
    END $$
    DELIMITER ;
    
    DROP PROCEDURE IF EXISTS add_product;
    DELIMITER $$
    CREATE PROCEDURE add_product (orderID int, productID int, quantity int, meters float)
    BEGIN
    	-- CHECK IF EXISTS PRODUCT
    	IF NOT EXISTS(SELECT PID FROM Product WHERE Product.PID = productID) THEN 
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'We are sorry! Our company does not sell the product you want to buy.';
    	END IF;
    	
    	 -- CHECK INVENTORY AVAILABILITY
    	IF (quantity * 5 + meters) > (SELECT Inventory_on_hand FROM Product WHERE Product.PID = productID) THEN 
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'We are sorry! Our company does not have enough inventory on hand for your order.';
    	END IF;
    	
    	-- ADD CONTAIN
    	INSERT INTO Contain
    	VALUES (orderID, productID, quantity, meters);
    END $$
    DELIMITER ;
    
    DELIMITER $$
    DROP PROCEDURE IF EXISTS update_order;
    CREATE PROCEDURE update_order (OrderID int, newStatus varchar(30), newNote varchar(50))
    BEGIN
    	IF NOT EXISTS (SELECT * FROM `Order` WHERE OID = OrderID) THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not found order with this order id.';
    	END IF;
        
        UPDATE `Order`
        SET `Status` = newStatus, Note = newNote
    	WHERE OID = OrderID;
    END $$
        
    DELIMITER ;
    
	DELIMITER $$
    DROP PROCEDURE IF EXISTS delete_order;
    CREATE PROCEDURE delete_order (OrderID int)
    BEGIN
    	IF NOT EXISTS (SELECT * FROM `Order` WHERE OID = OrderID) THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Not found order with this order id.';
    	END IF;
        
        IF (SELECT `Status` FROM `Order` WHERE OID = OrderID) <> 'Waiting' THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This order was confirmed by the saler, you can delete a confirmed order.';
    	END IF;
    
        DELETE FROM `Order`
    	WHERE OID = OrderID;
    END $$
        
    DELIMITER ;