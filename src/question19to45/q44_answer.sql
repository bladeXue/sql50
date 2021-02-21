# Q44
# 查询本月过生日的学生
select *
from Student
where MONTH(Sage) = MONTH(CURDATE());

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+

