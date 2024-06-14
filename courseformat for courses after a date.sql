select count (distinct mc.id) course_count, mcf.format
--timezone('AEST',to_timestamp(mc.timecreated))::date coursecreated 
from mdl_course_format_options mcf 
join mdl_course mc on mcf.courseid = mc.id 
join mdl_course_categories mcc on mc.category = mcc.id 
where  timezone('AEST',to_timestamp(mc.timecreated))::date >= '2023/01/01'
and mcc.path like 
group by mcf.format
order by course_count desc 


select  distinct mc.id courseid, mcf.format, timezone('AEST',to_timestamp(mc.timecreated))::date coursecreated 
from mdl_course_format_options mcf 
join mdl_course mc on mcf.courseid = mc.id 
join mdl_course_categories mcc on mc.category = mcc.id 
where  timezone('AEST',to_timestamp(mc.timecreated))::date >= '2023/01/01'
--group by mcf.format

