{% macro get_campaign_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "ad_serving_optimization_status", "datatype": dbt_utils.type_string()},
    {"name": "advertising_channel_subtype", "datatype": dbt_utils.type_string()},
    {"name": "advertising_channel_type", "datatype": dbt_utils.type_string()},
    {"name": "base_campaign_id", "datatype": dbt_utils.type_int()},
    {"name": "customer_id", "datatype": dbt_utils.type_int()},
    {"name": "end_date", "datatype": dbt_utils.type_string()},
    {"name": "experiment_type", "datatype": dbt_utils.type_string()},
    {"name": "final_url_suffix", "datatype": dbt_utils.type_string()},
    {"name": "frequency_caps", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "optimization_score", "datatype": dbt_utils.type_float()},
    {"name": "payment_mode", "datatype": dbt_utils.type_string()},
    {"name": "serving_status", "datatype": dbt_utils.type_string()},
    {"name": "start_date", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "tracking_url_template", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "vanity_pharma_display_url_mode", "datatype": dbt_utils.type_string()},
    {"name": "vanity_pharma_text", "datatype": dbt_utils.type_string()},
    {"name": "video_brand_safety_suitability", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}