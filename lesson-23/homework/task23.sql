/*
Puzzle 1: In this puzzle you have to extract the month from the dt column and then append zero single digit month if any. 
Please check out sample input and expected output.
*/
select *,
case
	when len(month(Dt)) = 1 then '0' + cast(month(dt) as char(2))
	else cast(month(dt) as char(2))
end as MonthPrefixedWithZero
from Dates;

/*
Puzzle 2: In this puzzle you have to find out the unique Ids present in the table. You also have to find out the SUM of 
Max values of vals columns for each Id and RId. For more details please see the sample input and expected output.
*/
with cte as (
select id, rID, max(Vals) as Max from MyTabel
group by id, rID
)

select count(id) as Distinct_Ids, rID, sum(Max) as TotalOfMaxVals from cte
group by rID;

/*
Puzzle 3: In this puzzle you have to get records with at least 6 characters and maximum 10 characters. 
Please see the sample input and expected output.
*/
select * from TestFixLengths
where len(Vals) between 6 and 10;

/*
Puzzle 4: In this puzzle you have to find the maximum value for each Id and then get the Item for that Id and 
Maximum value. Please check out sample input and expected output.
*/
with cte as(
select *,
dense_rank() over (partition by id order by Vals desc) as rank_id
from TestMaximum
)

select ID, Item, Vals from cte
where rank_id = 1;

/*
Puzzle 5: In this puzzle you have to first find the maximum value for each Id and DetailedNumber, 
and then Sum the data using Id only. Please check out sample input and expected output.
*/
with cte as (
select DetailedNumber, id, max(Vals) as MaxVals from SumOfMax
group by DetailedNumber, id
)

select id, sum(MaxVals) as SumOfMax from cte
group by id;

/*
Puzzle 6: In this puzzle you have to find difference between a and b column between each row and if the difference 
is not equal to 0 then show the difference i.e. a – b otherwise 0. Now you need to replace this zero with blank.
Please check the sample input and the expected output.
*/
select *, 
	case
		when a - b = 0 then ' '
		else cast(a - b as varchar(100))
	end as Output
from TheZeroPuzzle;

--7.What is the total revenue generated from all sales?
select sum(QuantitySold*UnitPrice) as TotalRevenue from Sales

--8.What is the average unit price of products?
select avg(UnitPrice) as AvgUnitPrice from Sales

--9.How many sales transactions were recorded?
select count(*) as TotalTransactions from Sales

--10.What is the highest number of units sold in a single transaction?
select max(QuantitySold) as HighestUnitsSold from Sales

--11.How many products were sold in each category?
select Category, sum(QuantitySold) as TotalSold from Sales
group by Category

--12.What is the total revenue for each region?
select Region, sum(QuantitySold * UnitPrice) as TotalRevenue from Sales
group by Region;

--13.Which product generated the highest total revenue?
with cte as(
select Product, sum(QuantitySold * UnitPrice) as TotalRevenue from Sales
group by Product
) 
select * from cte
where TotalRevenue in (select max(TotalRevenue) from cte);

--14.Compute the running total of revenue ordered by sale date.
select *, 
sum(QuantitySold * UnitPrice) over(order by saledate) as RunningTotalRevenue 
from Sales;

--15.How much does each category contribute to total sales revenue?
with cte as (
select distinct Category, sum(QuantitySold * UnitPrice) over() as TotalRevenue,
sum(QuantitySold * UnitPrice) over (partition by Category) as TotalRevenue_PerCategory
from Sales
)

select *, TotalRevenue_PerCategory/TotalRevenue * 100 as ContributionPercent from cte

--17.Show all sales along with the corresponding customer names
select s.*, c.CustomerName from Customers as c
join Sales as s on c.CustomerID = s.CustomerID

--18.List customers who have not made any purchases
--first way with join
select c.* from Customers as c
left join Sales as s on c.CustomerID = s.CustomerID
where s.SaleID is null;

--second way with subquery
select * from Customers
where CustomerID not in (select CustomerID from Sales)

--19.Compute total revenue generated from each customer
select c.CustomerID, c.CustomerName, sum(s.QuantitySold*s.UnitPrice) as TotalRevenue from Customers as c
join Sales as s on c.CustomerID = s.CustomerID
group by c.CustomerID, c.CustomerName

--20.Find the customer who has contributed the most revenue
select top 1 c.CustomerID, c.CustomerName, sum(s.QuantitySold*s.UnitPrice) as TotalRevenue from Customers as c
join Sales as s on c.CustomerID = s.CustomerID
group by c.CustomerID, c.CustomerName
order by TotalRevenue desc

--21.Calculate the total sales per customer
select c.CustomerID, c.CustomerName, count(s.SaleID) as TotalSales from Customers as c
join Sales as s on c.CustomerID = s.CustomerID
group by c.CustomerID, c.CustomerName

--22.List all products that have been sold at least once

--in the Sales table, there isn't product_id column to connect to the Product table, 
--so I can only use ProductName to connect them
select p.* from Products as p
join Sales as s on p.ProductName = s.Product

--23.Find the most expensive product in the Products table
select * from Products
where CostPrice in (select max(CostPrice) from Products)

--24.Find all products where the selling price is higher than the average selling price in their category
select * from Products as p1
where SellingPrice > (select avg(SellingPrice) from Products as p2 where p1.Category = p2.Category)

