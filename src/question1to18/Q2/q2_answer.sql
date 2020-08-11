# Q2
# 查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
select s.SId, s.Sname, t.avg_score
from Student as s
         inner join (select SId, avg(score) as avg_score
                     from SC
                     group by SId
                     having avg_score >= 60) as t
                    on s.SId = t.SId;
