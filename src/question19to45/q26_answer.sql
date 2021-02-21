# Q26
# 查询平均成绩大于等于85的所有学生的学号，姓名和平均成绩
# 使用having截取结果表（注意这里的措辞，HAVING的作用时间很晚）
select s.SId,
       s.Sname,
       avg(sc.score) as avg_score
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId
group by s.SId,
         s.Sname
having avg_score >= 85;

# +---+-----+---------+
# |SId|Sname|avg_score|
# +---+-----+---------+
# |01 |赵雷   |89.66667 |
# |07 |郑竹   |93.50000 |
# +---+-----+---------+

