-- ex20_join.sql



/*

	관계형 데이터베이스 시스템이 지양하는 것들
	
	1. 테이블에 기본키가 없는 상태 > 데이터 조작 곤란
	- 테이블 다시 수정해야 고쳐지는 것들 > 구조적인 문제!!
	
	2. null이 많은 상태의 테이블 > 공간 낭비
	3. 데이터가 중보고디는 상태 > 공간 낭비 + 데이터 조작 곤란
	4. 하나의 속성값이 원자값이 아닌 상태 > 더 이상 쪼개지지 않는 값을 넣어야 한다


*/

-- 1.
CREATE TABLE tblTest
(
	name vachar2(30) NOT NULL,
	age number(3) NOT NULL,
	nick vachar2(30) NOT NULL
);

-- 홍길동, 20, 강아지
-- 아무개, 22, 바보
-- 테스트, 20, 반장
-- 홍길동, 20, 강아지 > 발생(x), 조작(?)

-- 홍길동 별명 수정
UPDATE tblTest SET nick = '고양이' WHERE name = '강아지'; --식별 불가능

-- 홍길동 탈퇴
DELETE FROM tblTest WHERE name = '홍길동'; --식별 불가능


-- 2. null이 많은 상태의 테이블 > 공간 낭비
CREATE TABLE tblTest
(
	name vachar2(30) PRIMARY KEY,
	age number(3) NOT NULL,
	nick vachar2(30) NOT NULL,
	hobby1 varchar2(100) NULL,
	hobby2 varchar2(100) NULL,
	hobby3 varchar2(100) NULL,
	..
	hobby8 varchar2(100) NULL
);

-- 홍길동, 20, 강아지, null,null,null,null,null,null,null,null
-- 아무개, 22, 고양이, 게임,null,null,null,null,null,null,null
-- 이순신, 24, 거북이, 수영, 활쏘기,null,null,null,null,null,null
-- 테스트, 25, 닭, 수영,독서,낮잠,여행,맛집,공부,코딩,영화



-- 직원정보
-- 직원(번호(PK), 직원명, 급여, 거주지, 담당프로젝트)
CREATE TABLE tblstaff(
	seq NUMBER PRIMARY KEY,			--직원번호(PK)
	name varchar2(30) NOT NULL,		--직원명
	salary NUMBER NOT NULL,			--급여
	address varchar2(300) NOT NULL, --거주지
	project varchar2(300) NULL		--담당프조게트
);

INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (1, '홍길동', 300, '서울시', '홍콩 수출');

INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (2, '아무개', 250, '인천시', 'TV 광고');

INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (3, '하하하', 350, '의정부시', '매출 분석');

SELECT * FROM tblstaff;

 
-- '홍길동'에게 담당 프로젝트가 1건 추가 > '고객 관리'
-- '홍콩 수출,고객관리'
UPDATE tblstaff SET project = project + ',고객 관리' WHERE seq = 1;


INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (4, '홍길동', 300, '서울시', '고객 관리');

INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (5, '호호호', 250, '서울시', '게시판 관리,회원 응대');

INSERT INTO tblstaff (seq, name, salary, address, project)
	VALUES (6, '호호호', 250, '부산시', '불량 회원 응대');

SELECT * FROM tblstaff;

-- 'TV 광고' > 담당자!! > 확인?
SELECT * FROM tblstaff WHERE project = 'TV 광고';

-- 'TV 광고' > 담당자!! > 확인?
SELECT * FROM tblstaff WHERE project like '%회원 응대%';

-- '회원 응대' > '멤버 조치' 수정
UPDATE tblstaff SET project = '멤버 조치' WHERE project LIKE '%,회원 응대%';



-- 해결 > 테이블 재구성
DROP TABLE tblstaff;
DROP TABLE tblproject;

-- 직원 정보
-- 직원(번호(PK), 직원명, 급여, 거주지) -- 문제되는 컬럼 제거
CREATE TABLE tblStaff(
	seq NUMBER PRIMARY KEY,			--직원번호(PK)
	name varchar2(30) NOT NULL,		--직원명
	salary NUMBER NOT NULL,			--급여
	address varchar2(300) NOT NULL --거주지
);

-- 프로젝트 정보
CREATE TABLE tblProject (
	seq NUMBER PRIMARY KEY,			--프로젝트 번호(PK)
	project varchar2(100) NOT NULL,	--프로젝트명
	staff_seq NUMBER NOT NULL		--담당 직원 번호	
); 


