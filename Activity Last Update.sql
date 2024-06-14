--Activity last added 
select mcm.course, max(to_timestamp(mcm.added)) last_activity_added  
from mdl_course_modules mcm 
group by mcm.course 
order by mcm.course  

--activity last edited (COURSE CONTENT EDITED OR COUSE SETTING CHANGED)

select mlsl.courseid, max(to_timestamp(mlsl.timecreated)) last_activity_edited 
from mdl_logstore_standard_log mlsl 
where target ilike 'course_module' 
and action ilike 'updated'
group by courseid 
order by courseid 

--activity last viewed (LAST AN ACVITITY HAS BEEN ACCESSED BY A USER)

select mlsl.courseid, max(to_timestamp(mlsl.timecreated)) last_activity_edited 
from mdl_logstore_standard_log mlsl 
where target ilike 'course_module' 
and action ilike 'viewed'
group by courseid 
order by courseid 