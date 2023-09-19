
--로그인 
begin
--    login('이석정','2961047'); -- 교육생 미수료
    login('현민정','1621433'); -- 교육생 수료
--    login('염현빈','1534265'); -- 관리자
--    login('김수진','1928456'); -- 교사
end;
--select logintype from tblLogin where id = '현민정' and pw = '1621433'

/
----------------------------------
--관리자 선택
begin
    adminSelec(10);
end;
/
----------------------------------
--교사 선택
begin
    teacherSelec(10);
end;
/

----------------------------------
--교육생 선택
begin
    studentSelec(10);
end;
/
---------------------------------------------------------------관리자
-----------------------------------------------기초정보
----------------------------------
--2-1-2-1. 기초 정보 목록 출력
begin
    --강의실, 교재, 과목
    basicList('과목');
end;
/
----------------------------------
--2-1-2-2. 강의실 insert
begin
    classLoomInsert(7,30);
end;
/
----------------------------------
--2-1-2-2. 걍의실 이름 수정
begin
    classLoomNameUpdate(7,8);
end;
/
----------------------------------
--2-1-2-2. 강의실 인원 수정
begin
    classLoomSuUpdate(8, 27);
end;
/
----------------------------------
--2-1-2-2. 강의실 삭제
begin
    classLoomDelete(8);
end;
/
----------------------------------
--2-1-2-2. 교재 insert
begin
    --교재명, 출판사
    bookInsert('쌍용코드','바른이름');
end;
/
----------------------------------
--2-1-2-2. 교재 이름 수정
begin
    --번호, 바꿀이름
    bookNameUpdate(42,'바른이름');
end;
/
----------------------------------
--2-1-2-2. 교재 출판사 수정
begin
    --번호, 바꿀출판사
    bookPublisherUpdate(42,'바른이름');
end;
/
----------------------------------
--2-1-2-2. 교재 출판사 삭제
begin
    --번호
    bookDelete(42);
end;
/
----------------------------------
--2-1-2-2. 교재 insert
begin
    --과목이름
    subInsert('쌍용코드');
end;
/
----------------------------------
--2-1-2-2. 교재 수정
begin
    --번호 바꿀이름
    subNameUpdate(36,'쌍용오라클');
end;
/
----------------------------------
--2-1-2-2. 교재 삭제
begin
    --번호
    subDelete(36);
end;
/
-----------------------------------------------교사계정정보
----------------------------------교사정보+교사가능 수업 출력
BEGIN
    GetTeacherSubjects;
END;
/
----------------------------------교사 정보 등록
BEGIN
    -- 이름, 주민번호, 전화번호
    INSERT_TEACHER('흐형원', '2221232', '010-1414-5678');
END;
/
----------------------------------교사 강의가능 목록insert
BEGIN
    --교사번호, 강의이름
    InsertAvailableSubject(11, 'HTML');
END;
/

-----------------------------------------------개설과정관리
----------------------------------과정 목록출력
BEGIN
    procCourseList;
END;
/
----------------------------------전체과정 목록-선택 등록여부 정보출력
BEGIN
    procCourseSearch(7);   --과정 번호를 여기에 입력하세요.
    --과목이 있으면 과목목록 출력//없으면 과목등록 필요 출력
END;
/
----------------------------------등록여부 N - 개설과목 등록
DECLARE
    vCourseSeq tblsubjectlist.courseSeq%TYPE := 7;           -- 과정 번호
    vStartDate DATE := TO_DATE('2023-11-09', 'yyyy-mm-dd');  -- 과목시작일자
    vEndDate DATE := TO_DATE('2024-01-01', 'yyyy-mm-dd');    -- 과목종료일자
    vSubjectSeq tblsubject.subSeq%TYPE := 4;                 -- 과목 번호
    vBookSeq tblbook.BookSEQ%TYPE;                           -- 교재 번호
    vTeacherSeq tblteacher.teacherSEQ%TYPE;                  -- 교사 번호
