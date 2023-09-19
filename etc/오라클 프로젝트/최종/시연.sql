-- 시연

-- 관리자

-- 과정 등록, 조회
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
----------------------------------과정 목록출력
BEGIN
    procCourseList;
END;
/


-- 면접 
/
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
/
-- 합격시 학생 목록에 추가
select  * from tblstudent;
/
-- 권진아 삭제
--delete from tblstudent where studentseq = 247;

/
---------------------------------------------------------------교사
-----------------------------------------------강의스케줄
----------------------------------목록출력

-- 1번 교사 목록 출력하기

begin 
    -- 교사번호
    procPrintTeacherSchedule(1);
end;
/
----------------------------------과정선택 - 교육생출력

-- 1번 과정을 수강하는 교육생 출력하기
begin
    -- 과정번호
    procPrintCourseStudentList(1);
end;
/

-- 성적 입출력
-- 교사가 마친 강의 목록 출력하기
begin 
    --교사번호
    procPrintTFinishedSubScore(1);
end;
/
----------------------------------마친강의선택-교육생 정보 성적출력
-- 선택한 과정을 수강하는 교육생의 정보와 성적 출력
begin
    --과목,마친과정번호
    procPrintCourseStdScoreList(1, 3);
end;
/
----------------------------------필기성적입력
-- 1번 과정, 1번 과목, 11번 학생, 필기성적

-- 데이터 수정
-- 초기화
update tblscoretest set writtentestscorereg = 'N' where subjectlistseq = 1;
update tblscoreinfo set writingscore = null where scoreseq = 61;

/
-- 11번 학생 현재 성적 - 필기 성적 없음
select * from tblscoreinfo where scoreseq = 61;

/
-- 1번 과목목록의 필기 성적 등록 여부가 현재 N
select * from tblscoretest where subjectlistseq = 1;

/
begin
    -- 학생번호, 과목, 과정, 성적번호
    procSetStdWrtScore(11, 1, 1, 20);
end;
/

begin
    -- 학생번호, 과목, 과정, 성적번호
    procSetStdWrtScore(11, 1, 1, 20); -- 중복확인
end;


/

-- 확인
-- 등록된 성적 확인 - 필기: 20점
select * from tblscoreinfo where scoreseq = 61;
/

-- 1번 과목목록의 필기 성적 등록 여부가 Y로 변경
select * from tblscoretest where subjectlistseq = 1;

/

--------------------------------------------------------------------------
-- 교육생
-- 성적 조회
begin
    --학생번호
    subSelectList(11);
end;
/
--select * from tblsubject;
/
----------------------------------성적조회
begin
    --학생번호 (로그인해서 나오는 번호)
    scoreList(11, 'Java');
end;
/

-- 출근 퇴근 처리
----------------------------------출석 등록
begin
    --학생번호 (로그인해서 나오는 번호)
    workIn(2);
end;
/
----------------------------------퇴근 등록(출석먼저)
begin
    --학생번호 (로그인해서 나오는 번호)
    workout(2);
end;
/
----------------------------------출석 기간조회
begin
    --학생번호 (로그인해서 나오는 번호)
    workCheck(2, '23/09/14', '23/09/18');
end;
/

