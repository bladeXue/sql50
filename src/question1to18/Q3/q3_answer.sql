# Q3
# 查询在SC表存在成绩的学生信息
# 以下分别是子查询和联结，虽然子查询看上去比较简单，但是大部分其实DBMS对联结有查询优化
select *
from Student as s
where s.SId in (select distinct SId from SC);
# 或
select DISTINCT s.*
from Student s,
     SC sc
where s.SId = sc.SId;
