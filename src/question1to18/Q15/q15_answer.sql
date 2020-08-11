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

