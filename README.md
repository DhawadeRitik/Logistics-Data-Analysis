# 🚛 SwiftRoute Logistics Analytics Dashboard  
### End-to-End Power BI + SQL Business Intelligence Project  

---

## 📌 Project Overview

SwiftRoute Logistics Analytics is an end-to-end Business Intelligence solution designed to analyze logistics operations across **Orders, Hubs, Drivers, and Fleet Vehicles**.

The objective of this project was to transform raw operational data into actionable insights using:

- **Microsoft SQL Server** (Data validation & KPI verification)
- **Power BI** (Dashboard development & visualization)
- **DAX** (Advanced KPI calculations & Time Intelligence)
- **Star Schema Data Modeling**

The dashboard enables stakeholders to monitor performance, detect inefficiencies, and support data-driven decision-making.

---

## 🎯 Business Objectives

- Monitor On-Time Delivery performance  
- Track Month-over-Month operational growth  
- Identify overloaded hubs  
- Analyze driver performance & delay patterns  
- Optimize fleet utilization & maintenance planning  
- Improve customer satisfaction  

---

## 📊 Dashboard Structure

The report is divided into **4 analytical views**:

---

### 1️⃣ Executive Overview

#### 🔹 Key KPIs
- 📦 Total Orders  
- ⏱ On-Time Delivery Rate (OTDR %)  
- ⭐ Customer Satisfaction (CSAT %)  
- 🚚 Average Delivery Time (Hours)  
- 📈 Month-over-Month Growth %

#### 🔹 Features
- Previous Month comparison  
- Dynamic KPI cards  
- DAX Time Intelligence  
- Trend analysis  

---

### 2️⃣ Hub Performance Analysis

#### 🔹 Insights
- Orders Processed vs Hub Capacity  
- Hub Ranking by OTDR  
- Processing Time Heatmap (Day-wise)  
- Underperforming Hub Identification  

#### 🔹 Business Impact
- Redistribute operational load  
- Improve SLA compliance  
- Optimize regional operations  

---

### 3️⃣ Driver Performance Dashboard

#### 🔹 Insights
- Experience vs Rating (Scatter Analysis)  
- Drivers with Highest Delay Rates  
- Monthly Delivery Trends  
- Individual Driver Profile Summary  

#### 🔹 Business Impact
- Identify training needs  
- Improve workforce efficiency  
- Reduce delivery delays  

---

### 4️⃣ Fleet & Vehicle Analysis

#### 🔹 Insights
- Active vs Maintenance Vehicles  
- Orders by Vehicle Type & Model  
- Vehicle Age vs Breakdown Frequency  
- Breakdown Analysis by Model  

#### 🔹 Business Impact
- Predictive maintenance planning  
- Fleet optimization  
- Cost reduction  

---

## 🗂 Data Modeling Approach

The project follows a **Star Schema Architecture**.

### 🔹 Fact Table
- `Fact_Orders`

### 🔹 Dimension Tables
- `Dim_Driver`
- `Dim_Hub`
- `Dim_Vehicle`
- `Dim_Date`

### 🔹 Benefits
- Improved performance  
- Clean relationships  
- Optimized DAX calculations  
- Scalable design  

---

## 🛠 SQL Data Validation & Engineering

Before building the dashboards, the dataset was validated in **SQL Server**.

### 🔹 Data Validation Steps
- Duplicate record checks  
- NULL value validation  
- Data type verification  
- Aggregation cross-verification  
- Month-over-Month KPI validation  
- Defensive division using `NULLIF()`  
- CTE-based KPI calculations  
- Window functions for ranking  

### 🔹 Example SQL Techniques Used
- `WITH CTE`
- `COUNT(CASE WHEN ...)`
- `RANK() OVER()`
- `GROUP BY`
- `TRY_CONVERT()`
- `NULLIF()`

All Power BI KPIs were cross-verified in SQL for accuracy.

---

## 📐 DAX Techniques Used

- `CALCULATE()`
- `RANKX()`
- `SELECTEDVALUE()`
- `DATESINPERIOD()`
- `PREVIOUSMONTH()`
- `DIVIDE()`
- `SUMMARIZE()`
- Dynamic Measures
- Time Intelligence
- Context Transition

---

## 📈 Key Analytical Insights

- Certain hubs consistently operate above capacity.  
- Higher vehicle age correlates with increased breakdown frequency.  
- Driver experience does not always guarantee higher rating.  
- Delay rates are concentrated among specific hubs and vehicle models.  
- MoM performance trends highlight operational volatility.  

---

## 🛠 Tech Stack

| Tool        | Purpose                          |
|-------------|----------------------------------|
| Power BI    | Dashboard & Visualization        |
| DAX         | KPI & Time Intelligence          |
| SQL Server  | Data Cleaning & Validation       |
| Star Schema | Data Modeling                    |

---

## 🚀 How to Use This Project

1. Download the `.pbix` file  
2. Open in Power BI Desktop  
3. Connect to the provided SQL script (if required)  
4. Explore the dashboard pages  

---

## 📂 Repository Structure

