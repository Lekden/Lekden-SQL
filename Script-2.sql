select mt.id, mt.name, mc.* from mdl_tag_instance mti 
join mdl_tag mt on mti.tagid = mt.id 
join mdl_course mc on mti.itemid = mc.id 

-- permission teachers and managers by default. moodle/course:tag