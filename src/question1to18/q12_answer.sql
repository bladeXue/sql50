# Q12
# 检索"01"课程分数小于60，按分数降序排列的学生信息
# 使用order by
select s.*, sc.score
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId
         and sc.CId = 01
         and sc.score < 60
order by sc.score desc;

# +---+-----+-------------------+----+-----+
# |SId|Sname|Sage               |Ssex|score|
# +---+-----+-------------------+----+-----+
# |04 |李云   |1990-12-06 00:00:00|男   |50.0 |
# |06 |吴兰   |1992-01-01 00:00:00|女   |31.0 |
# +---+-----+-------------------+----+-----+

