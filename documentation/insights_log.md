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


## Customer Retention Analysis

### Business Question

How many customers place repeat orders?

### SQL

```sql
SELECT
    order_count,
    COUNT(*) AS customers
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS order_count
    FROM customers c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) customer_orders
GROUP BY order_count
ORDER BY order_count;
```

### Finding

Customer purchase frequency distribution:

- 93,099 customers placed 1 order
- 2,745 customers placed 2 orders
- 203 customers placed 3 orders
- 49 customers placed 4 or more orders

Approximately 96.9% of customers made only one purchase.

Only 3.1% of customers placed multiple orders.

### Business Insight

Customer retention appears to be very low, with the overwhelming majority of customers making a single purchase before becoming inactive.

This suggests that business growth is driven primarily by customer acquisition rather than repeat purchasing behavior.

The company may be missing significant opportunities to increase customer lifetime value through retention and loyalty initiatives.

### Recommendation

Investigate factors influencing customer retention, including:

- Customer satisfaction and review scores
- Product category purchasing behavior
- Delivery performance
- Geographic differences in retention
- Customer segmentation

Develop retention-focused strategies such as loyalty programs, targeted promotions, and post-purchase engagement campaigns to increase repeat purchasing rates.


## Customer Segmentation (RFM Analysis)

### Business Question

Which customer segments drive the business, and where are retention opportunities?

### Methodology

Customers were segmented using:

- Recency (days since last purchase)
- Frequency (number of orders)
- Monetary Value (total spending)

Segments were defined as:

- Champions
- Loyal Customers
- Big Spenders
- At Risk Customers
- One-Time Customers

### Findings

| Segment | Customers |
|----------|----------:|
| One-Time Customers | 63,047 |
| At Risk | 26,045 |
| Big Spenders | 3,897 |
| Loyal Customers | 355 |
| Champions | 13 |

### Business Insight

The customer base is heavily concentrated among one-time purchasers and inactive customers.

More than 95% of customers fall into either the One-Time Customer or At Risk segments.

Only 368 customers qualify as Loyal Customers or Champions, indicating a very small core customer base.

The business appears highly dependent on customer acquisition rather than long-term customer retention.

### Recommendation

Prioritize retention initiatives aimed at:

- Re-engaging At Risk customers
- Increasing second-purchase conversion rates
- Creating loyalty and rewards programs
- Developing personalized marketing campaigns for high-value customers

Future analysis should evaluate whether delivery performance, product categories, customer reviews, or geographic factors influence customer retention.


## Cohort Retention Analysis

### SQL

```sql
WITH customer_cohorts AS (

SELECT
    c.customer_unique_id,

    DATE_FORMAT(
        MIN(o.order_purchase_timestamp),
        '%Y-%m'
    ) AS cohort_month

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY c.customer_unique_id

),

customer_activity AS (

SELECT
    c.customer_unique_id,

    DATE_FORMAT(
        o.order_purchase_timestamp,
        '%Y-%m'
    ) AS activity_month

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

)

SELECT

cc.cohort_month,

TIMESTAMPDIFF(
    MONTH,
    STR_TO_DATE(CONCAT(cc.cohort_month,'-01'),'%Y-%m-%d'),
    STR_TO_DATE(CONCAT(ca.activity_month,'-01'),'%Y-%m-%d')
) AS month_number,

COUNT(DISTINCT cc.customer_unique_id) AS customers

FROM customer_cohorts cc

JOIN customer_activity ca
    ON cc.customer_unique_id = ca.customer_unique_id

GROUP BY
    cohort_month,
    month_number

ORDER BY
    cohort_month,
    month_number;
```

### Business Question

How effectively does the business retain customers after their initial purchase?

### Methodology

Customers were grouped into acquisition cohorts based on the month of their first purchase.

Subsequent purchases were tracked over time to measure customer retention.

### Findings

Customer acquisition grew rapidly throughout 2017 and stabilized during 2018.

Across nearly all cohorts, fewer than 1% of customers returned to make another purchase within the following month.

Examples:

- January 2017: 764 customers acquired, 3 returned after one month
- November 2017: 7,304 customers acquired, 40 returned after one month
- April 2018: 6,711 customers acquired, 39 returned after one month

### Business Insight

The business demonstrates strong customer acquisition performance but extremely weak customer retention.

Nearly all customer cohorts experience significant drop-off immediately following the first purchase.

This finding is consistent with previous retention and RFM analyses, suggesting that long-term growth is heavily dependent on acquiring new customers rather than retaining existing ones.

### Recommendation

Investigate:

- Product category retention differences
- Customer satisfaction drivers
- Loyalty program opportunities
- Post-purchase engagement strategies
- Repeat purchase incentives

Improving second-purchase conversion rates should be a strategic priority.


## Delivery Performance Analysis

### SQL

```sql
SELECT

COUNT(*) AS total_orders,

SUM(
    CASE
        WHEN order_delivered_customer_date >
             order_estimated_delivery_date
        THEN 1
        ELSE 0
    END
) AS late_orders

FROM orders

WHERE order_delivered_customer_date IS NOT NULL;
```

### Business Question

How effectively does the company deliver orders on time?

### SQL Findings

- Total Orders: 99,441
- Late Orders: 7,827
- Late Delivery Rate: 7.87%

### Business Insight

Operational performance appears strong, with more than 92% of orders delivered on or before the estimated delivery date.

The relatively low late-delivery rate suggests that fulfillment operations are generally effective and unlikely to be the primary cause of poor customer retention.

### Recommendation

Further analysis should investigate whether customer retention challenges are driven by factors other than delivery performance, including product quality, customer expectations, category-specific purchasing behavior, or competitive market dynamics.
