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

