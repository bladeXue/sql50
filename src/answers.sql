# Q1
# 查询"01"课程比"02"课程成绩高的学生的信息及课程分数
# 左连接自交
select *
from Student as s
         right join
     (
         select t1.SId, score_for_c01, score_for_c02
         from (select SId, score as score_for_c01 from SC as sc where sc.CId = 01) as t1,
              (select SId, score as score_for_c02 from SC as sc where sc.CId = 02) as t2
         where t1.SId = t2.SId
           and t1.score_for_c01 > t2.score_for_c02
     ) as r
     on s.SId = r.SId;

# +---+-----+-------------------+----+---+-------------+-------------+
# |SId|Sname|Sage               |Ssex|SId|score_for_c01|score_for_c02|
# +---+-----+-------------------+----+---+-------------+-------------+
# |02 |钱电   |1990-12-21 00:00:00|男   |02 |70.0         |60.0         |
# |04 |李云   |1990-12-06 00:00:00|男   |04 |50.0         |30.0         |
# +---+-----+-------------------+----+---+-------------+-------------+

# Q1.1
# 查询同时存在"01"课程和"02"课程的情况
# 注意查找效率，每次生成的关系表越小越好
select t1.*, t2.CId, t2.score
from (select * from SC as sc where sc.CId = '01') as t1,
     (select * from SC as sc where sc.CId = '02') as t2
where t1.SId = t2.SId;

# +---+---+-----+---+-----+
# |SId|CId|score|CId|score|
# +---+---+-----+---+-----+
# |01 |01 |80.0 |02 |90.0 |
# |02 |01 |70.0 |02 |60.0 |
# |03 |01 |80.0 |02 |80.0 |
# |04 |01 |50.0 |02 |30.0 |
# |05 |01 |76.0 |02 |87.0 |
# +---+---+-----+---+-----+

# Q1.2
# 查询存在"01"课程但可能不存在"02"课程的情况(不存在时显示为null)
# 典型的外联结
select t1.*, t2.CId, t2.score
from (select * from SC as sc where sc.CId = '01') as t1
         left join
     (select * from SC as sc where sc.CId = '02') as t2
     on t1.SId = t2.SId;

# +---+---+-----+----+-----+
# |SId|CId|score|CId |score|
# +---+---+-----+----+-----+
# |01 |01 |80.0 |02  |90.0 |
# |02 |01 |70.0 |02  |60.0 |
# |03 |01 |80.0 |02  |80.0 |
# |04 |01 |50.0 |02  |30.0 |
# |05 |01 |76.0 |02  |87.0 |
# |06 |01 |31.0 |NULL|NULL |
# +---+---+-----+----+-----+

# 1.3
# 查询不存在"01"课程但存在"02"课程的情况
# 采用子查询（联结也可以，但本题子查询简单）
select *
from SC as sc
where sc.SId not in (
    select SId
    from SC as sc
    where sc.CId = '01'
)
  AND sc.CId = '02';

# +---+---+-----+
# |SId|CId|score|
# +---+---+-----+
# |07 |02 |89.0 |
# +---+---+-----+

# Q2
# 查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
# 聚合函数分组和HAVING条件过滤，获得sid，最后与学生表联结
select s.SId, s.Sname, t.avg_score
from Student as s
         inner join (select SId, avg(score) as avg_score
                     from SC
                     group by SId
                     having avg_score >= 60) as t
                    on s.SId = t.SId;

# +---+-----+---------+
# |SId|Sname|avg_score|
# +---+-----+---------+
# |01 |赵雷   |89.66667 |
# |02 |钱电   |70.00000 |
# |03 |孙风   |80.00000 |
# |05 |周梅   |81.50000 |
# |07 |郑竹   |93.50000 |
# +---+-----+---------+

# Q3
# 查询在SC表存在成绩的学生信息
# 以下分别是子查询和联结，虽然子查询看上去比较简单，但是大部分其实DBMS对联结有查询优化
select *
from Student as s
where s.SId in (select distinct SId from SC);
# 或
select DISTINCT s.*
from Student s,
     SC sc
where s.SId = sc.SId;

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |
# |02 |钱电   |1990-12-21 00:00:00|男   |
# |03 |孙风   |1990-12-20 00:00:00|男   |
# |04 |李云   |1990-12-06 00:00:00|男   |
# |05 |周梅   |1991-12-01 00:00:00|女   |
# |06 |吴兰   |1992-01-01 00:00:00|女   |
# |07 |郑竹   |1989-01-01 00:00:00|女   |
# +---+-----+-------------------+----+

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

