select y.course, y.fullname, y.activity_name, y.sessionid, timezone('AEST',to_timestamp(y.timestart)) start_time, timezone('AEST',to_timestamp(y.timefinish)) end_time, 
(y.duration/60) duration, y.firstname, y.lastname, y.email, y.attendance, y.grade  from 
(
select *, ROW_NUMBER() OVER (partition BY email) AS row_num from 
(
select distinct mc.id course, mc.fullname,  mf.name activity_name, mfs2.id sessionid, mfsd.timestart, mfsd.timefinish, mfs2.duration, mu.firstname, mu.lastname, mu.email, 
--distinct mfs.id signupid, mf.course, mc.fullname coursename, mf.id f2f_instance, mu.email, mfs2.id sessionid, mfs.userid , mfss.statuscode, mfss.statuscode,
case
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
where (mfss.statuscode = 70 or mfss.statuscode = 80 or mfss.statuscode = 90 or mfss.statuscode = 100)
order by mu.email, mfss.grade
) x
) y 
where y.row_num = 1



select * from mdl_facetoface_signups_status mfss order by signupid 
