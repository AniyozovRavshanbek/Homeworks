--Task 1:
--Create a stored procedure that:
--Creates a temp table #EmployeeBonus
--Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it
--(BonusAmount = Salary * BonusPercentage / 100)
--Then, selects all data from the temp table.
go
alter proc employee_bonus
as
begin
	create table #EmployeeBonus (
		EmployeeID int,
		FullName varchar(200),
		Department varchar(100),
		Salary float,
		BonusAmount float
	)

	insert into #EmployeeBonus
	select emp.EmployeeID, concat_ws(' ', emp.FirstName, emp.LastName), emp.Department, emp.Salary, emp.Salary * db.BonusPercentage/100
	from Employees as emp
	join DepartmentBonus as db on emp.Department = db.Department

	select * from #EmployeeBonus
end
exec employee_bonus

--Task 2:
--Create a stored procedure that:
--Accepts a department name and an increase percentage as parameters
--Update salary of all employees in the given department by the given percentage
--Returns updated employees from that department.
go
create proc update_employees @department_name varchar(100), @percent float
as
begin
	update Employees set Salary = Salary + Salary*@percent/100 where Department = @department_name

	select * from Employees where Department = @department_name
end

--Task 3:
--Perform a MERGE operation that:
--Updates ProductName and Price if ProductID matches
--Inserts new products if ProductID does not exist
--Deletes products from Products_Current if they are missing in Products_New
--Return the final state of Products_Current after the MERGE.
merge into Products_Current as t
using Products_new as s
on t.ProductID = s.ProductID

when matched and (t.ProductName <> s.ProductName or t.Price <> s.Price) then
update set t.ProductName = s.ProductName, t.Price = s.Price

when not matched by target then
insert (ProductID, ProductName, Price) values(s.ProductID, s.ProductName, s.Price)

when not matched by source then
delete

output $action, inserted.*, deleted.*;

select * from Products_Current;

--Task 4:
--Tree Node

--Each node in the tree can be one of three types:
--"Leaf": if the node is a leaf node.
--"Root": if the node is the root of the tree.
--"Inner": If the node is neither a leaf node nor a root node.
select id,
	case
		when p_id is null then 'Root'
		when  id in (select p_id from Tree where p_id is not null) then 'Inner'
		else 'Leaf'
	end as type
from Tree;

--Task 5:
--Confirmation Rate
--Find the confirmation rate for each user. If a user has no confirmation requests, the rate should be 0.

select s.user_id, round(avg(iif(c.action = 'confirmed', 1.00, 0)), 2) as confirmation_rate
from Signups as s
left join Confirmations as c on s.user_id = c.user_id
group by s.user_id;

--Task 6:
--Find employees with the lowest salary
--Find all employees who have the lowest salary using subqueries.
select * from employees
where salary in (select min(salary) from employees)

--Task 7:
--Create a stored procedure called GetProductSalesSummary that:
--Accepts a @ProductID input
--Returns:
--ProductName
--Total Quantity Sold
--Total Sales Amount (Quantity × Price)
--First Sale Date
--Last Sale Date
--If the product has no sales, return NULL for quantity, 
--total amount, first date, and last date, but still return the product name.
go
create proc GetProductSalesSummary @ProductID int
as
begin
select p.ProductName, t.TotalQuantitySold, t.TotalSalesAmount, t.FirstSaleDate, t.LastSaleDate from (
	select p.ProductID, sum(s.Quantity) as TotalQuantitySold, sum(p.Price * s.Quantity) as TotalSalesAmount, 
	min(s.SaleDate) as FirstSaleDate, max(s.SaleDate) as LastSaleDate
	from Products as p
	left join Sales as s on p.ProductID = s.ProductID
	where p.ProductID = @ProductID
	group by p.ProductID
	) as t
	join Products as p on t.ProductID = p.ProductID
end

