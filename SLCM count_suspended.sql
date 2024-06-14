with x as 
(select ra.userid userid, cc.path path, u.suspended 
from mdl_role_assignments ra
join mdl_context c on c.id = ra.contextid
join mdl_course_categories cc on c.instanceid = cc.id 
join mdl_user u on ra.userid = u.id
where 
--c.contextlevel = 40
--and 
ra.roleid = 9), 
army as
(
select count(distinct x.userid) army from x where x.path like '/3%' 
), 
suspended_army as 
(
select count(x.suspended) army_suspended from x where x.suspended = 1 and x.path like '/3%'
),
navy as
(
select count(distinct x.userid) navy from x where x.path like '/2%'
), 
suspended_navy as 
(
select count(x.suspended) navy_suspended from x where x.suspended = 1 and x.path like '/2%'
),
airforce as
(
select count(distinct x.userid) airforce from x where x.path like '/1%'
), 
suspended_airforce as 
(
select count(x.suspended) airforce_suspended from x where x.suspended = 1 and x.path like '/1%'
),
joint as
(
select count(distinct x.userid) joint from x where x.path like '/2389%'
),
suspended_joint as 
(
select count(x.suspended) joint_suspended from x where x.suspended = 1 and x.path like '/2389%'
)
select army.army, suspended_army.army_suspended, navy.navy, suspended_navy.navy_suspended, airforce.airforce, suspended_airforce.airforce_suspended, 
joint.joint, suspended_joint.joint_suspended, (army.army+navy.navy+airforce.airforce+joint.joint) total_SLCM, 
(suspended_army.army_suspended + suspended_navy.navy_suspended + suspended_airforce.airforce_suspended + suspended_joint.joint_suspended) total_suspended_slcms
from army, navy, airforce, joint, suspended_army, suspended_navy, suspended_airforce, suspended_joint
