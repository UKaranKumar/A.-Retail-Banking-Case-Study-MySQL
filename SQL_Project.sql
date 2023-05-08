-- A.
-- 1.	Create DataBase BANK and Write SQL query to create above schema with constraints

create database bank_retail;
use bank_retail;

create table Branch
(
Branch_no int not null primary key,
name char(50) not null
);

create table Employees
(
Emp_no int not null primary key,
Branch_no int unique,
Fname char(20),
Mname char(20),
Lname char(20),
Dept char(20),
Desig char(10),
Mngr_no int not null,
foreign key(Branch_no) references Branch(Branch_no)
);

create table Customers
(
Cust_no int not null primary key,
Fname char(20),
Mname char(20),
Lname char(20),
City char(50),
DOB date,
Occupation char(10)
);

create table Accounts
(
Acc_no int not null primary key,
Branch_no int not null unique,
Cust_no int not null,
Type char(20) not null check (Type in ('Current', 'Saving')),
OpnDT date,
CurBal int,
Status char(10) not null check (Status in ('Active', 'Suspended', 'Terminated')),
foreign key(Branch_no) references Branch(Branch_no),
foreign key(Cust_no) references Customers(Cust_no)
);

-- 2.	Inserting Records into created tables

-- Branch
-- Branch_no	Name
-- 1		    Delhi
-- 2		    Mumbai 
insert into branch values
(1, 'Delhi'),
(2, 'Mumbai');
select * from branch;

-- Customer
-- custid	fname	mname	lname	occupation	dob
-- 1	    Ramesh  Chandra	Sharma	 Service    1976-12-06
-- 2	    Avinash	Sunder	Minha	Business    1974-10-16
insert into customers
(Cust_no, Fname, Mname, Lname, Occupation, DOB)
values
(1, 'Ramesh', 'Chandra', 'Sharma', 'Service' , '1976-12-06'),
(2, 'Avinash', 'Sunder', 'Minha', 'Business', '1974-10-16');
select * from customers;

-- Account
-- acnumber	custid	bid	curbal	opnDT	    atype	astatus
-- 1	     1	    1	10000	2012-12-15	Saving	Active
-- 2	     2	    2	5000	2012-06-12	Saving	Active
insert into accounts
(Acc_no, Cust_no, Branch_no, CurBal, OpnDT, Type, Status)
values
(1, 1, 1, 10000, '2012-12-15', 'Saving', 'Active'),
(2, 2, 2, 5000, '2012-06-12', 'Saving', 'Active');
select * from accounts;

-- Employee
-- Emp_no	Branch_no	Fname	Mname	Lname	Dept	Desig		Mngr_no
-- 1	    1		    Mark	steve	Lara	Account	Accountant	2
-- 2	    2		   Bella	James	Ronald	Loan	Manager		1
insert into employees values
(1, 1, 'Mark',' steve', 'Lara', 'Account', 'Accountant', 2),
(2, 2, 'Bella', 'James', 'Ronald', 'Loan', 'Manager', 1);
select * from employees;

-- 3.	Select unique occupation from customer table
select distinct Occupation from customers;

-- 4.	Sort accounts according to current balance
select * from accounts
order by curbal desc;

-- 5.	Find the Date of Birth of customer name ‘Ramesh’
select Fname, dob from customers
where Fname='Ramesh';

-- 6.	Add column city to branch table 
alter table branch add city char(50);
desc branch;

-- 7.	Update the mname and lname of employee ‘Bella’ and set to ‘Karan’, ‘Singh’ 
update employees set Mname='Karan', Lname='Singh'
where Fname='Bella';
select * from employees;

-- 8.	Select accounts opened between '2012-07-01' AND '2013-01-01'
select * from accounts
where OpnDT between '2012-07-01' AND '2013-01-01';

-- 9.	List the names of customers having ‘a’ as the second letter in their names 
select * from customers
where Fname like '_a%';