# Q4.1
# 查有成绩的学生信息
# 仔细区分IN和EXISTS的应用场景
select *
from Student as s
where SId in (select SId from SC);
# 或
select *
from Student as s
where exists(select sc.SId from SC as sc where s.SId = sc.SId);

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |
# |02 |钱电   |1990-12-21 00:00:00|男   |
# |03 |孙风   |1990-12-20 00:00:00|男   |
# |04 |李云   |1990-12-06 00:00:00|男   |
# |05 |周梅   |1991-12-01 00:00:00|女   |
# |06 |吴兰   |1992-01-01 00:00:00|女   |
# |07 |郑竹   |1989-01-01 00:00:00|女   |
# +---+-----+-------------------+----+

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

# Q6
# 查询学过“张三”老师授课的同学的信息
# 多表联合查询。多表慎用，因为数据规模会迅速变大，不少DBMS都有表数限制
select s.*
from Student as s,
     Teacher as t,
     Course as c,
     SC as sc
where s.sid = sc.sid
  and c.cid = sc.cid
  and c.tid = t.tid
  and tname = '张三';

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |
# |02 |钱电   |1990-12-21 00:00:00|男   |
# |03 |孙风   |1990-12-20 00:00:00|男   |
# |04 |李云   |1990-12-06 00:00:00|男   |
# |05 |周梅   |1991-12-01 00:00:00|女   |
# |07 |郑竹   |1989-01-01 00:00:00|女   |
# +---+-----+-------------------+----+

# Q7
# 查询没有学全所有课程的同学的信息
# 反向思考，全选课的同学之外就是没选全的
select *
from Student as s
where s.sid not in (
    select sc.sid
    from SC as sc
    group by sc.sid
    having count(sc.cid) = (select count(cid) from Course)
);

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |05 |周梅   |1991-12-01 00:00:00|女   |
# |06 |吴兰   |1992-01-01 00:00:00|女   |
# |07 |郑竹   |1989-01-01 00:00:00|女   |
# |09 |张三   |2017-12-20 00:00:00|女   |
# |10 |李四   |2017-12-25 00:00:00|女   |
# |11 |李四   |2012-06-06 00:00:00|女   |
# |12 |赵六   |2013-06-13 00:00:00|女   |
# |13 |孙七   |2014-06-01 00:00:00|女   |
# +---+-----+-------------------+----+

# Q8
# 查询至少有一门课与学号为"01"的同学所学相同的同学的信息
# 双重子查询
select s.*
from Student as s
where s.SId in
      (
          # 获取同学课的学生的id
          select sc.SId
          from SC as sc
          where sc.CId in
                (
                    # 先把01同学学的课查出来
                    select sc.CId
                    from SC as sc
                    where sc.SId = '01'
                )
      );
# 或 双重联结
select s.*
from Student as s
         inner join
     (
         # 获取同学课的学生的id
         # distinct和group by都可以去重
         select distinct sc.SId
         from SC as sc
                  inner join
              (
                  # 先把01同学学的课查出来
                  select *
                  from SC
                  where SId = '01'
              ) as sc01
              on sc.CId = sc01.CId
     ) as r
     on s.SId = r.SId;
# 或 3表联结
select distinct s.*
from SC as sc
         inner join
     (
         # 先把01同学学的课查出来
         select *
         from SC
         where SId = '01'
     ) as sc01
         inner join
     Student as s
     on sc.CId = sc01.CId and
        s.SId = sc.SId;

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |
# |02 |钱电   |1990-12-21 00:00:00|男   |
# |03 |孙风   |1990-12-20 00:00:00|男   |
# |04 |李云   |1990-12-06 00:00:00|男   |
# |05 |周梅   |1991-12-01 00:00:00|女   |
# |06 |吴兰   |1992-01-01 00:00:00|女   |
# |07 |郑竹   |1989-01-01 00:00:00|女   |
# +---+-----+-------------------+----+

# Q9
# 查询和"01"号的同学学习的课程完全相同的其他同学的信息
# 注意题目要查出“其他同学”，不包括01自己
# 多表联结，分别查出01自己的匹配课程数和其它同学的匹配数目，然后3表联结，性能应该还可以优化
select s.*
from (
         select sc1.sid, count(sc1.CId) as courses
         from SC as sc1,
              SC as sc2
         where sc2.SId = 01
           and sc1.SId = sc2.SId
           and sc1.CId = sc2.CId
         group by sc1.SId
     ) as t1,
     (
         select sc1.sid, count(sc1.CId) as courses
         from SC as sc1,
              SC as sc2
         where sc2.SId = 01
           and sc1.SId <> sc2.SId
           and sc1.CId = sc2.CId
         group by sc1.SId
     ) as t2,
     Student as s
