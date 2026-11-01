-- Custom SINGULAR test: assert_email_domain_is_kluniversity
-- Business rule: every student email must be on the kluniversity.in domain.
-- A singular test is just a SELECT that returns the offending rows.
-- 0 rows returned = test passes.

select
    student_id,
    student_email,
    email_domain
from {{ ref('stg_students') }}
where email_domain <> 'kluniversity.in'
   or student_email not like '%@kluniversity.in'
