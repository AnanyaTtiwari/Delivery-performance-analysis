create database delivery_analysis;
use delivery_analysis;
SELECT * FROM delivery;

--  Average Delivery Time 
SELECT 
    AVG(Delivery_Time)
FROM
    delivery;

-- Platform Performnace
SELECT 
    Platform, AVG(Delivery_Time) AS avg_time
FROM
    delivery
GROUP BY Platform;

-- Late Delivery % per platforms
SELECT 
    Platform,
    (SUM(CASE
        WHEN Delivery_Delay = 'Yes' THEN 1
        ELSE 0
    END) * 100.0 / COUNT(*)) AS late_percentage
FROM
    delivery
GROUP BY Platform
ORDER BY late_percentage DESC;

-- Delivery vs Rating
SELECT 
    Delivery_Status, AVG(Service_Rating)
FROM
    delivery
GROUP BY Delivery_Status;

-- Refund Impact
SELECT 
    Refund_Requested, AVG(Delivery_Time)
FROM
    delivery
GROUP BY Refund_Requested;

-- Category Analysis
SELECT 
    Product_Category, AVG(Delivery_Time) AS avg_time
FROM
    delivery
GROUP BY Product_Category
ORDER BY AVG(Delivery_Time) DESC;

-- Best & Worst Platform
-- Best
SELECT 
    Platform, AVG(Delivery_time) AS avg_time
FROM
    delivery
GROUP BY Platform
ORDER BY AVG(Delivery_time) ASC
LIMIT 1;
-- worst
SELECT 
    Platform, AVG(Delivery_time) AS avg_time
FROM
    delivery
GROUP BY Platform
ORDER BY AVG(Delivery_time) DESC
LIMIT 1;

-- Efficiency

SELECT 
    Platform, AVG(Order_Value / Delivery_Time) AS Efficiency
FROM
    delivery
GROUP BY Platform
ORDER BY Efficiency DESC; 

-- Total Orders per platforms
SELECT 
    Platform, COUNT(*) AS Total_orders
FROM
    delivery
GROUP BY Platform
ORDER BY Total_orders DESC;

-- Late Deliveries per platforms
SELECT Platform,
       SUM(CASE WHEN Delivery_Delay = 'Yes' THEN 1 ELSE 0 END) AS late_orders
FROM delivery
GROUP BY Platform;

-- Avergae Rating per Platforms
SELECT Platform, AVG(Service_Rating) AS avg_rating
FROM delivery
GROUP BY Platform
ORDER BY avg_rating DESC;

-- Refund vs Delay Relationship
SELECT Delivery_Delay, Refund_Requested, COUNT(*) AS total
FROM delivery
GROUP BY Delivery_Delay, Refund_Requested;

-- Worst Performing Category
SELECT Product_Category, AVG(Delivery_Time) AS avg_time
FROM delivery
GROUP BY Product_Category
ORDER BY avg_time DESC
LIMIT 1;

-- Fast vs Slow Deliveries count
SELECT 
    CASE 
        WHEN Delivery_Time <= 30 THEN 'Fast'
        WHEN Delivery_Time <= 60 THEN 'Moderate'
        ELSE 'Slow'
    END AS speed_category,
    COUNT(*) AS total_orders
FROM delivery
GROUP BY speed_category;

-- High Value Orders vs Delivery Time
SELECT 
    CASE 
        WHEN Order_Value < 500 THEN 'Low'
        WHEN Order_Value BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'High'
    END AS value_category,
    AVG(Delivery_Time) AS avg_delivery_time
FROM delivery
GROUP BY value_category;

-- Platform-wise Delivery Performance Summary
SELECT Platform,
       COUNT(*) AS total_orders,
       AVG(Delivery_Time) AS avg_time,
       AVG(Service_Rating) AS avg_rating,
       SUM(CASE WHEN Delivery_Delay = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS late_percentage
FROM delivery
GROUP BY Platform;

