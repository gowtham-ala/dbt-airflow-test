{#
  Custom GENERIC test: valid_student_id
  Enforces the full student_id spec:
    - exactly 10 characters
    - all numeric (digits only)
    - admission-year prefix is one of 22 / 23 / 24
  Returns the FAILING rows (0 rows = pass).
#}
{% test valid_student_id(model, column_name) %}

select
    {{ column_name }} as student_id
from {{ model }}
where
    length({{ column_name }}) <> 10
    or not regexp_like({{ column_name }}, '^[0-9]{10}$')
    or substr({{ column_name }}, 1, 2) not in ('22', '23', '24')

{% endtest %}
