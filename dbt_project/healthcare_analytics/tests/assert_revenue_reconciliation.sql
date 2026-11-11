
with fact_revenue as (

    select sum(revenue) as total_revenue
    from {{ ref('fact_revenue') }}

),

intermediate_revenue as (

    select sum(revenue) as total_revenue
    from {{ ref('int_transactions_enriched') }}

)

select
    f.total_revenue as fact_revenue,
    i.total_revenue as intermediate_revenue

from fact_revenue f
cross join intermediate_revenue i

where abs(f.total_revenue - i.total_revenue) > 0.01
