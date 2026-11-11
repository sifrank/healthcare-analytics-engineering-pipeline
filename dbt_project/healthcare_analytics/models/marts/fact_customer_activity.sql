
with customer_activity as (

    select *
    from {{ ref('int_customer_monthly_activity') }}

),

final as (

    select
        -- Dimensional keys
        a.customer_id,
        d.date_key,
        r.region_key,

        -- Reporting attributes
        a.month_start,
        a.region,
        a.account_segment,

        -- Customer activity measures
        a.monthly_revenue,
        a.transaction_count,
        a.units_purchased,
        a.distinct_products_purchased,

        -- Customer activity date
        a.last_transaction_date

    from customer_activity a

    left join {{ ref('dim_date') }} d
        on a.month_start = d.full_date

    left join {{ ref('dim_region') }} r
        on a.region = r.region

)

select *
from final
