
select
    customer_id,
    customer_name,
    customer_region as region,
    account_segment,

    date_trunc('month', transaction_date)::date as month_start,

    sum(revenue) as monthly_revenue,
    count(distinct transaction_id) as transaction_count,
    sum(units_sold) as units_purchased,
    count(distinct product_id) as distinct_products_purchased,
    max(transaction_date) as last_transaction_date

from {{ ref('int_transactions_enriched') }}

group by
    customer_id,
    customer_name,
    customer_region,
    account_segment,
    date_trunc('month', transaction_date)::date
