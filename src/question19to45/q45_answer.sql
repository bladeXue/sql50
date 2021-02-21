# Q45
# 查询下月过生日的学生
select *
from Student
where MONTH(Sage) = MONTH(CURDATE()) + 1;

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+

