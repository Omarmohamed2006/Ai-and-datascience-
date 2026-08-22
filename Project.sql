/* 
==================================================
   BikeStore Database Analysis - SQL Script
==================================================
   Instructions: Write your SQL queries directly under each question.
   Order Status Reference:
   1 = Pending | 2 = Processing | 3 = Rejected | 4 = Completed
*/

USE BikeStores;
GO

-- ================================================
-- A. Explore Data
-- ================================================

-- Display all data on the tables:
-- 1. sales.customers:
	select *from sales.customers
-- 2. sales.orders:
		select * from sales.orders
-- 3. sales.order_items:
		select * from sales.order_items
-- 4. sales.stores:
select * from sales.stores
-- 5. sales.staffs:
	select * from sales.staffs
-- 6. production.products:
	select * from production.products
-- 7. production.categories:
		select * from production.categories
-- 8. production.brands:
select * from production.brands
-- 9. production.stocks:
select * from production.stocks


-- ================================================
-- B. Questions
-- ================================================

-- 1. Which bike is most expensive? What could be the motive behind pricing this bike at the high price?
select top(1) product_name,list_price  from production.products
		order by list_price desc
		  --​High-End Materials: The bike is likely made from lightweight, expensive materials like carbon fiber.
--​Premium Components: It features high-performance gear sets, hydraulic disc brakes, and advanced suspension systems.
--​Target Audience: Designed for professional racers or competitive cyclists who prioritize maximum speed and performance over cost.
--​Brand & R&D: Reflects the high cost of Research & Development (R&D) and brand equity.



-- 2. How many total customers does BikeStore have? Would you consider people with order status 3 as customers substantiate your answer?
select count(*) as total_customers from sales.customers
--Yes, they are considered customers:
​--Intent to Buy: Registered in the system and placed an order, showing clear interest in the products.
--​Lead Generation: Their contact information (email, phone, address) is stored, making them valuable leads for future marketing or retargeting.
--​Process Failure vs. Demand: The rejection could be due to internal store issues (out of stock, payment gateway failure, shipping restriction) rather than a lack of interest from the buyer.




-- 3. How many stores does BikeStore have?
	select count(*) as total_stores from sales.stores

-- 4. What is the total price spent per order? (Hint: total price = [list_price] * [quantity] * (1 - [discount]))
	select order_id,sum( list_price*quantity*(1-discount)) as total_price from sales.order_items
	group by order_id


-- 5. What's the sales/revenue per store? (Hint: Sales revenue = ([list_price] * [quantity] * (1 - [discount])))
select s.store_name,sum(i.list_price*i.quantity*(1-i.discount))
from sales.stores s
inner join sales.orders o on s.store_id=o.store_id
inner join sales.order_items i on o.order_id=i.order_id
group by s.store_name



-- 6. Which category is most sold?
	select c.category_name,sum(o.quantity) as total_quantity
	from production.categories c
	inner join production.products p on c.category_id=p.category_id
	inner join sales.order_items o on p.product_id=o.product_id
	group by category_name
	order by total_quantity desc

-- 7. Which category rejected more orders?
	select c.category_name,count(distinct d.order_id) as total_rejected_orders
	from production.categories c
	inner join production.products p on c.category_id=p.category_id
	inner join sales.order_items o on p.product_id=o.product_id
	inner join sales.orders d on o.order_id=d.order_id
	where d.order_status=3
	group by c.category_name
	order by total_rejected_orders desc


-- 8. Which bike is the least sold?
select p.product_name,sum(o.quantity) as least_sold
from production.products p
left join sales.order_items o on p.product_id=o.product_id
group by p.product_name
order by least_sold asc

-- 9. What's the full name of a customer with ID 259?
 select first_name+' '+last_name as customer_name      from sales.customers
 where customer_id=259
 

-- 10. What did the customer on question 9 buy and when? What's the status of this order?
		select p.product_name,d.order_status,d.order_date
		from production.products p
		inner join sales.order_items o on p.product_id=o.product_id
		inner join sales.orders d on o.order_id=d.order_id
		where d.customer_id=259


-- 11. Which staff processed the order of customer 259? And from which store?
select s.first_name+' '+s.last_name as staff_name,c.first_name+' '+c.last_name as customer_name,d.store_name
from sales.staffs s
inner join sales.orders o on s.staff_id=o.staff_id
inner join sales.customers c on o.customer_id=c.customer_id
inner join sales.stores d on o.store_id=d.store_id
where c.customer_id=259

