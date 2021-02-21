# Q4
# 查询所有同学的学生编号，学生姓名，选课总数，所有课程的成绩总和
# 内联查询不会显示没选课的学生
select s.SId, s.Sname, t.count_course, t.sum_score
from Student as s
         inner join (select SId, count(CId) as count_course, sum(score) as sum_score
                     from SC
                     group by SId) as t
                    on s.SId = t.SId;
# 或 使用左联结显示所有学生，并使用IF表达式去除null
select s.SId,
       s.Sname,
       IFNULL(t.count_course, 0) as count_course,
       IFNULL(t.sum_score, 0)    as sum_score
from Student as s
         left join (select SId, count(CId) as count_course, sum(score) as sum_score from SC group by SId) as t
                   on s.SId = t.SId;

# +---+-----+------------+---------+
# |SId|Sname|count_course|sum_score|
# +---+-----+------------+---------+
# |01 |赵雷   |3           |269.0    |
# |02 |钱电   |3           |210.0    |
# |03 |孙风   |3           |240.0    |
# |04 |李云   |3           |100.0    |
# |05 |周梅   |2           |163.0    |
# |06 |吴兰   |2           |65.0     |
# |07 |郑竹   |2           |187.0    |
# |09 |张三   |0           |0.0      |
# |10 |李四   |0           |0.0      |
# |11 |李四   |0           |0.0      |
# |12 |赵六   |0           |0.0      |
# |13 |孙七   |0           |0.0      |
# +---+-----+------------+---------+

