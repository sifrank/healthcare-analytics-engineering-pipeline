
with source as (

    select *
    from {{ source('raw', 'customers') }}

),

cleaned as (

    select
        customer_id,
        trim(customer_name) as customer_name,
        trim(region) as region,
        trim(account_segment) as account_segment,
        cast(onboarding_date as date) as onboarding_date

    from source

)

select *
from cleaned
