USE fabric_delivery_company;

drop procedure if exists show_detail_order;
delimiter //
create procedure show_detail_order (
in order_id int
)
begin
if not exists (select * from `order` where `order`.OID = order_id) then
	signal sqlstate '45000' set MESSAGE_TEXT = "Cannot found that order's id";
end if;
SELECT `order`.OID, `Date`, `Name`, `Type`, Color, Quantity, Meters, `Status`, `Note`
FROM `order`, product, has_product
WHERE `order`.OID = has_product.OID AND product.PID = has_product.PID AND `order`.OID = order_id;
end//
delimiter ;

-- testcase
-- call show_detail_order(100006);

/* thêm phần báo lỗi nếu như id không tồn tại */

