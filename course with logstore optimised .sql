with enrolment as  
(
select mue.userid userid, mc.id courseid, mc.fullname coursename, mcc.id catid, mcc.name catname, mc.startdate start_date, mc.enddate end_date, mc.visible
from mdl_user_enrolments mue 
join mdl_enrol en on mue.enrolid = en.id
join mdl_course mc on mc.id = en.courseid
join mdl_course_categories mcc on mcc.id = mc.category 
), 
roles as 
(
select mra.userid userid, mra.roleid roleid, mc.id courseid
from mdl_role_assignments mra 
left join mdl_context mc2 on mc2.id = mra.contextid 
right join mdl_course mc on mc.id = mc2.instanceid 
),
lastactivity as 
--activty last added
(select mcm.course courseid, max(to_timestamp(mcm.added)::date) last_activity_added  
from mdl_course_modules mcm 
group by mcm.course 
order by mcm.course
), 
 lastedited as 
--activity last edited (COURSE CONTENT EDITED OR COUSE SETTING CHANGED)
(
select mlsl.courseid courseid, max(to_timestamp(mlsl.timecreated)::date) last_activity_edited 
from mdl_logstore_standard_log mlsl 
where (target = 'course_module' 
and action = 'updated'
)
group by courseid)
select concat(enrolment.catid, ' - ', enrolment.catname) category_id_name,  concat(enrolment.courseid, ' - ', enrolment.coursename) course_id_name, 
to_timestamp(enrolment.start_date)::date course_start, to_timestamp(enrolment.end_date)::date course_end,
case 
when enrolment.visible = 1 then 'open'
when enrolment.visible = 0 then 'hidden'
end course_state,
count(distinct enrolment.userid) total_users,
count(case when roles.roleid = 5 then 'students' end) student,
count(case when roles.roleid = 19 then 'teachers' end) teacher,
count(case when roles.roleid = 4 then 'non_editing_teachers' end) non_editing,
count(case when roles.roleid is null then 'others' end) no_or_other_roles, 
lastactivity.last_activity_added, lastedited.last_activity_edited,
concat('%%WWWROOT%%/course/management.php%%Q%%courseid=', enrolment.courseid) course_URL
from enrolment
left join roles on enrolment.courseid = roles.courseid and enrolment.userid = roles.userid
left join lastedited on enrolment.courseid = lastedited.courseid
left join lastactivity on enrolment.courseid = lastactivity.courseid
where enrolment.courseid is not null
group by  enrolment.courseid, enrolment.coursename, enrolment.catid, enrolment.catname, enrolment.visible, lastactivity.last_activity_added, lastedited.last_activity_edited, enrolment.start_date, enrolment.end_date
order by enrolment.courseid 

