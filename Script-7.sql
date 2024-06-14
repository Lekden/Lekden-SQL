select * from mdl_logstore_standard_log mlsl, to_timestamp(timecreated) where objectid = 444
and  to_timestamp(timecreated) >= '2023-04-27'


select * from mdl_customcert_templates 