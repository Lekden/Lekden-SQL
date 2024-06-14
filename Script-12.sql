select * from "member" m 

ALTER TABLE member
ADD email VARCHAR(255);

DROP TABLE member CASCADE;

create table member(
id serial primary key, 
fullname varchar(255), 
email varchar(255),
password varchar(255),
suspended boolean, 
date_of_birth date,
date_of_registration date,
expiry date, 
address varchar(255),
country varchar(255),
message varchar(255)
);
