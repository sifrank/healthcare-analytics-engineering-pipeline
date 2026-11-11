
with source as (

    select *
    from {{ source('raw', 'transactions') }}

),

cleaned as (

    select
        transaction_id,
        customer_id,
        product_id,
        sales_rep_id,
        cast(transaction_date as date) as transaction_date,
        units_sold,
        cast(unit_price as numeric(12, 2)) as unit_price,
        cast(discount_pct as numeric(5, 4)) as discount_pct,
        cast(revenue as numeric(14, 2)) as revenue

    from source

)

select *
from cleaned
