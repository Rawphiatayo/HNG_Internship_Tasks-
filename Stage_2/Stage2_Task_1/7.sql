-- The top 3 drivers by Revenjue from June 2021 to Dec 2024
SELECT *
FROM (SELECT 
        r.pickup_city,
        d.name AS driver_name,
        SUM(p.amount) AS total_revenue,
        RANK() OVER (PARTITION BY r.pickup_city ORDER BY SUM(p.amount) DESC) AS city_rank
    FROM rides_raw r
    JOIN drivers_raw d ON r.driver_id = d.driver_id
    JOIN payments_raw p ON r.ride_id = p.ride_id
    WHERE p.amount > 0
      AND r.request_time BETWEEN '2021-06-01' AND '2024-12-31'
    GROUP BY r.pickup_city, d.name) ranked
WHERE city_rank <= 3;

