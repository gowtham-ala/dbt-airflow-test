-- Custom SINGULAR test: assert_join_year_matches_prefix
-- Guaranteed invariant (confirmed by data owner): the admission-year prefix
-- in student_id must equal the YEAR of the join_date.
--   22xxxxxxxx -> joined 2022
--   23xxxxxxxx -> joined 2023
--   24xxxxxxxx -> joined 2024
-- 0 rows = pass.

select
    student_id,
    admission_year,
    join_date,
    year(join_date) as join_year
from {{ ref('stg_students') }}
where admission_year <> year(join_date)
