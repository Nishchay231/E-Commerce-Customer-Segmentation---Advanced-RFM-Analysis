-- Creating View for delivered orders
CREATE VIEW vw_delivered_orders AS
    SELECT 
        o.order_id,
        c.customer_unique_id,
        o.order_purchase_timestamp,
        op.payment_value
    FROM
        orders o
            JOIN
        customers c ON o.customer_id = c.customer_id
            JOIN
        order_payments op ON o.order_id = op.order_id
    WHERE
        o.order_status = 'delivered';

SELECT 
    *
FROM
    vw_delivered_orders;


-- Since it is a historical data (2016-2018), so we don't use CURDATE() — we use the day after the last order in the dataset:
-- Checking the date range
SELECT 
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM
    vw_delivered_orders;
-- Findings: first_order = 2016-10-03, last_order = 2018-08-28
-- Analysis date = last_order + 1 day = 2018-08-29 


-- Creating the view of the RFM value
CREATE VIEW vw_rfm_raw AS
    SELECT 
        customer_unique_id,
        DATEDIFF('2018-08-29',
                MAX(order_purchase_timestamp)) AS recency,
        COUNT(DISTINCT order_id) AS frequency,
        SUM(payment_value) AS monetary
    FROM
        vw_delivered_orders
    GROUP BY customer_unique_id;
-- Checking the view
SELECT 
    *
FROM
    vw_rfm_raw;


-- Creating the view of RFM score for further analysis
CREATE VIEW vw_rfm_scored AS
SELECT
    customer_unique_id,
    recency,
    frequency,
    monetary,
    -- Recency: lower days = better, descreasing order in NTILE
    NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
    -- Frequency: using CASE operator in place of NTILE, as the values are highly skewed
    CASE 
        WHEN frequency = 1 THEN 1
        WHEN frequency = 2 THEN 3
        WHEN frequency BETWEEN 3 AND 4 THEN 4
        ELSE 5
    END AS f_score,
    -- Monetary: higher revenue = better, ascending order in NTILE
    NTILE(5) OVER (ORDER BY monetary ASC) AS m_score
FROM vw_rfm_raw;


-- We have done Two-Axis Segmentation because there are some customers whose RF is average but spend higher
-- Engagement (lifecycle segment, from R+F only) and Value (spend segment, from M only)
CREATE VIEW vw_rfm_segments AS
SELECT
    *,
    CONCAT(r_score, f_score, m_score) AS rfm_code,

    -- ENGAGEMENT SEGMENT: Based of R and F, that is when/how often they buy
    CASE
        WHEN r_score >= 4 AND f_score >= 2 THEN 'Active Repeat Buyers'
        WHEN r_score >= 4 AND f_score = 1 THEN 'First Time Buyers'
        WHEN r_score <= 3 AND f_score >= 3 THEN 'Churning Repeat Buyers'
        WHEN r_score <= 2 AND f_score = 1 THEN 'Lost Customers'
        ELSE 'Average Customers'
    END AS engagement_segment,

    -- VALUE SEGMENT: Based of M, that is what they're worth — fully independent of R/F
    CASE
        WHEN m_score = 5 THEN 'High-Value'
        WHEN m_score IN (3,4) THEN 'Mid-Value'
        ELSE 'Low-Value'
    END AS value_tier

FROM vw_rfm_scored;

-- Checking the Ratio of Revenue %, Average Spent and Customer Count % of each Segment
SELECT 
    engagement_segment,
    value_tier,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS pct_customers,
    ROUND(SUM(monetary),1) AS segment_revenue,
    ROUND(SUM(monetary) * 100.0 / SUM(SUM(monetary)) OVER(), 2) AS pct_revenue,
    ROUND(AVG(monetary),1) AS avg_monetary
FROM vw_rfm_segments
GROUP BY engagement_segment, value_tier
ORDER BY segment_revenue DESC;

-- Total Revenue and Customer Count per Engagement segment
SELECT 
    engagement_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(monetary), 1) AS revenue
FROM
    vw_rfm_segments
GROUP BY engagement_segment
ORDER BY revenue DESC;

-- Total Revenue Ratio and Customer Count per Value Segment
SELECT value_tier, COUNT(*) AS customer_count, ROUND(SUM(monetary),1) AS revenue,
       ROUND(SUM(monetary) * 100.0 / SUM(SUM(monetary)) OVER(), 2) AS pct_revenue
FROM vw_rfm_segments GROUP BY value_tier ORDER BY revenue DESC;


select * from vw_rfm_segments;