select mu.*, timezone('AEDT',to_timestamp(firstaccess))::date 
from mdl_user mu 
where timezone('AEDT',to_timestamp(firstaccess))::date >= '01/01/2023'
and  timezone('AEDT',to_timestamp(lastaccess))::date >= '01/01/2023'

select count(distinct userid) from mdl_logstore_standard_log mlsl 
where action = 'loggedin'
and  timezone('AEDT',to_timestamp(timecreated))::date between '2023-01-01' and '2023-10-31'

select distinct userid, timezone('AEDT',to_timestamp(timecreated))::date from mdl_logstore_standard_log mlsl 
where action = 'loggedin'
and  timezone('AEDT',to_timestamp(timecreated))::date between '2023-01-01' and '2023-10-31'