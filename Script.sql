with x as 
(
select count(mc.id) count, mcc.id category, mcc1.id parent_category, timezone('AEST',to_timestamp(mcc.timemodified))::date date_modified  from mdl_course_categories mcc 
left join mdl_course mc on mcc.id = mc.category 
left join mdl_course_categories mcc1 on  mcc1.id = mcc.parent  
where (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%')
and (mcc.name not ilike '%sandbox%' and mcc.name not ilike '%sandpit%')
group by mcc.id, mcc1.id
), courses as (

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
where mcc4.path like :category_path
and (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%')
and (mcc.name not ilike '%sandbox%' and mcc.name not ilike '%sandpit%')
group by mcc4.id
), 
modules as 
(
select string_agg (concat(moddb.modulename ||'-'|| moddb.counts), ', ' ) top_3_activities, moddb.catid catid from 
(
select  modd.catid catid, modd.modname modulename, modd.modulecounts counts, row_number () over (partition by modd.catid order by modd.modulecounts desc) from 
(
select  mcc.id catid, m.name modname, count(cm.id) modulecounts
from mdl_course mc 
join mdl_course_modules as cm on cm.course = mc.id
join mdl_modules as m on cm.module = m.id
join mdl_course_categories mcc on mc.category = mcc.id
group by  mcc.id, modname
--order by mcc.id, modulecounts desc
) as modd
) as moddb
where row_number <= 3
group by catid
),
total as 
(
select distinct mra.userid userid, mcc.id catid, mra.roleid roleid
from  mdl_role_assignments mra 
left join mdl_context ctx on ctx.id = mra.contextid 
left join mdl_course mc on mc.id = ctx.instanceid  
left join mdl_course_categories mcc on mcc.id = mc.category    
where (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%')
and (mcc.name not ilike '%sandbox%' and mcc.name not ilike '%sandpit%')
),
students as 
(
select count(total.userid) count, total.catid catid from total where total.roleid = 5 group by total.catid
),
teachers as
(
select count(total.userid) count, total.catid catid from total where total.roleid = 19 group by total.catid
),
noneditteachers as
(
select count(total.userid) count, total.catid catid from total where total.roleid = 4 group by total.catid
),
slcm as 
( 
select count (distinct mu.id) count, mcc.id catid
from mdl_role_assignments mra 
left join mdl_context mc on mc.id = mra.contextid 
left join mdl_course_categories mcc on mcc.id = mc.instanceid
left join mdl_user mu on mu.id = mra.userid 
where mra.roleid = 20
group by mcc.id
),
report as (
select courses.categoryid categoryid, courses.category_name categoryname, concat (coalesce (courses.parent_category_id, 0),'/', courses.parent_category_name) as parentcategory_id_name, courses.total_courses totalcourses, users.total_users users, students.count student, teachers.count teacher, noneditteachers.count nonediting_teacher, slcm.count slcm, modules.top_3_activities, courses.date_modified datemodified
,concat('%%WWWROOT%%/course/management.php%%Q%%categoryid=', courses.categoryid) category_link 
from courses
join users on users.zid = courses.categoryid
left join modules on users.zid = modules.catid
left join students on users.zid = students.catid
left join teachers on users.zid = teachers.catid
left join noneditteachers on users.zid = noneditteachers.catid
left join slcm on users.zid = slcm.catid
order by courses.categoryid
)
select report.* from report 
union all
select null, '' , 'Total', sum(totalcourses), sum(users), sum(student),sum(teacher), sum(nonediting_teacher), sum(slcm), null, null, null from report
