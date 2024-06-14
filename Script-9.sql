with x (var1, var2) as (
   values ('/3%', '/3%')
), 
main as 
(
select mu.id userid, mu.email email, mcc.id catid, mc2.id course, mc2.fullname, mcc2.id catid2, mra.roleid roleid, mr.name role_name, 
case when mu.suspended = 0 then 'a'
     when mu.suspended = 1 then 's' end status
from mdl_role_assignments mra 
join mdl_context mc on mc.id = mra.contextid 
left join mdl_course mc2 on mc2.id  = mc.instanceid and mc.contextlevel = 50
left join mdl_course_categories mcc on mcc.id = mc.instanceid and mc.contextlevel = 40 
left join mdl_course_categories mcc2 on mc2.category = mcc2.id 
left join mdl_user mu on mu.id = mra.userid 
left join mdl_role mr on mra.roleid = mr.id 
--where (mcc2."path" like (select var1 from x) or mcc.path like (select var1 from x))
--and 
where mra.roleid != 5
)
--select string_agg(concat(a.email,'(',main.status,')'), ' / ') email from (
select distinct main.email email, main.catid2 catid from main where main.roleid = 3 group by main.catid2
--)a
