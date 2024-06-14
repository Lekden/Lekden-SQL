
select x.*, y.attendance, y.statuscode, y.grade from 
(
select max(mfss.timecreated) timecreated, mc.id course, mc.fullname,mfs2.id sessionid, mu.email, mf.name activity_name,   timezone('AEDT',to_timestamp(mfsd.timestart)) start_time, timezone('AEDT',to_timestamp(mfsd.timefinish)) end_time, 
(mfs2.duration/60) duration
from mdl_facetoface mf 
join mdl_facetoface_sessions mfs2 on mf.id = mfs2.facetoface 
join mdl_facetoface_signups mfs on mfs.sessionid = mfs2.id 
join mdl_facetoface_signups_status mfss on mfss.signupid = mfs.id 
join mdl_facetoface_sessions_dates mfsd on mfs2.id = mfsd.sessionid 
join mdl_course mc on mf.course = mc.id 	
join mdl_user mu on mu.id = mfs.userid 
--where (mfss.statuscode = 70 or mfss.statuscode = 80 or mfss.statuscode = 90 or mfss.statuscode = 100)
group by mc.id , mc.fullname,  mf.name , mfs2.id , mfsd.timestart, mfsd.timefinish, mfs2.duration, mu.firstname, mu.lastname, mu.email, mfs.id
order by mc.id, mfs2.id, mu.email 
) x
join 
(
select distinct mfss.timecreated, mc.id course, mfs2.id sessionid, mu.email, mfss.statuscode,
case 
when mfss.statuscode = 10 then 'cancelled'
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
order by mc.id, mfs2.id, mu.email 
) y
on x.course = y.course
and x.sessionid = y.sessionid
and x.email = y.email 
and x.timecreated = y.timecreated