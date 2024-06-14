with x as 
(select mm.name activity, mcm.module actid, mcc.path path
from mdl_course_modules mcm 
join mdl_modules mm on mm.id = mcm.module 
join mdl_course mc on mc.id = mcm.course 
join mdl_course_categories mcc on mcc.id = mc.category 
where mm.visible <> 0
),
army as 
(select x.activity, count (x.actid) army from x where x.path like '/3/%' or x.path like '/3%' group by x.activity ),
navy as 
(select x.activity, count (x.actid) navy from x where x.path like '/2/%' or x.path like '/2%' group by x.activity ),
airforce as 
(select x.activity, count (x.actid) airforce from x where x.path like '/4/%' or x.path like '/4%' group by x.activity ),
joint as 
(select x.activity, count (x.actid) joint from x where x.path like '/19/%' or x.path like '/19%' group by x.activity ) 
select distinct x.activity,  army.army,  navy.navy,  airforce.airforce,  joint.joint 
from x
left join army on x.activity = army.activity
full outer join navy on x.activity = navy.activity
full outer join airforce on x.activity = airforce.activity
full outer join joint  on x.activity = joint.activity




select mcm.module from mdl_course_modules mcm group by mcm."module" 


