-- 1. Revenue from each sales channel in a given year (2021)
SELECT sales_channel,
       SUM(amount) AS revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel;


-- 2. Top 10 most valuable customers in a given year
SELECT TOP 10 uid,
       SUM(amount) AS total_spent
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY uid
ORDER BY total_spent DESC;


-- 3. Month-wise revenue, expense, profit, status
WITH revenue AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
expense AS (
    SELECT 
        MONTH(datetime) AS month,
        SUM(amount) AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT 
    r.month,
    r.total_revenue,
    ISNULL(e.total_expense, 0) AS total_expense,
    (r.total_revenue - ISNULL(e.total_expense, 0)) AS profit,
    CASE 
        WHEN (r.total_revenue - ISNULL(e.total_expense, 0)) > 0 
        THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS status
FROM revenue r
LEFT JOIN expense e ON r.month = e.month;


-- 4. Most profitable clinic per city for a given month (Sep 2021)
WITH sales AS (
    SELECT cid, SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021 AND MONTH(datetime) = 9
    GROUP BY cid
),
expense_sum AS (
    SELECT cid, SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021 AND MONTH(datetime) = 9
    GROUP BY cid
),
profit_calc AS (
    SELECT 
        c.city,
        c.cid,
        (s.revenue - ISNULL(e.expense, 0)) AS profit,
        RANK() OVER (
            PARTITION BY c.city
            ORDER BY (s.revenue - ISNULL(e.expense, 0)) DESC
        ) AS rnk
    FROM clinics c
    JOIN sales s ON c.cid = s.cid
    LEFT JOIN expense_sum e ON c.cid = e.cid
)
SELECT * 
FROM profit_calc
WHERE rnk = 1;


-- 5. Second least profitable clinic per state for a given month (Sep 2021)
WITH sales AS (
    SELECT cid, SUM(amount) AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021 AND MONTH(datetime) = 9
    GROUP BY cid
),
expense_sum AS (
    SELECT cid, SUM(amount) AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021 AND MONTH(datetime) = 9
    GROUP BY cid
),
profit_calc AS (
    SELECT 
        c.state,
        c.cid,
        (s.revenue - ISNULL(e.expense, 0)) AS profit,
        DENSE_RANK() OVER (
            PARTITION BY c.state
            ORDER BY (s.revenue - ISNULL(e.expense, 0)) ASC
        ) AS rnk
    FROM clinics c
    JOIN sales s ON c.cid = s.cid
    LEFT JOIN expense_sum e ON c.cid = e.cid
)
SELECT *
FROM profit_calc
WHERE rnk = 2;
