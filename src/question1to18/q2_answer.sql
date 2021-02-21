# Q2
# 查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
# 聚合函数分组和HAVING条件过滤，获得sid，最后与学生表联结
select s.SId, s.Sname, t.avg_score
from Student as s
         inner join (select SId, avg(score) as avg_score
                     from SC
                     group by SId
                     having avg_score >= 60) as t
                    on s.SId = t.SId;

# +---+-----+---------+
# |SId|Sname|avg_score|
# +---+-----+---------+
# |01 |赵雷   |89.66667 |
# |02 |钱电   |70.00000 |
# |03 |孙风   |80.00000 |
# |05 |周梅   |81.50000 |
# |07 |郑竹   |93.50000 |
# +---+-----+---------+

