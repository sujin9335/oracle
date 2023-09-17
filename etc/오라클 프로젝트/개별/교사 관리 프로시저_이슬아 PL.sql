


--교사 정보 등록
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




------------------------------------------------------------------------------


-- 교사의 강의 가능 과목 입력 (선택적으로 추가)
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




--------------------------------------------------------------------------



--교사 정보 출력

CREATE OR REPLACE PROCEDURE GetTeacherSubjects AS
BEGIN
    FOR teacher_rec IN (
        SELECT t.name AS "교사 이름",
               t.ssn AS "주민번호 뒷자리",
               t.tel AS "전화번호",
               s.subName AS "강의 가능 과목"
        FROM tblTeacher t
        LEFT OUTER JOIN tblAvailableSubject a ON t.teacherSeq = a.teacherSeq
        LEFT OUTER JOIN tblSubject s ON a.subSeq = s.subSeq
        ORDER BY t.name
    ) LOOP
        BEGIN
            DBMS_OUTPUT.PUT_LINE('교사 이름: ' || teacher_rec."교사 이름");
            DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || teacher_rec."주민번호 뒷자리");
            DBMS_OUTPUT.PUT_LINE('전화번호: ' || teacher_rec."전화번호");
            DBMS_OUTPUT.PUT_LINE('강의 가능 과목: ' || teacher_rec."강의 가능 과목");
            DBMS_OUTPUT.PUT_LINE('------------------------------------');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('교사 정보가 존재하지 않습니다.');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
        END;
    END LOOP;
END GetTeacherSubjects;

/
begin
    GetTeacherSubjects();
end;

-----------------------------------------------------------------------------




--특정교사 출력


CREATE OR REPLACE PROCEDURE procOptionTeacher(
    p_teacher_seq NUMBER
)
IS
BEGIN
    FOR course_subject_record IN (
        SELECT DISTINCT
            c.COURSENAME AS 과정명,
            c.COURSESTARTDATE AS 과정시작,
            c.COURSEFINISHDATE AS 과정끝,
            j.SUBNAME AS 과목명,
            s.SUBJECTSTARTDATE AS 과목기간시작,
            s.SUBJECTFINISHDATE AS 과목기간끝,
            c.CLASSROOMNAME AS 강의실,
            b.BOOKNAME AS 교재명,
            CASE
                WHEN c.COURSESTARTDATE > SYSDATE THEN '강의 예정'
                WHEN c.COURSESTARTDATE <= SYSDATE AND c.COURSEFINISHDATE >= SYSDATE THEN '강의 중'
                ELSE '강의 종료'
            END AS 강의진행여부
        FROM TBLCLASSROOM r
        INNER JOIN TBLCOURSE c ON r.CLASSROOMNAME = c.CLASSROOMNAME
        INNER JOIN TBLSUBJECTLIST s ON c.COURSESEQ = s.COURSESEQ
        INNER JOIN TBLSCHEDULE d ON s.SUBJECTLISTSEQ = d.SUBJECTLISTSEQ
        INNER JOIN TBLTEACHER t ON d.TEACHERSEQ = t.TEACHERSEQ
        INNER JOIN TBLAVAILABLESUBJECT a ON t.TEACHERSEQ = a.TEACHERSEQ
        INNER JOIN TBLSUBJECT j ON a.SUBSEQ = j.SUBSEQ AND s.SUBSEQ = j.SUBSEQ
        INNER JOIN TBLBOOK b ON s.BOOKSEQ = b.BOOKSEQ
        WHERE a.TEACHERSEQ = p_teacher_seq
        ORDER BY s.SUBJECTSTARTDATE
    )
    LOOP
        BEGIN
            DBMS_OUTPUT.PUT_LINE('과정명: ' || course_subject_record.과정명 || ', ' ||
                                 '과정시작: ' || TO_CHAR(course_subject_record.과정시작, 'YYYY-MM-DD') || ', ' ||
                                 '과정끝: ' || TO_CHAR(course_subject_record.과정끝, 'YYYY-MM-DD') || ', ' ||
                                 '과목명: ' || course_subject_record.과목명 || ', ' ||
                                 '과목기간시작: ' || TO_CHAR(course_subject_record.과목기간시작, 'YYYY-MM-DD') || ', ' ||
                                 '과목기간끝: ' || TO_CHAR(course_subject_record.과목기간끝, 'YYYY-MM-DD') || ', ' ||
                                 '강의실: ' || course_subject_record.강의실 || ', ' ||
                                 '교재명: ' || course_subject_record.교재명 || ', ' ||
                                 '강의진행여부: ' || course_subject_record.강의진행여부);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('교사에 대한 정보가 없습니다.');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
        END;
    END LOOP;
END procOptionTeacher;



/




----------------------------------------------------------------------------

-- 교사 정보 수정 (teacherseq으로 교사 선택)

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



----------------------------------------------------------------------------

-- 교사 정보 삭제

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

