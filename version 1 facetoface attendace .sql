
select x.course, x.fullname,  x.activity_name, x.sessionid, x.start_time, x.end_time,
x.duration, x.firstname, x.lastname, x.email,
case 
when x.statuscode = 10 then 'cancelled'
when x.statuscode = 70 then 'booked'
when x.statuscode = 80 then 'no show'
when x.statuscode = 90 then 'Partially attended'
when x.statuscode = 100 then 'fully attended'
end attendance,
y.grade
from 
(
select distinct mc.id course, mc.fullname,  mf.name activity_name, mfs2.id sessionid,  timezone('AEDT',to_timestamp(mfsd.timestart)) start_time, timezone('AEDT',to_timestamp(mfsd.timefinish)) end_time, 
(mfs2.duration/60) duration, mfs.id signupid, mu.firstname, mu.lastname, mu.email,  
max(mfss.statuscode) statuscode
from mdl_facetoface mf 
join mdl_facetoface_sessions mfs2 on mf.id = mfs2.facetoface 
join mdl_facetoface_signups mfs on mfs.sessionid = mfs2.id 
join mdl_facetoface_signups_status mfss on mfss.signupid = mfs.id 
join mdl_facetoface_sessions_dates mfsd on mfs2.id = mfsd.sessionid 
join mdl_course mc on mf.course = mc.id 	
join mdl_user mu on mu.id = mfs.userid 
where (mfss.statuscode = 10 or mfss.statuscode = 70 or mfss.statuscode = 80 or mfss.statuscode = 90 or mfss.statuscode = 100)
group by mc.id , mc.fullname,  mf.name , mfs2.id , mfsd.timestart, mfsd.timefinish, mfs2.duration, mu.firstname, mu.lastname, mu.email, mfs.id
order by mc.id, mfs2.id, mu.email asc 
)x 
join 
(select distinct mfss2.grade, mfss2.signupid, mfss2.statuscode from mdl_facetoface_signups_status mfss2) y
on x.signupid = y.signupid
and x.statuscode = y.statuscode
--where x.course = 
order by x.course, x.activity_name, x.sessionid, x.email








