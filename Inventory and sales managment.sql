create database erryy
use erryy



create table employee (
emp_id int primary key identity,
emp_firstName varchar(40),
emp_lastName varchar(40),
emp_adress varchar(max),
emp_username varchar(max),
emp_password varchar(max),
emp_phoneNumber int,
roll varchar(100)
)

create table supplier(
sup_id int primary key identity,
sup_name varchar(30),
sup_adress varchar(max),
sup_username varchar(max),
sup_password varchar(max),
sup_phoneNumber int,
sup_tinNumber varchar(max)
)



create table customer(
customer_id int primary key identity,
first_name varchar(50),
last_name varchar(50),
userName varchar(max),
passwordd varchar(max),
adress varchar(max),
phoneNo int
)


create table item(
item_id int primary key,
item_name varchar(100) ,
item_purchased_price decimal(16,2),
item_selling_price decimal(16,2),
item_TotalStock int

)

create table suppliers_item(
sup_id int foreign key references supplier(sup_id),
item_id int primary key,
item_name varchar(100) ,
item_price decimal(16,2),
item_TotalStock int
)

create table order_supplier(
ordersup_id int primary key identity,
sup_id int foreign key references supplier(sup_id),
emp_id int foreign key references employee(emp_id),
item_id int foreign key references suppliers_item(item_id),
no_order int)



create table orderr(
order_id int primary key identity,
customer_id int foreign key references customer(customer_id),
item_id int foreign key references item(item_id),
order_quantity int,
emp_id int foreign key references employee(emp_id)

)



go
--EMPLOYEE
create proc [add employee]
@fname varchar(max),@lname varchar(max),@username varchar(max),@password varchar(max),@adress varchar(max),
@phone int,@roll varchar(max)
as
begin
insert into employee(emp_firstName,emp_lastName,emp_username,emp_password,emp_adress,emp_phoneNumber ,roll )
values(@fname ,@lname ,@username ,@password ,@adress,@phone ,@roll)
end
go
exec [add employee] 'Kebede','Getahun','Kebede87','kebe654','CMC',093344556,'Manager'
exec [add employee] 'Kibir','Girma','@kibir5','pouty09','Semit',098776542,'Sales'
exec [add employee]  'Abebe','Kebede','kebe34','1238ike','Merkato',0911875643,'Sales'
select * from employee
go

create proc [select employee](@id int)
as
begin
select emp_firstName,emp_lastName,emp_username,emp_adress,emp_phoneNumber ,roll
from employee
where @id=emp_id
end
go
exec [select employee] 1
go

create proc [delete employee]
@id int
as 
if (@id=1)
print 'Can not delete this employee'
else
begin
delete employee
where @id=emp_id
end
go
exec [delete employee] 1
exec [delete employee] 3
select * from employee
go

create trigger [delete emp]
on employee
after delete
as
begin
declare @id int
select @id=emp_id from deleted
update orderr
set emp_id=NULL
where @id=emp_id
end

go
create proc[update employee]
(@username varchar(max),@password varchar(max),@new_password varchar(max))
as
begin
update employee
set
emp_password=@new_password
where emp_password=@password and @username=emp_username
end
go
exec [update employee] '@kibir5','pouty09','jkluprt33'
go

create proc [ detail](@id int)
as
begin
declare @count int,@cust_id int,@name varchar(100),@username varchar(100)
select @cust_id=customer_id,@name=first_name + last_name,@username =username
from customer 
where @id=customer_id

set @count= dbo.count(@id)

print 'Customer ID:- '+  cast(@cust_id as varchar(100))+char(10)+ 
'Full Name:- '+@name+char(10)+ 'Username:- '+@username+char(10)+
'Number of order:- '+cast(@count as varchar(100))
end
go

--SUPPLIER

create proc [add supplier](@sup_name varchar(50),@sup_adress varchar(50),@sup_username varchar(50),@password varchar(MAX),
@sup_phoneNumber int,@sup_tinNumber int)
as
begin

insert into supplier(sup_name,sup_adress,sup_username,sup_password,sup_phoneNumber,sup_tinNumber)
 values(@sup_name,@sup_adress,@sup_username,@password,@sup_phoneNumber,@sup_tinNumber)
end
go

exec [add supplier] 'Samsung','Merkato','samsosmo','MAC32345',0987654321,1234
exec [add supplier] 'IPhone','Bole','iphone.com','lwer4321',09765345,6543
exec [add supplier] 'Tecno','Merkato','tecHno3','oqwir43',09123456,0987
select * from supplier

go
create proc [select  supplier](@id int)
as
begin
select sup_name,sup_adress,sup_username,sup_phoneNumber,sup_tinNumber
from supplier
where @id=sup_id
end

go
create proc [delect  supplier]
@sup_username varchar(max),@password varchar(max)
as
begin
delete supplier
where @sup_username=sup_username and @password=sup_password
end

go

create trigger [delete supp]
on supplier
after delete
as
begin
declare @id int
select @id=sup_id from deleted 

delete suppliers_item
where @id=item_id
end
go