where t1.courses = t2.courses
  and t2.SId = s.SId;
# 或 直接自联结
select *
from Student
where SId in (
    select t1.SId
    from ( # 获取全部成绩数据，course_count为和01同样的课程数目
             select sc1.SId, count(sc1.CId) as course_count
             from SC as sc1
                      inner join
                  (
                      select CId
                      from SC
                      where SId = '01'
                  ) as sc2
                  on sc1.CId = sc2.CId
             group by sc1.SId
         ) as t1
             inner join
         (
             select count(CId) as cnt
             from SC
             where SId = '01'
         ) as t2
         on t1.course_count = t2.cnt
);
# n重子查询（不推荐）
SELECT *
FROM Student
WHERE sid IN
      (
          SELECT sid
          FROM (
                   SELECT *
                   FROM SC AS a
                   WHERE cid IN
                         (
                             SELECT cid
                             FROM SC
                             WHERE sid = 01
                         )
               ) b
          GROUP BY sid
          HAVING COUNT(cid) =
                 (
                     SELECT COUNT(cid)
                     FROM SC c
                     WHERE sid = 01
                 ))
  AND sid != 01;
SELECT *
FROM Student
WHERE sid IN
      (SELECT sid
       FROM (SELECT *
             FROM SC AS a
             WHERE cid IN
                   (SELECT cid
                    FROM SC
                    WHERE sid = 01)) b
       GROUP BY sid
       HAVING COUNT(cid) =
              (SELECT COUNT(cid)
               FROM SC c
               WHERE sid = 01))
  AND sid != 01;

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |02 |钱电   |1990-12-21 00:00:00|男   |
# |03 |孙风   |1990-12-20 00:00:00|男   |
# |04 |李云   |1990-12-06 00:00:00|男   |
# +---+-----+-------------------+----+

# Q10
# 查询没学过 张三 老师讲授的任一门课程的学生姓名
# 其实就是学过张三老师的学生的取反
# 三层子嵌套或者多表联合查询，都可以。这里给出多表联合查询
select s.*
from Student as s
where s.SId not in
      (
          # 查询上过张三老师（数学课）的学生名单
          select sc.SId
          from SC as sc,
               Course as c,
               Teacher as t
          where sc.CId = c.CId
            and c.TId = t.TId
            and t.Tname = '张三'
      );

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |06 |吴兰   |1992-01-01 00:00:00|女   |
# |09 |张三   |2017-12-20 00:00:00|女   |
# |10 |李四   |2017-12-25 00:00:00|女   |
# |11 |李四   |2012-06-06 00:00:00|女   |
# |12 |赵六   |2013-06-13 00:00:00|女   |
# |13 |孙七   |2014-06-01 00:00:00|女   |
# +---+-----+-------------------+----+

# Q11
# 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
# 先查出对应的不及格成绩后，再和信息表联结
select s.SId, s.Sname, t.avg_score
from Student as s
         inner join
     (
         select sc.SId, count(sc.CId), avg(sc.score) as avg_score
         from SC as sc
         where score < 60
         group by sc.SId
     ) as t
     on s.SId = t.SId;
# 或 旧版本，直接双表联结，获得学生信息和成绩的混合表，之后再用HAVING（GROUP BY在SQL中比HAVING早生效）过滤
select s.SId, s.Sname, avg(sc.score) as avg_score
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId and sc.score < 60
group by sc.SId, s.Sname
having count(*) >= 2;

# +---+-----+---------+
# |SId|Sname|avg_score|
# +---+-----+---------+
# |04 |李云   |33.33333 |
# |06 |吴兰   |32.50000 |
# +---+-----+---------+

# Q12
# 检索"01"课程分数小于60，按分数降序排列的学生信息
# 使用order by
select s.*, sc.score
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId
         and sc.CId = 01
         and sc.score < 60
order by sc.score desc;

# +---+-----+-------------------+----+-----+
# |SId|Sname|Sage               |Ssex|score|
# +---+-----+-------------------+----+-----+
# |04 |李云   |1990-12-06 00:00:00|男   |50.0 |
# |06 |吴兰   |1992-01-01 00:00:00|女   |31.0 |
# +---+-----+-------------------+----+-----+

# Q13
# 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
# 实现似乎有些问题，个人觉得没有成绩的学生也要算
select *
from SC as sc
         left outer join
     (
         select sc.SId, avg(sc.score) as avg_score
         from SC sc
         group by sc.SId
     ) as r
     on sc.SId = r.SId