BEGIN
    -- 교재 번호를 사용자로부터 입력 받음
    vBookSeq := 3; 

    -- 교사 번호를 사용자로부터 입력 받음
    vTeacherSeq := 1; 

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
----------------------------------등록여부 Y - 수정
DECLARE
    vCourseSeq NUMBER := 2;        -- 선택한 과정 번호
    vSubSeq NUMBER := 1;           -- 수정하려는 과목 번호
    vNewSubSeq NUMBER := 50;        -- 새로운 과목 번호
BEGIN
    procUpdateSubCourse(vCourseSeq, vSubSeq, vNewSubSeq);
END;
/
----------------------------------등록여부 Y - 삭제
DECLARE
    vSubjectListSeq NUMBER := 54; -- 삭제할 과목 목록 번호 설정
BEGIN
    procDeleteSubjectList(vSubjectListSeq);  
END;
/
----------------------------------과목 목록출력
BEGIN
    procGetAllCourseInfo;
END;
/
----------------------------------과정 등록
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
----------------------------------과정 수정 - 번호
BEGIN
    procUpdateCourseSeq(22, 14); -- 현재 과정 번호 a를 b으로 수정
END;
/
----------------------------------과정 수정 - 시작일
DECLARE
    vCourseSeq NUMBER := 1;             -- 사용자로부터 입력받은 개설 과정 번호
    vNewStartDate DATE := TO_DATE('2022-09-01', 'YYYY-MM-DD');  -- 변경할 시작 날짜
BEGIN
    procUpdateCourseStartDate(vCourseSeq, vNewStartDate);
END;
/
----------------------------------과정 수정 - 종료일
DECLARE
    vCourseSeq NUMBER := 1;                                      -- 사용자로부터 입력받은 개설 과정 번호
    vNewFinishDate DATE := TO_DATE('2023-12-31', 'YYYY-MM-DD');  -- 변경할 종료 날짜
BEGIN
    procUpdateCourseFinishDate(vCourseSeq, vNewFinishDate);
END;
/
----------------------------------과정 수정 - 강의실명
DECLARE
    vCourseSeq NUMBER := 1;                    -- 수정할 과정 번호
    vNewClassroomName VARCHAR2(50) := 1;  -- 새로운 강의실명
BEGIN
   procUpdateCuClassroomName(vCourseSeq, vNewClassroomName);
END;
/
----------------------------------과정 삭제
BEGIN
    procDeleteCourse(13); --  과정 삭제
END;
/
----------------------------------과정 수료
BEGIN
    procUpdateCompletionStatus; 
END;
/
-----------------------------------------------교육생관리
----------------------------------교육생 목록
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
/
----------------------------------교육생 선택 출력
DECLARE
    p_student_name VARCHAR2(50) := '김진민';
BEGIN
    GetStudentCourseInfo(p_student_name);
END;
/
----------------------------------교육생 등록
BEGIN
    INSERT_STUDENT('rkskek', 1234567, '010-1234-5678', 1);
END;
/
----------------------------------교육생 수정
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
/
----------------------------------교육생 삭제
BEGIN
    DELETE_STUDENT(247);
    COMMIT;
END;
/
----------------------------------교육생 이름검색
DECLARE
    pname TBLSTUDENT.NAME%TYPE := '박민민';
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
/
----------------------------------교육생 주민번호검색
DECLARE
    pssn TBLSTUDENT.SSN%TYPE := '2512125'; -- 여기에 조회하려는 주민번호 입력
BEGIN
    GetStudentSsn(pssn);
END;
/
----------------------------------교육생 폰번호검색
DECLARE
    pphone TBLSTUDENT.PHONE%TYPE := '010-4441-4630'; -- 여기에 조회하려는 전화번호 입력
BEGIN
    GetStudentPhone(pphone);
END;
/
-----------------------------------------------시험관리조회
----------------------------------개설과정 선택
BEGIN
    --개설과정 번호 입력
    GetCourseSubjectsInfo(1);
END;
/
----------------------------------개설과정 과목 성적목록
BEGIN
    --개설 과정번호, 과목번호
    get_subject_scores(1, 1);
END;
/
----------------------------------교육생별 과목 성적목록
DECLARE
    v_student_seq NUMBER;
