# Q1
# 查询"01"课程比"02"课程成绩高的学生的信息及课程分数
# 左连接自交
select s.SId, s.Sname, s.Ssex, r.score_for_c01, r.score_for_c02
from Student as s
         right outer join
     (select t1.SId, score_for_c01, score_for_c02
      from (select SId, score as score_for_c01 from SC as sc where sc.CId = 01) as t1,
           (select SId, score as score_for_c02 from SC as sc where sc.CId = 02) as t2
      where t1.SId = t2.SId
        and t1.score_for_c01 > t2.score_for_c02) as r
     on s.SId = r.SId;

# Q1.1
# 查询同时存在"01"课程和"02"课程的情况
# 注意查找效率，每次生成的关系表越小越好
select *
from (select * from SC as sc where sc.CId = '01') as t1,
     (select * from SC as sc where sc.CId = '02') as t2
where t1.SId = t2.SId;

# Q1.2
# 查询存在"01"课程但可能不存在"02"课程的情况(不存在时显示为null)
select *
from (select * from SC as sc where sc.CId = '01') as t1
         left join
     (select * from SC as sc where sc.CId = '02') as t2
     on t1.SId = t2.SId;

# 1.3
# 查询不存在"01"课程但存在"02"课程的情况
select *
from SC as sc
where sc.SId not in (
    select SId
    from SC as sc
    where sc.CId = '01'
)
  AND sc.CId = '02';

# Q2
# 查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
select s.SId, s.Sname, t.avg_score
from Student as s
         inner join (select SId, avg(score) as avg_score
                     from SC
                     group by SId
                     having avg_score >= 60) as t
                    on s.SId = t.SId;

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

# Q4
# 查询所有同学的学生编号，学生姓名，选课总数，所有课程的成绩总和
# 联合查询不会显示没选课的学生
# 关于别名的问题，最好随时加别名，DBMS有优化
select s.SId, s.Sname, t.count_course, t.sum_score
from Student as s
         inner join (select SId, count(CId) as count_course, sum(score) as sum_score
                     from SC
                     group by SId) as t
                    on s.SId = t.SId;

# Q4.1
# 查有成绩的学生信息
# 仔细区分IN和EXISTS的应用场景
# 小心ALIAS
select *
from Student as s
where SId in (select SId from SC);
# 或
select *
from Student as s
where exists(select sc.SId from SC as sc where s.SId = sc.SId);

# Q5
# 查询李姓老师的数量
select count(*)
from Teacher as t
where t.Tname like '李%';

# Q6
# 查询学过 张三 老师授课的同学的信息
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

# Q8
# 查询至少有一门课与学号为"01"的同学所学相同的同学的信息
select s.*
from Student as s
where s.SId in
      (
          # 获取同学课的学生的id
          select sc.SId
          from SC as sc
          where sc.CId in (
              # 先把01同学学的课查出来
              select sc.CId
              from SC as sc
              where sc.SId = 01)
      );

# Q9
# 查询和"01"号的同学学习的课程完全相同的其他同学的信息
# 原创，分别查出01自己的匹配课程数和其它同学的匹配数目，然后多表联结，性能应该还可以优化
select s.*
from (
         select sc1.sid, count(sc1.CId) as courses
         from SC as sc1,
              SC as sc2
         where sc2.SId = @target_student_id
           and sc1.SId = sc2.SId
           and sc1.CId = sc2.CId
         group by sc1.SId
     ) as t1,
     (
         select sc1.sid, count(sc1.CId) as courses
         from SC as sc1,
              SC as sc2
         where sc2.SId = @target_student_id
           and sc1.SId <> sc2.SId
           and sc1.CId = sc2.CId
         group by sc1.SId
     ) as t2,
     Student as s,
     (select @target_student_id = 01) as tid
where t1.courses = t2.courses
  and t2.SId = s.SId;
# 我的原版（不带变量）
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

# Q10
# 查询没学过 张三 老师讲授的任一门课程的学生姓名
# 其实就是学过张三老师的学生的取反
# 三层子嵌套或者多表联合查询，都可以。这里给出多表
select s.*
from Student as s
where s.SId not in
      (select sc.SId
       from SC as sc,
            Course as c,
            Teacher as t
       where sc.CId = c.CId
         and c.TId = t.TId
         and t.Tname = '张三');

