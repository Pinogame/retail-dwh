-- =========================================================
-- # MART LAYER: Pre-computed Aggregates
-- # Goal: Speed up BI Dashboards
-- =========================================================

-- 1. Create separate schema
CREATE SCHEMA IF NOT EXISTS mart;

-- 2. Create Materialized View for Monthly Sales
-- Materialized View = Table that stores query result physically
CREATE MATERIALIZED VIEW IF NOT EXISTS mart.monthly_sales_summary AS
SELECT 
    d.year,
    d.month,
    p.category,
    p.brand,
    SUM(f.total_amount) as total_revenue,
    COUNT(f.sales_id) as total_transactions
FROM fact_sales f
JOIN dim_dates d ON f.sales_date::DATE = d.full_date
JOIN dim_products p ON f.product_sk = p.product_sk
GROUP BY d.year, d.month, p.category, p.brand
ORDER BY d.year DESC, d.month DESC, total_revenue DESC;

-- 3. Create Index on Mart (Further Optimization)
CREATE INDEX idx_mart_year_month ON mart.monthly_sales_summary(year, month);

-- 4. Grant Access to BI Viewer
GRANT USAGE ON SCHEMA mart TO read_only_role;
GRANT SELECT ON ALL TABLES IN SCHEMA mart TO read_only_role;

-- 5. Refresh Data Command (Note for Documentation)
-- REFRESH MATERIALIZED VIEW mart.monthly_sales_summary;