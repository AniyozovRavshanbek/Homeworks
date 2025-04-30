--Easy-Level Tasks 
/*
1.Using the Employees and Departments tables, write a query to return the names and salaries of employees whose salary 
is greater than 50000, along with their department names.
*/
--🔁 Expected Output: EmployeeName, Salary, DepartmentName
select emp.Name, emp.Salary, dep.DepartmentName from Employees as emp
join Departments as dep on emp.DepartmentID = dep.DepartmentID
where emp.Salary > 50000;

/*
2.Using the Customers and Orders tables, write a query to display customer names and order dates for orders placed 
in the year 2023.
*/
--🔁 Expected Output: FirstName, LastName, OrderDate
select c.FirstName, c.LastName, o.OrderDate from Customers as c
join Orders as o on c.CustomerID = o.CustomerID
where year(o.OrderDate) = 2023;

/*
3.Using the Employees and Departments tables, write a query to show all employees along with their department names. 
Include employees who do not belong to any department.
*/
--🔁 Expected Output: EmployeeName, DepartmentName
--(Hint: Use a LEFT OUTER JOIN)
select emp.Name, dep.DepartmentName from Employees as emp
left join Departments as dep on emp.DepartmentID = dep.DepartmentID;

/*
4.Using the Products and Suppliers tables, write a query to list all suppliers and the products they supply. 
Show suppliers even if they don’t supply any product.
*/
--🔁 Expected Output: SupplierName, ProductName
select sup.SupplierName, p.ProductName from Suppliers as sup
left join Products as p on sup.SupplierID = p.SupplierID;

/*
5.Using the Orders and Payments tables, write a query to return all orders and their corresponding payments. 
Include orders without payments and payments not linked to any order.
*/
--🔁 Expected Output: OrderID, OrderDate, PaymentDate, Amount
select ord.OrderID, ord.OrderDate, pay.PaymentDate, pay.Amount from Orders as ord
full join Payments as pay on ord.OrderID = pay.OrderID;

--6.Using the Employees table, write a query to show each employee's name along with the name of their manager.
--🔁 Expected Output: EmployeeName, ManagerName
select employee.Name, manager.Name from Employees as employee
left join Employees as manager on manager.EmployeeID = employee.ManagerID;

/*
7.Using the Students, Courses, and Enrollments tables, write a query to list the names of students who are enrolled 
in the course named 'Math 101'.
*/
--🔁 Expected Output: StudentName, CourseName
select s.Name, c.CourseName from Students as s
join Enrollments as e on s.StudentID = e.StudentID
join Courses as c on e.CourseID = c.CourseID
where c.CourseName = 'Math 101';

/*
8.Using the Customers and Orders tables, write a query to find customers who have placed an order with more than 3 items. 
Return their name and the quantity they ordered.
*/
--🔁 Expected Output: FirstName, LastName, Quantity

select c.FirstName, c.LastName, o.Quantity from Customers as c
join Orders as o on c.CustomerID = o.CustomerID
where o.Quantity > 3;

/*
9.Using the Employees and Departments tables, write a query to list employees working in the 'Human Resources' department.
*/
--🔁 Expected Output: EmployeeName, DepartmentName
select emp.Name, dep.DepartmentName from Employees as emp
join Departments as dep on emp.DepartmentID = dep.DepartmentID
where dep.DepartmentName = 'Human Resources';


-- Medium-Level Tasks
--10.Using the Employees and Departments tables, write a query to return department names that have more than 10 employees.
--🔁 Expected Output: DepartmentName, EmployeeCount
select dep.DepartmentName, count(emp.EmployeeID)as EmployeeCount from Employees as emp
join Departments as dep on emp.DepartmentID = dep.DepartmentID
group by dep.DepartmentName
having count(emp.EmployeeID) > 10;

--11.Using the Products and Sales tables, write a query to find products that have never been sold.
--🔁 Expected Output: ProductID, ProductName
select p.ProductID, p.ProductName from Products as p
left join Sales as s on p.ProductID = s.ProductID
where s.ProductID is null;

--12.Using the Customers and Orders tables, write a query to return customer names who have placed at least one order.
--🔁 Expected Output: FirstName, LastName, TotalOrders
select c.FirstName, c.LastName, count(ord.OrderID) as NumberOfOrders from Customers as c
join Orders as ord on c.CustomerID = ord.CustomerID
group by c.FirstName, c.LastName;


/*
13.Using the Employees and Departments tables, write a query to show only those records where both employee 
and department exist (no NULLs).
*/
--🔁 Expected Output: EmployeeName, DepartmentName
select emp.Name, dep.DepartmentName from Employees as emp
join Departments as dep on emp.DepartmentID = dep.DepartmentID;

