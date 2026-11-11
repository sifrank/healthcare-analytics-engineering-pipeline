
with targets as (

    select *
    from {{ ref('stg_revenue_targets') }}

),

final as (

    select
        -- Target grain: one row per month and region
        d.date_key,
        r.region_key,

        t.target_month,
        t.region,

        -- Measures
        t.revenue_target

    from targets t

    left join {{ ref('dim_date') }} d
        on t.target_month = d.full_date

    left join {{ ref('dim_region') }} r
        on t.region = r.region

)

select *
from final
