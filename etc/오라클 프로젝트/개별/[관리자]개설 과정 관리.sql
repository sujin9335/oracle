--[관리자] 개설 과정 관리
-- 1. 개설 과정 정보 목록 조회 select 
-- 개설 과정명, 개설 과정기간(시작 년월일, 끝 년월일), 강의실명, 개설 과목 등록 여부, 교육생 등록 인원
select
    t1.courseSeq AS "과정번호",
    t1.courseName AS "과정명",
    TO_CHAR(t1.courseStartDate, 'yyyy-mm-dd') AS "개설과정시작일",
    TO_CHAR(t1.courseFinishDate, 'yyyy-mm-dd') AS "개설과정종료일",
    t2.classRoomName AS "강의실명",
    t1.subjectRegistrationStatus AS "과목등록여부",
    t1.studentNumber AS "교육생인원수"    
from tblcourse t1
         inner join TBLCLASSROOM t2
                ON t1.classroomName = t2.classroomName;
                
--1-1. 개설 과정 정보 목록 조회 view

create or replace view vwCourseList
as
select
    t1.courseSeq AS "과정번호",
    t1.courseName AS "과정명",
    TO_CHAR(t1.courseStartDate, 'yyyy-mm-dd') AS "개설과정시작일",
    TO_CHAR(t1.courseFinishDate, 'yyyy-mm-dd') AS "개설과정종료일",
    t2.classRoomName AS "강의실명",
    t1.subjectRegistrationStatus AS "과목등록여부",
    t1.studentNumber AS "교육생인원수"    
from tblcourse t1
         inner join TBLCLASSROOM t2
                ON t1.classroomName = t2.classroomName; 

select * from vwcourselist;  

--1-2. 개설 과정 정보 목록 조회 procedure

CREATE OR REPLACE PROCEDURE procCourseList IS
BEGIN
    FOR c IN (
        SELECT *
        FROM vwCourseList
        ORDER BY "과정번호"
    ) LOOP
        -- 결과를 출력
        DBMS_OUTPUT.PUT_LINE('과정번호: ' || c."과정번호");
        DBMS_OUTPUT.PUT_LINE('과정명: ' || c."과정명");
        DBMS_OUTPUT.PUT_LINE('개설과정시작일: ' || c."개설과정시작일");
        DBMS_OUTPUT.PUT_LINE('개설과정종료일: ' || c."개설과정종료일");
        DBMS_OUTPUT.PUT_LINE('강의실명: ' || c."강의실명");
        DBMS_OUTPUT.PUT_LINE('과목등록여부: ' || c."과목등록여부");
        DBMS_OUTPUT.PUT_LINE('교육생인원수: ' || c."교육생인원수");
    END LOOP;
END;
/


--프로시저 호출

BEGIN
    procCourseList;
END;
/

-- 2. 특정 개설 과정 정보 출력 select   
-- 개설과정을 선택하여 정보 조회
-- 개설 과목 정보(과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명)
-- + 등록된 교육생 정보(교육생 이름, 주민번호 뒷자리, 전화번호, 등록일, 수료 및 중도탈락날짜, 수료 및 중도탈락 여부)
-- 과목등록여부가 'Y'일 경우 위 정보 출력/ 'N'일 경우 위 정보 null 출력
SELECT  
    (SELECT SUBNAME FROM tblsubject sj WHERE sl.SUBSEQ = sj.SUBSEQ) AS "과목명",
    TO_CHAR(sl.subjectStartDate, 'yyyy-mm-dd') AS "과목시작일자",
    TO_CHAR(sl.subjectFinishDate, 'yyyy-mm-dd') AS "과목종료일자",
    (SELECT BookNAME FROM tblbook b WHERE sl.BookSEQ = b.BookSEQ) AS "교재명",
    (SELECT name FROM tblteacher t WHERE sl.teacherseq = t.teacherSEQ) AS "교사명",
    st.name AS "교육생이름",
    st.ssn AS "주민번호 뒷자리",
    st.phone AS "핸드폰번호",
    TO_CHAR(st.registerdate, 'yyyy-mm-dd') AS "등록일",
    st.applicationClass AS "수강신청횟수",
    TO_CHAR(st.compldropdate, 'yyyy-mm-dd') AS "수료일또는중도탈락일",
    st.compldropstatus AS "수료및중도탈락여부"
