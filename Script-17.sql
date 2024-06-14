select course.id as "course id", course.fullname as "course name", x.id block_id, 
x.html_content, y.html_content,
concat('%%wwwroot%%/course/view.php%%q%%id=', course.id) as "course name_link_url",
cc.name as "category", concat('%%wwwroot%%/course/management.php%%q%%categoryid=', cc.id) as "category_link_url"
from mdl_course course
join mdl_context con on con.instanceid = course.id
join mdl_course_categories cc on course.category = cc.id
join 
(
select bi.id, bi.parentcontextid, convert_from(decode(bi.configdata, 'base64'), 'utf8') html_content from 
mdl_block_instances bi
where bi.blockname = 'html'
and convert_from(decode(bi.configdata, 'base64'), 'utf8') like '%!<link %' escape '!' 
) 
x on x.parentcontextid = con.id
--where con.contextlevel = 50
join
(
select bi.id, bi.parentcontextid, convert_from(decode(bi.configdata, 'base64'), 'utf8') html_content 
from mdl_block_instances bi
where bi.blockname = 'html'
and convert_from(decode(bi.configdata, 'base64'), 'utf8') like '%!<style>%' escape '!' 
)
y on y.parentcontextid = con.id 
where con.contextlevel = 50