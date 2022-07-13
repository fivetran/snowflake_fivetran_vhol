with base as (

    select *
    from {{ var('criteria_performance') }}

), fields as (

    select
        date_day,
        account_name,
        external_customer_id,
        campaign_name,
        campaign_id,
        ad_group_name,
        ad_group_id,
        criteria, 
        criteria_type,
        sum(spend) as spend,
        sum(clicks) as clicks,
        sum(impressions) as impressions
    from base
    {{ dbt_utils.group_by(9) }}

)

select *
from fields