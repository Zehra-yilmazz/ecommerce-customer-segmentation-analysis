-- ============================================================
--  Monthly sales summary for Power BI overview page
--
-- Columns:
--   order_month     -> the month (e.g. 2017-05, 2018-01)
--   total_orders    -> number of distinct orders placed that month
--   total_revenue   -> sum of all payments that month (total revenue)
--   avg_order_value -> average order value (total_revenue / total_orders)
-- ============================================================

SELECT
DATE_FORMAT(o.order_purchase_timestamp , '%Y-%m') AS order_month,
COUNT(DISTINCT o.order_id ) AS total_orders,
SUM(op.payment_value ) AS total_revenue,
SUM(op.payment_value ) / COUNT(DISTINCT o.order_id ) AS avg_order_value
FROM orders o
JOIN order_payments op ON o.order_id=op.order_id
WHERE order_status="delivered"
GROUP BY DATE_FORMAT(o.order_purchase_timestamp , '%Y-%m')
ORDER BY order_month ;

 


