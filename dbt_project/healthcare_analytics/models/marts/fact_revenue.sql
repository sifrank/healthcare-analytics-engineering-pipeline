
with transactions as (

    select *
    from {{ ref('int_transactions_enriched') }}

),

final as (

    select
        -- Transaction identifier
        t.transaction_id,

        -- Dimension keys
        t.customer_id,
        t.product_id,
        t.sales_rep_id,
        d.date_key,
        r.region_key,

        -- Transaction details
        t.transaction_date,
        t.units_sold,
        t.unit_price,
        t.discount_pct,

        -- Revenue measures
        t.revenue,
        t.units_sold * t.unit_price as gross_revenue,
        (t.units_sold * t.unit_price) - t.revenue
            as discount_amount

    from transactions t

    left join {{ ref('dim_date') }} d
        on t.transaction_date = d.full_date

    left join {{ ref('dim_region') }} r
        on t.customer_region = r.region

)

select *
from final
