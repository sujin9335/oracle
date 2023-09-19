set serverout on;

-- 1. 강의 스케줄 출력
-- 1.1. 해당 교사의 스케줄 출력
-- 해당 교사 스케줄 가져오기

create or replace view vwTeacherSchedule
as
select 
    sl.subseq as 과목번호, sch.teacherseq as 교사번호, sl.courseseq as 과정번호, c.coursename as 과정명, c.coursestartdate as 과정시작일, c.coursefinishdate as 과정종료일, 
    c.classroomname as 강의실, s.subname as 과목명, sl.subjectstartdate as 과목시작일, sl.subjectfinishdate as 과목종료일,
    b.bookname as 교재명, c.studentnumber as 교육생등록인원,
    case
        when sl.subjectstartdate > sysdate and sl.subjectfinishdate > sysdate then '강의예정'
        when sl.subjectstartdate < sysdate and sl.subjectfinishdate > sysdate then '강의중'
        when sl.subjectfinishdate < sysdate then '강의종료'
    end as 강의진행여부
from tblSchedule sch
    inner join tblSubjectList sl
        on sch.subjectlistseq = sl.subjectlistseq
            inner join tblCourse c
                on sl.courseseq = c.courseseq
                    inner join tblBook b
                        on sl.bookseq = b.bookseq
                            inner join tblSubject s
                                on sl.subseq = s.subseq
order by sl.subjectstartdate asc;

--select * from vwTeacherSchedule;


--create or replace procedure procGetTeacherSchedule(
--    pteacherseq in number,
--    pcursor out SYS_REFCURSOR
--)
--is
--begin
--    open pcursor
--    for
--    select 
--        sl.subseq as 과목번호, 
--        sl.courseseq as 과정번호, 
--        c.coursename as 과정명, 
--        c.coursestartdate as 과정시작일, 
--        c.coursefinishdate as 과정종료일, 
--        c.classroomname as 강의실, 
--        s.subname as 과목명, 
--        sl.subjectstartdate as 과목시작일, 
--        sl.subjectfinishdate as 과목종료일,
--        b.bookname as 교재명, 
--        c.studentnumber as 교육생등록인원,
--        case
--            when sl.subjectstartdate > sysdate and sl.subjectfinishdate > sysdate then '강의예정'
--            when sl.subjectstartdate < sysdate and sl.subjectfinishdate > sysdate then '강의중'
--            when sl.subjectfinishdate < sysdate then '강의종료'
--        end as 강의진행여부
--    from tblSchedule sch
--        inner join tblSubjectList sl on sch.subjectlistseq = sl.subjectlistseq
--        inner join tblCourse c on sl.courseseq = c.courseseq
--        inner join tblBook b on sl.bookseq = b.bookseq
--        inner join tblSubject s on sl.subseq = s.subseq
--    where sch.teacherseq = pteacherseq
--    order by sl.subjectstartdate asc;
--exception
--    when NO_DATA_FOUND then
--        dbms_output.put_line('해당 교사의 스케줄이 없습니다.');  
--        
--    when others then
--    dbms_output.put_line('예외 처리');
--end procGetTeacherSchedule;


-- 뷰 적용 버전
-- 교사 번호에 해당하는 교사 테이블 가져오기
create or replace procedure procGetTeacherSchedule(
    pteacherseq in number,
    pcursor out SYS_REFCURSOR
)
is
begin
    open pcursor
    for
    select 
        과목번호, 과정번호, 과정명, 과정시작일, 과정종료일, 강의실, 과목명, 과목시작일, 과목종료일, 교재명, 교육생등록인원, 강의진행여부
    from vwTeacherSchedule
    where 교사번호 = pteacherseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('해당 교사의 스케줄이 없습니다.');  
        
    when others then
    dbms_output.put_line('예외 처리');
end procGetTeacherSchedule;





-- 교사명 가져오기 프로시저
create or replace procedure procGetTeacherName(
    pteacherseq number,
    pteachername out varchar2
)
is
begin
    select name into pteachername from tblTeacher where teacherseq = pteacherseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('해당 교사가 없습니다.');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetTeacherName;


