select distinct on
 (epp.id) epp.id program_id, epp.fullname program_name, epp.idnumber program_idnumber, items.course_id_name,  items1.program_type, epp.public, 
 case 
 	when meps.type = 'selfallocation' then 'yes'
 	else 'no'
 end,
case
when epp.archived = 0 then 'no'
when epp.archived = 1 then 'yes' end archived,
to_char(timezone('AEDT',to_timestamp(epp.timeallocationstart)),'yyyy-mm-dd HH24:MI:SS') allocation_start_AEDT,
to_timestamp(epp.timecreated)::date program_created,
concat ('(', cohort.cohortid,') ' , cohort.cohortname) cohort_id_name, 
--eps.type, 
cohort.count cohort_member_count,
notice.notifications_enabled, concat('https://www.domain.com.au', epp.id)
from
{enrol_programs_programs} epp
left join
(select
string_agg(concat('(', epi.courseid,')  ',epi.fullname), (' / ') order by epi.id) as course_id_name, epi.programid from {enrol_programs_items} epi
where epi.courseid is not null 
group by epi.programid
) items
on epp.id = items.programid
left join {enrol_programs_sources} meps on meps.programid = epp.id and meps.type= 'selfallocation'
left join 
(
select count(distinct mepus.userid), mc.id cohortid, mc.name cohortname, mepp.id programid
from {enrol_programs_sources} meps 
join {enrol_programs_src_cohorts} mepsc on  mepsc.sourceid = meps.id 
join {enrol_programs_programs} mepp on meps.programid = mepp.id 
left join {cohort} mc on mc.id = mepsc.cohortid 
left join {enrol_programs_usr_snapshots} mepus on mepus.sourceid = meps.id 
where mc.id is not null
and mepus.archived = 0
group by mc.id, meps.id, mepp.id, mepp.fullname, mepsc.cohortid ) cohort on epp.id = cohort.programid
left join
(
select substring(epi.sequencejson, '"type.*[^}]') program_type, epi.programid from {enrol_programs_items} epi
where epi.sequencejson != '[]'
) items1 on epp.id = items1.programid
left join 
(
select mlon.instanceid, string_agg(mlon.notificationtype, '/' order by mlon.id) notifications_enabled 
from {local_openlms_notifications} mlon 
where mlon.enabled = 1
group by mlon.instanceid
)notice on notice.instanceid = epp.id 
--where mc.name is not null 
join 
(select mcc.id, mcc.name catname, mcc.path, mepp.id programid
from {enrol_programs_programs} mepp 
left join {context} mc on mepp.contextid = mc.id 
left join {course_categories} mcc on mcc.id = mc.instanceid 
where (mc.contextlevel = 40 or mc.contextlevel = 10)
--and mcc.id = 4
) category on category.programid = epp.id 
order by epp.id 
