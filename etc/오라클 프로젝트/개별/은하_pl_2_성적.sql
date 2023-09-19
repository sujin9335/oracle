-- 성적 입출력
-- 1. 교사번호에 맞는 강의완료 테이블 가져오기
create or replace procedure procGetTFinishedSubScore(
    pteacherseq in number,
    pcursor out SYS_REFCURSOR  
)
is
begin
    open pcursor
    for
    select 
        sl.subseq as 과목번호, c.courseseq as 과정번호, c.coursename as 과정명, c.coursestartdate as 과정시작일, c.coursefinishdate as 과정종료일, 
        s.subname as 과목명, sl.subjectstartdate as 과목시작일, sl.subjectfinishdate as 과목종료일,
        b.bookname as 교재명,
        sg.attendancegrade as 출결배점, sg.writtengrade as 필기배점, sg.practicalgrade as 실기배점,
        st.writtentestscorereg as 필기성적등록여부, st.practicaltestscorereg as 실기성적등록여부
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
                                                inner join tblscoretest st
                                                    on sl.subjectlistseq = st.subjectlistseq
    where sch.teacherseq = pteacherseq and sl.subjectfinishdate < sysdate
    order by sl.subjectstartdate, sl.subseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetTFinishedSubScore;
/

-- 강의 종료된 교사의 과목 목록 출력하기
create or replace procedure procPrintTFinishedSubScore(
    pteacherseq number
)
is
    vcursor sys_refcursor;
    vsubseq tblSubjectList.subseq%type;
    vcourseseq tblSubjectList.courseseq%type;
    vcoursename tblCourse.coursename%type;
    vcoursestartdate tblCourse.coursestartdate%type;
    vcoursefinishdate tblCourse.coursefinishdate%type;
    vsubname tblSubject.subname%type;
    vsubjectstartdate tblSubjectList.subjectstartdate%type;
    vsubjectfinishdate tblSubjectList.subjectfinishdate%type;
    vbookname tblBook.bookname%type;
    vattgrade tblSubjectGrade.attendancegrade%type;
    vwgrade tblSubjectGrade.writtengrade%type;
    vpgrade tblSubjectGrade.practicalgrade%type;
    vwrtscorereg tblScoreTest.writtentestscorereg%type;
    vprctscorereg tblScoreTest.practicaltestscorereg%type;
    
    vteachername tblTeacher.name%type;
    
    vattgradechar varchar2(10);
    vwgradechar varchar2(10);
    vpgradechar varchar2(10);
