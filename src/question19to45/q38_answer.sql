# Q38
# 检索至少选修两门课程的学生学号
select SId
from SC
group by SId
having count(CId) >= 2;

# +---+
# |SId|
# +---+
# |01 |
# |02 |
# |03 |
# |04 |
# |05 |
# |06 |
# |07 |
# +---+

