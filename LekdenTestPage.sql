select count (distinct mra.userid) userid, mcc.id catid
from  mdl_role_assignments mra 
left join mdl_context ctx on ctx.id = mra.contextid 
left join mdl_course mc on mc.id = ctx.instanceid  
left join mdl_course_categories mcc on mcc.id = mc.category    
where (mc.fullname not ilike '%sandbox%' and mc.fullname not ilike '%sandpit%' and mc.fullname not ilike '%sand pit%')
and (mcc.name not ilike '%sandbox%' and mcc.name not ilike '%sandpit%')
and mcc.path like '/2/%' and mcc.path like '/2%'
group by mcc.id




select count(mm.id) total, mm.name ,to_timestamp(mcm.added)::date 
from mdl_modules mm  
join mdl_course_modules mcm on mm.id = mcm.module
join mdl_course mc on mc.id = mcm.course 
join mdl_course_categories mcc on mcc.id = mc.category 
--where to_timestamp(mcm.added)::date between '2023-07-01' and '2023-07-31'
where to_timestamp(mcm.added)::date between '2023-07-01' and '2023-07-31'
and mcc.path like '/2/%' or mcc.path like '/2%' 
group by mm.name, mcm.added 