order by avg_score desc;

# +---+---+-----+---+---------+
# |SId|CId|score|SId|avg_score|
# +---+---+-----+---+---------+
# |07 |03 |98.0 |07 |93.50000 |
# |07 |02 |89.0 |07 |93.50000 |
# |01 |02 |90.0 |01 |89.66667 |
# |01 |03 |99.0 |01 |89.66667 |
# |01 |01 |80.0 |01 |89.66667 |
# |05 |01 |76.0 |05 |81.50000 |
# |05 |02 |87.0 |05 |81.50000 |
# |03 |01 |80.0 |03 |80.00000 |
# |03 |02 |80.0 |03 |80.00000 |
# |03 |03 |80.0 |03 |80.00000 |
# |02 |01 |70.0 |02 |70.00000 |
# |02 |02 |60.0 |02 |70.00000 |
# |02 |03 |80.0 |02 |70.00000 |
# |04 |01 |50.0 |04 |33.33333 |
# |04 |02 |30.0 |04 |33.33333 |
# |04 |03 |20.0 |04 |33.33333 |
# |06 |01 |31.0 |06 |32.50000 |
# |06 |03 |34.0 |06 |32.50000 |
# +---+---+-----+---+---------+

# Q14
# 查询各科成绩最高分、最低分和平均分，显示为：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
# >=60及格，70-79中等，80-89良好，>=90优秀
# 要求输出课程号和选修人数（查询结果按人数降序排列，若人数相同，按课程号升序排列）
# 使用if/case表达式配合聚合函数来解析
# 小心group by和order by的生效顺序
select sc.CId,
       max(sc.score)                                              as 最高分,
       min(sc.score)                                              as 最低分,
       AVG(sc.score)                                              as 平均分,
       count(*)                                                   as 选修人数,
       sum(IF(sc.score >= 60, 1, 0)) / count(*)                   as 及格率,
       sum(IF(sc.score >= 70 and sc.score < 80, 1, 0)) / count(*) as 中等率,
       sum(IF(sc.score >= 80 and sc.score < 90, 1, 0)) / count(*) as 优良率,
       sum(IF(sc.score >= 90, 1, 0)) / count(*)                   as 优秀率
from SC sc
GROUP BY sc.CId
ORDER BY count(*) DESC, sc.CId;

# +---+----+----+--------+----+------+------+------+------+
# |CId|最高分 |最低分 |平均分     |选修人数|及格率   |中等率   |优良率   |优秀率   |
# +---+----+----+--------+----+------+------+------+------+
# |01 |80.0|31.0|64.50000|6   |0.6667|0.3333|0.3333|0.0000|
# |02 |90.0|30.0|72.66667|6   |0.8333|0.0000|0.5000|0.1667|
# |03 |99.0|20.0|68.50000|6   |0.6667|0.0000|0.3333|0.3333|
# +---+----+----+--------+----+------+------+------+------+

# Q15
# 按各科成绩对学科进行排序，并显示排名，Score重复时保留名次空缺
# 所谓保留名次空缺，意思是两个人的成绩一样时，会出现两个“第n名”，之后的学生则是“第n+1名”
# 按学科排序，学科内按成绩排序
# 有一个自连接的小技巧，用sc中的score和自己进行对比，来计算“比当前分数高的分数有几个”
# 使用左联结，不然最高分会消失
select sc1.CId,
       sc1.SId,
       sc1.score,
       count(sc1.score) as score_grade
from SC as sc1
         left join
     SC as sc2
     on sc1.CId = sc2.CId
         and sc1.score < sc2.score
group by sc1.CId,
         sc1.SId,
         sc1.score
order by sc1.CId,
         score_grade;

# +---+---+-----+-----------+
# |CId|SId|score|score_grade|
# +---+---+-----+-----------+
# |01 |01 |80.0 |1          |
# |01 |03 |80.0 |1          |
# |01 |05 |76.0 |2          |
# |01 |02 |70.0 |3          |
# |01 |04 |50.0 |4          |
# |01 |06 |31.0 |5          |
# |02 |01 |90.0 |1          |
# |02 |07 |89.0 |1          |
# |02 |05 |87.0 |2          |
# |02 |03 |80.0 |3          |
# |02 |02 |60.0 |4          |
# |02 |04 |30.0 |5          |
# |03 |01 |99.0 |1          |
# |03 |07 |98.0 |1          |
# |03 |03 |80.0 |2          |
# |03 |02 |80.0 |2          |
# |03 |06 |34.0 |4          |
# |03 |04 |20.0 |5          |
# +---+---+-----+-----------+

