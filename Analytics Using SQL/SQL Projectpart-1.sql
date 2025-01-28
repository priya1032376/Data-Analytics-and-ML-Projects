/* Task 1 :
1.1 Find the top 10 customers by credit limit.
1.2 Find the average credit limit for customers in each country.
1.3 Find the number of customers in each state.
1.4 Find the customers who haven't placed any orders.
1.5 Calculate total sales for each customer.
1.6 List customers with their assigned sales representatives
1.7 Retrieve customer information with their most recent payment details. - to check
1.8 Identify the customers who have exceeded their credit limit.
1.9 Find the names of all customers who have placed an order for a product from a specific product line.
1.10 Find the names of all customers who have placed an order for the most expensive product.
*/
use modelcarsdb;
set sql_safe_updates = 0;
select * from customers;
select * from productlines;
select * from orders;
select * from products;
select * from orderdetails;
select * from payments;
select * from productline;

-- Task 1.1 Find the top 10 customers by credit limit.
select customerNumber, customerName, creditLimit from customers order by creditLimit desc limit 10;

-- Task 1.2 Find the average credit limit for customers in each country.

select country, avg(creditLimit) as 'country wise Avegrage Credit limit'  from customers group by country order by avg(creditLimit) asc;

-- Task 1.3 Find the number of customers in each state.
select count(customerNumber) as 'Total customers' , country from customers group by country order by count(customerNumber) asc;

-- Task 1.4 Find the customers who haven't placed any orders.

select CustomerNumber, customerName as 'Customer not placed any order' from customers where customerNumber not in 
(select customerNumber from orders where orderNumber in (select orderNumber from orderdetails));

-- Task 1.5 Calculate total sales for each customer.

select c.customerNumber, c.customerName, sum(od.quantityOrdered*od.priceEach) as 'Total sales' from customers c
inner join orders o on c.customerNumber = o.customerNumber
inner join orderdetails od on o.orderNumber = od.orderNumber group by c.customerNumber;

-- Task 1.6 List customers with their assigned sales representatives
select customerNumber, customerName, salesRepemployeenumber as 'Assigned Sales Representatives EMP NO.'  from customers;

-- Task 1.7 : Retrieve customer information with their most recent payment details.

-- option 1

select c.customerNumber, c.customerName from customers c where c.customerNumber in 
(select payment.customerNumber from (select p.customerNumber, max(p.paymentDate) from payments p group by customerNumber) payment);

-- option 2
select c.customerNumber, c.customerName, p.Latest_paymentDate from customers c
inner join (select p.customerNumber, max(p.paymentDate) as Latest_paymentDate from payments p group by customerNumber) p
on c.customerNumber=p.customerNumber;

/*select c.customerNumber, c.customerName, p.paymentdate from customers c
inner join payments p on c.customerNumber=p.customerNumber where p.paymentdate=(select max(p.paymentDate) 
where c.customerNumber=p.customerNumber);*/
-- Task 1.8 Identify the customers who have exceeded their credit limit.

select c.customerNumber, c.CustomerName,c.creditLimit, sum(od.quantityOrdered*od.priceEach) as Totalsales from customers c
inner join orders o on c.customerNumber = o.customerNumber
inner join orderdetails od on o.orderNumber=od.orderNumber
group by c.customerNumber
having sum(od.quantityOrdered*od.priceEach)>c.creditLimit;

-- Task 1.9 Find the names of all customers who have placed an order for a product from a specific product line.

select * from customers;
select * from orders;
select * from orderdetails;
select * from products;
select * from productlines;
select * from offices;

select c.customerNumber, c.customerName, p.productline from customers c
inner join orders o on c.customerNumber=o.customerNumber
inner join orderdetails od on o.orderNumber=od.orderNumber
inner join products p on od.productCode=p.productCode
group by p.productline, c.customerNumber, c.customerName;

-- Task 1.10 Find the names of all customers who have placed an order for the most expensive product.

select c.customerNumber, c.customerName, od.priceEach as 'Most expensive orders' from customers c
inner join orders o on c.customerNumber = o.customerNumber
inner join orderdetails od on o.orderNumber=od.ordernumber where od.priceEach = (select max(priceEach) from orderdetails);

/* Task 2: Customer Data Analysis Tasks

2.1 Count the number of employees working in each office.
2.2 Identify the offices with less than a certain number of employees.
2.3 List offices along with their assigned territories.
2.4 Find the offices that have no employees assigned to them.
2.5 Retrieve the most profitaiable office based on total sales
2.6 Find the office with the highest number of employees.
2.7 Find the average credit limit for customers in each office.
2.8 Find the number of offices in each country.
*/

-- Task 2.1 Count the number of employees working in each office.

select * from offices;
select * from employees;
select count(e.employeeNumber) as 'Office wise Emp count' , o.officecode from employees e
inner join offices o on e.officecode=o.officecode group by o.officecode;

-- 2.2 Identify the offices with less than a certain number of employees.
-- TO check

select count(e.employeeNumber) as 'Office wise Emp count' , o.officecode from employees e
inner join offices o on e.officecode=o.officecode group by o.officecode order by count(e.employeeNumber) asc;

-- 2.3 List offices along with their assigned territories.

select Officecode, territory from offices;

-- 2.4 Find the offices that have no employees assigned to them.

select * from employees;
select * from offices;
-- option 1
select o.officecode from offices o left join employees e on o.officecode=e.officecode
where e.employeeNumber is null;
-- option 2
select o.officecode from offices o where o.officecode not in (select e.officecode from employees e);

-- Task 2.5 Retrieve the most profitaiable(maximum) office based on total sales

