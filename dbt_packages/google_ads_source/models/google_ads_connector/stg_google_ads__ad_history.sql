{{ config(enabled=var('api_source') == 'google_ads') }}

with base as (

    select * 
    from {{ ref('stg_google_ads__ad_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_google_ads__ad_history_tmp')),
                staging_columns=get_ad_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        ad_group_id, 
        id as ad_id, 
        updated_at as updated_timestamp, 
        _fivetran_synced, 
        type as ad_type,
        status as ad_status,
        final_urls as source_final_urls,
        replace(replace(final_urls, '[', ''),']','') as final_urls
    from fields
),

most_recent as (

    select 
        ad_group_id,
        ad_id,
        updated_timestamp,
        _fivetran_synced,
        ad_type,
        ad_status,
        source_final_urls,

        --Extract the first url within the list of urls provided within the final_urls field
        {{ dbt_utils.split_part(string_text='final_urls', delimiter_text="','", part_number=1) }} as final_url,

        row_number() over (partition by ad_id order by updated_timestamp desc) = 1 as is_most_recent_record
    from final

),

url_fields as (
    select 
        *,
        {{ dbt_utils.split_part('final_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('final_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('final_url') }} as url_path,
        {{ dbt_utils.get_url_parameter('final_url', 'utm_source') }} as utm_source,
        {{ dbt_utils.get_url_parameter('final_url', 'utm_medium') }} as utm_medium,
        {{ dbt_utils.get_url_parameter('final_url', 'utm_campaign') }} as utm_campaign,
        {{ dbt_utils.get_url_parameter('final_url', 'utm_content') }} as utm_content,
        {{ dbt_utils.get_url_parameter('final_url', 'utm_term') }} as utm_term
    from most_recent
)

select * 
from url_fields
