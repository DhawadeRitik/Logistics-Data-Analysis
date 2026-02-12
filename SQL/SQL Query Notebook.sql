CREATE DATABASE LogisticsDataProject;
USE LogisticsDataProject;

-- See the availables Tables
SELECT * FROM sys.tables;

-- Preview of the Tables 

-- ================================================ Drivers =====================================================
SELECT * FROM Drivers;

-- Check Data Type , Column Names of the tables
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Drivers';

-- Check if any Duplicate values present or not 
SELECT	
	DriverID ,
	COUNT(DriverID) AS duplicate_count 
FROM Drivers 
GROUP BY DriverID
HAVING COUNT(DriverID) > 1

-- Check if any nul value is present or not 
SELECT 
    CASE 
        WHEN DriverID IS NULL THEN 'Missing ID'
        WHEN DriverName IS NULL THEN 'Missing Customer'
        WHEN [Employment Type] IS NULL THEN 'Missing Gender'
		WHEN [Hire Date] IS NULL THEN 'Missing Age'
		WHEN [Experience Years] IS NULL THEN 'Missing Segment'
		WHEN [Performance Rating] IS NULL THEN 'Missing State'
        ELSE 'Data Complete'
    END AS Null_Check_Status
FROM Drivers;

-- Count of the nulls
SELECT 
    COUNT(*) - COUNT(DriverID ) AS Nulls_in_DriverID,
    COUNT(*) - COUNT(DriverName) AS Nulls_in_DriverName,
    COUNT(*) - COUNT([Employment Type]) AS Nulls_in_EmploymentType,
    COUNT(*) - COUNT([Hire Date]) AS Nulls_in_Hire_Date,
	COUNT(*) - COUNT([Experience Years]) AS Nulls_in_Experience_Years,
	COUNT(*) - COUNT([Performance Rating]) AS Nulls_in_Performance_Rating
FROM Drivers;

-- ========================================== Product Table ==============================
-- Column Name , Data Types 
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Hubs';

-- Check if Duplicate values are present are not 
SELECT 
	[Hub ID] ,
	COUNT([Hub ID]) AS duplicate_count
FROM Hubs
GROUP BY [Hub ID] 
HAVING COUNT([Hub ID]) > 1;

-- Count of null values 
SELECT 
    COUNT(*) - COUNT([Hub ID]) AS Nulls_in_HubID,
    COUNT(*) - COUNT(HubName) AS Nulls_in_NubName,
    COUNT(*) - COUNT([Hub Capacity]) AS Nulls_in_HubCapacity
FROM Hubs ;


-- ============================================ Vehicle Tables ===========================================================
-- Column Name , Data Types 
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Vehicles';

-- Check Duplicate values 
SELECT 
	[Vehicle ID],
	COUNT([Vehicle ID]) AS duplicate_count 
FROM Vehicles
GROUP BY [Vehicle ID]
HAVING COUNT([Vehicle ID]) > 1;


-- Null Values Count 
SELECT 
    COUNT(*) - COUNT([Purchase Date]) AS Nulls_in_Purchase_Date,
    COUNT(*) - COUNT([Vehicle ID]) AS Nulls_in_Vehicle_ID,
    COUNT(*) - COUNT([Vehicle Model]) AS Nulls_in_Vehicle_Model,
	COUNT(*) - COUNT([Vehicle Status]) AS Nulls_in_Vehicle_Status,
	COUNT(*) - COUNT(Breakdown) AS Nulls_in_Breakdown,
	COUNT(*) - COUNT([Maintenance count Alert]) AS Nulls_in_Maintenance_count_Alert,
	COUNT(*) - COUNT([Vehicle Code]) AS Nulls_in_Vehicle_Code
FROM Vehicles ;

-- =======================================================================================================================================================================
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Orders';
-- ========================================================================================================================================================================

-- There are no Nulls & Duplicate Values are in the Drivers,Hubs & Vehicles Table also there is no Duplicate Values also 
-- Drivers , Hubs & Vehicles are the Dimention tables Which contain the unique values 
-- Orders is the Fact table whicgh contains the Foreign key and Duplicates values 
-- Date Table contains the continues Dates


