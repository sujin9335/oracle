
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


DECLARE
    pname TBLSTUDENT.NAME%TYPE := '권진아';
BEGIN
    FOR student_info IN (SELECT * FROM TBLSTUDENT WHERE NAME = pname) LOOP
            
            DBMS_OUTPUT.PUT_LINE('교육생 :' || pname);
            DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || student_info.STUDENTSEQ);
            DBMS_OUTPUT.PUT_LINE('주민번호: ' || student_info.SSN);
            DBMS_OUTPUT.PUT_LINE('전화번호: ' || student_info.PHONE);
            DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(student_info.REGISTERDATE, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('수강신청구분: ' || student_info.APPLICATIONCLASS);
            DBMS_OUTPUT.PUT_LINE('과정번호: ' || student_info.PROCESSSEQ);
            DBMS_OUTPUT.PUT_LINE('수료일 및 중도탈락 날짜: ' || TO_CHAR(student_info.COMPLDROPDATE, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락 여부: ' || student_info.COMPLDROPSTATUS);
            DBMS_OUTPUT.PUT_LINE('-----------------------');
        END LOOP;
END;






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

DECLARE
    pssn TBLSTUDENT.SSN%TYPE := '2512125'; -- 여기에 조회하려는 주민번호 입력
BEGIN
    GetStudentSsn(pssn);
END;






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


DECLARE
    pphone TBLSTUDENT.PHONE%TYPE := '010-5280-6259'; — 여기에 조회하려는 전화번호 입력
BEGIN
    GetStudentPhone(pphone);
END;
