

select * from mdl_label ml 
where convert_from(decode(ml.intro, 'base64'), 'utf8') like '%moodle%' escape '!'
and course = 64

select course.id as "course id", course.fullname as "course name", concat('%%wwwroot%%/course/view.php%%q%%id=', course.id) as "course name_link_url",
cc.name as "category", concat('%%wwwroot%%/course/management.php%%q%%categoryid=', cc.id) as "category_link_url"
from mdl_course course
join mdl_context con on con.instanceid = course.id
join mdl_course_categories cc on course.category = cc.id
where con.contextlevel = 50
and (
select count(id) from mdl_block_instances bi
where bi.blockname = 'html'
and convert_from(decode(bi.configdata, 'base64'), 'utf8') like '%!<script!>%' escape '!'
and bi.parentcontextid = con.id
limit 1
) <> 0

