with enrolment as  
(
select mue.userid userid, mc.id courseid, mc.fullname coursename, mc.timecreated, mcc.id catid, mcc.timemodified, mcc.name catname, mc.startdate start_date, to_char(to_timestamp(mc.enddate),'YYYY-MM-DD') end_date, mc.visible
from mdl_user_enrolments mue 
left join mdl_enrol en on mue.enrolid = en.id
full outer join mdl_course mc on mc.id = en.courseid
join mdl_course_categories mcc on mcc.id = mc.category 
--where mcc.path like '/42%'
), 
roles as 
(
select mra.userid userid, mra.roleid roleid, mc.id courseid, mu.email
from mdl_role_assignments mra 
join mdl_context mc2 on mc2.id = mra.contextid 
join mdl_course mc on mc.id = mc2.instanceid 
join mdl_user mu on mu.id = mra.userid 
--and mc2.contextlevel = 50
),
teacher as 
(
select coalesce(count(distinct roles.userid),0) teachers, roles.courseid from roles where roles.roleid = 3 group by roles.courseid
),
emailagg as 
(
select roles.courseid, string_agg(roles.email, ' / ') as teachers from roles where roles.roleid = 3 group by roles.courseid  
),
lastactivity as 
--activty last added
(select mcm.course courseid, timezone('AEST', max(to_timestamp(mcm.added)))::date last_activity_added  
from mdl_course_modules mcm 
group by mcm.course 
order by mcm.course
), 
 lastedited as 
--activity last edited (COURSE CONTENT EDITED OR COUSE SETTING CHANGED)
(
select mlsl.courseid courseid, timezone('AEST', max(to_timestamp(mlsl.timecreated)))::date last_activity_edited 
from mdl_logstore_standard_log mlsl 
where (target = 'course_module' 
and action = 'updated')
group by courseid
), 
--course completion table - to exclude completions for previous enrolments, join completion table user to currently enrolled table and 
--pull only student users (test completions appear in the completion table, teacher changes to student and completes the activity)
--no alternative than to use to sub-query 
completion as 
(
select mcc.course, (count(mcc.timecompleted))::text completions 
from mdl_course_completions mcc 
join 
(
select 
mue.userid userid, me.courseid course
from 
mdl_user_enrolments mue  
join mdl_enrol me on me.id = mue.enrolid 
) a 
on mcc.userid = a.userid 
and mcc.course = a.course
join mdl_role_assignments ra
on ra.userid = a.userid
join mdl_context c 
on ra.contextid = c.id and c.instanceid = a.course
where ra.roleid = 5
group by mcc.course
)
-- commented as it's a logstore query
/*creator as 
(
select mlsl.courseid, mu.email 
from mdl_logstore_standard_log mlsl 
join mdl_user mu on mlsl.userid = mu.id
where action = 'created' and target = 'course'
),*/
-- coursesize table not available in 3.x moodle
/*coursesize as 
(
select mrc.course, --concat((mrc.filesize::float)/(power(1024,3)), ' gb')
case 
when length(mrc.filesize::text) >= 10 then concat((mrc.filesize::float)/(power(1024,3)), ' gb')
when length(mrc.filesize::text) between 7 and 9 then concat((mrc.filesize::float)/(power(1024,2)), ' mb')
when length(mrc.filesize::text) <= 6 then concat((mrc.filesize::float)/(1024), ' kb')
end coursesize
from mdl_report_coursesize mrc
order by mrc.filesize desc
)*/
select concat(enrolment.catid, ' - ', enrolment.catname) category_id_name,  concat(enrolment.courseid, ' - ', enrolment.coursename) course_id_name, 
/*creator.email course_creator,*/ timezone('AEST', to_timestamp(enrolment.timecreated))::date create_date, timezone('AEST', to_timestamp(enrolment.start_date))::date course_start, 
case 
when enrolment.end_date = '1970-01-01' then 'NA'
when enrolment.end_date <> '1970-01-01' then enrolment.end_date
end course_end,
case 
when enrolment.visible = 1 then 'open'
when enrolment.visible = 0 then 'hidden'
end course_state,/* coursesize.coursesize,*/
emailagg.teachers teacher_email,
count(distinct enrolment.userid) total_users,
count(case when roles.roleid = 5 then 'students' end) student,
coalesce(teacher.teachers,0) teacher,
count(case when roles.roleid = 4 then 'non_editing_teachers' end) non_editing,
count(case when roles.roleid is null and enrolment.userid is not null then 'others' end) no_roles, 
case 
when completion.completions is null then '0'
when completion.completions is not null then completion.completions
end completions,
coalesce (lastactivity.last_activity_added::varchar,'na') last_activity_added, 
coalesce (lastedited.last_activity_edited::varchar,'na') last_activity_edited,
concat('%%WWWROOT%%/course/view.php%%Q%%id=', enrolment.courseid) course_URL
from enrolment
left join roles on enrolment.courseid = roles.courseid and enrolment.userid = roles.userid
left join lastedited on enrolment.courseid = lastedited.courseid
left join lastactivity on enrolment.courseid = lastactivity.courseid
left join completion on completion.course = enrolment.courseid
left join teacher on enrolment.courseid = teacher.courseid 
/*left join creator on creator.courseid = enrolment.courseid */
/*left join coursesize on coursesize.course = enrolment.courseid*/
left join emailagg on emailagg.courseid = enrolment.courseid 
--where enrolment.courseid is not null
group by  enrolment.courseid, enrolment.coursename, enrolment.catid, enrolment.catname, enrolment.visible, lastactivity.last_activity_added, 
lastedited.last_activity_edited, enrolment.start_date, enrolment.end_date, /*creator.email, *//*coursesize.coursesize,*/ enrolment.timecreated, 
completion.completions, teacher.teachers, emailagg.teachers
order by enrolment.courseid 

 