# Q11
# 查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
# 我的版本（用了子查询，不太好）
select s.SId, s.Sname, t.avg_score
from Student as s
         inner join
     (select sc.SId, count(sc.CId), avg(sc.score) as avg_score
      from SC as sc
      where score < 60
      group by sc.SId) as t
     on s.SId = t.SId;
# 或 博主给的版本，直接双表联结+HAVING（GROUP BY在SQL中比HAVING早生效）
select s.SId, s.Sname, avg(sc.score) as avg_score
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId and sc.score < 60
group by sc.SId, s.Sname
having count(*) >= 2;

# Q12
# 检索"01"课程分数小于60，按分数降序排列的学生信息
select s.*, sc.score
from Student as s
         inner join
     SC as sc
     on s.SId = sc.SId
         and sc.score < 60
         and sc.CId = 01
order by sc.score desc;

# Q13
# 按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩
# 博主的实现似乎有些问题，个人觉得没有成绩的学生也要算
select *
from SC as sc
         left outer join (
    select sc.SId, avg(sc.score) as avscore
    from SC sc
    group by sc.SId
) as r on sc.SId = r.SId
order by avscore desc;

# Q14
# 查询各科成绩最高分、最低分和平均分，显示为：课程 ID，课程 name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
# 要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
# 使用case表达式
select sc.CId,
       max(sc.score)                                                                as 最高分,
       min(sc.score)                                                                as 最低分,
       AVG(sc.score)                                                                as 平均分,
       count(*)                                                                     as 选修人数,
       sum(case when sc.score >= 60 then 1 else 0 end) / count(*)                   as 及格率,
       sum(case when sc.score >= 70 and sc.score < 80 then 1 else 0 end) / count(*) as 中等率,
       sum(case when sc.score >= 80 and sc.score < 90 then 1 else 0 end) / count(*) as 优良率,
       sum(case when sc.score >= 90 then 1 else 0 end) / count(*)                   as 优秀率
from SC sc
GROUP BY sc.CId
ORDER BY count(*) DESC, sc.CId ASC;

# Q15
# 按各科成绩进行排序，并显示排名，Score重复时保留名次空缺
# 有一个自连接的小技巧，用sc中的score和自己进行对比，来计算“比当前分数高的分数有几个”
select sc1.CId,
       sc1.SId,
       sc1.score,
       count(sc2.score) + 1 as score_grade
from SC as sc1
         left outer join
     SC as sc2
     on sc1.score < sc2.score
         and sc1.CId = sc2.CId
group by sc1.CId,
         sc1.SId,
         sc1.score
order by sc1.CId,
         score_grade asc;

# Q15.1
# 按各科成绩进行行排序，并显示排名，Score重复时合并名次
# 所谓名次合并，意思是两个人的成绩一致按照一个名次来
select sc1.*, count(sc2.score) + 1 as score_rank
from SC as sc1
         left outer join SC as sc2
                         on sc1.CId = sc2.CId # 同科
                             and sc1.score < sc2.score
group by sc1.CId, sc1.SId, sc1.score
order by sc1.CId, score_rank;

# Q16
# 查询学生的总成绩，并进行排名，总分重复时不保留名次空缺
# 主要是变量的使用（这个变量的作用仅仅是计数器）
# 抄的
select t1.*, @rank := @rank + 1 as score_rank
from (
         select sc.SId,
                sum(sc.score) as sum_score
         from SC as sc
         group by sc.SId
         order by sum_score desc
     ) as t1,
     (select @rank := 0) as t2;

