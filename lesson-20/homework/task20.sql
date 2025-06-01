--1. Find customers who purchased at least one item in March 2024 using EXISTS
select * from Sales s1
where exists(select * from Sales s2 where s1.SaleID = s2.SaleID and month(s2.SaleDate) = 3 and year(s2.SaleDate) = 2024)

--2. Find the product with the highest total sales revenue using a subquery.
with cte as (
	select Product, sum(Quantity * Price) as TotalRevenue from Sales
	group by Product
)

select Product from cte
where TotalRevenue in (select max(TotalRevenue) from cte);

--3. Find the second highest sale amount using a subquery
with cte as (
select *, sum(Quantity * Price) over (partition by SaleID) as SaleAmount from Sales
)
select * from cte c1
where (select count(distinct SaleAmount) from cte c2 where c2.SaleAmount > c1.SaleAmount) = 1

--4. Find the total quantity of products sold per month using a subquery
select * from (
select format(SaleDate, 'yyyy-MM') as Date, sum(Quantity) as TotalQuantity from Sales
group by format(SaleDate, 'yyyy-MM')
) as t

--5. Find customers who bought same products as another customer using EXISTS
select * from Sales s1
where exists(select * from Sales s2 where s1.Product = s2.Product and s1.SaleID <> s2.SaleID)

--6. Return how many fruits does each person have in individual fruit level
select Name, [Apple] as Apple, [Orange] as Orange, [Banana] as Banana from (
select Name, Fruit from Fruits
) as t

pivot(
count(fruit) for Fruit in ([Apple], [Orange], [Banana])
) as pvt;


--7. Return older people in the family with younger ones
select ParentId, ch.ChildID from Family p
join (
select childid from Family 
) ch on ch.ChildID > p.ParentId
order by ParentId;

/*
8. Write an SQL statement given the following requirements. For every customer that had a delivery to California, 
provide a result set of the customer orders that were delivered to Texas
*/
with cte as (
select * from Orders
where DeliveryState = 'CA'
)

select o.* from cte as c
join Orders as o on c.CustomerID = o.CustomerID
where o.DeliveryState = 'TX';

--9. Insert the names of residents if they are missing
update residents set address = address + ' name=' + fullname
where address not like '%name=' + fullname + '%'

/*
10. Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and 
the most expensive routes
*/
--recursive cte to find all paths from tashkent
with route_cte as (
    select 
        routeid,
        departurecity,
        arrivalcity,
        cast(departurecity + ' - ' + arrivalcity as varchar(500)) as route,
        cost as totalcost,
        cast(departurecity + ',' + arrivalcity as varchar(500)) as visited
    from routes
    where departurecity = 'Tashkent'

    union all

    select 
        r.routeid,
        c.arrivalcity,
        r.arrivalcity,
        cast(c.route + ' - ' + r.arrivalcity as varchar(500)),
        c.totalcost + r.cost,
        cast(c.visited + ',' + r.arrivalcity as varchar(500))
    from route_cte c
    join routes r
        on c.arrivalcity = r.departurecity
        and charindex(r.arrivalcity, c.visited) = 0
)

--select cheapest and most expensive route using subqueries and union
select route, cost from (
    select top 1 route, totalcost as cost
    from route_cte
    where arrivalcity = 'Khorezm'
    order by totalcost asc
) as cheapest

union

select route, cost from (
    select top 1 route, totalcost as cost
    from route_cte
    where arrivalcity = 'Khorezm'
    order by totalcost desc
) as most_expensive;


--11. Rank products based on their order of insertion.
select Vals, ID, row_number() over(order by ID) as rank_id from RankingPuzzle
where Vals = 'Product';

--12.Find employees whose sales were higher than the average sales in their department
select * from EmployeeSales emp1
where emp1.SalesAmount > (select avg(emp2.SalesAmount) from EmployeeSales emp2 where emp1.Department = emp2.Department);

--13. Find employees who had the highest sales in any given month using EXISTS
select * from EmployeeSales emp1
where exists(select * from EmployeeSales emp2
where emp1.SalesMonth = emp2.SalesMonth and emp1.SalesYear = emp2.SalesYear
group by emp2.SalesMonth, emp2.SalesYear
having emp1.SalesAmount = max(emp2.SalesAmount)
)

--14. Find employees who made sales in every month using NOT EXISTS
select distinct e1.employeename from EmployeeSales e1
where not exists (
    select distinct s.salesmonth from EmployeeSales s
    where s.salesyear = 2024

    except

    select distinct e2.salesmonth from EmployeeSales e2
    where e2.employeename = e1.employeename and e2.salesyear = 2024
)


--15. Retrieve the names of products that are more expensive than the average price of all products.
select Name from Products
where Price > (select avg(Price) from Products)

--16. Find the products that have a stock count lower than the highest stock count.
select * from Products
where Stock < (select max(Stock) from Products)

--17. Get the names of products that belong to the same category as 'Laptop'.
select Name from Products
where Category in (select Category from  Products where Name = 'Laptop')

--18. Retrieve products whose price is greater than the lowest price in the Electronics category.
select * from Products
where Price > (select min(Price) from Products where Category = 'Electronics')

--19. Find the products that have a higher price than the average price of their respective category.
select * from Products p1
where p1.Price > (select avg(p2.Price) from Products p2 where p1.Category = p2.Category)

--20. Find the products that have been ordered at least once.
select p.* from Products as p
join Orders1 as o on p.ProductID = o.ProductID

--21. Retrieve the names of products that have been ordered more than the average quantity ordered.
select p.Name from Products as p
join Orders1 as o on p.ProductID = o.ProductID
where o.Quantity > (select avg(Quantity) as AvgQuantity from Orders1)

--22. Find the products that have never been ordered.
select p.* from Products as p
left join Orders1 as o on p.ProductID = o.ProductID
where o.OrderID is null;

--23. Retrieve the product with the highest total quantity ordered.
--with subquery
select p.* from Products as p
where p.ProductID in (
  select top 1 ProductID 
  from Orders1 
  group by ProductID 
  order by sum(Quantity) desc
)


--with join
with cte as (
  select ProductID, sum(Quantity) as TotalQuantity from Orders1
  group by ProductID
)

select p.* from Products p
join cte on p.ProductID = cte.ProductID
where TotalQuantity in (select max(TotalQuantity) from cte)
