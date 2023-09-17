--목록

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


DECLARE
    pseq TBLSTUDENT.STUDENTSEQ%TYPE;
    pname TBLSTUDENT.NAME%TYPE;
    pssn TBLSTUDENT.SSN%TYPE;
    pphone TBLSTUDENT.PHONE%TYPE;
    preg TBLSTUDENT.REGISTERDATE%TYPE;
    papp TBLSTUDENT.APPLICATIONCLASS%TYPE;
    ppro TBLSTUDENT.PROCESSSEQ%TYPE;
    pdate TBLSTUDENT.COMPLDROPDATE%TYPE;
    pstatus TBLSTUDENT.COMPLDROPSTATUS%TYPE;
BEGIN
    allStudentSelect(pseq, pname, pssn, pphone, preg, papp, ppro, pdate, pstatus);
END;








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

BEGIN
    INSERT_STUDENT('rkskek', 1234567, '010-1234-5678', 1);
    COMMIT;
END;


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


BEGIN
    UPDATE_STUDENT(
            247,
            '수정된 교육생 이름',
            9876543,
            '010-9876-5432',
            TO_DATE('2023-09-15', 'YYYY-MM-DD'),
            2,
            TO_DATE('2023-04-30', 'YYYY-MM-DD'),
            '수료'
        );
    COMMIT;
END;



CREATE OR REPLACE PROCEDURE DELETE_STUDENT (  -- 교육생 삭제 프로시저
    p_student_id NUMBER
) AS
BEGIN
    DELETE FROM TBLSTUDENT
    WHERE STUDENTSEQ = p_student_id;

    COMMIT;
END DELETE_STUDENT;



BEGIN
    DELETE_STUDENT(251);
    COMMIT;
END;



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


DECLARE
    v_name TBLSTUDENT.NAME%TYPE;
    v_ssn TBLSTUDENT.SSN%TYPE;
    v_phone TBLSTUDENT.PHONE%TYPE;
    v_registerdate TBLSTUDENT.REGISTERDATE%TYPE;
    v_compldropstatus TBLSTUDENT.COMPLDROPSTATUS%TYPE;
