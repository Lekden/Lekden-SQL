with enrolment as  
(
select mue.userid userid, mc.id courseid, mc.fullname coursename, mc.timecreated, mcc.id catid, mcc.timemodified, mcc.name catname, mc.startdate start_date, to_char(mc.enddate,'YYYY-MM-DD') end_date, mc.visible
from {user_enrolments} mue 
left join {enrol} en on mue.enrolid = en.id
full outer join {course} mc on mc.id = en.courseid
join {course_categories} mcc on mcc.id = mc.category 
), 
roles as 
(
select mra.userid userid, mra.roleid roleid, mc.id courseid
from {role_assignments} mra 
join {context} mc2 on mc2.id = mra.contextid 
join {course} mc on mc.id = mc2.instanceid 
--and mc2.contextlevel = 50
),
lastactivity as 
--activty last added
(select mcm.course courseid, timezone('AEST', max(to_timestamp(mcm.added)::date)) last_activity_added  
from {course_modules} mcm 
group by mcm.course 
order by mcm.course
), 
 lastedited as 
--activity last edited (COURSE CONTENT EDITED OR COUSE SETTING CHANGED)
(
select mlsl.courseid courseid, timezone('AEST', max(to_timestamp(mlsl.timecreated)::date)) last_activity_edited 
from {logstore_standard_log} mlsl 
where (target = 'course_module' 
and action = 'updated')
group by courseid
),
creator as 
(
select mlsl.courseid, mu.email 
from {logstore_standard_log} mlsl 
join {user} mu on mlsl.userid = mu.id
where action = 'created' and target = 'course'
),
coursesize as 
(
select mrc.course, --concat((mrc.filesize::float)/(power(1024,3)), ' gb')
case 
when length(mrc.filesize::text) >= 10 then concat((mrc.filesize::float)/(power(1024,3)), ' gb')
when length(mrc.filesize::text) between 7 and 9 then concat((mrc.filesize::float)/(power(1024,2)), ' mb')
when length(mrc.filesize::text) <= 6 then concat((mrc.filesize::float)/(1024), ' kb')
end coursesize
from {report_coursesize} mrc
order by mrc.filesize desc
)
select concat(enrolment.catid, ' - ', enrolment.catname) category_id_name,  concat(enrolment.courseid, ' - ', enrolment.coursename) course_id_name, creator.email course_creator, timezone('AEST', to_timestamp(enrolment.timecreated)::date) create_date, timezone('AEST', to_timestamp(enrolment.start_date)::date) course_start, 
case 
when enrolment.end_date = '1970-01-01' then 'NA'
when enrolment.end_date <> '1970-01-01' then enrolment.end_date
end course_end,
case 
when enrolment.visible = 1 then 'open'
when enrolment.visible = 0 then 'hidden'
end course_state, coursesize.coursesize,
count(distinct enrolment.userid) total_users,
count(case when roles.roleid = 36 then 'students' end) student,
count(case when roles.roleid = 34 then 'teachers' end) teacher,
count(case when roles.roleid = 35 then 'non_editing_teachers' end) non_editing,
count(case when roles.roleid is null then 'others' end) no_or_other_roles, 
lastactivity.last_activity_added, lastedited.last_activity_edited,
concat('%%WWWROOT%%/course/management.php%%Q%%courseid=', enrolment.courseid) course_URL
from enrolment
left join roles on enrolment.courseid = roles.courseid and enrolment.userid = roles.userid
left join lastedited on enrolment.courseid = lastedited.courseid
left join lastactivity on enrolment.courseid = lastactivity.courseid
left join creator on creator.courseid = enrolment.courseid 
left join coursesize on coursesize.course = enrolment.courseid
--where enrolment.courseid is not null
group by  enrolment.courseid, enrolment.coursename, enrolment.catid, enrolment.catname, enrolment.visible, lastactivity.last_activity_added, 
lastedited.last_activity_edited, enrolment.start_date, enrolment.end_date, creator.email, coursesize.coursesize, enrolment.timecreated
order by enrolment.courseid 

 





