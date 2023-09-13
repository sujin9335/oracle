--ex31.sql

--근태 상황(출석)
create table tblDate(
    seq number primary key,
    state varchar2(30) not null,
    regdate date not null
);

insert into tblDate (seq, state, regdate) values (1, '정상', '2023-09-01');
-- 09-02 : 토요일
-- 09-03 : 일요일

insert into tblDate (seq, state, regdate) values (2, '정상', '2023-09-04');
insert into tblDate (seq, state, regdate) values (3, '지각', '2023-09-05');
-- 09-06 : 결석
insert into tblDate (seq, state, regdate) values (4, '정상', '2023-09-07');
insert into tblDate (seq, state, regdate) values (5, '정상', '2023-09-08');

-- 09-09 : 토요일
-- 09-10 : 일요일
insert into tblDate (seq, state, regdate) values (6, '조퇴', '2023-09-11');
insert into tblDate (seq, state, regdate) values (7, '정상', '2023-09-12');
insert into tblDate (seq, state, regdate) values (8, '정상', '2023-09-13');
insert into tblDate (seq, state, regdate) values (9, '지각', '2023-09-14');
insert into tblDate (seq, state, regdate) values (10, '정상', '2023-09-15');

-- 09-16 : 토요일
-- 09-17 : 일요일
insert into tblDate (seq, state, regdate) values (11, '정상', '2023-09-18');
insert into tblDate (seq, state, regdate) values (12, '정상', '2023-09-19');
insert into tblDate (seq, state, regdate) values (13, '지각', '2023-09-20');
-- 09-21 : 결석
insert into tblDate (seq, state, regdate) values (14, '조퇴', '2023-09-22');

-- 09-23 : 토요일
-- 09-24 : 일요일
insert into tblDate (seq, state, regdate) values (15, '정상', '2023-09-25');
insert into tblDate (seq, state, regdate) values (16, '정상', '2023-09-26');
insert into tblDate (seq, state, regdate) values (17, '정상', '2023-09-27');
-- 09-28 : 추석
-- 09-29 : 추석
-- 09-30 : 토요일



-- 근태 조회 > 9월 근태 기록 열람 > 결석한 날짜도 포함 + 공유일 포함 > 빠진 날짜 메꾸기
-- 1. ANSI-SQL > 수업
-- 2. PL/SQL
-- 3. java

set serveroutput on;

declare
    vdate date;
    vstate varchar2(30);
    vcnt number;
begin

    vdate := to_date('2023-09-01', 'yyyy-mm-dd'); --00:00:00

    for i in 1..30 loop
        dbms_output.put_line(vdate);
        
        select count(*) into vcnt from tblDate where to_char(regdate, 'yyyy-mm-dd') = to_char(vdate, 'yyyy-mm-dd');
        
        if vcnt > 0 then
            select state into vstate from tblDate where to_char(regdate, 'yyyy-mm-dd') = to_char(vdate, 'yyyy-mm-dd');
            dbms_output.put_line(vstate);
        end if;
        vdate := vdate + 1; --하루씩 증가
    end loop;

end;
/


-- ANSI-SQL
-- 계층형 쿼리 사용

select * from tblComputer;

select
    lpad(' ', level * 3) || name
from tblComputer
    start with seq = 1
        connect by pseq = prior seq;

-- 계층형 쿼리 = for문 효과 > 일련 번호 생성
select * from daul;

select level from dual
    connect by level <= 5;

select sysdate + level from dual
    connect by level <= 5;


-- *** 기억!! >  date 자료형으로 원하는 기간의 데이터 생성하는 방법
create or replace view vwDate -- view 는 매개전수 전달불가(프로시저만 가능)
as
select
    to_date('20230901', 'yyyymmdd') + level - 1 as regdate
from dual
    connect by level <= (to_date('20230930', 'yyyymmdd') - to_date('20230901', 'yyyymmdd') + 1);

select * from vwDate; --9월 한달 날짜
select * from tblDate; --9월 근태 기록


select 
    *
from vwDate v
    left outer join tblDate t
        on v.regdate = t.regdate
            order by v.regdate asc;


-- 휴일 처리(토, 일)
select 
    v.regdate,
    case
        when to_char(v.regdate, 'd') in ('1') then '일요일'
        when to_char(v.regdate, 'd') in ('7') then '토요일'
        else t.state
    end as state
from vwDate v
    left outer join tblDate t
        on v.regdate = t.regdate
            order by v.regdate asc;


-- 공휴일 처리
create table tblHoliday(
    seq number primary key,
    regdate date not null,
    name varchar2(30) not null
);

insert into tblHoliday values(1, '2023-09-28', '추석');
insert into tblHoliday values(2, '2023-09-29', '추석');

-- 평일 + 휴일 처리(토,일) + 공휴일 + 결석
select 
    v.regdate,
    case
        when to_char(v.regdate, 'd') in ('1') then '일요일'
        when to_char(v.regdate, 'd') in ('7') then '토요일'
        when t.state is null and h.name is not null then h.name
        when t.state is null and h.name is null then '결석'
        else t.state
    end as state
from vwDate v
    left outer join tblDate t
        on v.regdate = t.regdate
            left outer join tblHoliday h
                on v.regdate = h.regdate
                    order by v.regdate asc;







