# Q36
# 查询每门功成绩最好的前两名
# 考虑并列的情况
# Q15的延伸
select sc1.CId,
       sc1.SId,
       sc1.score,
       count(sc2.score) + 1 as 'score_rank'
from SC as sc1
         left join
     SC as sc2 on sc1.CId = sc2.CId and
                  sc1.score < sc2.score
group by sc1.CId,
         sc1.SId,
         sc1.score
having score_rank <= 2
order by sc1.CId,
         sc1.score desc;

# +---+---+-----+----------+
# |CId|SId|score|score_rank|
# +---+---+-----+----------+
# |01 |01 |80.0 |1         |
# |01 |03 |80.0 |1         |
# |02 |01 |90.0 |1         |
# |02 |07 |89.0 |2         |
# |03 |01 |99.0 |1         |
# |03 |07 |98.0 |2         |
# +---+---+-----+----------+

