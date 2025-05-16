--Easy Tasks
--1.Create a numbers table using a recursive query from 1 to 1000.
create table numbers(
	number int
);
with cte as (
	select 1 as n
	union all
	select n + 1 from cte
	where n < 1000
)
insert into numbers select * from cte
option (maxrecursion 0)--to avoid limit

--2.Write a query to find the total sales per employee using a derived table.(Sales, Employees)
select tspe.EmployeeID, concat_ws(' ', emp.FirstName, emp.LastName) as FullName, tspe.TotalSales from (
select emp.EmployeeID, sum(s.SalesAmount) as TotalSales from Employees as emp
join Sales as s on emp.EmployeeID = s.EmployeeID
group by emp.EmployeeID
) as tspe
join Employees as emp on tspe.EmployeeID = emp.EmployeeID

--3.Create a CTE to find the average salary of employees.(Employees)
with AvgSalary as (
select avg(Salary) AvgSalary from Employees
)
select * from AvgSalary;

--4.Write a query using a derived table to find the highest sales for each product.(Sales, Products)
select t.ProductID, p.ProductName, t.TheHighestSales from (
select p.ProductID, max(s.SalesAmount) as TheHighestSales from Products as p
join Sales as s on p.ProductID = s.ProductID
group by p.ProductID
) as t
join Products as p on t.ProductID = p.ProductID;

/*
--5.Beginning at 1, write a statement to double the number for each record, the max value you get should be 
less than 1000000.
*/
with DoublingNumbers as (
	select 1 as n
	union all
	select n*2 from DoublingNumbers
	where n < 1000000
)
select * from DoublingNumbers where n < 1000000;

--6.Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)
with cte as (
select emp.EmployeeID, count(s.EmployeeID) as CountSales from Employees as emp
join Sales as s on emp.EmployeeID = s.EmployeeID
group by emp.EmployeeID
)
select concat_ws(' ', emp.FirstName, emp.LastName) as FullName from cte
join Employees as emp on cte.EmployeeID = emp.EmployeeID
where cte.CountSales > 5;

--7.Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)
with SpecialProducts as (
	select p.* from Products as p
	join Sales as s on p.ProductID = s.ProductID
	where s.SalesAmount > 500
)
select * from SpecialProducts;

--8.Create a CTE to find employees with salaries above the average salary.(Employees)
with cte as (
select avg(Salary) as AvgSalary from Employees
)

select * from Employees where Salary > (select AvgSalary from cte);


--Medium Tasks
--1.Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)
select top 5 emp.* from (
	select emp.EmployeeID, count(s.SalesID) as NumberOfMadeOrders from Employees as emp
	join Sales as s on emp.EmployeeID = s.EmployeeID
	group by emp.EmployeeID
) as Top5Employees
join Employees as emp on emp.EmployeeID = Top5Employees.EmployeeID
order by Top5Employees.NumberOfMadeOrders desc;

--2.Write a query using a derived table to find the sales per product category.(Sales, Products)
select t.CategoryID, t.TotalSales from (
	select p.CategoryID, sum(s.SalesAmount) as TotalSales from Products as p
	join Sales as s on p.ProductID = s.ProductID
	group by p.CategoryID
) as t;

--3.Write a script to return the factorial of each value next to it.(Numbers1)
with fac as (
	select Number, 1 as n, 1 as result from Numbers1
	union all
	select Number, n+1, result*(n+1) from fac
	where n < Number

)
select concat_ws(', ', Number, max(result)) as Result from fac
group by Number;

--4.This script uses recursion to split a string into rows of substrings for each character in the string.(Example)
with splitter as (
	select id, 1 as n, String,
	cast(substring(String, 1, 1) as varchar(100)) as Splitted
	from Example

	union all
	select id, n + 1, String, cast(substring(String, 1, n+1) as varchar(100)) from splitter
	where n < len(String)
)
select String, Splitted from splitter
order by String, Splitted
option (maxrecursion 0);

--5.Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)
WITH cte AS (
    SELECT 
        CAST(YEAR(SaleDate) AS VARCHAR) + '-' + RIGHT('0' + CAST(MONTH(SaleDate) AS VARCHAR), 2) AS YearMonth,
        DATEFROMPARTS(YEAR(SaleDate), MONTH(SaleDate), 1) AS SaleMonth,
        SUM(SalesAmount) AS TotalSales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
)
SELECT 
    cm.SaleMonth, 
    cm.TotalSales, 
    cm.TotalSales - pm.TotalSales AS Difference
FROM cte cm
LEFT JOIN cte pm ON cm.SaleMonth = DATEADD(MONTH, 1, pm.SaleMonth);


--6.Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)
select emp.EmployeeID, emp.FirstName, emp.LastName, t.Quarter, t.TotalSales from (
	select EmployeeID, datepart(q, SaleDate) as Quarter, sum(SalesAmount) as TotalSales from Sales 
	group by EmployeeID, datepart(q, SaleDate)
	having sum(SalesAmount) > 45000 
) as t
join Employees as emp on t.EmployeeID = emp.EmployeeID;


--Difficult Tasks
--1.This script uses recursion to calculate Fibonacci numbers
declare @input int = 10;

with fibo as (
	select 0 as n, 0 as fibo1, 1 as fibo2
	union all
	select n + 1, fibo2, fibo1+fibo2 from fibo
	where n < @input
)
select n, fibo1 as Result from fibo
option (maxrecursion 0)


--2.Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)
select * from FindSameCharacters
where len(replace(Vals, left(Vals, 1), '')) = 0 and len(Vals) > 1;

--3.Create a numbers table that shows all numbers 1 through n and their order gradually increasing 
--by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)
create table Numbers5(
	number varchar(100)
);
with cte as (
	select 1 as n, cast('1' as varchar(100)) as number
	union all
	select n + 1, cast(number + cast(n + 1 as varchar(100)) as varchar(100))
	from cte
	where n < 10
)
insert into Numbers5 select number from cte
option (maxrecursion 0);

/*
--4.Write a query using a derived table to find the employees who have made the most sales in the last 6 months.
(Employees,Sales)
*/
select top 1 with ties emp.EmployeeID, emp.FirstName, emp.LastName, t.TotalSale  from (
	select emp.EmployeeID, sum(s.SalesAmount) as TotalSale from Employees as emp
	join Sales as s on emp.EmployeeID = s.EmployeeID
	where s.SaleDate >= dateadd(month, -6, getdate())
	group by emp.EmployeeID
) as t
join Employees as emp on t.EmployeeID = emp.EmployeeID
order by t.TotalSale desc;

/*
--5.Write a T-SQL query to remove the duplicate integer values present in the string column. 
Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)
*/
select PawanName, Pawan_slug_name,
case 
	when len(value) > 1 and (ordinal = 2 and left(value, 1) = right(value, 1) ) then substring(Pawan_slug_name, 1, 
	charindex('-', pawan_slug_name)+1)
	when len(value) = 1 and ordinal = 2 then substring(Pawan_slug_name, 1, charindex('-', pawan_slug_name))
	else Pawan_slug_name
end as CleanedName


from RemoveDuplicateIntsFromNames
cross apply string_split(Pawan_slug_name, '-', 1)
where ordinal = 2

