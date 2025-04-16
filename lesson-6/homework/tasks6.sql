--Puzzle 1: Finding Distinct Values
--Question: Explain at least two ways to find distinct values based on two columns.

--The first way: By comparing col1 and col2 with case 
select distinct
	case when col2 > col1 then col1 else col2 end as col1,
	case when col2 > col1 then col2 else col1 end as col2
from InputTbl;


--The second way: By comarping col1 and col2 with least and greatest functions
select distinct
    least(col1, col2) AS col1,
    greatest(col1, col2) AS col2
from InputTbl;

--Puzzle 2: Removing Rows with All Zeroes
--Question: If all the columns have zero values, then don’t show that row. 
--In this case, we have to remove the 5th row while selecting data.
select * from TestMultipleZero where not (A = 0 and B = 0 and C = 0 and D = 0);

--Puzzle 3: Find those with odd ids
select * from section1 where id % 2 = 1;

--Puzzle 4: Person with the smallest id (use the table in puzzle 3)
select top 1 * from section1 order by id;

--Puzzle 5: Person with the highest id (use the table in puzzle 3)
select top 1 * from section1 order by id desc;

--Puzzle 6: People whose name starts with b (use the table in puzzle 3)
select * from section1 where name like 'b%';

--Puzle 7: Write a query to return only the rows where the code contains the literal 
--underscore _ (not as a wildcard).
select * from ProductCodes where Code like '%/_%' escape '/';
