# Live Event Food & Beverage Operations Analytics (SQL)

This project, inspired by my current work, demonstrates an end-to-end SQL analytics workflow for evaluating food & beverage performance at live events (NBA games, concerts, etc.). The analysis mirrors real-world analytics work in sports and entertainment venues, focusing on KPI design, operational performance, item mix economics, time-based demand patterns, and data quality validation.

⚠️ Disclaimer  
All data and examples in this repository are simulated and inspired by real-world analytics problems. No proprietary, confidential, or client data is included.

---

## Business Context

Food & beverage operations at live events are driven by large, time-bound demand spikes, varying audience composition by event type, and operational constraints such as staffing, POS throughput, and stand optimization.

Analytics in this environment must:
- Accurately attribute sales to events
- Normalize performance by attendance
- Support operational decisions (staffing, stand openings, promotions. pricing, etc.)
- Remain resilient to data-quality issues such as duplicate line items and missing mappings

This project demonstrates how these challenges are addressed using SQL.

---

## Objectives

- Build a clean reporting layer by joining event, stand, item, and item-level sales data
- Define and calculate core food & beverage KPIs
- Analyze performance across event types, tiers, and arena levels
- Evaluate item mix and estimated margin using item-level cost data
- Analyze time-based demand using 15-minute buckets relative to event start
- Quantify discount and promotion impact
- Implement data quality checks to protect KPI integrity

---

## Data Model (Simulated)

### Source Tables
- **LKP_EVENTS_CALENDAR**  
  Event metadata and attendance by seating segment (General, Club, Suite, Courtside)

- **LKP_STAND_LOCATIONS**  
  Stand-level attributes including department, stand type, and arena level

- **LKP_ITEM_DETAILS**  
  Item attributes including price, cost, and category hierarchy

- **SRC_RAW_SALES_BY_ITEM**  
  Item-level sales transactions where `SALE_ID` may repeat to represent multi-item baskets

### Reporting Layer
- **VW_REPORTING_TABLE**  
  Unified reporting view combining all source tables

Sales are attributed to events using an event time window:
- From `EVENT_START_TIME - 2 hours`
- To `EVENT_START_TIME + 4 hours`

---

## KPI Framework

- **Revenue** = `SUM(NET_SALES)`
- **Units Sold** = `SUM(UNITS_SOLD)`
- **Transactions** = `COUNT(DISTINCT SALE_ID)`
- **Per Cap** = `Revenue / TOTAL_ATTENDANCE`
- **Conversion** = `Transactions / TOTAL_ATTENDANCE`
- **Basket Size** = `Units Sold / Transactions`
- **Average Ticket** = `Revenue / Transactions`

---

## Analysis Progression

### 1. Core KPI Analysis  


---

### 2. Attendance Segment Performance  


---

### 3. Stand & Operational Performance  



---

### 4. Item Mix & Estimated Margin  



---

### 5. Time-Based Demand Analysis  


---

### 6. Discounts & Promotions  



---

### 7. Data Quality Validation  



---

## How to Run the Project



---

## What This Project Demonstrates

- Advanced SQL joins and aggregations
- KPI design and normalization
- Operational analytics for live-event environments
- Item-level economic analysis
- Time-series demand analysis
- Data quality and validation practices
- Clear analytical storytelling aligned with business decisions

---

## How This Scales Beyond F&B

While this project focuses on food & beverage operations, the same analytical techniques apply to:
- Product and user engagement analytics
- Marketplace and transaction platforms
- Experimentation and before/after analysis
- Revenue and conversion funnel analysis

This project serves as a foundation for broader analytics work beyond the sports and entertainment domain.