-- ====================================================== Business Problems / Solve Business Questions ============================================
-- Orders Tables
-- Q1. KPI's Total Orders
-- 1. Find the Total Orders 
	 SELECT 
		COUNT([Order ID]) AS Total_Orders 
	 FROM Orders;

-- 2. Total Orders for the Previous Month 
-- This cleans the data and converts the column type permanently
	UPDATE Orders
	SET [Order Date] = 
    TRY_CONVERT(DATE, TRIM([Order Date]), 105);

	SELECT
    Order_Year,
    Order_Month,
    Total_Orders,
    LAG(Total_Orders) OVER (
        ORDER BY Order_Year, Order_Month
    ) AS Previous_Month_Orders
	FROM (
    SELECT
        YEAR([Order Date])  AS Order_Year,
        MONTH([Order Date]) AS Order_Month,
        COUNT([Order ID])   AS Total_Orders
    FROM Orders
    GROUP BY
        YEAR([Order Date]),
        MONTH([Order Date])
) t;

			
-- 3. Month Over Month Growth
	WITH prev_month_order AS (
    SELECT 
        YEAR([Order Date])  AS Order_Year,
        MONTH([Order Date]) AS Order_Month,
        COUNT([Order ID])   AS Total_Orders
    FROM Orders
    GROUP BY 
        YEAR([Order Date]),
        MONTH([Order Date])
	),
	month_over_month AS (
		SELECT
			*,
			LAG(Total_Orders) OVER (
				ORDER BY Order_Year, Order_Month
			) AS Previous_Month_Order
		FROM prev_month_order
	)
	SELECT 
		Order_Year,
		Order_Month,
		Total_Orders,
		Previous_Month_Order,
		ROUND(
			(Total_Orders - Previous_Month_Order) * 100.0
			/ NULLIF(Previous_Month_Order, 0),
			4
		) AS [MoM_Change_%]
	FROM month_over_month
	ORDER BY Order_Year, Order_Month;


--  Q2. On Time Delivery Rate 
-- 1. On Time Delivery Rate 
	SELECT
		ROUND ( COUNT(CASE 
				WHEN [Order Status] = 'Delivered'
				 AND [Is On Time] = 1
			  THEN 1 END) * 100.0
		/ NULLIF(
			COUNT(CASE 
					WHEN [Order Status] = 'Delivered'
				  THEN 1 END), 0
		  ),2) AS On_Time_Delivery_Rate
	FROM Orders;

-- USING CTE 
	WITH on_time_delivery_rate AS (
	 SELECT 
		COUNT([Order ID]) AS Total_Orders
	 FROM Orders
	    WHERE 
	[Order Status] = 'Delivered'
		 AND 
	[Is On Time] = 1
	)
	SELECT
		Total_Orders * 100.0
		/ NULLIF((
			SELECT COUNT([Order ID])
			FROM Orders
			WHERE [Order Status] = 'Delivered'
		), 0) AS On_Time_Delivery_Rate
	FROM on_time_delivery_rate;


-- 2. On Time Delivery Rate for Previous Month 
	WITH monthly_delivery AS (
		SELECT
			YEAR([Order Date])  AS Order_Year,
			MONTH([Order Date]) AS Order_Month,
			COUNT(CASE 
					WHEN [Order Status] = 'Delivered' 
					 AND [Is On Time] = 1 
				  THEN 1 END) AS On_Time_Orders,
			COUNT(CASE 
					WHEN [Order Status] = 'Delivered'
				  THEN 1 END) AS Delivered_Orders
		FROM Orders
		GROUP BY
			YEAR([Order Date]),
			MONTH([Order Date])
	),
	monthly_rate AS (
		SELECT
			Order_Year,
			Order_Month,
			On_Time_Orders * 100.0 / NULLIF(Delivered_Orders, 0) 
				AS On_Time_Delivery_Rate
		FROM monthly_delivery
	)
	SELECT
		Order_Year,
		Order_Month,
		On_Time_Delivery_Rate,
		LAG(On_Time_Delivery_Rate) OVER (
			ORDER BY Order_Year, Order_Month
		) AS Previous_Month_On_Time_Delivery_Rate
	FROM monthly_rate
	ORDER BY Order_Year, Order_Month;


