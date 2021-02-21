# Q27
# 查询课程名称为“数学”，且分数低于60的学生姓名和分数
# 三表联合查询，注意dbms对join有优化
# 注意多重join的语法细节
select s.Sname,
       sc.score
from Student as s
         inner join
     SC as sc
         inner join
     Course as c
     on s.SId = sc.SId and
        sc.CId = c.CId and
        c.Cname = '数学'
where sc.score < 60;
# 或 另一种更好看的内联结写法
select s.Sname,
       sc.score
from Student as s
         inner join
     SC as sc on s.SId = sc.SId
         inner join
     Course as c on sc.CId = c.CId
where c.Cname = '数学'
  and sc.score < 60;

# +-----+-----+
# |Sname|score|
# +-----+-----+
# |李云   |30.0 |
# +-----+-----+

