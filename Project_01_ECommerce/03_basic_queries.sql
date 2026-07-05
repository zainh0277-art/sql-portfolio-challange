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