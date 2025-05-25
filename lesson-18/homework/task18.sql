/*
1.Create a temporary table named MonthlySales to store the total quantity sold and total revenue for 
each product in the current month.
Return: ProductID, TotalQuantity, TotalRevenue
*/
with cte as (
select p.ProductID, sum(s.Quantity) TotalQuantity, sum(p.Price*s.Quantity) TotalRevenue from Products as p
join Sales as s on p.ProductID = s.ProductID
where year(s.SaleDate) = year(getdate()) and month(s.SaleDate) = month(getdate())
group by p.ProductID
) 

select * into #MonthlySales from cte;

/*
2.Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
Return: ProductID, ProductName, Category, TotalQuantitySold
*/
go
create view vw_ProductSalesSummary
as
	select t.ProductID, p.ProductName, p.Category, t.TotalQuantitySold from (
	select p.ProductID, sum(s.Quantity) TotalQuantitySold  from Products as p
	join Sales as s on p.ProductID = s.ProductID
	group by p.ProductID
	) as t
	join Products as p on t.ProductID = p.ProductID

/*
3.Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
Return: total revenue for the given product ID
*/
go
create function fn_GetTotalRevenueForProduct(@ProductID INT) returns table
as

	return 
		select sum(s.Quantity * p.Price) TotalRevenue from Products as p
		join Sales as s on p.ProductID = s.ProductID
		where p.ProductID = @ProductID
	
/*
4.Create an function fn_GetSalesByCategory(@Category VARCHAR(50))
Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.
*/
go
create function fn_GetSalesByCategory(@Category VARCHAR(50)) returns table
as
return
select p.ProductName, t.TotalQuantity, t.TotalRevenue from (
	select p.ProductID, sum(s.Quantity) TotalQuantity, sum(s.Quantity * p.Price) TotalRevenue from Products as p
	join Sales as s on p.ProductID = s.ProductID
	where p.Category = @Category
	group by p.ProductID
	) as t
	join Products as p on t.ProductID = p.ProductID


/*
5.You have to create a function that get one argument as input from user and the function should return 'Yes' 
if the input number is a prime number and 'No' otherwise. You can start it like this:
*/
go
create function prime (@number int)
returns varchar(3)
as
begin
    declare @i int = 2;
    declare @isprime bit = 1;

    if @number <= 1
        return 'no';

    while @i * @i <= @number
    begin
        if @number % @i = 0
        begin
            set @isprime = 0;
            break;
        end
        set @i = @i + 1;
    end

    return case when @isprime = 1 then 'yes' else 'no' end;
end;

/*
6.Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:
@Start INT
@End INT

It should include all integer values from @Start to @End, inclusive.
*/
go
create function fn_GetNumbersBetween(@start int, @end int) 
returns @numbers table(number int)
as
begin

	while @end >= @start
		begin
			insert into @numbers(number) values(@start)
			set @start += 1
		end
	return
end


/*
7.Write a SQL query to return the Nth highest distinct salary from the Employee table. 
If there are fewer than N distinct salaries, return NULL.
*/
go
create function getNthHighestSalary(@n int) returns int
as
begin
return(
	select max(salary) as MaxSALARY from (
	select salary, 
	dense_rank() over (order by salary desc) as rank
	from Employee
	) as t
	where rank = @n
)
end

/*
8.Write a SQL query to find the person who has the most friends.
Return: Their id, The total number of friends they have

Friendship is mutual. For example, if user A sends a request to user B and it's accepted, both A and B are 
considered friends with each other. The test case is guaranteed to have only one user with the most friends.
*/
with cte as (
select t.requester_id id, sum(t.f_count) num from(
select requester_id, count(accepter_id) as f_count from RequestAccepted
group by requester_id
union all
select accepter_id, count(requester_id) as f_count from RequestAccepted
group by accepter_id
) as t
group by t.requester_id
)

select * from cte where num in (select max(num) from cte)

/*
9.Create a View for Customer Order Summary.

Create a view called vw_CustomerOrderSummary that returns a summary of customer orders. 
The view must contain the following columns:
Column Name | Description
customer_id | Unique identifier of the customer
name | Full name of the customer
total_orders | Total number of orders placed by the customer
total_amount | Cumulative amount spent across all orders
last_order_date | Date of the most recent order placed by the customer
*/
go
create view vw_CustomerOrderSummary 
as
	select c.customer_id, c.name, sum(o.order_id) TotalOrders, sum(o.amount) TotalAmount, max(o.order_date) LastOrderDate
	from Customers as c
	join Orders as o on c.customer_id = o.customer_id
	group by c.customer_id, c.name;


/*
10.Write an SQL statement to fill in the missing gaps. You have to write only select statement, 
no need to modify the table.
*/
select g1.RowNumber,
        (select top 1 testCase from Gaps g2 where g2.RowNumber <= g1.RowNumber and g2.TestCase is not null order by g2.RowNumber desc)
from Gaps g1;
