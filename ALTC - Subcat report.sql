/*with x (var1, var2) as (
   values (:categoryid, :category_name)
),*/ 
with main as 
(
select 
concat('(', mc2.id, ')', mc2.fullname) course, 
mu.id userid, mu.email email, mcc.id catid,  mcc2.id catid2, mcc2.name catname2, mra.roleid roleid, mr.name role_name, 
mcc3.id catid3, mcc3.name catname3, 
case when mu.suspended = 0 then 'a'
     when mu.suspended = 1 then 's' end status
from mdl_role_assignments mra 
left join mdl_context mc on mc.id = mra.contextid 
left join mdl_course mc2 on mc2.id  = mc.instanceid and mc.contextlevel = 50
full outer join mdl_course_categories mcc on mcc.id = mc.instanceid and mc.contextlevel = 40 
full outer join mdl_course_categories mcc2 on mc2.category = mcc2.id 
left join mdl_course_categories mcc3 on mcc3.id = mcc2.parent
left join mdl_user mu on mu.id = mra.userid 
left join mdl_role mr on mra.roleid = mr.id 
where --(mcc2."path" like (select var1 from x) or mcc.path like (select var1 from x) or mcc2.name ilike (select var2 from x) or mcc.name ilike (select var2 from x))
--and 
--mra.roleid != 5
(mra.roleid = 4 or  mra.roleid = 3 or mra.roleid = 9 or mra.roleid = 1 or mra.roleid is null)
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
select distinct main.email email, main.catid catid, main.status from main where main.roleid = 1 group by main.catid, main.email, main.status
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
/*case when concat(main.catid3, ' - ', main.catname3) is null then 'adfda'
else concat(main.catid3, ' - ', main.catname3) end parent_category_id_name,*/
concat(main.catid3, ' - ', main.catname3) parent_category_id_name,
concat(main.catid2, ' - ', main.catname2) category_id_name,  
case when string_agg(distinct main.course, ' / ') = '()' then 'no course'
else string_agg(distinct main.course, ' / ') end course_id_name,
coalesce(slcm.email, 'no slcm enrolled') slcms, coalesce(cm.email, 'no cm enrolled') category_manager, 
coalesce(teacher.email, 'no teacher enrolled') teacher, coalesce(nonedit.email, 'no non-editing teacher enrolled') nonediting_teacher 
from main
left join slcm on main.catid2 = slcm.catid 
left join teacher on main.catid2 = teacher.catid 
left join nonedit on main.catid2 = nonedit.catid 
left join cm on main.catid2 = cm.catid 
where main.catid2 is not null
group by main.catid2, slcm.email, teacher.catid, teacher.email, nonedit.email, cm.email, main.catname2, main.catid3, main.catname3
order by main.catid2

select * from mdl_course_categories mcc where mcc.id = 1


