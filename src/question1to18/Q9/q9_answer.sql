# Q9
# 查询和"01"号的同学学习的课程完全相同的其他同学的信息
# 原创，分别查出01自己的匹配课程数和其它同学的匹配数目，然后多表联结，性能应该还可以优化
select s.*
from (
         select sc1.sid, count(sc1.CId) as courses
         from SC as sc1,
              SC as sc2
         where sc2.SId = @target_student_id
           and sc1.SId = sc2.SId
           and sc1.CId = sc2.CId
         group by sc1.SId
     ) as t1,
     (
         select sc1.sid, count(sc1.CId) as courses
         from SC as sc1,
              SC as sc2
         where sc2.SId = @target_student_id
           and sc1.SId <> sc2.SId
           and sc1.CId = sc2.CId
         group by sc1.SId
     ) as t2,
     Student as s,
     (select @target_student_id = 01) as tid
where t1.courses = t2.courses
  and t2.SId = s.SId;
# 我的原版（不带变量）
select s.*
from (
         select sc1.sid, count(sc1.CId) as courses
         from SC as sc1,
              SC as sc2
         where sc2.SId = 01
           and sc1.SId = sc2.SId
           and sc1.CId = sc2.CId
         group by sc1.SId
     ) as t1,
     (
         select sc1.sid, count(sc1.CId) as courses
         from SC as sc1,
              SC as sc2
         where sc2.SId = 01
           and sc1.SId <> sc2.SId
           and sc1.CId = sc2.CId
         group by sc1.SId
     ) as t2,
     Student as s
where t1.courses = t2.courses
  and t2.SId = s.SId;
