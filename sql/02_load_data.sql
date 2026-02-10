-- =========================================================
-- # DATA LOADING USING COPY
-- # Assumption:
-- # - CSV column order matches table column order exactly
-- # - DIM tables loaded first, FACT loaded last
-- =========================================================

-- =========================================================
-- # DIM: DATES
-- =========================================================
COPY dim_dates
FROM '/data/dim_dates.csv'
WITH (FORMAT csv, HEADER true);

-- =========================================================
-- # DIM: CAMPAIGNS
-- =========================================================
COPY dim_campaigns
FROM '/data/dim_campaigns.csv'
WITH (FORMAT csv, HEADER true);

-- =========================================================
-- # DIM: CUSTOMERS
-- =========================================================
COPY dim_customers
FROM '/data/dim_customers.csv'
WITH (FORMAT csv, HEADER true);

-- =========================================================
-- # DIM: PRODUCTS
-- =========================================================
COPY dim_products
FROM '/data/dim_products.csv'
WITH (FORMAT csv, HEADER true);

-- =========================================================
-- # DIM: SALESPERSONS
-- =========================================================
COPY dim_salespersons
FROM '/data/dim_salespersons.csv'
WITH (FORMAT csv, HEADER true);

-- =========================================================
-- # DIM: STORES
-- =========================================================
COPY dim_stores
FROM '/data/dim_stores.csv'
WITH (FORMAT csv, HEADER true);

-- =========================================================
-- # FACT: SALES
-- =========================================================
COPY fact_sales
FROM '/data/fact_sales_normalized.csv'
WITH (FORMAT csv, HEADER true);
