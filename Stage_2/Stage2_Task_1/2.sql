SELECT COUNT(DISTINCT r1.rider_id) AS riders_2021_to_2024
FROM riders_raw r1
JOIN rides_raw r2 ON r1.rider_id = r2.rider_id
JOIN payments_raw p ON r2.ride_id = p.ride_id
WHERE p.amount > 0
  AND EXTRACT(YEAR FROM r1.signup_date) = 2021
  AND EXTRACT(YEAR FROM r2.request_time) = 2024;
