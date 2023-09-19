--[관리자] 개설 과정 관리
-- 1. 개설 과목 목록 조회 select 
-- 과정 정보(과정명, 과정기간(시작 년월일, 끝 년월일), 강의실)와 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명
-- 과목등록여부가 'Y'일 경우 위 정보 출력/ 'N'일 경우 위 정보 중 과목관련 정보는 null 출력
SELECT  
    cu.*,
    (SELECT SUBNAME FROM tblsubject sj WHERE sl.SUBSEQ = sj.SUBSEQ) AS "과목명",
    TO_CHAR(sl.subjectStartDate, 'yyyy-mm-dd') AS "과목시작일자",
    TO_CHAR(sl.subjectFinishDate, 'yyyy-mm-dd') AS "과목종료일자",
    (SELECT bookNAME FROM tblBook b WHERE sl.bookSEQ = b.bookSEQ) AS "교재명",
    (SELECT name FROM tblTeacher t WHERE sl.teacherSeq = t.teacherSeq) AS "교사명"
FROM vwCourseList cu
LEFT JOIN tblSubjectList sl
    ON cu."과정번호" = sl.courseSeq
ORDER BY cu."과정번호";

--1-1.개설 과목 목록 조회 procedure
-- 과정 정보(과정명, 과정기간(시작 년월일, 끝 년월일), 강의실)와 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명
drop procedure procGetAllCourseInfo;
commit;
CREATE OR REPLACE PROCEDURE procGetAllCourseInfo AS
BEGIN
    FOR cou IN (
        SELECT  
            cu.*,
            (SELECT subName FROM tblSubject sj WHERE sl.subSeq = sj.subSeq) AS "과목명",
            TO_CHAR(sl.subjectStartDate, 'yyyy-mm-dd') AS "과목시작일자",
            TO_CHAR(sl.subjectFinishDate, 'yyyy-mm-dd') AS "과목종료일자",
            (SELECT bookName FROM tblBook b WHERE sl.bookSeq = b.bookSeq) AS "교재명",
            (SELECT name FROM tblTeacher t WHERE sl.teacherSeq = t.teacherSeq) AS "교사명"
        FROM vwCourseList cu
        LEFT JOIN tblSubjectList sl
            ON cu."과정번호" = sl.courseSeq
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('과정번호: ' || cou."과정번호");
        DBMS_OUTPUT.PUT_LINE('과목명: ' || cou."과목명");
        DBMS_OUTPUT.PUT_LINE('과목시작일자: ' || cou."과목시작일자");
        DBMS_OUTPUT.PUT_LINE('과목종료일자: ' || cou."과목종료일자");
        DBMS_OUTPUT.PUT_LINE('교재명: ' || cou."교재명");
        DBMS_OUTPUT.PUT_LINE('교사명: ' || cou."교사명");
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END procGetAllCourseInfo;
/

--프로시저 호출
BEGIN
    procGetAllCourseInfo;
END;
/

-- 2. 특정 개설 과목 목록 조회 procedure
--특정 개설 과정 선택 후 개설 과목 검색( 개설 과목 정보(과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명)) 및 신규 과목 등록
drop procedure procCourseSbjInsSbj;
commit;
CREATE OR REPLACE PROCEDURE procCourseSbjInsSbj (
    vcourseSeq IN NUMBER
) AS
BEGIN
    FOR subj IN (
        SELECT  
            (SELECT subName FROM tblSubject sj WHERE sl.subSeq = sj.subSeq) AS "과목명",
            TO_CHAR(sl.subjectStartDate, 'yyyy-mm-dd') AS "과목시작일자",
            TO_CHAR(sl.subjectFinishDate, 'yyyy-mm-dd') AS "과목종료일자",
            (SELECT bookName FROM tblBook b WHERE sl.bookSeq = b.bookSeq) AS "교재명",
            (SELECT name FROM tblTeacher t WHERE sl.teacherSeq = t.teacherSeq) AS "교사명"
        FROM vwCourseList cu
        LEFT JOIN tblSubjectList sl
            ON cu."과정번호" = sl.courseSeq
        WHERE cu."과정번호" = vcourseSeq 
            ORDER BY cu."과정번호"
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('과목명: ' || subj."과목명");
        DBMS_OUTPUT.PUT_LINE('과목시작일자: ' || subj."과목시작일자");
        DBMS_OUTPUT.PUT_LINE('과목종료일자: ' || subj."과목종료일자");
        DBMS_OUTPUT.PUT_LINE('교재명: ' || subj."교재명");
        DBMS_OUTPUT.PUT_LINE('교사명: ' || subj."교사명");
        DBMS_OUTPUT.PUT_LINE('---------------------------------------------------'); 
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);

END procCourseSbjInsSbj;
/

-- 프로시저 호출
DECLARE
    pCourseSeq NUMBER := 1; --과정 번호를 입력
BEGIN
   procCourseSbjInsSbj(pCourseSeq);
END;
/


--3-0. 교재목록 프로시저
create or replace PROCEDURE procShowAllBook
AS
BEGIN
    -- 모든 교재 정보를 출력
    FOR bookInfo IN (SELECT * FROM tblBook)
    LOOP
        DBMS_OUTPUT.PUT_LINE('교재번호: ' || bookInfo.bookSeq || ', 교재명: ' || bookInfo.bookName);
    END LOOP;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('오류: 해당 교재 번호에 대한 교재 정보를 찾을 수 없습니다.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END procShowAllBook;

--프로시저 호출
BEGIN
    procShowAllBook;
END;
/

--3-0. 입력받은 과목 현재 강의 가능한 교사목록

create or replace PROCEDURE procGetTeacherInfoForSubject(
    pSubSeq IN tblSubject.subSeq%TYPE
) IS
    vTeacherSeq tblTeacher.teacherSeq%TYPE;
    vTeacherName tblTeacher.name%TYPE;
BEGIN
    -- 과목번호로 해당 과목에 가능한 강사 목록 검색
    FOR teacherInfo IN (
        SELECT DISTINCT t.teacherSeq, t.name
        FROM tblTeacher t
        JOIN tblAvailableSubject a ON t.teacherSeq = a.teacherSeq
        WHERE a.subSeq = pSubSeq
    ) LOOP
        vTeacherSeq := teacherInfo.teacherSeq;
        vTeacherName := teacherInfo.name;
        DBMS_OUTPUT.PUT_LINE('강사 번호: ' || vTeacherSeq);
        DBMS_OUTPUT.PUT_LINE('강사 이름: ' || vTeacherName);
    END LOOP;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('오류: 해당 과목에 대한 강의 가능한 강사 정보를 찾을 수 없습니다.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END procGetTeacherInfoForSubject;

--프로시저 호출
BEGIN
    procGetTeacherInfoForSubject(17); -- '과목번호입력'
END;
/



--3. 신규 개설 과목 등록
drop procedure procInsertSubject;
commit;

CREATE OR REPLACE PROCEDURE procInsertSubject (
    vCourseSeq IN tblSubjectlist.courseSeq%TYPE,
    vStartDate IN DATE,
    vEndDate IN DATE,
    vSubjectSeq IN tblSubject.subSeq%TYPE,
    vBookSeq IN tblBook.bookSeq%TYPE,
    vTeacherSeq IN tblTeacher.teacherSeq%TYPE 
) IS
    vSubjectListSeq tblSubjectList.subjectListSeq%TYPE;
    vCurrentDate DATE := SYSDATE;
BEGIN
 
    DBMS_OUTPUT.PUT_LINE('과정 번호: ' || vCourseSeq);
    DBMS_OUTPUT.PUT_LINE('과목 시작일자: ' || TO_CHAR(vStartDate, 'yyyy-mm-dd'));
    DBMS_OUTPUT.PUT_LINE('과목 종료일자: ' || TO_CHAR(vEndDate, 'yyyy-mm-dd'));
    DBMS_OUTPUT.PUT_LINE('과목 번호: ' || vSubjectSeq);
    
    -- 과목 목록 번호 설정 (마지막 번호에 1 추가)
    SELECT NVL(MAX(subjectListSeq), 0) + 1 INTO vSubjectListSeq FROM tblSubjectList;

    -- 과목 시작일자가 현재 날짜 이후인지 확인
    IF vStartDate <= vCurrentDate THEN
        DBMS_OUTPUT.PUT_LINE('오류: 과목 시작일자는 현재 날짜 이후여야 합니다.');
        RETURN;
    END IF;
    
    -- 과목 종료일자가 현재 날짜 이후인지 확인
    IF vEndDate <= vCurrentDate THEN
        DBMS_OUTPUT.PUT_LINE('오류: 과목 종료일자는 현재 날짜 이후여야 합니다.');
        RETURN;
    END IF;
    
    -- 교재 목록
    DBMS_OUTPUT.PUT_LINE('-----교재목록---------');
    procShowAllBook; -- 교재 목록 보여주기
    DBMS_OUTPUT.PUT_LINE('-------------------');

    
    DBMS_OUTPUT.PUT_LINE('-----교사목록-------');
    procGetTeacherInfoForSubject(vSubjectSeq);
    DBMS_OUTPUT.PUT_LINE('-------------------');
    
    -- 선택한 정보로 신규 과목 등록
    INSERT INTO tblSubjectList (subjectListSeq, courseSeq, subSeq, subjectStartDate, subjectFinishDate, bookSeq, teacherSeq)
    VALUES (vSubjectListSeq, vCourseSeq, vSubjectSeq, vStartDate, vEndDate, vBookSeq, vTeacherSeq);

    COMMIT;   

    DBMS_OUTPUT.PUT_LINE('신규 과목 등록이 완료되었습니다.');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('오류: 해당 정보로 등록할 수 없습니다.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
            ROLLBACK;
END procInsertSubject;
/

--프로시저호출
DECLARE
    vCourseSeq tblsubjectlist.courseSeq%TYPE := 7;           -- 과정 번호
    vStartDate DATE := TO_DATE('2023-11-09', 'yyyy-mm-dd');  -- 과목시작일자
    vEndDate DATE := TO_DATE('2024-01-01', 'yyyy-mm-dd');    -- 과목종료일자
    vSubjectSeq tblsubject.subSeq%TYPE := 4;                 -- 과목 번호
    vBookSeq tblbook.BookSEQ%TYPE;                           -- 교재 번호
    vTeacherSeq tblteacher.teacherSEQ%TYPE;                  -- 교사 번호
BEGIN
    -- 교재 번호를 사용자로부터 입력 받음
    vBookSeq := TO_NUMBER(&vBookSeq); 

    -- 교사 번호를 사용자로부터 입력 받음
    vTeacherSeq := TO_NUMBER(&vTeacherSeq); 

    procInsertSubject(vCourseSeq, vStartDate, vEndDate, vSubjectSeq, vBookSeq, vTeacherSeq);
    DBMS_OUTPUT.PUT_LINE('교재 번호: ' || vBookSeq);
    DBMS_OUTPUT.PUT_LINE('교사 번호: ' || vTeacherSeq);
    DBMS_OUTPUT.PUT_LINE('과목 등록이 완료되었습니다.');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
        ROLLBACK;
END;
/






--4. 개설 과목정보 수정 update

--4-a.과목 수정
UPDATE tblSubjectList
    SET subSeq = 2   -- 수정할 과목번호
WHERE courseSeq = 1  -- 과정번호
  AND subSeq = 1;    -- 개설과목번호

--4-b. 과목 시작일 수정
UPDATE tblSubjectList
SET subjectStartDate = 수정할 과목 시작일    
WHERE courseSeq  =     과정번호      
    and subSeq =       개설과목번호  ;       
 
--4-c. 과목 종료일 수정    
 UPDATE tblSubjectList
SET  subjectFinishDate =  수정할 과목 종료일      
WHERE courseSeq  =        과정번호          
    and subSeq =          개설과목번호;             

--4-d. 교재 수정
UPDATE tblSubjectList
SET bookSeq = 3           -- 수정할 교재번호
WHERE courseSeq = 1       -- 과정번호
     and subSeq = 1 ;     -- 개설과목번호

--4-e. 교사 수정
UPDATE tblSubjectList
SET teacherSeq = 1  -- 수정할 교사번호
WHERE courseSeq = 1 -- 과정번호
  AND subSeq = 1;   -- 개설과목번호
 
 drop  procedure procUpdateSubjectInCourse;
 commit;
 
--4-1. 개설과목 수정 UPDATE PROCEDURE

--4-1-a. 개설과목 수정
CREATE OR REPLACE PROCEDURE procUpdateSubCourse(
    pCourseSeq IN NUMBER,
    pSubSeq IN NUMBER,
    pNewSubSeq IN NUMBER
) AS
    vSubExists NUMBER;
BEGIN
      -- 선택한 과정(pcourseSeq)의 특정 과목(psubSeq)이 tblsubject 테이블에 있는지 확인
    SELECT subSeq
    INTO vSubExists
    FROM tblSubject
    WHERE subSeq = pNewSubSeq;

    -- 만약 해당 과목이 존재하지 않으면 오류 처리
    IF vSubExists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('입력한 과목 번호가 존재하지 않습니다. 과목번호를 확인해주세요.');
        RETURN;
    END IF;

    -- 선택한 과정(pcourseSeq)의 특정 과목(psubSeq)을 새로운 과목(pnewSubtSeq)으로 변경
    UPDATE tblSubjectList
     SET subSeq = pNewSubSeq
    WHERE courseSeq = pCourseSeq
      AND subSeq = pSubSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('과목이 수정되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pcourseSeq);
    DBMS_OUTPUT.PUT_LINE('변경 된 과목번호: ' || pnewSubSeq);
EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과목 수정 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/

-- 프로시저 호출
DECLARE
    vCourseSeq NUMBER := 2;        -- 선택한 과정 번호
    vSubSeq NUMBER := 1;           -- 수정하려는 과목 번호
    vNewSubSeq NUMBER := 50;        -- 새로운 과목 번호
BEGIN
    procUpdateSubCourse(vCourseSeq, vSubSeq, vNewSubSeq);
END;
/

--4-1-b.개설과목 교재 수정 procedure 
CREATE OR REPLACE PROCEDURE procUpdateSubBookCu(
    pCourseSeq NUMBER,
    pSubSeq NUMBER,
    pNewBookID NUMBER
) AS
    vBookExists NUMBER;
BEGIN
    -- 교재 번호가 tblbook 테이블에 존재하는지 확인
    SELECT bookSeq
    INTO vBookExists
    FROM tblBook
    WHERE bookSeq= pNewBookID;

    -- 교재가 존재하지 않으면 교재 변경 실패
    IF vBookExists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('입력한 교재 번호가 존재하지 않습니다. 교재번호를 확인해주세요.');
    ELSE
        -- 과목 목록에서 과정과 과목이 일치하는 레코드를 찾아 교재 번호 변경
        UPDATE tblSubjectList
        SET bookSeq = pNewBookID
        WHERE courseSeq = pCourseSeq
          AND subSeq = pSubSeq;

        -- 변경된 내용을 확인하기 위해 커밋
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('교재가 변경되었습니다.');
        DBMS_OUTPUT.PUT_LINE('과정번호: ' || pCourseSeq);
        DBMS_OUTPUT.PUT_LINE('과목번호: ' || pSubSeq);
        DBMS_OUTPUT.PUT_LINE('변경된 교재번호: ' || pNewBookID);
    END IF;
    EXCEPTION
         WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('데이터가 없습니다. 변경이 실패했습니다.');
         WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('교재 변경 중 오류가 발생했습니다.');
            DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/
--프로시저 호출 
DECLARE
    vCourseSeq NUMBER := 1;         -- 사용자로부터 입력받은 과정 번호
    vSubSeq NUMBER := 2;            -- 사용자로부터 입력받은 과목 번호
    vNewBookID NUMBER := 10;       -- 사용자로부터 입력받은 변경할 교재 번호
BEGIN
    procUpdateSubBookCu(vCourseSeq, vSubSeq, vNewBookID);
END;
/

--4-1-c. 개설 교사 수정
 CREATE OR REPLACE PROCEDURE procUpdateTeacherSublist(
    pCourseSeq IN NUMBER,
    pSubSeq IN NUMBER,
    pNewTeacherSeq IN NUMBER
) AS
    vAvailableTeacherSeq NUMBER;
BEGIN
    -- 선택한 과정(pCourseSeq)과 과목(pSubSeq)에 대한 tblAvailableSubject의 교사 코드 확인
    SELECT teacherSeq
        INTO vAvailableTeacherSeq
    FROM tblAvailableSubject
        WHERE teacherSeq = pNewTeacherSeq
             AND subSeq = pSubSeq;

    -- 입력한 교사 코드(pNewTeacherSeq)와 tblAvailableSubject의 교사 코드가 일치하지 않으면 오류 처리
    IF vAvailableTeacherSeq <> pNewTeacherSeq THEN
        DBMS_OUTPUT.PUT_LINE('입력한 교사 코드와 해당 과목의 교사 코드가 일치하지 않습니다. 교사 번호를 확인해주세요.');
        RETURN;
    END IF;

    -- 선택한 과정(pCourseSeq)의 특정 과목(pSubSeq)의 교사 변경
    UPDATE tblSubjectList
    SET teacherSeq = pNewTeacherSeq
    WHERE courseSeq = pCourseSeq
      AND subSeq = pSubSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('교사가 변경되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pCourseSeq);
    DBMS_OUTPUT.PUT_LINE('과목번호: ' || pSubSeq);
    DBMS_OUTPUT.PUT_LINE('새로운 교사 코드: ' || pNewTeacherSeq);
EXCEPTION
     WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('데이터가 없습니다. 변경이 실패했습니다.');
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('교사 변경 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/
 
 --프로시저 호출
 DECLARE
    vCourseSeq NUMBER := 1;             -- 사용자로부터 입력받은 과정 번호
    vSubSeq NUMBER := 14;                -- 사용자로부터 입력받은 과목 번호
    vNewTeacherSeq NUMBER := 1;       -- 사용자로부터 입력받은 변경할 교사 코드
BEGIN
    procUpdateTeacherSublist(vCourseSeq, vSubSeq, vNewTeacherSeq);
END;
/

--4-1-d. 과목 시작일 변경
CREATE OR REPLACE PROCEDURE procUpdateSubStartDate(
    pCourseSeq IN NUMBER,
    pSubSeq IN NUMBER,
    pNewStartDate IN DATE
) AS
    vCurrentDate DATE := SYSDATE;  -- 현재 날짜 가져오기
BEGIN
    -- 현재 날짜 이후인지 확인
    IF pNewStartDate <= vCurrentDate THEN
        DBMS_OUTPUT.PUT_LINE('과목 시작일은 현재 날짜 이후로만 수정 가능합니다.');
        RETURN;  -- 업데이트 거부
    END IF;

    -- 과목 시작일 업데이트
    UPDATE tblSubjectList
    SET subjectStartDate = pNewStartDate
    WHERE courseSeq = pCourseSeq
      AND subSeq = pSubSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('과목 시작일이 수정되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pCourseSeq);
    DBMS_OUTPUT.PUT_LINE('과목번호: ' || pSubSeq);
    DBMS_OUTPUT.PUT_LINE('새로운 시작일: ' || TO_CHAR(pNewStartDate, 'YYYY-MM-DD'));
EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과목 시작일 수정 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/

--프로시저 호출
DECLARE
    vCourseSeq NUMBER := 1;             -- 사용자로부터 입력받은 개설 과정 번호
    vSubSeq NUMBER := 1;                -- 사용자로부터 입력받은 개설 과목 번호
    vNewStartDate DATE := TO_DATE('2022-09-01', 'YYYY-MM-DD');  -- 변경할 시작 날짜
BEGIN
    procUpdateSubStartDate(vCourseSeq, vSubSeq, vNewStartDate);
END;
/

--4-1-e.과목종료일 변경

CREATE OR REPLACE PROCEDURE procUpdateSubFinishDate(
    pCourseSeq IN NUMBER,
    pSubSeq IN NUMBER,
    pNewFinishDate IN DATE
) AS
    vCurrentDate DATE := SYSDATE;  -- 현재 날짜 가져오기
BEGIN
    -- 현재 날짜 이후인지 확인
    IF pNewFinishDate <= vCurrentDate THEN
        DBMS_OUTPUT.PUT_LINE('과목 종료일은 현재 날짜 이후로만 수정 가능합니다.');
        RETURN;  
    END IF;

    -- 과목 종료일 업데이트
    UPDATE tblSubjectList
    SET subjectFinishDate = pNewFinishDate
    WHERE courseSeq = pCourseSeq
      AND subSeq = pSubSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('과목 종료일이 수정되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pCourseSeq);
    DBMS_OUTPUT.PUT_LINE('과목번호: ' || pSubSeq);
    DBMS_OUTPUT.PUT_LINE('새로운 종료일: ' || TO_CHAR(pNewFinishDate, 'YYYY-MM-DD'));
EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과목 종료일 수정 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/

--프로시저 호출
DECLARE
    vCourseSeq NUMBER := 1;             -- 사용자로부터 입력받은 개설 과정 번호
    vSubSeq NUMBER := 1;                -- 사용자로부터 입력받은 개설 과목 번호
    vNewFinishDate DATE := TO_DATE('2022-09-01', 'YYYY-MM-DD');  -- 변경할 종료 날짜
BEGIN
    procUpdateSubFinishDate(vCourseSeq, vSubSeq, vNewFinishDate);
END;
/

--5. 개설 과목 삭제 delete
 
DELETE FROM tblsubjectlist;
WHERE subjectSeq = 삭제할 과목번호 ;

drop procedure DeleteSubjectList;
commit;

--개설과정 삭제 procedure
CREATE OR REPLACE PROCEDURE procDeleteSubjectList(
    pSubjectListSeq NUMBER
) IS
    vRowCount NUMBER;
BEGIN
    -- 입력한 번호가 과목 목록에 있는지 확인
    SELECT COUNT(*)
    INTO vRowCount
    FROM tblSubjectList
    WHERE subjectListSeq = pSubjectListSeq;

    IF vRowCount = 0 THEN
        -- 입력한 번호가 과목 목록에 없으면 오류 처리
        DBMS_OUTPUT.PUT_LINE('입력한 번호가 과목 목록에 존재하지 않습니다. 삭제가 불가능합니다.');
    ELSE
        -- 입력한 번호에 해당하는 과목 목록 삭제
        DELETE FROM tblSubjectList
        WHERE subjectListSeq = pSubjectListSeq;
        
        commit;
        
        DBMS_OUTPUT.PUT_LINE('과목 목록 번호 ' || pSubjectListSeq || '가 삭제되었습니다.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과목 목록 삭제 중 오류가 발생했습니다.');
END;
/

DECLARE
    vSubjectListSeq NUMBER := 59; -- 삭제할 과목 목록 번호 설정
BEGIN
    procDeleteSubjectList(vSubjectListSeq);  
END;
/
commit;
