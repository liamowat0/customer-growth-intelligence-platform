-- Business analysis queries

/*
====================================================
QUESTION 5: MONTHLY REVENUE TREND
====================================================

Business Question:
How has revenue changed over time?

Purpose:
Analyze monthly revenue performance to identify
growth trends, seasonality, and potential periods
of business expansion or decline.

Expected Insight:
- Is revenue increasing over time?
- Are there seasonal spikes?
- Are there periods of slowdown?
- Is growth consistent or volatile?
*/

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    ROUND(SUM(payment_value), 2) AS revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY order_month
ORDER BY order_month;



-- QUESTION 6
-- TOP PRODUCT CATEGORIES BY REVENUE
