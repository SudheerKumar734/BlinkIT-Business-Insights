SELECT * FROM blinkit_sales

-- Business Requirments

--KPI's Required

--1) Total Sales
SELECT CAST(SUM(total_sales) AS DECIMAL(10,2)) AS TotalSales FROM blinkit_sales

--2) Average Sales
SELECT CAST(AVG(total_sales) AS DECIMAL(10,2)) AS AvgSales FROM blinkit_sales

--3) Total Number of Products
SELECT COUNT(DISTINCT Item_Identifier)
FROM blinkit_sales;

--4) Average Rating
SELECT CAST(AVG(rating) AS decimal(10,2)) AS Average_Rating FROM blinkit_sales

-- Product Analysis

--1) Sales by Item Type
SELECT item_type, SUM(total_sales) AS revenue
FROM blinkit_sales
GROUP BY item_type
ORDER BY revenue DESC;

--2) Top 10 products by sales
SELECT TOP 10 item_type, SUM(total_sales) AS revenue 
FROM blinkit_sales
GROUP BY item_type
ORDER BY revenue DESC;

-- Fat Content Analysis

-- 1) Sales by Fat Content
SELECT item_fat_content, CAST(SUM(total_sales) AS DECIMAL(10,2)) AS revenue
FROM blinkit_sales
GROUP BY item_fat_content;

--2) Fat content by outlet for total sales
SELECT 
    outlet_location_type,
    CAST(SUM(CASE WHEN item_fat_content = 'Low Fat' THEN total_sales ELSE 0 END) AS DECIMAL(10,2)) AS Low_Fat,
    CAST(SUM(CASE WHEN item_fat_content = 'Regular' THEN total_sales ELSE 0 END) AS DECIMAL(10,2)) AS Regular
FROM blinkit_sales
GROUP BY outlet_location_type
ORDER BY outlet_location_type;

-- Outlet Analysis

--1) Sales by Outlet Type
SELECT outlet_type, CAST(SUM(total_sales) AS DECIMAL(10,2)) AS revenue
FROM blinkit_sales
GROUP BY outlet_type
ORDER BY revenue DESC;

--2) Sales by Outlet Size
SELECT outlet_size, CAST(SUM(total_sales) AS DECIMAL(10,2)) AS revenue
FROM blinkit_sales
GROUP BY outlet_size
ORDER BY revenue DESC;

--3) Sales by Location
SELECT outlet_location_type, CAST(SUM(total_sales) AS DECIMAL(10,2)) AS revenue
FROM blinkit_sales
GROUP BY outlet_location_type
ORDER BY revenue DESC;

-- Rating Analysis

--1) Average Rating by Item Type
SELECT item_type, CAST(AVG(rating) AS DECIMAL(10,2)) AS AvgRating
FROM blinkit_sales
GROUP BY item_type
ORDER BY AvgRating DESC;

-- Feature Engineering Analysis

--1) Sales by Outlet Age
SELECT outlet_age, CAST(SUM(total_sales) AS DECIMAL(10,2)) AS revenue
FROM blinkit_sales
GROUP BY outlet_age
ORDER BY revenue DESC;

--2) Sales Category Distribution
SELECT sales_category, COUNT(*) AS products
FROM blinkit_sales
GROUP BY sales_category
ORDER BY products DESC;

--Charts Requirements

--1) Percentage of Sales by Outlet Size
WITH PerOutletSizeSales AS (
    SELECT 
        outlet_size, 
        SUM(total_sales) AS Raw_Total_Sales
    FROM blinkit_sales
    GROUP BY Outlet_Size
)
SELECT 
    outlet_size,
    CAST(Raw_Total_Sales AS DECIMAL(10,2)) AS Final_Sales_Report, 
    CAST(Raw_Total_Sales * 100.0 / SUM(Raw_Total_Sales) OVER() AS DECIMAL(10,2)) AS Sales_Percentage
FROM PerOutletSizeSales
ORDER BY Raw_Total_Sales DESC;

--2) Top Product Type in Each Outlet Type
WITH cte AS(
	SELECT outlet_type, item_type, SUM(total_sales) AS revenue,
		DENSE_RANK() OVER(PARTITION BY outlet_type ORDER BY SUM(total_sales) DESC) AS rank_
	FROM blinkit_sales
	GROUP BY outlet_type, item_type
)
SELECT * FROM cte WHERE rank_ = 1

--3) Revenue Contribution %
SELECT item_type, SUM(total_sales) AS revenue,
    ROUND(SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER (),2) AS [revenue_percent_%]
FROM blinkit_sales
GROUP BY item_type
ORDER BY revenue DESC;






