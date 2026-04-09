-- 1. Last booked room for each user
SELECT user_id, room_no
FROM (
    SELECT user_id, room_no, booking_date,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
    FROM bookings
) t
WHERE rn = 1;


-- 2. Total billing amount of every booking in November 2021
SELECT b.booking_id,
       SUM(bc.item_quantity * i.item_rate) AS total_bill
FROM bookings b
JOIN booking_commercials bc ON b.booking_id = bc.booking_id
JOIN items i ON bc.item_id = i.item_id
WHERE b.booking_date >= '2021-11-01'
  AND b.booking_date < '2021-12-01'
GROUP BY b.booking_id;


-- 3. Bills in October 2021 with amount > 1000
SELECT bc.bill_id,
       SUM(bc.item_quantity * i.item_rate) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE bc.bill_date >= '2021-10-01'
  AND bc.bill_date < '2021-11-01'
GROUP BY bc.bill_id
HAVING SUM(bc.item_quantity * i.item_rate) > 1000;


-- 4. Most and least ordered item per month in 2021
WITH item_counts AS (
    SELECT 
        MONTH(bc.bill_date) AS month,
        i.item_name,
        SUM(bc.item_quantity) AS total_qty,
        
        RANK() OVER (
            PARTITION BY MONTH(bc.bill_date)
            ORDER BY SUM(bc.item_quantity) DESC
        ) AS rnk_desc,
        
        RANK() OVER (
            PARTITION BY MONTH(bc.bill_date)
            ORDER BY SUM(bc.item_quantity) ASC
        ) AS rnk_asc
        
    FROM booking_commercials bc
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_name
)
SELECT month, item_name, total_qty
FROM item_counts
WHERE rnk_desc = 1 OR rnk_asc = 1;


-- 5. Customers with second highest bill per month in 2021
WITH bills AS (
    SELECT 
        MONTH(bc.bill_date) AS month,
        b.user_id,
        bc.bill_id,
        SUM(bc.item_quantity * i.item_rate) AS total_bill,
        
        DENSE_RANK() OVER (
            PARTITION BY MONTH(bc.bill_date)
            ORDER BY SUM(bc.item_quantity * i.item_rate) DESC
        ) AS rnk
        
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id, bc.bill_id
)
SELECT *
FROM bills
WHERE rnk = 2;
