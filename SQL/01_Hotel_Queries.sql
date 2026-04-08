SELECT user_id, room_no
FROM (
    SELECT user_id, room_no, booking_date,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC) AS rn
    FROM bookings
) t
WHERE rn = 1;

SELECT * FROM users;