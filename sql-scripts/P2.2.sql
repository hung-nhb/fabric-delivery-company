USE fabric_delivery_company;

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
        SET @VAT = (SELECT VAT FROM Sales_time WHERE StID = NEW.StID);
    	SET @price = calculateOrderPrice(NEW.OID) * (1 + @VAT);		
    	SET @CustomerID = (SELECT CID FROM Make_Orde WHERE OID = NEW.OID);
    	SET @`type` = (SELECT Type FROM Customer WHERE CID = @CustomerID);
    	SELECT Debt INTO currDebt FROM Customer WHERE Customer.CID = @CustomerID;
    SELECT Debt_limit INTO maxDebt FROM Customer_Type WHERE Customer_Type.`Type` = @`type`;
        -- Check debt limit
        IF (currDebt + @price > maxDebt) THEN 		
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
    		IF ((iQuantity * 5 + iMeters) > (SELECT Inventory_on_hand FROM Product WHERE iPID = Product.PID)) THEN 
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'We are sorry! Our company does not have enough inventory on hand for your order.';
            END IF;
        END LOOP item_loop;
        SET exit_loop = FALSE;
    END $$
    DELIMITER ;
    
     DROP TRIGGER IF EXISTS after_insert_sale;
    DELIMITER //
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
    	SET @CustomerID = (SELECT CID FROM Make_Order WHERE OID = NEW.OID);
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
    END //
    DELIMITER ;
    
    DROP TRIGGER IF EXISTS after_delivery_trip_update;
    DELIMITER $$
    CREATE TRIGGER after_delivery_trip_update AFTER UPDATE ON delivery_trip
    FOR EACH ROW
    BEGIN
    	DECLARE iPaID, iOID int;
        DECLARE exit_loop BOOLEAN;
        
        DECLARE package_cursor CURSOR FOR
        SELECT PaID, OID 
        FROM has_package JOIN delivery_trip
        ON has_package.DtID = delivery_trip.DtID
        WHERE has_package.DtID = NEW.DtID;
        
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = TRUE;
        SET exit_loop = FALSE;
        IF NEW.`Status` = 'Done'
    		THEN
    			OPEN package_cursor;
                package_loop: LOOP
                FETCH package_cursor INTO iPaID, iOID;
                DELETE FROM Package
                WHERE PaID = iPaID AND OID = iOID;
                IF exit_loop THEN
    				CLOSE package_cursor;
                    LEAVE package_loop;
    			END IF;
                END LOOP package_loop;
    	END IF;
    END $$
    DELIMITER ;
    
    