
with source as (

    select *
    from {{ source('raw', 'revenue_targets') }}

),

cleaned as (

    select
        cast(target_month as date) as target_month,
        trim(region) as region,
        cast(revenue_target as numeric(14, 2)) as revenue_target

    from source

)

select *
from cleaned
