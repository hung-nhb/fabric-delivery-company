USE Fabric_Delivery_Company;

DROP FUNCTION IF EXISTS order_count;

DELIMITER $$

CREATE FUNCTION order_count (customer_id CHAR(6))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE o_count INT;
    SELECT COUNT(*) INTO o_count FROM `make_order` WHERE CID = customer_id;
	RETURN o_count;
END $$

DELIMITER ;

SELECT UID, `First and Middle Name`, Phone, Address  FROM `user` WHERE UID IN (SELECT CID FROM `customer` WHERE order_count(CID) > 0);

DROP FUNCTION IF EXISTS total_price;

DELIMITER $$

CREATE FUNCTION total_price (order_id CHAR(6))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE o_price INT;
    SELECT Price * (1 + VAT) INTO o_price FROM sale A JOIN sales_time B ON A.StID = B.StID WHERE OID = order_id;
	RETURN o_price;
END $$

DELIMITER ;

SELECT *, total_price(OID) FROM `order`;