FROM tblcourse cu
   LEFT JOIN tblsubjectlist sl
       ON cu.COURSESEQ = sl.COURSESEQ        
              left join tblstudent st
                on sl.COURSESEQ = st.processSeq
                 where cu.courseSeq = 1     -- 조회 원하는 과정 번호 입력
                         order by cu.COURSESEQ;
                         
-- 2. 특정 개설 과정 정보 출력 procedure  
-- 개설과정을 선택하여 정보 조회
-- 개설 과목 정보(과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명)
-- + 등록된 교육생 정보(교육생 이름, 주민번호 뒷자리, 전화번호, 등록일, 수료 및 중도탈락날짜, 수료 및 중도탈락 여부)
-- 과목등록여부가 'Y'일 경우 위 정보 출력/ 'N'일 경우 "과정등록이 필요합니다." 출력                      

CREATE OR REPLACE PROCEDURE procCourseSearch (
    pcourseSeq IN NUMBER
) AS    
    vsubjectRegistrationStatus VARCHAR2(1);
BEGIN
    -- SubjectRegistrationStatus 값을 조회
    BEGIN
        -- "과정번호"를 사용하여 SubjectRegistrationStatus 값을 조회
        SELECT "과목등록여부"
        INTO vsubjectRegistrationStatus
        FROM vwCourseList
        WHERE "과정번호" = pcourseSeq; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('과정을 찾을 수 없습니다.');
            RETURN;
    END;

    -- SubjectRegistrationStatus 값에 따라 분기
    IF vSubjectRegistrationStatus = 'Y' THEN
        -- subjectRegistrationStatus가 'Y'인 경우에만 아래 쿼리 실행
        FOR cus IN (
            SELECT           
                (SELECT subName FROM tblSubject sj WHERE sl.subSeq = sj.subSeq) AS "과목명",
                TO_CHAR(sl.subjectStartDate, 'yyyy-mm-dd') AS "과목시작일자",
                TO_CHAR(sl.subjectFinishDate, 'yyyy-mm-dd') AS "과목종료일자",
                (SELECT bookName FROM tblBook b WHERE sl.bookSeq = b.bookSeq) AS "교재명",
                (SELECT name FROM tblTeacher t WHERE sl.teacherSeq = t.teacherSeq) AS "교사명",
                st.name AS "교육생이름",
                st.ssn AS "주민번호 뒷자리",
                st.phone AS "핸드폰번호",
                TO_CHAR(st.registerDate, 'yyyy-mm-dd') AS "등록일",
                st.applicationClass AS "수강신청횟수",
                TO_CHAR(st.complDropDate, 'yyyy-mm-dd') AS "수료일또는중도탈락일",
                st.complDropStatus AS "수료및중도탈락여부"
            FROM tblcourse cu
            LEFT JOIN tblSubjectList sl
            ON cu.courseSeq = sl.courseSeq        
            LEFT JOIN tblStudent st
            ON sl.courseSeq = st.processSeq   
            WHERE cu.courseSeq = pcourseSeq                           
            ORDER BY cu.courseSeq
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('과목명: ' || cus."과목명");
            DBMS_OUTPUT.PUT_LINE('과목시작일자: ' || cus."과목시작일자");
            DBMS_OUTPUT.PUT_LINE('과목종료일자: ' || cus."과목종료일자");
            DBMS_OUTPUT.PUT_LINE('교재명: ' || cus."교재명");
            DBMS_OUTPUT.PUT_LINE('교사명: ' || cus."교사명");
            DBMS_OUTPUT.PUT_LINE('교육생이름: ' || cus."교육생이름");
            DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || cus."주민번호 뒷자리");
            DBMS_OUTPUT.PUT_LINE('핸드폰번호: ' || cus."핸드폰번호");
            DBMS_OUTPUT.PUT_LINE('등록일: ' || cus."등록일");
            DBMS_OUTPUT.PUT_LINE('수강신청횟수: ' || cus."수강신청횟수");
            DBMS_OUTPUT.PUT_LINE('수료일또는중도탈락일: ' || cus."수료일또는중도탈락일");
            DBMS_OUTPUT.PUT_LINE('수료및중도탈락여부: ' || cus."수료및중도탈락여부");
            DBMS_OUTPUT.PUT_LINE('---------------------------------------------------'); 
        END LOOP;
    ELSIF vSubjectRegistrationStatus = 'N' THEN
       
        DBMS_OUTPUT.PUT_LINE('과목등록이 필요합니다.');       
    ELSE
        DBMS_OUTPUT.PUT_LINE('올바르지 않은 subjectRegistrationStatus 값입니다.');
    END IF;