-- 3. Month Over Month Change in On Time Delivery Rate 
		WITH delivered_orders AS
		(
			SELECT 
				YEAR([Order Date])  AS Order_Year,
				MONTH([Order Date]) AS Order_Month,
				COUNT(
					CASE 
						WHEN [Order Status] = 'Delivered'
							 AND [Is On Time] = 1 
						THEN 1 
					END
				) AS On_Time_Delivered_Orders,
				COUNT(
					CASE 
						WHEN [Order Status] = 'Delivered'
						THEN 1 
					END
				) AS Delivered_Orders
			FROM Orders
			GROUP BY 
				YEAR([Order Date]),
				MONTH([Order Date])
		),
		monthly_rate AS
		(
			SELECT 
				Order_Year,
				Order_Month,
				On_Time_Delivered_Orders,
				Delivered_Orders,
						On_Time_Delivered_Orders * 100.0 
					/ NULLIF(Delivered_Orders, 0) AS ontime_rate
			FROM delivered_orders
		)
		SELECT 
			Order_Year,
			Order_Month,
			On_Time_Delivered_Orders,
			Delivered_Orders,
			ontime_rate,
			LAG(ontime_rate) OVER (ORDER BY Order_Year, Order_Month) AS Previous_Month_Rate,
			CONCAT(CAST((ontime_rate - LAG(ontime_rate) OVER (ORDER BY Order_Year, Order_Month)) * 100
				/ NULLIF(LAG(ontime_rate) OVER (ORDER BY Order_Year, Order_Month), 0) AS DECIMAL(10,2)),'%')
				AS Month_Over_Month_Rate
		FROM monthly_rate
		ORDER BY Order_Year, Order_Month;


-- Q3. Customer Satisfaction Score (CSAT %)	
-- Satisfied Customer take considering Customer Satisfaction Score is greater than 4
-- Satisfied Customer = Customer Satisfaction Score > 4
-- CSAT % = CSAT Customers  / Total Orders 
-- 1. Overall CSAT % for the selected Year and Month
	WITH CSAT_Score AS
	(
	SELECT 
			YEAR([Order Date]) AS Years,
			COUNT([Order ID]) AS Total_Orders,
			COUNT(CASE 
					WHEN [Customer Satisfaction Score] >= 4 THEN 1 END 
					) AS Total_Satisfied_Customers_Orders 
	FROM Orders 
	GROUP BY YEAR([Order Date])
	)
	SELECT 
			*,
			CAST(Total_Satisfied_Customers_Orders AS FLOAT) * 100 / Total_Orders AS [CSAT %]
	FROM CSAT_Score;

	
-- 2. CSAT % for the Previous Month
	WITH CSAT_Rate AS 
	(
		SELECT 
			 MONTH([Order Date]) AS Order_Month,
			 COUNT([Order ID]) AS Total_Orders,
			 COUNT(CASE 
					   WHEN [Customer Satisfaction Score] >= 4 THEN 1 END 
				   ) AS Total_Satisfied_Customers_Orders 
	   FROM Orders
	   GROUP BY MONTH([Order Date])
   ) , Previous_Month_CSAT AS 
   (
	   SELECT *,
		CONCAT(ROUND(CAST(Total_Satisfied_Customers_Orders AS FLOAT) * 100 / Total_Orders,2),'%') AS [CSAT %]
	   FROM CSAT_Rate
	)
	   SELECT 
	        *,
			LAG([CSAT %]) OVER(ORDER BY Order_Month) AS Previous_Month_CSAT_PCT
		FROM Previous_Month_CSAT
		ORDER BY Order_Month

-- 3. MoM change (%) in customer satisfaction
		WITH CSAT_Rate AS
		(
			SELECT 
				MONTH([Order Date]) AS Order_Month,
				COUNT([Order ID]) AS Total_Orders ,
				COUNT( CASE 
						 WHEN [Customer Satisfaction Score] >= 4 THEN 1 END 
				     ) AS Total_Satisfied_Customers_Orders
			FROM Orders 
			GROUP BY MONTH([Order Date])
		) , Previous_Month_CAST AS 
		(
			SELECT 
					*,
					ROUND(
						CAST(Total_Satisfied_Customers_Orders AS FLOAT) * 100 /Total_Orders
						,2) AS [CSAT %]
			FROM CSAT_Rate
		)
			SELECT
					* ,
					LAG([CSAT %]) OVER(ORDER BY Order_Month) AS [Previous_Month_CSAT_%],
					CONCAT(
						  ROUND(
							    ([CSAT %] - CAST(LAG([CSAT %]) OVER(ORDER BY Order_Month) AS FLOAT)) * 100 / CAST(LAG([CSAT %]) OVER(ORDER BY Order_Month) AS FLOAT),1
						       ),'%')AS [MOM_CSAT_%_Change]
			FROM Previous_Month_CAST
					
