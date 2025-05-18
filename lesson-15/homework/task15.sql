/*
1. Find Employees with Minimum Salary
Task: Retrieve employees who earn the minimum salary in the company. Tables: employees (columns: id, name, salary)
*/
select * from employees where salary in (select min(salary) from employees);

/*
2. Find Products Above Average Price
Task: Retrieve products priced above the average price. Tables: products (columns: id, product_name, price)
*/
select * from products where price > (select avg(price) from products);

/*
3. Find Employees in Sales Department Task: Retrieve employees who work in the "Sales" department. 
Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)
*/
select id, name from employees 
where department_id in (select id from departments where department_name = 'Sales');

/*
4. Find Customers with No Orders
Task: Retrieve customers who have not placed any orders. 
Tables: customers (columns: customer_id, name), orders (columns: order_id, customer_id)
*/
select * from customers
where customer_id not in (select customer_id from orders);

/*
5.Find Products with Max Price in Each Category
Task: Retrieve products with the highest price in each category. 
Tables: products (columns: id, product_name, price, category_id)
*/
select * from products as p1
where price in (select max(price) from products as p2 where p2.category_id = p1.category_id)

/*
6. Find Employees in Department with Highest Average Salary
Task: Retrieve employees working in the department with the highest average salary. 
Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)
*/
select top 1 with ties emp.*, dep.department_name from (
select emp.department_id, avg(emp.salary) as AvgSalary from employees as emp
join departments as dep on emp.department_id = dep.id
group by emp.department_id
) as t
join employees as emp on t.department_id = emp.department_id
join departments as dep on emp.department_id = dep.id
order by t.AvgSalary desc;

/*
7. Find Employees Earning Above Department Average
Task: Retrieve employees earning more than the average salary in their department. 
Tables: employees (columns: id, name, salary, department_id)
*/
select * from employees as emp1
where salary > (select avg(salary) from employees as emp2 where emp1.department_id = emp2.department_id)

/*
8. Find Students with Highest Grade per Course
Task: Retrieve students who received the highest grade in each course. 
Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)
*/
select * from students
where student_id in (
select g.student_id from (
	select g.course_id, max(grade) as MaxGrade from students as s
	join grades as g on s.student_id = g.student_id
	group by g.course_id


) as t
join grades as g on g.grade = t.MaxGrade and g.course_id = t.course_id
)

/*
9. Find Third-Highest Price per Category Task: Retrieve products with the third-highest price in each category. 
Tables: products (columns: id, product_name, price, category_id)
*/
select t.id, t.product_name, t.price, t.category_id from (
select *, 
dense_rank() over (partition by category_id order by price desc) as rank
from products
) as t
where t.rank = 3;


/*
10. Find Employees whose Salary Between Company Average and Department Max Salary
Task: Retrieve employees with salaries above the company average but below the maximum in their department. 
Tables: employees (columns: id, name, salary, department_id)
*/
select * from employees as emp1
where salary > (select avg(salary) from employees) and 
salary < (select max(salary) from employees as emp2 where emp1.department_id = emp2.department_id);


