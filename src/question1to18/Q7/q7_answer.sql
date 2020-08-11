# Q7
# 查询没有学全所有课程的同学的信息
# 反向思考，全选课的同学之外就是没选全的
select *
from Student as s
where s.sid not in (
    select sc.sid
    from SC as sc
    group by sc.sid
    having count(sc.cid) = (select count(cid) from Course)
);