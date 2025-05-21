USE Long_and_Complex_Queries;

WITH cte AS
(SELECT *, 
ROW_NUMBER() OVER(PARTITION BY employee_ID ORDER BY change_date DESC) as rn_desc, -- use ROW_NUMBER() instead of RANK() to guarantee exactly one row per employee.
ROW_NUMBER() OVER(PARTITION BY employee_ID ORDER BY change_date ASC) as rn_asc, -- for solving 6th question.
LEAD(salary, 1) over (PARTITION BY employee_id ORDER BY change_date DESC) AS prev_salary, 
LEAD(change_date, 1) over (PARTITION BY employee_id ORDER BY change_date DESC) AS prev_change_date
FROM salary_history)


, salary_ratio_CTE as (SELECT employee_id,
MAX(CASE WHEN rn_desc = 1 then salary END) AS latest_salary,
MAX(CASE WHEN rn_asc = 1 then salary END) AS first_salary,
(MAX(CASE WHEN rn_desc = 1 then salary END) - MAX(CASE WHEN rn_asc = 1 then salary END))/MAX(CASE WHEN rn_asc = 1 then salary END) as sal_growth,
MIN(change_date) as join_date 
FROM cte
GROUP BY employee_id)



SELECT cte.employee_id,
       MAX(CASE WHEN rn_desc = 1 THEN salary END) AS latest_salary,
       SUM(CASE WHEN promotion = 'Yes' THEN 1 ELSE 0 END) AS no_of_promotions,
       MAX(CAST((salary - prev_salary) * 100.0 / prev_salary AS DECIMAL(4,2))) AS max_salary_growth,
       CASE 
           WHEN MAX(CASE WHEN salary < prev_salary THEN 1 ELSE 0 END) = 0 
           THEN 'Y' 
           ELSE 'N' 
       END AS NeverDecreased,
       AVG(DATEDIFF(MONTH, prev_change_date, change_date)) AS avg_months_between_changes,
	   RANK() OVER (ORDER BY  sr.sal_growth DESC, sr.join_date ASC) as rank_by_growth
FROM cte
LEFT JOIN salary_ratio_CTE sr on cte.employee_id = sr.employee_id
GROUP BY cte.employee_id,  sr.sal_growth, sr.join_date ;


/*
SELECT e.employee_id, e.name, s.salary, p.no_of_promotions, g.salary_growth, ISNULL(n.never_decreased, 'Yes') as never_decreased, m.months_between_changes, r.rank_by_growth
FROM employees e
LEFT JOIN latest_salary_cte s ON e.employee_id = s.employee_id
LEFT JOIN promotions_cte p ON e.employee_id = p.employee_id
LEFT JOIN salary_growth_cte g ON e.employee_id = g.employee_id
LEFT JOIN salary_decreased_cte n ON e.employee_id = n.employee_id
LEFT JOIN avg_months_cte m ON e.employee_id = m.employee_id
LEFT JOIN salary_growth_rank_cte r ON e.employee_id = r.employee_id
*/

