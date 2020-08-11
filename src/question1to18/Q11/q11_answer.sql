# Q11
# 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
# 我的版本（用了子查询，不太好）
select s.SId, s.Sname, t.avg_score
from Student as s
         inner join
     (select sc.SId, count(sc.CId), avg(sc.score) as avg_score
      from SC as sc
      where score < 60
      group by sc.SId) as t
     on s.SId = t.SId;
# 或 旧版本，直接双表联结+HAVING（GROUP BY在SQL中比HAVING早生效）
select s.SId, s.Sname, avg(sc.score) as avg_score
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId and sc.score < 60
group by sc.SId, s.Sname
having count(*) >= 2;
