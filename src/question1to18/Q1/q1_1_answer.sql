# Q1.1
# 查询同时存在"01"课程和"02"课程的情况
# 注意查找效率，每次生成的关系表越小越好
select *
from (select * from SC as sc where sc.CId = '01') as t1,
     (select * from SC as sc where sc.CId = '02') as t2
where t1.SId = t2.SId;
