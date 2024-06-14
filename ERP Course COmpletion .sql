select * from mdl_course_completions mcc 
join mdl_user mu on mcc.userid = mu.id 
join mdl_course mc on mcc.course = mc.id 
where 
to_timestamp(mcc.timecompleted) >= now() - interval '7 days'


select mcc.*,  to_char(timezone('AEDT',to_timestamp(mcc.timecompleted)),'yyyy-mm-dd HH24:MI:SS') timecompleteda,  
to_char(timezone('AEDT',to_timestamp(mcc.reaggregate)),'yyyy-mm-dd HH24:MI:SS') timereaggregated from mdl_course_completions mcc where mcc.course =16


select 
mcc2.id categoryid, mcc2."name" category, mc.id course_id, 
mc.fullname course,  mu.id userid, mu.email user_email,
 to_char(timezone('AEDT',to_timestamp(mcc.timecompleted)),'yyyy-mm-dd HH24:MI:SS')completion_date,  
row_number() over (order by mc.id)
from mdl_course_completions mcc 
join mdl_user mu on mcc.userid = mu.id 
join mdl_course mc on mcc.course = mc.id 
join mdl_course_categories mcc2 on mc.category = mcc2.id 
where 
to_timestamp(mcc.timecompleted) >= now() - interval '7 days'




select mcc.name,  mc2.id cohortid , mc2."name", mc2.idnumber, count(mcm.userid) usercount
from mdl_context mc 
join mdl_course_categories mcc on mcc.id = mc.instanceid 
join mdl_cohort mc2 on mc2.contextid = mc.id 
join mdl_cohort_members mcm on mcm.cohortid = mc2.id 
where mc.contextlevel = 40
group by mcc.id, mcc.name, mc2.id, mc2.name, mc2.idnumber 
