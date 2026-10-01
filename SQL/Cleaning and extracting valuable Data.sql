-- Checking the Null values for the delivered orders
SELECT 
    COUNT(*)
FROM
    orders
WHERE
    order_delivered_customer_date IS NULL;
-- Finding - No Null values are present for delivered orders


-- Checking the Order distribution status 
SELECT 
    order_status, COUNT(*)
FROM
    orders
GROUP BY order_status;


-- Checking for duplicate order ids
SELECT 
    order_id, COUNT(*)
FROM
    orders
GROUP BY order_id
HAVING COUNT(*) > 1;
-- Findings - No duplicate order_ids are present



 