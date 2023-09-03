    -- ex13_ddl.sql

/*

	ex01 ~ ex12: DML 기본(기초)
	
	DDL
	- 데이터 정의어 
	- 데이터베이스 객체를 생성/수정/삭제한다
	- 데이터베이스 객체 > 테이블, 뷰, 인덱스, 프로시저, 트리거, 제약사항, 시노닙 등...
	- CREATE, ALTER, DROP
	
	테이블 생성하기 > 스키마 정의하기 > 컬럼 정의하기 > 컬럼의 이름, 자료형, 제약을 정의
	
	create table 테이블명
	(
		컬럼 정의,
		컬럼 정의,
		컬럼 정의,
		컬럼명 자료형(길이),
		컬럼명 자료형(길이) null 제약사항
	);
	
	
	제약 사항, Constraint
	- 해당 컬럼에 들어갈 데이터(값)에 대한 조건
		1. 조건을 만족하면 > 대입
		2. 조건을 불만족하면 > 에러 발생
	- 유효성 검사 도구
	- 데이터 무결성을 보장하기 위한 도구(***)
	
	1. NOT NULL (NN)
		- 해당 컬럼이 반드시 값을 가져야 한다.
		- 해당 컬럼에 값이 없으면 에러 발생
		- 필수값
	
	2. PRIMARY KEY, (PK)
		- 기본키
		- 테이블의 행을 구분하기 위한 제약 사항
		- 행을 식별하는 수많은 키(후보키)들 중 대표로 선정된 키
		- 모든 케이블은 반드시 1개의 기본키가 존재해야 한다(***********)
		- 중복값을 가질 수 없다 > unique
		- 값을 반드시 가진다 > not null
	
	3. FOREIGN KEY, FK
		- 다음에
	
	
	
	4. UNIQUE (UQ)
		- 유일하다 > 레코드간의 중복값을 가질 수 있다
		- null을 가질 수 있다 . 식별자가 될 수 없다
		ex) 초등학교 교실
			- 학생(번호(PK), 이름(NN), 직책(UQ))
			1, 홍길동, 반장
			2, 아무개, null
			3, 하하하, 부반장
			4, 테스트, null
			
		PK = UQ + NN
	
	5. CHECK
		- 사용자 정의형
		- where절의 조건 > 컬럼의 제약 사항으로 적용
	
	6. DEFAULT
		- 기본값 설정
		- insert/update 작업 시 > 컬럼에 값을 안넣으면 nullㄷ 대신 미리 설정한 값을 대입

*/


-- 메모 테이블 null
CREATE TABLE tblMemo
(
	-- 컬럼명 자료형(길이) NULL 제약사항
	seq number(3) NULL,			-- 메모번호
	name varchar2(30) NULL,		-- 작성자
	memo varchar2(1000) NULL,	-- 메모
	regdate DATE NULL			-- 작성날짜

);

SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate) 
	VALUES (1, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate) 
	VALUES (2, '아무개', null, sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate) 
	VALUES (3, null, null, null);

INSERT INTO tblmemo (seq, name, memo, regdate) 
	VALUES (null, null, null, null);



-- 메모 테이블 not null
DROP TABLE tblmemo;

CREATE TABLE tblMemo
(
	seq number(3) NOT NULL,			-- 메모번호(NN)
	name varchar2(30) NULL,			-- 작성자
	memo varchar2(1000) NOT NULL,	-- 메모(NN)
	regdate DATE NULL				-- 작성날짜
);


SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate) 
	VALUES (1, '홍길동', '메모입니다.', sysdate);

--ORA-01400: cannot insert NULL into ("HR"."TBLMEMO"."MEMO")
INSERT INTO tblmemo (seq, name, memo, regdate) 
	VALUES (2, '홍길동', null, sysdate);

INSERT INTO tblmemo (seq, name, regdate) 
	VALUES (2, '홍길동',  sysdate); -- 생략된 컬러멩는 mull이 들어간다

INSERT INTO tblmemo (seq, name, memo, regdate) 
	VALUES (2, '홍길동', '', sysdate); -- 빈문자('')도 null로 취급한다



	
-- 메모 테이블 PRIMARY KEY, PK
DROP TABLE tblmemo;

CREATE TABLE tblMemo
(
	seq number(3) PRIMARY KEY,		-- 메모번호(NN)
	name varchar2(30) NULL,			-- 작성자
	memo varchar2(1000) NOT NULL,	-- 메모(NN)
	regdate DATE NULL				-- 작성날짜
);


SELECT * FROM tblmemo;