-- Q4. Average Delivery Time (Hours)
-- 1. Average delivery time (in hours) for the selected Year and Month
	  SELECT 
			YEAR([Order Date]) AS Order_Year,
			MONTH([Order Date]) AS Order_Month,
			ROUND(
					AVG([Delivery Time Hours]) ,2
				  )AS Avg_Delivery_Time
	  FROM Orders 
	  GROUP BY YEAR([Order Date]), MONTH([Order Date]);

-- 2. Average delivery time for the Previous Month
     WITH Previous_Month_Year AS 
	 (
		 SELECT 
				YEAR([Order Date]) AS Order_Year,
				MONTH([Order Date]) AS Order_Month,
				ROUND(
						AVG([Delivery Time Hours]) ,2
					  )AS Avg_Delivery_Time
		FROM Orders
		GROUP BY YEAR([Order Date]), MONTH([Order Date])
     )
		SELECT 
			*,
			LAG(Avg_Delivery_Time) OVER(ORDER BY Order_Year,Order_Month) AS Previous_Month_AVG_Time
		FROM Previous_Month_Year;

-- 3. MoM change (%) in average delivery duration
	WITH Monthly_Delivery AS
	(
		SELECT 
			YEAR([Order Date]) AS Order_Year,
			MONTH([Order Date]) AS Order_Month,
			ROUND(AVG([Delivery Time Hours]), 2) AS Avg_Delivery_Time
		FROM Orders
		GROUP BY YEAR([Order Date]), MONTH([Order Date])
	),
		MoM_Calc AS
	(
		SELECT *,
			   LAG(Avg_Delivery_Time) 
			   OVER (ORDER BY Order_Year, Order_Month) AS Prev_Month_Avg_Delivery_Time
		FROM Monthly_Delivery
	)
		SELECT 
		Order_Year,
		Order_Month,
		Avg_Delivery_Time,
		Prev_Month_Avg_Delivery_Time,
		ROUND(
			(Avg_Delivery_Time - Prev_Month_Avg_Delivery_Time) * 100 
			/ NULLIF(Prev_Month_Avg_Delivery_Time, 0),
			2
		) AS MOM_Delivery_Time_Change
	FROM MoM_Calc;

-- =====================================================================================================================================================================================

-- ==================================================================== Hub Analysis ===================================================================================================

-- =====================================================================================================================================================================================
-- 1.Total Hubs
	SELECT 
		COUNT(*) AS [Total Hubs]
	FROM Hubs;

-- 2. Orders Processed vs Hub Capacity (Monthly & Yearly)
	WITH C AS (
		SELECT 
			YEAR(O.[Order Date]) AS Order_Year,
			MONTH(O.[Order Date]) AS Order_Month,
			H.HubName,
			H.[Hub Capacity],
			COUNT(O.[Order ID]) AS Total_Orders
		FROM Hubs AS H
		LEFT JOIN Orders AS O
			ON O.[Hub Name] = H.HubName
		GROUP BY H.HubName, H.[Hub Capacity],YEAR(O.[Order Date]),MONTH(O.[Order Date])
	)
	SELECT 
		Order_Year,
		Order_Month,
		HubName,
		Total_Orders,
		[Hub Capacity] AS Hub_Capacity
	FROM C;

