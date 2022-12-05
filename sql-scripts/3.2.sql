use fabric_delivery_company;

drop procedure if exists show_total_meters_of_product_in_day;
delimiter //
create procedure show_total_meters_of_product_in_day (
in in_date date,
in product_id int
)
begin
if not exists (select * from product where product.PID = product_id) then
	signal sqlstate '45000' set message_text = "Cannot found that product's id";
end if;
if (in_date > current_date()) then
	signal sqlstate '45000' set message_text = "Invalid Date";
end if;
select product.PID, `Name`, `Type`, Color, `Date`, coalesce(SUM(Quantity), 0) as TotalQuantity, coalesce(SUM(Meters), 0) as TotalMeters
from has_product, product, `order`
where product.PID = has_product.PID 
	and `order`.OID = has_product.OID 
    and `Date` = in_date
    and product.PID = product_id;
end//
delimiter ;

-- testcase
-- call show_total_meters_of_product_in_day("2022-07-11", 200003);
/*thêm phần báo lỗi cho id sản phẩm nếu như ko tồn tại và lỗi ngày bán ở tương lai*/
