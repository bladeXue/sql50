# Q21
# 查询男生、女生人数
# 方案1：分组count，产生纵向表
select s.Ssex,
       count(s.SId)
from Student as s
group by s.Ssex;
# 方案2：case，产生横向表
select sum(IF(s.Ssex = '男', 1, 0)) as 'male_stu',
       sum(IF(s.Ssex = '女', 1, 0)) as 'female_stu'
from Student as s;
# 本题解法很多，方案2也可以count-male_stu

# +----+------------+
# |Ssex|count(s.SId)|
# +----+------------+
# |男   |4           |
# |女   |8           |
# +----+------------+

