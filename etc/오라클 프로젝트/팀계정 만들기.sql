
create user p4 identified by java1234;

grant connect, resource, dba to p4; --hr

alter user project4team account lock;
alter user project4team account unlock;

select * from tabs;

-- 테이블 만들어진시간
SELECT *
FROM ALL_OBJECTS
WHERE OBJECT_TYPE = 'TABLE';

--&입력끄기
SET DEFINE OFF;