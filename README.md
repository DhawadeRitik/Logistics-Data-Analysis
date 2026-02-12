🚛 SwiftRoute Logistics Analytics Dashboard
End-to-End Power BI + SQL Business Intelligence Project
📌 Project Overview

This project is an end-to-end Business Intelligence solution built to analyze logistics operations across Orders, Hubs, Drivers, and Fleet Vehicles.

The objective was to transform raw operational data into actionable insights using:

Microsoft SQL Server (Data validation & KPI verification)

Power BI (Dashboard development & visualization)

DAX (Advanced KPI calculations & Time Intelligence)

Star Schema Data Modeling

The dashboard enables stakeholders to monitor performance, detect inefficiencies, and support data-driven decision-making.

🎯 Business Objectives

Monitor On-Time Delivery performance

Track Month-over-Month operational growth

Identify overloaded hubs

Analyze driver performance & delay patterns

Optimize fleet utilization & maintenance planning

Improve customer satisfaction

📊 Dashboard Structure

The report is divided into 4 analytical views:

1️⃣ Executive Overview
Key KPIs:

📦 Total Orders

⏱ On-Time Delivery Rate (OTDR %)

⭐ Customer Satisfaction (CSAT %)

🚚 Average Delivery Time (Hours)

📈 Month-over-Month Growth %

Key Features:

Previous Month comparison

Dynamic KPI cards

Time Intelligence using DAX

Trend analysis

2️⃣ Hub Performance Analysis
Insights:

Orders Processed vs Hub Capacity

Hub Ranking by OTDR

Processing Time Heatmap (Day-wise)

Underperforming Hub Identification

Business Value:

Helps management:

Redistribute operational load

Improve SLA compliance

Optimize regional operations

3️⃣ Driver Performance Dashboard
Insights:

Experience vs Rating (Scatter Analysis)

Drivers with Highest Delay Rates

Monthly Delivery Trends

Individual Driver Profile Summary

Business Value:

Identify training needs

Improve workforce efficiency

Reduce delivery delays

4️⃣ Fleet & Vehicle Analysis
Insights:

Active vs Maintenance Vehicles

Orders by Vehicle Type & Model

Vehicle Age vs Breakdown Frequency

Breakdown Analysis by Model

Business Value:

Predictive maintenance planning

Fleet optimization

Cost reduction

🗂 Data Modeling Approach

The project follows a Star Schema Architecture:

Fact Table:

Fact_Orders

Dimension Tables:

Dim_Driver

Dim_Hub

Dim_Vehicle

Dim_Date

Benefits:

Improved performance

Clean relationships

Optimized DAX calculations

Scalable design

🛠 SQL Data Validation & Engineering

Before building dashboards, the dataset was validated in SQL Server:

Performed:

Duplicate record checks

NULL value validation

Data type verification

Aggregation cross-verification

Month-over-Month KPI validation

Defensive division using NULLIF

CTE-based KPI calculations

Window functions for ranking

Example Techniques Used:

WITH CTE

COUNT(CASE WHEN...)

RANK() OVER()

GROUP BY

TRY_CONVERT()

NULLIF()

All Power BI KPIs were cross-verified in SQL for accuracy.

📐 DAX Techniques Used

CALCULATE()

RANKX()

SELECTEDVALUE()

DATESINPERIOD()

PREVIOUSMONTH()

DIVIDE()

SUMMARIZE()

Dynamic Measures

Time Intelligence

Context Transition

📈 Key Analytical Insights

Certain hubs consistently operate above capacity.

Higher vehicle age correlates with increased breakdown frequency.

Driver experience does not always guarantee higher rating.

Delay rates are concentrated among specific hubs & vehicle models.

MoM performance trends highlight operational volatility.

🛠 Tech Stack
Tool	Purpose
Power BI	Dashboard & Visualization
DAX	KPI & Time Intelligence
SQL Server	Data Cleaning & Validation
Star Schema	Data Modeling
🚀 How to Use This Project

Download .pbix file

Open in Power BI Desktop

Connect to provided SQL script (if needed)

Explore dashboard pages

📂 Repository Structure
📁 SwiftRoute-Logistics-Analytics
 ├── README.md
 ├── SwiftRoute_Dashboard.pbix
 ├── SQL_Validation_Scripts.sql
 ├── Data_Model_Diagram.png
 ├── Executive_Dashboard.png
 ├── Hub_Analysis.png
 ├── Driver_Analysis.png
 ├── Vehicle_Analysis.png

💡 What This Project Demonstrates

✔ Business KPI understanding
✔ Advanced DAX usage
✔ SQL + BI integration
✔ Data modeling fundamentals
✔ Analytical storytelling
✔ Industry-ready dashboard design

🎯 Future Improvements

Add Forecasting (Next Month Orders)

Implement What-If Analysis

Add Row Level Security (RLS)

Optimize for large datasets

Add drill-through pages

👨‍💻 Author

Ritik Dhawade
Aspiring Data Analyst | Power BI | SQL | DAX | Business Intelligence

Open to Data Analyst / BI opportunities.
