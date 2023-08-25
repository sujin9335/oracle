
-- 단일라인 주석

/* 
다중라인 주석
*/
/*
Oracle 11g xe(Expression Edition)

1.DISK1 설치
- 비밀번호: java1234

2. sqldeveloper 
무설치 파일 C:\class\dev 으로 이동

------------------------------

java
- 제품명
- 회사명 > 썬 > 오라클

Oracle Database
- 제품명
- 회사명

Database
- 데이터베이스 > 데이터 집합
- 관리, 운영, 보안 등.. > 데이터베이스 관리 시스템


데이터베이스 관리 시스템
- Database Management System
- 오라클(DB + DBMS) > DB? DBMS?


백그라운드 프로세스
- 서비스(Service)
- 데몬(Daemon) //서비스와 같은말임


오라클 실행/종료/상태확인 //작업관리자에서 보이는걸 더 상세히 작업할수있음
- win+R > services.msc 

1. OracleServiceXE > 데이터베이스 //더블클릭후 시직유형을 수동으로(메모리를 많이먹음)
			// 시작메뉴에서 start or stop Database로 시작 정지 가능

2. OracleXENSListener > 리스너(클라이언트 도구와 연결)



SQL Developer
- 데이터베이스 클라이언트 툴
- 눈에 안보이는 오라클에 연결해서 조작하는 프로그램
- 개발자 <-> 중계인(데이터베이스 클라이언트) <-> 오라클(데이터베이스 서버)


편집창 > 워크시트(접속된 계정 우클릭 > 워크시트열기) > 스크립트(파일) > *.sql
ex01.sql저장

환경설정 
인코딩 > UTF-8
왼쪽 코드편집기 > 글꼴


localhost + system

localhost > 현재 컴퓨터

localhost == 127.0.0.1(IP Address, 루프백, this)


system 작업 안함 > 권한이 너무 커서;; > 실수, 보안

일반 계정 작업 > 특정 업무에 대한 권한만 계정 > 수업


학습용 계정 제공(=일반 계정) > + 샘플 데이터 > hr


특정 계정의 비밀번호 바꾸기
- alter user 계정명 identified by 비밀번호;

특정 계정의 활성화/비활성화
- alter user 계정명 account unlock;
- alter user 계정명 account lock;


*/

alter user hr identified by java1234;

alter user hr account unlock;

/*

JDK 1.8
JDK 1.11
JDK 1.20 < 현재


Oracle Database 11g Enterprise Edition(기업용)
Oracle Database 11g Express Edition(무료, 교육용)


SQL, Structured Query Language
- 구조화된 질의 언어
-  개발자(SQL Developer) <-> SQL <-> 오라클
- DBMS 조작하기 위한 언어

오라클 + SQL
1. 데이터베이스 관리자, DBA
    - 모든 것

2. 데이터베이스 개발자, DB 개발자
    - 모든 것
    
3. 응용 프로그램 개발자(자바 개발자)
    - 모든 것 or 일부 사용


관계형 DBMS
1. Oracle
2. MS-SQL(Microsoft) 기업용
3. MySQL > 무료(개인,기업)
4. MariaDB > 무료(개인,기업)
5. PostreSQL > 무료(개인,기업)
6. DB2 > IBM
7. SQLite > Mobile


SQL 
1. DBMS 제작사와 독립적이다
    - 모든 관계형 데이터베이스에서 공통적으로 사용하기 위해 만들어진 언어
    - DBMS 제작사에서 SQL이라는 언어를 자신의 제품에 적용

2. 표준 SQL, ANSI-SQL
    - 모든 DBMS에 적용 가능한 SQL

3. 제조사별 SQL
    - 특정 DBMS에 적용 가능한 SQL
    - Oracle > PL/SQL
    - MS-SQL > T-SQL
    
    
오라클 수업 = ANSI-SQL(50~60%) + PL/SQL(20~30%) + 설계,기타(10%)
    
    
관계형 데이터베이스
- 데이터를 표 형식으로 저장/관리 한다.
- SQL을 사용한다.


ANSI-SQL
1. DDL
    - Data Definition Language
    - 데이터 정의어
    - 테이블, 뷰, 사용자, 인덱스 등의 데이터베이스 오브젝트르를
        생성/수정/삭제하는 명령어
    - 구조를 생성/관리하는 명령어
    a. CREATE : 생성
    b. DROP : 삭제
    c. ALTER : 수정
    - 데이터베이스 관리자
    - 데이터베이스 담당자
    - 프로그래머(일부)
    
    
2. DML
    - Data Manipulation language
    - 데이터 조작어
    - 데이터를 추가/수정/삭제/조회하는 명령어
    - CRUD
    - 사용 빈도가 가장 높음
    a. SELECT: 조회(읽기) > R
    b. INSERT: 추가(생성) > C
    c. UPDATE: 수정 > U
    d. DELETE: 삭제 > D
    - 데이터베이스 관리자
    - 데이터베이스 담당자
    - 프로그래머(*************************)
        
    
3. DCL
   - Data Control Language
    - 데이터 제어어
    - 계정 관리, 보안 관리, 트랜젝션 관리 등..
    a. COMMIT
    b. ROLLBACK
    c. GRANT
    d. REVOKE
    - 데이터베이스 관리자
    - 데이터베이스 담당자
    - 프로그래머(일부)


4. DQL
    - Data Query Language
    - DML 중에서 SELECT문을 따로 부르는 표현
    
5. TCL
    - Transaction Control Language
    - DCL 중에서 COMMIT, ROLLBACK문을 따로 부르는 표현
    
    
    
오라클 인코딩
- 1.0 ~ 8i: EUC-KR
- 9i ~ 현재: UTF-8


*/

-- SQL > 대소문자를 구분하지 않는다
-- 파란색 > 키워드
-- 검은색 > 식별자

select * from tabs;

SELECT * FROM tabs;

-- 'JOBS' > 문자 상수 > 데이터는 대소문자를 구분한다.(******)

select * from tabs where table_name = 'JOBS';

select * from tabs where table_name = 'jobs';


-- 1. 키워드 > 대문자
-- 2. 식별자 > 캐멀
SELECT * FROM tabs;

SELECT * FROM tabs; -- 단축키 alt + '







