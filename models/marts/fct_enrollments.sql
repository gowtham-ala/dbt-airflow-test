-- Fact: enrollment events, grain = one row per student enrollment.
-- Materialized as INCREMENTAL (the third materialization kind).
-- On the first run it builds the full table; subsequent runs only
-- append students whose join_date is newer than what's already loaded.

{{
    config(
        materialized='incremental',
        unique_key='student_id',
        incremental_strategy='merge'
    )
}}

with students as (

    select * from {{ ref('stg_students') }}

),

enrollments as (

    select
        student_id,
        student_dept,
        admission_year,
        join_date,
        date_of_birth,

        -- days between birth and joining (age at admission, in days)
        datediff('day', date_of_birth, join_date)      as age_at_join_days,

        -- fiscal-ish enrollment month bucket
        date_trunc('month', join_date)                 as join_month

    from students

)

select * from enrollments

{% if is_incremental() %}
  -- only process rows newer than the max already in the table
  where join_date > (select coalesce(max(join_date), '1900-01-01') from {{ this }})
{% endif %}
