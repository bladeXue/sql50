# Q39
# 查询选修了全部课程的学生信息
# 这里用了一次简单的子查询
select s.SId,
       s.Sname,
       s.Sage,
       s.Ssex
from Student as s
         inner join
     SC as sc on s.SId = sc.SId
group by s.SId,
         s.Sname,
         s.Sage,
         s.Ssex
having count(sc.CId) = (
    select count(*)
    from Course
);

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |
# |02 |钱电   |1990-12-21 00:00:00|男   |
# |03 |孙风   |1990-12-20 00:00:00|男   |
# |04 |李云   |1990-12-06 00:00:00|男   |
# +---+-----+-------------------+----+

