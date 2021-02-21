# Q33
# 成绩不重复，查询选修“张三”老师所授课程的学生中，成绩最高的学生信息及其成绩
# 4表联合查询
# 方案1：having max()，方案2：排序后limit 1，方案3：子查询
# 推荐方案2
select *
from Student as s,
     SC as sc,
     Course as c,
     Teacher as t
where t.TId = c.TId
  and t.Tname = '张三'
  and sc.CId = c.CId
  and sc.SId = s.SId
order by sc.score desc
limit 1;

# +---+-----+-------------------+----+---+---+-----+---+-----+---+---+-----+
# |SId|Sname|Sage               |Ssex|SId|CId|score|CId|Cname|TId|TId|Tname|
# +---+-----+-------------------+----+---+---+-----+---+-----+---+---+-----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |01 |02 |90.0 |02 |数学   |01 |01 |张三   |
# +---+-----+-------------------+----+---+---+-----+---+-----+---+---+-----+

