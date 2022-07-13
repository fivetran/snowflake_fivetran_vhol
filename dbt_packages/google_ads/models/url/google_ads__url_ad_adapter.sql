with base as (

    select *
    from {{ var('final_url_performance') }}

), fields as (

    select
        date_day,
        account_name,
        external_customer_id,
        campaign_name,
        campaign_id,
        ad_group_name,
        ad_group_id,
        base_url,
        url_host,
        url_path,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        sum(spend) as spend,
        sum(clicks) as clicks,
        sum(impressions) as impressions
    from base
    {{ dbt_utils.group_by(15) }}

)

select *
from fields