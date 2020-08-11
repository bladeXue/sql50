# Q12
# 检索"01"课程分数小于60，按分数降序排列的学生信息
select s.*, sc.score
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId
         and sc.score < 60
         and sc.CId = 01
order by sc.score desc;
