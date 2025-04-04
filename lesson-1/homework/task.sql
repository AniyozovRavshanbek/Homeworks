--Homework_1
--Easy
--1
/*
Data is a collection of facts, words, texts, images, and etc. 
By analysing it, organizations can make useful decisions, predict risks, or increase profits.

Database is a collection of data and it consists of tables and other database objects.
It is used to organize, retrieve, and manipulate data.

Relational Database is one type of database and in a relational database, 
tables that consist of data are connected to each other with keys(primary and foregin).

Table is a collection of data or information in rows and columns.
*/

--2
/*
Five key feature of sql server:
1. Security
2. Backup and restore
3. BI tools like SSRS, SSIS, SSAS
4. Various tools to manage efficiently database
5. Efficient integrations system
*/

--3
/*
Two authentication types:
1. Windows authentication
2. SQL server authentication
*/


--Medium
--4
create database SchoolDB;

use SchoolDB;
--5
create table Students(
	StudentID int primary key,
	Name varchar(50),
	Age int
);

--6
/*
SQL server is a relational database management system developed by Microsoft.
SSMS(SQL Server Management Studio) is a tool to manage databases.
SQL(Structured Query Language) is a programming language and it is used to work with database, table, and other database objects by using sql commands.
*/


--Hard
--7
--DQL-data query language: select
select * from Students;

--DML-data manupulation language:insert, update, delete
insert into Students 
values
(1, 'Akbar', 19),
(2, 'Madina', 17),
(3, 'Kamol', 22)

--DDL-data definition language:create, alter, drop, truncate
create table students1(
	id int primary key,
	full_name varchar(50)
);

truncate table students1;

--DCL-data control language: grant, evoke
--TCL-transaction control language: commit, rollback, set transaction

--8
insert into Students
values
(4, 'John', 23),
(5, 'Emma', 20),
(6, 'Tom', 19)

--9
/*
There are two ways, which I know, to backup and restore database:

To backup and restore:By using database tool(SSMS)
Firstly we click right side of mouse on database which we want to backup and choose Back Up section in Tasks category.
And there we can choose file path or alter backup type, and etc.

Firstly we click right side of mouse on Databases*main) and then cock on Restore Database.
There we choose device and file path by adding it to backup file.
*/

--By using sql commands
backup database SchoolDB to DISK='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\SchoolDB.bak';--file path

restore database SchoolDB from DISK='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\AdventureWorks2022.bak';