-- 12. How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore?
select first_name+' '+last_name as lead_staff ,count(staff_id) as total_staff  from sales.staffs
where manager_id Is null;


-- 13. Which brand is the most liked?
select top(1) b.brand_name,sum(o.quantity) as most_liked
from production.brands b
inner join production.products p on b.brand_id=p.brand_id
inner join sales.order_items o on p.product_id=o.product_id
group by b.brand_name
order by most_liked desc

-- 14. How many categories does BikeStore have, and which one is the least liked?
(
select count(category_id) as number_categories from production.categories
)
select   c.category_name ,sum(o.quantity) as least_liked 
from production.categories c
inner join production.products p on c.category_id=p.category_id
left join sales.order_items o on p.product_id=o.product_id
group by c.category_name
order by least_liked asc

-- 15. Which store still have more products of the most liked brand?
select top(1) b.brand_name,sum( s.quantity)as total_products,d.store_name
from production.brands b
inner join production.products p on b.brand_id=p.brand_id
inner join production.stocks s on p.product_id=s.product_id
inner join sales.stores d on s.store_id=d.store_id
where b.brand_name='trek'
group by b.brand_name,d.store_name
order by total_products desc

-- 16. Which state is doing better in terms of sales?
select top(1)  s.state ,sum(d.quantity) as total_sales
from sales.stores s
inner join sales.orders o on s.store_id=o.store_id
inner join sales.order_items d on o.order_id=d.order_id
group by s.state
order by total_sales desc
-- 17. What's the discounted price of product id 259?
select discount  from sales.order_items
where product_id=259

-- 18. What's the product name, quantity, price, category, model year and brand name of product number 44?
select  p.product_name,p.list_price,p.model_year,b.brand_name,c.category_name,sum(s.quantity) as quantity
from production.brands b
inner join production.products p on b.brand_id=p.brand_id
inner join production.categories c on p.category_id=c.category_id
left join production.stocks s  on  p.product_id=s.product_id
where p.product_id=44
group by p.product_name,p.list_price,p.model_year,b.brand_name,c.category_name


-- 19. What's the zip code of CA?
select distinct zip_code  from sales.customers
where state='CA'

-- 20. How many states does BikeStore operate in?
	select  count(distinct state) as states_operate_in  from sales.stores

-- 21. How many bikes under the children category were sold in the last 8 months?
select c.category_name,sum(o.quantity) as total_sold
from production.categories c
inner join production.products p on c.category_id=p.category_id
inner join sales.order_items o on p.product_id=o.product_id
inner join sales.orders d on o.order_id=d.order_id
where c.category_name like '%children%' and d.order_date>=DATEADD(month,-8,getdate())
group by c.category_name

-- 22. What's the shipped date for the order from customer 523?
select shipped_date  from sales.orders
where customer_id=523

-- 23. How many orders are still pending?
	select count(order_id) as pending_orders   from sales.orders
	where order_status=1
-- 24. What's the names of category and brand does "Electra white water 3i - 2018" fall under?
 select b.brand_name ,c.category_name
 from production.brands b
 inner join production.products p on b.brand_id=p.brand_id
 inner join production.categories c on p.category_id=c.category_id
 where p.product_name='Electra white water 3i - 2018'

-- 25. Create a view that displays all completed orders with the following columns: Order ID, Customer Full Name, Store Name, Staff Name, Total Order Price
go
create view sales_summary  as
 select o.order_id, c.first_name+' '+c.last_name as customer_name,s.store_name,d.first_name+' '+d.last_name as staff_name,i.list_price
from sales.orders o
inner join sales.customers c on o.customer_id=c.customer_id
inner join sales.stores s on o.store_id=s.store_id
inner join sales.staffs d on o.staff_id=d.staff_id
inner join sales.order_items i on o.order_id=i.order_id
where o.order_status=4


-- 26. Create a view named vw_ProductDetails that contains: Product Name, Brand Name, Category Name, Model Year, List Price. Then display all data from the View.
go
create view vw_Product_Details as 
select p.product_name,b.brand_name ,c.category_name,p.model_year,p.list_price
from production.products p
inner join production.brands b on p.brand_id=b.brand_id
inner join production.categories c on p.category_id=c.category_id
go
select * from vw_Product_Details

