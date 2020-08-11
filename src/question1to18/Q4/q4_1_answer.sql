# Q4.1
# 查有成绩的学生信息
# 仔细区分IN和EXISTS的应用场景
# 小心ALIAS
select *
from Student as s
where SId in (select SId from SC);
# 或
select *
from Student as s
where exists(select sc.SId from SC as sc where s.SId = sc.SId);
