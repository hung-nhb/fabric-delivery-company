use fabric_delivery_company;

drop procedure if exists show_detail_order;
delimiter //
create procedure show_detail_order (
in order_id int
)
begin
if not exists (select * from `order` where `order`.OID = order_id) then
	signal sqlstate '45000' set message_text = "Cannot found that order's id";
end if;
select `order`.OID, `Date`, `Name`, `Type`, Color, Quantity, Meters, `Status`, `Note`
from `order`, product, has_product
where `order`.OID = has_product.OID and product.PID = has_product.PID and `order`.OID = order_id;
end//
delimiter ;

-- testcase
-- call show_detail_order(100006);

/* thêm phần báo lỗi nếu như id không tồn tại */

