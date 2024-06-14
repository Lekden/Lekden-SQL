with x as  
(select 
c.catid catid, c.catname catname, c.courseid courseid, cname coursename, c.start_date, c.end_date,
count(distinct c.userid) total_users, 
count(case when c.roleid = 5 then 'students' end) student,
count(case when c.roleid = 3 then 'teachers' end) teacher,
count(case when c.roleid = 4 then 'non_editing_teachers' end) non_editing,
count(case when c.roleid is null then 'others' end) no_role, 
concat('%%WWWROOT%%/course/management.php%%Q%%courseid=', c.courseid) course_URL
from 
(
select distinct a.uid userid, a.cid courseid, a.cname cname, a.catid catid,a.catname catname, a.start_date, a.end_date, b.roleid roleid 
from
(select distinct ue.userid uid, en.courseid cid, mc.fullname cname, mcc.id catid, mcc.name catname, mc.startdate start_date, mc.enddate end_date
from mdl_user mu
join mdl_user_enrolments ue on mu.id = ue.userid 
join mdl_enrol en on ue.enrolid = en.id
join mdl_course mc on mc.id = en.courseid 
join mdl_course_categories mcc on mcc.id = mc.category 
--where mcc.path like '/2/%' or mcc.path like '/2%'
) a
left join 
(select distinct mu.id uid, mc.id cid,  mra.roleid roleid from mdl_user mu 
left join mdl_role_assignments mra on mu.id = mra.userid
left join mdl_context mc2 on mc2.id = mra.contextid 
left join mdl_course mc on mc.id = mc2.instanceid 
) b
 on a.cid = b.cid and a.uid = b.uid
) c
group by c.catid, c.catname, c.courseid, c.cname, c.start_date, c.end_date
order by c.catid
), 
y as 
--activty last added
(select mcm.course courseid, max(to_timestamp(mcm.added)::date) last_activity_added  
from mdl_course_modules mcm 
group by mcm.course 
order by mcm.course) 
select concat(x.catid, ' - ', x.catname) category_id_name, concat(x.courseid,' - ',x.coursename) course_id_name, 
timezone('AEST',to_timestamp(x.start_date))::date start_date,  
timezone('AEST',to_timestamp(x.end_date))::date  end_date, 
x.total_users, x.student, x.teacher, x.non_editing, x.no_role,y.last_activity_added, x.course_url
from x
left join y on y.courseid = x.courseid 
order by x.courseid 

