select count(mm.id) total, mm.name
from mdl_modules mm
join mdl_course_modules mcm on mm.id = mcm.module
join mdl_course mc on mc.id = mcm.course 
join mdl_course_categories mcc on mcc.id = mc.category 
where (mcc.path like '/6/%' or mcc.path like '/6%')
and (TO_TIMESTAMP(MCM.ADDED)::DATE BETWEEN '2022-12-01' AND '2022-12-30')
group by mm.name