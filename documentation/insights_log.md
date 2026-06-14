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



## Monthly Revenue Trend

### Business Question

How has revenue changed over time?

### SQL

```sql
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS order_month,
    ROUND(SUM(payment_value), 2) AS revenue
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
GROUP BY order_month
ORDER BY order_month;
```

### Finding

Monthly revenue increased significantly throughout 2017, growing from approximately $138K in January 2017 to nearly $1.2M in November 2017.

Revenue remained relatively stable throughout most of 2018, fluctuating between approximately $1.0M and $1.16M per month.

A noticeable revenue spike occurred in November 2017, followed by elevated sales in December 2017.

### Business Insight

The company experienced rapid growth throughout 2017 before reaching a more mature and stable revenue level in 2018.

The sharp increase in revenue during November and December suggests seasonal purchasing behavior, likely driven by holiday shopping periods and promotional events.

The stabilization of revenue during 2018 indicates that the business may have transitioned from a high-growth phase into a more mature operating stage where customer retention and operational efficiency become increasingly important drivers of future growth.

### Recommendation

Investigate the drivers behind the 2017 growth period by analyzing:

- Customer acquisition trends
- Product category performance
- Geographic expansion
- Repeat customer behavior

Additionally, analyze seasonal sales patterns and promotional effectiveness to determine whether holiday-driven growth opportunities can be replicated in future periods.



## Top Product Categories by Revenue

### Business Question

Which product categories generate the most revenue?

### SQL

```sql
SELECT
    p.product_category_name AS category,
    ROUND(SUM(oi.price),2) AS revenue,
    COUNT(DISTINCT oi.order_id) AS orders
FROM order_items oi
JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 15;
```

### Finding

The highest revenue-generating product categories were:

- Health & Beauty: $1.26M
- Watches & Gifts: $1.21M
- Bed, Bath & Table: $1.04M
- Sports & Leisure: $988K
- Computer Accessories: $912K

Several home-related categories also ranked among the top performers, including furniture, home utilities, and office furniture.

### Business Insight

Revenue is concentrated among a relatively small number of product categories, indicating that category management plays a significant role in overall business performance.

Home and lifestyle products represent a major portion of revenue, suggesting a strong market position within those segments.

Higher-value categories such as watches, gifts, and computer accessories likely contribute to the company's above-average order value.

### Recommendation

Focus future analysis on:

- Category profitability
- Customer purchasing behavior by category
- Category-specific retention rates
- Seasonal category performance
- Cross-selling opportunities between top-performing categories

Prioritize marketing and inventory investments toward categories that demonstrate both high revenue and consistent demand.
