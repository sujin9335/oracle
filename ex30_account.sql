-- ex30_account.sql


/*

    사용자 관련
    - DCL
    - 계정 생성, 삭제 등 제어
    - 리소스 제어 권한
    
    현재 사용 계정
    - system
    - hr
    
    프로젝트 > 계정 생성
    


*/

select * from tabs; -- 현재 스키마(계정 -hr)에서 소유하고 있는 테이블 목록


/*

    사용자가 계정 생성하기
    - 시스템 권한을 가지고 있는 계정만 가능하다 > 관리자급 > system
    - 계정 생성 권한을 가지고 있는 일반 계정도 가능하다

    
    - create user 계정명 identified by 암호;   //계정 생성
    - alter user 계정명 identified by 암호;    //암호 변경
    - alter user 계정명 account unlock;        //계정 잠금 해제
    - alter user 계정명 account lock;          //계정 잠금 설정
    
    
    - 새로 만든 계정 > 아무 권한이 없다. > 접속할 권한도 없다.
    
    
    사용자에게 권한 부여하기
    - grant 권한명 to 유저명;

    사용자에게 권한 제거하기
    - revoke 권한명 from 유저명;
    
    권한명??
    1. 단일 권한
        - create user
        - drop user
        - drop any table
        - create seesion    //접속권한
        - create table
        - create view
        - create sequence
        - create procedure
    
    2. 권한의 집합 > Role
        - connect > 사용자 DB 접속 + 기본적 행동
        - resource > 테이블 등 객체 조작
        - dba > 준관리자급 권한
    

*/

create user hong identified by java1234; --접속 계정을 system으로 변경해야됨

grant create session to hong; -- hong 접속 가능


-------------------------
-- hong 접속해서 
show user; --SQL Developer

select * from tabs;

--  "insufficient privileges" 테이블 만들 권한이 없음
create table tblData(
    seq number primary key,
    data varchar2(100) not null
);

-------------------------

grant create table to hong; -- 테이블 생성 가능

revoke create session from hong; -- 접속 권한 삭제



-- 프로젝트 진행 > 프로젝트용 계정 생성
create user team identified by java1234;

grant connect, resource, dba to team; --hr

alter user team account lock;
alter user team account unlock;


















