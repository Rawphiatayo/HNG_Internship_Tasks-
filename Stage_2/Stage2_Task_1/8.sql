-- Eligible driver for Bonus
WITH driver_stats AS (
    SELECT 
        d.driver_id,
        d.name AS driver_name,
        COUNT(CASE WHEN p.amount > 0 THEN r.ride_id END) AS completed_rides,
        COUNT(CASE WHEN r.status = 'cancelled' THEN 1 END) AS cancelled_rides,
        COUNT(r.ride_id) AS total_rides,
        ROUND(AVG(d.rating), 2) AS avg_rating
    FROM drivers_raw d
    JOIN rides_raw r ON d.driver_id = r.driver_id
    LEFT JOIN payments_raw p ON r.ride_id = p.ride_id
	WHERE p.amount > 0
    GROUP BY d.driver_id, d.name)
SELECT 
    driver_id,
    driver_name,
    completed_rides,
    avg_rating,
    ROUND((cancelled_rides::decimal / total_rides) * 100, 2) AS cancel_rate
FROM driver_stats
WHERE completed_rides >= 30
  AND avg_rating >= 4.5
  AND (cancelled_rides::decimal / total_rides) * 100 < 5
ORDER BY completed_rides DESC
LIMIT 10;

