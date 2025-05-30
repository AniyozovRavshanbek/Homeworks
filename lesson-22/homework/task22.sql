--Easy Questions
--1.Compute Running Total Sales per Customer
select sale_id, customer_id, customer_name, 
sum(total_amount) over(partition by customer_id order by sale_id) as running_total
from sales_data;

--2.Count the Number of Orders per Product Category
select distinct product_category, count(*) over(partition by product_category) as NumberOfOrders from sales_data

--3.Find the Maximum Total Amount per Product Category
select distinct product_category, max(total_amount) over (partition by product_category) as MaxAmount from sales_data

--4.Find the Minimum Price of Products per Product Category
select distinct product_category, min(total_amount) over (partition by product_category) as MinAmount from sales_data

--5.Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)
select sale_id, total_amount, order_date, 
cast(avg(total_amount) over(order by order_date rows between 1 preceding and 1 following) as decimal(10, 2)) as MovingAvg_3Days
from sales_data;

--6.Find the Total Sales per Region
--first way with aggreagte function
select region, sum(total_amount) as TotalSales from sales_data
group by region

--second way with aggregate window function
select distinct region, sum(total_amount) over(partition by region) as TotalSales from sales_data;

--7.Compute the Rank of Customers Based on Their Total Purchase Amount
with cte as (
  select customer_id, max(customer_name) as customer_name, sum(total_amount) as TotalSales 
  from sales_data 
  group by customer_id
),
ranking as (
  select *, dense_rank() over(order by TotalSales desc) as rank_id from cte
)
select * from ranking 
order by rank_id;

--8.Calculate the Difference Between Current and Previous Sale Amount per Customer
select customer_id, customer_name ,total_amount, order_date, lag(total_amount, 1, 0) over(partition by customer_id order by order_date) as PreviousAmount,
total_amount - lag(total_amount, 1, 0) over(partition by customer_id order by order_date) as Difference
from sales_data;

--9.Find the Top 3 Most Expensive Products in Each Category
with cte as(
select product_category, product_name, unit_price,
dense_rank() over(partition by product_category order by unit_price desc) as rnk
from sales_data
)
select distinct * from cte
where rnk < 4
order by product_category, rnk;

--10.Compute the Cumulative Sum of Sales Per Region by Order Date
select region, total_amount, order_date ,sum(total_amount) over(partition by region order by order_date) 
as cumulative_sum from sales_data
select region, total_amount, 
sum(total_amount) over(partition by region) as TotalSales 
from sales_data;


--Medium Questions
--11.Compute Cumulative Revenue per Product Category
select product_category, product_name, total_amount, order_date, 
sum(total_amount) over(partition by product_category order by order_date) as cumulative_revenue from sales_data

--12.Here you need to find out the sum of previous values. Please go through the sample input and expected output.
select *, sum(number) over(order by number) as SumPreValues from numbers

--13.Sum of Previous Values to Current Value
select *, value + lag(value, 1, 0) over(order by value) as [Sum Of Previous] from OneColumn;

--14.Generate row numbers for the given data. The condition is that the first row number 
--for every partition should be odd number.For more details please check the sample input and expected output.
SELECT Id,Vals, 
ROW_Number() OVER (ORDER BY Id,Vals) + SUM(a) OVER (ORDER BY Id,vals) -  a RowNumber
FROM
(
    SELECT 
    *,   
      IIF(Id = LEAD(Id) OVER (ORDER BY Id,Vals), 0 ,
      ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals)%2)a  
    FROM Row_Nums
)k



--15.Find customers who have purchased items from more than one product_category
with cte as (
select customer_id, count(distinct product_category) as CountPurchasedItems from sales_data
group by customer_id
having count(distinct product_category) > 1
)
select sd.customer_id, sd.customer_name, sd.product_category, sd.product_name from cte 
join sales_data as sd on cte.customer_id = sd.customer_id;

--16.Find Customers with Above-Average Spending in Their Region
select customer_id, customer_name, total_amount, region from sales_data sd1
where total_amount > (select avg(total_amount) from sales_data sd2 
where sd1.region = sd2.region);

--17.Rank customers based on their total spending (total_amount) within each region. 
--If multiple customers have the same spending, they should receive the same rank.
with cte as (
select customer_id, region, sum(total_amount) as TotalSpending from sales_data
group by customer_id, region
)
select *, dense_rank() over(partition by region order by TotalSpending desc) as rank_id from cte

--18.Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.
select customer_id,customer_name,total_amount,order_date, 
sum(total_amount) over(partition by customer_id order by order_date) as cumulative_sales from sales_data;

--19.Calculate the sales growth rate (growth_rate) for each month compared to the previous month.
with cte as(
select distinct format(order_date, 'yyyy-MM')  as Date, 
sum(total_amount) over(partition by format(order_date, 'yyyy-MM') ) as total_sales from sales_data
)
select *, lag(total_sales) over(order by Date) as previous_month_sales,  
(total_sales - lag(total_sales) over(order by Date))/lag(total_sales) over(order by Date) * 100 as growth_rate_percentage
from cte;


--20.Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)
with cte as (
select *, lag(total_amount) over(partition by customer_id order by order_date) as LastOrderAmount from sales_data
)

select customer_id, customer_name, order_date, total_amount, LastOrderAmount from cte
where total_amount > LastOrderAmount;


--Hard Questions
--21.Identify Products that prices are above the average product price
select product_category, product_name, unit_price from sales_data
where unit_price > (select avg(unit_price) from sales_data)

/*
22.In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of 
the group in the new column. The challenge here is to do this in a single select. For more details please see the 
sample input and expected output.
*/
select *, 
case
	when (Grp = lead(Grp, 1, 0) over(order by Id) and lag(Grp, 1, 0) over(order by Id) <> Grp) or 
	(Grp not in (lead(Grp, 1, 0) over(order by Id), lag(Grp, 1, 0) over(order by Id)))
	then sum(Val1 + Val2) over (partition by Grp) 
	else Null
end as Tot
from MyData;

/*
23.Here you have to sum up the value of the cost column based on the values of Id. For Quantity if values are different 
then we have to add those values.Please go through the sample input and expected output for details.
*/
select id, sum(cost) as Cost,
case
	when count(distinct quantity) = 1 then max(quantity)
	else sum(Quantity)
end as Quantity
from TheSumPuzzle
group by id;

--24.From following set of integers, write an SQL statement to determine the expected outputs
with cte as (
    select 
        SeatNumber as current_seat,
        lag(SeatNumber, 1, 0) over (order by SeatNumber) as previous_seat
    FROM Seats
)
select 
    previous_seat + 1 as "Gap Start",
    current_seat - 1 as "Gap End"
from cte
where current_seat > previous_seat + 1
order by "Gap Start";

/*
25.In this puzzle you need to generate row numbers for the given data. The condition is that the first row number 
for every partition should be even number.For more details please check the sample input and expected output.
*/
SELECT Id,Vals, 
ROW_Number() OVER (ORDER BY Id,Vals) + SUM(a) OVER (ORDER BY Id,vals) -  a+1 RowNumber
FROM
(
    SELECT 
    *,   
      IIF(Id = LEAD(Id) OVER (ORDER BY Id,Vals), 0 ,
      ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals)%2)a  
    FROM Row_Nums
)k






