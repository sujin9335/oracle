-- 관리자
CREATE TABLE tblAdmin (
	adminSeq NUMBER PRIMARY KEY,
	name VARCHAR2(50) NOT NULL,
	ssn VARCHAR2(13) NOT NULL CHECK (LENGTH(ssn) = 7),
	tel VARCHAR2(30) NOT NULL CHECK (LENGTH(tel) = 13)
);
create sequence admin_seq;


-- 교사
CREATE TABLE tblTeacher (
	teacherSeq NUMBER PRIMARY KEY,
	name VARCHAR2(50) NOT NULL,
	ssn VARCHAR2(13) NOT NULL CHECK (LENGTH(ssn) = 7),
	tel VARCHAR2(30) NOT NULL CHECK (LENGTH(tel) = 13)
);
create sequence teacher_seq;


-- 비품
CREATE TABLE tblFixture (
	fixtureSeq NUMBER PRIMARY KEY,
	type VARCHAR2(50) NOT NULL,
	inUse VARCHAR2(10) DEFAULT '미사용' CHECK (inUse IN ('사용중', '미사용')) NOT NULL
);
create sequence fixture_seq;


-- 강의실
CREATE TABLE tblClassroom (
	classroomName VARCHAR2(30) PRIMARY KEY, 
	classroomMaxPeople NUMBER NOT NULL 
);


-- 비품관리
CREATE TABLE tblFixtureMng (
	fixtureMngSeq NUMBER PRIMARY KEY,
	fixtureSeq NUMBER REFERENCES tblFixture(fixtureSeq),
	classroomName VARCHAR2(100) NOT NULL REFERENCES tblClassroom(classroomName)
);

create sequence fixture_mng_seq;


-- 과정
CREATE TABLE tblCourse (
	courseSeq NUMBER PRIMARY KEY, 
	courseName VARCHAR2(255) NOT NULL,
	courseStartDate DATE NOT NULL, 
	courseFinishDate DATE NOT NULL, 
	classroomName VARCHAR2(30) NOT NULL references tblClassroom(classroomName), 
	subjectRegistrationStatus VARCHAR2(100) DEFAULT 'N' NOT NULL check(subjectRegistrationStatus in ('Y', 'N')), 
	studentNumber NUMBER 
);

create sequence course_seq;


-- 추천도서
CREATE TABLE tblRecommendBook (
	recommendBookSeq NUMBER PRIMARY KEY,
	bookName VARCHAR2(255) NOT NULL,
	author VARCHAR2(100) NOT NULL, 
	publisherName VARCHAR2(100) NOT NULL, 
	bookLevel NUMBER NOT NULL, 
	relatedSubject VARCHAR2(100) NOT NULL 
);

create sequence recommend_book_seq;


-- 교재
CREATE TABLE tblBook (
	bookSeq NUMBER PRIMARY KEY,
	bookName VARCHAR2(255) NOT NULL, 
	publisher VARCHAR2(100) NOT NULL
);
create sequence book_seq;


-- 과목
CREATE TABLE tblSubject (
	subSeq NUMBER PRIMARY KEY, 
	subName VARCHAR2(100) NOT NULL
);
create sequence sub_seq;


-- 강의 가능 목록
CREATE TABLE tblAvailableSubject (
	asSeq NUMBER PRIMARY KEY,
	teacherSeq NUMBER NOT NULL REFERENCES tblTeacher(teacherSeq),
	subSeq NUMBER NOT NULL REFERENCES tblSubject(subSeq)
);

create sequence as_seq;


-- 연계기업
CREATE TABLE tblCompany (
	companySeq NUMBER PRIMARY KEY,
	name VARCHAR2(100) NOT NULL,
	tel VARCHAR2(30) NOT NULL
);
create sequence company_seq;


-- 커리큘럼
CREATE TABLE tblCurriculum (
	curriculumSeq NUMBER PRIMARY KEY,
	courseSeq NUMBER NOT NULL REFERENCES tblCourse(courseSeq), 
	curriculumInfo VARCHAR2(500) NOT NULL
);
create sequence curriculum_seq;


-- 세부커리큘럼
CREATE TABLE tblDetailCurriculum (
	detailCurrSeq NUMBER PRIMARY KEY,
	curriculumSeq NUMBER NOT NULL REFERENCES tblCurriculum(curriculumSeq), 
	curriculumName VARCHAR2(500) NOT NULL
);
create sequence detail_curr_seq;


