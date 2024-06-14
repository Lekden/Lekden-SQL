select distinct on
 (epp.id) epp.id program_id, epp.fullname program_name, epp.idnumber program_idnumber, items.course_id_name,  items1.program_type,
/*case
when epp.archived = 0 then 'no'
when epp.archived = 1 then 'yes' end archived,*/
to_char(timezone('AEDT',to_timestamp(epp.timeallocationstart)),'yyyy-mm-dd HH24:MI:SS') allocation_start_AEDT,
to_timestamp(epp.timecreated)::date program_created,
concat ('(', epsc.cohortid,') ' , mc.name) cohort_id_name, 
--eps.type, 
cmembers.cohort_members, 
notice.notifications_enabled, concat('https://www.adele.defence.gov.au', epp.id)
from
mdl_enrol_programs_programs epp
left join
(select
string_agg(concat('(', epi.courseid,')  ',epi.fullname), (' / ') order by epi.id) as course_id_name, epi.programid from mdl_enrol_programs_items epi
where epi.courseid is not null 
group by epi.programid
) items
on epp.id = items.programid
left join mdl_enrol_programs_sources eps on eps.programid = epp.id and eps.type = 'cohort'
left join mdl_enrol_programs_src_cohorts epsc on epsc.sourceid = eps.id 
left join mdl_cohort mc on mc.id = epsc.cohortid
left join
(
select substring(epi.sequencejson, '"type.*[^}]') program_type, epi.programid from mdl_enrol_programs_items epi
where epi.sequencejson != '[]'
) items1 on epp.id = items1.programid
left join 
(
select mlon.instanceid, string_agg(mlon.notificationtype, '/' order by mlon.id) notifications_enabled 
from mdl_local_openlms_notifications mlon 
where mlon.enabled = 1
group by mlon.instanceid
)notice on notice.instanceid = epp.id 
left join 
(
select  mc2.id cohortid , count(mcm.userid) cohort_members
from mdl_context mc 
join mdl_course_categories mcc on mcc.id = mc.instanceid 
join mdl_cohort mc2 on mc2.contextid = mc.id 
join mdl_cohort_members mcm on mcm.cohortid = mc2.id 
where mc.contextlevel = 40
group by  mc2.id
) cmembers on cmembers.cohortid = mc.id  
--where mc.name is not null 
join 
(select mcc.id, mcc.name catname, mcc.path, mepp.id programid
from mdl_enrol_programs_programs mepp 
left join mdl_context mc on mepp.contextid = mc.id 
left join mdl_course_categories mcc on mcc.id = mc.instanceid 
where (mc.contextlevel = 40 or mc.contextlevel = 10)
--and mcc.id = 4
) category on category.programid = epp.id 
order by epp.id 