-- Old Guard Audit (Date Filtering)
-- Task: Find all active employees who were hired before January 1, 2010. Order the list from the longest-serving employee to the newest.
-- SQL Query:
SELECT
    
    first_name,
    last_name,
    hire_date
FROM
    
    employees
WHERE
    hire_date < '2010-01-01'
    AND status = 'Active'
-- Employee Directory (Basic Inner Join)
-- Task: Create an employee directory that combines each employee's first and last name into a single column (employee_name), shows their email, and lists their actual department name. Sort the list alphabetically by name.
-- SQL Query:
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    e.email,
    d.department_name
FROM
    employees e
INNER JOIN
    departments d ON e.department_id = d.department_id
ORDER BY
    employee_name;  
-- Headcount Breakdown (GROUP BY)
-- Task: Get a count of how many employees belong to each status (e.g., Active, Terminated, On Leave).
-- SQL Query:
SELECT
    status,
    COUNT(*) AS employee_count
FROM
    employees
GROUP BY
    status;
-- Top 5 Earners of 2014 (Sorting & Limiting)
-- Task: Find the names, job titles, and base pay of the top 5 highest-paid employees (based on base_pay) during the payroll year 2014.
-- SQL Query:
SELECT
    e.first_name || ' ' || e.last_name AS employee_name,
    p.job_title,
    p.base_pay,
    pr.year
FROM
    employees e
INNER JOIN
    payroll_ledger p ON e.employee_id = p.employee_id
INNER JOIN
    payroll_runs pr ON p.run_id = pr.run_id
WHERE
    pr.year = 2014
ORDER BY
    p.base_pay DESC
LIMIT 5;
-- Average Compensation by Job Title (Aggregations & Rounding)
-- Task: For each unique job title in the company, calculate the average base salary and average benefits package. Round the averages to 2 decimal places and sort them from the highest average base salary to the lowest.
-- SQL Query:
SELECT
    job_title,
    ROUND(AVG(base_pay), 2) AS avg_base_salary,
    ROUND(AVG(benefits), 2) AS avg_benefits
FROM
    employees e
INNER JOIN
    payroll_ledger p ON e.employee_id = p.employee_id
INNER JOIN
    payroll_runs pr ON p.run_id = pr.run_id
WHERE
    pr.year = 2014
GROUP BY
    job_title
ORDER BY
    avg_base_salary DESC;
-- Leadership Roles Search (Pattern Matching & Wildcards)
-- Task: Identify any employee holding a leadership or command role. Find all employees whose job title contains the word "Chief", "Captain", or "Lieutenant" (case-insensitive).
-- SQL Query:
SELECT
    e.first_name,
    e.last_name,
    p.job_title
FROM
    employees e
INNER JOIN
    payroll_ledger p ON e.employee_id = p.employee_id
WHERE
    LOWER(p.job_title) LIKE '%chief%'
    OR LOWER(p.job_title) LIKE '%captain%'
    OR LOWER(p.job_title) LIKE '%lieutenant%';
--Overtime-Heavy Blue-Collar Staff (Multi-Conditional Filtering)
-- Task: Find employees who have earned more than $10,000 in overtime pay but have a base pay of less than $80,000.
-- SQL Query:
SELECT
    e.first_name,
    e.last_name,
    p.base_pay,
    p.overtime_pay
FROM
    employees e
INNER JOIN
    payroll_ledger p ON e.employee_id = p.employee_id
WHERE
    p.overtime_pay > 10000
    AND p.base_pay < 80000;
-- High-Capacity Departments (HAVING Clause)
-- Task: Find all departments that have a workforce size of more than 10 employees. Display the department name and the total headcount, sorted from the largest department to the smallest.
-- SQL Query:
SELECT
    d.department_name,
    COUNT(e.employee_id) AS headcount
FROM
    departments d
INNER JOIN
    employees e ON d.department_id = e.department_id
GROUP BY
    d.department_name
HAVING
    COUNT(e.employee_id) > 10
ORDER BY
    headcount DESC;
-- Tenure Calculator (Date Arithmetic)
-- Task: For employees who have been terminated, calculate the exact number of days they were employed using their hire date and termination date. Order the list to show who had the longest tenure first.
-- SQL Query:
SELECT
    e.first_name,
    e.last_name,
    e.hire_date,
    e.termination_date,
    e.termination_date - e.hire_date AS tenure_days
FROM
    employees e
WHERE
    e.termination_date IS NOT NULL
ORDER BY
    tenure_days DESC;
-- Annual "Other Pay" Expenditure (Time Series Aggregation)
-- Task: Calculate the total budget spent on "Other Pay" (bonuses, allowances, etc.) for each payroll year. Sort the results chronologically from the oldest year to the newest.
-- SQL Query:
SELECT
    pr.year,
    SUM(p.other_pay) AS total_other_pay
FROM
    payroll_runs pr
INNER JOIN
    payroll_ledger p ON pr.run_id = p.run_id
GROUP BY
    pr.year
ORDER BY
    pr.year;