-- 교사 스케줄 출력 프로시저
create or replace procedure procPrintTeacherSchedule(
    pteacherseq number -- 교사번호
)
is
    vcursor sys_refcursor;
    vsubseq tblSubjectList.subseq%type;
    vcourseseq tblSubjectList.courseseq%type;
    vcoursename tblCourse.coursename%type;
    vcoursestartdate tblCourse.coursestartdate%type;
    vcoursefinishdate tblCourse.coursefinishdate%type;
    vclassroomname tblCourse.classroomname%type;
    vsubname tblSubject.subname%type;
    vsubjectstartdate tblSubjectList.subjectstartdate%type;
    vsubjectfinishdate tblSubjectList.subjectfinishdate%type;
    vbookname tblBook.bookname%type;
    vstudentnumber tblCourse.studentnumber%type;
    vprogress varchar2(30);
    vteachername tblTeacher.name%type;
begin
    -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '  교사명:  ' || vteachername); 
    
    dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    -- 해당 교사 스케줄 가져오기
    procGetTeacherSchedule(pteacherseq, vcursor);
    
    -- 해당 교사 스케줄 출력
    loop
        fetch vcursor into vsubseq, vcourseseq, vcoursename, vcoursestartdate, vcoursefinishdate, vclassroomname, vsubname, vsubjectstartdate, vsubjectfinishdate, vbookname, vstudentnumber, vprogress;
            exit when vcursor%notfound;
                dbms_output.put_line('과목번호: ' || vsubseq || '   과정번호: ' || vcourseseq || '   과정명: ' || vcoursename ||'   과정시작일: ' || vcoursestartdate || '   과정종료일: ' || vcoursefinishdate || '   강의실: ' || vclassroomname || '   과목명: ' || vsubname || '   과목시작일: ' || vsubjectstartdate || '   과목종료일: ' || vsubjectfinishdate || '   교재명: ' || vbookname || '   교육생등록인원: ' || vstudentnumber || '   강의진행여부: ' || vprogress);
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('결과가 없습니다.');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintTeacherSchedule;



-- 최종 실행
begin 
    procPrintTeacherSchedule(1);
end;


