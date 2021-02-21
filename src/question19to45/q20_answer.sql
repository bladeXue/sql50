# Q20
# 查询出只选修两门课程的学生学号和姓名
# 简单，直接join即可
# 善用having可以少写很多条件，但是要当心，having是发生在拼表结束后的
select s.SId,
       s.Sname
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId
group by sc.SId,
         s.Sname
having count(sc.CId) = 2;

# +---+-----+
# |SId|Sname|
# +---+-----+
# |05 |周梅   |
# |06 |吴兰   |
# |07 |郑竹   |
# +---+-----+

