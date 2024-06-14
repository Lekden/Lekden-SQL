with x as 
(
select  mu.id userid, mc.id courseid, mc.fullname, mcc.name, mt.name, mra.*
		from mdl_user mu
		join mdl_user_enrolments ue on mu.id = ue.userid 
		join mdl_enrol en on ue.enrolid = en.id
		join mdl_role_assignments mra on mu.id = mra.userid 
		join mdl_context mc2 on mra.contextid = mc2.id
		join mdl_course mc on mc.id = mc2.instanceid and mc.id = en.courseid 
		join mdl_course_categories mcc on mcc.id = mc.category
		join mdl_tag_instance mti on mti.itemid = mc.id
		join mdl_tag mt on mt.id = mti.tagid
		where (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%'
		and mcc.name not like '%sandbox%' and mcc.name not ilike 'sandpit')
		and mt.name like :service_name
), 
instructor as (
select count(*) instructors, x.courseid courseid from x where x.roleid = 3 group by x.courseid
), 
student as (
select count(*) students, x.courseid courseid from x where x.roleid = 5 group by x.courseid
)
select instructor.instructors, student.students, instructor.courseid
from instructor
full outer join student on instructor.courseid = student.courseid 