--ORA-00001: unique constraint (HR.SYS_C007085) violated
INSERT INTO tblmemo (seq, name, memo, regdate) -- 두번 실행시 에러
	VALUES (1, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (2, '홍길동', '메모입니다.', sysdate);

--ORA-01400: cannot insert NULL into ("HR"."TBLMEMO"."SEQ")
INSERT INTO tblmemo (seq, name, memo, regdate) --NOT NULL 자동
	VALUES (null, '홍길동', '메모입니다.', sysdate);


-- 테이블 내에 PK가 반드시 존재?
DROP TABLE tblmemo;

CREATE TABLE tblMemo
(
	seq number(3) NOT NULL,			-- 메모번호(NN)
	name varchar2(30) NULL,			-- 작성자
	memo varchar2(1000) NOT NULL,	-- 메모(NN)
	regdate DATE NULL				-- 작성날짜
);

SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (1, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (2, '아무개', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (3, '테스트', '메모입니다.', sysdate);


SELECT * FROM tblmemo WHERE name = '아무개';
SELECT * FROM tblmemo WHERE seq = 2; -- 검색 > 주로 PK 검색

SELECT * FROM tblmemo WHERE name = '홍길동';
SELECT * FROM tblmemo WHERE seq = 1;

DELETE FROM tblMomo WHERE seq = 2;



DROP TABLE tblmemo;

CREATE TABLE tblMemo
(
	seq number(3) PRIMARY KEY,		-- 메모번호(pk)
	name varchar2(30) NULL,			-- 작성자
	memo varchar2(1000) NOT NULL,	-- 메모(NN)
	regdate DATE NULL				-- 작성날짜
);


SELECT * FROM tblmemo;

--ORA-00001: unique constraint (HR.SYS_C007085) violated
INSERT INTO tblmemo (seq, name, memo, regdate) -- 두번 실행시 에러
	VALUES (1, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (2, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (3, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (4, '홍길동', '메모입니다.', sysdate);


SELECT * FROM tblmemo WHERE name = '아무개';
SELECT * FROM tblmemo WHERE seq = 2; -- 검색 > 주로 PK 검색

SELECT * FROM tblmemo WHERE name = '홍길동';
SELECT * FROM tblmemo WHERE seq = 4;

DELETE FROM tblMomo WHERE seq = 4;



-- 메모 테이블 unique
DROP TABLE tblmemo;

CREATE TABLE tblMemo
(
	seq number(3) PRIMARY KEY,		-- 메모번호(pk)
	name varchar2(30) UNIQUE,		-- 작성자(UQ)
	memo varchar2(1000) NOT NULL,	-- 메모(NN)
	regdate DATE NULL				-- 작성날짜
);


SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (1, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate) --이름이 같아서 안됨
	VALUES (2, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (2, '아무개', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate) -- NULL 가능
	VALUES (2, null, '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (4, null, '메모입니다.', sysdate);




-- 메모 테이블 check
DROP TABLE tblmemo;

CREATE TABLE tblMemo
(
	seq number(3) PRIMARY KEY,		-- 메모번호(pk)
	name varchar2(30),				-- 작성자
	memo varchar2(1000),			-- 메모
	regdate DATE, 					-- 작성날짜
	-- 중요도(1(중요), 2(보통), 3(안중요))
	--prioriy NUMBER(1) CHECK(prioriy >= 1 AND prioriy <= 3)
	priority NUMBER(1) CHECK(priority between 1 AND 3), -- check()는 WHERE 작성하듯이 작성
	categroy varchar2(30) CHECK(categroy IN ('할일', '공부', '약속')) -- 카테고리(할일,공부, 약속)
);

SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate, priority, categroy)
	VALUES (1, '홍길동', '메모입니다.', sysdate, 1, '할일');

INSERT INTO tblmemo (seq, name, memo, regdate, priority, categroy)
	VALUES (2, '홍길동', '메모입니다.', sysdate, 5, '할일');

INSERT INTO tblmemo (seq, name, memo, regdate, priority, categroy)
	VALUES (3, '홍길동', '메모입니다.', sysdate, 1, '개인');





-- 메모 테이블 default
DROP TABLE tblmemo;

CREATE TABLE tblMemo
(
	seq number(3) PRIMARY KEY,			-- 메모번호(pk)
	name varchar2(30) DEFAULT '익명',		-- 작성자
	memo varchar2(1000) ,				-- 메모
	regdate DATE DEFAULT sysdate		-- 작성날짜
);


SELECT * FROM tblmemo;

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (1, '홍길동', '메모입니다.', sysdate);

INSERT INTO tblmemo (seq, name, memo, regdate) 
	VALUES (2, null, '메모입니다.', null); -- 값을 null로 넣으면 DEFAULT 실행안됨

INSERT INTO tblmemo (seq, memo)
	VALUES (3, '메모입니다.');

INSERT INTO tblmemo (seq, name, memo, regdate) 
	VALUES (4, default, '메모입니다.', default); -- DEFAULT 상수


-------------------------------------------

/*
	
	제약 사항을 만드는 방법
	
	1. 컬럼 수준에서 만드는 방법
		- 위에서 수업한 방법
		- 컬럼을 선언할 때 제약 사항도 같이 선언하는 방법
		
	2. 테이블 수준에서 만드는 방법
	3. 외부에서 만드는 방법

*/

	
CREATE TABLE tblMemo
(
	seq number(3),						-- 메모번호
	name varchar2(30),					-- 작성자
	memo varchar2(1000) DEFAULT '메모임',	-- 메모
	regdate DATE NOT NULL, 				-- 작성날짜
	
	-- 테이블 수준에서 제약 사항 정의 > 가독성 (NOT NULL, DEFAULT 는 여기에 정의 못함)
	CONSTRAINT tblmemo_seq_pk PRIMARY KEY(seq),
	CONSTRAINT tblmemo_name_uq unique(name),
	CONSTRAINT tblmemo_memo_ck check(LENGTH(memo) >= 10)
);	
	
	
	
	
	
	
	
	
	
	
	
	
