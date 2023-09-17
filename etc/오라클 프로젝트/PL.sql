

set serveroutput on;
--로그인PL
create or replace procedure login(
    pid in varchar2,
    ppw in varchar2
)
is
    vtype varchar2(30);
    vname varchar2(30);
    pseq vwStudent.번호%type;
    pname vwStudent.이름%type;
    pphon vwStudent.번호%type;
    psub vwStudent.과정명%type;
    pstart vwStudent.과정시작일%type;
    pend vwStudent.과정종료일%type;
    pcr vwStudent.강의실%type;
begin
    vname := pid;
    select basicSeq, logintype into pseq, vtype from tblLogin where id = pid and pw = ppw; 
    
    if vtype = '관리자' then

        dbms_output.put_line('관리자 ' || vname || '님 안녕하세요');
        dbms_output.put_line('1. 기초 정보 관리');
        dbms_output.put_line('2. 교사 계정 관리');
        dbms_output.put_line('3. 개설 과정 관리');
        dbms_output.put_line('4. 교육생 관리');
        dbms_output.put_line('5. 시험 관리 및 성적 조회');
        dbms_output.put_line('6. 출결 관리 및 조회');
    elsif vtype = '교사' then
       
        dbms_output.put_line(pseq || '번 ' || '교사 ' || vname || '님 안녕하세요');
        dbms_output.put_line('1, 강의 스케줄 조회');
        dbms_output.put_line('2. 배점 입출력');
        dbms_output.put_line('3. 성적 입출력');
        dbms_output.put_line('4. 출결 관리 및 출결 조회');
    elsif vtype = '교육생' then 
        
        select 이름, 번호, 과정명, 과정시작일, 과정종료일, 강의실 into pname, pphon, psub, pstart, pend, pcr from vwStudent where 번호 = pseq;
        dbms_output.put_line(psub || ' ' || pseq || '번 교육생 ' || vname || '님 안녕하세요');
        dbms_output.put_line(pcr || ' 강의실' ||' 기간: ' || pstart || '~' || pend);
        dbms_output.put_line('1, 성적 조회');
        dbms_output.put_line('2, 출결 관리 및 출결 조회');

    end if;
exception
    when others then

        dbms_output.put_line('로그인 실패');
end login;
/
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
/
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
/


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
/
-------------------------------------------------------------------

--기초정보 조회 1-2-1
create or replace procedure basicList(
    pinput varchar2
)
is
    vcursor sys_refcursor; --커서 참조 변수
    vrow1 tblclassroom%rowtype;
    vrow2 tblBook%rowtype;
    vrow3 tblSubject%rowtype;
begin


    if pinput = '강의실' then
        open vcursor
        for
        select CLASSROOMNAME, CLASSROOMMAXPEOPLE  from tblclassroom order by CLASSROOMNAME;
        dbms_output.put_line('강의실');
        loop 
            fetch vcursor into vrow1;
            exit when vcursor%notfound;
            dbms_output.put_line('강의실명: ' || vrow1.classroomname);
            dbms_output.put_line('강의실 인원수: ' || vrow1.CLASSROOMMAXPEOPLE || '명');
            dbms_output.put_line('=======================================');
        end loop;
    elsif pinput = '교재' then
        open vcursor
        for
        select bookSeq, bookName, publisher from tblBook order by bookSeq;
        dbms_output.put_line('교재');
        loop 
            fetch vcursor into vrow2;
            exit when vcursor%notfound;
            dbms_output.put_line('번호: ' || vrow2.bookSeq);
            dbms_output.put_line('교재명: ' || vrow2.bookName);
            dbms_output.put_line('출판사명: ' || vrow2.publisher);
            dbms_output.put_line('=======================================');
        end loop;
    elsif pinput = '과목' then
        open vcursor
        for
        select subSeq, subName from tblSubject order by subSeq;
        dbms_output.put_line('과목');
        loop 
            fetch vcursor into vrow3;
            exit when vcursor%notfound;
            dbms_output.put_line('번호: ' || vrow3.subSeq);
            dbms_output.put_line('교재명: ' || vrow3.subName);
            dbms_output.put_line('=======================================');
        end loop;
    else
        dbms_output.put_line('잘못 입력하셨습니다');
    end if;

