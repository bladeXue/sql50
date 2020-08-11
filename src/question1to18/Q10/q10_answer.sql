# Q10
# 查询没学过 张三 老师讲授的任一门课程的学生姓名
# 其实就是学过张三老师的学生的取反
# 三层子嵌套或者多表联合查询，都可以。这里给出多表
select s.*
from Student as s
where s.SId not in
      (select sc.SId
       from SC as sc,
            Course as c,
            Teacher as t
       where sc.CId = c.CId
         and c.TId = t.TId
         and t.Tname = '张三');