-- 10.	Find the lowest balance from customer and account table
select * from customers c
join accounts a
on a.Cust_no=c.Cust_no
order by CurBal
limit 1;

-- 11.	Give the count of customer for each occupation
select *, count(Cust_no) from customers
group by Occupation;

-- 12.	Write a query to find the name (first_name, last_name) of the employees who are managers.
select e1.Mngr_no, concat(e1.Fname,' ',e1.Mname,' ',e1.Lname)name from employees e1
join employees e2 
on e1.Mngr_no=e2.Emp_no;

-- 13.	List name of all employees whose name ends with a
select concat(Fname,' ',Mname,' ',Lname)name from employees
where Lname like '%a';

-- 14.	Select the details of the employee who work either for department ‘loan’ or ‘credit’
select * from employees
where Dept like 'Loan' or 'Credit';

-- 15.	Write a query to display the customer number, customer firstname, account number for the customers who are born after 15th of any month.
select c.Cust_no, Fname, Acc_no, DOB from customers c 
join accounts a 
on c.Cust_no=a.Cust_no
where day(dob)>15;

-- 16.	Write a query to display the customer’s number, customer’s firstname, branch id and balance amount for people using JOIN.
select c.Cust_no, Fname, b.branch_no, curbal  from customers c
join accounts a on c.Cust_no=a.Cust_no
join branch b on b.Branch_no=a.Branch_no;

-- 17.	Create a virtual table to store the customers who are having the accounts in the same city as they live
update branch set city = 'Delhi' where branch_no = 1;
update branch set city = 'Mumbai' where branch_no = 2;
update customers set city='Mumbai' where city is null;

create view same_city as
select c.Cust_no, Fname, c.city Customer_city, b.city Branch_city  from customers c 
join  accounts a
on c.Cust_no=a.Cust_no
join branch b 
on b.Branch_no=a.Branch_no
where c.city=b.city;

select * from Same_city;

