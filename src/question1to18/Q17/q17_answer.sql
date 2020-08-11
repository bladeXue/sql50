# Q17
# 统计各科成绩各分数段人数：课程编号，课程名称，[100-85]，[85-70]，[70-60]，[60-0]及所占百分比
# 思路和之前的一题一样，join+case计数
# 不要用单sc的group by，用sc join course，这才是关系表的意义
select sc.CId,
       c.Cname,
       sum(IF(sc.score >= 0 and score < 60, 1, 0))                                      as '[60-0]',
       sum(IF(sc.score >= 0 and score < 60, 1, 0)) / count(sc.SId)                      as '[60-0]',
       sum(IF(sc.score >= 60 and score < 70, 1, 0))                                     as '[70-60]',
       sum(IF(sc.score >= 60 and score < 70, 1, 0)) / count(sc.SId)                     as '[70-60]百分比',
       sum(IF(sc.score >= 70 and score < 85, 1, 0))                                     as '[85-70]',
       sum(IF(sc.score >= 70 and score < 85, 1, 0)) / count(sc.SId)                     as '[85-70]百分比',
       sum(IF(sc.score >= 85 and score <= 100, 1, 0))                                   as '[100-85]',
       sum(IF(sc.score >= 85 and score <= 100, 1, 0)) / count(sc.SId) as '[100-85]百分比'
from SC as sc
         inner join Course as c
                    on sc.CId = c.CId
group by sc.CId, c.Cname;