-- Top 5 consistent Drivers per active month
WITH driver_activity AS (
    SELECT 
        d.driver_id,
        d.name AS driver_name,
        COUNT(r.ride_id) AS total_rides,
        DATE_TRUNC('month', MIN(r.request_time)) AS first_month,
        DATE_TRUNC('month', MAX(r.request_time)) AS last_month
    FROM drivers_raw d
    JOIN rides_raw r ON d.driver_id = r.driver_id
    JOIN payments_raw p ON r.ride_id = p.ride_id
    WHERE p.amount > 0  -- Only count completed rides
    GROUP BY d.driver_id, d.name)
SELECT driver_id, driver_name, total_rides,
    ROUND(
        (total_rides::numeric / 
            GREATEST(
                DATE_PART('year', AGE(last_month, first_month)) * 12 +
                DATE_PART('month', AGE(last_month, first_month)) + 1,
                1)
        )::numeric, 2) AS avg_monthly_rides
FROM driver_activity
ORDER BY avg_monthly_rides DESC
LIMIT 5;


