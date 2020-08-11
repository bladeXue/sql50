# Q1.2
# 查询存在"01"课程但可能不存在"02"课程的情况(不存在时显示为null)
select *
from (select * from SC as sc where sc.CId = '01') as t1
         left join
     (select * from SC as sc where sc.CId = '02') as t2
     on t1.SId = t2.SId;
