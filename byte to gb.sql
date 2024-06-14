select mrc.course, 
case when length(mrc.filesize::varchar) >= 9 then concat(round(mrc.filesize/1024*1024*1024,2),' gb')
     when length(mrc.filesize::varchar) <= 8 then concat(round(mrc.filesize/1024*1024,2), ' mb')
	 end coursesize
from mdl_report_coursesize mrc


select mrc.course, concat(round((mrc.filesize)/(power(1024,3))),2)), ' gb')
 --when length(mrc.filesize::varchar) <= 8 then concat(round((mrc.filesize)/(1073741824),2), ' mb')
	-- end coursesize
from {report_coursesize} mrc
order by mrc.filesize desc