# Q15.1
# 按各科成绩对学生进行排序，并显示排名，Score重复时合并名次
# 所谓名次合并，意思是两个人的成绩一致按照一个名次来，会出现两个“第n名”，之后的学生则是“第n+2名”
# 和q15的区别在于score_grade的对象是谁
select sc1.CId,
       sc1.SId,
       sc1.score,
       count(sc2.score) + 1 as score_grade
from SC as sc1
         left join
     SC as sc2
     on sc1.CId = sc2.CId # 同科
         and sc1.score < sc2.score
group by sc1.CId,
         sc1.SId,
         sc1.score
order by sc1.CId,
         score_grade;

# +---+---+-----+-----------+
# |CId|SId|score|score_grade|
# +---+---+-----+-----------+
# |01 |01 |80.0 |1          |
# |01 |03 |80.0 |1          |
# |01 |05 |76.0 |3          |
# |01 |02 |70.0 |4          |
# |01 |04 |50.0 |5          |
# |01 |06 |31.0 |6          |
# |02 |01 |90.0 |1          |
# |02 |07 |89.0 |2          |
# |02 |05 |87.0 |3          |
# |02 |03 |80.0 |4          |
# |02 |02 |60.0 |5          |
# |02 |04 |30.0 |6          |
# |03 |01 |99.0 |1          |
# |03 |07 |98.0 |2          |
# |03 |03 |80.0 |3          |
# |03 |02 |80.0 |3          |
# |03 |06 |34.0 |5          |
# |03 |04 |20.0 |6          |
# +---+---+-----+-----------+

# Q16
# 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺
# 主要是变量的使用（这个变量的作用仅仅是计数器）
select t1.*, @rank := @rank + 1 as score_rank
from (
         select sc.SId,
                sum(sc.score) as sum_score
         from SC as sc
         group by sc.SId
         order by sum_score desc
     ) as t1
         inner join
     (
         select @rank := 0
     ) as t2;

# +---+---------+----------+
# |SId|sum_score|score_rank|
# +---+---------+----------+
# |01 |269.0    |1         |
# |03 |240.0    |2         |
# |02 |210.0    |3         |
# |07 |187.0    |4         |
# |05 |163.0    |5         |
# |04 |100.0    |6         |
# |06 |65.0     |7         |
# +---+---------+----------+

# Q17
# 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0]及所占百分比
# 思路和之前的Q14一样，join+case计数
# 不要用单sc的group by，用sc join course先做出一张混合表，这才是关系的意义
select sc.CId,
       c.Cname,
       sum(IF(sc.score >= 0 and score < 60, 1, 0))                    as '[60-0]',
       sum(IF(sc.score >= 0 and score < 60, 1, 0)) / count(sc.SId)    as '[60-0]',
       sum(IF(sc.score >= 60 and score < 70, 1, 0))                   as '[70-60]',
       sum(IF(sc.score >= 60 and score < 70, 1, 0)) / count(sc.SId)   as '[70-60]百分比',
       sum(IF(sc.score >= 70 and score < 85, 1, 0))                   as '[85-70]',
       sum(IF(sc.score >= 70 and score < 85, 1, 0)) / count(sc.SId)   as '[85-70]百分比',
       sum(IF(sc.score >= 85 and score <= 100, 1, 0))                 as '[100-85]',
       sum(IF(sc.score >= 85 and score <= 100, 1, 0)) / count(sc.SId) as '[100-85]百分比'
from SC as sc
         inner join
     Course as c
     on sc.CId = c.CId
group by sc.CId, c.Cname;

# +---+-----+------+------+-------+----------+-------+----------+--------+-----------+
# |CId|Cname|[60-0]|[60-0]|[70-60]|[70-60]百分比|[85-70]|[85-70]百分比|[100-85]|[100-85]百分比|
# +---+-----+------+------+-------+----------+-------+----------+--------+-----------+
# |01 |语文   |2     |0.3333|0      |0.0000    |4      |0.6667    |0       |0.0000     |
# |02 |数学   |1     |0.1667|1      |0.1667    |1      |0.1667    |3       |0.5000     |
# |03 |英语   |2     |0.3333|0      |0.0000    |2      |0.3333    |2       |0.3333     |
# +---+-----+------+------+-------+----------+-------+----------+--------+-----------+

# Q18
# 查询各科成绩前三名的记录
# mysql不能group by了以后取limit
# 这里还是老套路，也就是所谓的基于自交的横向扩展
select sc1.CId,
       sc1.SId,
       sc1.score,
       count(sc2.score) + 1 as 'c_score_rank'
