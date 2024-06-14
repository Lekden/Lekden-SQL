select * from mdl_data md 
join mdl_data_fields mdf on md.id = mdf.dataid 
join mdl_data_content mdc on mdf.id = mdc.fieldid 