-- 27. Create a view that shows the total sales for each store. Columns: Store Name, Total Sales
go
create view total_sales_per_store as
select s.store_name,sum(d.list_price*d.quantity*(1-d.discount))as total_sales
from sales.stores s
inner join sales.orders o on s.store_id=o.store_id
inner join sales.order_items d on o.order_id=d.order_id
group by s.store_name
go
select * from total_sales_per_store


-- 28. Using a CTE, display customers who spent more than the average customer spending. Columns: Customer ID, Customer Name, Total Spending
go
WITH CustomerSpending AS (
   
    SELECT 
        c.customer_id,
        c.first_name + ' ' + c.last_name AS customer_name,
        ISNULL(SUM(i.quantity * i.list_price * (1 - i.discount)), 0) AS total_spending
    FROM sales.customers c
    LEFT JOIN sales.orders o ON c.customer_id = o.customer_id
    LEFT JOIN sales.order_items i ON o.order_id = i.order_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)

SELECT 
    customer_id,
    customer_name,
    total_spending
FROM CustomerSpending
WHERE total_spending > (SELECT AVG(total_spending) FROM CustomerSpending)
ORDER BY total_spending DESC;


-- 29. Using a CTE, rank products from highest to lowest revenue using ROW_NUMBER(). Columns: Rank, Product Name, Revenue
go
WITH ProductRevenue AS (
    SELECT 
        p.product_name,
        ISNULL(SUM(i.quantity * i.list_price * (1 - i.discount)), 0) AS Revenue
    FROM production.products p
    LEFT JOIN sales.order_items i ON p.product_id = i.product_id
    GROUP BY p.product_name
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY Revenue DESC) AS [Rank],
    product_name AS [Product Name],
    Revenue
FROM ProductRevenue;

-- 30. Using a CTE, display the top 5 most sold bikes. Columns: Product Name, Total Quantity Sold
go
WITH ProductSales AS (
    SELECT 
        p.product_name,
        SUM(i.quantity) AS TotalQuantitySold
    FROM production.products p
    INNER JOIN sales.order_items i ON p.product_id = i.product_id
    GROUP BY p.product_name
)
SELECT TOP 5 
    product_name AS [Product Name],
    TotalQuantitySold AS [Total Quantity Sold]
FROM ProductSales
ORDER BY TotalQuantitySold DESC;

-- 31. Using a recursive CTE, display the staff hierarchy (Manager -> Employee) based on manager_id in staffs table. Columns: Staff Name, Manager Name, Level
go
WITH StaffHierarchy AS (
    SELECT 
        staff_id,
        first_name + ' ' + last_name AS StaffName,
        CAST('No Manager' AS VARCHAR(255)) AS ManagerName,
        1 AS Level
    FROM sales.staffs
    WHERE manager_id IS NULL

    UNION ALL

   
    SELECT 
        e.staff_id,
        e.first_name + ' ' + e.last_name AS StaffName,
        CAST(m.StaffName AS VARCHAR(255)) AS ManagerName,
        m.Level + 1 AS Level
    FROM sales.staffs e
    INNER JOIN StaffHierarchy m ON e.manager_id = m.staff_id
)
SELECT 
    StaffName AS [Staff Name],
    ManagerName AS [Manager Name],
    Level
FROM StaffHierarchy
ORDER BY Level, StaffName;

-- 32. Find all products whose price is higher than the average product price using a subquery.
SELECT 
    product_name,
    list_price
FROM production.products
WHERE list_price > (SELECT AVG(list_price) FROM production.products);

-- 33. Find customers who have placed more orders than the average number of orders per customer.
SELECT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name,
    COUNT(o.order_id) AS total_orders
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count * 1.0)
    FROM (
        SELECT COUNT(order_id) AS order_count
        FROM sales.orders
        GROUP BY customer_id
    ) AS CustomerOrderCounts
);

-- 34. Display the most expensive bike(s) using a subquery only.
SELECT 
    product_name,
    list_price
FROM production.products
WHERE list_price = (SELECT MAX(list_price) FROM production.products);

-- 35. Find all products that have never been ordered.
SELECT 
    product_id,
    product_name
FROM production.products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id 
    FROM sales.order_items
);

