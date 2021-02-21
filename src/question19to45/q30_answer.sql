# Q30
# 查询存在不及格的课程
# group或distinct都行
select distinct CId
from SC
where score < 60;
# 或
select CId
from SC
where score < 60
group by CId;

# +---+
# |CId|
# +---+
# |01 |
# |02 |
# |03 |
# +---+