BEGIN
    v_student_seq := 6; -- 교육생 번호를 지정, 콘솔이나 개발 도구에서 입력하세요.

    -- 프로시저 호출
    GetStudentScores(v_student_seq);
END;
/
----------------------------------교사 정보 수정
BEGIN
    UpdateTeacherInfo('17', '흐지훈', '1920921', '010-6734-0102');
END;
/
----------------------------------교사 정보 삭제
BEGIN
    DeleteTeacher(11); -- 삭제할 교사의 teacherSeq 값을 입력하세요.
END;
/
-----------------------------------------------출결관리조회
----------------------------------개설과정선택 출결조회

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

---------------------------------------------------------------교사
-----------------------------------------------강의스케줄
----------------------------------목록출력
begin 
    --교사번호
    procPrintTeacherSchedule(1);
end;
/
----------------------------------과정선택 - 교육생출력
begin
    procPrintCourseStudentList(10);
end;
/
-----------------------------------------------배점입출력
----------------------------------마친강의 출력
begin
    --교사번호
    procPrintTFinishedSubject(3);
end;
/
----------------------------------마친강의 선택 점수입력
begin
    --과목번호, 과정번호, 출/필/실 배점
--    procSetSubjectGrade(1, 3, 20, 50, 30); -- 과목 과정 출 필 실
--    procSetSubjectGrade(33, 3, 20, 50, 30);
--    procSetSubjectGrade(9, 2, 20, 50, 30); -- 올바른 등록
--    procSetSubjectGrade(9, 2, 10, 50, 40); -- 출결 점수 낮게
    procSetSubjectGrade(9, 2, 20, 50, 50); -- 총 점수를 100 이상
end;
/
----------------------------------필기시험 날짜등록
begin
--    procSetWrtTestDate(1, 3, '23/05/15'); -- 이미 등록
    procSetWrtTestDate(34, 1, '23/05/15');
end;
/
----------------------------------필기시험 문제등록
begin
--    procSetWrtTestDate(1, 3); -- 이미등록
    procSetWrtTestDate(34, 1);
end;
/
----------------------------------실기시험 날짜등록
begin
--    procSetPrctTestDate(1, 3, '23/05/29'); -- 이미 등록
    procSetPrctTestDate(34, 1, '23/05/29');
end;
/
----------------------------------실기시험 문제등록
begin
--    procSetPrctTestDate(1, 3); -- 이미 등록
    procSetPrctTestDate(34, 1);
end;
/
-----------------------------------------------성적입출력
----------------------------------마친강의목록
begin 
    --선생번호
    procPrintTFinishedSubScore(1);
end;
/
----------------------------------마친강의선택-교육생 정보 성적출력
begin
    --과목,마친과정번호, 
    procPrintCourseStdScoreList(1, 3);
end;
/
----------------------------------필기성적입력
begin
    -- 학생번호, 과목, 과정, 성적번호
--    procSetStdWrtScore(66, 1, 3, 50);
--    procSetStdWrtScore(1, 1, 1, 50);
--    procSetStdWrtScore(1, 34, 1, 30);
    procSetStdWrtScore(11, 1, 1, 20);
--    11번학생 1번과정 26번과목
end;
/
----------------------------------실기성적입력
begin
    -- 학생번호, 과목, 과정, 성적번호
--    procSetStdPrctScore(66, 1, 3, 10);
    procSetStdPrctScore(66, 1, 1, 10);
end;
/
----------------------------------학생 출결 성적등록
begin
--    procSetStdAttScore(66, 1, 3, 50); -- 과정을 다 듣기 전에 탈락하였습니다.
--    procSetStdAttScore(11, 1, 1, 50);
    -- 학생 1번, 과목목록 1번, 과정 1번, 과목 1번
--    procSetStdAttScore(1, 1, 1, 19);
--    procSetStdAttScore(1, 1, 1, 40);
    procSetStdAttScore(1, 1, 1, 40);
end;
----------------------------------출결 과정별 조회
begin
    --선생번호, 과정번호
    procPrintCourseAtt(1, 1);
end;
/

