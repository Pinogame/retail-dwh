
-- =========================================================
-- # STAR SCHEMA DDL (Dimensions + Fact)
-- # Goal: create tables with proper PK/FK + reasonable data types
-- =========================================================

-- =========================================================
-- # DROP TABLES (fact first, then dimensions)
-- # CASCADE removes dependent constraints automatically
-- =========================================================
DROP TABLE IF EXISTS fact_sd CASCADE;
DROP TABLE IF EXISTS dim_stores CASCADE;
DROP TABLE IF EXISTS dim_salespersons CASCADE;
DROP TABLE IF EXISTS dim_products CASCADE;
DROP TABLE IF EXISTS dim_dates CASCADE;
DROP TABLE IF EXISTS dim_customers CASCADE;
DROP TABLE IF EXISTS dim_campaigns CASCADE;

-- =========================================================
-- # DIMENSION: DATE
-- # Stores calendar attributes (one row per date)
-- # PK uses surrogate key (date_sk)
-- =========================================================
CREATE TABLE dim_dates (
  full_date   DATE UNIQUE NOT NULL,    -- # Actual calendar date (YYYY-MM-DD)
  date_sk     INT PRIMARY KEY,         -- # Date surrogate key
  year        INT,                     -- # Year number
  month       INT,                     -- # Month number (1-12)
  day         INT,                     -- # Day of month (Num)
  weekday     INT,                     -- # Day of week (Num)
  quarter     INT                      -- # Quarter (1-4)
);

-- =========================================================
-- # DIMENSION: CAMPAIGN
-- # Stores marketing campaign attributes
-- # start/end date point to dim_dates
-- =========================================================
CREATE TABLE dim_campaigns (
  campaign_sk     INT PRIMARY KEY,                       -- # Campaign surrogate key
  campaign_id     VARCHAR(50) UNIQUE,                    -- # Source system campaign id
  campaign_name   VARCHAR(100),                          -- # Campaign name
  start_date_sk   INT REFERENCES dim_dates(date_sk),     -- # Campaign start date key
  end_date_sk     INT REFERENCES dim_dates(date_sk),     -- # Campaign end date key
  campaign_budget INT                                   -- # Campaign budget (integer)
);

-- =========================================================
-- # DIMENSION: CUSTOMER
-- # Stores customer master data attributes
-- =========================================================
CREATE TABLE dim_customers (
  customer_sk          INT PRIMARY KEY,      -- # Customer surrogate key
  customer_id          VARCHAR(50) UNIQUE,   -- # Source system customer id
  first_name           VARCHAR(100),         -- # First name
  last_name            VARCHAR(100),         -- # Last name
  email                TEXT,                 -- # Email address
  residential_location VARCHAR(100),         -- # Customer location
  customer_segment     VARCHAR(100)          -- # Segment label
);

-- =========================================================
-- # DIMENSION: PRODUCT
-- # Stores product attributes
-- =========================================================
CREATE TABLE dim_products (
  product_sk      INT PRIMARY KEY,      -- # Product surrogate key
  product_id      VARCHAR(50) UNIQUE,   -- # Source system product id
  product_name    VARCHAR(100),         -- # Product name
  category        VARCHAR(50),          -- # Product category
  brand           VARCHAR(50),          -- # Brand
  origin_location VARCHAR(100)          -- # Origin location
);

-- =========================================================
-- # DIMENSION: SALESPERSON
-- # Stores salesperson attributes
-- =========================================================
CREATE TABLE dim_salespersons (
  salesperson_sk   INT PRIMARY KEY,      -- # Salesperson surrogate key
  salesperson_id   VARCHAR(50) UNIQUE,   -- # Source system salesperson id
  salesperson_name VARCHAR(100),         -- # Salesperson name
  salesperson_role VARCHAR(100)          -- # Role/title
);

-- =========================================================
-- # DIMENSION: STORE
-- # Stores store attributes
-- # store_manager_sk references dim_salespersons
-- =========================================================
CREATE TABLE dim_stores (
  store_sk         INT PRIMARY KEY,                                -- # Store surrogate key
  store_id         VARCHAR(50) UNIQUE,                             -- # Source system store id
  store_name       VARCHAR(50),                                    -- # Store name
  store_type       VARCHAR(100),                                   -- # Store type
  store_location   VARCHAR(100),                                   -- # Store location
  store_manager_sk INT REFERENCES dim_salespersons(salesperson_sk) -- # Store manager key
);

-- =========================================================
-- # FACT: SALES (STAR FACT TABLE)
-- # Stores transactional measures + foreign keys to dimensions
-- =========================================================
CREATE TABLE IF NOT EXISTS fact_sales (
    sales_sk        INTEGER PRIMARY KEY,
    sales_id        VARCHAR(50) NOT NULL,
    customer_sk     INTEGER REFERENCES dim_customers(customer_sk),
    product_sk      INTEGER REFERENCES dim_products(product_sk),
    store_sk        INTEGER REFERENCES dim_stores(store_sk),
    salesperson_sk  INTEGER REFERENCES dim_salespersons(salesperson_sk),
    campaign_sk     INTEGER REFERENCES dim_campaigns(campaign_sk),
    sales_date      TIMESTAMP,
    total_amount    NUMERIC(12,2)
);