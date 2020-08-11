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
