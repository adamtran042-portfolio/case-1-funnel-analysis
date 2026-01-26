-- Case 1: Funnel analysis by primary category
-- Notes:
-- - Assumes `events` table already exists (data ingestion omitted).
-- - Primary category is derived from the first segment of category_code.

CREATE TABLE IF NOT EXISTS events (
    event_time DATETIME,
    event_type VARCHAR(20),
    product_id BIGINT,
    category_id BIGINT,
    category_code VARCHAR(255),
    brand VARCHAR(100),
    price DECIMAL(10,2),
    user_id VARCHAR(128),
    user_session VARCHAR(64)
)
WITH base_events AS (
    SELECT
        e.user_id,
        CASE
            WHEN e.category_code IS NULL OR TRIM(SUBSTRING_INDEX(e.category_code, '.', 1)) = ''
                THEN 'Unclassified'
            ELSE SUBSTRING_INDEX(e.category_code, '.', 1)
        END AS primary_category,
        e.event_type,
        e.price
    FROM events e
    WHERE e.user_id IS NOT NULL
      AND e.event_type IN ('view', 'cart', 'purchase')
),
user_category_funnel AS (
    SELECT
        user_id,
        primary_category,
        MAX(event_type = 'view') AS view_flag,
        MAX(event_type = 'cart') AS cart_flag,
        MAX(event_type = 'purchase') AS purchase_flag
    FROM base_events
    GROUP BY user_id, primary_category
),
category_counts AS (
    SELECT
        primary_category,
        SUM(view_flag) AS total_view,
        SUM(cart_flag) AS total_cart,
        SUM(purchase_flag) AS total_purchase
    FROM user_category_funnel
    GROUP BY primary_category
),
category_revenue AS (
    SELECT
        primary_category,
        SUM(CASE WHEN event_type = 'view' THEN price ELSE 0 END) AS potential_revenue,
        SUM(CASE WHEN event_type = 'purchase' THEN price ELSE 0 END) AS realized_revenue
    FROM base_events
    GROUP BY primary_category
),
totals AS (
    SELECT SUM(total_view) AS total_views
    FROM category_counts
)
SELECT
    c.primary_category,
    c.total_view,
    c.total_cart,
    c.total_purchase,
    c.total_cart/NULLIF(c.total_view, 0)*100 AS view_to_cart,
    c.total_purchase/NULLIF(c.total_cart, 0)*100 AS cart_to_purchase,
    c.total_purchase/NULLIF(c.total_view, 0)*100 AS view_to_purchase,
    c.total_view/NULLIF(t.total_views, 0)*100 AS percentage_of_total_views,
    r.potential_revenue,
    r.realized_revenue
FROM category_counts c
JOIN totals t
JOIN category_revenue r
  ON r.primary_category = c.primary_category
ORDER BY c.total_view DESC;