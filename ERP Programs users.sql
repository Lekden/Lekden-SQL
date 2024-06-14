select 
mepp.id program_id, 
mepp.fullname program_name,
--mepp.archived program_archived,
mu.email, 
case 
when mepa.archived = 0 and mepa.timecompleted is null then 'Open'
when mepa.archived = 1 and mepa.timecompleted is null then 'Archived'
when mepa.archived = 0 and mepa.timecompleted is not null then 'Completed'
when mepa.archived = 1 and mepa.timecompleted is not null then 'Archived completed'
end user_status,
to_char(timezone('AEST',to_timestamp(mepa.timecompleted)),'yyyy-mm-dd HH24:MI:SS') program_completed, 
meps."type" 
from mdl_enrol_programs_allocations mepa 
join mdl_enrol_programs_programs mepp on mepp.id = mepa.programid 
join mdl_user mu on mu.id = mepa.userid 
join mdl_enrol_programs_sources meps on meps.id = mepa.sourceid 
where mepp.id = 7
order by mepp.id, mu.email 

select * from mdl_enrol_programs_programs mepp 