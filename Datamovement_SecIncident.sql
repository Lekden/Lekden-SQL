


select z.*, zz.groupid, zz.group_added from 
(select
mu.id userid, mu.username wrong_username, mc.id courseid, mc.fullname, to_timestamp(mcc2.timecompleted)::date course_completion_date,  to_timestamp(ue.timecreated)::date enrolment_date, x.activity_id, 
x.activity_completed
from mdl_user mu
join mdl_user_enrolments ue on mu.id = ue.userid
join mdl_enrol en on ue.enrolid = en.id
join mdl_course mc on mc.id = en.courseid
left join mdl_course_completions mcc2 on mcc2.userid = mu.id and mcc2.course = mc.id 
left join 
(select mcm.id activity_id, mcm.course course, mcmc.userid userid, to_timestamp(mcmc.timemodified) activity_completed  
from  mdl_course_modules_completion mcmc
join mdl_course_modules mcm on mcm.id = mcmc.coursemoduleid) x 
on mc.id = x.course and mu.id = x.userid) z 
join 
(select mg.id groupid, mg.name group_name, to_timestamp(mgm.timeadded) group_added , mgm.userid userid, mg.courseid courseid
from mdl_groups mg
join mdl_groups_members mgm on mgm.groupid = mg.id) zz
on z.userid = zz.userid and z.courseid = zz.courseid
where 
z.wrong_username in ('')
and z.courseid in ('2')
and zz.group_added > '2023-06-13 09:20:00'
and z.activity_completed > '2023-06-13 09:20:00'


select * from mdl_course_completions mcc 
