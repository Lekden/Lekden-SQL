select * FROM pg_catalog.pg_tables

create table account(
id int generated by default as identity,
name varchar(50) not null,
balance dec(15,2) not null,
primary key (id)
)

select * from account 


   -- 60 Days if creation in Jan
                EXTRACT(MONTH FROM TO_TIMESTAMP(timecreated)) = 1
                AND (
                    (
                        lastaccess > 0
                        AND lastaccess < CAST(EXTRACT(EPOCH FROM NOW()) AS INT)-(60 * 86400)
                    ) OR (
                        lastaccess = 0
                        AND timecreated < CAST(EXTRACT(EPOCH FROM NOW()) AS INT)-(60 * 86400)