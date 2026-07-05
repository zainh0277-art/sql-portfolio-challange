-- Question 1: High-Risk User Audit Requirement: Compliance team ko un tamam users ki list chahiye jo Pakistan se hain, lekin unho ne profile banate waqt apna email ya phone number database mein missing (NULL) chora hai. List ko joined_date ke hisab se latest upar rakhte huay sort karein.
-- Solution:
SELECT
    user_id,
    username,
    email,
    phone
FROM
    users
WHERE
    country = 'Pakistan' AND (email IS NULL OR phone IS NULL)
ORDER BY
    joined_date DESC;
-- Question 2: Clean Profile Report (COALESCE Practice) Requirement: Ek aisi clean report nikalen jahan customer ka name aur unka phone number show ho. Agar phone number database mein NULL hai, tu uski jagah text 'Landline/No Phone' display hona chahiye taake report gandi na lage.
-- Solution:
SELECT
    user_id,
    username,
    COALESCE(phone, 'NO Phone Provided') AS phone_number
FROM
    users;    
-- Question 3: Under-the-Radar Financial Anomalies (Wildcards & Absolute Values) Requirement: Audit team ko store_financials table mein kuch mashkook transactions check karni hain. Un saare records ko filter karo jinki description ke andar lafzi tor par 'Audit' ya 'Tax' aata ho (chahe choti abc mein ho ya bari mein) aur unka loss/expense amount $50 se $500 ke darmiyan ho.
-- Solution:
SELECT
    financial_id,
    transaction_date,
    transaction_type,
    amount
FROM
    store_financials
WHERE
    description ILIKE '%audit%' OR description ILIKE '%tax%'
    AND amount BETWEEN -500 AND -50
ORDER BY
    amount ASC;

-- Question 4: Inventory Alert (Low Stock & Out of Stock) Requirement: Warehouse manager ko un items ki report chahiye jinka stock ya tu bilkul khatam ho chuka hai (stock_quantity = 0), ya phir unka stock critical level par hai (stock_quantity 1 se 20 ke darmiyan hai). Critical stock wale items pehle show hone chahiye.
-- Solution:
SELECT
    product_id,
    product_name,
    stock_quantity,
    CASE
        WHEN stock_quantity = 0 THEN 'Out of Stock'
        WHEN stock_quantity BETWEEN 1 AND 20 THEN 'Low Stock'
    END AS stock_status
FROM
    products
WHERE
    stock_quantity = 0 OR stock_quantity BETWEEN 1 AND 20
ORDER BY
    CASE
        WHEN stock_quantity BETWEEN 1 AND 20 THEN 'Low Stock'
        WHEN stock_quantity = 0 THEN 'Out of Stock'
    END,
    stock_status DESC;
-- Question 5: Financial Risk Tracker (Large Expenses) Requirement: store_financials table se un saare operational expenses ki list nikalen jahan company ka $100 se zyada ka kharcha hua ho. Yaad rahe expenses ka amount negative mein save hota hai, tu filter dhyan se lagana aur sab se bade kharche ko top par rakhna.
-- Solution:
SELECT
    financial_id,
    transaction_date,
    transaction_type,
    amount
FROM
    store_financials
WHERE
    transaction_type = 'Expense' AND amount < -100
ORDER BY
    ABS(amount) DESC;
-- Question 1: International Fraud Control & Non-Standard Emails Requirement: Risk audit team un fake profiles ko spot karna chahti hai jinhon ne business leakage ki hai. Ek aisi query likho jo un users ka user_id, username, aur email nikale jo Pakistan ya India se NAHI hain, jinki email address exact gmail.com ya yahoo.com par NAHI bani hui (e.g., junk extensions), aur unho ne saal 2025 ke baad join kiya ho.
-- Solution:
SELECT
    user_id,
    username,
    email
FROM
    users
WHERE
    country NOT IN ('Pakistan', 'India')
    AND email NOT LIKE '%@gmail.com'
    AND email NOT LIKE '%@yahoo.com'
    AND joined_date > '2025-12-31';
-- Question 2: Projections on Planned Appraisals (Salary Math & Offsets) Requirement: HR Department saalana budget ready kar raha hai. Unhein dekhna hai ke agar har employee ki salary mein 14% ka increment kiya jaye (salary * 1.14), aur sath mein $500 ka flat allowance bonus diya jaye, tu kin kin employees ki estimated new salary $85,000 ko cross kar jayegi? Output columns: Full Name, Current Salary, aur Projected Salary.
-- Solution:
SELECT
    first_name || ' ' || last_name AS Full_name,
    salary AS Current_Salary,
    ROUND((salary * 1.14 + 500),2) AS Projected_Salary
FROM
    employees
WHERE
    (salary * 1.14 + 500) > 85000
ORDER BY
    Projected_Salary DESC;
-- Question 3: Executive Formatting Clean-up (Advanced String Control) Requirement: Database mein data standardization ka issue hai. Ek query likho jahan first_name mukammal UPPERCASE (BARI ABC) mein ho, last_name mukammal lowercase (choti abc) mein ho, unka department sirf 'Sales', 'Marketing', ya 'Finance' ho, aur unki employee ID ek ODD number (taank adad, jaise 1, 3, 5...) ho.
-- Solution:
SELECT
    UPPER(first_name) AS first_name_uppercase,
    LOWER(last_name) AS last_name_lowercase,
    department,
    employee_id
FROM
    employees
WHERE
    department IN ('Sales', 'Marketing', 'Finance')
    AND employee_id % 2 = 1;
-- Question 4: Hidden Financial Anomalies (Wildcard Substring Search) Requirement: Tax investigators ko store_financials table mein kuch sensitive transactions audit karni hain. Un saare rows ka poora data filter karo jinki description ke andar lafzi tor par word 'Audit', 'Tax', ya 'Penalty' aata ho aur unka spending amount negative values mein $150 aur $750 ke darmiyan ho.
-- Solution:
SELECT
    financial_id,
    transaction_date,
    transaction_type,
    amount,
    description
FROM
    store_financials
WHERE
    (description ILIKE '%audit%' OR description ILIKE '%tax%' OR description ILIKE '%penalty%')
    AND amount BETWEEN -750 AND -150;
-- Question 5: Dynamic Seniority Banding (CASE WHEN Date Control) Requirement: Business Operations team users ka retention pattern dekhna chahti hai. users table se ek report nikalo jismein user ka naam, country, aur ek custom calculated column ho retention_tier: Agar user ne saal 2024 se pehle join kiya tha, tu show ho 'OG Legacy'. Agar user ne saal 2024 ya 2025 mein join kiya, tu show ho 'Mid-Term Core'. Baki tamam naye users ke liye show ho 'Recent Acquisition'.
-- Solution:
SELECT
    username,
    country,
    CASE
        WHEN joined_date < '2024-01-01' THEN 'OG Legacy'
        WHEN joined_date BETWEEN '2024-01-01' AND '2025-12-31' THEN 'Mid-Term Core'
        ELSE 'Recent Acquisition'
    END AS retention_tier
FROM
    users;