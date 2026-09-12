-- ============================================================
-- STEP 8:COHORT ANALYSIS 
-- Extract order-level data needed for cohort analysis
-- For each order, we need the customer, the order date, and we 
-- will calculate the customer's first purchase month in Python

SELECT 
    c.customer_unique_id,
    o.order_id,
    o.order_purchase_timestamp
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
ORDER BY c.customer_unique_id, o.order_purchase_timestamp;

