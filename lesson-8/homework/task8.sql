--Easy-Level Tasks
--1.Using Products table, find the total number of products available in each category.
select Category, count(*) as TotalProducts from Products
group by Category; --grouping by Category to count products in each category

--2.Using Products table, get the average price of products in the 'Electronics' category.
select Category, avg(Price) as AvgPrice from Products
group by Category having Category = 'Electronics'; --filter to only show Electronics category

--3.Using Customers table, list all customers from cities that start with 'L'.
select * from Customers where City like 'L%'; --'L%'matches cities starting with 'L'

--4.Using Products table, get all product names that end with 'er'.
select ProductName from Products where ProductName like '%er'; --'%er' matches product names ending with 'er'

--5.Using Customers table, list all customers from countries ending in 'A'.
select * from Customers where Country like '%A'; --'%A' matches countries ending with 'A'

--6.Using Products table, show the highest price among all products.
select max(Price) as HighestPrice from Products; --max() function gets the highest price

--7.Using Products table, use IIF to label stock as 'Low Stock' if quantity < 30, else 'Sufficient'.
select *, iif(StockQuantity < 30, 'Low Stock', 'Sufficient') as StockState from Products;
--iif() is a conditional function to check stock levels

--8.Using Customers table, find the total number of customers in each country.
select Country, count(*) as TotalCustomers from Customers
group by Country; --group by country to get total count of customers in each country

--9.Using Orders table, find the minimum and maximum quantity ordered.
select min(Quantity) as minQuantity, max(Quantity) as maxQuantity from Orders;
--min() and max() functions to find the lowest and highest quantity


--Medium-Level Tasks
/*
10.Using Orders and Invoices tables, list customer IDs who placed orders in 2023 (using EXCEPT) to find those 
who did not have invoices.
*/
select CustomerID from Orders where year(OrderDate) = 2023 --filter orders from 2023
except
select CustomerID from Invoices; --subtract the customer IDs who have invoices

/*
11.Using Products and Products_Discounted table, Combine all product names from Products and 
Products_Discounted including duplicates.
*/
select ProductName from Products
union all
select ProductName from Products_Discounted;
--union all includes duplicates

/*
12.Using Products and Products_Discounted table, Combine all product names from Products and 
Products_Discounted without duplicates.
*/
select ProductName from Products
union
select ProductName from Products_Discounted;
--union removes duplicates


--13.Using Orders table, find the average order amount by year.
select year(OrderDate) as OrderYera, avg(TotalAmount) as AvgAmount from Orders
group by year(OrderDate); --group by year to calculate the average for each year

/*
14.Using Products table, use CASE to group products based on price: 'Low' (<100), 'Mid' (100-500), '
High' (>500). Return productname and pricegroup.
*/
select ProductName,
	case
		when Price < 100 then 'Low'
		when Price between 100 and 500 then 'Mid'
		else 'High'
	end as Pricegroup
from Products;
--case statement for categorizing products by price range


--15.Using Customers table, list all unique cities where customers live, sorted alphabetically.
select distinct City from Customers order by City;
--distinct removes duplicates, order by sorts alphabetically

--16.Using Sales table, find total sales per product Id.
select ProductID, sum(SaleAmount)as TotalSales from Sales
group by ProductID; --group by ProductID to get the total sales for each product

--17.Using Products table, use wildcard to find products that contain 'oo' in the name. Return productname.
select ProductName from Products where ProductName like '%oo%';
--'%oo%' matches product names containing 'oo'

--18.Using Products and Products_Discounted tables, compare product IDs using INTERSECT.
select ProductID from Products
intersect
select ProductID from Products_Discounted;
--intersect finds common product IDs in both tables

--Hard-Level Tasks
/*
19.Using Invoices table, show top 3 customers with the highest total invoice amount. 
Return CustomerID and Totalspent.
*/
select top 3 CustomerID, sum(TotalAmount) as TotalSpent from Invoices
group by CustomerID order by TotalSpent desc;


--20.Find product ID and productname that are present in Products but not in Products_Discounted.
select ProductID, ProductName from Products
except
select ProductID, ProductName from Products_Discounted;
--except returns products in Products not in Products_Discounted

/*
21.Using Products and Sales tables, list product names and the number of times each has been sold. 
(Research for Joins)
*/
select p.ProductName, count(p.ProductID) as TimesSold from Products as p
join Sales as s on p.ProductID = s.ProductID
group by p.ProductName;
--join to connect Products and Sales, then count the sales

--22.Using Orders table, find top 5 products (by ProductID) with the highest order quantities.
select top 5 ProductID, sum(Quantity) as TotalQuantity from Orders 
group by ProductID order by TotalQuantity desc;
--top 5 and order by total quantity to get the highest sold products