BEGIN
    GetStudentInfo(1, v_name, v_ssn, v_phone, v_registerdate, v_compldropstatus);


    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || v_name);
    DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || v_ssn);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || v_phone);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(v_registerdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수강 횟수: ' || v_compldropstatus);
END;




---------------------------

create or replace procedure GetStudentName(   --교육생 이름 검색
    pname in TBLSTUDENT.name%type,
    oname out tblstudent.name%type
)
    is
begin

    select name into oname from TBLSTUDENT where name = pname;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 student_id에 대한 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
end;


declare
    oname TBLSTUDENT.name%type;
begin
    GETSTUDENTNAME('최원민',oname);
    DBMS_OUTPUT.PUT_LINE('교육생 이름 : ' || oname );
end;

select * from TBLSTUDENT;

---------------------------






create or replace procedure GetStudentSsn(  --교육생 주민번호 검색
    pname in TBLSTUDENT.name%type,
    oname out tblstudent.name%type,
    ossn out TBLSTUDENT.ssn%type
)
    is
begin

    select name,ssn into oname,ossn from TBLSTUDENT where name = pname;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 student_id에 대한 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
end;


declare
    oname TBLSTUDENT.name%type;
    ossn  TBLSTUDENT.ssn%type;
begin
    GetStudentSsn('정진정', oname, ossn);
    DBMS_OUTPUT.PUT_LINE('교육생 이름 : ' || oname);
    DBMS_OUTPUT.PUT_LINE('교육생 주민번호 : ' || ossn);
end;


create or replace procedure GetStudentPhone(  --교육생 휴대폰 번호 검색
    pname in TBLSTUDENT.name%type,
    oname out TBLSTUDENT.name%type,
    ophone out TBLSTUDENT.phone%type
)
    is
begin
    select name ,PHONE into oname , ophone from TBLSTUDENT where NAME = pname;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 student_id에 대한 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
end;

declare
    oname TBLSTUDENT.name%type;
    ophone TBLSTUDENT.phone%type;
begin
    GetStudentPhone('김형우', oname,ophone);
    DBMS_OUTPUT.PUT_LINE('교육생 이름 : ' || oname);
    DBMS_OUTPUT.PUT_LINE('교육생 휴대폰 번호 : ' || ophone);
end;

-- 교육생 정보 출력시 교육생 이름, 주민번호 뒷자리, 전화번호, 등록일, 수강(신청) 횟수를 출력한다.

CREATE OR REPLACE PROCEDURE GetStudentInfo(
    pstudentid IN NUMBER,
    pstudentname OUT TBLSTUDENT.NAME%TYPE,
    pssnlast4 OUT TBLSTUDENT.SSN%TYPE,
    pphonenumber OUT TBLSTUDENT.PHONE%TYPE,
    pregistrationdate OUT TBLSTUDENT.REGISTERDATE%TYPE,
    pcoursecount OUT NUMBER
)
    IS
BEGIN
    -- 주어진 student_id로부터 교육생 정보를 검색합니다.
    SELECT name, SUBSTR(ssn, -4), phone, registerdate
    INTO pstudentname, pssnlast4, pphonenumber, pregistrationdate
    FROM TBLSTUDENT
    WHERE STUDENTSEQ = pstudentid;

    -- 수강 횟수를 계산합니다.
    SELECT COUNT(*) INTO pcoursecount
    FROM tblcourselist
    WHERE studentseq = pstudentid;

    -- 결과를 출력합니다.
    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pstudentname);
    DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || pssnlast4);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || pphonenumber);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(pregistrationdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수강 횟수: ' || pcoursecount);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 student_id에 대한 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END GetStudentInfo;


DECLARE
    pstudentid NUMBER := 2;
    pstudentname TBLSTUDENT.NAME%TYPE;
    pssnlast4 TBLSTUDENT.SSN%TYPE;
    pphonenumber TBLSTUDENT.PHONE%TYPE;
    pregistrationdate TBLSTUDENT.REGISTERDATE%TYPE;
    pcoursecount NUMBER;
BEGIN
    GetStudentInfo(pstudentid, pstudentname, pssnlast4,
                   pphonenumber, pregistrationdate, pcoursecount);
END;

--특정 교육생 선택시 교육생이 수강 신청한 또는 수강중인, 수강했던 개설 과정 정보(과정명, 과정기간(시작 년월일, 끝 년월일),
-- 강의실, 수료 및 중도탈락 여부, 수료 및 중도탈락 날짜)를 출력한다.




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


DECLARE
    p_student_name VARCHAR2(50) := '김진민';
BEGIN
    GetStudentCourseInfo(p_student_name);
END;

--교육생 정보를 쉽게 확인하기 위한 검색 기능을 사용할 수 있어야 한다.

CREATE OR REPLACE PROCEDURE studentSearch(
    pseq IN TBLSTUDENT.studentseq%TYPE,
    pname OUT TBLSTUDENT.NAME%TYPE,
    pssn OUT TBLSTUDENT.SSN%TYPE,
    pphone OUT TBLSTUDENT.PHONE%TYPE
)
    IS
BEGIN
    SELECT name, ssn, phone
    INTO pname, pssn, pphone
    FROM TBLSTUDENT
    WHERE STUDENTSEQ = pseq;
END studentSearch;



DECLARE
    pseq TBLSTUDENT.studentseq%TYPE := 1;
    pname TBLSTUDENT.NAME%TYPE;
    pssn TBLSTUDENT.SSN%TYPE;
    pphone TBLSTUDENT.PHONE%TYPE;
BEGIN
    studentSearch(pseq, pname, pssn, pphone);
    DBMS_OUTPUT.PUT_LINE('학생명 : ' || pname );
    DBMS_OUTPUT.PUT_LINE( '주민번호 뒷자리 : ' || pssn );
    DBMS_OUTPUT.PUT_LINE('휴대폰 번호 : ' || pphone);
END;

-- 교육생에 대한 수료 및 중도 탈락 처리를 할 수 있어야 한다. 수료 또는 중도탈락 날짜를 입력할 수 있어야 한다.

CREATE OR REPLACE PROCEDURE UpdateCompletionDate(
    p_student_id IN NUMBER
)
    IS
BEGIN
    UPDATE TBLSTUDENT
    SET COMPLDROPDATE = trunc(SYSDATE) , COMPLDROPSTATUS = '중도탈락'
    WHERE STUDENTSEQ = p_student_id;


END UpdateCompletionDate;


BEGIN
    UpdateCompletionDate(2);
END;