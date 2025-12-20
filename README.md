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
This repository includes simulated CSV datasets in the `/data` folder:

### Source Tables
- **`data/LKP_EVENTS_CALENDAR.csv`**  
  Event metadata and attendance by seating segment (General, Club, Suite, Courtside)

- **`data/LKP_STAND_LOCATIONS.csv`**  
  Stand-level attributes including department, stand type, and arena level

- **`data/LKP_ITEM_DETAILS.csv`**  
  Item attributes including price, cost, and category hierarchy

- **`data/SRC_RAW_SALES_BY_ITEM.csv`**  
  Item-level sales transactions where `SALE_ID` may repeat to represent multi-item baskets

⚠️ These files contain non-proprietary data, imagined for demonstrating SQL reporting and KPI analysis.

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
**File:** `02_core_kpis.sql`

- Event-level revenue, units, and transactions
- Attendance-normalized KPIs for fair comparisons across events

---

### 2. Attendance Segment Performance  
**File:** `03_attendance_segments.sql`

- Revenue and transactions by arena level
- Segment-level per-cap analysis (General, Club, Suite, Courtside)

---

### 3. Stand & Operational Performance  
**File:** `04_stand_performance.sql`

- Stand-level revenue and throughput
- Performance by department, stand type, and arena level
- Identification of high-impact operational locations

---

### 4. Item Mix & Estimated Margin  
**File:** `05_item_mix_margin.sql`

- Item-level volume and revenue
- Estimated COGS using item cost
- Estimated gross margin and margin percentage

---

### 5. Time-Based Demand Analysis  
**File:** `06_time_buckets_15min.sql`

- 15-minute demand buckets relative to event start
- Identification of peak sales windows
- POS throughput proxy (transactions per POS)

---

### 6. Discounts & Promotions  
**File:** `07_discounts_promos.sql`

- Revenue and units by discount type
- Discount dollars and discount rate by event type


---

### 7. Data Quality Validation  
**File:** `08_data_quality_checks.sql`

- Missing item or stand mappings
- Duplicate line-item inflation risk
- Suspicious sales or unit values
- Event attribution gaps


---

## How to Run the Project

1. Run `00_schema.sql` to create tables.
2. Load the CSVs from `/data` into the tables using your preferred method.
3. Create the reporting view using `01_vw_reporting_table.sql`
4. Execute analysis files in order:
   - `02_core_kpis.sql`
   - `03_attendance_segments.sql`
   - `04_stand_performance.sql`
   - `05_item_mix_margin.sql`
   - `06_time_buckets_15min.sql`
   - `07_discounts_promos.sql`
   - `08_data_quality_checks.sql`

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
