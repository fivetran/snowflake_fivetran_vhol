{{ config(enabled=var('api_source') == 'google_ads') }}

with base as (

    select * 
    from {{ ref('stg_google_ads__account_history_tmp') }}

),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_google_ads__account_history_tmp')),
                staging_columns=get_account_history_columns()
            )
        }}
        
    from base
),

final as (
    
    select 
        id as account_id,
        updated_at,
        _fivetran_synced,
        currency_code, 
        descriptive_name as account_name
    from fields
),

most_recent as (

    select 
        *,
        row_number() over (partition by account_id order by updated_at desc) = 1 as is_most_recent_record
    from final

)

select * from most_recent
