
with date_spine as (

    select
        generate_series(
            '2024-01-01'::date,
            '2025-12-31'::date,
            interval '1 day'
        )::date as date_day

)

select
    to_char(date_day, 'YYYYMMDD')::integer as date_key,
    date_day as full_date,

    extract(year from date_day)::integer as year,
    extract(quarter from date_day)::integer as quarter,
    extract(month from date_day)::integer as month,
    to_char(date_day, 'Month') as month_name,
    to_char(date_day, 'Mon') as month_short,
    extract(day from date_day)::integer as day_of_month,

    extract(isodow from date_day)::integer as day_of_week,
    to_char(date_day, 'Day') as day_name,

    date_trunc('month', date_day)::date as month_start,

    case
        when extract(isodow from date_day) in (6, 7)
        then true
        else false
    end as is_weekend

from date_spine
