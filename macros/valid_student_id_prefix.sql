{#
  Custom GENERIC test: valid_student_id_prefix
  Fails for any row whose id is not exactly 10 chars or whose
  2-char prefix is not one of 22 / 23 / 24.
  A generic test returns the FAILING rows (0 rows = pass).
#}
{% test valid_student_id_prefix(model, column_name) %}

select
    {{ column_name }} as student_id
from {{ model }}
where
    length({{ column_name }}) <> 10
    or substr({{ column_name }}, 1, 2) not in ('22', '23', '24')

{% endtest %}
