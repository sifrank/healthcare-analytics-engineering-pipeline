
with source as (

    select *
    from {{ source('raw', 'products') }}

),

cleaned as (

    select
        product_id,
        trim(product_name) as product_name,
        trim(category) as product_category,
        cast(unit_price as numeric(12, 2)) as unit_price

    from source

)

select *
from cleaned
