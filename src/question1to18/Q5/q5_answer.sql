# Q5
# 查询李姓老师的数量
select count(*)
from Teacher as t
where t.Tname like '李%';
