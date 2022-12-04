USE fabric_delivery_company;

drop procedure if exists show_total_meters_of_product_in_day;
delimiter //
create procedure show_total_meters_of_product_in_day (
in in_date date,
in product_id int
)
begin
if not exists (select * from product where product.PID = product_id) then
	signal sqlstate '45000' set MESSAGE_TEXT = "Cannot found that product's id";
end if;
if (in_date > current_date()) then
	signal sqlstate '45000' set MESSAGE_TEXT = "Invalid Date";
end if;
SELECT product.PID, `Name`, `Type`, Color, `Date`, SUM(Quantity) AS total_quantity,SUM(Meters) AS total_meters
FROM has_product, product, `order`
WHERE product.PID = has_product.PID 
	AND `order`.OID = has_product.OID 
    AND `Date` = in_date
    AND product.PID = product_id;
end//
delimiter ;

-- testcase
-- call show_total_meters_of_product_in_day("2022-12-03", 200007);

/*thêm phần báo lỗi cho id sản phẩm nếu như ko tồn tại và lỗi ngày bán ở tương lai*/
