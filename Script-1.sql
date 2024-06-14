with
vars(catid) as (
values ('/2389/%')
),
vars2(catid2) as (
values ('/2389%')
),
x as
(select
count(distinct mu.id) students, to_char(to_timestamp(ue.timecreated)::date,'YYYY') enrolment_year
from {user} mu
join {user_enrolments} ue on mu.id = ue.userid
join {enrol} en on ue.enrolid = en.id
join {role_assignments} mra on mu.id = mra.userid
join {context} mc2 on mra.contextid = mc2.id
join {course} mc on mc.id = mc2.instanceid and mc.id = en.courseid
join {course_categories} mcc on mcc.id = mc.category
where mra.roleid = 5
and (mcc.path like (select catid from vars) or mcc.path like (select catid2 from vars2))
and (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%')
and (mcc.name not ilike '%sandbox%' and mcc.name not ilike 'sandpit')
group by enrolment_year
),
y as
(select  count(distinct mu.id) teachers, to_char(to_timestamp(ue.timecreated)::date,'YYYY') enrolment_year
from {user} mu
join {user_enrolments} ue on mu.id = ue.userid
join {enrol} en on ue.enrolid = en.id
join {role_assignments} mra on mu.id = mra.userid
join {context} mc2 on mra.contextid = mc2.id
join {course} mc on mc.id = mc2.instanceid and mc.id = en.courseid
join {course_categories} mcc on mcc.id = mc.category
where mra.roleid = 3
and (mcc.path like (select catid from vars) or mcc.path like (select catid2 from vars2))
and (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%')
and (mcc.name not ilike '%sandbox%' and mcc.name not ilike 'sandpit')
group by enrolment_year
),
z as (
select count(mc.id) courses, to_char(to_timestamp(mc.startdate)::date,'YYYY') as year
from {course} mc
join {course_categories} mcc on mc.category = mcc.id
and (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%')
and (mcc.name not ilike '%sandbox%' and mcc.name not ilike 'sandpit')
and (mcc.path like (select catid from vars) or mcc.path like (select catid2 from vars2))
group by year
), final as
(
select sum(x.students) students, sum(y.teachers) teachers, sum(z.courses) courses, z.year from z
full outer join y on y.enrolment_year = z.year
full outer join x on x.enrolment_year = z.year
group by z.year
order by z.year
)
select final.year, final.courses total_courses, coalesce (final.teachers,0) total_teachers, coalesce (final.students,0) total_students  from final






