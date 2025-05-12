--Easy Tasks
--1.Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)
--the first way with substring()
select id,
substring(Name, 1, charindex(',', Name)-1) as Name,
substring(Name, charindex(',', Name)+1, len(Name)) as Surname
from TestMultipleColumns;

--the second way with parsename()
select id,
parsename(replace(Name, ',', '.'), 2) as Name,
parsename(replace(Name, ',', '.'), 1) as Surname
from TestMultipleColumns;

--2.Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)
--the first way with like
select * from TestPercent where Strs like '%/%%' escape '/';

--the second way with charindex()
select * from TestPercent where charindex('%', strs) >= 1;

--the third way with len()
select * from TestPercent where 
len(Strs) > len(replace(Strs, '%', ''));

--3.In this puzzle you will have to split a string based on dot(.).(Splitter)
select Id, Vals, value as SplittedValue from Splitter as s
cross apply string_split(s.Vals, '.')

--4.Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)
--with translate() function
select translate('1234ABC123456XYZ1234567890ADS', '0123456789', 'XXXXXXXXXX') as ReplacedString;

--5.Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)
select * from testDots 
where len(Vals) - len(replace(Vals, '.', '')) > 2;

--6.Write a SQL query to count the spaces present in the string.(CountSpaces)
select texts, len(texts) - len(replace(texts, ' ', '')) as SpacesCount from CountSpaces;

--7.Write a SQL query that finds out employees who earn more than their managers.(Employee)
select emp.* from Employee as emp
join Employee as manager on emp.ManagerId = manager.Id
where emp.Salary > manager.Salary;

/*
--8.Find the employees who have been with the company for more than 10 years, but less than 15 years. 
Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service 
(calculated as the number of years between the current date and the hire date).(Employees)
*/
select EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, datediff(year, HIRE_DATE, getdate()) as TheYearsOfService
from Employees
where datediff(year, HIRE_DATE, getdate()) > 10 and datediff(year, HIRE_DATE, getdate()) < 15;


--Medium Tasks
--1.Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)
DECLARE @input VARCHAR(100) = 'rtcfvty34redt';

SELECT 
    @input AS original_string,
    REPLACE(TRANSLATE(@input, '0123456789', '##########'), '#', '') AS characters_cleaned,
    REPLACE(TRANSLATE(@input, 'abcdefghijklmnopqrstuvwxyz', REPLICATE('#', 26)), '#', '') AS numbers_only;

/*
2.write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)
*/
select t2.id from weather as t1
cross join weather as t2 
where datediff(day, t1.RecordDate, t2.RecordDate) = 1 and t1.Temperature < t2.Temperature;

--3.Write an SQL query that reports the first login date for each player.(Activity)
select player_id, min(event_date) as TheFirstLoginDate from Activity
group by player_id;

--4.Your task is to return the third item from that list.(fruits)

--the first way with string_split()
select value as TheThirdFruit from fruits
cross apply string_split(fruit_list, ',', 1)
where ordinal = 3;

--the second way with parsename()
select 
parsename(replace(fruit_list, ',','.'), 2) as TheThirdFruit
from fruits;


--5.Write a SQL query to create a table where each character from the string will be converted into a row.(sdgfhsdgfhs@121313131)
CREATE TABLE CharByChar (
    CharValue CHAR(1)
);

WITH CharCTE AS (
    SELECT SUBSTRING('sdgfhsdgfhs@121313131', 1, 1) AS CharValue, 1 AS Position
    UNION ALL
    SELECT SUBSTRING('sdgfhsdgfhs@121313131', Position + 1, 1), Position + 1
    FROM CharCTE
    WHERE Position < LEN('sdgfhsdgfhs@121313131') 
)
INSERT INTO CharByChar (CharValue)
SELECT CharValue
FROM CharCTE
OPTION (MAXRECURSION 0); 


/*
--6.You are given two tables: p1 and p2. Join these tables on the id column. The catch is: 
when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)
*/
select p1.id, 
case
	when p1.code = 0 then p2.code
	else p1.code
end as code,
p2.* 
from p1
join p2 on p1.id = p2.id;


/*
7.Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. 
The stages are defined as follows:
*/
--If the employee has worked for less than 1 year → 'New Hire'
--If the employee has worked for 1 to 5 years → 'Junior'
--If the employee has worked for 5 to 10 years → 'Mid-Level'
--If the employee has worked for 10 to 20 years → 'Senior'
--If the employee has worked for more than 20 years → 'Veteran'(Employees)
select *,
case
	when datediff(year, HIRE_DATE, getdate()) < 1 then 'New Hire'
	when datediff(year, HIRE_DATE, getdate()) between 1 and 5 then 'Junior'
	when datediff(year, HIRE_DATE, getdate()) between 5 and 10 then 'Mid-Level'
	when datediff(year, HIRE_DATE, getdate()) between 10 and 20 then 'Senior'
	else 'Veteran'
end as TheEmployementStage
from Employees;

--8.Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)
select Id, VALS,
case
	when Vals not like '%[^0-9]%' then VALS 
	when Vals like '[0-9]%' then left(Vals, patindex('%[^0-9]%', Vals)-1)
	else ''
end as IntegerValues
from GetIntegers


--Difficult Tasks
--1.In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)
select id, concat_ws(',', substring(Vals, 3, 1), substring(Vals, 1,1), substring(Vals, 5, len(Vals)))as SwappedVals
from MultipleVals

--2.Write a SQL query that reports the device that is first logged in for each player.(Activity)
select player_id, device_id from Activity
where event_date in (
	select min(event_date) from Activity
	group by player_id
);

/*
--3.You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. 
For each week, the total sales will be considered 100%, 
and the percentage sales for each day of the week should be calculated based on the area sales for that week.
*/
WITH WeeklySales AS (
    SELECT
        Area,
        FinancialWeek,
        SUM(SalesLocal + SalesRemote) AS TotalWeeklySales
    FROM WeekPercentagePuzzle
    GROUP BY Area, FinancialWeek
),
DailySalesPercentage AS (
    SELECT
        wp.Area,
        wp.FinancialWeek,
        wp.Date,
        wp.SalesLocal,
        wp.SalesRemote,
        (wp.SalesLocal + wp.SalesRemote) AS DailyTotalSales,
        ws.TotalWeeklySales,
        ROUND(((wp.SalesLocal + wp.SalesRemote) * 100.0) / ws.TotalWeeklySales, 2) AS DailySalesPercentage
    FROM WeekPercentagePuzzle wp
    JOIN WeeklySales ws ON wp.Area = ws.Area AND wp.FinancialWeek = ws.FinancialWeek
)
SELECT
    Area,
    FinancialWeek,
    Date,
    SalesLocal,
    SalesRemote,
    DailyTotalSales,
    TotalWeeklySales,
    DailySalesPercentage
FROM DailySalesPercentage
ORDER BY Area, FinancialWeek, Date;
