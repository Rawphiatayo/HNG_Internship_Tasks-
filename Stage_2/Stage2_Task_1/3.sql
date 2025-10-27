--Total Revenue by each quarter in all year
SELECT 
    EXTRACT(YEAR FROM dropoff_time) AS year,
    EXTRACT(QUARTER FROM dropoff_time) AS quarter,
    SUM(p.amount) AS total_revenue
FROM rides_raw r
JOIN payments_raw p ON r.ride_id = p.ride_id
WHERE p.amount > 0  
GROUP BY year, quarter
ORDER BY year, quarter;

-- The YoY growth of each quarter in every year
WITH quarterly_revenue AS (
    SELECT 
        EXTRACT(YEAR FROM dropoff_time) AS year,
        EXTRACT(QUARTER FROM dropoff_time) AS quarter,
        SUM(p.amount) AS total_revenue
    FROM rides_raw r
    JOIN payments_raw p ON r.ride_id = p.ride_id
    WHERE p.amount > 0
    GROUP BY year, quarter 
)
SELECT 
    curr.year,
    curr.quarter,
    curr.total_revenue,
    prev.total_revenue AS prev_year_revenue,
    ROUND(
        ((curr.total_revenue - prev.total_revenue) / prev.total_revenue) * 100, 
        2
    ) AS yoy_growth_percent
FROM quarterly_revenue curr
LEFT JOIN quarterly_revenue prev
    ON curr.quarter = prev.quarter 
   AND curr.year = prev.year + 1
ORDER BY curr.year, curr.quarter;

--The Biggest YoY Growth
WITH quarterly_revenue AS (
    SELECT 
        EXTRACT(YEAR FROM dropoff_time) AS year,
        EXTRACT(QUARTER FROM dropoff_time) AS quarter,
        SUM(p.amount) AS total_revenue
    FROM rides_raw r
    JOIN payments_raw p ON r.ride_id = p.ride_id
    WHERE p.amount > 0
    GROUP BY year, quarter),
yoy_growth AS (
    SELECT 
        curr.year,
        curr.quarter,
        ((curr.total_revenue - prev.total_revenue) / prev.total_revenue) * 100 AS yoy_growth_percent
    FROM quarterly_revenue curr
    JOIN quarterly_revenue prev
      ON curr.quarter = prev.quarter AND curr.year = prev.year + 1
)
SELECT *
FROM yoy_growth
ORDER BY yoy_growth_percent DESC
LIMIT 1;

