# 1.3
# 查询不存在"01"课程但存在"02"课程的情况
# 采用子查询（联结也可以，但本题子查询简单）
select *
from SC as sc
where sc.SId not in (
    select SId
    from SC as sc
    where sc.CId = '01'
)
  AND sc.CId = '02';

# +---+---+-----+
# |SId|CId|score|
# +---+---+-----+
# |07 |02 |89.0 |
# +---+---+-----+

