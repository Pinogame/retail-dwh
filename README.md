# Retail Data Warehouse Project

## 📌 Overview

This project demonstrates an **End-to-End Data Engineering** solution for a Retail Data Warehouse. It covers the complete lifecycle of data engineering: from infrastructure setup, schema design, data ingestion, optimization, quality checks, to final visualization.

**Tech Stack:**

- **Database:** PostgreSQL 16 (optimized configuration)
- **Containerization:** Docker & Docker Compose
- **Data Quality:** Great Expectations (GX)
- **Visualization:** Apache Superset
- **Security:** Role-Based Access Control (RBAC)

---

## 🛠️ Development Workflow (How It Works)

This repository follows a strict development workflow as outlined below:

### Phase 1: Infrastructure Setup

1. **Project Structure**: Organized into `config/`, `sql/`, `data/`, and `great_expectations/`.
2. **Docker Environment**:
    - Configured `docker-compose.yml` to orchestrate Postgres, Great Expectations, and Superset.
    - Optimized `postgresql.conf` for performance (shared_buffers, work_mem).
    - Managed credentials securely using `.env` files (excluded from Git).

### Phase 2: Database Design (Star Schema)

1. **Schema Definition** (`sql/01_schema.sql`):
    - Designed a **Star Schema** with one Fact table (`fact_sales`) and multiple Dimension tables (`dim_products`, `dim_customers`, etc.).
    - Enforced data integrity with Primary Keys and Foreign Keys.

### Phase 3: Data Ingestion

1. **Data Loading** (`sql/02_load_data.sql`):
    - Ingested raw CSV data into PostgreSQL using the efficient `COPY` command.
    - Verified data integrity after loading (Row counts check).

### Phase 4: Performance Optimization

1. **Indexing** (`sql/04_optimization.sql`):
    - Created indexes on all Foreign Keys to speed up JOIN operations.
    - Ran `ANALYZE` to update database statistics.
    - Verified performance improvements using `EXPLAIN ANALYZE`.

### Phase 5: Data Quality Assurance

1. **Great Expectations Setup**:
    - Created a dedicated Docker environment for GX.
    - Developed `great_expectations/run_validation.py` to programmatically validate data.
    - **Rules Implemented**:
        - `sales_id` must not be null.
        - `total_amount` must be positive.
        - `sales_date` must be present.

### Phase 6: Security & Access Control

1. **RBAC Implementation** (`sql/05_rbac.sql`):
    - Created a `read_only_role` for reporting purposes.
    - Created a dedicated service user `bi_viewer` assigned to this role.
    - Ensured `bi_viewer` can only `SELECT` and cannot modify schema or data.

### Phase 7: Analytics Layer (Mart)

1. **Data Mart** (`sql/06_mart_layer.sql`):
    - Created a dedicated `mart` schema.
    - Built a **Materialized View** (`mart.monthly_sales_summary`) to pre-aggregate sales data.
    - Added indexes to the view for sub-second dashboard queries.

### Phase 8: Visualization

1. **Apache Superset**:
    - **Custom Docker Build**: Created `superset/Dockerfile` to install the missing `psycopg2-binary` PostgreSQL driver.
    - Connected Superset to Postgres using the `bi_viewer` credentials.
    - Built an interactive Dashboard visualizing Monthly Sales Trends.

---

## 🚀 How to Run This Project

### Prerequisites

- Docker & Docker Compose installed.
- Git installed.

### Steps

1. **Clone the Repository**

    ```bash
    git clone https://github.com/Pinogame/retail-dwh.git
    cd retail-dwh
    ```

2. **Setup Environment Variables**
    - Copy `.env.example` to `.env`.
    - Fill in the required credentials.

    ```bash
    cp .env.example .env
    ```

3. **Start Infrastructure**

    ```bash
    docker compose up -d --build
    ```

4. **Initialize Database (First Run Only)**
    Execute the SQL scripts in order:

    ```bash
    # Schema & Data
    docker compose exec postgres psql -U admin -d retail_dwh -f /docker-entrypoint-initdb.d/01_schema.sql
    docker compose exec postgres psql -U admin -d retail_dwh -f /docker-entrypoint-initdb.d/02_load_data.sql

    # Optimization & Security
    docker compose exec postgres psql -U admin -d retail_dwh -f /docker-entrypoint-initdb.d/04_optimization.sql
    docker compose exec postgres psql -U admin -d retail_dwh -f /docker-entrypoint-initdb.d/05_rbac.sql
    docker compose exec postgres psql -U admin -d retail_dwh -f /docker-entrypoint-initdb.d/06_mart_layer.sql
    ```

5. **Run Data Quality Checks**

    ```bash
    docker compose run --rm gx python /app/great_expectations/run_validation.py
    ```

6. **Setup Superset**

    ```bash
    # Create Admin User
    docker compose exec superset superset fab create-admin \
      --username admin \
      --firstname Superset \
      --lastname Admin \
      --email admin@test.com \
      --password admin

    # Initialize DB & Roles
    docker compose exec superset superset db upgrade
    docker compose exec superset superset init
    ```

7. **Access Dashboard**
    - Open browser at `http://localhost:8088`.
    - Login with `admin` / `admin`.

---

## 📂 Project Structure

```
├── config/                 # Postgres custom configuration
├── data/                   # Raw CSV Data (Git ignored)
├── great_expectations/     # Data Quality scripts & Dockerfile
├── sql/                    # SQL Scripts (Schema, Load, Opt, RBAC, Mart)
├── superset/               # Superset custom Dockerfile
├── docker-compose.yml      # Orchestration
├── .env.example            # Environment template
├── WORKFLOW.md             # Detailed development log
└── README.md               # Project documentation
```
