	select distinct mc.id course_id, mc.fullname course_name, mf.id f2fid, mf.name activity_name, mfs2.id sessionid, 
case when mfsd1.fieldid = 2 then mfsd1.data end custom_session_id, 
--mfsd1.data custom_session_id, 
timezone('AEST',to_timestamp(mfsd.timestart)) start_time, 
timezone('AEST',to_timestamp(mfsd.timefinish)) end_time, 
(mfs2.duration/60) duration_hour, mcc.id category
from 
mdl_course mc 
join mdl_facetoface mf on mf.course = mc.id 
left join mdl_facetoface_sessions mfs2 on mf.id = mfs2.facetoface 
left join mdl_facetoface_sessions_dates mfsd on mfs2.id = mfsd.sessionid 
left join mdl_facetoface_session_data mfsd1 on mfsd1.sessionid = mfs2.id
left join mdl_course_categories mcc on mcc.id = mc.category
--left join mdl_user mu on mu.id = mfs.userid 
--where mc.id = 33954
order by mc.id

--remove htmls in a row value
select regexp_replace(details, '<[^>]*>', '', 'g	') from mdl_facetoface_sessions mfs 



--course with no activity last 1 year
select * from 
(
select courseid, max(timezone('AEST',to_timestamp(timecreated))) maxtime from mdl_logstore_standard_log mlsl
group by courseid
) x
where x.maxtime < now() - interval '2 months'