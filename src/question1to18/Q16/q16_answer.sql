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