from SC as sc1
         left join
     SC as sc2
     on sc1.CId = sc2.CId # 这两行是关键，保留比当前成绩高的记录，这样就很容易算出当前成绩是多少名了
         and sc1.score < sc2.score
group by sc1.SId,
         sc1.CId,
         sc1.score
having c_score_rank < 4
order by sc1.CId, c_score_rank;

# +---+---+-----+------------+
# |CId|SId|score|c_score_rank|
# +---+---+-----+------------+
# |01 |01 |80.0 |1           |
# |01 |03 |80.0 |1           |
# |01 |05 |76.0 |3           |
# |02 |01 |90.0 |1           |
# |02 |07 |89.0 |2           |
# |02 |05 |87.0 |3           |
# |03 |01 |99.0 |1           |
# |03 |07 |98.0 |2           |
# |03 |02 |80.0 |3           |
# |03 |03 |80.0 |3           |
# +---+---+-----+------------+

# Q19
# 查询每门课程被选修的学生数
# 很基本操作，group即可
# 之前Q1-Q18是简单到难，Q19开始循环知识点和难度
select sc.CId,
       count(sc.SId) as 'sum_stu'
from SC as sc
group by sc.CId;

# +---+-------+
# |CId|sum_stu|
# +---+-------+
# |01 |6      |
# |02 |6      |
# |03 |6      |
# +---+-------+

# Q20
# 查询出只选修两门课程的学生学号和姓名
# 简单，直接join即可
# 善用having可以少写很多条件，但是要当心，having是发生在拼表结束后的
select s.SId,
       s.Sname
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId
group by sc.SId,
         s.Sname
having count(sc.CId) = 2;

# +---+-----+
# |SId|Sname|
# +---+-----+
# |05 |周梅   |
# |06 |吴兰   |
# |07 |郑竹   |
# +---+-----+

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

# Q22
# 查询名字中含有“风”字的学生信息
# 简单，通配符
SELECT s.*
FROM Student as s
WHERE s.Sname LIKE '%风%';

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |03 |孙风   |1990-12-20 00:00:00|男   |
# +---+-----+-------------------+----+

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

# Q24
# 查询1990年出生的学生名单
# 使用标准函数year()
select s.*
from Student as s
where year(s.Sage) = 1990;

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |
# |02 |钱电   |1990-12-21 00:00:00|男   |
# |03 |孙风   |1990-12-20 00:00:00|男   |
# |04 |李云   |1990-12-06 00:00:00|男   |
# +---+-----+-------------------+----+

# Q25
# 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select c.CId,
       c.Cname,
       avg(sc.score) as avg_score
from Course as c
         inner join
     SC as sc
     on c.CId = sc.CId
group by c.CId,
         c.Cname
order by avg_score desc,
         c.CId;

# +---+-----+---------+
# |CId|Cname|avg_score|
# +---+-----+---------+
# |02 |数学   |72.66667 |
# |03 |英语   |68.50000 |
# |01 |语文   |64.50000 |
# +---+-----+---------+

# Q26
# 查询平均成绩大于等于85的所有学生的学号，姓名和平均成绩
# 使用having截取结果表（注意这里的措辞，HAVING的作用时间很晚）
select s.SId,
       s.Sname,
       avg(sc.score) as avg_score
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId
group by s.SId,
         s.Sname
having avg_score >= 85;

# +---+-----+---------+
# |SId|Sname|avg_score|
# +---+-----+---------+
# |01 |赵雷   |89.66667 |
# |07 |郑竹   |93.50000 |
# +---+-----+---------+

# Q27
# 查询课程名称为“数学”，且分数低于60的学生姓名和分数
# 三表联合查询，注意dbms对join有优化
# 注意多重join的语法细节
select s.Sname,
       sc.score
from Student as s
         inner join
     SC as sc
         inner join
     Course as c
     on s.SId = sc.SId and
        sc.CId = c.CId and
        c.Cname = '数学'
where sc.score < 60;
# 或 另一种更好看的内联结写法
select s.Sname,
       sc.score
from Student as s
         inner join
     SC as sc on s.SId = sc.SId
         inner join
     Course as c on sc.CId = c.CId
where c.Cname = '数学'
  and sc.score < 60;

# +-----+-----+
# |Sname|score|
# +-----+-----+
# |李云   |30.0 |
# +-----+-----+

# Q28
# 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）
# 典型的外联结
select s.SId,
       s.Sname,
       sc.CId,
       sc.score
from Student as s
         inner join
     SC as sc on s.SId = sc.SId;

