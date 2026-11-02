-- Custom SINGULAR test: assert_dates_parse_cleanly
-- The source stores dob/jd as DD-MM-YYYY strings. TRY_TO_DATE returns NULL
-- on anything malformed. This test flags any row where a non-empty raw
-- date string FAILED to parse (i.e. parsed value is null but raw was present).
-- 0 rows = pass.

with src as (
    select * from {{ source('scrs', 'scrs_users') }}
)

select
    student_id,
    student_dob,
    student_jd
from src
where
    (student_dob is not null and try_to_date(student_dob, 'DD-MM-YYYY') is null)
    or
    (student_jd  is not null and try_to_date(student_jd,  'DD-MM-YYYY') is null)
