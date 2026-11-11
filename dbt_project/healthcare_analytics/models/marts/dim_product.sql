
select
    product_id,
    product_name,
    product_category,
    unit_price

from {{ ref('stg_products') }}
