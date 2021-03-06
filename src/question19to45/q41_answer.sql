# Q41
# 按照出生日期来算，当前月日<出生年月的月日则，年龄减一
# 函数或case都可以
select SId                                  as 学生编号,
       Sname                                as 学生姓名,
       TIMESTAMPDIFF(YEAR, Sage, CURDATE()) as 学生年龄
from Student;

# +----+----+----+
# |学生编号|学生姓名|学生年龄|
# +----+----+----+
# |01  |赵雷  |31  |
# |02  |钱电  |30  |
# |03  |孙风  |30  |
# |04  |李云  |30  |
# |05  |周梅  |29  |
# |06  |吴兰  |29  |
# |07  |郑竹  |32  |
# |09  |张三  |3   |
# |10  |李四  |3   |
# |11  |李四  |8   |
# |12  |赵六  |7   |
# |13  |孙七  |6   |
# +----+----+----+

