select distinct mu.id, mcc.id catid
from mdl_role_assignments mra 
left join mdl_context mc on mc.id = mra.contextid 
left join mdl_course_categories mcc on mcc.id = mc.instanceid
left join mdl_user mu on mu.id = mra.userid 
where mra.roleid = 20
--group by mcc.id


select mc.instanceid course, mf.filename  from mdl_files mf
join mdl_context mc on mf.contextid = mc.id 
join mdl_course mc2 on mc2.id = mc.instanceid 
where mc.contextlevel = 50


select mcm.*, to_timestamp(mcm.added)::date added from mdl_course_modules mcm where course = 3

select * from mdl_logstore_standard_log mlsl order by timecreated desc 


