--Easy-Level Tasks (10)
--1.Using Products, Suppliers table List all combinations of product names and supplier names.
select p.ProductName, s.SupplierName from Products as p
cross join Suppliers as s;

--2.Using Departments, Employees table Get all combinations of departments and employees.
select * from Departments
cross join Employees;

/*
3.Using Products, Suppliers table List only the combinations where the supplier actually supplies the product. 
Return supplier name and product name
*/
select s.SupplierName, p.ProductName from Products as p
join Suppliers as s on p.SupplierID = s.SupplierID;

--4.Using Orders, Customers table List customer names and their orders ID.
select concat_ws(' ',c.FirstName, c.LastName) as FullName, o.OrderID from Customers as c
join Orders as o on c.CustomerID = o.CustomerID;

--5.Using Courses, Students table Get all combinations of students and courses.
select * from Students
cross join Courses;

--6.Using Products, Orders table Get product names and orders where product IDs match.
select p.ProductName, o.* from Products as p
join Orders as o on p.ProductID = o.ProductID;

--7.Using Departments, Employees table List employees whose DepartmentID matches the department.
select emp.* from Employees as emp
join Departments as dep on emp.DepartmentID = dep.DepartmentID;

--8.Using Students, Enrollments table List student names and their enrolled course IDs
select s.Name, e.CourseID from Students as s
join Enrollments as e on s.StudentID = e.StudentID;

--9.Using Payments, Orders table List all orders that have matching payments.
select Orders.* from Orders
join Payments on Orders.OrderID = Payments.OrderID;

--10.Using Orders, Products table Show orders where product price is more than 100.
select o.* from Orders as o
join Products as p on o.ProductID = p.ProductID
where p.Price > 100;


--Medium (10 puzzles)
/*
--11.Using Employees, Departments table List employee names and department names where department IDs are not equal.
It means: Show all mismatched employee-department combinations.
*/
select emp.Name, dep.DepartmentName from Employees as emp
join Departments as dep on emp.DepartmentID <> dep.DepartmentID;

--12.Using Orders, Products table Show orders where ordered quantity is greater than stock quantity.
select ord.* from Orders as ord
join Products as p on ord.ProductID = p.ProductID
where ord.Quantity > p.StockQuantity;

--13.Using Customers, Sales table List customer names and product IDs where sale amount is 500 or more.
select concat_ws(' ', c.FirstName, c.LastName) as FullName, s.ProductID from Customers as c
join Sales as s on c.CustomerID = s.CustomerID
where s.SaleAmount >= 500;

--14.Using Courses, Enrollments, Students table List student names and course names they’re enrolled in.
select s.Name, c.CourseName from Students as s
join Enrollments as e on s.StudentID = e.StudentID
join Courses as c on e.CourseID = c.CourseID;

--15.Using Products, Suppliers table List product and supplier names where supplier name contains “Tech”.
select p.ProductName, s.SupplierName from Products as p
join Suppliers as s on p.SupplierID = s.SupplierID
where s.SupplierName like '%Tech%';

--16.Using Orders, Payments table Show orders where payment amount is less than total amount.
select ord.* from Orders as ord
join Payments as pay on ord.OrderID = pay.OrderID
where pay.Amount < ord.TotalAmount;

--17.Using Employees table List employee names with salaries greater than their manager’s salary.
select employee.Name from Employees as manager
join Employees as employee on manager.EmployeeID = employee.ManagerID
where employee.Salary > manager.Salary;

--18.Using Products, Categories table Show products where category is either 'Electronics' or 'Furniture'.
select p.* from Products as p
join Categories as c on p.Category = c.CategoryID
where c.CategoryName in ('Electronics', 'Furniture');

--19.Using Sales, Customers table Show all sales from customers who are from 'USA'.
select s.* from Sales as s
join Customers as c on s.CustomerID = c.CustomerID
where c.Country = 'USA';

--20.Using Orders, Customers table List orders made by customers from 'Germany' and order total > 100.
select ord.* from Orders as ord
join Customers as c on ord.CustomerID = c.CustomerID
where c.Country = 'Germany' and ord.TotalAmount > 100;

--Hard (5 puzzles)
--21.Using Employees table List all pairs of employees from different departments.
select emp1.Name, emp2.Name from Employees as emp1
join Employees as emp2 on emp1.DepartmentID != emp2.DepartmentID and emp1.EmployeeID < emp2.EmployeeID;

/*
22.Using Payments, Orders, Products table List payment details where the paid amount is not equal to 
(Quantity × Product Price).
*/
select pay.* from Payments as pay
join Orders as o on pay.OrderID = o.OrderID
join Products as p on o.ProductID = p.ProductID
where pay.Amount <> o.Quantity*p.Price;

--23.Using Students, Enrollments, Courses table Find students who are not enrolled in any course.
select s.* from Students as s
left join Enrollments as e on s.StudentID = e.StudentID
where e.StudentID is null;

/*
24.Using Employees table List employees who are managers of someone, but their salary is less than or equal to 
the person they manage.
*/
select manager.* from Employees as manager
join Employees as employee on manager.EmployeeID = employee.ManagerID
where manager.Salary <= employee.Salary;

--25.Using Orders, Payments, Customers table List customers who have made an order, but no payment has been recorded for it.
select c.* from Customers as c
join Orders as o on c.CustomerID = o.CustomerID
left join Payments as p on p.OrderID = o.OrderID
where p.OrderID is null;
