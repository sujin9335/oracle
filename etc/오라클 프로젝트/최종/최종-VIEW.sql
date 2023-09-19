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

---------------------------------------------------------관리자-개설과정
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






---------------------------------------------------------교사
create or replace view vwTeacherSchedule
as
select 
    sl.subseq as 과목번호, sch.teacherseq as 교사번호, sl.courseseq as 과정번호, c.coursename as 과정명, c.coursestartdate as 과정시작일, c.coursefinishdate as 과정종료일, 
    c.classroomname as 강의실, s.subname as 과목명, sl.subjectstartdate as 과목시작일, sl.subjectfinishdate as 과목종료일,
    b.bookname as 교재명, c.studentnumber as 교육생등록인원,
    case
        when sl.subjectstartdate > sysdate and sl.subjectfinishdate > sysdate then '강의예정'
        when sl.subjectstartdate < sysdate and sl.subjectfinishdate > sysdate then '강의중'
        when sl.subjectfinishdate < sysdate then '강의종료'
    end as 강의진행여부
from tblSchedule sch
    inner join tblSubjectList sl
        on sch.subjectlistseq = sl.subjectlistseq
            inner join tblCourse c
                on sl.courseseq = c.courseseq
                    inner join tblBook b
                        on sl.bookseq = b.bookseq
                            inner join tblSubject s
                                on sl.subseq = s.subseq
order by sl.subjectstartdate asc;




commit;






