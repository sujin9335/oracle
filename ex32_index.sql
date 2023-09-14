--ex32_index

/*

    인덱스, Index
    - 검색을 빠른 속도로 하기 위해 사용하는 도구
    - SQL 명령 처리 속도를 빠르게 하기 위해서, 특정 컬럼에 대해 생성되는 도구
    - 책 > 목차 / 인덱스(찾아보기) > 검색 도구
    
    데이터베이스
    - 테이블내의 레코드 순서가 사용자가 원하는 정렬 상태가 아니다 > DBMS가 자체적 정렬 보관
    - 어떤 데이터 검색 > 처음 ~ 끝까지 차례대로 검색 > table full scan
    - 특정 컬럼 선택 > 별도의 테이블에 복사 > 미리 정렬 >> 인덱스
    - 원본 테이블 <- 참조 -> 인덱스
    
    인덱스 장단점
    - 처리 속도를 향상 시킨다
    - 무분별한 인덱스 사용은 DB 성능을 저하 시킨다
    
    자동으로 인덱스가 걸리는 컬럼
    1. primary key
    2. unique
    - ** 테이블에서 PK 컬럼을 검색하는 속도 >>>>> 테이블에서 PK 아닌 컬럼을 검색하는 속도
    

*/


create table tblIndex
as
select * from tblAddressBook; --2000개


select count(*) from tblIndex; --2000개

insert into tblIndex select * from tblIndex;

select * from tbladdressBook; --seq(PK)
select * from tblIndex; --제약사항(x), 없음(PK) (테이블 복사시에는 참조값 적용x)

--시간 확인
set timing on;

--SQL 실행
--1. ctrl + enter   > 결과 > 테이블
--2. F5             > 결과 > 텍스트 (결과를 텍스트로 옮길때 쓰임)


-- 인덱스 없이 검색 > 경과 시간: 3초? 정도
select count(*) from tblIndex where name = '최민기';

-- 인덱스 생성
create index idxName
    on tblIndex(name);

select count(*) from tblIndex where name = '최민기'; --경과 시간 0.003초


/*

    인덱스 종류
    1. 고유 인덱스
    2. 비고유 인덱스
    
    3. 단일 인덱스
    4. 복합 인덱스
    
    5. 함수 기반 인덱스

*/

-- 고유 인덱스
-- : 색인의 값이 중복이 불가능하다
-- : PK, UNIQUE
create unique index idxName on tblIndex(name); --동명이인(x)
create unique index idxContientn on tblCountry(continent);


-- 비고유 인덱스
-- : 색인의 값이 중복이 가능하다
-- : 일반 컬럼
create index idxHometown on tblIndex(hometown);

-- 단일 인덱스
-- : 컬럼 1개를 대상으로 만든 인덱스
create index idxHometown on tblIndex(hometown);
drop index idxHometown;

select count(*) from tblIndex where hometown = '서울'; --경과 시간 0.5초 (인덱스 드랍하면 2.5초)

select count(*) from tblIndex where hometown = '서울' and job = '학생'; -- 10초 (인덱가 안된 컬럼이랑 묶어서 하면 느려진다)

-- 복합(결합) 인덱스
-- : 컬럼 N개를 대상으로 만든 인덱스
create index idxHometownJob on tblIndex(hometown, job);

select count(*) from tblIndex where hometown = '서울'; --0.07초 (묶어서 걸었기 때문에 한개만 할때는 느림)

select count(*) from tblIndex where hometown = '서울' and job = '학생'; --0.05초


-- 함수 기반 인덱스
-- : 가공된 값을 사용하는 인덱스


select count(*) from tblIndex where substr(email, instr(email, '@')) = '@naver.com'; --1.4초 

create index idxEmail on tblIndex(email);

select count(*) from tblIndex where substr(email, instr(email, '@')) = '@naver.com'; --1.4초 (인덱스를 걸어도 가공하기때문에 느림)

create index idxEmail on tblIndex(substr(email, instr(email, '@'))); --가공된값으로 인덱스 걸어야됨
