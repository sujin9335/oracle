CREATE TABLE tblStudent (
	studentSeq NUMBER, 
	name VARCHAR2(50) NOT NULL,
	ssn VARCHAR2(13) NOT NULL, 
	phone VARCHAR2(30) NULL, 
	registerDate DATE DEFAULT SYSDATE, 
	ApplicationClass NUMBER DEFAULT 0, 
	processSeq NUMBER NULL,
	complDropDate DATE, 
	complDropStatus VARCHAR2(30) DEFAULT NULL
    
--    CONSTRAINT tblStudent_sseq_pk PRIMARY KEY(studentSeq),
--    CONSTRAINT tblStudent_pseq_pk foreign key(processSeq) references tblCourse(courseSeq),
--    CONSTRAINT tblStudent_Status_ck check(complDropStatus in ('수료', '중도탈락', NULL))
);

select * from tblStudent;

drop table tblStudent;
INSERT INTO tblStudent VALUES (student_seq.nextVal,'박민민','1226750','010-5275-4373','2023-02-22',1,1,null,null);

--complDropStatus VARCHAR2(30) CHECK (complDropStatus IN (‘수료’, ’중도탈락’))

create sequence student_seq;

CREATE TABLE tblLogin (
	loginSeq NUMBER,
    basicSeq NUMBER NOT NULL,
	id VARCHAR2(50) NOT NULL, 
	pw VARCHAR2(50) NOT NULL, 
	loginType VARCHAR2(30) NOT NULL,
    
    CONSTRAINT tblLogin_seq primary key(loginSeq),
    CONSTRAINT tblLogin_type check(loginType in ('관리자','교사', '교육생'))
);
drop table tblLogin;
INSERT INTO tblLogin VALUES (login_seq.nextVal,'1','염현빈','1534265','관리자');

create sequence login_seq;

CREATE TABLE tblAttendance (
	attendanceSeq NUMBER, 
	studentSeq NUMBER NOT NULL, --학생번
	courseSeq NUMBER NOT NULL, --과정번
	AttendanceDate DATE NOT NULL, 
	AttendanceStatus VARCHAR2(10) NOT NULL,
    
    CONSTRAINT tblAttendance_seq_pk PRIMARY KEY(attendanceSeq),
    CONSTRAINT tblAttendance_sseq_fk foreign key(studentSeq) references tblStudent(studentSeq),
    CONSTRAINT tblAttendance_cseq_fk foreign key(courseSeq) references tblCourse(courseSeq),
    CONSTRAINT tblAttendance_status_ck check(AttendanceStatus in ('정상', '지각', '외출', '병가', '조퇴', '결석'))
);



