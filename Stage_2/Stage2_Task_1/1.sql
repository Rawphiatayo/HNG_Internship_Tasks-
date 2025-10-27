-- 10 Longest rides by distance
SELECT 
    r.ride_id,
    d.name AS driver_name,
    ri.name AS rider_name,
    r.pickup_city,
    r.dropoff_city,
    r.distance_km,
    p.method AS payment_method
FROM rides_raw r
JOIN drivers_raw d ON r.driver_id = d.driver_id
JOIN riders_raw ri ON r.rider_id = ri.rider_id
LEFT JOIN payments_raw p ON r.ride_id = p.ride_id
WHERE p.amount > 0 
ORDER BY r.distance_km DESC
LIMIT 10;