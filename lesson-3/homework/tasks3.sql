--Easy-Level Tasks (9)
--1.Define and explain the purpose of BULK INSERT in SQL Server.
--BULK INSERT is used to import data from a file into a table.

--For example
bulk insert Products
from 'C:\Users\HP\Desktop\products.txt'
with (
    fieldterminator = ',',
    rowterminator = '\n',
    firstrow = 2
);

--2.List four file formats that can be imported into SQL Server.
--txt, json, csv, xml

--3.Create a table Products with columns: 
--ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).
create table Products(
	productID int primary key,
	ProductName varchar(50),
	Price decimal(10, 2)

);

--4.Insert three records into the Products table using INSERT INTO.
insert into Products
values
(1, 'apple', 1.99),
(2, 'meat', 10.59),
(3, 'juice', 0.99)


--5.Explain the difference between NULL and NOT NULL with examples.
/*
NULL is a value, which if data isn't entered into a table, table receive NULL value.
Usually, if constraints(like pk, not null) aren't added to columns, NULL value is allowed.

NOT NULL is a constraint, which it doesn't allow NULL values, and only requires real value.
*/
--For example:
create table sampleTable(
	id int primary key,--null isn't allowed because of pk constraint
	name varchar(50),--null is allowed
	price float not null --null isn't allowed due to not null constraint
);

--6.Add a UNIQUE constraint to the ProductName column in the Products table.
alter table Products add unique(ProductName);

--7.Write a comment in a SQL query explaining its purpose.
--This query retrieves all products from the Products table where the price is greater than 50.
--The result will include ProductID, ProductName, and Price.
select ProductID, ProductName, Price from Products where Price > 50;

--8.Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE.
create table Categories(
	CategoryID int primary key,
	CategoryName nvarchar(100) unique
);
--9.Explain the purpose of the IDENTITY column in SQL Server.
/*
IDENTITY keyword is used to generate unique number automatically based on parameters:
identity(1,1): the starting value is 1 and it will increment by 1 for each new record.
identity(3, 2):the starting value is 3 and it will increment by 3 for each new record.
*/


--Medium-Level Tasks (7)
--10.Use BULK INSERT to import data from a text file into the Products table.
bulk insert Products
from 'C:\Users\HP\Desktop\products.txt'
with (
    fieldterminator = ',',
    rowterminator = '\n',
    firstrow = 2
);

--11.Create a FOREIGN KEY in the Products table that references the Categories table.
alter table Products add category_id int;
alter table Products add constraint  FK_Products_Categories
foreign key (category_id) references Categories(CategoryID);


--12.Explain the differences between PRIMARY KEY and UNIQUE KEY with examples.
/*
The main two differences between PRIMARY AND UNIQUE KEY:
-PRIMARY KEY is used in table only one time, but UNIQUE KEY can be used more than one.
-PRIMARY KEY doesn't allow NULL, but the reverse is true for UNIQUE KEY.
*/


--13.Add a CHECK constraint to the Products table ensuring Price > 0.
alter table Products add check (Price > 0);

--14.Modify the Products table to add a column Stock (INT, NOT NULL).
alter table Products add Stock int not null default 50;
/*
I added default constraint because 
I have already records in the Products table in another columns
and the command demonstrates error dues to NOT NULL.
*/


--15.Use the ISNULL function to replace NULL values in a column with a default value.
select productID, ProductName, isnull(Price, 5) as Price from Products;

--16.Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.
/*
FOREIGN KEY(fk) is used to connect to external tables by using FOREIGN KEY keyword.
For example: We have two tables, passengers and securityCheck. We may connect passengers table to 
securityCheck with FOREIGN KEY.
*/


--Hard-Level Tasks (6)
--17.Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.
create table Customers(
	customer_id int primary key,
	customer_name nvarchar(100),
	customer_age int check(customer_age >= 18)
);


--18.Create a table with an IDENTITY column starting at 100 and incrementing by 10.
create table identity_numbers(
	id int primary key,
	numbers int identity(100, 10)
);

--19.Write a query to create a composite PRIMARY KEY in a new table OrderDetails.
--Note: Composite primary key means than pk used more than one in a table
create table OrderDetails(
	order_id int,
	product_id int,
	price decimal(10, 2),
	primary key(order_id, product_id)
);

--20.Explain with examples the use of COALESCE and ISNULL functions for handling NULL values.
/*
The main difference between ISNULL AND COALESCE:
ISNULL takes only 2 arguments, while COALESCE takes 2 or more arguments.
*/
--For example:
select isnull(null, 5);
select coalesce(null, 'hi', 2, null, 3.4);--it takes first value which is not null


--21.Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.
create table Employees(
	EmpID int primary key,
	Email nvarchar(100) unique
);

--22.Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.
alter table ChildTable
add constraint FK_ChildTable_ParentTable
foreign key (ParentID)
references ParentTable(ParentID)
on delete cascade
on update cascade;





