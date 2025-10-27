CREATE TABLE drivers_raw(
    driver_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(100),
    signup_date TIMESTAMP,
    rating DECIMAL(2,1)
);

CREATE TABLE payments_raw(
    payment_id SERIAL PRIMARY KEY,
    ride_id INT,
    amount DECIMAL(10,2),
    method VARCHAR(20),
    paid_date TIMESTAMP
);

CREATE TABLE riders_raw(
    rider_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    signup_date TIMESTAMP,
    city VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE rides_raw(
    ride_id SERIAL PRIMARY KEY,
    rider_id INT,
    driver_id INT,
    request_time TIMESTAMP,
    pickup_time TIMESTAMP,
    dropoff_time TIMESTAMP,
    pickup_city VARCHAR(100),
    dropoff_city VARCHAR(100),
    distance_km DECIMAL(6,2),
    status VARCHAR(20),
    fare DECIMAL(10,2)
);

SELECT * FROM drivers_raw LIMIT 5;
SELECT * FROM riders_raw LIMIT 5;
SELECT * FROM rides_raw LIMIT 5;
SELECT * FROM payments_raw LIMIT 5

SELECT driver_id, COUNT(driver_id) 
FROM drivers_raw
GROUP BY driver_id
HAVING COUNT(driver_id) > 1;

SELECT payment_id, COUNT(payment_id) 
FROM payments_raw
GROUP BY payment_id
HAVING COUNT(payment_id) > 1;

SELECT rider_id, COUNT(rider_id) 
FROM riders_raw
GROUP BY rider_id
HAVING COUNT(rider_id) > 1;

SELECT ride_id, COUNT(ride_id)
FROM rides_raw
GROUP BY ride_id
HAVING COUNT (ride_id) >1

SELECT name, city, signup_date, COUNT(*)
FROM drivers_raw
GROUP BY name, city, signup_date
HAVING COUNT(*) > 1;

SELECT rider_id, driver_id, pickup_time, dropoff_time, COUNT(*)
FROM rides_raw
GROUP BY rider_id, driver_id, pickup_time, dropoff_time
HAVING COUNT(*) > 1;

SELECT ride_id, amount, method, COUNT(*)
FROM payments_raw
GROUP BY ride_id, amount, method
HAVING COUNT(*) > 1;

SELECT name, email, COUNT(*)
FROM riders_raw
GROUP BY name, email
HAVING COUNT(*) > 1;

SELECT *
FROM rides_raw
WHERE fare IS NULL OR distance_km IS NULL OR status IS NULL;

SELECT *
FROM rides_raw
WHERE fare <= 0;

UPDATE rides_raw
SET fare = NULL
WHERE fare <= 0;

SELECT DISTINCT pickup_city FROM rides_raw ORDER BY pickup_city;

SELECT *
FROM rides_raw
WHERE request_time < pickup_time;

DELETE FROM rides_raw
WHERE request_time < '2021-06-01' OR request_time > '2024-12-31';

SELECT r.ride_id, r.status, r.fare
FROM rides_raw r
LEFT JOIN payments_raw p ON r.ride_id = p.ride_id
WHERE p.payment_id IS NULL;

SELECT *
FROM drivers_raw
WHERE rating < 1 OR rating > 5;

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