create proc [update supplier]
(@username varchar(max),@password varchar(max),@new_password varchar(max))
as
begin
update supplier
set
sup_password=@new_password
where @username=sup_username and @password=sup_password
end
go

create proc [Select all]
as
begin
select sup_name,sup_adress,sup_username,sup_phoneNumber,sup_tinNumber
from supplier
end
 go

--CUSTOMER

create proc [add customer]
@fname varchar(40),@lname varchar(40),@username varchar(40),@password varchar(40),@adress varchar(max),@phone int
as
begin
insert into customer (first_name,last_name,userName,passwordd,adress,phoneNo)
values(@fname,@lname,@username,@password,@adress,@phone)
end
go
exec [add customer] 'Saron','Yitbarek','sar98','er234p','Meri',096518723
exec [add customer] 'Ruth','Eskinder','Ruta33','08uhbv','Kaliti',09843765
exec [add customer] 'Yordanos','Girmay','yordig','po987ygv','Bole',095432176
select * from customer
go

create proc [delete customer]
(@username varchar(max),@password varchar(max))
as
begin
delete customer
where userName=@username and passwordd=@password
end
go
exec [delete customer] 'sar98','er234p'
go

create trigger [delete customerr]
on customer
for delete
as
begin
declare @id int
select @id=customer_id
from deleted 
delete orderr
where customer_id=@id
end

go

create proc [update customer]
(@username varchar(max),@password varchar(max),@new_password varchar(max))
as
begin
update customer
set
passwordd=@new_password
where userName=@username and passwordd=@password
end
go

create proc [select customer](@id int)
as
begin
select first_name,last_name,userName,adress,phoneNo
from customer
where @id=customer_id
end
go
--ITEM
create proc [add item]
(@item_id int,@item_name varchar(100),@item_purchased_price decimal(16,2),@item_selling_price decimal(16,2),
@item_TotalStock int)
as
begin
insert into item
values (@item_id ,@item_name ,@item_purchased_price ,@item_selling_price ,@item_TotalStock)
end
go
exec  [add item] 1,'Samsung s1',12000,1400,10
exec  [add item] 2,'Samsung s2',13000,1550,11
exec  [add item] 3,'Iphone 10',24000,25500,9
exec  [add item] 4,'Iphone 11',34000,35500,13
exec  [add item] 5,'Techno s3',4000,5500,9
go
create proc [delete item]
@id int
as
begin
delete item
where item_id=@id
end
go
exec  [delete item] 2
go

create proc [update price of item]
(@id int,@new_price decimal(16,2))
as
begin
update item
set item_selling_price=@new_price
where item_id=@id
end
go
exec [update price of item] 1,1432
go
create proc [select item]
as
begin
select item_name,item_selling_price ,item_TotalStock
from item
end
go
--used for trigger item_insert
create function checkk(@id int)
returns int
as 
begin
declare @y varchar(50),@x int
select @y=item_name
from  item
where @id=item_id

if(@y is NULL)
begin
set @x=1
end
else 
begin
set @x=0 
end
return @x
end
go
--used for total
create function price(@id int)
returns decimal(16,2)
as
begin
declare @price decimal(16,2)
select @price=item_selling_price
from item 
where @id=item_id
return @price
end
go
--used for bill
create function Namee(@id int)
returns varchar(100)
as
begin
declare @n varchar(100)
select @n=item_name 
from item
where @id=item_id
return @n
end
go


create function change(@id int)
returns decimal(16,2)
as
begin
declare @x decimal(16,2)
select @x=item_selling_price -item_purchased_price
from item 
where item_id=@id
 return @x
 end

 go



--Suppliers item
create proc [add supplier item]
(@sup_id int,@item_id int,@item_name varchar(100),@item_price decimal(16,2),@item_TotalStock int)
as
begin
insert into suppliers_item
values (@sup_id ,@item_id ,@item_name ,@item_price ,@item_TotalStock)
end
go
exec [add supplier item] 1,1,'Samsung s1',12000,30
exec [add supplier item] 1,2,'Samsung s2',13000,17
exec [add supplier item] 2,3,'Iphone 10',24000,12
exec [add supplier item] 2,4,'Iphone 11',34000,22
exec [add supplier item] 3,5,'Techno s3',4000,15
exec [add supplier item] 3,6,'Techno s4',5000,16
go
create proc [delete supplier item]
@id int
as
begin
delete suppliers_item
where item_id=@id
end
go
create proc [update price of supplier item]
(@id int,@new_price decimal(16,2))
as
begin
update suppliers_item
set item_price=@new_price
where item_id=@id
end
go
create proc [select supplier item](@id int)
as
begin
select item_id,item_name,item_price ,item_TotalStock
from suppliers_item
where @id=sup_id
end
go
--used for trigger item_insert
create function search_name(@id int)
returns varchar(50)
as
begin
declare @name varchar(50)
select @name=item_name
from suppliers_item
where item_id=@id
return @name
end
go
--used for bill_employee
create function order_Namee(@id int)
returns varchar(100)
as
begin
declare @n varchar(100)
select @n=item_name 
from suppliers_item
where @id=item_id
return @n
end
go
create function order_price(@id int)
returns decimal(16,2)
as
begin
declare @price decimal(16,2)
select @price=item_price
from suppliers_item 
where @id=item_id
return @price
end

