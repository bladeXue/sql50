# Q31
# 查询课程编号为01且课程成绩在80分及以上的学生的学号和姓名
select s.SId,
       s.Sname
from Student as s
         inner join
     SC as sc on s.SId = sc.SId
where sc.CId = 01
  and sc.score >= 80;
# 或
select s.SId,
       s.Sname
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId
         and sc.CId = 01
         and sc.score >= 80;

# +---+-----+
# |SId|Sname|
# +---+-----+
# |01 |赵雷   |
# |03 |孙风   |
# +---+-----+