# +---+-----+---+-----+
# |SId|Sname|CId|score|
# +---+-----+---+-----+
# |01 |赵雷   |01 |80.0 |
# |01 |赵雷   |02 |90.0 |
# |01 |赵雷   |03 |99.0 |
# |02 |钱电   |01 |70.0 |
# |02 |钱电   |02 |60.0 |
# |02 |钱电   |03 |80.0 |
# |03 |孙风   |01 |80.0 |
# |03 |孙风   |02 |80.0 |
# |03 |孙风   |03 |80.0 |
# |04 |李云   |01 |50.0 |
# |04 |李云   |02 |30.0 |
# |04 |李云   |03 |20.0 |
# |05 |周梅   |01 |76.0 |
# |05 |周梅   |02 |87.0 |
# |06 |吴兰   |01 |31.0 |
# |06 |吴兰   |03 |34.0 |
# |07 |郑竹   |02 |89.0 |
# |07 |郑竹   |03 |98.0 |
# +---+-----+---+-----+

# Q29
# 查询任何一门课程成绩在70分以上的姓名，课程名称和分数
# 小心优化https://zhuanlan.zhihu.com/p/72223558 Q29
select s.Sname,
       c.Cname,
       sc.score
from Student as s
         inner join
     SC as sc on s.SId = sc.SId and sc.score > 70
         inner join
     Course as c on sc.CId = c.CId;

# +-----+-----+-----+
# |Sname|Cname|score|
# +-----+-----+-----+
# |赵雷   |英语   |99.0 |
# |赵雷   |数学   |90.0 |
# |赵雷   |语文   |80.0 |
# |钱电   |英语   |80.0 |
# |孙风   |英语   |80.0 |
# |孙风   |数学   |80.0 |
# |孙风   |语文   |80.0 |
# |周梅   |数学   |87.0 |
# |周梅   |语文   |76.0 |
# |郑竹   |英语   |98.0 |
# |郑竹   |数学   |89.0 |
# +-----+-----+-----+

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

# Q31
# 查询课程编号为01且课程成绩在80分及以上的学生的学号和姓名
select s.SId,
       s.Sname
from Student as s
         inner join
     SC as sc on s.SId = sc.SId
where sc.CId = 01
  and sc.score >= 80;
# 或
select s.SId,
       s.Sname
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId
         and sc.CId = 01
         and sc.score >= 80;

# +---+-----+
# |SId|Sname|
# +---+-----+
# |01 |赵雷   |
# |03 |孙风   |
# +---+-----+

# Q32
# 求每门课程的学生人数
# 未考虑sid重复问题
select sc.CId,
       count(sc.SId) as 'stu_count'
from SC as sc
group by sc.CId;

# +---+---------+
# |CId|stu_count|
# +---+---------+
# |01 |6        |
# |02 |6        |
# |03 |6        |
# +---+---------+

# Q33
# 成绩不重复，查询选修“张三”老师所授课程的学生中，成绩最高的学生信息及其成绩
# 4表联合查询
# 方案1：having max()，方案2：排序后limit 1，方案3：子查询
# 推荐方案2
select *
from Student as s,
     SC as sc,
     Course as c,
     Teacher as t
where t.TId = c.TId
  and t.Tname = '张三'
  and sc.CId = c.CId
  and sc.SId = s.SId
order by sc.score desc
limit 1;

# +---+-----+-------------------+----+---+---+-----+---+-----+---+---+-----+
# |SId|Sname|Sage               |Ssex|SId|CId|score|CId|Cname|TId|TId|Tname|
# +---+-----+-------------------+----+---+---+-----+---+-----+---+---+-----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |01 |02 |90.0 |02 |数学   |01 |01 |张三   |
# +---+-----+-------------------+----+---+---+-----+---+-----+---+---+-----+

# Q34
# 成绩有重复的情况下，查询选修“张三”老师所授课程的学生中，成绩最高的学生信息及其成绩
# 还是老规矩，自交比大小
# 与Q33类似
select s.*,
       sc.score
from Student as s
         inner join
     SC as sc on s.SId = sc.SId
         inner join
     Course as c on sc.CId = c.CId
         inner join
     Teacher as t on c.TId = t.TId
where t.Tname = '张三'
  and sc.score = (
    select max(sc.score)
    from Student as s
             inner join
         SC as sc on s.SId = sc.SId
             inner join
         Course as c on sc.CId = c.CId
             inner join
         Teacher as t on c.TId = t.TId
    where t.Tname = '张三'
);