END procCourseSearch;
/

--프로시저호출
BEGIN
    procCourseSearch(1);   --과정 번호를 여기에 입력하세요.
END;
/

--3. 수료상태 update
--과정 수료한 경우 등록된 교육생 전체에 대하여 수료 날짜 지정, 중도 탈락자 제외
UPDATE tblStudent s
SET s.complDropDate = SYSDATE,
    s.complDropStatus = '수료'
WHERE EXISTS (
    SELECT 1
    FROM tblCourse c
    WHERE s.processSeq= c.courseSeq
    AND c.courseFinishDate <= SYSDATE
)
AND s.complDropDate is null;

--3-1. 수료상태 update procedure
CREATE OR REPLACE PROCEDURE procUpdateCompletionStatus
AS
BEGIN
    UPDATE tblStudent s
    SET s.complDropDate = SYSDATE,
        s.complDropStatus = '수료'
    WHERE EXISTS (
        SELECT 1
        FROM tblcourse c
        WHERE s.processSeq = c.courseSeq
        AND c.courseFinishDate <= SYSDATE
    )
    AND s.complDropDate IS NULL;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('수료 상태가 업데이트되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('업데이트 중 오류가 발생했습니다.');
END;
/
--프로시저 호출
BEGIN
    procUpdateCompletionStatus; 
END;
/

--4. 신규 과정등록 insult
-- 과정번호, 개설 과정명, 개설 과정기간(시작 년월일, 끝 년월일), 강의실명, 개설 과목 등록 여부, 교육생 등록 인원
  INSERT INTO tblcourse(courseSeq, courseName, courseStartDate, courseFinishDate, classroomName, subjectRegistrationStatus, studentNumber)
    VALUES (course_seq.nextval, 개설 과정명, 개설 과정시작 년월일, 개설 과정끝 년월일, 강의실명, 개설 과목 등록 여부, 교육생 등록 인원);
--4-1. 신규 과정등록 procedure
CREATE OR REPLACE PROCEDURE procInsertCourse(
    pCourseName tblCourse.courseName%TYPE,
    pStartDate tblCourse.courseStartDate%TYPE,
    pFinishDate tblCourse.courseFinishDate%TYPE,
    pClassroomName tblCourse.classroomName%TYPE,
    pSubjectStatus tblCourse.subjectRegistrationStatus%TYPE,
    pStudentNumber in out tblCourse.studentNumber%TYPE
) IS
    vClassroomName NUMBER;
    vClassroomMaxPeople NUMBER;
BEGIN
    -- 강의실명이 tblclassroom 테이블에 있는지 확인
    SELECT classroomName, classroomMaxPeople
    INTO vclassroomName, vclassroomMaxPeople
    FROM tblClassroom
    WHERE classroomName = pClassroomName;

    -- 강의실명이 없으면 오류 발생
    IF vclassroomName= 0 THEN
        DBMS_OUTPUT.PUT_LINE('오류: 입력한 강의실명이 tblclassroom에 존재하지 않습니다.');
        RETURN;
    END IF;

    -- 개설과정 시작일과 종료일이 현재 날짜 이후인지 확인
    IF pStartDate <= SYSDATE OR pFinishDate <= SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('오류: 개설과정 시작일과 종료일은 현재 날짜 이후로만 설정 가능합니다.');
        RETURN;
    END IF;

    -- 강의실에 따라 교육생 인원수 설정
    IF pClassroomName IN ('1', '2', '3') THEN
        pStudentNumber := 30;
    ELSIF pClassroomName IN ('4', '5', '6') THEN
        pStudentNumber := 26;
    ELSE
        DBMS_OUTPUT.PUT_LINE('오류: 올바른 강의실명을 입력해주세요.');
        RETURN;
    END IF;

    -- 과정 추가
    INSERT INTO tblCourse(courseSeq, courseName, courseStartDate, courseFinishDate, classroomName, subjectRegistrationStatus, studentNumber)
    VALUES (course_seq.nextval, pCourseName, pStartDate, pFinishDate, pClassroomName, pSubjectStatus, pStudentNumber);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('새로 등록된 과정 정보');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || course_seq.currval);
    DBMS_OUTPUT.PUT_LINE('과정명: ' || pCourseName);
    DBMS_OUTPUT.PUT_LINE('개설과정시작일: ' || TO_CHAR(pStartDate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('개설과정종료일: ' || TO_CHAR(pFinishDate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('강의실명: ' || pClassroomName);
    DBMS_OUTPUT.PUT_LINE('과목등록여부: ' || pSubjectStatus);
    DBMS_OUTPUT.PUT_LINE('교육생인원수: ' || pStudentNumber);
    DBMS_OUTPUT.PUT_LINE('과정이 성공적으로 추가되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과정 추가 중 오류가 발생했습니다.');
END;
/
--프로시저 호출
DECLARE
    vCourseName tblCourse.courseName%TYPE := 'Sample Course';
    vStartDate tblCourse.courseStartDate%TYPE := TO_DATE('2023-09-20', 'YYYY-MM-DD');
    vFinishDate tblCourse.courseFinishDate%TYPE := TO_DATE('2024-01-20', 'YYYY-MM-DD');
    vClassroomName tblCourse.classroomName%TYPE := '1';  -- 강의실명을 여기에 입력
    vSubjectStatus tblCourse.subjectRegistrationStatus%TYPE := 'Y';
    vStudentNumber tblCourse.studentNumber%TYPE := NULL;  -- 초기값은 NULL로 설정

BEGIN
 
    procInsertCourse(vCourseName, vStartDate, vFinishDate, vClassroomName, vSubjectStatus, vStudentNumber);
 
END;
/

--5. 개설과정정보 update ANSI

--5-a.개설 과정번호 수정
UPDATE tblCourse
SET courseSeq = 13          -- 기존 과정번호
WHERE courseSeq = 21;       -- 수정할 과정번호

--5-b.개설과정 시작일 수정
UPDATE tblCourse
SET courseStartDate =  기존 과목시작일    
WHERE courseSeq  =  수정할 과목시작일  ;     
  
--5-c.개설과정 종료일 수정     
UPDATE tblCourse
SET courseFinishDate = 기존 과목 종료일      
WHERE courseSeq  = 수정할 과목종료일  ;           

--5-d.강의실명 수정
Update tblCourse
set classroomName = 기존 강의실명
where courseSeq = 수정할 강의실명;

--5-1. 개설과정정보 update procedure
--5-1-a.개설 과정번호 수정
drop procedure procUpdateCourseSeq;
commit;
CREATE OR REPLACE PROCEDURE procUpdateCourseSeq(
    pCurrentCourseSeq NUMBER,
    pNewCourseSeq NUMBER
) IS
    vCourseExists NUMBER;
BEGIN
      -- 수정하려는 과목번호가 있는지 확인
    SELECT courseSeq
    INTO vCourseExists
    FROM tblcourse
    WHERE courseSeq = pNewCourseSeq;

    -- 만약 해당 과목이 존재하지 않으면 오류 처리
    IF vCourseExists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('입력한 과목 번호가 존재하지 않습니다. 과목번호를 확인해주세요.');
        RETURN;
    END IF;
    
    UPDATE tblCourse
    SET courseSeq = pNewCourseSeq
    WHERE courseSeq = pCurrentCourseSeq;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('과정 번호 ' || pCurrentCourseSeq || '가 ' || pNewCourseSeq || '로 수정되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과정 번호 수정 중 오류가 발생했습니다.');
END;
/

--프로시저 호출
BEGIN
    procUpdateCourseSeq(22, 14); -- 현재 과정 번호 a를 b으로 수정
END;
/


--5-1-b.개설 과정 시작일 수정
CREATE OR REPLACE PROCEDURE procUpdateCourseStartDate(
    pCourseSeq IN NUMBER,
    pNewStartDate IN DATE
) AS
    vCurrentDate DATE := SYSDATE;  -- 현재 날짜 가져오기
BEGIN
    -- 현재 날짜 이후인지 확인
    IF pNewStartDate <= vCurrentDate THEN
        DBMS_OUTPUT.PUT_LINE('과정 시작일은 현재 날짜 이후로만 수정 가능합니다.');
        RETURN;  -- 업데이트 거부
    END IF;

    -- 과정 시작일 업데이트
    UPDATE tblCourse
    SET courseStartDate = pNewStartDate
    WHERE courseSeq = pCourseSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('과정 시작일이 수정되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pCourseSeq);
    DBMS_OUTPUT.PUT_LINE('새로운 시작일: ' || TO_CHAR(pNewStartDate, 'YYYY-MM-DD'));
EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과정 시작일 수정 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/


-- 프로시저 호출
DECLARE
    vCourseSeq NUMBER := 1;             -- 사용자로부터 입력받은 개설 과정 번호
    vNewStartDate DATE := TO_DATE('2022-09-01', 'YYYY-MM-DD');  -- 변경할 시작 날짜
BEGIN
    procUpdateCourseStartDate(vCourseSeq, vNewStartDate);
END;
/


--5-1-c.개설 과정 종료일 수정
CREATE OR REPLACE PROCEDURE procUpdateCourseFinishDate(
    pCourseSeq IN NUMBER,
    pNewFinishDate IN DATE
) AS
    vCurrentDate DATE := SYSDATE;  -- 현재 날짜 가져오기
BEGIN
    -- 현재 날짜 이후인지 확인
    IF pNewFinishDate <= vCurrentDate THEN
        DBMS_OUTPUT.PUT_LINE('과정 종료일은 현재 날짜 이후로만 수정 가능합니다.');
        RETURN; 
    END IF;

    -- 과정 종료일 업데이트
    UPDATE tblCourse
    SET courseFinishDate = pNewFinishDate
    WHERE courseSeq = pCourseSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('과정 종료일이 수정되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pCourseSeq);
    DBMS_OUTPUT.PUT_LINE('새로운 종료일: ' || TO_CHAR(pNewFinishDate, 'YYYY-MM-DD'));
EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과정 종료일 수정 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/

--프로시저 호출
DECLARE
    vCourseSeq NUMBER := 1;                                      -- 사용자로부터 입력받은 개설 과정 번호
    vNewFinishDate DATE := TO_DATE('2023-12-31', 'YYYY-MM-DD');  -- 변경할 종료 날짜
BEGIN
    procUpdateCourseFinishDate(vCourseSeq, vNewFinishDate);
END;
/

commit;

----5-1-d.개설 과정 강의실명 수정

CREATE OR REPLACE PROCEDURE procUpdateCuClassroomName(
    pCourseSeq IN NUMBER,
    pNewClassroomName IN VARCHAR2
) AS
    vClassroomName NUMBER;
BEGIN
    -- 새로운 강의실명(pNewClassroomName)이 tblclassroom 테이블에 있는지 확인
    SELECT classroomName INTO vClassroomName
    FROM tblclassroom
    WHERE classroomName = pNewClassroomName;

    -- 만약 새로운 강의실명이 tblclassroom 테이블에 없으면 오류 발생
    IF vClassroomName = 0 THEN
        DBMS_OUTPUT.PUT_LINE('오류: 새로운 강의실명이 tblclassroom에 존재하지 않습니다.');
        RETURN;
    END IF;

    -- tblCourse 테이블의 강의실명 업데이트
    UPDATE tblCourse
    SET classroomName = pNewClassroomName
    WHERE courseSeq = pCourseSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('강의실명이 수정되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pCourseSeq);
    DBMS_OUTPUT.PUT_LINE('새로운 강의실명: ' || pNewClassroomName);
EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('강의실명 수정 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/
--프로시저 호출
DECLARE
    vCourseSeq NUMBER := 1;                    -- 수정할 과정 번호
    vNewClassroomName VARCHAR2(50) := 1;  -- 새로운 강의실명
BEGIN
   procUpdateCuClassroomName(vCourseSeq, vNewClassroomName);
END;
/

--6.개설과정 삭제 delete
DELETE FROM tblCourse
WHERE courseSeq = 14;

--6-1.개설과정 삭제 delete procedure
drop procedure procDeleteCourse;
commit;
CREATE OR REPLACE PROCEDURE procDeleteCourse(
    pcourseSeq NUMBER
) IS
    vCourseCount NUMBER;
BEGIN
    SELECT courseSeq
    INTO vCourseCount
    FROM tblCourse
    WHERE courseSeq = pcourseSeq;
    
     -- 과정 번호가 없으면 오류 발생
    IF vCourseCount = 0 THEN
        DBMS_OUTPUT.PUT_LINE('오류: 입력한 과정 번호가 존재하지 않습니다.');
        RETURN;
    END IF;
    
    -- 과정 삭제
    DELETE FROM tblCourse
    WHERE courseSeq = pcourseSeq;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('과정 번호 ' || pcourseSeq || '이(가) 삭제되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과정 삭제 중 오류가 발생했습니다.');
END;
/

BEGIN
    procDeleteCourse(13); --  과정 삭제
END;
/
commit;
