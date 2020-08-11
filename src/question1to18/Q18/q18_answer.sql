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


