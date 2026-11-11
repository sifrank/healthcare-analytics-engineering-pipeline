
with transactions as (

    select *
    from {{ ref('stg_transactions') }}

),

customers as (

    select *
    from {{ ref('stg_customers') }}

),

products as (

    select *
    from {{ ref('stg_products') }}

),

sales_reps as (

    select *
    from {{ ref('stg_sales_reps') }}

),

enriched as (

    select
        -- Transaction details
        t.transaction_id,
        t.transaction_date,
        t.customer_id,
        t.product_id,
        t.sales_rep_id,
        t.units_sold,
        t.unit_price,
        t.discount_pct,
        t.revenue,

        -- Customer details
        c.customer_name,
        c.region as customer_region,
        c.account_segment,
        c.onboarding_date,

        -- Product details
        p.product_name,
        p.product_category,

        -- Sales representative details
        s.sales_rep_name,
        s.region as sales_rep_region,
        s.hire_date

    from transactions t

    left join customers c
        on t.customer_id = c.customer_id

    left join products p
        on t.product_id = p.product_id

    left join sales_reps s
        on t.sales_rep_id = s.sales_rep_id

)

select *
from enriched
