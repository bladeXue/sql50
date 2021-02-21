# Q19
# 查询每门课程被选修的学生数
# 很基本操作，group即可
# 之前Q1-Q18是简单到难，Q19开始循环知识点和难度
select sc.CId,
       count(sc.SId) as 'sum_stu'
from SC as sc
group by sc.CId;

# +---+-------+
# |CId|sum_stu|
# +---+-------+
# |01 |6      |
# |02 |6      |
# |03 |6      |
# +---+-------+

