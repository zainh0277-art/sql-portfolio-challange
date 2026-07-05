-- Question 1: Global Sales Heatmap (Demographic Aggregation) Requirement: Marketing head ko dekhna hai ke kis mulk se sab se zyada revenue aa raha hai. Ek aisi query likho jo har unique country ka naam, wahan se place kiye gaye kul orders ki ginti (COUNT), aur wahan se hone wali total sales ka sum (SUM(quantity * unit_price)) nikal kar de. Sorting: Jis country se sab se zyada revenue aaya ho, woh top par ho.
-- Solution:
SELECT
    u.country,
    COUNT(o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM
    users u
    JOIN orders o ON u.user_id = o.user_id
    JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    u.country
ORDER BY
    total_sales DESC;
-- Question 2: The Underperforming Manager Audit (Self-Join + Aggregation) Requirement: Operations team internal audit kar rahi hai. Unhein har Manager ka Full Name (first_name + last_name), unka department, aur unke under kaam karne wale employees ki total ginti (COUNT) chahiye. Note: Sirf un managers ko show karo jinki department team mein 2 se zyada employees kaam kar rahe hon (HAVING clause ka use hoga).
-- Solution:
SELECT
    m.first_name || ' ' || m.last_name AS manager_full_name,
    m.department,
    COUNT(e.employee_id) AS total_employees
FROM
    employees m
    JOIN employees e ON e.manager_id = m.employee_id
GROUP BY
    m.employee_id, m.first_name, m.last_name, m.department
HAVING
    COUNT(e.employee_id) > 2
ORDER BY
    total_employees DESC;
-- Question 3: Category Price-Gap & Inventory Value Analytics Requirement: Retail director ko har product category (e.g., Electronics, Apparel) ka deep analysis chahiye. Har category ke liye yeh 3 cheezan calculate karo: Us category ka sab se mehnga retail price (MAX). Us category ka sab se sasta cost price (MIN). Us category ka total stock valuation (SUM(stock_quantity * retail_price)).
-- Solution:
SELECT
    category,
    MAX(retail_price) AS max_retail_price,
    MIN(cost_price) AS min_cost_price,
    SUM(stock_quantity * retail_price) AS total_stock_valuation
FROM
    products
GROUP BY
    category;
-- Question 4: Order Leakage & Status Breakdown (Multi-Table Stats) Requirement: Supply chain manager ko check karna hai ke kis status (Delivered, Pending, Cancelled) ke orders company ka kitna paisa fasa kar baithe hain. Har order_status ka naam, orders ki total ginti, aur un orders ke andar beche gaye items ka total revenue (SUM) nikalen. Tables needed: orders aur order_items.
-- Solution:
SELECT
    o.order_status,
    COUNT(o.order_id) AS total_orders,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM
    orders o
    JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    o.order_status;
-- Question 5: High-Value Inventory Leakage (Dead Stock Valuation) Requirement: Warehouse head ko un high-value products ki list chahiye jo storage mein sarr rahi hain lekin aaj tak unka ek bhi order nahi aaya. products aur order_items par LEFT JOIN lagao, aur sirf un products ka naam, category, aur unka stock quantity show karo jinka koi order record na ho (IS NULL), aur unka apna retail_price $50 se upar ho.
-- Solution:
SELECT
    p.product_name,
    p.category,
    p.stock_quantity
FROM
    products p
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE
    oi.product_id IS NULL
    AND p.retail_price > 50;
--Question 6: Cross-Department Salary Gap Analysis (Double Join) Requirement: HR director ko har employee ka naam, unka department, aur unki salary dekhni hai. Lekin sath hi, us employee ke Manager ka Name aur Manager ki Department bhi show karni hai taake yeh check kiya ja sakay ke kya koi manager kisi doosre department ki team ko tu handle nahi kar raha?
-- Solution:
SELECT
    e.first_name || ' ' || e.last_name AS employee_full_name,
    e.department AS employee_department,
    e.salary AS employee_salary,
    m.first_name || ' ' || m.last_name AS manager_full_name,
    m.department AS manager_department
FROM
    employees e
    LEFT JOIN employees m ON e.manager_id = m.employee_id;
-- Question 7: Customer Lifetime Value (CLV) with Order Count Restrictions Requirement: CEO chahta hai ke hum un customers ki loyalty check karein jinhon ne company ke sath long-term business kiya hai. Ek aisi query likho jo user ka username, unka total order count, aur unki total spending (SUM(quantity * unit_price)) show kare. Condition: Sirf un users ko filter karo jinhon ne kam az kam 4 alag orders place kiye hon aur unka status 'Cancelled' na ho.
-- Solution:
SELECT
    u.username,
    COUNT(o.order_id) AS total_order_count,
    SUM(oi.quantity * oi.unit_price) AS total_spending
FROM
    users u
    LEFT JOIN orders o ON u.user_id = o.user_id
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
WHERE
    o.order_status != 'Cancelled'
GROUP BY
    u.username
HAVING
    COUNT(o.order_id) >= 4
ORDER BY
    total_spending DESC;
-- Question 8: Underperforming Products with Active Orders (The Slow Movers) Requirement: Inventory management ko lagta hai ke kuch products orders mein aa tu rahi hain lekin unki total quantity bech kar bhi company ko koi khass faida nahi ho raha. Task: Har product ka naam, uski category, aur bechi gayi kul total quantity ka sum nikalen. Condition: Sirf un products ko show karo jinki bechi gayi total quantity 5 items se kam ho, lekin unka order record database mein mojood ho.
-- Solution:
SELECT
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold
FROM
    products p
    INNER JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY
    p.product_name,
    p.category
HAVING
    SUM(oi.quantity) < 5;
-- Question 9: High-Value Order Basket Audit (The Whale Orders) Requirement: Finance team ko un individual single orders (order_id) ki tracking chahiye jo bohat bade hain. Mujhe order_id, us order ko place karne wale customer ka username, aur us single order ki total financial worth (SUM(quantity * unit_price)) chahiye. Condition: Sirf woh orders samne aayen jinki total invoice value $250 se upar banti ho.
-- Solution:
SELECT
    o.order_id,
    u.username,
    SUM(oi.quantity * oi.unit_price) AS total_order_value
FROM
    orders o
    INNER JOIN users u ON o.user_id = u.user_id
    INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    u.username
HAVING
    SUM(oi.quantity * oi.unit_price) > 250
ORDER BY
    total_order_value DESC;
-- Question 10: Complete Employee-Sales Mapping (LEFT JOIN on Sales) Requirement: Sales review meeting mein HR ko un employees ki list chahiye jinhon ne abhi tak aik bhi order process nahi kiya (yani woh system par passive hain). Task: employees aur orders table par LEFT JOIN lagao aur employee ka full name aur department show karo jinke against orders table mein koi mapping na ho (o.employee_id IS NULL).
-- Solution:
SELECT
    e.first_name || ' ' || e.last_name AS employee_full_name,
    e.department
FROM
    employees e
    LEFT JOIN orders o ON e.employee_id = o.employee_id
WHERE
    o.employee_id IS NULL;