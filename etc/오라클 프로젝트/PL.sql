

set serveroutput on;
--로그인PL
create or replace procedure login(
    pid in varchar2,
    ppw in varchar2
)
is
    vtype varchar2(30);
    vname varchar2(30);
begin
    vname := pid;
    select logintype into vtype from tblLogin where id = pid and pw = ppw; 
   
    if vtype = '관리자' then
        dbms_output.put_line('관리자 ' || vname || '님 안녕하세요');
        dbms_output.put_line('1. 기초 정보 관리');
        dbms_output.put_line('2. 교사 계정 관리');
        dbms_output.put_line('3. 개설 과정 관리');
        dbms_output.put_line('4. 교육생 관리');
        dbms_output.put_line('5. 시험 관리 및 성적 조회');
        dbms_output.put_line('6. 출결 관리 및 조회');
    elsif vtype = '교사' then
        dbms_output.put_line('교사 ' || vname || '님 안녕하세요');
        dbms_output.put_line('1, 강의 스케줄 조회');
        dbms_output.put_line('2. 배점 입출력');
        dbms_output.put_line('3. 성적 입출력');
        dbms_output.put_line('4. 출결 관리 및 출결 조회');
    elsif vtype = '교육생' then
        dbms_output.put_line('교육생 ' || vname || '님 안녕하세요');
        dbms_output.put_line('1, 성적 조회');
        dbms_output.put_line('2, 출결 관리 및 출결 조회');

    end if;
exception
    when others then
        dbms_output.put_line('로그인 실패');
end login;
-------------------------------------------------------------------

--관리자 상세기능 2-1-? 
create or replace procedure adminSelec(
    pinput in number
)
is
    vnum number;
begin
    vnum := pinput;

    if vnum = 1 then
        dbms_output.put_line('1. 기초 정보 목록');
        dbms_output.put_line('2. 기초 정보 등록');
        dbms_output.put_line('3. 기초 정보 수정');
        dbms_output.put_line('4. 기초 정보 삭제');
    elsif vnum = 2 then
        dbms_output.put_line('1. 교사 정보 목록');
        dbms_output.put_line('2. 교사 정보 등록');
        dbms_output.put_line('3. 교사 정보 수정');
        dbms_output.put_line('4. 교사 정보 삭제');
    elsif vnum = 3 then
        dbms_output.put_line('1. 개설 과정 목록');
        dbms_output.put_line('2. 개설 과목 목록');
        dbms_output.put_line('3. 개설 과정 등록');
        dbms_output.put_line('4. 개설 과정 수정');
        dbms_output.put_line('5. 개설 과정 삭제');
        dbms_output.put_line('6. 개설 과정 수료');
    elsif vnum = 4 then
        dbms_output.put_line('1. 교육생 목록');
        dbms_output.put_line('2. 교육생 등록');
        dbms_output.put_line('3. 교육생 수정');
        dbms_output.put_line('4. 교육생 삭제');
        dbms_output.put_line('5. 교육생 검색');
    elsif vnum = 5 then
        dbms_output.put_line('1. 시험 관리 목록');
        dbms_output.put_line('2. 성적 정보 목록');
    elsif vnum = 6 then
        dbms_output.put_line('1. 특정 과정 출결 조회');
        dbms_output.put_line('2. 특정 인원 출결 조회');
        dbms_output.put_line('3. 기간별 출결 조회');
        dbms_output.put_line('4. 출결 수정 관리');
    else
        dbms_output.put_line('잘못입력 하셨습니다');
    end if;

end adminSelec;

-------------------------------------------------------------------

--교사 상세기능 2-2-? 
create or replace procedure teacherSelec(
    pinput in number
)
is
    vnum number;
begin
    vnum := pinput;

    if vnum = 1 then
        dbms_output.put_line('1. 강의 예정');
        dbms_output.put_line('2. 강의 중');
        dbms_output.put_line('3. 강의 종료');
    elsif vnum = 2 then
        dbms_output.put_line('1. 과목 선택(배점 입력)');
    elsif vnum = 3 then
        dbms_output.put_line('1. 과목 선택(성적 입력)');
    elsif vnum = 4 then
        dbms_output.put_line('1. 강의 별 출결 조회');
        dbms_output.put_line('2. 기간 별 출결 조회');
        dbms_output.put_line('3. 과정 별 출결 조회');
        dbms_output.put_line('4. 인원 별 출결 조회');
    else
        dbms_output.put_line('잘못입력 하셨습니다');
    end if;

end teacherSelec;



-------------------------------------------------------------------

--교육생 상세기능 2-3-? 
create or replace procedure studentSelec(
    pinput in number
)
is
    vnum number;
begin
    vnum := pinput;

    if vnum = 1 then
        dbms_output.put_line('1. 과목 선택');
    elsif vnum = 2 then
        dbms_output.put_line('1. 근태 기록');
        dbms_output.put_line('2. 기간 별 출결 조회');
    else
        dbms_output.put_line('잘못입력 하셨습니다');
    end if;

end studentSelec;

-------------------------------------------------------------------

--기초정보 조회 1-2-1
--create or replace procedure basicList(
--    pinput in number,
--    pcursor out sys_refcursor
--)
--is
--    vnum number;
--
--begin
--    vnum := pinput;
--
----    select * from tblclassroom;
--
--    if vnum = 1 then
--        dbms_output.put_line('1. 강의실 명');
--            open pcursor
--            for
--            select CLASSROOMNAME, CLASSROOMMAXPEOPLE  from tblclassroom order by CLASSROOMNAME;
--       
----    elsif vnum = 2 then
----     
----    elsif vnum = 3 then
----        
----    elsif vnum = 4 then
--       
--    else
--        dbms_output.put_line('잘못입력 하셨습니다');
--    end if;
--
--end basicList;

--기초정보 조회 1-2-1
create or replace procedure basicList(
    pinput in number
)
is
    vnum number;
    vcursor sys_refcursor; --커서 참조 변수
    vrow tblclassroom%rowtype;
begin
    vnum := pinput;

--    select * from tblclassroom;

    if vnum = 1 then
        dbms_output.put_line('1. 강의실 명');
            open vcursor
            for
            select CLASSROOMNAME, CLASSROOMMAXPEOPLE  from tblclassroom order by CLASSROOMNAME;
        
        loop 
            fetch vcursor into vrow;
            exit when vcursor%notfound;
            dbms_output.put_line('강의실명: ' || vrow.classroomname || ' 강의실 인원수:' || vrow.CLASSROOMMAXPEOPLE);
        end loop;
--    elsif vnum = 2 then
--     
--    elsif vnum = 3 then
--        
--    elsif vnum = 4 then
       
    else
        dbms_output.put_line('잘못입력 하셨습니다');
    end if;

end basicList;









