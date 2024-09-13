--select * from
--(
select
x.course_id, x.course_name, x.f2f_activity_name, x.f2f_session_id, x.firstname, x.lastname,  x.email,  y.actioned_by,
x.start_time, x.end_time, x.duration, y.attendance, x.attendance_time, y.grade, y.note cancellation_note
--row_number() over (order by x.f2f_session_id) rowno
from
(
select mc.id course_id, mc.fullname course_name, mf.name f2f_activity_name, mfs2.id f2f_session_id, mu.firstname, mu.lastname,  mu.email,
timezone('AEST',to_timestamp(mfsd.timestart)) start_time, timezone('AEST',to_timestamp(mfsd.timefinish)) end_time,
(mfs2.duration/60) duration,
timezone('AEST',to_timestamp(max(mfss.timecreated))) attendance_time
from
mdl_facetoface mf
join mdl_facetoface_sessions mfs2 on mf.id = mfs2.facetoface
join mdl_facetoface_signups mfs on mfs.sessionid = mfs2.id
join mdl_facetoface_signups_status mfss on mfss.signupid = mfs.id
join mdl_facetoface_sessions_dates mfsd on mfs2.id = mfsd.sessionid
join mdl_course mc on mf.course = mc.id
join mdl_user mu on mu.id = mfs.userid
join mdl_course_categories mcc on mcc.id = mc.category
where (mfss.statuscode = 10 or mfss.statuscode = 60 or mfss.statuscode = 70 or mfss.statuscode = 80 or mfss.statuscode = 90 or mfss.statuscode = 100)
--and
--mcc.path like '/1108/1785/2677'
group by mc.id , mc.fullname,  mf.name , mfs2.id , mfsd.timestart, mfsd.timefinish, mfs2.duration, mu.firstname, mu.lastname, mu.email, mfs.id
) x
join
(
select distinct timezone('AEST',to_timestamp(mfss.timecreated)) attendance_time, mc.id course, mfs2.id sessionid, mu.email, mfss.statuscode, mfss.note,
mu1.email actioned_by,
case
when mfss.statuscode = 10 then 'cancelled'
when mfss.statuscode = 60 then 'wait-list'
when mfss.statuscode = 70 then 'booked'
when mfss.statuscode = 80 then 'no show'
when mfss.statuscode = 90 then 'Partially attended'
when mfss.statuscode = 100 then 'fully attended'
end attendance,
mfss.grade
from mdl_facetoface mf
join mdl_facetoface_sessions mfs2 on mf.id = mfs2.facetoface
join mdl_facetoface_signups mfs on mfs.sessionid = mfs2.id
join mdl_facetoface_signups_status mfss on mfss.signupid = mfs.id
join mdl_facetoface_sessions_dates mfsd on mfs2.id = mfsd.sessionid
join mdl_course mc on mf.course = mc.id
join mdl_user mu on mu.id = mfs.userid
join mdl_user mu1 on mu1.id = mfss.createdby
order by mc.id, mfs2.id, mu.email
) y
on x.course_id = y.course
and x.f2f_session_id = y.sessionid
and x.email = y.email
and x.attendance_time = y.attendance_time
--where
--x.attendance_time >= now() - interval '1 month'
order by x.course_id, x.f2f_session_id, x.email, y.grade
--) main
--where main.rowno <= 30000