end basicList;
/
-------------------------------------------------------------------------
create or replace procedure classLoomInsert( --클레스룸 INSERT
    pname tblClassroom.classroomname%type,
    psu tblClassroom.classroomMaxPeople%type
)
is
begin
   insert into tblClassroom values (pname, psu);
end classLoomInsert;
/

-------------------------------------------------------------------------
create or replace procedure classLoomNameUpdate( --클레스룸 이름 수정
    pname tblClassroom.classroomname%type,
    pinput tblClassroom.classroomname%type
)
is
begin
    update tblClassroom set
        classroomname = pinput 
            where classroomname = pname;
end classLoomNameUpdate;
/

-------------------------------------------------------------------------
create or replace procedure classLoomSuUpdate( --클레스룸 인원 수정
    pname tblClassroom.classroomname%type,
    pinput tblClassroom.classroomMaxPeople%type
)
is
begin
    update tblClassroom set
        classroomMaxPeople = pinput 
            where classroomname = pname;
end classLoomSuUpdate;
/
-------------------------------------------------------------------------
create or replace procedure classLoomDelete( --클레스룸 삭제
    pname tblClassroom.classroomname%type
)
is
begin
    DELETE FROM tblClassroom WHERE classroomname = pname;
end classLoomDelete;
/
-------------------------------------------------------------------------
create or replace procedure bookInsert( --교재 INSERT
    pname tblBook.bookname%type,
    ppublisher tblBook.publisher%type
)
is
begin
   insert into tblBook values ((select max(bookseq) from tblBook)+1 ,pname, ppublisher);
end bookInsert;
/
-------------------------------------------------------------------------
create or replace procedure bookNameUpdate( --교재 이름 수정
    pseq tblBook.bookseq%type,
    pinput tblBook.bookname%type
)
is
begin
    update tblBook set
        bookname = pinput 
            where bookseq = pseq;
end bookNameUpdate;
/
-------------------------------------------------------------------------
create or replace procedure bookPublisherUpdate( --교재 출판사 수정
    pseq tblBook.bookseq%type,
    pinput tblBook.publisher%type
)
is
begin
    update tblBook set
        publisher = pinput 
            where bookseq = pseq;
end bookPublisherUpdate;
/
-------------------------------------------------------------------------
create or replace procedure bookDelete( --교재 삭제
    pseq tblBook.bookseq%type
)
is
begin
    DELETE FROM tblBook WHERE bookseq = pseq;
end bookDelete;
/
-------------------------------------------------------------------------
create or replace procedure subInsert( --과목 INSERT
    pname tblSubject.subname%type
)
is
begin
   insert into tblSubject values ((select max(subseq) from tblSubject)+1 ,pname);
end subInsert;
/
-------------------------------------------------------------------------
create or replace procedure subNameUpdate( --과목 이름 수정
    pseq tblSubject.subseq%type,
    pinput tblSubject.subname%type
)
is
begin
    update tblSubject set
        subname = pinput 
            where subseq = pseq;
end subNameUpdate;
/
-------------------------------------------------------------------------
create or replace procedure subDelete( --교재 삭제
    pseq tblSubject.subseq%type
)
is
begin
    DELETE FROM tblSubject WHERE subseq = pseq;
end subDelete;
/
------------------------------------------------------------------------- 교육생기능

create or replace procedure subSelectList( --성적조회 전 과목선택출력
    pseq vwStudent.번호%type
)
is
    vsub vwStudent.과정명%type;
    vcursor sys_refcursor;
    vrow vwsublist%rowtype;
begin
    select 과정명 into vsub from vwstudent where 번호 = pseq;
    open vcursor
    for
    select * from vwsublist where 과정이름 = vsub;
    dbms_output.put_line(vsub);
    loop
        fetch vcursor into vrow;
        exit when vcursor%notfound;
        dbms_output.put_line('과목명: ' || vrow.과목이름);
    end loop;
    
end subSelectList;
/

------------------------------------------------------------------------- 

