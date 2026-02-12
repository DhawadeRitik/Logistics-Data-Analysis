# 🚛 SwiftRoute Logistics Analytics Dashboard  
### Power BI | SQL | DAX | End-to-End Business Intelligence Project  

---

## 📌 Project Summary

SwiftRoute Logistics Analytics is a full-scale Business Intelligence solution built to analyze logistics operations across **Orders, Hubs, Drivers, and Fleet Vehicles**.

This project demonstrates the complete BI workflow:
**Data Validation (SQL) → Data Modeling (Star Schema) → KPI Engineering (DAX) → Executive Dashboarding (Power BI).**

---

## 🎯 Business Impact

✔ Monitored **On-Time Delivery Rate (OTDR %)** to improve SLA compliance  
✔ Identified **overloaded hubs** operating above capacity  
✔ Detected **high-delay drivers and vehicle models**  
✔ Analyzed **Month-over-Month operational growth trends**  
✔ Evaluated **vehicle age vs breakdown frequency** for predictive planning  

---

## 📊 Dashboard Highlights

### 1️⃣ Executive Overview
- Total Orders  
- OTDR %  
- CSAT %  
- Avg Delivery Time  
- MoM Growth %  
- Dynamic Time Intelligence  

### 2️⃣ Hub Performance
- Capacity vs Orders  
- Hub Ranking (RANKX)  
- Processing Heatmaps  
- Underperformance Detection  

### 3️⃣ Driver Analytics
- Experience vs Rating Scatter  
- Delay Rate Analysis  
- Monthly Delivery Trends  
- Driver KPI Profiles  

### 4️⃣ Fleet Intelligence
- Active vs Maintenance Vehicles  
- Breakdown Analysis by Model  
- Vehicle Age Risk Correlation  

---

## 🗂 Data Architecture

**Star Schema Model**

**Fact Table**
- `Fact_Orders`

**Dimension Tables**
- `Dim_Driver`
- `Dim_Hub`
- `Dim_Vehicle`
- `Dim_Date`

Optimized for performance, scalability, and efficient DAX calculations.

---

## 🛠 Technical Implementation

### 🔹 SQL Engineering
- CTE-based KPI validation  
- Window functions (`RANK() OVER()`)  
- Defensive division using `NULLIF()`  
- Data quality checks (NULLs, duplicates, data types)  
- Aggregation cross-verification  

### 🔹 Advanced DAX
- `CALCULATE()`
- `RANKX()`
- `SELECTEDVALUE()`
- `DATESINPERIOD()`
- `PREVIOUSMONTH()`
- `DIVIDE()`
- Context Transition  
- Time Intelligence  

All KPIs were cross-validated between SQL and Power BI for accuracy.

---

## 📈 Key Insights Generated

- Certain hubs consistently exceed operational capacity.  
- Older vehicles show higher breakdown frequency.  
- Driver experience does not always correlate with higher ratings.  
- Delay concentration is linked to specific hubs and vehicle models.  
- MoM trends reveal operational volatility patterns.  

---

## 🛠 Tech Stack

| Tool        | Usage |
|-------------|--------|
| Power BI    | Dashboard Development |
| DAX         | KPI Engineering |
| SQL Server  | Data Validation & Analysis |
| Star Schema | Data Modeling |

---

## 🚀 What This Project Demonstrates

✔ End-to-End BI Development  
✔ Business-Oriented KPI Thinking  
✔ Advanced DAX & Time Intelligence  
✔ SQL + BI Integration  
✔ Analytical Storytelling  
✔ Industry-Ready Dashboard Design  

---

## 👨‍💻 Author

**Ritik Dhawade**  
Aspiring Data Analyst | Power BI | SQL | DAX | Business Intelligence  

📩 Open to Data Analyst / BI opportunities  

