
with x as 
(
SELECT mcc.id, mcc.name, mcc.path,  unnest(string_to_array(path, '/')) pathbreak FROM  mdl_course_categories mcc 
),
y as 
(
select x.id, x.name, x.path, x.pathbreak, mcc2.name pathname from x
left join mdl_course_categories mcc2 on x.pathbreak = mcc2.id::text 
),
z as 
(select y.id, string_agg(y.pathname, '/') as pathname from y 
group by y.id)
select mc.id courseid, mc.fullname course , z.id categoryid, concat(z.pathname,'/',mc.fullname) from z
join mdl_course mc on mc.category = z.id
join mdl_course_categories mcc3 on mcc3.id = z.id
order by z.pathname
***************V2**************
with x as 
(
SELECT mcc.*,  unnest(string_to_array(path, '/')) pathbreak FROM  mdl_course_categories mcc 
),
y as 
(
select x.id, x.name, x.path, x.pathbreak, mcc2.name pathname from x
left join mdl_course_categories mcc2 on x.pathbreak = mcc2.id::text 
),
z as 
(select y.id, array_to_string(array_agg(y.pathname),'/') pathname from y
group by y.id)

select mc.id courseid, mc.fullname course , z.id categoryid, z.pathname from z
join mdl_course mc on mc.category = z.id
join mdl_course_categories mcc3 on mcc3.id = z.id
*********************************************************