insert INTO tblstaff(seq, name, salary, address) VALUES (1, '홍길동', 300, '서울시'); 
insert INTO tblstaff(seq, name, salary, address) VALUES (2, '아무개', 250, '인천시'); 
insert INTO tblstaff(seq, name, salary, address) VALUES (3, '하하하', 250, '부천시'); 

insert INTO tblproject(seq, project, staff_seq) VALUES (1, '홍콩 수출', 1); 
insert INTO tblproject(seq, project, staff_seq) VALUES (2, 'TV 광고', 2); 
insert INTO tblproject(seq, project, staff_seq) VALUES (3, '매출 분석', 3); 
insert INTO tblproject(seq, project, staff_seq) VALUES (4, '노조 협상', 1); 
insert INTO tblproject(seq, project, staff_seq) VALUES (5, '대리점 분양', 2); 

SELECT * FROM tblstaff;
SELECT * FROM tblproject;

-- 'TV 광고' 담당자!!!
SELECT * FROM tblstaff 
	WHERE seq =(SELECT staff_seq FROM tblproject WHERE project = 'TV 광고');


-- A. 신입 사원 입사 > 신규 프로젝트 담당
-- A.1 신입 사원 추가(0)
insert INTO tblstaff(seq, name, salary, address) VALUES (4, '호호호', 250, '성남시'); 

-- A.2 신규 프로젝트 추가
insert INTO tblproject(seq, project, staff_seq) VALUES (6, '자제 매입', 4);

-- A.3 신규 프로젝트 추가 > 에러(x) > 논리 오류!!!
insert INTO tblproject(seq, project, staff_seq) VALUES (7, '고객 유치', 5); --5는 없는 담당자 

SELECT * FROM tblstaff 
	WHERE seq =(SELECT staff_seq FROM tblproject WHERE project = '고객 유치'); -- 담당자가 없음


-- B. '홍길동' 퇴사
-- B.1 '홍길동' 삭제
DELETE FROM tblstaff WHERE seq = 1; --project 는 홍길동 것 그대로있어 바로하면 안됨

-- B.2 '홍길동' 삭제 > 인수 인계(위임)
UPDATE tblproject SET staff_seq = 2 WHERE staff_seq = 1;

-- B.3 '홍길동' 삭제
DELETE FROM tblstaff WHERE seq = 1;


-- 해결 테이블 (참조 컬럼에 FK - REFERENCES 설정)
-- 직원(번호(PK), 직원명, 급여, 거주지) -- 문제되는 컬럼 제거
CREATE TABLE tblStaff(
	seq NUMBER PRIMARY KEY,			--직원번호(PK)
	name varchar2(30) NOT NULL,		--직원명
	salary NUMBER NOT NULL,			--급여
	address varchar2(300) NOT NULL --거주지
); -- 부모테이블

-- 프로젝트 정보
CREATE TABLE tblProject (
	seq NUMBER PRIMARY KEY,								--프로젝트 번호(PK)
	project varchar2(100) NOT NULL,						--프로젝트명
	staff_seq NUMBER NOT NULL REFERENCES tblstaff(seq)	--담당 직원 번호(FK)	(순서가 생김)
); -- 자식테이블

DROP TABLE tblstaff;		--2 딜리트도 순서가 생기게됨
DROP TABLE tblproject;		--1



-- *** 자식 테이블 보다 부모 테이블이 먼저 발생한다(테이블 생성, 레코드 생성)

-- 고객 테이블
create table tblCustomer (
    seq number primary key,         --고객번호(PK)
    name varchar2(30) not null,     --고객명
    tel varchar2(15) not null,      --연락처
    address varchar2(100) not null  --주소
);

-- 판매내역 테이블
create table tblSales (
    seq number primary key,                             --판매번호(PK)
    item varchar2(50) not null,                         --제품명
    qty number not null,                                --판매수량
    regdate date default sysdate not null,              --판매날짜
    cseq number not null references tblCustomer(seq)    --판매한 고객번호(FK)
);



-- [비디오 대여점]

-- 장르 테이블
create table tblGenre (
    seq number primary key,         --장르 번호(PK)
    name varchar2(30) not null,     --장르명
    price number not null,          --대여가격
    period number not null          --대여기간(일)
);

