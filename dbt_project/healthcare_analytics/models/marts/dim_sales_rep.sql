
select
    sales_rep_id,
    sales_rep_name,
    region,
    hire_date

from {{ ref('stg_sales_reps') }}
