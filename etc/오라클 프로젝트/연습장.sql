CREATE TABLE tblattendanceStatus (
	atsSeq NUMBER, /* 출퇴번호 */
	studentSeq NUMBER NOT NULL, /* 학생번호 */
	stIn DATE default sysdate, /* 출근시간 */
	stOut DATE default sysdate, /* 퇴근시간 */
    
    CONSTRAINT tbl_atsSeq_pk PRIMARY KEY(atsSeq),
    CONSTRAINT tbl_studentSeq_fk foreign key(studentSeq) references tblStudent(studentSeq)
);

create sequence attendanceStatus_seq;

drop table tblattendanceStatus;

insert into tblattendanceStatus values ((SELECT nvl(max(atsSeq),0) + 1 from tblattendanceStatus), 146,default, default);

select to_char(stin, 'hh24') from tblattendanceStatus;
select to_number(stin, 'hh24') from tblattendanceStatus where studentseq = 146;
select * from tblattendanceStatus;
select * from tblAttendance;

select * from tblattendanceStatus;

select stin, stout from tblattendanceStatus where studentseq = 146;

select processSeq from tblstudent where studentseq = 146;

select * from tblAttendance where attendanceSeq = (SELECT max(attendanceSeq) from tblAttendance);

select * from tblAttendance where studentseq = 146;
select * from tblAttendance where AttendanceDate >= '23/07/15' and AttendanceDate < '23/07/17' and studentseq = 146;
select * from tblAttendance where AttendanceDate >= '23/07/16' and AttendanceDate <= to_date(('23/07/17' || ' 23:59:59'), 'yy-mm-dd hh24:mi:ss') and studentseq = 146;
SELECT
--	'2023-08-29', --자료형?
--	to_date('2023-08-29'),
--	to_date('2023-08-29', 'yyyy-mm-dd'),
--	to_date('20230829'),
--	to_date('20230829', 'yyyymmdd'),
--	to_date('2023/08/29'),
--	to_date('2023/08/29', 'yyyy/mm/dd'),
	to_date('23/07/17 23:59:59', 'yyyy/mm/dd hh24:mi:ss'), --한글은 안됨
    
	to_date(('23/07/17' || ' 23:59:59'), 'yyyy-mm-dd hh24:mi:ss')
FROM dual;