-- 1.2. 과정번호 입력시 해당 과정 듣는 교육생 정보 출력
-- 해당 과정을 듣는 교육생 정보 테이블 가져오기
create or replace procedure procGetCourseStudentList(
    pcourseseq number,
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
    select 
        studentseq as 교육생번호, name as 교육생이름, phone as 전화번호, registerdate as 등록일, compldropstatus as 수료중도탈락여부
    from tblstudent 
    where processseq = pcourseseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('해당 과정을 듣는 교육생이 없습니다.');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseStudentList;


-- 과정명 가져오기
create or replace procedure procGetCourseName(
    pcourseseq number,
    pcoursename out varchar2
)
is
begin
    select coursename into pcoursename from tblCourse where courseseq = pcourseseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('해당 과정이 없습니다.');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseName;


-- 교육생 정보 테이블 출력하기
create or replace procedure procPrintCourseStudentList(
    pcourseseq number
)
is
    vcursor sys_refcursor;
    vstudentseq tblstudent.studentseq%type;
    vname tblstudent.name%type;
    vphone tblstudent.phone%type;
    vregdate tblstudent.registerdate%type;
    vstatus tblstudent.compldropstatus%type;
    vcoursename tblcourse.coursename%type;
begin
    -- 입력한 번호가 교사가 진행하는 과목의 과정인지 물어보는거 나중에 시간되면 추가하기.
    -- 일단은 강사 스케줄의 번호만 입력된다는 가정임.

    -- 과정번호와 과정명 출력하기
    procGetCourseName(pcourseseq, vcoursename);
    dbms_output.put_line('과정번호: '  || pcourseseq ||'   과정명: ' || vcoursename);
    
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------');
    
    -- 교육생 목록 출력하기
    procGetCourseStudentList(pcourseseq, vcursor);
    loop
        fetch vcursor into vstudentseq, vname, vphone, vregdate, vstatus;
        exit when vcursor%notfound;
            dbms_output.put_line('교육생번호: ' || vstudentseq || '   교육생이름: ' || vname || '   전화번호: ' || vphone || '   등록일: ' || vregdate || '   수료|중도탈락 여부: ' || vstatus);
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('결과가 없습니다.');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintCourseStudentList;

-- 실행
begin
    procPrintCourseStudentList(10);
end;

-----------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. 배점 입출력
-- 2.1. 강의를 마친 과목 목록 출력하기

-- 교사번호에 맞는 강의완료 테이블 가져오기
create or replace procedure procGetTFinishedSubject(
    pteacherseq in number,
    pcursor out SYS_REFCURSOR
)
is
begin
    open pcursor
    for
    select 
        sl.subseq as 과목번호, sl.courseseq as 과정번호, c.coursename as 과정명, c.coursestartdate as 과정시작일, c.coursefinishdate as 과정종료일, 
        c.classroomname as 강의실, s.subname as 과목명, sl.subjectstartdate as 과목시작일, sl.subjectfinishdate as 과목종료일,
        b.bookname as 교재명,
        sg.attendancegrade as 출결배점, sg.writtengrade as 필기배점, sg.practicalgrade as 실기배점,
        sct.writtentestdate as 필기시험날짜, sct.practicaltestdate as 실기시험날짜, sct.writtentestfilereg as 필기시험등록여부, sct.practicaltestfilereg as 실기시험등록여부
    from tblSchedule sch
        inner join tblSubjectList sl
            on sch.subjectlistseq = sl.subjectlistseq
                inner join tblCourse c
                    on sl.courseseq = c.courseseq
                        inner join tblBook b
                            on sl.bookseq = b.bookseq
                                inner join tblSubject s
                                    on sl.subseq = s.subseq
                                        inner join tblsubjectgrade sg
                                            on sl.subjectlistseq = sg.subjectlistseq
                                                inner join tblscoretest sct
                                                    on sct.subjectlistseq = sl.subjectlistseq
    where sch.teacherseq = pteacherseq and sl.subjectfinishdate < sysdate
    order by sl.subjectstartdate;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetTFinishedSubject;




-- 강의 종료된 교사의 과목 목록 출력하기
create or replace procedure procPrintTFinishedSubject(
    pteacherseq number
)
is
    vcursor sys_refcursor;
    vsubseq tblSubjectList.subseq%type;
    vcourseseq tblSubjectList.courseseq%type;
    vcoursename tblCourse.coursename%type;
    vcoursestartdate tblCourse.coursestartdate%type;
    vcoursefinishdate tblCourse.coursefinishdate%type;
    vclassroomname tblCourse.classroomname%type;
    vsubname tblSubject.subname%type;
    vsubjectstartdate tblSubjectList.subjectstartdate%type;
    vsubjectfinishdate tblSubjectList.subjectfinishdate%type;
    vbookname tblBook.bookname%type;
    vattgrade tblSubjectGrade.attendancegrade%type;
    vwgrade tblSubjectGrade.writtengrade%type;
    vpgrade tblSubjectGrade.practicalgrade%type;
    vwrittentestdate tblScoreTest.writtentestdate%type;
    vpracticaltestdate tblScoreTest.practicaltestdate%type;
    vwrittenfilereg tblScoreTest.writtentestfilereg%type;
    vpracticalfilereg tblScoreTest.practicaltestfilereg%type;
    
    vteachername tblTeacher.name%type;
    
    vattgradechar varchar2(10);
    vwgradechar varchar2(10);
    vpgradechar varchar2(10);
    
    vwrittentestdatechar varchar2(10);
    vpracticaltestdatechar varchar2(10);
begin
    -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '  교사명:  ' || vteachername); 
    
    dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    -- 해당 교사 스케줄 가져오기
    procGetTFinishedSubject(pteacherseq, vcursor);

    loop
        fetch vcursor into vsubseq, vcourseseq, vcoursename, vcoursestartdate, vcoursefinishdate, vclassroomname, vsubname, vsubjectstartdate, vsubjectfinishdate, vbookname, vattgrade, vwgrade, vpgrade, vwrittentestdate, vpracticaltestdate, vwrittenfilereg, vpracticalfilereg;
        exit when vcursor%notfound;
            vattgradechar := to_char(vattgrade);
            vwgradechar := to_char(vwgrade);
            vpgradechar := to_char(vpgrade);
            
            vwrittentestdatechar := to_char(vwrittentestdate, 'yy/mm/dd');
            vpracticaltestdatechar := to_char(vpracticaltestdate, 'yy/mm/dd');
            
            -- 널값 확인
            if vattgrade is null then 
                vattgradechar := 'null';
            end if;
            
            if vwgrade is null then 
                vwgradechar := 'null';
            end if;
            
            if vpgrade is null then 
                vpgradechar := 'null';
            end if;
            
            if vwrittentestdate is null then 
                vwrittentestdatechar := 'null';
            end if;
            
            if vpracticaltestdate is null then 
                vpracticaltestdatechar := 'null';
            end if;
            
            dbms_output.put_line('과목번호: ' || vsubseq || '   과정번호: ' || vcourseseq || '   과정명: ' || vcoursename ||'   과정시작일: ' || vcoursestartdate || '   과정종료일: ' || vcoursefinishdate || '   강의실: ' || vclassroomname || '   과목명: ' || vsubname || '   과목시작일: ' || vsubjectstartdate || '   과목종료일: ' || vsubjectfinishdate || '   교재명: ' || vbookname || '   출결배점: ' || vattgradechar || '   필기배점: ' || vwgradechar || '   실기배점: ' || vpgradechar || '   필기시험날짜: ' || vwrittentestdatechar || '   실기시험날짜: ' || vpracticaltestdatechar || '   필기시험문제등록여부: ' || vwrittenfilereg || '   실기시험문제등록여부: ' || vpracticalfilereg);
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end;

