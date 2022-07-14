{% macro get_account_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "auto_tagging_enabled", "datatype": "boolean"},
    {"name": "currency_code", "datatype": dbt_utils.type_string()},
    {"name": "descriptive_name", "datatype": dbt_utils.type_string()},
    {"name": "final_url_suffix", "datatype": dbt_utils.type_string()},
    {"name": "hidden", "datatype": "boolean"},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "manager", "datatype": "boolean"},
    {"name": "manager_customer_id", "datatype": dbt_utils.type_int()},
    {"name": "optimization_score", "datatype": dbt_utils.type_float()},
    {"name": "pay_per_conversion_eligibility_failure_reasons", "datatype": dbt_utils.type_string()},
    {"name": "test_account", "datatype": "boolean"},
    {"name": "time_zone", "datatype": dbt_utils.type_string()},
    {"name": "tracking_url_template", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
