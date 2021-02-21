# Q23
# 查询同名学生名单，并统计同名人数
select s.Sname,
       count(*)
from Student s
group by s.Sname
having count(*) > 1;

# +-----+--------+
# |Sname|count(*)|
# +-----+--------+
# |李四   |2       |
# +-----+--------+