# 验证本题需改动数据，将SC表中学生“赵竹”的{SId=07,CId=02}的score从89.0改成90.0
# +---+-----+-------------------+----+-----+
# |SId|Sname|Sage               |Ssex|score|
# +---+-----+-------------------+----+-----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |90.0 |
# |07 |郑竹   |1989-01-01 00:00:00|女   |90.0 |
# +---+-----+-------------------+----+-----+

# Q35
# 查询不同课程成绩相同的学生的学生编号，课程编号，学生成绩
# 方案还是自交，但是会有重复数据，也就是c01=c03和c03=c01，通过分组或dist来去重
SELECT DISTINCT sc1.*
FROM SC AS sc1
         INNER JOIN
     SC AS sc2 ON sc1.score = sc2.score
WHERE sc1.cid <> sc2.cid;

# +---+---+-----+
# |SId|CId|score|
# +---+---+-----+
# |03 |03 |80.0 |
# |03 |02 |80.0 |
# |02 |03 |80.0 |
# |03 |01 |80.0 |
# |01 |01 |80.0 |
# +---+---+-----+

# Q36
# 查询每门功成绩最好的前两名
# 考虑并列的情况
# Q15的延伸
select sc1.CId,
       sc1.SId,
       sc1.score,
       count(sc2.score) + 1 as 'score_rank'
from SC as sc1
         left join
     SC as sc2 on sc1.CId = sc2.CId and
                  sc1.score < sc2.score
group by sc1.CId,
         sc1.SId,
         sc1.score
having score_rank <= 2
order by sc1.CId,
         sc1.score desc;

# +---+---+-----+----------+
# |CId|SId|score|score_rank|
# +---+---+-----+----------+
# |01 |01 |80.0 |1         |
# |01 |03 |80.0 |1         |
# |02 |01 |90.0 |1         |
# |02 |07 |89.0 |2         |
# |03 |01 |99.0 |1         |
# |03 |07 |98.0 |2         |
# +---+---+-----+----------+

# Q37
# 统计每门课程的学生选修人数（超过5人的课程才统计）
# 聚合函数的基本考察
select CId,
       count(SId) as 'count_stu'
from SC
group by CId
having count_stu > 5;

# +---+---------+
# |CId|count_stu|
# +---+---------+
# |01 |6        |
# |02 |6        |
# |03 |6        |
# +---+---------+

# Q38
# 检索至少选修两门课程的学生学号
select SId
from SC
group by SId
having count(CId) >= 2;

# +---+
# |SId|
# +---+
# |01 |
# |02 |
# |03 |
# |04 |
# |05 |
# |06 |
# |07 |
# +---+

# Q39
# 查询选修了全部课程的学生信息
# 这里用了一次简单的子查询
select s.SId,
       s.Sname,
       s.Sage,
       s.Ssex
from Student as s
         inner join
     SC as sc on s.SId = sc.SId
group by s.SId,
         s.Sname,
         s.Sage,
         s.Ssex
having count(sc.CId) = (
    select count(*)
    from Course
);

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+
# |01 |赵雷   |1990-01-01 00:00:00|男   |
# |02 |钱电   |1990-12-21 00:00:00|男   |
# |03 |孙风   |1990-12-20 00:00:00|男   |
# |04 |李云   |1990-12-06 00:00:00|男   |
# +---+-----+-------------------+----+

# Q40
# 查询各学生的年龄，只按年份来算
# 本题开始考察时间函数
SELECT Sname,
       YEAR(NOW()) - YEAR(sage) AS 'age'
FROM Student;

# +-----+---+
# |Sname|age|
# +-----+---+
# |赵雷   |31 |
# |钱电   |31 |
# |孙风   |31 |
# |李云   |31 |
# |周梅   |30 |
# |吴兰   |29 |
# |郑竹   |32 |
# |张三   |4  |
# |李四   |4  |
# |李四   |9  |
# |赵六   |8  |
# |孙七   |7  |
# +-----+---+

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

# Q42
# 查询本周过生日的学生
select *
from Student
where WEEKOFYEAR(Sage) = WEEKOFYEAR(CURDATE());

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+

# Q43
# 查询下周过生日的学生
select *
from Student
where WEEKOFYEAR(Sage) = WEEKOFYEAR(CURDATE()) + 1;

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+

# Q44
# 查询本月过生日的学生
select *
from Student
where MONTH(Sage) = MONTH(CURDATE());

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+

# Q45
# 查询下月过生日的学生
select *
from Student
where MONTH(Sage) = MONTH(CURDATE()) + 1;

# +---+-----+-------------------+----+
# |SId|Sname|Sage               |Ssex|
# +---+-----+-------------------+----+

