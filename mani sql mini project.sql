create database amazon;
select SupplierID from amazon.Products;

-- Task 3: Write a query to: 

-- Retrieve all customers from a specific city. 
select * from amazon.customers
where city = 'Bettyport';

-- Fetch all products under the "Fruits" category.
select * from amazon.products
where category = 'Fruits';

-- ● Task 4: Write DDL statements to recreate the Customers table with the following constraints: 
-- CustomerID as the primary key.

-- Ensure Age cannot be null and must be greater than 18.
alter table amazon.customers
modify age int not null check(age>=18);

-- Add a unique constraint for Name.
alter table amazon.customers
modify Name varchar(100) unique;

-- Task 5: Insert 3 new rows into the Products table using INSERT statements. 
insert into amazon.products (productID,productname,category,subcategory,priceperunit,stockquantity,supplierid)
value  ('gh389dhneekeybssgs','puremilk','diary','subdiary',24,21,'mnsuoiehdshsuhd'),
('hsnamakdgeeu36272','gheemilk','diary2','subdiary2',50,80,'mak7543gdyg39d8'),
('mk27dfvs564bsj','milkwhitechoclate','diary3','subdiary3',54,67,'bvdgywbhb356729');

-- Task 6: Update the stock quantity of a product where ProductID matches a specific ID.
select * from amazon.products
where productid = '2827710f-0130-4156-8d19-6b3a3cfbbf98';
set sql_safe_updates=0;
update amazon.products
set StockQuantity = 9000
where productid = '2827710f-0130-4156-8d19-6b3a3cfbbf98';

-- Task 7: Delete a supplier from the Suppliers table where their city matches a specific value. 
select city from amazon.suppliers;
select supplierid from amazon.suppliers
where city = 'South Ana';
delete from amazon.suppliers
where SupplierID = '03ec3130-f542-432e-b173-f110efd69026';

-- Task 8: Use SQL constraints to: 
-- Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5
alter table amazon.reviews
modify rating int check (rating between 1 and 5);
-- Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No").
alter table  amazon.customers
modify PrimeMember varchar(100) default('No');

-- Task 9: Write queries using:
-- WHERE clause to find orders placed after 2024-01-01.
select * from amazon.orders
where OrderDate > 2024-01-01;
-- HAVING clause to list products with average ratings greater than 4. 
select productID,avg(rating) as avg_rating
from amazon.reviews
group by productID
having avg(rating) > 4;
-- GROUP BY and ORDER BY clauses to rank products by total sales. 
select productID, sum(quantity * unitprice) as total_sales
from amazon.order_details
group by productID
order by total_sales desc;

-- Task 10: Identifying High-Value Customers 
-- Scenario: 
-- Amazon Fresh wants to identify top customers based on their total spending. We will: 
-- 1. Calculate each customer's total spending. 
 select customerID,sum(orderAmount)
 from amazon.orders
 group by CustomerID;
 -- Rank customers based on their spending. 
 select customerid,sum(orderamount) from amazon.orders
 group by CustomerID;
 select o.customerid,c.name,sum(orderamount)as total_amt, rank() over (order by sum(orderamount) desc)as Ranks
 from amazon.orders as o
 inner join amazon.customers as c
 on o.CustomerID = c.CustomerID
 group by o.CustomerID,c.name;
 -- Identify customers who have spent more than ₹5,000. 
 select o.customerid,c.name,sum(orderamount)
 from amazon.orders as o
 inner join amazon.customers as c
 on o.CustomerID = c.CustomerID
 group by o.CustomerID,c.name
 having o.customerid > 5000;
 
 -- Task 11: Use SQL to: 
-- Join the Orders and OrderDetails tables to calculate total revenue per order. 
select o.orderid,sum(od.quantity*od.unitprice) as total_revenue
from amazon.orders as o
join amazon.order_details as od
on o.orderid=od.OrderID
group by orderid; 
-- Identify customers who placed the most orders in a specific time period.
select orderdate from amazon.orders;
select customerid,count(customerid)
from amazon.orders
group by CustomerID
order by count(CustomerID) desc;
-- Find the supplier with the most products in stock. 
select s.suppliername,s.SupplierID,sum(p.stockquantity) as total_stock
from amazon.suppliers as s
inner join amazon.products as p
on s.SupplierID = p.SupplierID
group by s.suppliername,s.SupplierID
order by total_stock desc limit 1;

-- Task 12: Normalize the Products table to 3NF: 
-- Separate product categories and subcategories into a new table. 
create table amazon.categories(ProductID varchar(100),ProductName varchar(100),category varchar(100));
insert into amazon.categories(productid,productname,category)
values ('0006853b-74cb-44a2-91ed-699aa31c5b5b','Particularly Baker','Bakery'),
('0219aafa-5dbc-4d92-acd9-8a78b4158651','Enter Dair','Dairy'),
('0297061c-1241-4540-ac99-ac6a44fa507e','We Baker','Bakery'),
('02c7c358-da33-4586-8e32-5e459b7394fc','Early Snack','Snacks');

-- Separate product categories and subcategories into a new table.
create table amazon.subcategories (productID varchar(100), subcategories varchar(100));
insert into amazon.subcategories (productID,subcategories)
values ('0006853b-74cb-44a2-91ed-699aa31c5b5b','Sub-Bakery-1'),
('0219aafa-5dbc-4d92-acd9-8a78b4158651','Sub-Dairy-3'),
('0297061c-1241-4540-ac99-ac6a44fa507e','Sub-Bakery-4'),
('02c7c358-da33-4586-8e32-5e459b7394fc','Sub-Snacks-1');


-- Task 13: Write a subquery to: 
-- Identify the top 3 products based on sales revenue.
select productID,sum(quantity * unitprice) as sales_revenue
from amazon.order_details
group by ProductID
order by sum(Quantity * unitprice) desc limit 3;
-- Find customers who haven’t placed any orders yet. 
select c.customerid,c.name as customer_name,o.orderid
from amazon.customers as c
left join amazon.orders as o
on c.CustomerID = o.CustomerID
where o.OrderID is null;

-- Task 14: Provide actionable insights: 
-- Which cities have the highest concentration of Prime members? 
select city,count(*) as prime_member from amazon.customers
where PrimeMember = 'yes'
group by city
order by count(*) desc limit 1;
-- What are the top 3 most frequently ordered categories? 
select od.orderid,od.productid,count(p.category)
from amazon.products as p
inner join amazon.order_details as od
on od.ProductID = p.ProductID
group by od.OrderID,od.ProductID
order by count(p.category) desc limit 3;








