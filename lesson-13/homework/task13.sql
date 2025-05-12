--Easy Tasks
/*
1.You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that 
format using employees table.
*/
--the first way
select cast(EMPLOYEE_ID as varchar(10)) + '-' + FIRST_NAME + ' ' + LAST_NAME as FullName from Employees;

--the second way
select concat(EMPLOYEE_ID, '-', FIRST_NAME, ' ', LAST_NAME) as FullName from Employees;

/*
2.Update the portion of the phone_number in the employees table, within the phone number the substring '124' 
will be replaced by '999'
*/
update Employees set PHONE_NUMBER = replace(PHONE_NUMBER, '124', '999');

/*
3.That displays the first name and the length of the first name for all employees whose name starts with the letters
'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)
*/
--the first way with left() function
select FIRST_NAME, len(FIRST_NAME) as [Length] from Employees
where left(FIRST_NAME, 1) in ('A', 'J', 'M');

--the second way with like
select FIRST_NAME, len(FIRST_NAME) as [Length] from Employees
where FIRST_NAME like '[AJM]%';

--4.Write an SQL query to find the total salary for each manager ID.(Employees table)
select MANAGER_ID, sum(SALARY) as TotalSalary from Employees
group by MANAGER_ID;

/*
5.Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for 
each row in the TestMax table
*/
select Year1, greatest(Max1, Max2, Max3) as TheHighestValue from TestMax;

--6.Find me odd numbered movies and description is not boring.(cinema)
select * from cinema where id % 2 = 1 and description <> 'boring';

/*
7.You have to sort data based on the Id but Id with 0 should always be the last row. 
Now the question is can you do that with a single order by column.(SingleOrder)
*/
select * from SingleOrder
order by 
case
	when id = 0 then 1
	else 0
end;

/*
--8.Write an SQL query to select the first non-null value from a set of columns. 
If the first column is null, move to the next, and so on. If all columns are null, return null.(person)
*/
select id, coalesce(ssn, passportid, itin) as TheFirstNonValue from person


--Medium Tasks
--1.Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)
select StudentID,
parsename(replace(FullName, ' ', '.'), 3) as FirstName,
parsename(replace(FullName, ' ', '.'), 2) as MiddleName,
parsename(replace(FullName, ' ', '.'), 1) as LatName,
Grade
from Students;

/*
2.For every customer that had a delivery to California, provide a result set of the customer orders that 
were delivered to Texas. (Orders Table)
*/
select o.* from Orders as o
join (
select distinct CustomerID from Orders
where DeliveryState = 'CA'
) as c
on o.CustomerID = c.CustomerID
where o.DeliveryState = 'TX';

--3.Write an SQL statement that can group concatenate the following values.(DMLTable)
select string_agg(string, ' ') as ConcatenatedValue from DMLTable

--4.Find all employees whose names (concatenated first and last) contain the letter "a" at least 3 times.
select * from Employees
where len(concat_ws(' ', FIRST_NAME, LAST_NAME)) - len(replace(concat_ws(' ', FIRST_NAME, LAST_NAME), 'a', '')) >= 3;

/*
5.The total number of employees in each department and the percentage of those employees who have been 
with the company for more than 3 years(Employees)
*/
select 
    Department_ID,
    count(*) as total_employees,
    sum(case when datediff(year, hire_date, getdate()) > 3 then 1 else 0 end) as over_3_years,
    cast(sum(case when datediff(year, hire_date, getdate()) > 3 then 1 else 0 end) * 100.0 / count(*) as decimal(5,2)) as percentage_over_3_years
from Employees
group by Department_ID;


--6.Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)
with t1 as (
select * from Personal
where MissionCount in (
	select max(MissionCount) from Personal
	group by JobDescription
)
),
t2 as (
select * from Personal
where MissionCount in (
	select min(MissionCount) from Personal
	group by JobDescription
))

select t1.JobDescription, t1.SpacemanID as TheMostExperienced, t2.SpacemanID as TheLeastExperienced from t1
join t2 on t1.JobDescription = t2.JobDescription;


--Difficult Tasks
/*
1.Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters 
from the given string 'tf56sd#%OqH' into separate columns.
*/
declare @str varchar(100) = 'tf56sd#%OqH';

with chars as (
    select substring(@str, number, 1) as ch from master..spt_values
    where type = 'p' and number between 1 and len(@str)
)
select
    (select string_agg(ch, '') from chars where ch like '[A-Z]') as UpperCase,
    (select string_agg(ch, '') from chars where ch like '[a-z]') as LowerCase,
    (select string_agg(ch, '') from chars where ch like '[0-9]') as Numbers,
    (select string_agg(ch, '') from chars where ch not like '[A-Za-z0-9]') as Others;


--2.Write an SQL query that replaces each row with the sum of its value and the previous rows' value. (Students table)
select s1.StudentID, s1.FullName, 
(select sum(s2.Grade) from Students as s2 where s2.StudentID <= s1.StudentID) 
from Students as s1;


/*
3.You are given the following table, which contains a VARCHAR column that contains mathematical equations. 
Sum the equations and provide the answers in the output.(Equations)
*/
CREATE FUNCTION dbo.EvalExpression (@expr VARCHAR(100))
RETURNS INT
AS
BEGIN
    DECLARE @total INT = 0;
    DECLARE @currentNum INT = 0;
    DECLARE @sign CHAR(1) = '+';
    DECLARE @i INT = 1;
    DECLARE @len INT = LEN(@expr);

    WHILE @i <= @len
    BEGIN
        DECLARE @ch CHAR(1) = SUBSTRING(@expr, @i, 1);

        IF @ch BETWEEN '0' AND '9'
        BEGIN
            SET @currentNum = @currentNum * 10 + CAST(@ch AS INT);
        END
        ELSE IF @ch IN ('+', '-')
        BEGIN
            IF @sign = '+'
                SET @total = @total + @currentNum;
            ELSE
                SET @total = @total - @currentNum;

            SET @currentNum = 0;

            SET @sign = @ch;
        END

        SET @i = @i + 1;
    END

    IF @sign = '+'
        SET @total = @total + @currentNum;
    ELSE
        SET @total = @total - @currentNum;

    RETURN @total;
END

select equation, dbo.EvalExpression(equation) as totalsum
from Equations
order by equation;

--4.Given the following dataset, find the students that share the same birthday.(Student Table)
select distinct s1.StudentName, s1.Birthday from Student as s1
join Student as s2 on (month(s1.Birthday) = month(s2.Birthday) and day(s1.Birthday) = day(s2.Birthday)) 
and s1.StudentName <> s2.StudentName
order by s1.Birthday;

/*
5.You have a table with two players (Player A and Player B) and their scores. 
If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. 
Write an SQL query to calculate the total score for each unique player pair(PlayerScores)
*/
select least(PlayerA, PlayerB) as PlayerA, greatest(PlayerA, PlayerB) as PlayerB, sum(Score) as Score from PlayerScores
group by least(PlayerA, PlayerB), greatest(PlayerA, PlayerB);


