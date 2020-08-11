# Q6
# 查询学过 张三 老师授课的同学的信息
# 多表联合查询。多表慎用，因为数据规模会迅速变大，不少DBMS都有表数限制
select s.*
from Student as s,
     Teacher as t,
     Course as c,
     SC as sc
where s.sid = sc.sid
  and c.cid = sc.cid
  and c.tid = t.tid
  and tname = '张三';