--14.Using the Employees table, write a query to find pairs of employees who report to the same manager.
--🔁 Expected Output: Employee1, Employee2, ManagerID
select emp1.Name, emp2.Name, emp1.ManagerID from Employees as emp1
join Employees as emp2 on emp1.ManagerID = emp2.ManagerID and emp2.EmployeeID > emp1.EmployeeID;

--15.Using the Orders and Customers tables, write a query to list all orders placed in 2022 along with the customer name.
--🔁 Expected Output: OrderID, OrderDate, FirstName, LastName
select o.OrderID, o.OrderDate, c.FirstName, c.LastName from Orders as o
join Customers as c on  o.CustomerID = c.CustomerID
where year(OrderDate) = 2022;

/*
16.Using the Employees and Departments tables, write a query to return employees from the 'Sales' 
department whose salary is above 60000.
*/
--🔁 Expected Output: EmployeeName, Salary, DepartmentName
select emp.Name, emp.Salary, dep.DepartmentName from Employees as emp
join Departments as dep on emp.DepartmentID = emp.DepartmentID
where emp.Salary > 60000 and dep.DepartmentName = 'Sales';

--17.Using the Orders and Payments tables, write a query to return only those orders that have a corresponding payment.
--🔁 Expected Output: OrderID, OrderDate, PaymentDate, Amount
select ord.OrderID, ord.OrderDate, pay.PaymentDate, pay.Amount from Orders as ord
join Payments as pay on ord.OrderID = pay.OrderID;

--18.Using the Products and Orders tables, write a query to find products that were never ordered.
--🔁 Expected Output: ProductID, ProductName
select p.ProductID, p.ProductName from Products as p
left join Orders as o on p.ProductID = o.ProductID
where o.ProductID is null;


--Hard-Level Tasks
/*
19.Using the Employees table, write a query to find employees whose salary is greater than the average salary of 
all employees.
*/
--🔁 Expected Output: EmployeeName, Salary
select Name, Salary from Employees
where Salary > (select avg(Salary) from Employees);

/*
20.Using the Orders and Payments tables, write a query to list all orders placed before 2020 that have 
no corresponding payment.
*/
--🔁 Expected Output: OrderID, OrderDate
select ord.OrderID, ord.OrderDate from Orders as ord
left join Payments as pay on ord.OrderID = pay.OrderID
where pay.OrderID is null and year(ord.OrderDate) < 2020;


--21.Using the Products and Categories tables, write a query to return products that do not have a matching category.
--🔁 Expected Output: ProductID, ProductName
select p.ProductID, p.ProductName from Products as p
left join Categories as c on p.Category = c.CategoryID
where c.CategoryID is null;

--22.Using the Employees table, write a query to find employees who report to the same manager and earn more than 60000.
--🔁 Expected Output: Employee1, Employee2, ManagerID, Salary
select emp1.Name, emp2.Name, emp1.ManagerID, emp1.Salary from Employees as emp1
join Employees as emp2 on emp1.ManagerID = emp2.ManagerID and emp1.EmployeeID > emp2.EmployeeID
where emp1.Salary > 60000 and emp2.Salary > 60000;


/*
23.Using the Employees and Departments tables, write a query to return employees who work in departments whose name 
starts with the letter 'M'.
*/
--🔁 Expected Output: EmployeeName, DepartmentName
select emp.Name, dep.DepartmentName from Employees as emp
join Departments as dep on emp.DepartmentID = dep.DepartmentID
where dep.DepartmentName like 'M%';

/*
24.Using the Products and Sales tables, write a query to list sales where the amount is greater than 500, 
including product names.
*/
--🔁 Expected Output: SaleID, ProductName, SaleAmount
select s.SaleID, p.ProductName, s.SaleAmount from Products as p
join Sales as s on p.ProductID = s.ProductID
where s.SaleAmount > 500;

/*
25.Using the Students, Courses, and Enrollments tables, write a query to find students who have not enrolled 
in the course 'Math 101'.
*/
--🔁 Expected Output: StudentID, StudentName
select * from Students as s
left join Enrollments as e on s.StudentID = e.StudentID
left join Courses as c on e.CourseID = c.CourseID and c.CourseName = 'Math 101'
where c.CourseID is null;


--26.Using the Orders and Payments tables, write a query to return orders that are missing payment details.
--🔁 Expected Output: OrderID, OrderDate, PaymentID
select ord.OrderID, ord.OrderDate, pay.PaymentID from Orders as ord
left join Payments as pay on ord.OrderID = pay.OrderID
where pay.PaymentID is null;

/*
27.Using the Products and Categories tables, write a query to list products that belong to either the 
'Electronics' or 'Furniture' category.
*/
--🔁 Expected Output: ProductID, ProductName, CategoryName
select p.ProductID, p.ProductName, c.CategoryName from Products as p
join Categories as c on p.Category = c.CategoryID
where c.CategoryName in ('Electronics', 'Furniture');