-- 36. Find the store with the highest total sales using a subquery.
SELECT TOP 1 
    s.store_name,
    SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_sales
FROM sales.stores s
INNER JOIN sales.orders o ON s.store_id = o.store_id
INNER JOIN sales.order_items i ON o.order_id = i.order_id
GROUP BY s.store_name
ORDER BY total_sales DESC;

-- 37. Display customers who purchased products from the most liked brand.

SELECT DISTINCT 
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_name
FROM sales.customers c
INNER JOIN sales.orders o ON c.customer_id = o.customer_id
INNER JOIN sales.order_items i ON o.order_id = i.order_id
INNER JOIN production.products p ON i.product_id = p.product_id
WHERE p.brand_id = (
    SELECT TOP 1 p2.brand_id
    FROM sales.order_items i2
    INNER JOIN production.products p2 ON i2.product_id = p2.product_id
    GROUP BY p2.brand_id
    ORDER BY SUM(i2.quantity) DESC
);

-- 38. Find categories whose total sales are above the average category sales.
SELECT 
    cat.category_name,
    SUM(i.quantity * i.list_price * (1 - i.discount)) AS total_sales
FROM production.categories cat
INNER JOIN production.products p ON cat.category_id = p.category_id
INNER JOIN sales.order_items i ON p.product_id = i.product_id
GROUP BY cat.category_name
HAVING SUM(i.quantity * i.list_price * (1 - i.discount)) > (
    SELECT AVG(category_total)
    FROM (
        SELECT SUM(i2.quantity * i2.list_price * (1 - i2.discount)) AS category_total
        FROM production.products p2
        INNER JOIN sales.order_items i2 ON p2.product_id = i2.product_id
        GROUP BY p2.category_id
    ) AS CategorySales
);

-- 39. Display the products whose price is greater than the average price of their category.
SELECT 
    p1.product_name,
    p1.category_id,
    p1.list_price
FROM production.products p1
WHERE p1.list_price > (
    SELECT AVG(p2.list_price)
    FROM production.products p2
    WHERE p2.category_id = p1.category_id
);

-- 40. Find the staff member who processed the highest number of completed orders.
SELECT TOP 1 
    st.staff_id,
    st.first_name + ' ' + st.last_name AS staff_name,
    COUNT(o.order_id) AS completed_orders_count
FROM sales.staffs st
INNER JOIN sales.orders o ON st.staff_id = o.staff_id
WHERE o.order_status = 4 
GROUP BY st.staff_id, st.first_name, st.last_name
ORDER BY completed_orders_count DESC;


-- ================================================
-- Bonus (Advanced SQL)
-- ================================================

-- 41. Create a view named vw_CustomerSales showing: Customer ID, Customer Name, Number of Orders, Total Spending
go 
create view CustomerSales as
select c.customer_id,c.first_name+' '+c.last_name as customer_name,count(distinct o.order_id)as Number_orders, sum(d.quantity*d.list_price*(1-d.discount)) as total_spending
from sales.customers c
left join sales.orders o on c.customer_id=o.customer_id
left join sales.order_items d on o.order_id=d.order_id
group by c.customer_id,c.first_name,c.last_name
go
select * from CustomerSales


-- 42. Using the view created in Question 41, display customers whose total spending is greater than the average spending of all customers.
select customer_id,customer_name,total_spending   from CustomerSales
where total_spending>(select AVG(total_spending) from CustomerSales)


-- 43. Using a CTE, calculate the cumulative sales by order date. Columns: Order Date, Daily Sales, Running Total
WITH DailySalesCTE AS (
    
    SELECT 
        o.order_date,
        ISNULL(SUM(i.quantity * i.list_price * (1 - i.discount)), 0) AS Daily_Sales
    FROM sales.orders o
    INNER JOIN sales.order_items i ON o.order_id = i.order_id
    GROUP BY o.order_date
)

SELECT 
    order_date AS [Order Date],
    Daily_Sales AS [Daily Sales],
    SUM(Daily_Sales) OVER (ORDER BY order_date) AS [Running Total]
FROM DailySalesCTE;

-- 44. Using a subquery, find the second most expensive bike.
SELECT TOP 1 
    product_name,
    list_price
FROM production.products
WHERE list_price < (
    
    SELECT MAX(list_price) 
    FROM production.products
)
ORDER BY list_price DESC;