go
--ORDER
create proc [add order]
@customer_id int,@item_name varchar(40),@quantity int,@adress varchar(max),@phone_no int,@emp_id int=2
as 
begin

declare @id int
select @id=item_id from item 
where @item_name=item_name

insert into orderr(customer_id,item_id,order_quantity,emp_id)
    values (@customer_id,@id,@quantity,@emp_id)

end
go
exec [add order] 2,'Samsung s1',2,'Kailit',098765432
exec [add order] 2,'Iphone 10',1,'Kailit',098765432
exec [add order] 2,'Techno s3',2,'Kailit',098765432
go
create trigger [purchased item]
on orderr
after insert
as
begin
declare @id int,@quantity int
select @id=item_id,@quantity=order_quantity
from inserted
update item
set
item_TotalStock  = item_TotalStock - @quantity
where  item_id=@id
end
go


create proc [delete order](@order_id int)
as
begin
delete orderr
where order_id=@order_id
end

go

create proc [update order]
(@order_id int,@item_name varchar(max),@quantity int)
as
begin
declare @id int
select @id=item_id from item 
where @item_name=item_name

update orderr
set item_id=@id,
order_quantity=@quantity
where order_id=@order_id
end

go

create proc [select order](@id int)
as
begin
select * from orderr
where @id=order_id
end

go
--For customer detail
create function count(@id int)
returns int
as
begin
declare @c int
select @c=count(customer_id)
from orderr
where customer_id=@id
return @c
end

create function total(@customer_id int) 
returns decimal(12,2) 
as 
begin 
declare @Total decimal(12,2)

select @Total = SUM(dbo.Price(item_id) *order_quantity ) 
from orderr 
where @customer_id=customer_id 
return @Total 
end


create proc bill(@cust_id int)
as 
begin
declare @cust_name varchar(100)
declare @item varchar(max)=' '
select @item=@item + dbo.namee(item_id) +'      '+ cast(dbo.price(item_id) as varchar(50)) +'      '+
cast(order_quantity as varchar(100)) + '      '+cast(dbo.Price(item_id) *order_quantity as varchar(100))+char(10)
from  orderr 
where customer_id=@cust_id

select @cust_name=first_name + last_name
from customer
where customer_id=@cust_id

print @cust_name+char(10)+
'Item_Name' +'      '+'Item Price'+'   '+'Quantity'+'   '+'Amount'+char(10)+@item+
'                                                             TOTAL '+ cast(dbo.total(@cust_id) as varchar(50))
end

exec bill 2




--ORDER SUPPLIER

create proc [add order supplier]
@item_id int,@item_name varchar(40),@quantity int,@sup_id int,@emp_id int
as
begin
insert into order_supplier(sup_id,emp_id,item_id,no_order)
values(@sup_id,@emp_id,@item_id,@quantity)
end
exec [add order supplier] 5,'Techno s3',5,3,1


create trigger item_insertt
on order_supplier
after insert
as
Begin

declare @quantity int,@item_id int

select @quantity=no_order,@item_id=item_id 
from inserted


update item
set
item_TotalStock=item_TotalStock+@quantity,
item_purchased_price=dbo.order_price(@item_id)
where item_id=@item_id

update suppliers_item
set
item_TotalStock=item_TotalStock-@quantity
where item_id=@item_id

end



create proc [delete order supplier]
(@orderid int)
as
begin
delete order_supplier
where @orderid=ordersup_id
end

create trigger [delete order sup]
on order_supplier
after delete
as
begin
declare @quantity int,@item_id int
select @quantity=no_order,@item_id=item_id
from deleted

update suppliers_item
set item_TotalStock=item_TotalStock+@quantity
where @item_id=item_id
end


create proc [update order supplier]
(@order_id int,@item_id int,@quantity int)
as
begin
update order_supplier
set item_id=@item_id,
    no_order=@quantity
where @order_id=ordersup_id
end


create proc [select order supplier]
as
begin
select * from order_supplier
end

create function ord_total(@emp_id int) 
returns decimal(12,2) 
as 
begin 
declare @Total decimal(12,2)

select @Total = SUM(dbo.order_price(item_id) *no_order ) 
from order_supplier 
where @emp_id=emp_id 
return @Total 
end


create proc [bill_sup](@emp_id int)
as 
begin
declare @emp_name varchar(100)
declare @item varchar(max)=' '
select @item=@item + dbo.order_namee(item_id) +'      '+ cast(dbo.order_price(item_id) as varchar(50)) +'      '+
cast(no_order as varchar(100)) + '      '+cast(dbo.order_price(item_id) *no_order as varchar(100))+char(10)
from  order_supplier
where emp_id=@emp_id

select @emp_name=emp_firstName + emp_lastName
from employee
where emp_id=@emp_id

print @emp_name+char(10)+
'Item_Name' +'      '+'Item Price'+'   '+'Quantity'+'   '+'Amount'+char(10)+@item+
'                                                             TOTAL '+ cast(dbo.ord_total(@emp_id) as varchar(50))
end

exec [bill_sup] 1














