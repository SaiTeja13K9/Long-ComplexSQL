USE Long_and_Complex_Queries;

/* SELECT * FROM employees;
SELECT * FROM salary_history; */

--1. Find the Latest Salary for the each employee
/* SELECT s.employee_id, s.change_date, s.salary
FROM salary_history s
WHERE s.change_date = (
    SELECT MAX(change_date)
    FROM salary_history
    WHERE employee_id = s.employee_id
); */

/* WITH CTE AS
(SELECT *, RANK() OVER(PARTITION BY employee_ID ORDER BY change_date DESC) as rn
FROM salary_history)
SELECT employee_id, salary FROM CTE WHERE rn = 1; */

WITH cte AS
(SELECT *, 
ROW_NUMBER() OVER(PARTITION BY employee_ID ORDER BY change_date DESC) as rn_desc, -- use ROW_NUMBER() instead of RANK() to guarantee exactly one row per employee.
ROW_NUMBER() OVER(PARTITION BY employee_ID ORDER BY change_date ASC) as rn_asc -- for solving 6th question.
FROM salary_history)
, latest_salary_cte as (
SELECT employee_id, salary 
FROM cte 
WHERE rn_desc = 1)

--2. Calculate the Total number of promotions each employee has received.

/*SELECT employee_id,
COUNT(CASE WHEN promotion = 'Yes' THEN 1
	ELSE NULL END) AS no_of_promotions
FROM salary_history
GROUP BY employee_id
ORDER BY employee_id;*/

, promotions_cte as(
SELECT employee_id, COUNT(*) AS no_of_promotions
FROM cte
WHERE promotion = 'Yes'
GROUP BY employee_id)

--3. Determine the maximum salary hike percentage between any two consecutive salary changes for each employee.
, prev_salary_cte as 
(SELECT *, 
LEAD(salary, 1) over (PARTITION BY employee_id ORDER BY change_date DESC) AS prev_salary, --USED lead as the salary in cte is in the desc order
LEAD(change_date, 1) over (PARTITION BY employee_id ORDER BY change_date DESC) AS prev_change_date -- for solving the 5th question.
FROM cte),

salary_growth_cte as (
SELECT employee_id, MAX(CAST((salary-prev_salary)*100.0/prev_salary AS DECIMAL(4,2))) as salary_growth
FROM prev_salary_cte
GROUP BY employee_id)

--4. Identify employees whose salary has never decreased over time
, salary_decreased_cte as (SELECT DISTINCT employee_id, 'N' as never_decreased 
FROM prev_salary_cte
WHERE salary < prev_salary)


--5. Find the average time(in months) between salary changes for each employee.
, avg_months_cte AS
(SELECT employee_id, AVG(DATEDIFF(MONTH, prev_change_date, change_date)) AS months_between_changes
FROM prev_salary_cte
GROUP BY employee_id)

--6. Rank employees by their salary growth rate (from first to last recorded salary), breaking ties by the earliest join date.

, salary_ratio_CTE as (SELECT employee_id,
MAX(CASE WHEN rn_desc = 1 then salary END) AS latest_salary,
MAX(CASE WHEN rn_asc = 1 then salary END) AS first_salary,
(MAX(CASE WHEN rn_desc = 1 then salary END) - MAX(CASE WHEN rn_asc = 1 then salary END))/MAX(CASE WHEN rn_asc = 1 then salary END) as sal_growth,
MIN(change_date) as join_date 
FROM cte
GROUP BY employee_id)

, salary_growth_rank_cte as
(SELECT employee_id,sal_growth, join_date, RANK() OVER (ORDER BY  sal_growth DESC, join_date ASC) as rank_by_growth
FROM salary_ratio_CTE)

SELECT e.employee_id, e.name, s.salary, p.no_of_promotions, g.salary_growth, ISNULL(n.never_decreased, 'Yes') as never_decreased, m.months_between_changes, r.rank_by_growth
FROM employees e
LEFT JOIN latest_salary_cte s ON e.employee_id = s.employee_id
LEFT JOIN promotions_cte p ON e.employee_id = p.employee_id
LEFT JOIN salary_growth_cte g ON e.employee_id = g.employee_id
LEFT JOIN salary_decreased_cte n ON e.employee_id = n.employee_id
LEFT JOIN avg_months_cte m ON e.employee_id = m.employee_id
LEFT JOIN salary_growth_rank_cte r ON e.employee_id = r.employee_id

