SELECT mc.id courseid, mc.fullname coursename, f.id fileid, f.filename, f.filesize, f.filearea, f.filepath,
to_char(to_timestamp(f.timecreated), 'dd-MON-yyyy HH24:MI: SS') as 
timecreated, mu.id, mu.email
from mdl_files f
join mdl_context c ON f.contextid = c.id
join mdl_course_modules cm ON c.instanceid = cm.id
join mdl_course mc on mc.id = cm.course 
join mdl_user mu on mu.id = f.userid 
where
c.contextlevel = 70
and 
f.filename ILIKE '%certificate%'
--and mc.id = 34

select * from mdl_context mc 