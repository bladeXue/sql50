# Q25
# 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select c.CId,
       c.Cname,
       avg(sc.score) as avg_score
from Course as c
         inner join
     SC as sc
     on c.CId = sc.CId
group by c.CId,
         c.Cname
order by avg_score desc,
         c.CId;

# +---+-----+---------+
# |CId|Cname|avg_score|
# +---+-----+---------+
# |02 |数学   |72.66667 |
# |03 |英语   |68.50000 |
# |01 |语文   |64.50000 |
# +---+-----+---------+

