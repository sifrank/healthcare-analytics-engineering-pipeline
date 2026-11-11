
select
    customer_id,
    customer_name,
    region,
    account_segment,
    onboarding_date

from {{ ref('stg_customers') }}
