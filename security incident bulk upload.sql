	select * from mdl_logstore_standard_log mlsl 
	where target ilike '%user%' and action ilike 'update'
	order by timecreated desc 