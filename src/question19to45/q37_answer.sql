# Q37
# 统计每门课程的学生选修人数（超过5人的课程才统计）
# 聚合函数的基本考察
select CId,
       count(SId) as 'count_stu'
from SC
group by CId
having count_stu > 5;

# +---+---------+
# |CId|count_stu|
# +---+---------+
# |01 |6        |
# |02 |6        |
# |03 |6        |
# +---+---------+

