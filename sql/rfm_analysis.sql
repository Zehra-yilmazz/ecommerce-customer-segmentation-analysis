-- ============================================================
-- RFM ANALYSIS - Customer Segmentation
-- ============================================================
--
-- WHAT IS RFM ANALYSIS?
-- RFM stands for Recency, Frequency, and Monetary value - three 
-- behavioral metrics used to quantify customer value:
--   - Recency:   How recently did the customer make a purchase?
--   - Frequency: How often does the customer purchase?
--   - Monetary:  How much money does the customer spend in total?
--
-- WHY WE PERFORMED THIS ANALYSIS
-- Not all customers contribute equally to a business. RFM analysis 
-- allows us to quantitatively rank and group customers based on 
-- their actual purchasing behavior, rather than relying on assumptions.
-- Each customer is scored on a 1-5 scale for each dimension (based on 
-- quantiles), and these scores are combined to classify customers 
-- into meaningful segments such as "Champions", "Loyal Customers", 
-- "At Risk", and "New Customers".
--
-- CONTRIBUTION TO THE PROJECT
-- 1. Business Insight: Identifies which customer groups generate 
--    the most revenue and which are at risk of churning.
-- 2. Data-Driven Decision Making: Provides a foundation for targeted 
--    marketing strategies (e.g., retention campaigns for "At Risk" 
--    customers, loyalty rewards for "Champions").
-- 3. Dashboard Value: Segment results feed directly into the Power BI 
--    dashboard, giving managers a clear, visual breakdown of customer 
--    value distribution.
-- 4. Industry-Standard Method: RFM is a widely recognized technique 
--    in customer analytics, demonstrating applied statistical thinking 
--    in a real business context.
--
-- ============================================================


-- ============================================================
-- STEP 1: Calculate raw R, F, M values per customer
-- ============================================================
-- QUERY LOGIC SUMMARY
-- ============================================================
-- 1. Join three tables together (orders + customers + payment info)
-- 2. Filter to include only delivered orders
-- 3. Group the data by customer
-- 4. For each customer, calculate:
--    - Recency:   how recently they made their last purchase
--    - Frequency: how many orders they placed
--    - Monetary:  how much they spent in total
-- ============================================================
SELECT 
    c.customer_unique_id,
    DATEDIFF((SELECT MAX(order_purchase_timestamp) FROM orders), 
              MAX(o.order_purchase_timestamp)) AS recency,
    COUNT(DISTINCT o.order_id) AS frequency,
    SUM(p.payment_value) AS monetary
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_payments p ON o.order_id customersorder_itemsordersproduct_category_translation= p.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_unique_id;