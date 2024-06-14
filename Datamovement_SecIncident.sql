


select z.*, zz.groupid, zz.group_added from 
(select
mu.id userid, mu.username wrong_username, mc.id courseid, mc.fullname, to_timestamp(mcc2.timecompleted)::date course_completion_date,  to_timestamp(ue.timecreated)::date enrolment_date, x.activity_id, 
x.activity_completed
from mdl_user mu
join mdl_user_enrolments ue on mu.id = ue.userid
join mdl_enrol en on ue.enrolid = en.id
join mdl_course mc on mc.id = en.courseid
left join mdl_course_completions mcc2 on mcc2.userid = mu.id and mcc2.course = mc.id 
left join 
(select mcm.id activity_id, mcm.course course, mcmc.userid userid, to_timestamp(mcmc.timemodified) activity_completed  
from  mdl_course_modules_completion mcmc
join mdl_course_modules mcm on mcm.id = mcmc.coursemoduleid) x 
on mc.id = x.course and mu.id = x.userid) z 
join 
(select mg.id groupid, mg.name group_name, to_timestamp(mgm.timeadded) group_added , mgm.userid userid, mg.courseid courseid
from mdl_groups mg
join mdl_groups_members mgm on mgm.groupid = mg.id) zz
on z.userid = zz.userid and z.courseid = zz.courseid
where 
z.wrong_username in ('andre.garing@defence.gov.au','keiya.kojima@defence.gov.au','trey.hubert@defence.gov.au','austin.nott@defence.gov.au','willem.taylor@defence.gov.au','lee.echivarre@defence.gov.au','lewis.stewart@defence.gov.au',
'lily.masters@defence.gov.au',
'samuel.belcastro@defence.gov.au','samantha.midson@defence.gov.au','chanel.albion@defence.gov.au','zara.hart@defence.gov.au','dylanger.honneysett@defence.gov.au','claudia.doeland@defence.gov.au',
'isabelle.boeske@defence.gov.au','samuel.mclennan@defence.gov.au','makayla.magro@defence.gov.au','mitchell.hewitt1@defence.gov.au','joshua.eldred@defence.gov.au','jamie.shapiro@defence.gov.au','sean.hemmings@defence.gov.au','coby.saler@defence.gov.au',
'michael.mayne@defence.gov.au','brent.hoffman@defence.gov.au','alexander.gillies@defence.gov.au','rebel.brooker@defence.gov.au','brandon.ebdon@defence.gov.au','georgia.pearson1@defence.gov.au','cameron.eales@defence.gov.au','darcy.knight@defence.gov.au',
'rhys.devlin@defence.gov.au','samantha.claridge@defence.gov.au','nicholas.spencer@defence.gov.au','rory.goodison@defence.gov.au','blake.white@defence.gov.au','samuel.stephan@defence.gov.au','jordan.mccahon@defence.gov.au',
'beau.redden@defence.gov.au','gurpreet.singh6@defence.gov.au','belinda.clape@defence.gov.au','oliver.agbisit@defence.gov.au','samuel.gorton@defence.gov.au','demas.farrell@defence.gov.au','harley.windham@defence.gov.au')
and z.courseid in ('2342','45786','45242','37239','24636','40353','30646','45025','41695','2361','2363','2362','6851','43114','12717')
and zz.group_added > '2023-06-13 09:20:00'
and z.activity_completed > '2023-06-13 09:20:00'


select * from mdl_course_completions mcc 