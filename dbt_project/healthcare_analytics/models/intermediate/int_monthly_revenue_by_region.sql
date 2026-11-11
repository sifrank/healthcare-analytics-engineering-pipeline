
with transactions as (

    select *
    from {{ ref('int_transactions_enriched') }}

),

monthly_revenue as (

    select
        date_trunc('month', transaction_date)::date as month_start,
        customer_region as region,
        sum(revenue) as actual_revenue,
        count(distinct transaction_id) as transaction_count,
        count(distinct customer_id) as active_customers

    from transactions

    group by 1, 2

),

targets as (

    select
        target_month as month_start,
        region,
        revenue_target

    from {{ ref('stg_revenue_targets') }}

),

combined as (

    select
        coalesce(r.month_start, t.month_start) as month_start,
        coalesce(r.region, t.region) as region,
        coalesce(r.actual_revenue, 0) as actual_revenue,
        coalesce(t.revenue_target, 0) as revenue_target,
        coalesce(r.transaction_count, 0) as transaction_count,
        coalesce(r.active_customers, 0) as active_customers

    from monthly_revenue r

    full outer join targets t
        on r.month_start = t.month_start
        and r.region = t.region

)

select
    month_start,
    region,
    actual_revenue,
    revenue_target,
    actual_revenue - revenue_target as revenue_variance,

    round(
        actual_revenue / nullif(revenue_target, 0) * 100,
        2
    ) as target_attainment_pct,

    transaction_count,
    active_customers

from combined
