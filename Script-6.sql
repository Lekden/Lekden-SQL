-- get time of the last action in a sandbox course 
select * from 
(
select mc.id,mc.fullname, 
max(to_timestamp(mlsl.timecreated)) lastupdate, null as email
from mdl_logstore_standard_log mlsl
join mdl_course mc on mc.id = mlsl.courseid 
where mc.fullname ilike '% - sandbox'
group by mc.id, mc.fullname 
) x
where x.lastupdate < now() - interval '1 hours'
UNION
select mc.id, mc.fullname, null as lastupdate, concat(substring(mc.fullname from '[^ ]+'::text),'@defence.gov.au') email
from mdl_user mu
join mdl_user_enrolments mue on mu.id = mue.userid 
join mdl_enrol me on mue.enrolid = me.id 
join mdl_course mc on me.courseid = mc.id
where mc.fullname ilike '% - sandbox'
and (mu.email = concat(substring(mc.fullname from '[^ ]+'::text),'@defence.gov.au') and mu.suspended = 1)

