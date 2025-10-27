-- Riders with more than 10 rides without cash
SELECT r.rider_id, rd.name AS rider_name, COUNT(r.ride_id) AS total_rides
FROM rides_raw r
JOIN riders_raw rd ON r.rider_id = rd.rider_id
JOIN payments_raw p ON r.ride_id = p.ride_id
WHERE p.amount > 0
GROUP BY r.rider_id, rd.name
HAVING COUNT(r.ride_id) > 10
   AND SUM(CASE WHEN LOWER(p.method) = 'cash' THEN 1 ELSE 0 END) = 0
   ORDER BY total_rides DESC;

