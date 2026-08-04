USE [Pizza Sales DB];

SELECT * FROM pizza_sales;
--Sort Confusion of Count and Sum
SELECT pizza_name_id, SUM(quantity) AS QuantitySUM, COUNT(quantity) AS QuantityCOUNT FROM pizza_sales
GROUP BY pizza_name_id
ORDER BY pizza_name_id DESC;

--(A) KPIs
--Total Revenue
SELECT SUM(total_price) AS Total_Revenue FROM pizza_sales; 

--Average Order Value
SELECT SUM(total_price) /COUNT(DISTINCT order_id) AS Avg_Order_Value FROM pizza_sales;

--Total pizza sold
SELECT SUM(quantity) AS Total_Pizza_Sold FROM pizza_sales;

--Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales;

--Average pizzas per Order
SELECT CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) /
CAST(COUNT(DISTINCT order_id) AS DECIMAL(10, 2)) AS DECIMAL(10,2)) AS Avg_Pizzas_Per_Order FROM pizza_sales;


--(B) Daily Trend for Total orders.
SELECT DATENAME(DW, order_date) AS Order_day, 
COUNT(DISTINCT order_id ) AS Total_Orders FROM pizza_sales
GROUP BY DATENAME(DW, order_date);


--(C)Monthly Trend for Total Orders
SELECT DATENAME(MONTH, order_date) AS Month_Name, 
COUNT(DISTINCT order_id ) AS Total_Orders FROM pizza_sales
GROUP BY DATENAME(MONTH, order_date)
ORDER BY Total_Orders DESC;


--(D)Percentage of Sales by Pizza Category
SELECT pizza_category, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_category;

--For January alone
SELECT 
	pizza_category, SUM(total_price) AS Total_Sales, SUM(total_price) * 100.0 / 
(SELECT SUM(total_price) FROM pizza_sales WHERE MONTH(order_date) = 1) AS Category_Percentage
	From pizza_sales
	WHERE MONTH(order_date) = 1
	GROUP BY pizza_category;


--(E)Percentage of Sales by Pizza size
SELECT pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) as total_revenue,
CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) from pizza_sales) AS DECIMAL(10,2)) AS PCT
FROM pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

--For January alone
SELECT 
	pizza_size, CAST(SUM(total_price) AS DECIMAL(10,2)) AS Total_Sales, CAST(SUM(total_price) * 100.0 / 
(SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(QUARTER, order_date) =1) AS DECIMAL(10,2)) AS Category_Percentage
	From pizza_sales
	WHERE DATEPART(QUARTER, order_date) =1
	GROUP BY pizza_size
	ORDER BY Category_Percentage DESC;


--(F)Total Pizzas Sold by Pizza Category.
SELECT pizza_category, SUM(quantity) as Total_Quantity_Sold
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold DESC;

--(G)Top 5 Best Sellers by Revenue, Total Quantity and Total Orders.
--TOP 5 Pizzas by Revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC;

--TOP 5 Pizzas by Quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC;

--TOP 5 Pizzas by Total_Orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders DESC;


--(H)Bottom 5 Best Sellers by Revenue, Total Quantity and Total Orders.
--Bottom 5 Pizzas by Revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC;

--Bottom 5 Pizzas by Quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity ASC;

--Bottom 5 Pizzas by Total_Orders
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Orders FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Orders ASC;
