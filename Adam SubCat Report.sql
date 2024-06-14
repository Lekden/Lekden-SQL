with x (var1, var2) as (
   values ('', '')
), 
main as 
(
select concat('(', mc2.id, ')', mc2.fullname) course, mu.id userid, mu.email email, mcc.id catid,  mcc2.id catid2, mcc2.name catname2, mra.roleid roleid, mr.name role_name, 
mcc3.id catid3, mcc2.name catname3, mcc4.id catid4, mcc4.name catname4,
case when mu.suspended = 0 then 'a'
     when mu.suspended = 1 then 's' end status
from  mdl_course_categories mcc4, mdl_role_assignments mra
left join mdl_context mc on mc.id = mra.contextid 
left join mdl_course mc2 on mc2.id  = mc.instanceid and mc.contextlevel = 50
left join mdl_course_categories mcc on mcc.id = mc.instanceid and mc.contextlevel = 40 
full outer join mdl_course_categories mcc2 on mc2.category = mcc2.id 
full outer join mdl_course_categories mcc3 on mcc3.id = mcc2.parent
full outer join mdl_user mu on mu.id = mra.userid 
full outer join mdl_role mr on mra.roleid = mr.id 
where /*(mcc2."path" like (select var1 from x) or mcc.path like (select var1 from x) or mcc2.name ilike (select var2 from x) or mcc.name ilike (select var2 from x))
and */
mra.roleid != 5
),
slcm as (
select string_agg(concat(c.email,'(', c.status,')'), ' / ') email, c.catid from 
(
select distinct main.email email, main.catid catid, main.status from main where main.roleid = 9 group by main.catid, main.email, main.status
) c 
group by c.catid 
),
cm as (
select string_agg(concat(d.email,'(', d.status,')'), ' / ') email, d.catid from 
(
select distinct main.email email, main.catid catid, main.status from main where main.roleid = 616 group by main.catid, main.email, main.status
) d 
group by d.catid 
),
teacher as (
select string_agg(concat(a.email,'(', a.status,')'), ' / ') email, a.catid from 
(
select distinct main.email email, main.catid2 catid, main.status from main where main.roleid = 3 group by main.catid2, main.email, main.status
) a
group by a.catid 
), 
nonedit as (
select string_agg(concat(b.email,'(', b.status,')'), ' / ') email, b.catid from 
(
select distinct main.email email, main.catid2 catid, main.status from main where main.roleid = 4 group by main.catid2, main.email, main.status
) b 
group by b.catid 
)
select 
concat(main.catid3, ' - ', main.catname3) parent_category_id_name,
concat(main.catid4, ' - ', main.catname4) category_id_name,  
string_agg(distinct main.course, ' / '),
coalesce(slcm.email, 'no slcm enrolled') slcms, coalesce(cm.email, 'no cm enrolled') category_manager, coalesce(teacher.email, 'no teacher enrolled') teacher, 
coalesce(nonedit.email, 'no non-editing teacher enrolled') nonediting_teacher 
from main
left join slcm on main.catid4 = slcm.catid 
left join teacher on main.catid4 = teacher.catid 
left join nonedit on main.catid4 = nonedit.catid 
left join cm on main.catid4 = cm.catid 
where main.catid4 is not null
group by main.catid2, slcm.email, teacher.catid, teacher.email, nonedit.email, cm.email, main.catname2, main.catid3, main.catname3, main.catid4, main.catname4
order by main.catid4




