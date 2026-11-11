
select
    customer_id,
    month_start,
    count(*) as record_count

from {{ ref('fact_customer_activity') }}

group by
    customer_id,
    month_start

having count(*) > 1
