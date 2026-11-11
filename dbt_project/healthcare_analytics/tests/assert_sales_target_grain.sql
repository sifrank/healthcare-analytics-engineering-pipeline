
select
    region_key,
    target_month,
    count(*) as record_count

from {{ ref('fact_sales_targets') }}

group by
    region_key,
    target_month

having count(*) > 1
