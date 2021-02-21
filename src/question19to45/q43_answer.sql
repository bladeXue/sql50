# Q43
# 查询下周过生日的学生
select *
from Student
where WEEKOFYEAR(Sage) = WEEKOFYEAR(CURDATE()) + 1;

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+

