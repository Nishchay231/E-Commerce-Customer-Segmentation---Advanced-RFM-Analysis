# Olist E-Commerce Customer Segmentation (Advanced RFM Analysis)

## 📌 Project Overview
This project performs an advanced RFM (Recency, Frequency, Monetary) analysis on the Olist Brazilian E-Commerce dataset. Unlike standard RFM tutorials that rely on basic percentile bucketing, this project utilizes a **Two-Axis Segmentation Model** (Engagement vs. Value) to uncover hidden revenue opportunities. 

The analysis was conducted end-to-end using **MySQL** for data modelling, **Excel** for data QA, and **Power BI** for executive dashboarding.

## 🛠 Tech Stack
* **Database & SQL:** MySQL Workbench 8.0 (Data Modelling, Views, Window Functions, `CASE WHEN` logic, Aggregations)
* **Data Visualization & BI:** Power BI (DAX, Data Modelling, Matrix Heatmaps, Custom Visual Hierarchy)
* **Data QA & Validation:** Excel (PivotTables, Cartesian product checks, Grand Total reconciliation)

## 🧠 Technical Methodology & Advanced Logic
To ensure business accuracy, several specific data modelling decisions were made that differ from standard beginner tutorials:

1. **Human-Level Aggregation (`customer_unique_id`):** 
   Olist assigns a new `customer_id` for every single order. To accurately track repeat behaviour, data was aggregated using `customer_unique_id`. Failing to do this inflates the "First-Time Buyer" count and ruins the Frequency metric.
2. **Historical Data Anchoring (Recency Calculation):**
   Because the dataset is historical (2016-2018), using the standard SQL `CURDATE()` function would result in every customer having a Recency of several years, rendering the analysis useless. Instead, I established a dynamic anchor date set to the day after the last recorded transaction in the dataset (`MAX(order_purchase_timestamp) + 1 day`) to accurately measure Recency relative to the business's actual timeline.
3. **Handling Installment Duplication:** 
   Olist allows installment payments, creating multiple rows per order in the payments table. The SQL joins were structured strictly to prevent cartesian products and double-counting of revenue, which was independently cross-verified using Excel PivotTables.
4. **Manual Frequency Bucketing (Skew Handling):** 
   Because >90% of Olist customers bought exactly once, using standard `NTILE(5)` on Frequency causes arbitrary and meaningless splits. I utilised manual `CASE WHEN` logic to assign Frequency scores based on true business hurdles (e.g., Score 1 = 1 order, Score 3 = 2 orders).
5. **Two-Axis Segmentation:** 
   Rather than flat RFM segments, I split the logic into:
   * **Engagement Segment (R + F):** Active Repeat, Churning Repeat, Lost, First-Time, Average.
   * **Value Tier (M):** High-Value, Mid-Value, Low-Value.

## Dashboard

### Page 1 — Overview
| Visual | Key finding it reveals |
|---|---|
| KPI row (Total Revenue, Customer Count, Lost×High-Value Revenue, High-Value Revenue %) | ₹15.42M total revenue, with ₹3.12M of it (20.3%) sitting in one dormant-but-proven segment |
| Stacked bar — Engagement Segment × Value Tier by Total Revenue | First Time Buyers and Lost Customers are nearly tied as the two biggest revenue segments, and each is hiding a similarly large High-Value slice inside it |
| Customer % & Avg Order Value by Value Tier (table) | Confirms the 20/40/40 customer split and shows the average order value gap directly: ₹442 (High) vs ₹137 (Mid) vs ₹55 (Low) |
| Donut — Revenue by Value Tier | Confirms the 53.52% / 33.13% / 13.34% split at a glance |
| Slicers (Engagement Segment, Value Tier) | — |

### Page 2 — Segment Deep Dive
| Visual | Key finding it reveals |
|---|---|
| KPI row (Avg Recency – Lost, Lost×High-Value Revenue, Lost High-Value Customers) | Lost customers have been dormant an average of 394 days — a long but still-addressable win-back window |
| Composition matrix — Customer count by Engagement Segment × Value Tier, row-normalised colour | Active Repeat Buyers and Churning Repeat Buyers are the two darkest High-Value cells on the grid — over half of each of those segments is High-Value, even though they're tiny in absolute customer count |
| Box-and-whisker — Monetary distribution by Engagement Segment, colored by Value Tier | Lost Customers and First Time Buyers both show a tight, low median box with a long right-hand whisker reaching toward ₹3M+ — visual proof that an "average" label is masking real high-value customers |
| R/F/M detail matrix (Engagement Segment × Value Tier, avg Recency/Frequency/Monetary) | Confirms, e.g., that High-Value Active Repeat Buyers average ₹458.78 — the highest average order value of any cell outside the Lost×High-Value pocket |

## 🎯 Segment Definitions & Marketing Recommendations
Based on the Two-Axis framework, here is the strategic playbook for targeting all identified segments, including recommended promotional budgets (discounts):

### 1. Active Repeat Buyers
* **Who they are:** Customers who bought recently and buy often (High Recency, High Frequency).
* **Recommendation:** Focus on loyalty and upselling. Do not train them to wait for discounts, as they already love the brand. 
* **Discount Strategy:** **0% - 5%**. Instead of price cuts, offer exclusive perks, early access to new products, or VIP loyalty points.

### 2. First-Time Buyers
* **Who they are:** Customers who bought very recently, but have only ordered exactly once (High Recency, Low Frequency).
* **Recommendation:** The hardest hurdle in e-commerce is driving the second purchase. Hit them with an onboarding sequence and a time-sensitive offer to build a buying habit.
* **Discount Strategy:** **10% - 15%** on their *next* purchase, with a strict 14-day expiration to create urgency.

### 3. Average Customers
* **Who they are:** The "middle of the road" majority. They buy sporadically and are not currently highly active, but aren't completely lost yet (Mid Recency, Mid/Low Frequency).
* **Recommendation:** Business-as-usual marketing. Keep the brand top-of-mind without aggressively eating into profit margins.
* **Discount Strategy:** **10% - 20%**, strictly utilised during major seasonal sales (e.g., Black Friday, Holiday Clear-outs) rather than personalised triggers.

### 4. Churning Repeat Buyers
* **Who they are:** Customers who used to buy frequently, but their recency is slipping away (Low/Mid Recency, High Frequency). 
* **Recommendation:** High priority for retention. They have a proven track record of buying, but something disrupted their habit. Intercept them before they go completely cold.
* **Discount Strategy:** **20% - 25%**. Trigger a personalised "We Miss You" or "Come Back" automated email sequence with a moderately aggressive discount.

### 5. Lost Customers
* **Who they are:** Customers who bought a long time ago and rarely ordered (Low Recency, Low Frequency). 
* **Recommendation:** Requires triage based on their *Value Tier*. 
* **Discount Strategy:** 
  * **For Lost + High-Value:** **30%+ (Deep Discount)**. Because their historical AOV is ₹442+, you can afford a high Customer Acquisition Cost (CAC) to win them back. Offer a massive "Welcome Back" deal.
  * **For Lost + Low-Value:** **0%**. Do not waste margin or ad spend here. Leave them on the standard free weekly newsletter list.