-- 3. Hub Performance Ranking
-- On Time Delivery Rate By Hubs 
	WITH ONTDR AS
	(
		SELECT 
			H.HubName,
			COUNT(CASE WHEN O.[Order Status] = 'Delivered' THEN 1 END) AS Total_Delivered_Orders,
			COUNT(CASE WHEN O.[Order Status] = 'Delivered' AND [Is On Time] = 1 THEN 1 END) AS On_Time_Delivered_Orders
		FROM Orders O
		LEFT JOIN Hubs H
		ON O.[Hub Name] = H.HubName
		GROUP BY H.HubName
	)
		SELECT *,
			   CONCAT(ROUND(
					CAST((On_Time_Delivered_Orders * 100.0) 
							/ NULLIF(Total_Delivered_Orders, 0) 
					AS FLOAT)
					,2),' %') AS OTDR_Percentage
		FROM ONTDR;


-- 3. How many hours does it take by Hubs to processed order?
-- Average Delivery Time By Hybname and WeekDay
	SELECT
		DATEPART(ISO_WEEK, [Order Date]) AS Week_No,
		DATEPART(WEEKDAY, [Order Date]) AS Weekday_No,
		DATENAME(WEEKDAY, [Order Date]) AS Weekday_Name,
		[Hub Name],
		ROUND(AVG(CAST([Delivery Time Hours] AS FLOAT)), 2) AS Avg_Time
	FROM Orders
	GROUP BY
		DATEPART(ISO_WEEK, [Order Date]),
		DATEPART(WEEKDAY, [Order Date]),
		DATENAME(WEEKDAY, [Order Date]),
		[Hub Name]
	ORDER BY Week_No, Weekday_No;

-- Delivered vs On Time Delivered Orders by Hub Name
	WITH HubMetrics AS
(
    SELECT 
        [Hub Name] AS Hub_Name,
        COUNT(*) AS Total_Orders,

        SUM(CASE WHEN [Order Status] = 'Cancelled' THEN 1 ELSE 0 END) 
            AS Total_Cancelled_Orders,

        SUM(CASE WHEN [Order Status] = 'Delivered' THEN 1 ELSE 0 END) 
            AS Total_Delivered_Orders,

        SUM(CASE 
                WHEN [Order Status] = 'Delivered' 
                     AND [Is On Time] = 1 
                THEN 1 ELSE 0 
            END) AS On_Time_Delivered_Orders,

        SUM(CASE 
                WHEN [Order Status] = 'Delivered' 
                     AND [Is On Time] = 0 
                THEN 1 ELSE 0 
            END) AS Delay_Delivered_Orders
    FROM Orders
    GROUP BY [Hub Name]
   )
	SELECT 
		*,

		ROUND(
			(CAST(Total_Delivered_Orders AS FLOAT) * 100.0) 
			/ NULLIF(Total_Orders, 0),
			2
		) AS Delivery_Rate,

    ROUND(
        (CAST(On_Time_Delivered_Orders AS FLOAT) * 100.0) 
        / NULLIF(Total_Delivered_Orders, 0),
        2
    ) AS OnTime_Delivery_Rate,

    ROUND(
        (CAST(Delay_Delivered_Orders AS FLOAT) * 100.0) 
        / NULLIF(Total_Delivered_Orders, 0),
        2
    ) AS Delay_Delivery_Rate,

    ROUND(
        (CAST(Total_Cancelled_Orders AS FLOAT) * 100.0) 
        / NULLIF(Total_Orders, 0),
        2
		) AS Cancellation_Rate
	FROM HubMetrics
	ORDER BY OnTime_Delivery_Rate DESC;


-- ========================================================================================================================================================================================================================
-- =============================================================================== Drivers ================================================================================================================================
-- ========================================================================================================================================================================================================================

-- Total Number of Drivers
	SELECT 
		COUNT(DriverID) AS Total_Drivers
	FROM Drivers

--  Exeperience VS Rating 
	SELECT 
		AVG([Experience Years]) AS Average_Experience,
		AVG([Performance Rating]) AS Average_Rating
	FROM Drivers;

