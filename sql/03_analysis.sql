# Data validation
SELECT 'dim_campaigns' as table_name, COUNT(*) as row_count 
FROM dim_campaigns
UNION ALL
SELECT 'dim_customers', COUNT(*) 
FROM dim_customers
UNION ALL
SELECT 'dim_products', COUNT(*) 
FROM dim_products
UNION ALL
SELECT 'dim_stores', COUNT(*) 
FROM dim_stores
UNION ALL
SELECT 'dim_salespersons', COUNT(*) 
FROM dim_salespersons
UNION ALL
SELECT 'dim_dates', COUNT(*) 
FROM dim_dates
UNION ALL
SELECT 'fact_sales', COUNT(*) 
FROM fact_sales;

# Data Analyze
-- Analyze : total sales per product category
SELECT 
    p.category, 
    SUM(f.total_amount) as total_revenue
FROM fact_sales as f
JOIN dim_products as p ON f.product_sk = p.product_sk
GROUP BY p.category
ORDER BY total_revenue DESC;