-- 18.	A. Create a transaction table with following details 
-- TID – transaction ID – Primary key with autoincrement 
-- Custid – customer id (reference from customer table
-- account no – acoount number (references account table)
-- bid – Branch id – references branch table
-- amount – amount in numbers
-- type – type of transaction (Withdraw or deposit)
-- DOT -  date of transaction
Create table Transaction( 
TID int primary key auto_increment,
Custid int,
account_no int,
bid int,
amount int,
type char(20) not null check (type in ('withdraw','deposit')) ,
DOT date,
foreign key (custid) references customers(cust_no),
foreign key (account_no) references accounts(acc_no),
foreign key (bid) references branch(branch_no));

-- a. Write trigger to update balance in account table on Deposit or Withdraw in transaction table
-- b. Insert values in transaction table to show trigger success

DELIMITER //
create trigger transaction_details
after insert on transaction
for each row
begin
if new.type = 'Deposit' then update accounts set curbal = curbal+new.amount where custid=new.custid ;
elseif new.type = 'Withdraw' then update accounts set curbal = curbal-new.amount where custid=new.custid ;
end if;
end // 
DELIMITER ;

insert into transaction values 
(null,1,1,1,2000,'deposit',now());
select * from transaction;


-- 19.	Write a query to display the details of customer with second highest balance 
select * from customers c 
join accounts a
on c.Cust_no=a.Cust_no
order by CurBal desc
limit 1,1;

-- OR --

select * from 
(select *,dense_rank()over(order by curbal desc) rnk from accounts)t
where rnk=2;

-- 20.	Take backup of the databse created in this case study.
backup database bank_retail
to disk = 'C:\Users\ukara\Downloads\bank_retail.bak';

-- B.
-- 1. Display the product details as per the following criteria and sort them in descending order of category:
   #a.  If the category is 2050, increase the price by 2000
   #b.  If the category is 2051, increase the price by 500
   #c.  If the category is 2052, increase the price by 600 
   
   select *, case
   when product_class_code=2050 then product_price+2000
   when product_class_code=2051 then product_price+500
   when product_class_code=2052 then product_price+600
   else product_price
   end new_price
   from product
   order by new_price desc;
   
-- 2. List the product description, class description and price of all products which are shipped.
select PRODUCT_DESC, PRODUCT_CLASS_DESC, PRODUCT_PRICE from product p
join product_class pc 
on p.PRODUCT_CLASS_CODE=pc.PRODUCT_CLASS_CODE
join order_items ot 
on ot.PRODUCT_ID=p.PRODUCT_ID
join order_header oh 
on oh.ORDER_ID=ot.ORDER_ID
join shipper s 
on s.SHIPPER_ID=oh.SHIPPER_ID 
group by p.PRODUCT_ID,PRODUCT_DESC, PRODUCT_CLASS_DESC, PRODUCT_PRICE; 

-- 3. Show inventory status of products as below as per their available quantity:
#a. For Electronics and Computer categories, if available quantity is < 10, show 'Low stock', 11 < qty < 30, show 'In stock', > 31, show 'Enough stock'
#b. For Stationery and Clothes categories, if qty < 20, show 'Low stock', 21 < qty < 80, show 'In stock', > 81, show 'Enough stock'
#c. Rest of the categories, if qty < 15 – 'Low Stock', 16 < qty < 50 – 'In Stock', > 51 – 'Enough stock'
#For all categories, if available quantity is 0, show 'Out of stock'.
select PRODUCT_ID, PRODUCT_DESC, PRODUCT_CLASS_DESC, PRODUCT_QUANTITY_AVAIL , case
when PRODUCT_QUANTITY_AVAIL=0 then 'Out of Stock'
when PRODUCT_QUANTITY_AVAIL between 1 and 15 then 'Low Stock'
when PRODUCT_QUANTITY_AVAIL between 16 and 50 then 'In Stock'
when PRODUCT_QUANTITY_AVAIL > 50 then 'Enough Stock'
when (PRODUCT_CLASS_DESC in ('Electronics','Computer')) and (PRODUCT_QUANTITY_AVAIL <10) then 'Low Stock'
when (PRODUCT_CLASS_DESC in ('Electronics','Computer')) and (PRODUCT_QUANTITY_AVAIL between 10 and 30 ) then 'In Stock'
when (PRODUCT_CLASS_DESC in ('Electronics','Computer')) and (PRODUCT_QUANTITY_AVAIL > 30) then 'Enough Stock'
when (PRODUCT_CLASS_DESC in ('Stationery','Clothes')) and (PRODUCT_QUANTITY_AVAIL <20) then 'Low Stock'
when (PRODUCT_CLASS_DESC in ('Stationery','Clothes')) and (PRODUCT_QUANTITY_AVAIL between 20 and 80 ) then 'In Stock'
when (PRODUCT_CLASS_DESC in ('Stationery','Clothes')) and (PRODUCT_QUANTITY_AVAIL >80) then 'Enough Stock'
end Inventory_Status 
from product p 
join product_class pc 
on p.PRODUCT_CLASS_CODE=pc.PRODUCT_CLASS_CODE;

-- 4. List customers from outside Karnataka who haven’t bought any toys or books 
select oc.CUSTOMER_ID, concat(CUSTOMER_FNAME,' ',customer_lname) Full_name, STATE  from online_customer oc 
join address a
on oc.ADDRESS_ID=a.ADDRESS_ID 
join order_header oh 
on oh.CUSTOMER_ID=oc.CUSTOMER_ID 
join order_items ot 
on ot.ORDER_ID=oh.ORDER_ID 
join product p 
on p.PRODUCT_ID=ot.PRODUCT_ID 
join product_class pc
on pc.PRODUCT_CLASS_CODE=p.PRODUCT_CLASS_CODE 
where PRODUCT_CLASS_DESC not in ('Toys' ,'Books') and (state <> 'Karnataka' or state is null)
group by oc.CUSTOMER_ID, state;

   