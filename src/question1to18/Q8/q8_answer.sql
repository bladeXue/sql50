# Q8
# 查询至少有一门课与学号为"01"的同学所学相同的同学的信息
select s.*
from Student as s
where s.SId in
      (
          # 获取同学课的学生的id
          select sc.SId
          from SC as sc
          where sc.CId in (
              # 先把01同学学的课查出来
              select sc.CId
              from SC as sc
              where sc.SId = 01)
      );
