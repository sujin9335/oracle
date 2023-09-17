--view
--교육생 개인의 정보와 교육생이 수강한 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실이 타이틀로 출력
--1번교육생

create or replace view vwStudent
as
select 
    s.studentSeq as 번호,
    s.name as 이름,
    s.phone as 전화번호,
    c.coursename as 과정명,
    c.courseStartDate as 과정시작일,
    c.courseFinishDate as 과정종료일,
    c.classroomName as 강의실
from tblStudent s
    inner join tblCourse c
        on s.processSeq = c.courseseq;
        
select * from vwStudent where 번호 = 1;

create or replace view vwSubList
as
select
    sl.subjectListSeq as 리스트번호,
    c.courseName as 과정이름,
    s.subName as 과목이름,
    sl.subjectStartDate as 과목시작일,
    sl.subjectFinishDate as 과목종료일,
    b.bookName as 교재,
    t.name as 교사,
    sg.attendanceGrade as 출결배점,
    sg.writtenGrade as 필기배점,
    sg.practicalGrade as 실기배점,
    sc.writtenTestDate as 필기시험일,
    sc.practicalTestDate as 실기시험일
from tblsubjectList sl
    inner join tblCourse c
        on sl.courseSeq = c.courseSeq
            inner join tblSubject s
                on sl.subSeq = s.subSeq
                    inner join tblBook b
                        on sl.bookSeq = b.bookSeq
                            inner join tblTeacher t
                                on sl.teacherSeq = t.teacherSeq
                                    left outer join tblSubjectGrade sg
                                        on sl.courseSeq = sg.subjectListSeq
                                            left outer join tblScoreTest sc
                                                on sl.courseSeq = sc.subjectListSeq;
            
        
select * from vwsublist;
select * from tblsubjectList;

create or replace view vwscore
as
select 
    si.studentSeq as 번호,
    vs.과목이름,
    si.attendanceScore as 출결점수,
    si.writingScore as 필기점수,
    si.practicalScore as 실기점수
from tblScoreInfo si
    inner join vwSubList vs
        on si.subjectListSeq = vs.리스트번호; 

