begin
    -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '  교사명:  ' || vteachername); 
    
    dbms_output.put_line('-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    -- 해당 교사 스케줄 가져오기
    procGetTFinishedSubScore(pteacherseq, vcursor);

    loop
        fetch vcursor into vsubseq, vcourseseq, vcoursename, vcoursestartdate, vcoursefinishdate, vsubname, vsubjectstartdate, vsubjectfinishdate, vbookname, vattgrade, vwgrade, vpgrade, vwrtscorereg, vprctscorereg;
        exit when vcursor%notfound;
            vattgradechar := to_char(vattgrade);
            vwgradechar := to_char(vwgrade);
            vpgradechar := to_char(vpgrade);
            
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
            
            dbms_output.put_line('과목번호: ' || vsubseq || '   과정번호: ' || vcourseseq || '   과정명: ' || vcoursename ||'   과정시작일: ' || vcoursestartdate || '   과정종료일: ' || vcoursefinishdate || '   과목명: ' || vsubname || '   과목시작일: ' || vsubjectstartdate || '   과목종료일: ' || vsubjectfinishdate || '   교재명: ' || vbookname || '   출결배점: ' || vattgradechar || '   필기배점: ' || vwgradechar || '   실기배점: ' || vpgradechar || '   필기시험점수등록여부: ' || vwrtscorereg || '   실기시험점수등록여부: ' || vprctscorereg);
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintTFinishedSubScore;
/
-- 최종 실행
begin 
    procPrintTFinishedSubScore(1);
end;


-- 2. 특정 과목번호, 과정번호 입력 -> 교육생 정보 및 성적 출력
-- 해당 과목을 듣는 학생의 성적 테이블 가져오기
create or replace procedure procGetCourseStdScoreList(
    psubjectlistnum number, -- 과목목록번호
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
    select 
        st.studentseq as 교육생번호, st.name as 교육생이름, st.phone as 전화번호, st.compldropstatus as 수료중도탈락여부, st.compldropdate as 중도탈락일자,
        si.attendancescore as 출결성적, si.writingscore as 필기성적, si.practicalscore as 실기성적
    from tblscoreinfo si
        inner join tblstudent st
            on si.studentseq = st.studentseq
    where si.subjectlistseq = psubjectlistnum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseStdScoreList;
/

-- 과목명 가져오기
create or replace procedure procGetSubjectName(
    psubseq number,
    psubname out varchar2
)
is
begin
    select subname into psubname from tblsubject where subseq = psubseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetSubjectName;
/

-- 교육생 정보 테이블 출력하기
create or replace procedure procPrintCourseStdScoreList(
    psubseq number,
    pcourseseq number
)
is
    vcursor sys_refcursor;
    
    vstudentseq tblstudent.studentseq%type;
    vname tblstudent.name%type;
    vphone tblstudent.phone%type;
    vstatus tblstudent.compldropstatus%type;
    vstatusdate tblstudent.compldropdate%type;
    vattscore tblscoreinfo.attendancescore%type;
    vwrtscore tblscoreinfo.writingscore%type;
    vprctscore tblscoreinfo.practicalscore%type;
    
    vsublistseq tblsubjectlist.subjectlistseq%type; -- 해당 과목의 과목목록번호
    
    vcoursename tblcourse.coursename%type;  -- 과정명
    vsubjectname tblsubject.subname%type;   -- 과목명
    
    -- 여부, 날짜, 성적 3개 null 검사 필요
    vstatuschar tblstudent.compldropstatus%type;
    vstatusdatechar varchar2(10);
    vattscorechar varchar2(10);
    vwrtscorechar varchar2(10);
    vprctscorechar varchar2(10);
begin
    -- 입력한 번호가 교사가 진행하는 과목의 과정인지 물어보는거 나중에 시간되면 추가하기.
    -- 일단은 강사 스케줄의 번호만 입력된다는 가정임.
    
    -- 과목목록번호 가져오기
    procGetSubjectListNum(psubseq, pcourseseq, vsublistseq);

    -- 과정번호와 과정명 출력하기
    procGetCourseName(pcourseseq, vcoursename);
    dbms_output.put_line('과정번호: '  || pcourseseq ||'   과정명: ' || vcoursename);
    
    -- 과목번호와 과목명 출력하기
    procGetSubjectName(psubseq, vsubjectname);
    dbms_output.put_line('과목번호: '  || psubseq ||'   과목명: ' || vsubjectname);
    
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------');
    
    -- 교육생 목록 출력하기
    procGetCourseStdScoreList(vsublistseq, vcursor);
    loop
        fetch vcursor into vstudentseq, vname, vphone, vstatus, vstatusdate, vattscore, vwrtscore, vprctscore;
        exit when vcursor%notfound;
            vstatuschar := vstatus;
            vstatusdatechar := to_char(vstatusdate, 'yy/mm/dd');
            vattscorechar := to_char(vattscore);
            vwrtscorechar := to_char(vwrtscore);
            vprctscorechar := to_char(vprctscore);
            
            -- null 검사
            if vstatus is null then
                vstatuschar := 'null';
            end if;
            
            if vstatusdate is null then
                vstatusdatechar := 'null';
            end if;
            
            if vattscore is null then
                vattscorechar := 'null';
            end if;
            
            if vwrtscore is null then
                vwrtscorechar := 'null';
            end if;
            
            if vprctscore is null then
                vprctscorechar := 'null';
            end if;
            
            if vstatuschar = '중도탈락' then -- 중도탈락일도 출력
                dbms_output.put_line('교육생번호: ' || vstudentseq || '   교육생이름: ' || vname || '   전화번호: ' || vphone || '   수료|중도탈락 여부: ' || vstatuschar || '   수료|중도탈락일: ' || vstatusdatechar || '   출결성적: ' || vattscorechar || '   필기성적: ' || vwrtscorechar || '   실기성적: ' || vprctscorechar);    
            else
                dbms_output.put_line('교육생번호: ' || vstudentseq || '   교육생이름: ' || vname || '   전화번호: ' || vphone || '   수료|중도탈락 여부: ' || vstatuschar || '   출결성적: ' || vattscorechar || '   필기성적: ' || vwrtscorechar || '   실기성적: ' || vprctscorechar);
            end if;
            
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintCourseStdScoreList;
/
-- 실행
begin
    procPrintCourseStdScoreList(1, 3);
end;



-- 3. 학생 성적 등록
-- 3.1. 필기 성적 등록

-- 학생 개인의 필기 성적 가져오기
create or replace procedure procGetStdWrtScore(
    pstdseq number,
    psublistseq number,
    pwrtscore out number
)
is
begin
    select writingscore into pwrtscore from tblscoreinfo where studentseq = pstdseq and subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdWrtScore;
/

--declare
--    vresult number;
--begin
--    procGetStdWrtScore(67, 13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 필기 배점 가져오기
create or replace procedure procGetWrtGrade(
    psublistseq number,
    pscore out number
)
is
begin
    select writtengrade into pscore from tblsubjectgrade where subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetWrtGrade;
/
--declare 
--    vresult number;
--begin
--    procGetWrtGrade(13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 학생의 중도탈락여부 가져오기
create or replace procedure procGetStdDropStatus(
    pstdseq number,
    pstatus out varchar2
)
is
begin
    select compldropstatus into pstatus from tblstudent where studentseq = pstdseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdDropStatus;
/

--declare
--    vresult tblstudent.compldropstatus%type;
--begin
--    procGetStdDropStatus(66, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 중도탈락일 가져오기
create or replace procedure procGetStdDropDate(
    pstdseq number,
    pdate out date
)
is
begin  
    select compldropdate into pdate from tblstudent where studentseq = pstdseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdDropDate;
/

-- 과목종료일 가져오기
create or replace procedure procGetSubFDate(
    psubjectlistseq number,
    pdate out date
)
is
begin
    select subjectfinishdate into pdate from tblsubjectlist where subjectlistseq = psubjectlistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetSubFDate;
/

--declare
--    vresult date;
--begin
--    procGetSubFDate(13, vresult);
--    dbms_output.put_line(vresult);
--end;


--select * from tblscoretest;

-- 모든 학생의 필기성적이 등록되었는지 확인 후 성적등록여부에 값 수정
create or replace procedure procSetWScoreRegStatus(
    psublistseq number
)
is
    vwcount number;
    vcourseseq number;
    vstudentcnt number;
begin    
    -- 해당 과목의 필기성적이 매겨진 학생 수 세기
    select count(*) into vwcount from tblscoreinfo where subjectlistseq = psublistseq and writingscore is not null; 
--    dbms_output.put_line(vwcount);
    
    -- 과정번호 찾기
    select courseseq into vcourseseq from tblsubjectlist where subjectlistseq = psublistseq;
    
    -- 강의실 수강 인원 확인
    select studentnumber into vstudentcnt from tblcourse where courseseq = vcourseseq; 
    
    -- 수강인원과 필기시험성적을 입력한 행의 수가 같은 경우
    if vwcount = vstudentcnt then
        update tblscoretest set writtentestscorereg = 'Y' where subjectlistseq = psublistseq;
        commit;
        dbms_output.put_line('해당 과목을 수강하는 모든 학생의 필기 시험 성적이 등록되었습니다.');
    end if;
        
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');

end procSetWScoreRegStatus;
/


-- 필기성적 등록하기
create or replace procedure procSetStdWrtScore(
    pstdseq number,
    psubseq number,
    pcourseseq number,
    pscore number
)
is
    vsublistseq number;
    vscore tblscoreinfo.writingscore%type;
    vstatus tblstudent.compldropstatus%type;
    vdropdate tblstudent.compldropdate%type;
    vsubfdate tblsubjectlist.subjectfinishdate%type;
    vwrtgrade tblsubjectgrade.writtengrade%type;
begin
    -- 과목목록번호 가져오기
    procGetSubjectListNum(psubseq, pcourseseq, vsublistseq);

    -- 필기성적 가져오기
    procGetStdWrtScore(pstdseq, vsublistseq, vscore);
    
    if vscore is null then
        -- 중도탈락여부 가져오기
        procGetStdDropStatus(pstdseq, vstatus);
        dbms_output.put_line('중도탈락여부: ' || vstatus);
        
        -- 중도탈락일 가져오기
        procGetStdDropDate(pstdseq, vdropdate);
        dbms_output.put_line('중도탈락일: ' || vdropdate);
        
        -- 과목종료일 가져오기
        procGetSubFDate(vsublistseq, vsubfdate);
        dbms_output.put_line('과목종료일: ' || vsubfdate);
        
        if vstatus = '중도탈락' and vdropdate < vsubfdate then -- 중도탈락 + 과목보다 일찍 탈락
            dbms_output.put_line('과목을 다 듣기 전에 탈락하였습니다. 성적을 등록할 수 없습니다. 등록을 종료합니다.');

        else -- 성적 입력 가능
        
            -- 필기배점 가져오기
            procGetWrtGrade(vsublistseq, vwrtgrade);
            dbms_output.put_line('필기배점: ' || vwrtgrade);
            
            if vwrtgrade is not null then -- 배점이 있는 경우
                -- 배점과 입력할 성적 비교
                
                -- 최대 점수가 각 시험의 배점까지이다.
                if pscore < 0 or pscore > vwrtgrade then -- 부적절한 범위
                    dbms_output.put_line('유효하지 않은 입력입니다. 입력을 종료합니다.');
                else -- 필기 성적 입력
                    update tblscoreinfo set writingscore = pscore where studentseq = pstdseq and subjectlistseq = vsublistseq;
                    commit;
                    
                    dbms_output.put_line('필기 성적 등록을 완료했습니다.');
                    
                    -- 해당 과목목록번호를 가진 학생들의 필기성적 확인하기 -> 모든 성적이 입력되었다면 'Y'로 변경
                    procSetWScoreRegStatus(vsublistseq);

                end if;
                
            else -- 필기배점이 없는 경우
                
                dbms_output.put_line('과목에 등록된 필기배점이 없습니다. 배점을 먼저 등록해주세요. 등록을 종료합니다.');
                
            end if;
            
        end if;
        
    else -- 성적이 이미 존재
        dbms_output.put_line('성적이 이미 존재합니다. 등록을 종료합니다.');
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetStdWrtScore;
/
-- 실행
begin
--    procSetStdWrtScore(66, 1, 3, 50);
--    procSetStdWrtScore(1, 1, 1, 50);
--    procSetStdWrtScore(1, 34, 1, 30);
    procSetStdWrtScore(11, 1, 1, 20);
--    11번학생 1번과정 26번과목
end;

-- 확인
select * from tblscoreinfo where studentseq = 66;

select * from tblscoreinfo where studentseq = 1;

select * from tblsubjectlist where subjectlistseq = 6;


-- 3.2. 실기 성적 등록

-- 학생 개인의 실기 성적 가져오기
create or replace procedure procGetStdPrctScore(
    pstdseq number,
    psublistseq number,
    pprctscore out number
)
is
begin
    select practicalscore into pprctscore from tblscoreinfo where studentseq = pstdseq and subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdPrctScore;
/

--declare
--    vresult number;
--begin
--    procGetStPrctScore(66, 13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 실기 배점 가져오기
create or replace procedure procGetPrctGrade(
    psublistseq number,
    pscore out number
)
is
begin
    select practicalgrade into pscore from tblsubjectgrade where subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetPrctGrade;
/
--declare 
--    vresult number;
--begin
--    procGetPrctGrade(13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 모든 학생의 실기성적이 등록되었는지 확인 후 성적등록여부에 값 수정
create or replace procedure procSetPScoreRegStatus(
    psublistseq number
)
is
    vpcount number;
    vcourseseq number;
    vstudentcnt number;
begin    
   
    -- 해당 과목의 실기성적이 매겨진 학생 수 세기
    select count(*) into vpcount from tblscoreinfo where subjectlistseq = psublistseq and practicalscore is not null; 
    
    -- 과정번호 찾기
    select courseseq into vcourseseq from tblsubjectlist where subjectlistseq = psublistseq;
    
    -- 강의실 수강 인원 확인
    select studentnumber into vstudentcnt from tblcourse where courseseq = vcourseseq; 
    
    -- 수강인원과 실기시험성적을 입력한 행의 수가 같은 경우
    if vpcount = vstudentcnt then
        update tblscoretest set practicaltestscorereg = 'Y' where subjectlistseq = psublistseq;
        commit;
        
        dbms_output.put_line('해당 과목을 수강하는 모든 학생의 실기 시험 성적이 등록되었습니다.');

    end if;
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');

end procSetPScoreRegStatus;
/


select * from tblsubjectgrade;
select * from tblscoreinfo;

-- 실기 성적 등록하기
create or replace procedure procSetStdPrctScore(
    pstdseq number,
    psubseq number,
    pcourseseq number,
    pscore number
)
is
    vsublistseq number;
    vscore tblscoreinfo.practicalscore%type;
    vstatus tblstudent.compldropstatus%type;
    vdropdate tblstudent.compldropdate%type;
    vsubfdate tblsubjectlist.subjectfinishdate%type;
    vprctgrade tblsubjectgrade.practicalgrade%type;
begin
    -- 과목목록번호 가져오기
    procGetSubjectListNum(psubseq, pcourseseq, vsublistseq);

    -- 실기성적 가져오기
    procGetStdPrctScore(pstdseq, vsublistseq, vscore);
    
    if vscore is null then
        -- 중도탈락여부 가져오기
        procGetStdDropStatus(pstdseq, vstatus);
        dbms_output.put_line('중도탈락여부: ' || vstatus);
        
        -- 중도탈락일 가져오기
        procGetStdDropDate(pstdseq, vdropdate);
        dbms_output.put_line('중도탈락일: ' || vdropdate);
        
        -- 과목종료일 가져오기
        procGetSubFDate(vsublistseq, vsubfdate);
        dbms_output.put_line('과목종료일: ' || vsubfdate);
        
        if vstatus = '중도탈락' and vdropdate < vsubfdate then -- 중도탈락 + 과목보다 일찍 탈락
            dbms_output.put_line('과목을 다 듣기 전에 탈락하였습니다. 성적을 등록할 수 없습니다. 등록을 종료합니다.');

        else -- 성적 입력 가능
        
            -- 실기배점 가져오기
            procGetPrctGrade(vsublistseq, vprctgrade);
            dbms_output.put_line('실기배점: ' || vprctgrade);
            
            if vprctgrade is not null then -- 배점이 있는 경우
                -- 배점과 입력할 성적 비교
                
                -- 최대 점수가 각 시험의 배점까지이다.
                if pscore < 0 or pscore > vprctgrade then -- 부적절한 범위
                    dbms_output.put_line('유효하지 않은 입력입니다. 입력을 종료합니다.');
                else -- 실기 성적 입력
                    update tblscoreinfo set practicalscore = pscore where studentseq = pstdseq and subjectlistseq = vsublistseq;
                    commit;
                    
                    dbms_output.put_line('실기 성적 등록을 완료했습니다.');
                    
                    -- 모든 학생의 실기 성적이 등록되었다면 'Y'로 바꾸기
                    procSetPScoreRegStatus(vsublistseq);
                end if;
                
            else -- 실기배점이 없는 경우
                dbms_output.put_line('과목에 등록된 실기배점이 없습니다. 배점을 먼저 등록해주세요. 등록을 종료합니다.');
                
            end if;
            
        end if;
        
    else -- 성적이 이미 존재
        dbms_output.put_line('성적이 이미 존재합니다. 등록을 종료합니다.');
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetStdPrctScore;
/
-- 실행
begin
--    procSetStdPrctScore(66, 1, 3, 10);
    procSetStdPrctScore(66, 1, 1, 10);
end;

begin
    procSetStdPrctScore(66, 1, 3, 50);
--    procSetStdPrctScore(1, 1, 1, 50);
--    procSetStdPrctScore(1, 34, 1, 30);
--    procSetStdPrctScore(11, 1, 1, 20);
--    11번학생 1번과정 26번과목
--    procSetStdPrctScore(11, 26, 1, 20);
end;



-- 확인
--select * from tblscoreinfo where studentseq = 66;



-- 찐확인
select * from tblsubjectlist;
select * from tblscoreinfo where subjectlistseq = 1;
select * from tblscoretest where subjectlistseq = 1;

update tblscoretest set practicaltestscorereg = 'N' where subjectlistseq = 1; -- 등록일 다 N으로 변경

-- 1번학생 필기 실기 성적 없애기
update tblscoreinfo set writingscore = null where scoreseq = 1;
update tblscoreinfo set practicalscore = null where scoreseq = 1;


-- 1번학생 필기 성적 등록하기
begin
    procSetStdWrtScore(1, 1, 1, 30);
end;

-- 1번학생 실기 성적 등록하기
begin
    procSetStdPrctScore(11, 1, 1, 40);
end;

select * from tblscoretest where subjectlistseq = 1;
select * from tblscoreinfo where subjectlistseq = 1;



-- 3.3. 출결점수 입력
-- 해당 과정이 끝나야 입력이 가능하다.
-- 해당 과목목록의 과정이 끝났는지 확인
-- 끝났다면 학생번호 골라서 점수 주기
-- 대신 배점만큼

-- 학생 개인의 출결 성적 가져오기
create or replace procedure procGetStdAttScore(
    pstdseq number,
    psublistseq number,
    pattscore out number
)
is
begin
    select attendancescore into pattscore from tblscoreinfo where studentseq = pstdseq and subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdAttScore;
/


-- 과정종료일 가져오기
create or replace procedure procGetCourseFdate(
    pcourseseq number,
    pdate out date
)
is
begin
    select coursefinishdate into pdate from tblcourse where courseseq = pcourseseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseFdate;
/


-- 출결배점 가져오기
create or replace procedure procGetAttGrade(
    psublistseq number,
    pscore out number
)
is 
begin
    select attendancegrade into pscore from tblsubjectgrade where subjectlistseq = psublistseq; 
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetAttGrade;
/
--declare
--    vresult number;
--begin
--    procGetAttGrade(13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 학생의 출결 점수 입력하기
create or replace procedure procSetStdAttScore(
    pstdseq number,
    psubseq number,
    pcourseseq number,
    pscore number
)
is
    vsublistseq number;
    vscore tblscoreinfo.attendancescore%type;
    vstatus tblstudent.compldropstatus%type;
    vdropdate tblstudent.compldropdate%type;
    vcoursefdate tblcourse.coursefinishdate%type;
    vattgrade tblsubjectgrade.attendancegrade%type;
begin
    -- 과목목록번호 가져오기
    procGetSubjectListNum(psubseq, pcourseseq, vsublistseq);

    -- 출결성적 가져오기
    procGetStdAttScore(pstdseq, vsublistseq, vscore);
    
    if vscore is null then
        -- 중도탈락여부 가져오기
        procGetStdDropStatus(pstdseq, vstatus);
        dbms_output.put_line('중도탈락여부: ' || vstatus);
        
        -- 중도탈락일 가져오기
        procGetStdDropDate(pstdseq, vdropdate);
        dbms_output.put_line('중도탈락일: ' || vdropdate);
        
        -- 과정종료일 가져오기
        procGetCourseFdate(pcourseseq, vcoursefdate);
        dbms_output.put_line('과정종료일: ' || vcoursefdate);
        
        if vstatus = '중도탈락' and vdropdate < vcoursefdate then -- 중도탈락 + 과정보다 일찍 탈락
            dbms_output.put_line('과정을 다 듣기 전에 탈락하였습니다. 성적을 등록할 수 없습니다. 등록을 종료합니다.');

        else -- 성적 입력 가능
        
            -- 출결배점 가져오기
            procGetAttGrade(vsublistseq, vattgrade);
            dbms_output.put_line('출결배점: ' || vattgrade);
            
            if vattgrade is not null then -- 배점이 있는 경우
                -- 배점과 입력할 성적 비교
                
                -- 최대 점수가 각 시험의 배점까지이다.
                if pscore < 0 or pscore > vattgrade then -- 부적절한 범위
                    dbms_output.put_line('유효하지 않은 입력입니다. 입력을 종료합니다.');
                else -- 출결 성적 입력
                    update tblscoreinfo set attendancescore = pscore where studentseq = pstdseq and subjectlistseq = vsublistseq;
                    commit;
                    
                    dbms_output.put_line('출결 성적 등록을 완료했습니다.');
                end if;
                
            else -- 출결배점이 없는 경우
                dbms_output.put_line('과목에 등록된 출결배점이 없습니다. 배점을 먼저 등록해주세요. 등록을 종료합니다.');
                
            end if;
            
        end if;
        
    else -- 성적이 이미 존재
        dbms_output.put_line('성적이 이미 존재합니다. 등록을 종료합니다.');
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetStdAttScore;
/
-- 실행
begin
--    procSetStdAttScore(66, 1, 3, 50); -- 과정을 다 듣기 전에 탈락하였습니다.
--    procSetStdAttScore(11, 1, 1, 50);
    -- 학생 1번, 과목목록 1번, 과정 1번, 과목 1번
--    procSetStdAttScore(1, 1, 1, 19);
--    procSetStdAttScore(1, 1, 1, 40);
    procSetStdAttScore(1, 1, 1, 40);
end;


-- 확인
--select * from tblsubjectgrade where subjectlistseq = 10;
--
--select * from tblcourse where courseseq = 3;
--select * from tblscoreinfo where studentseq = 66 and subjectlistseq = 13;
--
-----
--select * from tblcourse where courseseq = 10;
--
--select * from tblsubjectlist where courseseq = 10; -- 37~42
--select * from tblsubjectgrade where subjectlistseq = 37;
--select * from tblscoreinfo where subjectlistseq = 37;
--------------------------------------------------------------------------------------------------------------------

select * from tblscoreinfo; -- subjectlistseq

select* from tblscoreinfo where subjectlistseq = 3;

select * from tblstudent where studentseq = 33;


-- 과정번호 찾기
    select courseseq from tblsubjectlist where subjectlistseq = 6;

select * from tblcourse where courseseq = 1;

select * from tblscoretest;

select * from tblscoreinfo where subjectlistseq = 1;

update tblscoreinfo set writingscore = null where studentseq = 1;

--update tblscoretest set writtentestscorereg = 'N' where subjectlistseq = 1;

update tblscoreinfo set writingscore = 20 where studentseq = 1;

--update tblscoretest set writtentestscorereg = 'N' where scoretestseq = 6;


-- 트리거
--create or replace trigger trgSetScoreRegStatus
--    after
--    update
--    on tblscoreinfo
--    for each row
--declare
--    vwcount number;
--    vpcount number;
--    vcourseseq number;
--    vstudentcnt number;
--begin    
--    -- 해당 과목의 필기성적이 매겨진 학생 수 세기
--    select count(*) into vwcount from tblscoreinfo where subjectlistseq = :new.subjectlistseq and writingscore is not null; 
--    dbms_output.put_line(vwcount);
--    
--    -- 해당 과목의 실기성적이 매겨진 학생 수 세기
--    select count(*) into vpcount from tblscoreinfo where subjectlistseq = :new.subjectlistseq and practicalscore is not null; 
--    dbms_output.put_line(vpcount);
--    
--    -- 과정번호 찾기
--    select courseseq into vcourseseq from tblsubjectlist where subjectlistseq = :new.subjectlistseq;
--    
--    -- 강의실 수강 인원 확인
--    select studentnumber into vstudentcnt from tblcourse where courseseq = vcourseseq; 
--    
--    -- 수강인원과 필기시험성적을 입력한 행의 수가 같은 경우
--    if vwcount = vstudentcnt then
--        dbms_output.put_line(to_char(sysdate, 'hh24:mi:ss') || ' 트리거가 실행되었습니다.');
--        update tblscoretest set writtentestscorereg = 'Y' where scoretestseq = :new.subjectlistseq;
--    end if;
--    
----    -- 수강인원과 실기시험성적을 입력한 행의 수가 같은 경우
----    if vpcount = vstudentcnt then
----        update tblscoretest set practicaltestscorereg = 'Y' where scoretestseq = :new.subjectlistseq;
----    end if;
----    
----exception
----    when NO_DATA_FOUND then
----        dbms_output.put_line('데이터 없음');  
----        
----    when others then
----        dbms_output.put_line('예외 처리');
--
--end trgSetScoreRegStatus;

--drop trigger trgSetScoreRegStatus;


