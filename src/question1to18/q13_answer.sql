# Q13
# 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
# 实现似乎有些问题，个人觉得没有成绩的学生也要算
select *
from SC as sc
         left outer join
     (
         select sc.SId, avg(sc.score) as avg_score
         from SC sc
         group by sc.SId
     ) as r
     on sc.SId = r.SId
order by avg_score desc;