-- Delay Delivary Rate, Delivery Rate  By Drivers
-- Join using Driver Name
	WITH Drivers_Delay_Delivery_Rate AS (
    SELECT 
        D.DriverName,
        COUNT(*) AS Total_Orders,

        SUM(CASE WHEN O.[Order Status] = 'Delivered' THEN 1 ELSE 0 END) 
            AS Total_Delivered_Orders,

        SUM(CASE WHEN O.[Order Status] = 'Cancelled' THEN 1 ELSE 0 END) 
            AS Total_Cancelled_Orders,

        SUM(CASE 
                WHEN O.[Order Status] = 'Delivered' 
                     AND O.[Is Delayed] = 1 
                THEN 1 ELSE 0 
            END) AS Delay_Delivered_Orders,

        SUM(CASE 
                WHEN O.[Order Status] = 'Delivered' 
                     AND O.[Is On Time] = 1 
                THEN 1 ELSE 0
            END) AS On_Time_Delivered_Orders
    FROM Orders O
    INNER JOIN Drivers D
        ON TRIM(LOWER(O.[Driver Name])) = TRIM(LOWER(D.DriverName))
    GROUP BY D.DriverName
)
SELECT 
    *,
    ROUND(CAST(Total_Delivered_Orders AS FLOAT) * 100 / NULLIF(Total_Orders, 0), 2)
        AS Delivery_Rate,

    ROUND(CAST(Total_Cancelled_Orders AS FLOAT) * 100 / NULLIF(Total_Orders, 0), 2)
        AS Cancellation_Rate,

    ROUND(CAST(On_Time_Delivered_Orders AS FLOAT) * 100 / NULLIF(Total_Delivered_Orders, 0), 2)
        AS On_Time_Delivery_Rate,

    ROUND(CAST(Delay_Delivered_Orders AS FLOAT) * 100 / NULLIF(Total_Delivered_Orders, 0), 2)
        AS Delay_Delivery_Rate
FROM Drivers_Delay_Delivery_Rate
WHERE Total_Delivered_Orders >= 10
ORDER BY Delay_Delivery_Rate DESC;

-- JOIN using Driver ID 
WITH Drivers_Delay_Delivery_Rate AS
	(
    SELECT 
		D.DriverID,
        D.DriverName,
        COUNT(*) AS Total_Orders,

        SUM(CASE 
                WHEN O.[Order Status] = 'Delivered' 
                THEN 1 ELSE 0 
            END) AS Total_Delivered_Orders,

        SUM(CASE 
                WHEN O.[Order Status] = 'Cancelled' 
                THEN 1 ELSE 0 
            END) AS Total_Cancelled_Orders,

        SUM(CASE 
                WHEN O.[Order Status] = 'Delivered' 
                     AND O.[Is Delayed] = 1 
                THEN 1 ELSE 0 
            END) AS Delay_Delivered_Orders,

        SUM(CASE 
                WHEN O.[Order Status] = 'Delivered' 
                     AND O.[Is On Time] = 1 
                THEN 1 ELSE 0
            END) AS On_Time_Delivered_Orders
		FROM Orders O
		LEFT JOIN Drivers D 
			ON O.[Driver ID] = D.DriverID
		GROUP BY D.DriverID, D.DriverName
		)
		SELECT 
			*,

		ROUND(
			CAST(Total_Delivered_Orders AS FLOAT) * 100 
			/ NULLIF(Total_Orders, 0),
			2
		) AS Delivery_Rate,

		ROUND(
			CAST(Total_Cancelled_Orders AS FLOAT) * 100 
			/ NULLIF(Total_Orders, 0),
			2
		) AS Cancellation_Rate,

		ROUND(
			CAST(On_Time_Delivered_Orders AS FLOAT) * 100 
			/ NULLIF(Total_Delivered_Orders, 0),
			2
		) AS On_Time_Delivery_Rate,

		ROUND(
			CAST(Delay_Delivered_Orders AS FLOAT) * 100 
			/ NULLIF(Total_Delivered_Orders, 0),
			2
		) AS Delay_Delivery_Rate
	FROM Drivers_Delay_Delivery_Rate
	WHERE Total_Delivered_Orders >= 10
	ORDER BY DriverID ;


-- Average Customer Satisfaction Score By Drivers 
	SELECT 
		[Driver Name],
		AVG([Customer Satisfaction Score]) AS Average_Customer_Satisfaction_Score
	FROM Orders
	GROUP BY [Driver Name]

-- Total Number Of Vehicles
	SELECT 
		COUNT(*) AS Total_Vehicle 
	FROM Vehicles;

-- Total Active Vehicles
	SELECT 
		COUNT(*) Active_Vehicles
    FROM Vehicles
	WHERE [Vehicle Status] = 'Active'
