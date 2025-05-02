--1.Combine Two Tables
/*
Write a solution to report the first name, last name, city, and state of each person in the Person table. 
If the address of a personId is not present in the Address table, report null instead.
*/
select p.firstName, p.lastName, a.city, a.state from Person as p
left join Address as a on p.personId = a.personId;

--2.Employees Earning More Than Their Managers
--Write a solution to find the employees who earn more than their managers.
select employee.name as Employee from Employee as manager
join Employee as employee on manager.id = employee.managerId
where employee.salary > manager.salary;

--3.Duplicate Emails
--Write a solution to report all the duplicate emails. Note that it''s guaranteed that the email field is not NULL.
select email from Person
group by email
having count(*) > 1;

--4.Delete Duplicate Emails
--Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.
--Please note that you are supposed to write a DELETE statement and not a SELECT one.
delete Person
where id in (
select p1.id from Person as p1
join Person as p2 on p1.email = p2.email and p1.id > p2.id
)

--5.Find those parents who has only girls.
--Return Parent Name only.
select distinct p1.ParentName from girls as p1
left join boys as p2 on p1.ParentName = p2.ParentName
where p2.ParentName is null;

--6.Total over 50 and least
--Find total Sales amount for the orders which weights more than 50 for each customer along with their least weight.(from TSQL2012 database, Sales.Orders Table)
select o.CustomerID, sum(o.TotalAmount) as TotalSalesAmount, min(o.Weight) as LeastWeight
from Sales.Orders as o
where o.Weight > 50
group by o.CustomerID;

--7.Carts
--You have the tables below, write a query to get the expected output
select isnull(c1.Item, ' ') as [Item Cart 1], isnull(c2.Item, ' ') as [Item Cart 2] from Cart1 as c1
full join Cart2 as c2 on c1.Item = c2.Item

--8.Customers Who Never Order
--Write a solution to find all customers who never order anything. Return the result table in any order.
select c.name as Customers from Customers as c
left join Orders as o on c.id = o.customerId
where o.customerId is null;

--9.Students and Examinations
--Write a solution to find the number of times each student attended each exam.
--Return the result table ordered by student_id and subject_name.
select s.student_id, s.student_name, sub.subject_name, count(e.student_id) as attended_exams from Students as s
cross join Subjects as sub
left join Examinations as e on s.student_id = e.student_id and sub.subject_name = e.subject_name
group by s.student_id, s.student_name, sub.subject_name 
order by s.student_id, sub.subject_name;






