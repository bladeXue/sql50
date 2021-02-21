# Q29
# 查询任何一门课程成绩在70分以上的姓名，课程名称和分数
# 小心优化https://zhuanlan.zhihu.com/p/72223558 Q29
select s.Sname,
       c.Cname,
       sc.score
from Student as s
         inner join
     SC as sc on s.SId = sc.SId and sc.score > 70
         inner join
     Course as c on sc.CId = c.CId;

# +-----+-----+-----+
# |Sname|Cname|score|
# +-----+-----+-----+
# |赵雷   |英语   |99.0 |
# |赵雷   |数学   |90.0 |
# |赵雷   |语文   |80.0 |
# |钱电   |英语   |80.0 |
# |孙风   |英语   |80.0 |
# |孙风   |数学   |80.0 |
# |孙风   |语文   |80.0 |
# |周梅   |数学   |87.0 |
# |周梅   |语文   |76.0 |
# |郑竹   |英语   |98.0 |
# |郑竹   |数学   |89.0 |
# +-----+-----+-----+

