-- 출결
-- 교사가 수업한 과정만 조회 가능
-- > 과목목록번호에서 교사번호 검색하면서 유효성 검사는 나중에

-- 교사가 수업하는 올바른 과정번호로 입력한다는 가정 하에 진행.

-- ex) 1번교사 1번과목목록번호 1번과정 1번과목

--select * from tblsubjectlist;

-- 과정별 출결 조회 테이블 가져오기
create or replace procedure procGetCourseAtt(
    pcourseseq number,
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
    select 
        s.studentseq as 교육생번호, s.name as 교육생이름, a.attendancedate as 날짜, a.attendancestatus as 출결여부
    from tblattendance a
        inner join tblstudent s
            on a.studentseq = s.studentseq
                inner join tblcourse c
                    on s.processseq = c.courseseq
    where a.courseseq = pcourseseq
    order by s.studentseq, a.attendancedate;

exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseAtt;
/
--declare
--    vcursor sys_refcursor;
--    
--    vseq tblstudent.studentseq%type;
--    vname tblstudent.name%type;
--    vdate tblattendance.attendancedate%type;
--    vstatus tblattendance.attendancestatus%type;
--begin
--    procGetCourseAtt(1, vcursor);
--    
--    loop
--        fetch vcursor into vseq, vname, vdate, vstatus; 
--        exit when vcursor%notfound;
--            dbms_output.put_line('교육생번호: ' || vseq || '   교육생이름: ' || vname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
--    end loop;
--
--end;


-- 과정별 출결 조회하기
create or replace procedure procPrintCourseAtt(
    pteacherseq number,
    pcourseseq number
)
is
    vteachername tblteacher.name%type;
    vcoursename tblcourse.coursename%type;
    
    vcursor sys_refcursor;
    vseq tblstudent.studentseq%type;
    vname tblstudent.name%type;
    vdate tblattendance.attendancedate%type;
    vstatus tblattendance.attendancestatus%type;
    
    vdatestr varchar2(30);
begin
     -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '   교사명:  ' || vteachername); 
    
    -- 과정번호와 과정명 출력하기
    procGetCourseName(pcourseseq, vcoursename);
    dbms_output.put_line('과정번호: '  || pcourseseq ||'   과정명: ' || vcoursename);
    
    dbms_output.put_line('--------------------------------------------------------------------');
    
    -- 목록 출력
    procGetCourseAtt(1, vcursor);
    
    loop
        fetch vcursor into vseq, vname, vdate, vstatus; 
        exit when vcursor%notfound;
            if to_char(vdate, 'd') not in ('1', '7') then  -- 평일만 출력
                dbms_output.put_line('교육생번호: ' || vseq || '   교육생이름: ' || vname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
            end if;
    end loop;
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintCourseAtt;
/

-- 실행
begin
    procPrintCourseAtt(1, 1);
end;


-- 기간별 출결 조회
-- 년별 조회

-- 년.월 조회
-- 해당 년월 테이블 가져오기
--create or replace procedure procGetYmAtt(
--    pteacherseq number,
--    pstartdate date,
--    penddate date,
--    pcursor out sys_refcursor
--)
--is
--begin
--    open pcursor
--    for
--    select 
--        a.courseseq as 과정번호, c.coursename as 과정명, s.studentseq as 교육생번호, s.name as 교육생이름, 
--        a.attendancedate as 날짜, a.attendancestatus as 출결여부
--    from tblattendance a 
--        inner join tblstudent s 
--            on a.studentseq = s.studentseq
--                inner join tblcourse c
--                    on s.processseq = c.courseseq
--                        inner join tblsubjectlist sl
--                            on sl.courseseq = c.courseseq
--    where a.attendancedate between to_date(pstartdate) and to_date(penddate) and sl.teacherseq = pteacherseq;
--    
--exception
--    when NO_DATA_FOUND then
--        dbms_output.put_line('데이터 없음');  
--        
--    when others then
--        dbms_output.put_line('예외 처리');
--end procGetYmAtt;
--
--
--select * from tblstudent;
--exec dbms_output.enable('500000000');
--
--
--declare
--    vcursor sys_refcursor;
--    vcourseseq tblcourse.courseseq%type;
--    vcoursename tblcourse.coursename%type;
--    vstdseq tblstudent.studentseq%type;
--    vstdname tblstudent.name%type;
--    vdate tblattendance.attendancedate%type;
--    vstatus tblattendance.attendancestatus%type;
--begin
--    procGetYmAtt(1, '20230601', '20230630', vcursor);
--    
--    loop 
--        fetch vcursor into vcourseseq, vcoursename, vstdseq, vstdname, vdate, vstatus;
--        exit when vcursor%notfound;
--            dbms_output.put_line('과정번호: ' || vcourseseq || '   과정명: ' || vcoursename || '   교육생번호: ' || vstdseq || '   교육생이름: ' || vstdname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
--    end loop;
--exception
--    when others then
--        dbms_output.put_line('오류');
--end;
--
---- 해당 년월 출결 조회하기
--create or replace procedure procPrintYmAtt(
--    pteacherseq number,
--    pdatestr varchar2 -- 년월 -> 문자열로 입력받는다.
--)
--is
--    vstartdate date; -- 시작일 (해당 월의 시작 일)
--    venddate date; -- 종료일 (해당 월의 마지막 일)
--begin
--    -- 시작일 문자를 날짜 형식으로 변경하기
--    vstartdate := TO_DATE(pdatestr || '01', 'yyyymmdd');
--    dbms_output.put_line(vstartdate);
--    
--    -- 입력한 월의 마지막 날짜를 얻기
--    venddate := LAST_DAY(vstartdate);
--    dbms_output.put_line(venddate);
--    
--    -- 테이블 가져오기
--    procGetYmAtt
--    
--exception
--    when NO_DATA_FOUND then
--        dbms_output.put_line('데이터 없음');  
--        
--    when others then
--        dbms_output.put_line('예외 처리');
--end procPrintYmAtt;
--
--
---- 실행
--begin
--    procPrintYmAtt(1, '202304');
--end;


-- 특정 기간 조회
-- 시작일~끝일 테이블 가져오기
create or replace procedure procGetYmAtt(
    pteacherseq number,
    pstartdate date,
    penddate date,
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
    select 
        distinct a.courseseq as 과정번호, c.coursename as 과정명, s.studentseq as 교육생번호, s.name as 교육생이름, 
        a.attendancedate as 날짜, a.attendancestatus as 출결여부
    from tblattendance a 
        inner join tblstudent s 
            on a.studentseq = s.studentseq
                inner join tblcourse c
                    on s.processseq = c.courseseq
                        inner join tblsubjectlist sl
                            on sl.courseseq = c.courseseq
    where a.attendancedate between to_date(pstartdate) and to_date(penddate) and sl.teacherseq = pteacherseq
    order by a.attendancedate, a.courseseq, s.studentseq;
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetYmAtt;
/

-- 특정 기간 출결 조회하기
create or replace procedure procPrintYmAtt(
    pteacherseq number,
    pstartdate date,
    penddate date
)
is
    vcursor sys_refcursor;
    vcourseseq tblcourse.courseseq%type;
    vcoursename tblcourse.coursename%type;
    vstdseq tblstudent.studentseq%type;
    vstdname tblstudent.name%type;
    vdate tblattendance.attendancedate%type;
    vstatus tblattendance.attendancestatus%type;
    vteachername tblteacher.name%type;
begin
    -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '   교사명:  ' || vteachername); 
    
    -- 기간 출력하기
    dbms_output.put_line('기간: ' || to_char(pstartdate, 'yyyy-mm-dd') || ' ~ ' || to_char(penddate, 'yyyy-mm-dd'));
    
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    -- 테이블 가져오기
    procGetYmAtt(pteacherseq, pstartdate, penddate, vcursor);
    
    loop 
        fetch vcursor into vcourseseq, vcoursename, vstdseq, vstdname, vdate, vstatus;
        exit when vcursor%notfound;
        if to_char(vdate, 'd') not in ('1', '7') then  -- 평일만 출력
            dbms_output.put_line('과정번호: ' || vcourseseq || '   과정명: ' || vcoursename || '   교육생번호: ' || vstdseq || '   교육생이름: ' || vstdname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
        end if;
    end loop;
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintYmAtt;
/

-- 실행
begin
    procPrintYmAtt(1, '20230101', '20230115');
end;

-------------------------------------------------------
-- 년.월.일 조회 -> 그 날짜에 해당하는 교사가 강의한 과정에 한해 다 출력
-- 해당 년월일 테이블 가져오기
create or replace procedure procGetYmdAtt(
    pteacherseq number,
    pdate date,
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
    select 
        distinct a.courseseq as 과정번호, c.coursename as 과정명, s.studentseq as 교육생번호, s.name as 교육생이름, a.attendancedate as 날짜, a.attendancestatus as 출결여부 
    from tblattendance a 
        inner join tblstudent s 
            on a.studentseq = s.studentseq
                inner join tblcourse c
                    on s.processseq = c.courseseq
                        inner join tblsubjectlist sl
                            on c.courseseq = sl.courseseq
    where a.attendancedate = to_date(pdate) and sl.teacherseq = pteacherseq
    order by a.courseseq, s.studentseq; 
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetYmdAtt;
/

--declare
--    vcursor sys_refcursor;
--    
--    vcourseseq tblcourse.courseseq%type;
--    vcoursename tblcourse.coursename%type;
--    vstdseq tblstudent.studentseq%type;
--    vstdname tblstudent.name%type;
--    vdate tblattendance.attendancedate%type;
--    vstatus tblattendance.attendancestatus%type;
--begin
--    procGetYmdAtt(1, '2023-07-05', vcursor);
--    
--    loop
--        fetch vcursor into vcourseseq, vcoursename, vstdseq, vstdname, vdate, vstatus; 
--        exit when vcursor%notfound;
--            dbms_output.put_line('과정번호: ' || vcourseseq || '   과정명: ' || vcoursename || '   교육생번호: ' || vstdseq || '   교육생이름: ' || vstdname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
--    end loop;
--
--end;


-- 특정 년월일 조회하기
create or replace procedure procPrintYmdAtt(
    pteacherseq number,
    pdatestr varchar2
)
is
    vinputdate date;
    vcursor sys_refcursor;
    vteachername tblteacher.name%type;
    vcourseseq tblcourse.courseseq%type;
    vcoursename tblcourse.coursename%type;
    vstdseq tblstudent.studentseq%type;
    vstdname tblstudent.name%type;
    vdate tblattendance.attendancedate%type;
    vstatus tblattendance.attendancestatus%type;
begin
     -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '   교사명:  ' || vteachername); 
    
    vinputdate := to_date(pdatestr, 'yyyy/mm/dd');
    
    -- 날짜 출력하기
    dbms_output.put_line('날짜: '  || to_char(vinputdate, 'yyyy/mm/dd'));
    
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    
    
    if to_char(vinputdate, 'd') in ('1', '7') then  -- 주말
        dbms_output.put_line('입력하신 날짜는 주말입니다. 조회를 종료합니다.');
    else
        -- 목록 출력
        procGetYmdAtt(pteacherseq, vinputdate, vcursor);
        
        loop
            fetch vcursor into vcourseseq, vcoursename, vstdseq, vstdname, vdate, vstatus; 
            exit when vcursor%notfound;
                dbms_output.put_line('과정번호: ' || vcourseseq || '   과정명: ' || vcoursename || '   교육생번호: ' || vstdseq || '   교육생이름: ' || vstdname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
        end loop;
    end if;
    
end procPrintYmdAtt;
/

-- 실행
begin
    procPrintYmdAtt(1, '20230702');
end;



-- 교육생 별 출결 조회

-- 해당 교사의 수업을 듣는 교육생의 번호가 올바로 들어온다고 가정.

-- ex) 1번 교육생

-- 교육생 출결테이블 가져오기
create or replace procedure procGetStdAtt(
    pteacherseq number,
    pstdseq number,
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
--    select 
--        a.courseseq as 과정번호, c.coursename as 과정명, a.attendancedate as 날짜, a.attendancestatus as 출결여부
--    from tblattendance a
--        inner join tblstudent s
--            on a.studentseq = s.studentseq
--                inner join tblcourse c
--                    on s.processseq = c.courseseq
--                        inner join tblsubjectlist sl
--                            on c.courseseq = sl.courseseq
--    where a.studentseq = pstdseq and sl.teacherseq = pteacherseq;
--    
    select 
        distinct a.courseseq as 과정번호, c.coursename as 과정명, a.attendancedate as 날짜, a.attendancestatus as 출결여부
    from tblattendance a
        inner join tblstudent s
            on s.studentseq =a.studentseq
                inner join tblcourse c
                    on c.courseseq = s.processseq
                        inner join tblsubjectlist sl
                            on c.courseseq = sl.courseseq
    where a.studentseq = pstdseq and sl.teacherseq = pteacherseq
    order by a.courseseq, a.attendancedate;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdAtt;
/

--declare
--    vcursor sys_refcursor;
--    
--    vseq tblcourse.courseseq%type;
--    vname tblcourse.coursename%type;
--    vdate tblattendance.attendancedate%type;
--    vstatus tblattendance.attendancestatus%type;
--begin
--    procGetStdAtt(1, 1, vcursor);
--    
--    loop
--        fetch vcursor into vseq, vname, vdate, vstatus; 
--        exit when vcursor%notfound;
--            dbms_output.put_line('과정번호: ' || vseq || '   과정명: ' || vname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
--    end loop;
--
--end;


-- 교육생 이름 가져오기
create or replace procedure procGetStdName(
    pstdseq number,
    pname out varchar2
)
is
begin
    select name into pname from tblstudent where studentseq = pstdseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdName;
/
--declare
--    vresult varchar2(50);
--begin
--    procGetStdName(1, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 교육생 별 출결 조회하기
create or replace procedure procPrintStdAtt(
    pteacherseq number,
    pstdseq number
)
is
    vteachername tblteacher.name%type;
    vstdname tblstudent.name%type;
    
    vcursor sys_refcursor;
    vcourseseq tblcourse.courseseq%type;
    vcoursename tblcourse.coursename%type;
    vdate tblattendance.attendancedate%type;
    vstatus tblattendance.attendancestatus%type;
begin
     -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '   교사명:  ' || vteachername); 
    
    -- 교육생번호와 교육생이름 출력하기
    procGetStdName(pstdseq, vstdname);
    dbms_output.put_line('교육생번호: '  || pstdseq ||'   교육생이름: ' || vstdname);
    
    dbms_output.put_line('---------------------------------------------------------------------------------------------------');
    
    -- 목록 출력
    procGetStdAtt(pteacherseq, pstdseq, vcursor);
    
    loop
        fetch vcursor into vcourseseq, vcoursename, vdate, vstatus; 
        exit when vcursor%notfound;
            if to_char(vdate, 'd') not in ('1', '7') then  -- 평일만 출력
                dbms_output.put_line('과정번호: ' || vcourseseq || '   과정명: ' || vcoursename || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
            end if;
    end loop;
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintStdAtt;
/

-- 실행
begin
    procPrintStdAtt(2, 31);
end;





