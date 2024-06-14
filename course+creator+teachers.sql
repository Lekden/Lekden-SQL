with coursem as (
select x.*, mu.username course_creator  from 
(select mcc.id cat_id, mcc.name category_name, mc.id course_id, mc.fullname course_name,
string_agg(mu.username, ', ') teachers,
to_timestamp(mc.timecreated) course_created 
		from mdl_user mu
		join mdl_role_assignments mra on mu.id = mra.userid 
		join mdl_context mc2 on mra.contextid = mc2.id
		join mdl_course mc on mc.id = mc2.instanceid
		join mdl_course_categories mcc on mcc.id = mc.category
where mcc.path ilike '/2%'
and mra.roleid = 3
group by  mcc.id, mcc.name, mc.id, mc.fullname
) x 
join mdl_logstore_standard_log mlsl on mlsl.courseid = x.course_id
join mdl_user mu on mu.id = mlsl.userid
where (mlsl.target ilike 'course' and mlsl."action" ilike 'created')
), 
activity as 
(
--condition = last updated, created or deleted
select max(to_timestamp(mlsl.timecreated)) last_activity_updated, mlsl.courseid courseid 
from mdl_logstore_standard_log mlsl
where mlsl.target ilike 'course_module' 
and action not ilike 'viewed' 
group by mlsl.courseid
)
select coursem.*, coalesce((activity.last_activity_updated)::text, 'no_action') from coursem
left join activity on coursem.course_id = activity.courseid




select * from mdl_enrol me 
