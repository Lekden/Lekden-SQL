select 
u.id, 
u.email,
ra.roleid,
timezone('AEST', to_timestamp(u.lastaccess))::date
from mdl_user u,
mdl_role_assignments ra
where u.id = ra.userid
and ra.roleid = 3
and timezone('AEST', to_timestamp(u.lastaccess))::date <= now() - interval '6 months'

select 