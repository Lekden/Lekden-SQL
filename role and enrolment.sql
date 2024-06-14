select mu.id, mu.username, mc.fullname, mra.roleid  from mdl_user mu
join mdl_user_enrolments ue on mu.id = ue.userid 
join mdl_enrol en on ue.enrolid = en.id
join mdl_role_assignments mra on mu.id = mra.userid 
join mdl_context mc2 on mra.contextid = mc2.id
join mdl_course mc on mc.id = mc2.instanceid and mc.id = en.courseid 
join mdl_course_categories mcc on mcc.id = mc.category
where mu.id = 319
order by mu.username 