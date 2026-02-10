import great_expectations as gx
from great_expectations.core.expectation_configuration import ExpectationConfiguration
import os

# 1. Connect to Great Expectations Context
context = gx.get_context()

# 2. Define Database Connection String (From .env)
db_user = os.environ.get("POSTGRES_USER", "admin")
db_pword = os.environ.get("POSTGRES_PASSWORD", "admin123")
db_host = "postgres"
db_port = "5432"
db_name = os.environ.get("POSTGRES_DB", "retail_dwh")

connection_string = f"postgresql+psycopg2://{db_user}:{db_pword}@{db_host}:{db_port}/{db_name}"

# 3. Add Datasource
datasource_name = "retail_dwh_postgres"
datasource_config = {
    "name": datasource_name,
    "class_name": "Datasource",
    "execution_engine": {
        "class_name": "SqlAlchemyExecutionEngine",
        "connection_string": connection_string,
    },
    "data_connectors": {
        "default_inferred_data_connector": {
            "class_name": "InferredAssetSqlDataConnector",
            "include_schema_name": True,
        },
    },
}
context.add_datasource(**datasource_config)

# 4. Create Expectation Suite
suite_name = "fact_sales_suite"
# Use add_or_update_expectation_suite for GX 0.18+
suite = context.add_or_update_expectation_suite(expectation_suite_name=suite_name)

# 5. Add Expectations (Rules)
# Rule 1: Sales ID Must Not Be Null
config_1 = ExpectationConfiguration(
    expectation_type="expect_column_values_to_not_be_null",
    kwargs={"column": "sales_id"}
)

# Rule 2: Matrix Total Amount Must Be >= 0
config_2 = ExpectationConfiguration(
    expectation_type="expect_column_values_to_be_between",
    kwargs={"column": "total_amount", "min_value": 0}
)

# Rule 3: Sales Date Must Be Not Null
config_3 = ExpectationConfiguration(
    expectation_type="expect_column_values_to_not_be_null",
    kwargs={"column": "sales_date"}
)

# Add all expectations to the suite
suite.add_expectation_configurations(expectation_configurations=[config_1, config_2, config_3])

# Save the suite
context.save_expectation_suite(expectation_suite=suite)

# 6. Run Checkpoint (Validation)
checkpoint_name = "fact_sales_checkpoint"
checkpoint_config = {
    "name": checkpoint_name,
    "config_version": 1,
    "class_name": "SimpleCheckpoint",
    "validations": [
        {
            "batch_request": {
                "datasource_name": datasource_name,
                "data_connector_name": "default_inferred_data_connector",
                "data_asset_name": "public.fact_sales",
            },
            "expectation_suite_name": suite_name,
        }
    ],
}
context.add_checkpoint(**checkpoint_config)

print(f"🚀 Running Validation for {suite_name}...")
results = context.run_checkpoint(checkpoint_name=checkpoint_name)

# 7. Print Result
if results.success:
    print("✅ GREAT SUCCESS! All data quality checks passed.")
else:
    print("❌ WARNING! Some checks failed.")
    print(results)