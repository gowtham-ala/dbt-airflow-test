-- Dimension: one row per student.
-- Materialized as a TABLE (inherited from marts config).

with students as (

    select * from {{ ref('stg_students') }}

)

select
    student_id,
    student_name,
    student_email,
    student_dept,
    date_of_birth,
    join_date,
    admission_year,
    email_domain,

    -- age in years as of today (derived attribute)
    datediff('year', date_of_birth, current_date())   as age_years,

    -- simple classification of the student cohort
    case
        when admission_year = 2022 then 'Senior'
        when admission_year = 2023 then 'Junior'
        when admission_year = 2024 then 'Fresher'
        else 'Unknown'
    end                                                as cohort_label

from students
