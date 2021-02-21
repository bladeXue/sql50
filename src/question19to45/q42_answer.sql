# Q42
# 查询本周过生日的学生
select *
from Student
where WEEKOFYEAR(Sage) = WEEKOFYEAR(CURDATE());

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+

