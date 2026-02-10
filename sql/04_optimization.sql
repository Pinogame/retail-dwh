-- =========================================================
-- # OPTIMIZATION: CREATE INDEXES
-- # Index all FKs to speed up JOINs with Dimension Tables
-- =========================================================

CREATE INDEX idx_fact_date        ON fact_sales(sales_date);
CREATE INDEX idx_fact_customer    ON fact_sales(customer_sk);
CREATE INDEX idx_fact_product     ON fact_sales(product_sk);
CREATE INDEX idx_fact_store       ON fact_sales(store_sk);
CREATE INDEX idx_fact_salesperson ON fact_sales(salesperson_sk);
CREATE INDEX idx_fact_campaign    ON fact_sales(campaign_sk);

-- =========================================================
-- # UPDATE STATISTICS
-- # Update stats so Query Planner knows about the new indexes
-- =========================================================
ANALYZE fact_sales;

-- =========================================================
-- # PROOF OF PERFORMANCE
-- # Use EXPLAIN ANALYZE to show that the query uses the Index
-- =========================================================
EXPLAIN ANALYZE 
SELECT 
    p.category, 
    SUM(f.total_amount) as total_revenue
FROM fact_sales f
JOIN dim_products p ON f.product_sk = p.product_sk
GROUP BY p.category;