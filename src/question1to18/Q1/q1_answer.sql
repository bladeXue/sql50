# Q1
# 查询"01"课程比"02"课程成绩高的学生的信息及课程分数
# 左连接自交
select s.SId, s.Sname, s.Ssex, r.score_for_c01, r.score_for_c02
from Student as s
         right outer join
     (select t1.SId, score_for_c01, score_for_c02
      from (select SId, score as score_for_c01 from SC as sc where sc.CId = 01) as t1,
           (select SId, score as score_for_c02 from SC as sc where sc.CId = 02) as t2
      where t1.SId = t2.SId
        and t1.score_for_c01 > t2.score_for_c02) as r
     on s.SId = r.SId;
