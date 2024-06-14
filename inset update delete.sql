update commands 

select * from mdl_user mu where firstname ilike 'jiggy'

delete from mdl_user where id = 91


insert into mdl_user(firstname, lastname,email, username)
values ('jigme', 'namgyal', 'jigmenamgyal@gmail.com', 'jigme.namgyal')
returning *


update mdl_user
set firstname = 'jiggy',
    lastname = 'tewtew'
where id = 516