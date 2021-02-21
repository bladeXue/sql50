# Q1
# 查询"01"课程比"02"课程成绩高的学生的信息及课程分数
# 左连接自交
select *
from Student as s
         right join
     (
         select t1.SId, score_for_c01, score_for_c02
         from (select SId, score as score_for_c01 from SC as sc where sc.CId = 01) as t1,
              (select SId, score as score_for_c02 from SC as sc where sc.CId = 02) as t2
         where t1.SId = t2.SId
           and t1.score_for_c01 > t2.score_for_c02
     ) as r
     on s.SId = r.SId;

# +---+-----+-------------------+----+---+-------------+-------------+
# |SId|Sname|Sage               |Ssex|SId|score_for_c01|score_for_c02|
# +---+-----+-------------------+----+---+-------------+-------------+
# |02 |钱电   |1990-12-21 00:00:00|男   |02 |70.0         |60.0         |
# |04 |李云   |1990-12-06 00:00:00|男   |04 |50.0         |30.0         |
# +---+-----+-------------------+----+---+-------------+-------------+

