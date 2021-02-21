# Q34
# 成绩有重复的情况下，查询选修“张三”老师所授课程的学生中，成绩最高的学生信息及其成绩
# 还是老规矩，自交比大小
# 与Q33类似
select s.*,
       sc.score
from Student as s
         inner join
     SC as sc on s.SId = sc.SId
         inner join
     Course as c on sc.CId = c.CId
         inner join
     Teacher as t on c.TId = t.TId
where t.Tname = '张三'
  and sc.score = (
    select max(sc.score)
    from Student as s
             inner join
         SC as sc on s.SId = sc.SId
             inner join
         Course as c on sc.CId = c.CId
             inner join
         Teacher as t on c.TId = t.TId
    where t.Tname = '张三'
);

# 验证本题需改动数据，将SC表中学生“赵竹”的{SId=07,CId=02}的score从89.0改成90.0
# +---+-----+-------------------+----+-----+
# |SId|Sname|Sage               |Ssex|score|
# +---+-----+-------------------+----+-----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |90.0 |
# |07 |郑竹   |1989-01-01 00:00:00|女   |90.0 |
# +---+-----+-------------------+----+-----+

