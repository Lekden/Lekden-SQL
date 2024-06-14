SELECT
mdl_user.username,
mdl_course_modules_completion.coursemoduleid activity_id,
mdl_course_modules_completion.completionstate,
mdl_modules.name activity_type,
--mdl_course_modules_completion.timemodified,
timezone('AEDT',to_timestamp(mdl_course_modules_completion.timemodified)) timemodified,
--mdl_course_modules.module activity_id,
mdl_course.fullname,
mdl_course.category
FROM
mdl_course_modules_completion
JOIN mdl_user
ON mdl_course_modules_completion.userid = mdl_user.id
JOIN mdl_course_modules
ON mdl_course_modules_completion.coursemoduleid = mdl_course_modules.id
JOIN mdl_course
ON mdl_course_modules.course = mdl_course.id
join mdl_modules
on mdl_course_modules.module = mdl_modules.id
WHERE
mdl_course_modules_completion.completionstate = 1 AND mdl_course_modules.course = 89
and timezone('AEDT',to_timestamp(mdl_course_modules_completion.timemodified)) >= now() - interval '7 days'