-- 교육생
CREATE TABLE tblStudent (
	studentSeq NUMBER, 
	name VARCHAR2(50) NOT NULL,
	ssn VARCHAR2(13) NOT NULL, 
	phone VARCHAR2(30) NULL, 
	registerDate DATE DEFAULT SYSDATE, 
	ApplicationClass NUMBER DEFAULT 0, 
	processSeq NUMBER NULL,
	complDropDate DATE, 
	complDropStatus VARCHAR2(30) DEFAULT NULL,
    
    CONSTRAINT tblStudent_sseq_pk PRIMARY KEY(studentSeq),
    CONSTRAINT tblStudent_pseq_pk foreign key(processSeq) references tblCourse(courseSeq),
    CONSTRAINT tblStudent_Status_ck check(complDropStatus in ('수료', '중도탈락', NULL))
);


create sequence student_seq;


-- 과목 목록
CREATE TABLE tblSubjectList (
	subjectListSeq NUMBER PRIMARY KEY, 
	courseSeq NUMBER NOT NULL references tblCourse(courseSeq), 
	subSeq NUMBER NOT NULL references tblSubject(subSeq), 
	subjectStartDate DATE NOT NULL, 
	subjectFinishDate DATE NOT NULL,
	bookSeq NUMBER NOT NULL references tblBook(bookSeq), 
	teacherSeq NUMBER NOT NULL references tblTeacher(teacherSeq) 
);

create sequence subject_list_seq;


-- 수강 과정 목록
CREATE TABLE tblCourseList(
    courseListSeq NUMBER PRIMARY KEY,
    studentSeq NUMBER NOT NULL REFERENCES tblStudent(studentSeq),
    courseSeq NUMBER NOT NULL REFERENCES tblCourse(courseSeq)
);
create sequence course_list_seq;


-- 성적 정보
CREATE TABLE tblScoreInfo (
	scoreSeq NUMBER PRIMARY KEY,
	studentSeq NUMBER NOT NULL REFERENCES tblStudent(studentSeq), 
	subjectListSeq NUMBER NOT NULL REFERENCES tblSubjectList(subjectListSeq),
	attendanceScore NUMBER, 
	writingScore NUMBER,
	practicalScore NUMBER
);
create sequence score_seq;


-- 팀 프로젝트 명단
CREATE TABLE tblProjectList (
	pjSeq NUMBER PRIMARY KEY, 
	subjectListSeq NUMBER NOT NULL REFERENCES tblSubjectList(subjectListSeq),
	teamNum NUMBER NOT NULL,
	studentSeq NUMBER NOT NULL REFERENCES tblStudent(studentSeq)
);
create sequence pj_seq;


-- 취업
CREATE TABLE tblEmployment (
	employmentSeq NUMBER PRIMARY KEY,
	studentSeq NUMBER NOT NULL REFERENCES tblStudent(studentSeq),
	status VARCHAR2(30) DEFAULT 'N' NOT NULL CHECK (status IN ('Y', 'N'))
);
create sequence employment_seq;


-- 고용보험
CREATE TABLE tblInsurance (
	insuranceSeq NUMBER PRIMARY KEY,
	studentSeq NUMBER NOT NULL REFERENCES tblStudent(studentSeq),
	status VARCHAR2(10) DEFAULT 'N' NOT NULL CHECK (status IN ('Y', 'N'))
);
create sequence insurance_seq;


-- 로그인
CREATE TABLE tblLogin (
	loginSeq NUMBER,
    basicSeq NUMBER NOT NULL,
	id VARCHAR2(50) NOT NULL, 
	pw VARCHAR2(50) NOT NULL, 
	loginType VARCHAR2(30) NOT NULL,
    
    CONSTRAINT tblLogin_seq primary key(loginSeq),
    CONSTRAINT tblLogin_type check(loginType in ('관리자', '교사', '교육생'))
);

create sequence login_seq;


-- 강의 스케줄
CREATE TABLE tblSchedule (
	scheduleSeq NUMBER PRIMARY KEY,
	teacherSeq NUMBER NOT NULL REFERENCES tblTeacher(teacherSeq),
	subjectListSeq NUMBER NOT NULL REFERENCES tblSubjectList(subjectListSeq),
	progress VARCHAR2(30) NOT NULL CHECK (progress IN ('강의예정', '강의중', '강의종료')) 
);

create sequence schedule_seq;


-- 스터디
CREATE TABLE tblStudy (
	studySeq NUMBER PRIMARY KEY, 
	subSeq NUMBER NOT NULL REFERENCES tblSubject(subSeq), 
	persons NUMBER DEFAULT 0 NOT NULL, 
	startDate DATE NOT NULL, 
	endDate DATE NOT NULL,
	topic VARCHAR2(500) NOT NULL
); 

