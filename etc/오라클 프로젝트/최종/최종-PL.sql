

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
-----------------------------------------------------------------------------관리자
----------------------------------------------------------------------기초정보
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

----------------------------------------------------------------------교사계정정보
----------------------------------교사정보+교사가능 수업 출력
CREATE OR REPLACE PROCEDURE InsertAvailableSubject(
    p_teacherSeq IN NUMBER,
    p_subName IN VARCHAR2
)
IS
    v_maxAsSeq NUMBER;
    v_subSeq NUMBER;
BEGIN
    -- 강의 가능 과목 테이블에서 가장 큰 asSeq 값을 찾습니다.
    SELECT COALESCE(MAX(asseq), 0) + 1 INTO v_maxAsSeq FROM tblavailablesubject;
    
    -- 과목명을 사용하여 해당 과목의 subSeq 값을 찾습니다.
    SELECT subSeq INTO v_subSeq FROM tblSubject WHERE subName = p_subName;

    -- 강의 가능 과목을 추가합니다.
    INSERT INTO tblAvailableSubject (asSeq, teacherSeq, subSeq)
    VALUES (v_maxAsSeq, p_teacherSeq, v_subSeq);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('강의 가능 과목이 추가되었습니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('과목 정보가 존재하지 않습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END InsertAvailableSubject;
/
----------------------------------교사정보 insert
CREATE OR REPLACE PROCEDURE INSERT_TEACHER (
    p_name IN tblTeacher.name%TYPE,
    p_ssn IN tblTeacher.ssn%TYPE,
    p_tel IN tblTeacher.tel%TYPE
)
AS
BEGIN
    DECLARE
        v_max_teacher_seq NUMBER;
    BEGIN
        SELECT MAX(teacherSeq) + 1 INTO v_max_teacher_seq FROM tblTeacher;
        
        INSERT INTO tblTeacher (teacherSeq, name, ssn, tel)
        VALUES (v_max_teacher_seq, p_name, p_ssn, p_tel);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('교사 정보 등록 완료');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
    END;
END INSERT_TEACHER;
/
----------------------------------교사 강의가능 목록insert
CREATE OR REPLACE PROCEDURE InsertAvailableSubject(
    p_teacherSeq IN NUMBER,
    p_subName IN VARCHAR2
)
IS
    v_maxAsSeq NUMBER;
    v_subSeq NUMBER;
BEGIN
    -- 강의 가능 과목 테이블에서 가장 큰 asSeq 값을 찾습니다.
    SELECT COALESCE(MAX(asseq), 0) + 1 INTO v_maxAsSeq FROM tblavailablesubject;
    
    -- 과목명을 사용하여 해당 과목의 subSeq 값을 찾습니다.
    SELECT subSeq INTO v_subSeq FROM tblSubject WHERE subName = p_subName;

    -- 강의 가능 과목을 추가합니다.
    INSERT INTO tblAvailableSubject (asSeq, teacherSeq, subSeq)
    VALUES (v_maxAsSeq, p_teacherSeq, v_subSeq);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('강의 가능 과목이 추가되었습니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('과목 정보가 존재하지 않습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END InsertAvailableSubject;
/
----------------------------------교사 정보 수정
CREATE OR REPLACE PROCEDURE UpdateTeacherInfo(
    p_teacherSeq IN NUMBER,
    p_name IN VARCHAR2,
    p_ssn IN VARCHAR2,
    p_tel IN VARCHAR2
)
IS
BEGIN
    -- 기존 교사의 정보를 새로운 정보로 업데이트합니다.
    UPDATE tblTeacher
      SET
        name = p_name,
        ssn = p_ssn,
        tel = p_tel
    WHERE
        teacherSeq = p_teacherSeq;

    DBMS_OUTPUT.PUT_LINE('교사 정보가 업데이트되었습니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('교사 정보가 존재하지 않습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END UpdateTeacherInfo;
/
----------------------------------교사 정보 삭제
CREATE OR REPLACE PROCEDURE DeleteTeacher(
    p_teacherSeq IN NUMBER
)
IS
BEGIN
    -- 해당 교사의 강의 가능 과목 정보를 먼저 삭제합니다.
    DELETE FROM tblAvailableSubject
    WHERE teacherSeq = p_teacherSeq;

    -- 교사를 삭제합니다.
    DELETE FROM tblTeacher
    WHERE teacherSeq = p_teacherSeq;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('교사 정보가 삭제되었습니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('교사 정보가 존재하지 않습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END DeleteTeacher;
/
----------------------------------------------------------------------개설과정관리
----------------------------------------------------------------------교육생관리
----------------------------------교육생 목록
CREATE OR REPLACE PROCEDURE allStudentSelect(
    pseq OUT TBLSTUDENT.STUDENTSEQ%TYPE,
    pname OUT TBLSTUDENT.NAME%TYPE,
    pssn OUT TBLSTUDENT.SSN%TYPE,
    pphone OUT TBLSTUDENT.PHONE%TYPE,
    preg OUT TBLSTUDENT.REGISTERDATE%TYPE,
    papp OUT TBLSTUDENT.APPLICATIONCLASS%TYPE,
    ppro OUT TBLSTUDENT.PROCESSSEQ%TYPE,
    pdate OUT TBLSTUDENT.COMPLDROPDATE%TYPE,
    pstatus OUT TBLSTUDENT.COMPLDROPSTATUS%TYPE
)
    IS
    CURSOR student_cursor IS
        SELECT STUDENTSEQ, NAME, SSN, PHONE, REGISTERDATE, APPLICATIONCLASS, PROCESSSEQ, COMPLDROPDATE, COMPLDROPSTATUS
        FROM TBLSTUDENT;
BEGIN
    OPEN student_cursor;
    LOOP
        FETCH student_cursor INTO pseq, pname, pssn, pphone, preg, papp, ppro, pdate, pstatus;
        EXIT WHEN student_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('번호 : ' || pseq);
        DBMS_OUTPUT.PUT_LINE('교육생  : ' || pname);
        DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리 : ' || pssn);
        DBMS_OUTPUT.PUT_LINE('휴대폰 번호 : ' || pphone);
        DBMS_OUTPUT.PUT_LINE('등록일: ' || preg);
        DBMS_OUTPUT.PUT_LINE('수강신청횟수 : ' || papp);
        DBMS_OUTPUT.PUT_LINE('과정번호 : ' || ppro);
        DBMS_OUTPUT.PUT_LINE('수료일 및 중도탈락 날짜 : ' || pdate);
        DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락여부 : ' || pstatus);
        DBMS_OUTPUT.PUT_LINE('————————————————');
    END LOOP;
    CLOSE student_cursor;
END allStudentSelect;
/
----------------------------------교육생 선택 출력
CREATE OR REPLACE PROCEDURE GetStudentCourseInfo(
    p_student_name IN VARCHAR2
)
    IS
BEGIN
    FOR course_rec IN (
        SELECT
            c.COURSENAME AS 과정명,
            c.COURSESTARTDATE AS 시작일자,
            c.COURSEFINISHDATE AS 종료일자,
            c.CLASSROOMNAME AS 강의실,
            s.COMPLDROPDATE AS 수료일,
            s.COMPLDROPSTATUS AS 중도탈락여부
        FROM TBLSTUDENT s
                 INNER JOIN TBLCOURSE c ON s.PROCESSSEQ = c.COURSESEQ
                 INNER JOIN TBLSUBJECTLIST j ON c.COURSESEQ = j.SUBJECTLISTSEQ
        WHERE s.NAME = p_student_name
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('과정명: ' || course_rec.과정명);
            DBMS_OUTPUT.PUT_LINE('시작일자: ' || TO_CHAR(course_rec.시작일자, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('종료일자: ' || TO_CHAR(course_rec.종료일자, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('강의실: ' || course_rec.강의실);
            DBMS_OUTPUT.PUT_LINE('수료일: ' || TO_CHAR(course_rec.수료일, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('중도탈락여부: ' || course_rec.중도탈락여부);
            DBMS_OUTPUT.PUT_LINE('--------------------------');
        END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 교육생의 개설 과정 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END GetStudentCourseInfo;
/
----------------------------------교육생 등록
CREATE OR REPLACE PROCEDURE INSERT_STUDENT (   -- 교육생 등록 프로시저
    pname VARCHAR2,
    pjumin NUMBER,
    pphone VARCHAR2,
    pcourse_number NUMBER,
    pregistration_date DATE DEFAULT trunc(SYSDATE),
    pcompletion_date DATE DEFAULT NULL,
    pcompletion_status VARCHAR2 DEFAULT NULL
) AS
BEGIN
    INSERT INTO TBLSTUDENT
    VALUES (
               (SELECT MAX(STUDENTSEQ) + 1 FROM TBLSTUDENT),
               pname,
               pjumin,
               pphone,
               pregistration_date,
               1,
               pcourse_number,
               pcompletion_date,
               pcompletion_status
           );
    COMMIT;
END INSERT_STUDENT;
/
----------------------------------교육생 수정
CREATE OR REPLACE PROCEDURE UPDATE_STUDENT (   -- 교육생 수정 프로시저
    pstudent_id NUMBER,
    pname VARCHAR2,
    pjumin NUMBER,
    pphone VARCHAR2,
    pregistration_date DATE,
    pcourse_number NUMBER,
    pcompletion_date DATE,
    pcompletion_status VARCHAR2
) AS
BEGIN
    UPDATE TBLSTUDENT
    SET
        NAME = pname,
        SSN = pjumin,
        PHONE = pphone,
        REGISTERDATE = pregistration_date,
        APPLICATIONCLASS = pcourse_number,
        COMPLDROPDATE = pcompletion_date,
        COMPLDROPSTATUS = pcompletion_status
    WHERE STUDENTSEQ = pstudent_id;

    COMMIT;
END UPDATE_STUDENT;
/
----------------------------------교육생 삭제
CREATE OR REPLACE PROCEDURE DELETE_STUDENT (  -- 교육생 삭제 프로시저
    p_student_id NUMBER
) AS
BEGIN
    DELETE FROM TBLSTUDENT
    WHERE STUDENTSEQ = p_student_id;

    COMMIT;
END DELETE_STUDENT;
/
----------------------------------교육생 이름검색
CREATE OR REPLACE PROCEDURE GetStudentInfo(  -- 교육생 검색
    pstudent_id IN NUMBER,
    pstudent_name OUT TBLSTUDENT.NAME%TYPE,
    pjumin_no_last4 OUT TBLSTUDENT.ssn%TYPE,
    pphone_number OUT TBLSTUDENT.PHONE%TYPE,
    pregistration_date OUT TBLSTUDENT.REGISTERDATE%TYPE,
    pcourse_count OUT TBLSTUDENT.COMPLDROPSTATUS%TYPE
)
    IS
BEGIN

    SELECT name, ssn, phone, registerdate, compldropstatus
    INTO pstudent_name, pjumin_no_last4, pphone_number, pregistration_date, pcourse_count
    FROM TBLSTUDENT
    WHERE STUDENTSEQ = pstudent_id;

    -- 결과를 출력합니다.
    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pstudent_name);
    DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || pjumin_no_last4);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || pphone_number);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(pregistration_date, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수강 횟수: ' || pcourse_count);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 student_id에 대한 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END GetStudentInfo;
/


----------------------------------------------------------------------시험관리조회
----------------------------------개설과정 선택
CREATE OR REPLACE PROCEDURE GetCourseSubjectsInfo (
    p_courseSeq IN NUMBER
) IS
BEGIN
    FOR subject_rec IN (
        SELECT
            c.courseName AS "과정명",
            sl.subjectListSeq AS "과목번호",
            s.subName AS "과목명",
            CASE
                WHEN st.writtenTestScoreReg = 'Y' THEN '성적등록'
                ELSE '성적미등록'
            END AS "성적등록여부",
            CASE
                WHEN st.writtenTestFileReg = 'Y' THEN '시험문제등록'
                ELSE '시험문제미등록'
            END AS "시험문제등록여부"
        FROM
            tblCourse c
        INNER JOIN
            tblSubjectList sl ON c.courseSeq = sl.courseSeq
        INNER JOIN
            tblScoreTest st ON sl.subjectListSeq = st.subjectListSeq
        INNER JOIN
            tblSubject s ON sl.subSeq = s.subSeq
        WHERE
            c.courseSeq = p_courseSeq
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('과정명: ' || subject_rec."과정명");
        DBMS_OUTPUT.PUT_LINE('과목번호: ' || subject_rec."과목번호");
        DBMS_OUTPUT.PUT_LINE('과목명: ' || subject_rec."과목명");
        DBMS_OUTPUT.PUT_LINE('성적등록여부: ' || subject_rec."성적등록여부");
        DBMS_OUTPUT.PUT_LINE('시험문제등록여부: ' || subject_rec."시험문제등록여부");
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END;
/
----------------------------------개설과정명 목록출력
CREATE OR REPLACE PROCEDURE get_subject_scores (
    p_selected_courseSeq NUMBER,
    p_selected_subSeq NUMBER
) AS
BEGIN
    FOR rec IN (
        SELECT
            c.courseName AS course_name,
            TO_CHAR(c.courseStartDate, 'YYYY-MM-DD') || ' ~ ' || TO_CHAR(c.courseFinishDate, 'YYYY-MM-DD') AS course_period,
            c.classroomName AS classroom_name,
            s.subName AS subject_name,
            t.name AS teacher_name,
            b.bookName AS book_name,
            st.name AS student_name,
            st.ssn AS ssn_suffix,
            si.attendanceScore AS attendance_score,
            si.writingScore AS writing_score
        FROM
            tblCourse c
        INNER JOIN
            tblSubjectList sl ON c.courseSeq = sl.courseSeq
        INNER JOIN
            tblSubject s ON sl.subSeq = s.subSeq
        INNER JOIN
            tblTeacher t ON sl.teacherSeq = t.teacherSeq
        INNER JOIN
            tblBook b ON sl.bookSeq = b.bookSeq
        INNER JOIN
            tblScoreInfo si ON sl.subjectListSeq = si.subjectListSeq
        INNER JOIN
            tblStudent st ON si.studentSeq = st.studentSeq
        WHERE
            sl.courseSeq = p_selected_courseSeq
            AND sl.subSeq = p_selected_subSeq
        ORDER BY
            c.courseName,
            s.subName,
            st.name
    ) LOOP
        -- 결과 출력
        DBMS_OUTPUT.PUT_LINE('개설 과정명: ' || rec.course_name);
        DBMS_OUTPUT.PUT_LINE('개설 과정기간: ' || rec.course_period);
        DBMS_OUTPUT.PUT_LINE('강의실명: ' || rec.classroom_name);
        DBMS_OUTPUT.PUT_LINE('개설 과목명: ' || rec.subject_name);
        DBMS_OUTPUT.PUT_LINE('교사명: ' || rec.teacher_name);
        DBMS_OUTPUT.PUT_LINE('교재명: ' || rec.book_name);
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || rec.student_name);
        DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || rec.ssn_suffix);
        DBMS_OUTPUT.PUT_LINE('필기: ' || rec.attendance_score);
        DBMS_OUTPUT.PUT_LINE('실기: ' || rec.writing_score);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    END LOOP;
END;
/
----------------------------------교육생 개인별 성적목록
CREATE OR REPLACE PROCEDURE GetStudentScores (
    p_student_seq IN NUMBER
)
IS
BEGIN
    FOR r IN (
        SELECT
            st.name AS "교육생 이름",
            st.ssn AS "주민번호 뒷자리",
            c.courseName AS "개설 과정명",
            TO_CHAR(c.courseStartDate, 'YYYY-MM-DD') || ' ~ ' || TO_CHAR(c.courseFinishDate, 'YYYY-MM-DD') AS "개설 과정기간",
            c.classroomName AS "강의실명",
            s.subName AS "개설 과목명",
            TO_CHAR(sl.subjectStartDate, 'YYYY-MM-DD') || ' ~ ' || TO_CHAR(sl.subjectFinishDate, 'YYYY-MM-DD') AS "개설 과목 기간",
            t.name AS "교사명",
            si.attendanceScore AS "필기",
            si.writingScore AS "실기"
        FROM
            tblStudent st
        INNER JOIN
            tblScoreInfo si ON st.studentSeq = si.studentSeq
        INNER JOIN
            tblSubjectList sl ON si.subjectListSeq = sl.subjectListSeq
        INNER JOIN
            tblCourse c ON sl.courseSeq = c.courseSeq
        INNER JOIN
            tblSubject s ON sl.subSeq = s.subSeq
        INNER JOIN
            tblTeacher t ON sl.teacherSeq = t.teacherSeq
        WHERE
            st.studentSeq = p_student_seq
        ORDER BY
            c.courseName,
            s.subseq
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(r."교육생 이름" || ', ' || r."주민번호 뒷자리" || ', ' || r."개설 과정명" || ', ' || r."개설 과정기간" || ', ' || r."강의실명" || ', ' || r."개설 과목명" || ', ' || r."개설 과목 기간" || ', ' || r."교사명" || ', ' || r."필기" || ', ' || r."실기");
    END LOOP;
END GetStudentScores;
/
----------------------------------교육생 이름검색
CREATE OR REPLACE PROCEDURE GetStudentName( -- 이름검색
    pname IN TBLSTUDENT.NAME%TYPE,
    pstudentseq OUT TBLSTUDENT.STUDENTSEQ%TYPE,
    pssn OUT TBLSTUDENT.SSN%TYPE,
    pphone OUT TBLSTUDENT.PHONE%TYPE,
    pregisterdate OUT TBLSTUDENT.REGISTERDATE%TYPE,
    papplicationclass OUT TBLSTUDENT.APPLICATIONCLASS%TYPE,
    pprocessseq OUT TBLSTUDENT.PROCESSSEQ%TYPE,
    pcompldropdate OUT TBLSTUDENT.COMPLDROPDATE%TYPE,
    pcompldropstatus OUT TBLSTUDENT.COMPLDROPSTATUS%TYPE
)
    IS
BEGIN
    SELECT
        STUDENTSEQ,
        SSN,
        PHONE,
        REGISTERDATE,
        APPLICATIONCLASS,
        PROCESSSEQ,
        COMPLDROPDATE,
        COMPLDROPSTATUS
    INTO
        pstudentseq,
        pssn,
        pphone,
        pregisterdate,
        papplicationclass,
        pprocessseq,
        pcompldropdate,
        pcompldropstatus
    FROM
        TBLSTUDENT
    WHERE
            NAME = pname;

    
    DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || pstudentseq);
    DBMS_OUTPUT.PUT_LINE('주민번호: ' || pssn);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || pphone);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(pregisterdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수강신청구분: ' || papplicationclass);
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pprocessseq);
    DBMS_OUTPUT.PUT_LINE('수료일 및 중도탈락 날짜: ' || TO_CHAR(pcompldropdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락 여부: ' || pcompldropstatus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 이름의 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END;
/
----------------------------------교육생 주민번호검색
CREATE OR REPLACE PROCEDURE GetStudentSsn(  --주민번호검색
    pssn IN TBLSTUDENT.SSN%TYPE
)
    IS
    pname TBLSTUDENT.NAME%TYPE;
    pstudentseq TBLSTUDENT.STUDENTSEQ%TYPE;
    pphone TBLSTUDENT.PHONE%TYPE;
    preg TBLSTUDENT.REGISTERDATE%TYPE;
    papp TBLSTUDENT.APPLICATIONCLASS%TYPE;
    ppro TBLSTUDENT.PROCESSSEQ%TYPE;
    pdate TBLSTUDENT.COMPLDROPDATE%TYPE;
    pstatus TBLSTUDENT.COMPLDROPSTATUS%TYPE;
BEGIN
    SELECT NAME, STUDENTSEQ, PHONE, REGISTERDATE, APPLICATIONCLASS, PROCESSSEQ, COMPLDROPDATE, COMPLDROPSTATUS
    INTO pname, pstudentseq, pphone, preg, papp, ppro, pdate, pstatus
    FROM TBLSTUDENT
    WHERE SSN = pssn;

    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pname);
    DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || pstudentseq);
    DBMS_OUTPUT.PUT_LINE('주민번호: ' || pssn);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || pphone);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(preg, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수강신청횟수: ' || papp);
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || ppro);
    DBMS_OUTPUT.PUT_LINE('수료일 및 중도탈락 날짜: ' || TO_CHAR(pdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락 여부: ' || pstatus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 주민번호의 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END;
/
----------------------------------교육생 폰번호검색
CREATE OR REPLACE PROCEDURE GetStudentPhone(
    pphone IN TBLSTUDENT.PHONE%TYPE
)
    IS
    pname TBLSTUDENT.NAME%TYPE;
    pssn TBLSTUDENT.SSN%TYPE;
    preg TBLSTUDENT.REGISTERDATE%TYPE;
    papp TBLSTUDENT.APPLICATIONCLASS%TYPE;
    ppro TBLSTUDENT.PROCESSSEQ%TYPE;
    pdate TBLSTUDENT.COMPLDROPDATE%TYPE;
    pstatus TBLSTUDENT.COMPLDROPSTATUS%TYPE;
BEGIN
    SELECT NAME, SSN, REGISTERDATE, APPLICATIONCLASS, PROCESSSEQ, COMPLDROPDATE, COMPLDROPSTATUS
    INTO pname, pssn, preg, papp, ppro, pdate, pstatus
    FROM TBLSTUDENT
    WHERE PHONE = pphone;

    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pname);
    DBMS_OUTPUT.PUT_LINE('주민번호: ' || pssn);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || pphone);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(preg, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수강신청구분: ' || papp);
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || ppro);
    DBMS_OUTPUT.PUT_LINE('수료일 및 중도탈락 날짜: ' || TO_CHAR(pdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락 여부: ' || pstatus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 전화번호의 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END;
/


----------------------------------------------------------------------출결관리조회
----------------------------------개설과정선택 출결조회
CREATE OR REPLACE PROCEDURE get_attendance_info_range (
    p_selected_courseSeq NUMBER,
    p_selected_year NUMBER,
    p_start_month NUMBER,
    p_start_day NUMBER,
    p_end_month NUMBER,
    p_end_day NUMBER
) AS
BEGIN
    FOR rec IN (
        SELECT
            c.courseName AS "개설 과정명",
            TO_CHAR(a.attendanceDate, 'YYYY-MM-DD') AS "출결 날짜",
            st.name AS "교육생 이름",
            SUBSTR(st.ssn, 7) AS "주민번호 뒷자리",
            a.attendanceStatus AS "출결 상태"
        FROM
            tblCourse c
        INNER JOIN
            tblAttendance a ON c.courseSeq = a.courseSeq
        INNER JOIN
            tblStudent st ON a.studentSeq = st.studentSeq
        WHERE
            c.courseSeq = p_selected_courseSeq
            AND TO_CHAR(a.attendanceDate, 'YYYY') = p_selected_year
            AND TO_CHAR(a.attendanceDate, 'MM') = p_start_month
            AND TO_CHAR(a.attendanceDate, 'DD') >= p_start_day
            AND TO_CHAR(a.attendanceDate, 'MM') = p_end_month
            AND TO_CHAR(a.attendanceDate, 'DD') <= p_end_day
        ORDER BY
            c.courseName,
            a.attendanceDate,
            st.name
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('개설 과정명: ' || rec."개설 과정명");
        DBMS_OUTPUT.PUT_LINE('출결 날짜: ' || rec."출결 날짜");
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || rec."교육생 이름");
        DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || rec."주민번호 뒷자리");
        DBMS_OUTPUT.PUT_LINE('출결 상태: ' || rec."출결 상태");
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    END LOOP;
END;
/
DECLARE
    -- 프로시저 매개변수에 전달할 값들을 정의합니다.
    v_selected_courseSeq NUMBER := 1; -- 선택한 개설 과정 번호
    v_selected_year NUMBER := 2023;   -- 선택한 년도
    v_start_month NUMBER := 5;        -- 시작 월
    v_start_day NUMBER := 15;         -- 시작 일
    v_end_month NUMBER := 5;          -- 끝나는 월
    v_end_day NUMBER := 30;           -- 끝나는 일
BEGIN
    get_attendance_info_range(
        p_selected_courseSeq => v_selected_courseSeq,
        p_selected_year => v_selected_year,
        p_start_month => v_start_month,
        p_start_day => v_start_day,
        p_end_month => v_end_month,
        p_end_day => v_end_day
    );
END;
/
-----------------------------------------------------------------------------교사
----------------------------------------------------------------------강의스케줄
----------------------------------------------------------------------배점입출력
----------------------------------------------------------------------성적입출력
----------------------------------------------------------------------출결관리조회
-----------------------------------------------------------------------------교육생
----------------------------------교육생 성적 조회 기능
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






----------------------------------------------------관리자 추가기능
------------------------------------협력기업-목록
CREATE OR REPLACE PROCEDURE GetCompanyRecords IS
BEGIN
    FOR company_rec IN (SELECT * FROM tblCompany) LOOP
        -- 원하는 작업 수행 (예: DBMS_OUTPUT으로 출력)
        DBMS_OUTPUT.PUT_LINE('CompanySeq: ' || company_rec.companySeq || ', Name: ' || company_rec.name || ', Tel: ' || company_rec.tel);
    END LOOP;
END;
/
------------------------------------협력기업-추가
CREATE OR REPLACE PROCEDURE AddCompany(
    p_name VARCHAR2,
    p_tel VARCHAR2
) IS
BEGIN
    DECLARE
        v_max_company_seq NUMBER;
    BEGIN
        SELECT MAX(companySeq) + 1 INTO v_max_company_seq FROM tblCompany;
        INSERT INTO tblCompany (companySeq, name, tel) VALUES (v_max_company_seq, p_name, p_tel);
        DBMS_OUTPUT.PUT_LINE('새로운 기업이 추가되었습니다.');
    END;
END;
/
------------------------------------협력기업-수정
CREATE OR REPLACE PROCEDURE UpdateCompany(
    p_company_seq NUMBER,
    p_name VARCHAR2,
    p_tel VARCHAR2
) IS
BEGIN
    BEGIN
        UPDATE tblCompany SET name = p_name WHERE companySeq = p_company_seq;
        UPDATE tblCompany SET tel = p_tel WHERE companySeq = p_company_seq;
        DBMS_OUTPUT.PUT_LINE('기업 정보가 수정되었습니다.');
    END;
END;
/
------------------------------------협력기업-삭제
CREATE OR REPLACE PROCEDURE DeleteCompany(
    p_company_seq NUMBER
) IS
BEGIN
    BEGIN
        DELETE FROM tblCompany WHERE companySeq = p_company_seq;
        DBMS_OUTPUT.PUT_LINE('기업 정보가 삭제되었습니다.');
    END;
END;
/
------------------------------------취업-목록
CREATE OR REPLACE PROCEDURE SelectEmploymentData IS
BEGIN
    FOR emp_rec IN (SELECT * FROM tblEmployment) LOOP
        DBMS_OUTPUT.PUT_LINE('employmentSeq: ' || emp_rec.employmentSeq || ', studentSeq: ' || emp_rec.studentSeq || ', status: ' || emp_rec.status);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/
------------------------------------취업-추가
CREATE OR REPLACE PROCEDURE procEmployment (
    p_studentSeq NUMBER
) AS
BEGIN
    INSERT INTO tblEmployment (employmentSeq, studentSeq, status)
    SELECT (SELECT MAX(employmentSeq) + 1 FROM tblEmployment), p_studentSeq, 'N'
    FROM tblStudent
    WHERE studentSeq = p_studentSeq and complDropStatus = '수료';
    
    DBMS_OUTPUT.PUT_LINE('Employment 정보가 추가되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/
------------------------------------취업-수정
CREATE OR REPLACE PROCEDURE update_employment_status (
    p_studentSeq NUMBER
) AS
BEGIN
    UPDATE tblEmployment
    SET status = 'Y'
    WHERE studentSeq = p_studentSeq;
    COMMIT;
END update_employment_status;
/
------------------------------------취업-삭제
CREATE OR REPLACE PROCEDURE DeleteEmployment (
    p_studentSeq IN NUMBER
) IS
BEGIN
    DELETE FROM tblEmployment WHERE studentSeq = p_studentSeq;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('DELETE 오류 발생: ' || SQLERRM);
END;
/
------------------------------------고용보험
CREATE OR REPLACE PROCEDURE manage_insurance (
    p_studentSeq NUMBER,
    p_action VARCHAR2
) AS
BEGIN
    IF p_action = 'SELECT' THEN
        -- 조회
        FOR rec IN (SELECT * FROM tblInsurance) LOOP
            DBMS_OUTPUT.PUT_LINE('고용보험 정보');
            DBMS_OUTPUT.PUT_LINE('InsuranceSeq: ' || rec.insuranceSeq || ' ' || 'StudentSeq: ' || rec.studentSeq || ' ' || 'Status: ' || rec.status);
        END LOOP;
    ELSIF p_action = 'INSERT' THEN
        -- 추가
        INSERT INTO tblInsurance (insuranceSeq, studentSeq, status)
        SELECT (SELECT MAX(insuranceSeq) + 1 FROM tblInsurance), p_studentSeq, 'N'
        FROM tblEmployment e
        WHERE e.studentSeq = p_studentSeq;
        DBMS_OUTPUT.PUT_LINE('Insurance 정보가 추가되었습니다.');
    ELSIF p_action = 'UPDATE' THEN
        -- 수정
        UPDATE tblInsurance SET status = 'Y' WHERE studentSeq = p_studentSeq;
        DBMS_OUTPUT.PUT_LINE('Insurance 정보가 수정되었습니다.');
    ELSIF p_action = 'DELETE' THEN
        -- 삭제
        DELETE FROM tblInsurance WHERE studentSeq = p_studentSeq;
        DBMS_OUTPUT.PUT_LINE('Insurance 정보가 삭제되었습니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('잘못된 동작을 선택하셨습니다.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류발생');
END;
/
------------------------------------면접-조회
CREATE OR REPLACE PROCEDURE select_interview AS
BEGIN
    FOR rec IN (SELECT * FROM tblInterview) LOOP
        DBMS_OUTPUT.PUT_LINE('면접 정보:');
        DBMS_OUTPUT.PUT_LINE('InterviewSeq: ' || rec.iSeq);
        DBMS_OUTPUT.PUT_LINE('SubSeq: ' || rec.subSeq);
        DBMS_OUTPUT.PUT_LINE('Name: ' || rec.name);
        DBMS_OUTPUT.PUT_LINE('SSN: ' || rec.ssn);
        DBMS_OUTPUT.PUT_LINE('Tel: ' || rec.tel);
        DBMS_OUTPUT.PUT_LINE('PassOrNot: ' || rec.passOrNot);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END select_interview;
/
------------------------------------면접-추가
CREATE OR REPLACE PROCEDURE insert_interview_and_student (
    p_subSeq NUMBER,
    p_name VARCHAR2,
    p_ssn VARCHAR2,
    p_tel VARCHAR2,
    p_passOrNot VARCHAR2
) AS
BEGIN
    -- 면접 정보 추가
    INSERT INTO tblInterview (iSeq, subSeq, name, ssn, tel, passOrNot)
    VALUES ((SELECT MAX(iSeq) + 1 FROM tblInterview), p_subSeq, p_name, p_ssn, p_tel, p_passOrNot);
    
    -- '합격'일 경우 학생 정보 추가
    IF p_passOrNot = '합격' THEN
        INSERT INTO tblStudent (studentSeq, name, ssn, phone, ApplicationClass, processSeq)
        VALUES ((SELECT MAX(studentSeq) + 1 FROM tblStudent), p_name, p_ssn, p_tel, 1, p_subSeq);
    END IF;
END insert_interview_and_student;
/
------------------------------------면접-수정
CREATE OR REPLACE PROCEDURE update_interview_tel (
    p_iSeq NUMBER,
    p_tel VARCHAR2
) AS
BEGIN
    UPDATE tblInterview SET tel = p_tel WHERE iSeq = p_iSeq;
    
    UPDATE tblStudent
    SET phone = p_tel
    WHERE ssn = (SELECT ssn FROM tblInterview WHERE iSeq = p_iSeq)
        and name = (SELECT name FROM tblInterview WHERE iSeq = p_iSeq);
    
    DBMS_OUTPUT.PUT_LINE('면접 정보 및 학생 정보가 수정되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END update_interview_tel;
/
------------------------------------면접-삭제
CREATE OR REPLACE PROCEDURE delete_interview (
    p_iSeq NUMBER
) AS
BEGIN
    -- tblInterview에서 해당 iSeq 값 삭제
    DELETE FROM tblInterview WHERE iSeq = p_iSeq;

    -- tblStudent에서 해당 iSeq 값과 관련된 항목 삭제
    DELETE FROM tblStudent WHERE ssn = (SELECT ssn FROM tblInterview WHERE iSeq = p_iSeq)
        and name = (SELECT name FROM tblInterview WHERE iSeq = p_iSeq);
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('오류 발생');
END delete_interview;
/
------------------------------------스터디 조회1
CREATE OR REPLACE PROCEDURE GetStudyStudent
    IS
BEGIN
    FOR study_info IN (
        SELECT
            s.STUDYSEQ AS "스터디번호",
            t.STUDENTSEQ AS "교육생번호",
            t.NAME AS "교육생",
            t.PHONE AS "휴대폰번호",
            s.TOPIC AS "스터디주제"
        FROM TBLSTUDYPERSON p
                 INNER JOIN TBLSTUDY s ON p.STUDYSEQ = s.STUDYSEQ
                 INNER JOIN TBLSTUDYDATA d ON s.STUDYSEQ = d.STUDYSEQ
                 INNER JOIN TBLSTUDENT t ON p.STUDENTSEQ = t.STUDENTSEQ
        )
        LOOP
            
            DBMS_OUTPUT.PUT_LINE('스터디번호: ' || study_info."스터디번호");
            DBMS_OUTPUT.PUT_LINE('교육생번호: ' || study_info."교육생번호");
            DBMS_OUTPUT.PUT_LINE('교육생: ' || study_info."교육생");
            DBMS_OUTPUT.PUT_LINE('휴대폰번호: ' || study_info."휴대폰번호");
            DBMS_OUTPUT.PUT_LINE('스터디주제: ' || study_info."스터디주제");
            DBMS_OUTPUT.PUT_LINE('-----------------------');
        END LOOP;
END GetStudyStudent;
/
------------------------------------스터디 조회2
CREATE OR REPLACE PROCEDURE GetStudyInfo
    IS
BEGIN
    FOR study_info IN (
        SELECT
            s.STUDYSEQ   AS 스터디번호,
            t.STUDENTSEQ AS 교육생번호,
            t.NAME       AS 교육생,
            d.TITLE      AS 제목,
            d.REGDATE    AS 작성일자,
            d.STATUS     AS 파일첨부상태,
            s.STARTDATE  AS 시작일자,
            s.ENDDATE    AS 종료일자
        FROM
            TBLSTUDYPERSON p
                INNER JOIN TBLSTUDY s ON p.STUDYSEQ = s.STUDYSEQ
                INNER JOIN TBLSTUDYDATA d ON s.STUDYSEQ = d.STUDYSEQ
                INNER JOIN TBLSTUDENT t ON p.STUDENTSEQ = t.STUDENTSEQ
        )
        LOOP
           
            DBMS_OUTPUT.PUT_LINE('스터디번호: ' || study_info.스터디번호);
            DBMS_OUTPUT.PUT_LINE('교육생번호: ' || study_info.교육생번호);
            DBMS_OUTPUT.PUT_LINE('교육생: ' || study_info.교육생);
            DBMS_OUTPUT.PUT_LINE('제목: ' || study_info.제목);
            DBMS_OUTPUT.PUT_LINE('작성일자: ' || TO_CHAR(study_info.작성일자, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('파일첨부상태: ' || study_info.파일첨부상태);
            DBMS_OUTPUT.PUT_LINE('시작일자: ' || TO_CHAR(study_info.시작일자, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('종료일자: ' || TO_CHAR(study_info.종료일자, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('———————————');
        END LOOP;
END GetStudyInfo;
/