# Q17
# 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0]及所占百分比
# 思路和之前的一题一样，join+case计数
# 不要用单sc的group by，用sc join course，这才是关系表的意义
select sc.CId,
       c.Cname,
       sum(case when sc.score >= 0 and score < 60 then 1 else 0 end)                    as '[60-0]',
       sum(case when sc.score >= 0 and score < 60 then 1 else 0 end) / count(sc.SId)    as '[60-0]',
       sum(case when sc.score >= 60 and score < 70 then 1 else 0 end)                   as '[70-60]',
       sum(case when sc.score >= 60 and score < 70 then 1 else 0 end) / count(sc.SId)   as '[70-60]百分比',
       sum(case when sc.score >= 70 and score < 85 then 1 else 0 end)                   as '[85-70]',
       sum(case when sc.score >= 70 and score < 85 then 1 else 0 end) / count(sc.SId)   as '[85-70]百分比',
       sum(case when sc.score >= 85 and score <= 100 then 1 else 0 end)                 as '[100-85]',
       sum(case when sc.score >= 85 and score <= 100 then 1 else 0 end) / count(sc.SId) as '[100-85]百分比'
from SC as sc
         inner join Course as c
                    on sc.CId = c.CId
group by sc.CId, c.Cname;

# Q18
# 查询各科成绩前三名的记录
# mysql不能group by了以后取limit
# 这里还是老套路，也就是所谓的基于字交的横向扩展
select sc1.*, count(sc2.score) + 1 as 'c_score_rank'
from SC as sc1
         left join
     SC as sc2
     on sc1.CId = sc2.CId # 这两行是关键，保留比当前成绩高的记录，这样就很容易算出当前成绩是多少名了
         and sc1.score < sc2.score
group by sc1.SId, sc1.CId, sc1.score
having c_score_rank < 4
order by sc1.CId, c_score_rank;

# Q19
# 查询每门课程被选修的学生数
# 很基本操作，分组即可
# 之前Q1-Q18是简单到难，Q19开始循环
select sc.CId, count(sc.SId) as 'sum_stu'
from SC as sc
group by sc.CId;

# 20
# 查询出只选修两门课程的学生学号和姓名
# 简单，直接join即可
# 善用having可以少写很多条件，但是要当心，having是发生在拼表结束后的
select s.SId, s.Sname
from Student as s
         inner join SC as sc
                    on s.SId = sc.SId
group by sc.SId, s.Sname
having count(sc.CId) = 2;

# Q21
# 查询男生、女生人数
# 方案1：分组count，产生纵向表
select s.Ssex, count(s.SId)
from Student as s
group by s.Ssex;
# 方案2：case，产生横向表
select sum(case when s.Ssex = '男' then 1 else 0 end) as 'male_stu',
       sum(case when s.Ssex = '女' then 1 else 0 end) as 'female_stu'
from Student as s;
# 本题解法很多，方案2也可以count-male_stu
# etc

# Q22
# 查询名字中含有“风”字的学生信息
# 简单，通配符
SELECT *
FROM Student s
WHERE s.Sname LIKE '%风%';

# Q23
# 查询同名学生名单，并统计同名人数
select s.Sname, count(*)
from Student s
group by s.Sname
having count(*) > 1;

# Q24
# 查询1990年出生的学生名单
# 使用标准函数year()
select *
from Student as s
where year(s.Sage) = 1990;

# Q25
# 查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select c.CId, c.Cname, avg(sc.score) as 'average_score'
from Course as c
         inner join SC as sc
                    on c.CId = sc.CId
group by c.CId, c.Cname
order by average_score desc, c.CId;

# Q26
# 查询平均成绩大于等于85的所有学生的学号，姓名和平均成绩
# 使用having截取结果表（注意这里的措辞）
select s.SId, s.Sname, avg(sc.score) as 'average_score'
from Student as s
         inner join SC as sc
                    on s.SId = sc.SId
group by s.SId, s.Sname
having average_score >= 85;

# Q27
# 查询课程名称为“数学”，且分数低于60的学生姓名和分数
# 三表联合查询，注意dbms对join有优化
# 注意多重join的语法细节
select s.Sname, sc.score
from Student as s
         inner join SC as sc
                    on s.SId = sc.SId
         inner join Course as c
                    on sc.CId = c.CId
                        and c.Cname = '数学'
                        and sc.score < 60;

# Q28
# 查询所有学生的课程及分数情况（存在学生没成绩，没选课的情况）
select s.SId, s.Sname, sc.CId, sc.score
from Student as s
         left join SC sc
                   on s.SId = sc.SId;

