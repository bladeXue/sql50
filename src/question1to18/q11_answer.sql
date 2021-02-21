# Q11
# 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
# 先查出对应的不及格成绩后，再和信息表联结
select s.SId, s.Sname, t.avg_score
from Student as s
         inner join
     (
         select sc.SId, count(sc.CId), avg(sc.score) as avg_score
         from SC as sc
         where score < 60
         group by sc.SId
     ) as t
     on s.SId = t.SId;
# 或 旧版本，直接双表联结，获得学生信息和成绩的混合表，之后再用HAVING（GROUP BY在SQL中比HAVING早生效）过滤
select s.SId, s.Sname, avg(sc.score) as avg_score
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId and sc.score < 60
group by sc.SId, s.Sname
having count(*) >= 2;

# +---+-----+---------+
# |SId|Sname|avg_score|
# +---+-----+---------+
# |04 |李云   |33.33333 |
# |06 |吴兰   |32.50000 |
# +---+-----+---------+

