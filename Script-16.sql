SELECT 
CONCAT('%%WWWROOT%%/course/view.php%%Q%%id=', c.id) AS "Course link",
ct.instanceid,
f.component,
f.filename,
f.author,
timezone('AEST', to_timestamp(f.timecreated)) AS time_created,
replace(
CONCAT('%%WWWROOT%%/',
CASE
  WHEN f.component = 'user' AND f.filearea = 'draft' THEN 'draftfile.php'
  ELSE 'pluginfile.php'
END,
'/', f.contextid,
'/', f.component,
'/', f.filearea,
'/', f.itemid,
f.filepath, f.filename), ' ', '%20')
filenameurl
FROM mdl_files f
LEFT JOIN mdl_context ct ON ct.id = f.contextid
LEFT JOIN mdl_course_modules cm ON cm.id = ct.instanceid
LEFT JOIN mdl_course c ON cm.course = c.id
WHERE f.timecreated >= extract(epoch from (now() - interval '7 days'))
AND (filename iLIKE '%PROTECTED%' OR filename iLIKE '%SECRET %' OR 
filename LIKE '%SECRET]%' OR filename LIKE '%SECRET.%' OR filename LIKE '%SECSECRET%' OR filename LIKE '%TOP SECRET%' or filename LIKE '%AUSTEO%' 
or filename LIKE '% AGAO %' or filename LIKE '%=AGAO%' or filename LIKE '%(AGAO)%' or filename LIKE '%CABINET%' or filename LIKE '%NATIONAL CABINET%' 
or filename LIKE '% REL %' or filename LIKE '%REL AUS%' or filename LIKE '%REL CAN%' or filename LIKE '%REL NZL%' or filename LIKE '%REL UK%' or filename LIKE '%REL USA%'  
or filename LIKE '%REL AUS/CAN/NZL/UK/USA%' or filename LIKE '%DLM=%')
ORDER BY time_created desc

