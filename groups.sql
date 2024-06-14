
select mc.id courseid,  mc.fullname coursename,  mg.id groupid, mg.name groupname, mu.id, mu.username, 
timezone('AEST', to_timestamp(mgm.timeadded)) timeaddedd from mdl_groups mg 
join mdl_groups_members mgm  on mgm.groupid = mg.id 
join mdl_course mc on mg.courseid = mc.id
join mdl_user mu on mu.id = mgm.userid
where mgm.groupid = 15