create or replace procedure scoreList( --성적조회
    pseq vwStudent.번호%type,
    psub vwsublist.과목이름%type
)
is
    vsub vwStudent.과정명%type;    --입력받은 학생의 과정명
    vrow vwsublist%rowtype;
    vrow2 vwscore%rowtype;

begin
    select 과정명 into vsub from vwstudent where 번호 = pseq;
    select * into vrow from vwsublist where 과정이름 = vsub and 과목이름 = psub;
    select * into vrow2 from vwscore where 번호 = pseq and 과목이름 = psub;
    dbms_output.put_line(vsub);
    dbms_output.put_line('과목번호: ' || vrow.리스트번호);
    dbms_output.put_line('과목명: ' || vrow.과목이름);
    dbms_output.put_line('과목기간: ' || vrow.과목시작일 || ' ~ ' || vrow.과목종료일);
    dbms_output.put_line('교재: ' || vrow.교재);
    dbms_output.put_line('교사: ' || vrow.교사);
    dbms_output.put_line('출결 배점: ' || vrow.출결배점);
    dbms_output.put_line('필기 배점: ' || vrow.필기배점 || ' 시험일: ' || vrow.필기시험일);
    dbms_output.put_line('실기 배점: ' || vrow.실기배점 || ' 시험일: ' || vrow.실기시험일);
    dbms_output.put_line('출결점수: ' || vrow2.출결점수);
    dbms_output.put_line('필기점수: ' || vrow2.필기점수);
    dbms_output.put_line('실기점수: ' || vrow2.실기점수);
    
end scoreList;
/
------------------------------------------------------------------------- 

create or replace procedure workIn( -- 출석등록
    pseq tblattendanceStatus.atsSeq%type
)
is
begin
    insert into tblattendanceStatus values ((SELECT nvl(max(atsSeq),0) + 1 from tblattendanceStatus), pseq, default, null);
end workIn;
/
------------------------------------------------------------------------- 

create or replace procedure workout( -- 퇴근등록
    pseq tblattendanceStatus.atsSeq%type
)
is
    pin number;
    pout number;
begin
    update tblattendanceStatus set
        stout = default 
            where studentseq = pseq;
    select to_char(stin, 'hh24'), to_char(stout, 'hh24') into pin, pout from tblattendanceStatus where studentseq = pseq;

    if pin < 9 and pout >= 18 then
        INSERT INTO tblAttendance 
            VALUES ((SELECT nvl(max(attendanceSeq),0) + 1 from tblAttendance),pseq,(select processSeq from tblstudent where studentseq = pseq),sysdate,'정상');
    elsif pin >= 9 and pout >= 18 then
        INSERT INTO tblAttendance 
            VALUES ((SELECT nvl(max(attendanceSeq),0) + 1 from tblAttendance),pseq,(select processSeq from tblstudent where studentseq = pseq),sysdate,'지각');
    else 
        INSERT INTO tblAttendance 
            VALUES ((SELECT nvl(max(attendanceSeq),0) + 1 from tblAttendance),pseq,(select processSeq from tblstudent where studentseq = pseq),sysdate,'조퇴');
    end if;
end workout;
/
-------------------------------------------------------------------

create or replace procedure workCheck(--출석 조회
    pinput varchar2,
    pstdate date,
    pendate date
)
is
    vcursor sys_refcursor; --커서 참조 변수
    vrow tblAttendance%rowtype;

begin
    open vcursor
    for
    select 
        *
    from tblAttendance 
        where AttendanceDate >= pstdate 
            and AttendanceDate < to_date((pendate || ' 23:59:59'), 'yy-mm-dd hh24:mi:ss')
            and studentseq = pinput;
    
    loop 
        fetch vcursor into vrow;
        exit when vcursor%notfound;
        dbms_output.put_line('=======================================');
        dbms_output.put_line(vrow.AttendanceDate || ' 상태: '|| vrow.AttendanceStatus);
        
    end loop;
    dbms_output.put_line('=======================================');


end workCheck;
/
----------------------------------
begin
    --학생번호 (로그인해서 나오는 번호)
    workCheck(146, '23/07/16', '23/07/17');
end;
/
select * from vwsublist;
select * from vwStudent;
select * from tblScoreInfo;