-- 비디오 테이블
create table tblVideo (
    seq number primary key,                         --비디오 번호(PK)
    name varchar2(100) not null,                    --비디오 제목
    qty number not null,                            --보유 수량
    company varchar2(50) null,                      --제작사
    director varchar2(50) null,                     --감독
    major varchar2(50) null,                        --주연배우
    genre number not null references tblGenre(seq)  --장르 번호(FK)
);


-- 고객 테이블
create table tblMember (
    seq number primary key,         --고객번호(PK)
    name varchar2(30) not null,     --고객명
    grade number(1) not null,       --고객등급(1,2,3)
    byear number(4) not null,       --생년
    tel varchar2(15) not null,      --연락처
    address varchar2(300) null,     --주소
    money number not null           --예치금
);

-- 대여 테이블
create table tblRent (
    seq number primary key,                             --대여번호(PK)
    member number not null references tblMember(seq),   --회원번호(FK)
    video number not null references tblVideo(seq),     --비디오번호(FK)
    rentdate date default sysdate not null,             --대여시각
    retdate date null,                                  --반납시각
    remark varchar2(500) null                           --비고
);

SELECT * FROM tblgenre;
SELECT * FROM tblvideo;
SELECT * FROM tblMember;
SELECT * FROM tblRent;


/*

	조인, Join
	- (서로 관계를 맺은) 2개(1개) 이상의 테이블을 1개의 결과셋으로 만드는 기술
	
	조인의 종류
	1. 단순 조인, CROSS JOIN
	2. 내부 조인, INNER JOIN ***
	3. 외부 조인, OUTER JOIN ***
	4. 셀프 조인, SELF JOIN
	5. 전체 외부 조인, FULL OUTER JOIN


*/

/*

	1. 단순 조인, CROSS JOIN, 카티션곱(데크라트곱)
	- A 테이블 X B 테이블
	- 쓸모없다. > 가치 있는 행과 가치없는 행이 뒤섞여서 있어서..
	- 더미 데이터(유효성 무관)


*/

SELECT * FROM tblcustomer; --3명

SELECT * FROM tblsales; --9건

SELECT * FROM tblcustomer CROSS JOIN tblsales; --27개 ANSI-SQL(추천)
SELECT * FROM tblcustomer, tblsales; --Oracle


/*

	2. 내부 조인, INNER JOIN
	- 단순 조인에서 유효한 레코드만, 추출한 조인

	select 컬럼리스트 from 테이블A cross joiin 테이블B;
	
	select 컬럼리스트 from 테이블A inner joiin 테이블B on 테이블A.PK = 테이블B.FK;
	
	select 
		컬럼리스트 
	from 테이블A 
		inner joiin 테이블B 
			on 테이블A.PK = 테이블B.FK;
	

*/

-- 직원 테이블, 프로젝트 테이블
SELECT
	*
FROM tblstaff
	CROSS JOIN tblproject;


-- 조인 > 테이블 별칭 자주 사용
SELECT				--2.
	s.seq,
	s.name,
	p.seq,
	p.project
FROM tblstaff s INNER JOIN tblproject p ON s.seq = p.staff_seq --1.
	ORDER BY s.seq;	--3.


-- 고객 테이블, 판매 테이블
SELECT 
	c.name AS 고객명,
	s.item AS 제품명,
	s.qty AS 개수
FROM tblcustomer c
	INNER JOIN tblsales s
		ON c.seq = s.cseq;


SELECT * FROM tblMen;
SELECT * FROM tblwomen;

SELECT
	*
FROM tblmen m
	INNER JOIN tblwomen w
		ON m.name = w.couple;

SELECT
	*
FROM tblinsa i
	INNER JOIN tblsales s;



-- 고객명(tblCustomer) + 판매물품명(tblSales) > 가져오시오
-- 1. 조인
SELECT
	c.name,
	s.item
FROM tblcustomer c
	INNER JOIN tblsales s
		ON c.seq = s.cseq;

SELECT * FROM tblcustomer;
SELECT * FROM tblsales;


-- 2. 서브 쿼리 > 상관 서브 쿼리
-- 메인쿼리 > 자식 테이블
-- 상관 서브 쿼리 > 부모 테이블
SELECT
	item AS 물품명,
	(SELECT name FROM tblcustomer WHERE seq = tblsales.cseq) AS 고객명
FROM tblsales;








