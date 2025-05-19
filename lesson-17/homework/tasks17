/*
1. You must provide a report of all distributors and their sales by region. If a distributor did not have any sales 
for a region, rovide a zero-dollar value for that day. Assume there is at least one sale for each region
*/
select t.Region, t.Distributor, isnull(rs.Sales, 0) as Sales from (
select distinct r1.Region, r2.Distributor from RegionSales as r1
cross join RegionSales as r2
) as t
left join RegionSales as rs on t.Distributor = rs.Distributor and t.Region = rs.Region
order by t.Distributor;

--2. Find managers with at least five direct reports
select emp.name from (
select manager.id, count(emp.managerId) as ReportsCount from Employee as manager
join Employee as emp on manager.id = emp.managerId
group by manager.id
having count(emp.managerId) >= 5
) as t 
join Employee as emp on t.id = emp.id;

/*
3. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.
*/
select p.product_name, t.TotalUnit from (
select p.product_id, year(o.order_date) as Year, month(o.order_date) as Month, sum(o.unit) as TotalUnit from Products as p
join Orders as o on p.product_id = o.product_id
where year(o.order_date) = 2020 and month(o.order_date) = 2
group by p.product_id, year(o.order_date), month(o.order_date)
) as t
join Products as p on t.product_id = p.product_id
where t.TotalUnit >= 100;

/*
4. Write an SQL statement that returns the vendor from which each customer has placed the most orders
*/
select o.CustomerID, o.Vendor from (
select CustomerID, max(Count) as MaxCount from Orders 
group by CustomerID
) as t
join Orders as o on t.CustomerID = o.CustomerID and t.MaxCount = o.Count
order by CustomerID;


/*
5. You will be given a number as a variable called @Check_Prime check if this number is prime then return 
'This number is prime' else eturn 'This number is not prime'
*/
DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2, @isPrime BIT = 1;

WHILE @i <= SQRT(@Check_Prime)
BEGIN
  IF @Check_Prime % @i = 0
  BEGIN
    SET @isPrime = 0;
  END
  SET @i += 1;
END

IF @Check_Prime < 2
    PRINT 'This number is not prime';
ELSE IF @isPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

/*
6. Write an SQL query to return the number of locations,in which location most signals sent, and total number of 
signal for each device from the given table.
*/
SELECT d.Device_id,
       COUNT(DISTINCT d.Locations) AS no_of_location,
       (
         SELECT TOP 1 d2.Locations
         FROM Device d2
         WHERE d2.Device_id = d.Device_id
         GROUP BY d2.Locations
         ORDER BY COUNT(*) DESC
       ) AS max_signal_location,
       COUNT(*) AS no_of_signals
FROM Device d
GROUP BY d.Device_id;

/*
7. Write a SQL to find all Employees who earn more than the average salary in their corresponding department. 
Return EmpID, EmpName,Salary in your output
*/
select EmpID, EmpName, Salary from Employee as emp1
where salary > (
select avg(Salary) from Employee as emp2
where emp1.DeptID = emp2.DeptID

);

/*
8. You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table of 
each ticket’s chosen numbers. If a ticket has some but not all the winning numbers, you win $10. 
If a ticket has all the winning numbers, you win $100. Calculate the total winnings for today’s drawing.
*/
declare @len int = (select count(Number) from WinningNumbers);
with cte as (
select t.TicketID, count(t.Number) as NumberCount from Tickets as t
join WinningNumbers as wn on t.Number = wn.Number
group by t.TicketID
)

select 
isnull(
sum(
case
	when NumberCount = @len then 100
	else 10
end
), 0) as TotalPrize

from cte;

/*
9. The Spending table keeps the logs of the spendings history of users that make purchases from an online 
shopping website which has a desktop and a mobile devices.

Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only 
and both mobile and desktop together for each date.
*/
WITH UserPlatforms AS (
    SELECT 
        User_id,
        Spend_date,
        CASE WHEN COUNT(DISTINCT Platform) = 2 THEN 'Both' 
             ELSE MAX(Platform) 
        END AS Platform_type,
        SUM(Amount) AS Amount
    FROM Spending
    GROUP BY User_id, Spend_date
),
AllDatesPlatforms AS (
    SELECT DISTINCT 
        s.Spend_date,
        p.Platform
    FROM Spending s
    CROSS JOIN (SELECT 'Mobile' AS Platform UNION SELECT 'Desktop' UNION SELECT 'Both') p
),
PlatformSummary AS (
    SELECT 
        Spend_date,
        Platform_type AS Platform,
        SUM(Amount) AS Total_Amount,
        COUNT(User_id) AS Total_users
    FROM UserPlatforms
    GROUP BY Spend_date, Platform_type
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY a.Spend_date, a.Platform) AS Row,
    a.Spend_date,
    a.Platform,
    ISNULL(p.Total_Amount, 0) AS Total_Amount,
    ISNULL(p.Total_users, 0) AS Total_users
FROM AllDatesPlatforms a
LEFT JOIN PlatformSummary p ON a.Spend_date = p.Spend_date AND a.Platform = p.Platform
ORDER BY a.Spend_date, 
    CASE a.Platform 
        WHEN 'Mobile' THEN 1 
        WHEN 'Desktop' THEN 2 
        WHEN 'Both' THEN 3 
    END;

/*
10. Write an SQL Statement to de-group the following data.
*/

with cte as (
	select 1 as n, Product, Quantity, 1 as result from Grouped
	union all
	select n+1, Product, Quantity, result from cte
	where n + 1 <= Quantity

)
select Product, result as Quantity from cte
order by Product
option (maxrecursion 0)






