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

