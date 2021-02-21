# Q35
# 查询不同课程成绩相同的学生的学生编号，课程编号，学生成绩
# 方案还是自交，但是会有重复数据，也就是c01=c03和c03=c01，通过分组或dist来去重
SELECT DISTINCT sc1.*
FROM SC AS sc1
         INNER JOIN
     SC AS sc2 ON sc1.score = sc2.score
WHERE sc1.cid <> sc2.cid;

# +---+---+-----+
# |SId|CId|score|
# +---+---+-----+
# |03 |03 |80.0 |
# |03 |02 |80.0 |
# |02 |03 |80.0 |
# |03 |01 |80.0 |
# |01 |01 |80.0 |
# +---+---+-----+

