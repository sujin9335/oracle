1. 시험 관리 및 성적 조회

-- 특정 개설 과정을 선택하는 경우 등록된 개설 과목 정보를 출력하고, 개설 과목 별로 성적 등록 여부, 시험 문제 파일 등록 여부를 확인

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

BEGIN
    GetCourseSubjectsInfo(1);
END;
/

----과목별 출력시 개설 과정명, 개설 과정기간, 강의실명, 개설 과목명, 교사명, 교재명 등을 출력하고, 해당 개설 과목을 수강한 모든 교육생들의 성적 정보(교육생 이름, 주민번호 뒷자리, 필기, 실기)를 같이 출력
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

BEGIN
    get_subject_scores(1, 1);
END;
/

--교육생 개인별 출력시 교육생 이름, 주민번호 뒷자리, 개설 과정명, 개설 과정기간, 강의실명 등을 출력하고, 교육생 개인이 수강한 모든 개설 과목에 대한 성적 정보(개설 과목명, 개설 과목 기간, 교사명, 출력, 필기, 실기)를 같이 출력
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

DECLARE
    v_student_seq NUMBER;
BEGIN
    v_student_seq := 6; -- 교육생 번호를 지정, 콘솔이나 개발 도구에서 입력하세요.

    -- 프로시저 호출
    GetStudentScores(v_student_seq);
END;
/

2. 출결 관리 및 출결 조회

--특정 개설 과정을 선택하는 경우 모든 교육생의 출결을 조회, 출결 현황을 기간별(년, 월, 일) 조회
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

3. 협력기업

-- 조회
CREATE OR REPLACE PROCEDURE GetCompanyRecords IS
BEGIN
    FOR company_rec IN (SELECT * FROM tblCompany) LOOP
        -- 원하는 작업 수행 (예: DBMS_OUTPUT으로 출력)
        DBMS_OUTPUT.PUT_LINE('CompanySeq: ' || company_rec.companySeq || ', Name: ' || company_rec.name || ', Tel: ' || company_rec.tel);
    END LOOP;
END;

-- 추가
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

        COMMIT; -- 변경사항을 커밋
        DBMS_OUTPUT.PUT_LINE('새로운 기업이 추가되었습니다.');
    END;
END;

-- 수정
CREATE OR REPLACE PROCEDURE UpdateCompany(
    p_company_seq NUMBER,
    p_name VARCHAR2,
    p_tel VARCHAR2
) IS
BEGIN
    BEGIN
        UPDATE tblCompany SET name = p_name WHERE companySeq = p_company_seq;
        UPDATE tblCompany SET tel = p_tel WHERE companySeq = p_company_seq;

        COMMIT; -- 변경사항을 커밋
        DBMS_OUTPUT.PUT_LINE('기업 정보가 수정되었습니다.');
    END;
END;

-- 삭제
CREATE OR REPLACE PROCEDURE DeleteCompany(
    p_company_seq NUMBER
) IS
BEGIN
    BEGIN
        DELETE FROM tblCompany WHERE companySeq = p_company_seq;

        COMMIT; -- 변경사항을 커밋
        DBMS_OUTPUT.PUT_LINE('기업 정보가 삭제되었습니다.');
    END;
END;

-- 조회
DECLARE
    CURSOR company_cursor IS
        SELECT * FROM tblCompany;
    
    v_company_rec tblCompany%ROWTYPE;
BEGIN
    OPEN company_cursor;
    LOOP
        FETCH company_cursor INTO v_company_rec;
        EXIT WHEN company_cursor%NOTFOUND;
        -- 원하는 작업 수행 (예: DBMS_OUTPUT으로 출력)
        DBMS_OUTPUT.PUT_LINE('CompanySeq: ' || v_company_rec.companySeq || ', Name: ' || v_company_rec.name || ', Tel: ' || v_company_rec.tel);
    END LOOP;
    CLOSE company_cursor;
END;

-- 추가
DECLARE
    v_max_company_seq NUMBER;
BEGIN
    SELECT MAX(companySeq) + 1 INTO v_max_company_seq FROM tblCompany;
    
    INSERT INTO tblCompany (companySeq, name, tel) VALUES (v_max_company_seq, '지니뮤직(주)', '010-5489-2310');
    
    COMMIT; -- 변경사항을 커밋
    DBMS_OUTPUT.PUT_LINE('새로운 기업이 추가되었습니다.');
END;

-- 수정
DECLARE
    v_company_seq NUMBER := 37; -- 수정할 기업의 companySeq를 지정
BEGIN
    UPDATE tblCompany SET name = '(주)지니뮤직' WHERE companySeq = v_company_seq;
    UPDATE tblCompany SET tel = '010-6814-3986' WHERE companySeq = v_company_seq;
    
    COMMIT; -- 변경사항을 커밋
    DBMS_OUTPUT.PUT_LINE('기업 정보가 수정되었습니다.');
END;

-- 삭제
DECLARE
    v_company_seq_to_delete NUMBER := 36; -- 삭제할 기업의 companySeq를 지정
BEGIN
    DELETE FROM tblCompany WHERE companySeq = v_company_seq_to_delete;
    
    COMMIT; -- 변경사항을 커밋
    DBMS_OUTPUT.PUT_LINE('기업 정보가 삭제되었습니다.');
END;


4. 취업
--조회
-- PL/SQL 프로시저 정의
CREATE OR REPLACE PROCEDURE SelectEmploymentData IS
BEGIN
    FOR emp_rec IN (SELECT * FROM tblEmployment) LOOP
        DBMS_OUTPUT.PUT_LINE('employmentSeq: ' || emp_rec.employmentSeq || ', studentSeq: ' || emp_rec.studentSeq || ', status: ' || emp_rec.status);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END;
/

DECLARE
BEGIN
--    DBMS_OUTPUT.ENABLE(NULL);
    
    -- 프로시저 호출
    SelectEmploymentData;
    
--    DBMS_OUTPUT.DISABLE;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END;
/


--추가
CREATE OR REPLACE PROCEDURE InsertEmployment (
    p_studentSeq IN NUMBER
) IS
BEGIN
    INSERT INTO tblEmployment (employmentSeq, studentSeq, status)
    VALUES ((SELECT MAX(employmentSeq) + 1 FROM tblEmployment), p_studentSeq, 'N');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('INSERT 오류 발생: ' || SQLERRM);
END;
/

DECLARE
--    v_studentSeq NUMBER := 245; -- 학생 번호를 지정합니다.
BEGIN
    InsertEmployment(245);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END;
/

--수정
CREATE OR REPLACE PROCEDURE UpdateEmployment (
    p_studentSeq IN NUMBER
) IS
BEGIN
    UPDATE tblEmployment SET status = 'Y' WHERE studentSeq = p_studentSeq;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('UPDATE 오류 발생: ' || SQLERRM);
END;
/

DECLARE
    v_studentSeq NUMBER; -- 학생 번호를 지정합니다.
    v_status VARCHAR2(1); -- 변경할 상태를 지정합니다.
BEGIN
    -- 프로시저 호출
    UpdateEmploymentStatus(244, 'Y');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END;
/

--삭제
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

DECLARE
    v_studentSeq NUMBER := 245; -- 학생 번호를 지정합니다.
BEGIN
    DeleteEmployment(v_studentSeq);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END;
/