# Q29
# 查询任何一门课程成绩在70分以上的姓名，课程名称和分数
# 小心优化https://zhuanlan.zhihu.com/p/72223558 Q29
select s.Sname, c.Cname, sc.score
from Student as s
         inner join SC sc
                    on s.SId = sc.SId
                        and sc.score > 70
         inner join Course as c
                    on sc.CId = c.CId;

# Q30
# 查询存在不及格的课程
# group或distinct都行
select distinct sc.CId
from SC as sc
where sc.score < 60;

# Q31
# 查询课程编号为01且课程成绩在80分及以上的学生的学号和姓名
select s.SId, s.Sname
from Student as s
         inner join SC as sc
                    on s.SId = sc.SId
where sc.CId = 01
  and sc.score >= 80;
# 比较上下两种写法的区别
select s.SId, s.Sname
from Student as s
         inner join SC as sc
                    on s.SId = sc.SId
                        and sc.CId = 01
                        and sc.score >= 80;

# Q32
# 求每门课程的学生人数
# 未考虑sid重复问题
select sc.CId, count(sc.SId) as 'stu_count'
from SC as sc
group by sc.CId;

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

# Q34
# 成绩有重复的情况下，查询选修“张三”老师所授课程的学生中，成绩最高的学生信息及其成绩
# 还是老规矩，自交比大小
# 与Q33类似，略

# Q35
# 查询不同课程成绩相同的学生的学生编号，课程编号，学生成绩
# 方案还是自交，但是会有重复数据，也就是01=03和03=01，通过分组或dist来去重
SELECT DISTINCT sc1.*
FROM SC AS sc1
         INNER JOIN SC AS sc2
WHERE sc1.score = sc2.score
  AND sc1.cid != sc2.cid;

# Q36
# 查询每门功成绩最好的前两名
# 考虑并列的情况
select sc1.CId, sc1.SId, sc1.score, count(sc2.score) + 1 as 'score_rank'
from SC as sc1
         left join SC as sc2
                   on sc1.CId = sc2.CId
                       and sc1.score < sc2.score
group by sc1.CId, sc1.SId, sc1.score
having score_rank <= 2
order by sc1.CId, sc1.score desc;

# Q37
# 统计每门课程的学生选修人数（超过5人的课程才统计）
select sc.CId, count(sc.SId) as 'count_stu'
from SC as sc
group by sc.CId
having count_stu > 5;

# Q38
# 检索至少选修两门课程的学生学号
select sc.SId, count(sc.CId) as 'count_course'
from SC as sc
group by sc.SId
having count_course >= 2;

# Q39
# 查询选修了全部课程的学生信息
# 这里用了一次简单的子查询
select s.SId, s.Sname
from Student as s
         inner join SC as sc
                    on s.SId = sc.SId
group by s.SId, s.Sname
having count(sc.CId) = (
    select count(*)
    from Course
);

# Q40
# 查询各学生的年龄，只按年份来算
# 本题开始考察时间函数
SELECT sname,
       YEAR(NOW()) - YEAR(sage) AS 'age'
FROM Student;

# Q41
# 按照出生日期来算，当前月日<出生年月的月日则，年龄减一
# 函数或case都可以
select s.SId                                  as 学生编号,
       s.Sname                                as 学生姓名,
       TIMESTAMPDIFF(YEAR, s.Sage, CURDATE()) as 学生年龄
from Student as s;

# Q42
# 查询本周过生日的学生
select *
from Student as s
where WEEKOFYEAR(s.Sage) = WEEKOFYEAR(CURDATE());

# Q43
# 查询下周过生日的学生
select *
from Student as s
where WEEKOFYEAR(s.Sage) = WEEKOFYEAR(CURDATE()) + 1;

# Q44
# 查询本月过生日的学生
select *
from Student as s
where MONTH(s.Sage) = MONTH(CURDATE());

# Q45
# 查询下月过生日的学生
select *
from Student as s
where MONTH(s.Sage) = MONTH(CURDATE()) + 1;

