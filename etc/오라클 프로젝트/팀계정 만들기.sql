
create user project4team identified by java1234;

grant connect, resource, dba to project4team; --hr

alter user project4team account lock;
alter user project4team account unlock;

select * from tabs;