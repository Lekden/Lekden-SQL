select *, to_timestamp(mcc.timeenrolled)  from mdl_course_completions mcc 

select mu.id, mu.username, to_timestamp(mu.timecreated)  from mdl_user mu where to_timestamp(mu.timecreated) > '2023-07-28 11:53:25'


select mgm.userid, mu.email,  mg.id groupid, mg.name groupname, mc.id courseid, mc.fullname, to_timestamp(mgm.timeadded) groupadd_date 
from mdl_groups mg 
join mdl_course mc on mg.courseid = mc.id 
join mdl_groups_members mgm on mgm.groupid = mg.id 
join mdl_user mu on mu.id = mgm.userid 
where mc.id in ('2342','45786','45242','37239','24636','40353','30646','45025','41695','2361','2363','2362','6851','43114','12717')
and 
mu.email in (')
and to_timestamp(mgm.timeadded) > '2023-06-13 09:20:00'

select * from mdl_grade_grades mgg 