-- 최종 실행
begin 
    procPrintTFinishedSubject(3);
end;


--select * from tblsubjectgrade;
--select * from tblsubjectlist;

-- 2.2.1 특정 과목 선택시 해당 과목의 출결/필기/실기 배점 입력하기

-- 과정번호 + 과목번호 -> 과목목록번호 찾기
create or replace procedure procGetSubjectListNum(
    psubnum number,
    pcoursenum number,
    presult out number
)
is
begin
    select subjectlistseq into presult from tblsubjectlist where subseq = psubnum and courseseq = pcoursenum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetSubjectListNum;

-- 테스트
--declare
--    vresult number;
--begin
--    procGetSubjectListNum(1, 3, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 해당 과목의 배점이 입력되었는가 확인
create or replace procedure procCheckSubjectGrade(
    psubjectlistnum number,
    presult out number
)
is
begin
    select attendancegrade into presult from tblSubjectGrade where subjectlistseq = psubjectlistnum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procCheckSubjectGrade;


-- 테스트
--declare
--    vresult tblsubjectgrade.attendancegrade%type;
--begin
--    procCheckSubjectGrade(13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 과목번호, 과정번호 입력
-- 배점(출결, 필기, 실기) 입력
-- 해당 과목이 끝났는지 확인하기
create or replace procedure procSetSubjectGrade(
    psubnum number,         -- 과목번호
    pcoursenum number,      -- 과정번호
    pattgrade number,       -- 출결 배점
    pwrittengrade number,   -- 필기 배점
    ppracticalgrade number  -- 실기 배점
)
is
    vsubjectlistnum tblsubjectlist.subjectlistseq%type; -- 과목목록번호
    vstatus tblsubjectgrade.attendancegrade%type; -- 배점등록여부(숫자)
begin
    -- 과목 목록 번호 찾기
    procGetSubjectListNum(psubnum, pcoursenum, vsubjectlistnum);
    
    -- 해당 과목 목록으로 배점정보 물어보기
    procCheckSubjectGrade(vsubjectlistnum, vstatus);

    -- 배점이 입력되었는지 확인하기
    if vstatus != 0 then -- 배점이 입력되었다면
        dbms_output.put_line('배점이 이미 입력되었습니다. 입력을 종료합니다.');
        
    else -- 배점을 입력해야 하는 경우
        dbms_output.put_line('현재 등록된 배점이 없습니다.');
    
        -- 배점 유효성 검사
        if (pattgrade < 20 or pattgrade > 100) then -- 출결배점 범위가 유효하지 않은 경우
            dbms_output.put_line('출결배점이 유효하지 않습니다. 입력을 종료합니다.');
            
        elsif pwrittengrade < 0 or pwrittengrade > 100 then  -- 필기배점 범위가 유효하지 않은 경우
            dbms_output.put_line('필기배점이 유효하지 않습니다. 입력을 종료합니다.');
            
        elsif ppracticalgrade < 0 or ppracticalgrade > 100 then  -- 실기배점 범위가 유효하지 않은 경우
            dbms_output.put_line('실기배점이 유효하지 않습니다. 입력을 종료합니다.');
            
        elsif pattgrade + pwrittengrade + ppracticalgrade != 100 then -- 출결배점은 유효하나, 총합이 100이 아닌 경우
            dbms_output.put_line('배점의 총 합이 100이 아닙니다. 입력을 종료합니다.');
            
        else  -- 배점 입력하기
            update tblsubjectgrade 
            set attendancegrade = pattgrade, writtengrade = pwrittengrade, practicalgrade = ppracticalgrade 
            where subjectgradeseq = vsubjectlistnum;
            
            commit; -- db에 반영하기
            dbms_output.put_line('적합한 배점입니다. 새로 입력한 배점 정보 등록이 완료되었습니다.');
        end if;
    
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetSubjectGrade;


-- 실행
begin
--    procSetSubjectGrade(1, 3, 20, 50, 30); -- 과목 과정 출 필 실
--    procSetSubjectGrade(33, 3, 20, 50, 30);
--    procSetSubjectGrade(9, 2, 20, 50, 30); -- 올바른 등록
--    procSetSubjectGrade(9, 2, 10, 50, 40); -- 출결 점수 낮게
    procSetSubjectGrade(9, 2, 20, 50, 50); -- 총 점수를 100 이상
end;

-- 값 테스트
select * from tblsubjectgrade where subjectgradeseq = 13;

update tblsubjectgrade set attendancegrade = null where subjectgradeseq = 13;
update tblsubjectgrade set writtengrade = null where subjectgradeseq = 13;
update tblsubjectgrade set practicalgrade = null where subjectgradeseq = 13;

-- 원본

update tblsubjectgrade set attendancegrade = 20 where subjectgradeseq = 13;
update tblsubjectgrade set writtengrade = 50 where subjectgradeseq = 13;
update tblsubjectgrade set practicalgrade = 30 where subjectgradeseq = 13;

-----
select * from tblsubjectgrade where subjectgradeseq = 18;

update tblsubjectgrade set attendancegrade = null where subjectgradeseq = 18;
update tblsubjectgrade set writtengrade = null where subjectgradeseq = 18;
update tblsubjectgrade set practicalgrade = null where subjectgradeseq = 18;

--------------------------------------------------------------------------------------------------------------
--select * from tblscoretest;

-- 2.2.2. 필기 시험 날짜 등록
-- 1. 해당 필기 시험 날짜 가져오기
create or replace procedure procCheckWrittenDateReg(
    psubjectlistnum number,
    presult out date
)
is
begin
    select writtentestdate into presult from tblScoreTest where subjectlistseq = psubjectlistnum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procCheckWrittenDateReg;

--declare
--    vresult date;
--begin
--    procCheckWrittenDateReg(13, vresult);
--    dbms_output.put_line(vresult);
--end;


--set serverout on;

-- 2. 필기 시험 날짜 등록
create or replace procedure procSetWrtTestDate(
    psubnum number,         -- 과목번호
    pcoursenum number,      -- 과정번호
    pdate date              -- 필기시험일
)
is
    vsubjectlistnum tblsubjectlist.subjectlistseq%type; -- 과목목록번호
    vstatus tblscoretest.writtentestdate%type; -- 필기시험일
begin
    -- 과목 목록 번호 찾기
    procGetSubjectListNum(psubnum, pcoursenum, vsubjectlistnum);
    
    -- 해당 과목 목록으로 필기시험날짜 물어보기
    procCheckWrittenDateReg(vsubjectlistnum, vstatus);

    -- 날짜가 입력되었는지 확인하기
    if vstatus is null then -- 날짜를 입력해야 하는 경우
        dbms_output.put_line('현재 등록된 필기시험날짜가 없습니다.');
            
        update tblscoretest set writtentestdate = pdate where subjectlistseq = vsubjectlistnum;
        commit; -- db에 반영
        
        dbms_output.put_line('필기시험날짜가 등록되었습니다.');
    
    else -- 날짜가 입력되었다면
        
        dbms_output.put_line('필기시험날짜가 이미 등록되었습니다. 등록을 종료합니다.');

    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetWrtTestDate;


-- 실행
begin
--    procSetWrtTestDate(1, 3, '23/05/15'); -- 이미 등록
    procSetWrtTestDate(34, 1, '23/05/15');
end;

-- 확인
--select * from tblscoretest where subjectlistseq = 13;

-- 2.2.3. 필기 문제 등록
-- 1. 등록 여부 확인을 위해 값 가져오기
create or replace procedure procCheckWrittenFileReg(
    psubjectlistnum number,
    presult out varchar2
)
is
begin
    select writtentestfilereg into presult from tblScoreTest where subjectlistseq = psubjectlistnum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procCheckWrittenFileReg;

--declare
--    vresult tblScoreTest.writtentestfilereg%type;
--begin
--    procCheckWrittenFileReg(13, vresult);
--    dbms_output.put_line(vresult);
--end;

-- 2. 값이 'N'이면 'Y'로 변경
create or replace procedure procSetWrtTestDate(
    psubnum number,         -- 과목번호
    pcoursenum number       -- 과정번호
)
is
    vsubjectlistnum tblsubjectlist.subjectlistseq%type; -- 과목목록번호
    vstatus tblscoretest.writtentestfilereg%type; -- 필기시험문제등록여부
begin
    -- 과목 목록 번호 찾기
    procGetSubjectListNum(psubnum, pcoursenum, vsubjectlistnum);
    
    -- 해당 과목 목록으로 필기시험날짜 물어보기
    procCheckWrittenFileReg(vsubjectlistnum, vstatus);

    -- 날짜가 입력되었는지 확인하기
    if vstatus != 'N' then -- 날짜가 입력되었다면
        dbms_output.put_line('필기시험문제가 이미 등록되었습니다. 등록을 종료합니다.');
        
    else -- 시험문제를 등록해야 하는 경우
        dbms_output.put_line('현재 필기시험문제가 등록되지 않았습니다.');
        
        update tblscoretest set writtentestfilereg = 'Y' where subjectlistseq = vsubjectlistnum;
        commit;
        
        dbms_output.put_line('새로운 필기시험문제가 등록되었습니다.');
        
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetWrtTestDate;


-- 실행
begin
--    procSetWrtTestDate(1, 3); -- 이미등록
    procSetWrtTestDate(34, 1);
end;

-- 확인
--select * from tblscoretest where subjectlistseq = 13;

-- 2.2.4. 실기 시험 날짜 등록
-- 1. 해당 실기 시험 날짜 가져오기
create or replace procedure procCheckPrctDateReg(
    psubjectlistnum number,
    presult out date
)
is
begin
    select practicaltestdate into presult from tblScoreTest where subjectlistseq = psubjectlistnum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procCheckPrctDateReg;

--declare
--    vresult date;
--begin
--    procCheckPrctDateReg(13, vresult);
--    dbms_output.put_line(vresult);
--end;

-- 2. null이면 실기 시험 날짜 등록
create or replace procedure procSetPrctTestDate(
    psubnum number,         -- 과목번호
    pcoursenum number,      -- 과정번호
    pdate date              -- 실기시험일
)
is
    vsubjectlistnum tblsubjectlist.subjectlistseq%type; -- 과목목록번호
    vstatus tblscoretest.practicaltestdate%type; -- 실기시험일
begin
    -- 과목 목록 번호 찾기
    procGetSubjectListNum(psubnum, pcoursenum, vsubjectlistnum);
    
    -- 해당 과목 목록으로 실기시험날짜 물어보기
    procCheckPrctDateReg(vsubjectlistnum, vstatus);

    -- 날짜가 입력되었는지 확인하기
    if vstatus is null then -- 날짜를 입력해야 하는 경우
        dbms_output.put_line('현재 등록된 실기시험날짜가 없습니다.');
            
        update tblscoretest set practicaltestdate = pdate where subjectlistseq = vsubjectlistnum;
        commit;
        
        dbms_output.put_line('새로운 실기시험날짜가 등록되었습니다.');
    
    else -- 날짜가 입력되었다면
        
        dbms_output.put_line('실기시험날짜가 이미 입력되었습니다. 입력을 종료합니다.');
 
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetPrctTestDate;


-- 실행
begin
--    procSetPrctTestDate(1, 3, '23/05/29'); -- 이미 등록
    procSetPrctTestDate(34, 1, '23/05/29');
end;

-- 확인
--select * from tblscoretest where subjectlistseq = 13;



-- 2.2.5. 실기 문제 등록
-- 1. 등록 여부 확인을 위해 값 가져오기
create or replace procedure procCheckPrctFileReg(
    psubjectlistnum number,
    presult out varchar2
)
is
begin
    select practicaltestfilereg into presult from tblScoreTest where subjectlistseq = psubjectlistnum;
exception
    when others then
        dbms_output.put_line('예외처리');
end procCheckPrctFileReg;

--declare
--    vresult tblScoreTest.practicaltestfilereg%type;
--begin
--    procCheckPrctFileReg(13, vresult);
--    dbms_output.put_line(vresult);
--end;

-- 2. 값이 'N'이면 'Y'로 변경
create or replace procedure procSetPrctTestDate(
    psubnum number,         -- 과목번호
    pcoursenum number       -- 과정번호
)
is
    vsubjectlistnum tblsubjectlist.subjectlistseq%type; -- 과목목록번호
    vstatus tblscoretest.practicaltestfilereg%type; -- 실기시험문제등록여부
begin
    -- 과목 목록 번호 찾기
    procGetSubjectListNum(psubnum, pcoursenum, vsubjectlistnum);
    
    -- 해당 과목 목록으로 필기시험날짜 물어보기
    procCheckPrctFileReg(vsubjectlistnum, vstatus);

    -- 날짜가 입력되었는지 확인하기
    if vstatus != 'N' then -- 날짜가 입력되었다면
        dbms_output.put_line('실기시험문제가 이미 등록되었습니다. 등록을 종료합니다.');
        
    else -- 시험문제를 등록해야 하는 경우
        dbms_output.put_line('현재 실기시험문제가 등록되지 않았습니다.');
        
        update tblscoretest set practicaltestfilereg = 'Y' where subjectlistseq = vsubjectlistnum;
        commit;
        
        dbms_output.put_line('새로운 실기시험문제가 등록되었습니다.');
        
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetPrctTestDate;


-- 실행
begin
--    procSetPrctTestDate(1, 3); -- 이미 등록
    procSetPrctTestDate(34, 1);
end;

-- 확인
--select * from tblscoretest where subjectlistseq = 13;

----------------------------------------------------------------------------------------------------------------------
select * from tblsubjectgrade;
select * from tblsubjectlist;

-- 트리거
-- 배점 입력 전, 과목종료일과 현재날짜를 비교해서 종료되지 않은 과목은 오류 발생
create or replace trigger trgDateCompGrade
    before
    update
    on tblsubjectgrade
    for each row
declare
    venddate date;
begin
    dbms_output.put_line(to_char(sysdate, 'hh24:mi:ss') || ' 트리거가 실행되었습니다.');
    
    -- 해당 과목종료일 가져오기
    select subjectfinishdate into venddate from tblsubjectlist where subjectlistseq = :new.subjectlistseq;
    
    if venddate > sysdate then -- 현재날짜가 더 이르면 아직 안끝난 과목
        dbms_output.put_line('해당 과목이 아직 종료되지 않았습니다. 배점 입력이 불가합니다.');
        raise_application_error(-20001, '해당 과목이 아직 종료되지 않았습니다. 배점 입력이 불가합니다.');
    end if;
    
end trgDateCompGrade; 

drop trigger trgDateCompGrade;