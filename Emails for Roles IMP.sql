
with x as 
(
select count(mc.id) count, mcc.id category, mcc1.id parent_category, timezone('AEST',to_timestamp(mcc.timemodified))::date date_modified  from mdl_course_categories mcc 
left join mdl_course mc on mcc.id = mc.category 
left join mdl_course_categories mcc1 on  mcc1.id = mcc.parent 
group by mcc.id, mcc1.id
), 
courses as
(
select x.count total_courses, x.category categoryid, x.date_modified date_modified, 
mcc2.name as category_name, x.parent_category parent_category_id, mcc3.name as parent_category_name from x
left join mdl_course_categories mcc2 on mcc2.id = x.category
left join mdl_course_categories mcc3 on mcc3.id =  x.parent_category
), 
users as 
(
select count(distinct mu.id) total_users, mcc4.id zid 
from mdl_user mu
left join mdl_user_enrolments mue on mue.userid = mu.id 
left join mdl_enrol me on me.id = mue.enrolid 
left join mdl_course mc1 on mc1.id = me.courseid
left join mdl_course_categories mcc4 on mcc4.id = mc1.category
--where (mcc4.path like (select catpath from vars) or mcc4.path like (select catpath2 from vars2))
group by mcc4.id
), 
total as 
(
select distinct mra.userid userid, mcc.id catid, mra.roleid roleid, mu.email email
from  mdl_role_assignments mra 
left join mdl_context ctx on ctx.id = mra.contextid 
left join mdl_course mc on mc.id = ctx.instanceid  
left join mdl_course_categories mcc on mcc.id = mc.category   
left join mdl_user mu on mu.id = mra.userid 
),
students as 
(
select count(total.userid) count, total.catid catid from total where total.roleid = 5 group by total.catid
),
teachers as
(
--select count(total.userid) count, total.catid catid from total where total.roleid = 3 group by total.catid
select  string_agg(total.email, ' / ') as teachers, total.catid from total where total.roleid = 3 group by total.catid  
),
noneditteachers as
(
--select count(total.userid) count, total.catid catid from total where total.roleid = 4 group by total.catid
select total.catid, string_agg(total.email, ' / ') as noneditingteachers from total where total.roleid = 4 group by total.catid 
),
slcm as 
( 
select string_agg(distinct mu.email, '/') slcms, mcc.id catid
from mdl_role_assignments mra 
left join mdl_context mc on mc.id = mra.contextid 
left join mdl_course_categories mcc on mcc.id = mc.instanceid
left join mdl_user mu on mu.id = mra.userid 
where mra.roleid = 9
group by mcc.id
)
select courses.categoryid categoryid, courses.category_name categoryname, concat (coalesce (courses.parent_category_id, 0),'/', courses.parent_category_name) 
as parentcategory_id_name, coalesce(courses.total_courses,0) totalcourses, coalesce(users.total_users,0) users, coalesce(students.count,0) student, teachers.teachers teacher,
noneditteachers.noneditingteachers nonediting, slcm.slcms slcm, concat('%%WWWROOT%%/course/management.php%%Q%%categoryid=', courses.categoryid) category_link 
from courses
left join users on courses.categoryid = users.zid
left join students on courses.categoryid = students.catid
left join teachers on courses.categoryid = teachers.catid
left join noneditteachers on courses.categoryid = noneditteachers.catid
left join slcm on courses.categoryid = slcm.catid
left join total on total.catid = courses.categoryid 
--do not return rows that have zero student enrolment 
--where students.count is not null 
group by courses.categoryid, courses.category_name, courses.parent_category_id, courses.parent_category_name, courses.total_courses, users.total_users, students.count, teachers.teachers, 
noneditteachers.noneditingteachers, slcm.slcms
order by courses.categoryid
 