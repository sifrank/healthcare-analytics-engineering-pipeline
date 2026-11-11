
with regions as (

    select region
    from {{ ref('stg_customers') }}

    union

    select region
    from {{ ref('stg_sales_reps') }}

    union

    select region
    from {{ ref('stg_revenue_targets') }}

)

select
    row_number() over (order by region) as region_key,
    region

from regions
where region is not null
