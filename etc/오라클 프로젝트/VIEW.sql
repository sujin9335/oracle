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