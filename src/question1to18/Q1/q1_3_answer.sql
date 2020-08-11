# 1.3
# 查询不存在"01"课程但存在"02"课程的情况
select *
from SC as sc
where sc.SId not in (
    select SId
    from SC as sc
    where sc.CId = '01'
)
  AND sc.CId = '02';