----------------------------------출결 기간별 조회
begin
    --선생번호, 시작기간, 종료기간
    procPrintYmAtt(1, '20230101', '20230115');
end;
/
----------------------------------출결 기간별 조회-하루
begin
    procPrintYmdAtt(1, '20230702');
end;
/
----------------------------------출결 인원별 조회
begin
    --선생번호, 학생번호
    procPrintStdAtt(2, 31);
end;

---------------------------------------------------------------교육생
----------------------------------교육생 성적 조회 기능
begin
    --학생번호
    subSelectList(2);
end;
/
----------------------------------성적조회
begin
    --학생번호 (로그인해서 나오는 번호)
    scoreList(2, 'HTML');
end;
/
----------------------------------출석 등록
begin
    --학생번호 (로그인해서 나오는 번호)
    workIn(146);
end;
/
----------------------------------퇴근 등록(출석먼저)
begin
    --학생번호 (로그인해서 나오는 번호)
    workout(146);
end;
/
----------------------------------출석 기간조회
begin
    --학생번호 (로그인해서 나오는 번호)
    workCheck(146, '23/09/18', '23/09/18');
end;
/







----------------------------------------------------관리자 추가기능
------------------------------------협력기업-목록
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
/
------------------------------------협력기업-추가
DECLARE
    v_max_company_seq NUMBER;
BEGIN
    SELECT MAX(companySeq) + 1 INTO v_max_company_seq FROM tblCompany;
    
    INSERT INTO tblCompany (companySeq, name, tel) VALUES (v_max_company_seq, '지니뮤직(주)', '010-5489-2310');
    DBMS_OUTPUT.PUT_LINE('새로운 기업이 추가되었습니다.');
END;
/
------------------------------------협력기업-수정
DECLARE
    v_company_seq NUMBER := 37; -- 수정할 기업의 companySeq
BEGIN
    UPDATE tblCompany SET name = '(주)지니뮤직' WHERE companySeq = v_company_seq;
    UPDATE tblCompany SET tel = '010-6814-3986' WHERE companySeq = v_company_seq;
    DBMS_OUTPUT.PUT_LINE('기업 정보가 수정되었습니다.');
END;
/
------------------------------------협력기업-삭제
DECLARE
    v_company_seq_to_delete NUMBER := 36; -- 삭제할 기업의 companySeq
BEGIN
    DELETE FROM tblCompany WHERE companySeq = v_company_seq_to_delete;
    DBMS_OUTPUT.PUT_LINE('기업 정보가 삭제되었습니다.');
END;
/
------------------------------------취업-목록
DECLARE
BEGIN
    SelectEmploymentData;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/
------------------------------------취업-추가
BEGIN
    procEmployment(245); -- 학생 studentSeq
END;
/
------------------------------------취업-수정
BEGIN
    update_employment_status(244); -- 학생 studentSeq
END;
/
------------------------------------취업-삭제
BEGIN
    DeleteEmployment(245);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/
------------------------------------고용보험
DECLARE
    v_studentSeq NUMBER := 245; -- 학생 번호 지정
BEGIN
    -- 조회
    manage_insurance(NULL, 'SELECT');
    
--    -- 추가
--    manage_insurance(245, 'INSERT');
--    
--    -- 수정
--    manage_insurance(245, 'UPDATE');
--    
--    -- 삭제
--    manage_insurance(245, 'DELETE');
END;
/
select * from tblInsurance;


------------------------------------면접-조회
BEGIN
    select_interview;
END;
/
------------------------------------면접-추가
BEGIN
    insert_interview_and_student(7, '권진아', '3433335', '010-2468-0931', '합격');
--    insert_interview_and_student(null, '우정잉', '3424567', '010-5657-0098', '불합격');
END;
------------------------------------면접-수정
BEGIN
    update_interview_tel(447, '010-2547-0908');
END;
/
------------------------------------면접-삭제
BEGIN
    delete_interview(448);
END;
/
------------------------------------스터디-조회1
BEGIN
    GetStudyStudent;
END;
/
------------------------------------스터디-조회2
begin
    GETSTUDYINFO();
end;


