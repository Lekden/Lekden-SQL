with
vars(catid) as (
values ('/2/%')
),
vars2(catid2) as (
values ('/2%')
),
x as (
select
distinct mu.id id,
mra.roleid roleid,
to_char(to_timestamp(ue.timecreated)::date,
'YYYY') enrolment_year
from
mdl_user mu
join mdl_user_enrolments ue on
mu.id = ue.userid
join mdl_enrol en on
ue.enrolid = en.id
join mdl_role_assignments mra on
mu.id = mra.userid
join mdl_context mc2 on
mra.contextid = mc2.id
join mdl_course mc on
mc.id = mc2.instanceid
and mc.id = en.courseid
join mdl_course_categories mcc on
mcc.id = mc.category
where
(mcc.path like (
select
catid
from
vars)
or mcc.path like (
select
catid2
from
vars2))
and (mc.fullname not ilike '%sandbox%'
and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%' and mcc.name not ilike '%sandbox%'
and mcc.name not ilike '%sandpit%' and mcc.name not ilike '%deleted%' 
and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%' and mcc.name not ilike '%sandbox%'
and mcc.name not ilike '%sandpit%' and mcc.name not ilike '%delet%' and mcc.name not ilike '%archive%')
),
student as (
select
count (x.id) total_students,
x.enrolment_year
from
x
where
x.roleid = 5
group by
x.enrolment_year
),
teacher as (
select
count (x.id) total_teachers,
x.enrolment_year
from
x
where
x.roleid = 19
group by
x.enrolment_year
),
course as (
select
count(mc.id) courses,
to_char(to_timestamp(mc.startdate)::date,
'YYYY') as year
from
mdl_course mc
join mdl_course_categories mcc on
mc.category = mcc.id
where
(mc.fullname not ilike '%sandbox%'
and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%' and mcc.name not ilike '%sandbox%'
and mcc.name not ilike '%sandpit%' and mcc.name not ilike '%deleted%' 
and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%' and mcc.name not ilike '%sandbox%'
and mcc.name not ilike '%sandpit%' and mcc.name not ilike '%delet%' and mcc.name not ilike '%archive%')
and (mcc.path like (select catid from vars) or mcc.path like (select catid2 from vars2))
group by
year
)
select
course.year,
course.courses courses,
coalesce (teacher.total_teachers,0) teachers,
coalesce (student.total_students,0) students
from
course
full outer join student on
student.enrolment_year = course.year
full outer join teacher on
teacher.enrolment_year = course.year
order by
course.year
