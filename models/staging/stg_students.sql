-- Staging model for scrs_users.
-- Materialized as a VIEW (inherited from dbt_project.yml staging config).
-- Responsibilities: rename/clean, cast DD-MM-YYYY strings to DATE,
-- derive admission year from the student_id prefix.

with source as (

    select * from {{ source('scrs', 'scrs_users') }}

),

renamed as (

    select
        student_id,
        lower(trim(student_mail))                      as student_email,
        initcap(trim(student_name))                    as student_name,
        upper(trim(student_dept))                      as student_dept,

        -- raw DD-MM-YYYY strings -> proper DATE
        try_to_date(student_dob, 'DD-MM-YYYY')         as date_of_birth,
        try_to_date(student_jd,  'DD-MM-YYYY')         as join_date,

        -- admission year encoded in the first two chars of the id
        ('20' || substr(student_id, 1, 2))::int        as admission_year,

        -- email domain for validation / grouping
        split_part(student_mail, '@', 2)               as email_domain

    from source

)

select * from renamed
