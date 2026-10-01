# Customer Segmentation & Revenue Recovery Strategy

## 1. The Core Problem
Historically, promotional campaigns have been broadcast to the entire customer base evenly. This creates two major inefficiencies: discounting budget is wasted on customers who only buy cheap items once, and adequate incentives are not provided to win back the highest-spending users. A systematic approach was required to identify VIPs and isolate the most expensive churn risks.

## 2. Segment Deep Dive & Strategic Recommendations

Based on our Two-Axis RFM Analysis of 93,357 unique customers and ₹ 15.42M in revenue, the customer base has been segmented by behavioral engagement. Below is the breakdown of each segment alongside tailored strategic actions.

| Engagement Segment | Customer Count | % of Customers | Total Revenue | Revenue % | Key Finding | Strategic Recommendation |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **First Time Buyers** | 36,142 | 38.71% | ₹ 5.94M | 38.50% | Represents our largest acquisition group, but they possess unproven loyalty and carry a high risk of one-and-done behavior. | Restrict to highly scalable, low-cost nurturing channels (e.g., standard automated email flows) to drive a second purchase. |
| **Lost Customers** | 36,351 | 38.94% | ₹ 5.88M | 38.15% | Holds massive historical value trapped in inactive users. Contains a critical subset of 6,990 "High-Value" users who have stopped buying entirely. | Filter for the "High-Value" tier only and deploy aggressive, high-margin VIP win-back offers (e.g., 30% off or a premium gift). |
| **Average Customers** | 18,063 | 19.35% | ₹ 2.74M | 17.75% | The "silent majority." These are middle-of-the-road spenders with sporadic or average engagement patterns. | Exclude from deep discounts. Nurture via Business-As-Usual (BAU) marketing, standard newsletters, and seasonal promotions. |
| **Churning Repeat Buyers** | 1,600 | 1.71% | ₹ 0.48M | 3.09% | A very small segment, but they punch significantly above their weight in revenue (proven repeat buyers). They are currently fading. | Trigger a gentle, automated re-engagement sequence (e.g., a 10% nudge discount or "We Miss You" email) before they fall into the "Lost" bucket. |
| **Active Repeat Buyers** | 1,201 | 1.29% | ₹ 0.39M | 2.51% | The absolute VIPs. Though small in volume, their Average Order Value (AOV) and loyalty are exceptionally high. | Do not discount. Reward them with VIP treatment, early access to new products, and referral program invitations to protect margins. |

## 3. Headline Findings & Immediate Actions

While the table above maps the entire customer base, the immediate focus for the marketing team should be centered on these three high-ROI initiatives:

* **The ₹ 3.12M Revenue Leak (High Priority):** 
  * *The Focus:* 20.26% of our lifetime revenue is currently sitting in the **"Lost x High-Value"** cross-segment. These 6,990 customers are highly lucrative but totally inactive.
  * *The Action:* Because their historical Average Order Value (AOV) is nearly triple the company average, the business can afford a much higher Customer Acquisition Cost (CAC) to reactivate them. Export this exact list from the Power BI grid and launch an aggressive VIP win-back campaign immediately.
* **The Untapped Potential of First-Time Buyers:**
  * *The Focus:* **First-Time Buyers account for our largest single revenue block (₹ 5.94M / 38.50%)**, matching our Lost Customers in volume. However, getting a customer to buy a second time is the hardest hurdle in e-commerce.
  * *The Action:* We must prevent this massive cohort from churning into the "Lost" bucket. Enroll them immediately into an automated post-purchase email flow (e.g., welcome series, cross-sell recommendations) to drive that crucial second purchase without spending heavily on ads.
* **Catching the "Slipping" Repeaters:**
  * *The Focus:* The 1,600 Churning Repeat Buyers are the easiest to save right now. They haven't forgotten about the brand, but their buying cycle has broken.
  * *The Action:* It is significantly cheaper to nudge a slipping customer than to reactivate a completely lost one. Deploy a low-cost 10% discount sequence this week to repair their buying habit.

## 4. Assumptions & Risks

* **Revenue Recognition (Delivered Orders Only):** To prevent artificially inflating revenue numbers, only orders with a finalized `delivered` status were counted. Canceled, returned, or lost shipments were excluded from the RFM model.
* **Human-Level Aggregation (`customer_unique_id`):** The Olist platform assigns a new `customer_id` for every single transaction. To accurately track repeat behavior, data was strictly aggregated using `customer_unique_id`. Failing to do this would have incorrectly classified every user as a one-time buyer.
* **Handling Installment Payments:** Olist allows customers to pay in installments, which creates multiple rows per order in the payments table. SQL joins and aggregations were specifically structured (and QA'd in Excel) to prevent the double-counting of order revenue.
* **Illustrative Discounts:** The discount percentages mentioned in the recommendations (e.g., 10% nudge, 30% win-back) are illustrative starting points based on the behavioral risk-to-value logic of the segments. Final promotional depths should be aligned with current unit economics and profit margins.