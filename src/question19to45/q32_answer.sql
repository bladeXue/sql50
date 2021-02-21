# Q32
# 求每门课程的学生人数
# 未考虑sid重复问题
select sc.CId,
       count(sc.SId) as 'stu_count'
from SC as sc
group by sc.CId;

# +---+---------+
# |CId|stu_count|
# +---+---------+
# |01 |6        |
# |02 |6        |
# |03 |6        |
# +---+---------+

