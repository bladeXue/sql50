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