select e.officecode as 'office', sum(od.quantityordered*od.priceEach) as 'Total sales' from orderdetails od
inner join orders o on o.orderNumber=od.orderNumber
inner join customers c on o.customerNumber=c.customerNumber
inner join employees e on e.employeeNumber=c.salesRepEmployeeNumber
group by e.officecode order by sum(od.quantityordered*od.priceEach) desc Limit 1;


-- Task 2.6 Find the office with the highest number of employees.

select * from offices;
select * from orderdetails;
select * from orders;
select * from customers;
select * from employees;

select officecode, count(employeeNumber) as 'office wise Emp count' from employees 
group by officecode order by count(employeeNumber) desc Limit 1;

-- Task 2.7 Find the average credit limit for customers in each office.

select * from customers;
select * from employees;

select avg(c.creditLimit) as 'office wise Average credot limit of customer', e.officecode from  customers c
inner join employees e on e.employeeNumber=c.salesRepEmployeeNumber group by e.officecode order by avg(c.creditLimit) desc;

-- Find the number of offices in each country.

select * from offices;
select count(officecode) as office_count, country from offices group by country;



/* Task 3: Product Data Analysis
3.1 Count the number of products in each product line.
3.2 Find the product line with the highest average product price.
3.3 Find all products with a price above or below a certain amount (MSRP should be between 50 and 100).
3.4 Find the total sales amount for each product line.
3.5 Identify products with low inventory levels (less than a specific threshold value of 10 for quantityInStock).
3.6 Retrieve the most expensive product based on MSRP.
3.7 Calculate total sales for each product.
3.8 Identify the top selling products based on total quantity ordered using a stored procedure. The procedure should accept an input parameter to specify the number of top-selling products to retrieve.
3.9 Retrieve products with low inventory levels (less than a threshold value of 10 for quantityInStock) within specific product lines ('Classic Cars', 'Motorcycles').
3.10 Find the names of all products that have been ordered by more than 10 customers.
3.11 Find the names of all products that have been ordered more than the average number of orders for their product line.
*/

-- Task 3.1 Count the number of products in each product line.
select * from products;

select count(productcode) as 'no. of products', productline from products group by productline order by count(productcode) desc;

-- Task 3.2 Find the product line with the highest average product price.

select avg(msrp) as 'highest average product prince', productline from products group by productline order by avg(msrp) limit 1;

-- Task 3.3 Find all products with a price above or below a certain amount (MSRP should be between 50 and 100).

select MSRP, ProductCode, productName from products where MSRP between 50 and 100 order by msrp asc;

-- Task 3.4 Find the total sales amount for each product line.

select sum(od.priceEach*od.quantityordered) as 'Total Sales', p.productline from products p
inner join orderdetails od on od.productcode=p.productcode group by p.productline;

-- Task 3.5 Identify products with low inventory levels (less than a specific threshold value of 10 for quantityInStock).

select * from products;
select * from orderdetails;

select p.productcode, p.productline, p.quantityinstock as 'Qty in stock', coalesce(sum(od.quantityordered),0) as Ordered_qty, (p.quantityinstock-coalesce(sum(od.quantityordered),0)) as 'Inventory level'
from products p
left join orderdetails od on od.productcode=p.productcode group by p.productcode
having p.quantityinstock-coalesce(sum(od.quantityordered),0) <10;


 -- Task 3.6 Retrieve the most expensive product based on MSRP.
 
select max(msrp) as 'most expensive' , productName, productline from products group by productline,productName order by max(msrp) desc limit 1;
-- or
select * from products order by MSRP desc limit 1;


-- Task 3.7 Calculate total sales for each product.

select sum(quantityordered*priceEach) as Total_sales, productcode from orderdetails group by productcode order by sum(quantityordered*priceEach);

-- Task 3.8 Identify the top selling products based on total quantity ordered using a stored procedure. 
-- The procedure should accept an input parameter to specify the number of top-selling products to retrieve.



DELIMITER $$
CREATE PROCEDURE `top_selling_product`(in top_products int)
BEGIN
select p.productcode, p.productName, sum(od.quantityOrdered) as 'Total Quantity ordered' from products p
inner join orderdetails od on od.productcode=p.productcode group by p.productcode, p.productname
order by sum(od.quantityOrdered) desc
limit top_products;
END$$

call modelcarsdb.top_selling_product(5);


/* Task 3.9 Retrieve products with low inventory levels (less than a threshold value of 10 for quantityInStock) 
within specific product lines ('Classic Cars', 'Motorcycles'). */

select * from products;
select * from orderdetails;
select * from orders;

select p.productcode, p.productName, p.productline, p.quantityinstock, coalesce(sum(od.quantityordered),0)  as 'Total qty ordered', p.quantityinstock-coalesce(sum(od.quantityordered),0) as Inventory_Stock
from products p inner join orderdetails od on p.productcode=od.productcode group by p.productline, p.productcode
having p.quantityinstock-coalesce(sum(od.quantityordered),0) < 10 AND p.productline in ('Classic Cars', 'Motorcycles');


-- Task 3.10 Find the names of all products that have been ordered by more than 10 customers.

select * from products;
select * from orderdetails;
select * from orders;

select p.productcode, p.productName, count(distinct o.customerNumber) as 'no. of orders placed by customer' from products p
inner join orderdetails od on od.productcode=p.productcode
inner join orders o on o.ordernumber=od.ordernumber
group by  p.productcode, p.productName having count(distinct o.customerNumber) > 10;


-- Task 3.11 Find the names of all products that have been ordered more than the average number of orders for their product line.

select p.productcode, p.productName, p.productLine, sum(od.quantityordered) from products p
inner join orderdetails od on od.productcode=p.productcode
group by p.productcode, p.productName having sum(od.quantityordered) > avg(od.quantityordered);




