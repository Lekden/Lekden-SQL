select mc.id courseid, mc.fullname coursename, 
to_timestamp(mc.startdate)::date startdate,
to_timestamp(mc.timecreated)::date timecreated, 
to_timestamp(mc.timemodified)::date timemodified,
 mcc.id catid, mcc.name catname
from mdl_course mc, mdl_course_categories mcc
where mc.category = mcc.id
and to_char(to_timestamp(mc.timecreated)::date,'YYYY-MM-DD') <> to_char(to_timestamp(mc.timemodified)::date,'YYYY-MM-DD')
--and to_timestamp(mc.timemodified)::date = '2023-06-28'
and mcc.name ilike 'live'