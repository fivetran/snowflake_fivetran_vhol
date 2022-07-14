{% macro get_ad_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt_utils.type_timestamp()},
    {"name": "action_items", "datatype": dbt_utils.type_string()},
    {"name": "ad_group_id", "datatype": dbt_utils.type_int()},
    {"name": "ad_strength", "datatype": dbt_utils.type_string()},
    {"name": "added_by_google_ads", "datatype": "boolean"},
    {"name": "device_preference", "datatype": dbt_utils.type_string()},
    {"name": "display_url", "datatype": dbt_utils.type_string()},
    {"name": "final_app_urls", "datatype": dbt_utils.type_string()},
    {"name": "final_mobile_urls", "datatype": dbt_utils.type_string()},
    {"name": "final_url_suffix", "datatype": dbt_utils.type_string()},
    {"name": "final_urls", "datatype": dbt_utils.type_string()},
    {"name": "id", "datatype": dbt_utils.type_int()},
    {"name": "name", "datatype": dbt_utils.type_string()},
    {"name": "policy_summary_approval_status", "datatype": dbt_utils.type_string()},
    {"name": "policy_summary_review_status", "datatype": dbt_utils.type_string()},
    {"name": "status", "datatype": dbt_utils.type_string()},
    {"name": "system_managed_resource_source", "datatype": dbt_utils.type_string()},
    {"name": "tracking_url_template", "datatype": dbt_utils.type_string()},
    {"name": "type", "datatype": dbt_utils.type_string()},
    {"name": "updated_at", "datatype": dbt_utils.type_timestamp()},
    {"name": "url_collections", "datatype": dbt_utils.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