CREATE SEQUENCE study_seq;


-- 과목 배점 정보
CREATE TABLE tblSubjectGrade (
	subjectGradeSeq NUMBER PRIMARY KEY,
	subjectListSeq NUMBER NOT NULL REFERENCES tblSubjectList(subjectListSeq),
	attendanceGrade NUMBER DEFAULT 20 NOT NULL, 
	writtenGrade NUMBER DEFAULT 40 NOT NULL, 
	practicalGrade NUMBER DEFAULT 40 NOT NULL
);

create sequence subject_grade_seq; 


-- 성적시험등록여부
CREATE TABLE tblScoreTest (
    scoreTestSeq NUMBER PRIMARY KEY,
    subjectListSeq NUMBER NOT NULL REFERENCES tblSubjectList(subjectListSeq) ,
    writtenTestFileReg VARCHAR2(10) DEFAULT 'N' check (writtenTestFileReg in ('Y', 'N' )) ,
    practicalTestFileReg VARCHAR2(10) DEFAULT 'N' check(practicalTestFileReg in ('Y', 'N' )),
    writtenTestDate DATE NULL,
    practicalTestDate DATE NULL,
    writtenTestScoreReg VARCHAR2(10) DEFAULT 'N' check(writtenTestScoreReg in ('Y', 'N' )),
    practicalTestScoreReg VARCHAR2(10) DEFAULT 'N' check(practicalTestScoreReg in ('Y', 'N' ))
);

create sequence score_test_seq;


-- 출결
CREATE TABLE tblAttendance (
	attendanceSeq NUMBER, 
	studentSeq NUMBER NOT NULL, 
	courseSeq NUMBER NOT NULL,
	attendanceDate DATE NOT NULL, 
	attendanceStatus VARCHAR2(10) NOT NULL,
    
    CONSTRAINT tblAttendance_seq_pk PRIMARY KEY(attendanceSeq),
    CONSTRAINT tblAttendance_sseq_fk foreign key(studentSeq) references tblStudent(studentSeq),
    CONSTRAINT tblAttendance_cseq_fk foreign key(courseSeq) references tblCourse(courseSeq),
    CONSTRAINT tblAttendance_status_ck check(AttendanceStatus in ('정상', '지각', '외출', '병가', '조퇴', '결석'))
);
create sequence attendance_seq;


-- 사물함
CREATE TABLE tblLocker (
	lockerSeq NUMBER PRIMARY KEY, 
	studentSeq NUMBER references tblStudent(studentSeq)
);
create sequence locker_seq;


-- 교사평가
CREATE TABLE tblTeacherEvaluation (
    evaluationSeq NUMBER PRIMARY KEY,
	courseSeq NUMBER NOT NULL references tblCourse(courseSeq), 
	teacherSeq NUMBER NOT NULL references tblTeacher(teacherSeq), 
	studentSeq NUMBER NOT NULL references tblStudent(studentSeq), 
	rating number DEFAULT 0
);
create sequence evaluation_seq;


-- 스터디 자료(tblStudyData)
CREATE TABLE tblStudyData (
	studyDataSeq NUMBER PRIMARY KEY,  
	studentSeq NUMBER NOT NULL references tblStudent(studentSeq),
	title VARCHAR2(50) NOT NULL, 
	regdate DATE NOT NULL,
	status VARCHAR2(10) DEFAULT 'N' NOT NULL CHECK (status IN ('Y', 'N')), 
	studySeq NUMBER NOT NULL references tblStudy(studySeq)
);
create sequence study_data_seq; 


-- 스터디 참여자(tblStudyPerson)
CREATE TABLE tblStudyPerson (  
	participationSeq NUMBER PRIMARY KEY, 
	studySeq NUMBER NOT NULL references tblStudy(studySeq),  
	studentSeq NUMBER NOT NULL references tblStudent(studentSeq)
);
create sequence participation_seq;


-- 면접
CREATE TABLE tblInterview (
    iSeq NUMBER,
    subSeq NUMBER NULL,
    name VARCHAR2(50) NOT NULL,
    ssn VARCHAR2(13) NULL,
    tel VARCHAR2(30) NULL,
    passOrNot VARCHAR2(10) NOT NULL,
        
    CONSTRAINT tblInterview_seq_pk primary key(iSeq),
    CONSTRAINT tblInterview_pn_ck check(passOrNot in ('불합격', '합격'))
);

create sequence interview_seq;


-- (보류)
-- 개근
-- 성적우수자
