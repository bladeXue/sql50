# Q5
# 查询“李”姓老师的数量
# 聚合函数和正则表达式的简单使用
select count(*)
from Teacher as t
where t.Tname like '李%';

# +-----+
# |count|
# +-----+
# |1    |
# +-----+

