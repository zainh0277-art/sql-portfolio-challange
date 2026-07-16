-- 1. The High-Paying DepartmentsBusiness Case: HR wants to identify elite departments.
-- Find the departments whose average base pay is higher than the global average base pay of the entire company.Your Task: Group by department, calculate the average base pay, and use a subquery in the HAVING clause to filter out any departments falling below the company-wide average.
-- Solution:
SELECT d.department_name, ROUND(AVG(p.base_pay),2) AS avg_base_pay
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN payroll_ledger p ON e.employee_id = p.employee_id
GROUP BY d.department_name
HAVING AVG(p.base_pay) > (SELECT AVG(p.base_pay) FROM employees e JOIN payroll_ledger p ON e.employee_id = p.employee_id);
-- 2. Overpopulated Job TitlesBusiness Case: Workforce planning needs to know which roles are highly saturated. 
-- Find the job titles that have a headcount greater than the average headcount across all job titles.Your Task: Group by job title, count the employees, and use a subquery in the HAVING clause to calculate the average headcount per job title to use as your benchmark.
-- Solution:
SELECT p.job_title, COUNT(e.employee_id) AS headcount
FROM employees e
INNER JOIN payroll_ledger p ON e.employee_id = p.employee_id
GROUP BY p.job_title
HAVING COUNT(e.employee_id) > (SELECT AVG(headcount) FROM (SELECT COUNT(employee_id) AS headcount FROM employees GROUP BY job_title) AS job_headcounts);
-- 3. Above-Average Overtime DepartmentsBusiness Case: Operations wants to flag departments that are relying too heavily on overtime. 
-- Find departments where the average overtime pay is strictly greater than the average overtime pay of the entire company.
-- Your Task: Group by department, calculate average overtime, and filter using a subquery in the HAVING clause that finds the global average overtime.
-- Solution:
SELECT d.department_name, ROUND(AVG(p.overtime_pay),2) AS avg_overtime
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN payroll_ledger p ON e.employee_id = p.employee_id
GROUP BY d.department_name
HAVING AVG(p.overtime_pay) > (SELECT AVG(overtime_pay) FROM payroll_ledger);
-- 4. Departments Beating Terminated StandardsBusiness Case: Find departments where the average base pay of active employees is higher than the maximum base pay ever given to a terminated employee.
-- Your Task: Group active employees by department, calculate their average base pay, and in the HAVING clause, use a subquery to find the MAX(base_pay) of employees whose status is 'Terminated'.
-- Solution:
SELECT 
    d.department_name, 
    ROUND(AVG(p.base_pay), 2) AS avg_base_pay
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN payroll_ledger p ON e.employee_id = p.employee_id
WHERE e.status = 'Active'
GROUP BY d.department_name
HAVING AVG(p.base_pay) > (
    SELECT MAX(pl.base_pay) 
    FROM employees emp
    INNER JOIN payroll_ledger pl ON emp.employee_id = pl.employee_id
    WHERE emp.status = 'Terminated'
);
-- 5. Small-Team Budget OutliersBusiness Case: Finance is looking for departments with 5 or fewer employees, but whose total payroll budget (base pay + benefits) is larger than the average total payroll budget of all departments.
-- Your Task: Group by department, filter for employee counts $\le 5$, and use a subquery in the HAVING clause to calculate the average total budget across all departments.
-- Solution:
SELECT 
    d.department_name, 
    COUNT(e.employee_id) AS employee_count,
    ROUND(SUM(p.base_pay + p.benefits), 2) AS total_payroll_budget
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN payroll_ledger p ON e.employee_id = p.employee_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) <= 5 
   AND SUM(p.base_pay + p.benefits) > (
       SELECT AVG(dept_budgets.total_budget) 
       FROM (
           SELECT SUM(p2.base_pay + p2.benefits) AS total_budget 
           FROM employees e2 
           INNER JOIN payroll_ledger p2 ON e2.employee_id = p2.employee_id 
           GROUP BY e2.department_id
       ) AS dept_budgets
   );