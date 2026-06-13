# Insights Log

---

## Baseline KPI Assessment

### Business Question

What is the current state of the business in terms of revenue, customers, and order activity?

### SQL

```sql
SELECT
    ROUND(SUM(payment_value),2) AS total_revenue
FROM payments;

SELECT
    COUNT(*) AS total_orders
FROM orders;

SELECT
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM customers;

SELECT
    ROUND(AVG(payment_value),2) AS avg_order_value
FROM payments;

SELECT
    MIN(order_purchase_timestamp) AS first_order,
    MAX(order_purchase_timestamp) AS last_order
FROM orders;
```

### Finding

- Total Revenue: $16.0M
- Total Orders: 99,441
- Unique Customers: 96,096
- Average Order Value: $154.10
- Analysis Period: September 2016 – October 2018

### Business Insight

The business generated approximately $16 million in revenue across nearly 100,000 orders during a 25-month period.

The gap between total orders and unique customers indicates the presence of repeat purchasing behavior. However, it is not yet clear whether repeat customers represent a significant portion of revenue or whether retention is strong enough to support long-term growth.

The relatively high average order value of $154.10 suggests customers may be purchasing higher-priced products or multiple items per transaction.

### Recommendation

Conduct further analysis to determine:

- Customer retention rates
- Customer lifetime value (LTV)
- RFM customer segments
- Revenue contribution from repeat customers
- Product categories driving high order values

These analyses will help identify the business's most valuable customers and the key drivers of sustainable revenue growth.
