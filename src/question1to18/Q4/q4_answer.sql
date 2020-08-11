# Q4
# 查询所有同学的学生编号，学生姓名，选课总数，所有课程的成绩总和
# 联合查询不会显示没选课的学生
# 关于别名的问题，最好随时加别名，DBMS有优化
select s.SId, s.Sname, t.count_course, t.sum_score
from Student as s
         inner join (select SId, count(CId) as count_course, sum(score) as sum_score
                     from SC
                     group by SId) as t
                    on s.SId = t.SId;

