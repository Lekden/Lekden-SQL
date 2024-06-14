		with x as 
		(select
		count(mu.id) students, to_char(to_timestamp(ue.timecreated)::date,'YYYY') enrolment_year, mcc.path catpath
		from mdl_user mu
		join mdl_user_enrolments ue on mu.id = ue.userid 
		join mdl_enrol en on ue.enrolid = en.id
		join mdl_role_assignments mra on mu.id = mra.userid 
		join mdl_context mc2 on mra.contextid = mc2.id
		join mdl_course mc on mc.id = mc2.instanceid and mc.id = en.courseid 
		join mdl_course_categories mcc on mcc.id = mc.category
		where mra.roleid = 5 
		and (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%'
		and mcc.name not like '%sandbox%' and mcc.name not ilike 'sandpit')
		group by enrolment_year, catpath
		),
		y as 
		(select  count(mu.id) teachers, to_char(to_timestamp(ue.timecreated)::date,'YYYY') enrolment_year, mcc.path catpath
		from mdl_user mu
		join mdl_user_enrolments ue on mu.id = ue.userid 
		join mdl_enrol en on ue.enrolid = en.id
		join mdl_role_assignments mra on mu.id = mra.userid 
		join mdl_context mc2 on mra.contextid = mc2.id
		join mdl_course mc on mc.id = mc2.instanceid and mc.id = en.courseid 
		join mdl_course_categories mcc on mcc.id = mc.category
		where mra.roleid = 3
		and (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%'
		and mcc.name not like '%sandbox%' and mcc.name not ilike 'sandpit')
		group by enrolment_year, catpath
		),
		z as (
		select count(mc.id) courses, to_char(to_timestamp(mc.startdate)::date,'YYYY') as year, mcc.path catpath
		from mdl_course mc
		join mdl_course_categories mcc on mc.category = mcc.id
		where (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%'
		and mcc.name not like '%sandbox%' and mcc.name not ilike 'sandpit')
		group by year, catpath
		)
		select sum(x.students) students, sum(y.teachers) teachers, sum(z.courses) courses, z.year, z.catpath, x.catpath, y.catpath from z
		full outer join y on y.enrolment_year = z.year and y.catpath = z.catpath
		full outer join x on x.enrolment_year = z.year and x.catpath = z.catpath
		--where (z.catpath like '/3%' or z.catpath like '/3/%')
		group by z.year, z.catpath, x.catpath, y.catpath
		order by z.year





