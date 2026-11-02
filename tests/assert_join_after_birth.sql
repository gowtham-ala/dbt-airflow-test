-- Custom SINGULAR test: assert_join_after_birth
-- Logical integrity: a student cannot join before they were born.
-- Operates on the cleaned staging model (dates already cast to DATE).
-- 0 rows = pass.

select
    student_id,
    date_of_birth,
    join_date
from {{ ref('stg_students') }}
where join_date <= date_of_birth
