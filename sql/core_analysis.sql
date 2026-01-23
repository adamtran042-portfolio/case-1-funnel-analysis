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
);

WITH base_events AS (
    SELECT
        e.user_id,
        CASE
            WHEN e.category_code IS NULL OR TRIM(SUBSTRING_INDEX(e.category_code, '.', 1)) = ''
                THEN 'Unclassified'
            ELSE SUBSTRING_INDEX(e.category_code, '.', 1)
        END AS primary_category,
        e.event_type
    FROM events e
),
funnel_table AS (
    -- user-level funnel flags per category
    SELECT
        user_id,
        primary_category,
        MAX(event_type = 'view')     AS views,
        MAX(event_type = 'cart')     AS carts,
        MAX(event_type = 'purchase') AS purchases
    FROM base_events
    GROUP BY user_id, primary_category
),
totals AS (
    SELECT SUM(views) AS total_views
    FROM funnel_table
)
SELECT
    f.primary_category,
    SUM(f.views)     AS total_view,
    SUM(f.carts)     AS total_cart,
    SUM(f.purchases) AS total_purchase,

    -- Conversion rates (safe divide)
    SUM(f.carts)     / NULLIF(SUM(f.views), 0)     * 100 AS view_to_cart,
    SUM(f.purchases) / NULLIF(SUM(f.carts), 0)     * 100 AS cart_to_purchase,
    SUM(f.purchases) / NULLIF(SUM(f.views), 0)     * 100 AS view_to_purchase,

    -- Share of attention
    SUM(f.views) / NULLIF(t.total_views, 0) * 100 AS percentage_of_total_views
FROM funnel_table f
CROSS JOIN totals t
GROUP BY f.primary_category, t.total_views
ORDER BY total_view DESC;
