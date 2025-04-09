--Basic-Level Tasks (10)
--1.Create a table Employees with columns: EmpID INT, Name (VARCHAR(50)), and Salary (DECIMAL(10,2)).
use testdatabase
create table Employees(
	EmpID int,
	Name varchar(50),
	Salary decimal(10, 2)
)


--2.Insert three records into the Employees table using different 
--INSERT INTO approaches (single-row insert and multiple-row insert).
--single-row insert
insert into Employees values(1, 'John', 95000.25);
insert into Employees values(2, 'Emma', 80000);
insert into Employees values(3, 'Tom', 110000.99);
--multiple-row insert
insert into Employees
values
(4, 'Kamol', 150000),
(5, 'Humoyun', 120000.09),
(6, 'Aziza', 99999.99)

select * from Employees;


--3.Update the Salary of an employee where EmpID = 1.
update Employees set Salary = 100000 where EmpID = 1;

--4.Delete a record from the Employees table where EmpID = 2.
delete from Employees where EmpID = 2;

--5.Demonstrate the difference between DELETE, TRUNCATE, and DROP commands on a test table.
--delete and truncate can remove all records in a table, if condition isn't given
--I have sample1 and sample3 tables
delete from sample1;--to remove all records(rows)
delete from sample1 where price > 10;--to remove records, which price > 10;

truncate table sample3;--to remove all records

drop table sample3;--to remove entire table with all columns and rows


--6.Modify the Name column in the Employees table to VARCHAR(100).
alter table Employees alter column Name varchar(100);

--7.Add a new column Department (VARCHAR(50)) to the Employees table.
alter table Employees add Department varchar(50);

--8.Change the data type of the Salary column to FLOAT.
alter table Employees alter column Salary float;


--9.Create another table Departments with columns 
--DepartmentID (INT, PRIMARY KEY) and DepartmentName (VARCHAR(50)).
create table Departments(
	DepartmentID int primary key,
	DepartmentName varchar(50)
);


--10.Remove all records from the Employees table without deleting its structure.
truncate table Employees;

--Intermediate-Level Tasks (6)
--11.Insert five records into the Departments table using INSERT INTO SELECT from an existing table.
--I have a table called Departments1 and I'll transfer its records into Departments table
insert into Departments select * from Departments1;

--12.Update the Department of all employees where Salary > 5000 to 'Management'.
--I removed all records of Employees table based on 10th task and firstly, I'll insert new data into the table
insert into Employees 
values
(1, 'John', 10000, 'Management'),
(2, 'Kamol', 2000, 'Logistics'),
(3, 'Anna', 7000, 'IT'),
(4, 'Emma', 5000, 'Marketing'),
(5, 'Tom', 5500.999, 'Human Resources');

--then update 
update Employees set Department = 'Management' where Salary > 5000;


--13.Write a query that removes all employees but keeps the table structure intact.
delete from Employees;

--14.Drop the Department column from the Employees table.
alter table Employees drop column Department;

--15.Rename the Employees table to StaffMembers using SQL commands.
exec sp_rename 'Employees', 'StaffMembers';

--16.Write a query to completely remove the Departments table from the database.
drop table Departments;


--Advanced-Level Tasks (9)
--17.Create a table named Products with at least 5 columns, including: 
--ProductID (Primary Key), ProductName (VARCHAR), Category (VARCHAR), Price (DECIMAL)
create table Products(
	ProductID int primary key,
	ProductName varchar(100),
	Category varchar(50),
	Price decimal(10,3),
	[Delivery Date] date
);

--18.Add a CHECK constraint to ensure Price is always greater than 0.
alter table Products add check (Price>0);

--19.Modify the table to add a StockQuantity column with a DEFAULT value of 50.
alter table Products add StockQuantity int default 50;

--20.Rename Category to ProductCategory
exec sp_rename 'Category','ProductCategory','column';

--21.Insert 5 records into the Products table using standard INSERT INTO queries.
insert into Products
values
(1, 'red ferrari', 'toy', 120.99, '2020-04-01', 1),
(2, 'atomic habits', 'book', 15.99, '2023-08-11', 5),
(3, 'macbook 14 pro', 'computer', 1499, '2022-12-22', 2),
(4, 'pencil', 'stationery', 0.79, '2018-11-10', 100),
(5, 't-shirt', 'clothing', 20.5, '2022-07-07', 3);

--22.Use SELECT INTO to create a backup table called Products_Backup containing all Products data.
select * into Products_Backup from Products;

--23.Rename the Products table to Inventory.
exec sp_rename 'Products', 'Inventory';

--24.Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.
alter table Inventory alter column Price float;

--25.Add an IDENTITY column named ProductCode that starts from 1000 and increments by 5.
alter table Inventory add ProductCode int identity(1000, 5);

