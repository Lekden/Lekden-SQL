select to_timestamp(mlsl.timecreated)::time date
from mdl_logstore_standard_log mlsl 



--version 1 -- good to learn queries 
select mu.id, mu.username, concat(mu.firstname||' '||mu.lastname) admin_name, mlsl.eventname, mlsl."action", to_timestamp(mlsl.timecreated) Date_time_created, 
to_char(timezone('AEDT',to_timestamp(mlsl.timecreated)),'hh24.mi.ss') as time
from mdl_user mu 
join mdl_logstore_standard_log mlsl on mu.id = mlsl.userid 
where mu.id IN
(select cast(unnest(string_to_array(value, ',')) as integer) userid FROM mdl_config mc
where name ilike 'siteadmins')
and mlsl."action" ilike '%loggedin%'
and to_timestamp(mlsl.timecreated) >= now() - interval '30 days'
--and to_char((to_timestamp(mlsl.timecreated)),'hh24.mi.ss') < '07.00.00' or to_char((to_timestamp(mlsl.timecreated)),'hh24.mi.ss') > '21.00.00'




--Note for self *** change interval and time operaters in where clause after testing 
-- keep only one timestamp
select mu.id userid, mu.username, concat(mu.firstname||' '||mu.lastname) admin_name, mlsl."action", timezone('AEDT',to_timestamp(mlsl.timecreated))::date as date, timezone('AEDT', to_timestamp(mlsl.timecreated))::time as time, mlsl.ip 
from mdl_user mu 
join mdl_logstore_standard_log mlsl on mu.id = mlsl.userid 
where mu.id IN
(select cast(unnest(string_to_array(value, ',')) as integer) userid FROM mdl_config mc
where name ilike 'siteadmins')
and mlsl."action" ilike '%loggedin%'
and timezone('AEDT',to_timestamp(mlsl.timecreated))::date >= now() - interval '2 days'
and 
((timezone('AEDT',to_timestamp(mlsl.timecreated))::time < '07:00:00' or timezone('AEDT',to_timestamp(mlsl.timecreated))::time > '21:00:00')
or 
mlsl.ip not in (
select mlsl.ip from mdl_user as mu
join mdl_logstore_standard_log mlsl on mu.id = mlsl.userid 
where mu.id IN
(select cast(unnest(string_to_array(value, ',')) as integer) userid FROM mdl_config mc
where name ilike 'siteadmins') 
and timezone('AEDT',to_timestamp(mlsl.timecreated))::date  <= now() - interval '2 days' and  timezone('AEDT',to_timestamp(mlsl.timecreated))::date >= now() - interval '5 days'
and mlsl.ip != '203.6.69.62'
order by mlsl.timecreated  desc))

