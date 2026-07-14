-- Start Completely Fresh
DROP TABLE IF EXISTS payroll_ledger CASCADE;
DROP TABLE IF EXISTS payroll_runs CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- 1. Create Departments Table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    location VARCHAR(100) DEFAULT 'San Francisco'
);

-- 2. Create Employees Table (Normalized)
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    hire_date DATE NOT NULL,
    status VARCHAR(30) DEFAULT 'Active' CHECK (status IN ('Active', 'Terminated', 'On Leave')),
    termination_date DATE,
    department_id INT REFERENCES departments(department_id) ON DELETE SET NULL
);

-- 3. Create Payroll Runs Table
CREATE TABLE payroll_runs (
    run_id INT PRIMARY KEY,
    year INT NOT NULL,
    pay_period VARCHAR(100) NOT NULL
);

-- 4. Create Payroll Ledger Table (Actual metrics tracking)
CREATE TABLE payroll_ledger (
    ledger_id INT PRIMARY KEY,
    run_id INT REFERENCES payroll_runs(run_id) ON DELETE CASCADE,
    employee_id INT REFERENCES employees(employee_id) ON DELETE CASCADE,
    job_title VARCHAR(150) NOT NULL,
    base_pay DECIMAL(12,2) DEFAULT 0.00,
    overtime_pay DECIMAL(12,2) DEFAULT 0.00,
    other_pay DECIMAL(12,2) DEFAULT 0.00,
    benefits DECIMAL(12,2) DEFAULT 0.00,
    total_pay DECIMAL(12,2) GENERATED ALWAYS AS (base_pay + overtime_pay + other_pay) STORED,
    total_pay_benefits DECIMAL(12,2) GENERATED ALWAYS AS (base_pay + overtime_pay + other_pay + benefits) STORED
);