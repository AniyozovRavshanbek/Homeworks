--1.Write a query to assign a row number to each sale based on the SaleDate.
select *, row_number() over (order by saledate) as rn from ProductSales;

--2.Write a query to rank products based on the total quantity sold. 
--give the same rank for the same amounts without skipping numbers.
with cte as (
	select ProductName, sum(Quantity) as TotalQuantity from ProductSales
	group by ProductName
)

select *, dense_rank() over (order by TotalQuantity desc) as rank_id from cte;

--3.Write a query to identify the top sale for each customer based on the SaleAmount.
with cte as(
select *, dense_rank() over (partition by customerid order by saleamount desc) as rank_id from ProductSales
)
select CustomerID, SaleAmount from cte
where rank_id = 1;

--4.Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.
select SaleDate, SaleAmount, lead(SaleAmount) over (order by saledate) as NextSaleAmount from ProductSales;

--5.Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.
select SaleDate, SaleAmount, lag(SaleAmount) over (order by saledate) as PreviousSaleAmount from ProductSales;

--6.Write a query to identify sales amounts that are greater than the previous sale's amount
with cte as (
select SaleAmount, lag(SaleAmount, 1, 0) over (order by SaleDate) PreviousSaleAmount  from ProductSales
)

select SaleAmount from cte
where SaleAmount > PreviousSaleAmount;

--7.Write a query to calculate the difference in sale amount from the previous sale for every product
select ProductName, SaleAmount, lag(SaleAmount, 1, 0) over (partition by ProductName order by SaleDate) PreviousSaleAmount, 
SaleAmount - lag(SaleAmount, 1, 0) over (partition by ProductName order by SaleDate) Difference  from ProductSales

--8.Write a query to compare the current sale amount with the next sale amount in terms of percentage change.
select SaleAmount as CurrentSaleAmount, lead(SaleAmount, 1, 0) over (order by SaleDate) as NextSaleAmount,
cast((lead(SaleAmount, 1, 0) over (order by SaleDate) - SaleAmount) * 100/SaleAmount as decimal(10, 2)) as PercentageChange 
from ProductSales;

--9.Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.
select ProductName, SaleAmount as CurrentSaleAmount, lag(SaleAmount) over (partition by ProductName order by SaleDate) as PreviousSaleAmount,
round(SaleAmount / lag(SaleAmount) over (partition by ProductName order by SaleDate), 2) as Ratio from ProductSales;

--10.Write a query to calculate the difference in sale amount from the very first sale of that product.
select ProductName, SaleAmount, first_value(SaleAmount) over (partition by ProductName order by SaleDate) as FirstSale, 
SaleAmount - first_value(SaleAmount) over (partition by ProductName order by SaleDate) as Difference from ProductSales;

--11.Write a query to find sales that have been increasing continuously for a product 
--(i.e., each sale amount is greater than the previous sale amount for that product).
with cte as (
select *, lag(SaleAmount, 1, 0) over (partition by ProductName order by SaleDate) as PreviousAmount from ProductSales
)

select SaleID, ProductName, SaleAmount from cte
where SaleAmount > PreviousAmount;

--12.Write a query to calculate a "closing balance"(running total) for sales amounts which 
--adds the current sale amount to a running total of previous sales.
select *, sum(SaleAmount) over (order by SaleDate) as RunningTotal from ProductSales;

--13.Write a query to calculate the moving average of sales amounts over the last 3 sales.
select *,
avg(SaleAmount) over (order by SaleDate rows between 2 preceding and current row) as MovingAvg
from ProductSales;

--14.Write a query to show the difference between each sale amount and the average sale amount.
select SaleID, SaleAmount, (select avg(SaleAmount) from ProductSales) as AvgSaleAmount, 
SaleAmount - (select avg(SaleAmount) from ProductSales) as Difference from ProductSales;

--15.Find Employees Who Have the Same Salary Rank
with cte as (
select *, dense_rank() over (order by salary) as rank_id from Employees
),
cte2 as (
select rank_id, count(*) as Count from cte
group by rank_id
having count(*) > 1
)

select cte.* from cte 
join cte2 on cte.rank_id = cte2.rank_id

--16.Identify the Top 2 Highest Salaries in Each Department
with cte as(
select *, dense_rank() over (partition by Department order by Salary desc) as rank_id from Employees
)

select emp.* from cte
join Employees emp on cte.EmployeeID = emp.EmployeeID
where rank_id < 3;

--17.Find the Lowest-Paid Employee in Each Department
with cte as(
select *, dense_rank() over (partition by Department order by Salary) as rank_id from Employees
)

select emp.* from cte
join Employees emp on cte.EmployeeID = emp.EmployeeID
where rank_id = 1;

--18.Calculate the Running Total of Salaries in Each Department
select *, sum(Salary) over (partition by Department order by employeeid) as RunningTotal from Employees;

--19.Find the Total Salary of Each Department Without GROUP BY
select distinct Department, sum(Salary) over (partition by Department) as TotalSalary_PerDepartment from Employees;

--20.Calculate the Average Salary in Each Department Without GROUP BY
select distinct Department, avg(salary) over (partition by Department) as AvgSalary_PerDepartment from Employees

--21.Find the Difference Between an Employee’s Salary and Their Department’s Average
select *, avg(Salary) over (partition by Department) as AvgSalary_ByDepartment, 
cast(Salary - avg(Salary) over (partition by Department) as decimal(10, 2)) as difference from Employees

--22.Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)
select *, avg(Salary) over(order by EmployeeID rows between 1 preceding and 1 following) as 
[Moving Average Salary Over 3 Employees] from Employees;

--23.Find the Sum of Salaries for the Last 3 Hired Employees
with cte as(
select *, dense_rank() over(order by HireDate desc) as rank_id from Employees
)
select distinct sum(Salary) over() as SumOfSalaries from cte
where rank_id < 4
