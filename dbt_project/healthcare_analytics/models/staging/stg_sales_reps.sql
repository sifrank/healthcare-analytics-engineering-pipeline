
with source as (

    select *
    from {{ source('raw', 'sales_reps') }}

),

cleaned as (

    select
        sales_rep_id,
        trim(sales_rep_name) as sales_rep_name,
        trim(region) as region,
        cast(hire_date as date) as hire_date

    from source

)

select *
from cleaned
