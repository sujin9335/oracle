--트리거
create or replace trigger trgAttendance --출석테이블 관리
    after 
    insert
    on tblAttendance
declare
    vseq number;
begin

--    dbms_output.put_line(to_char(sysdate, 'hh24:mi:ss') || '트리거가 실행되었습니다.');
    select studentSeq into vseq from tblAttendance where attendanceSeq = (SELECT max(attendanceSeq) from tblAttendance);
    
    DELETE FROM tblattendanceStatus where studentSeq = vseq;

end trgAttendance;
/
------------------------------------------교사 
create or replace trigger trgDateCompGrade
    before
    update
    on tblsubjectgrade
    for each row
declare
    venddate date;
begin
    dbms_output.put_line(to_char(sysdate, 'hh24:mi:ss') || ' 트리거가 실행되었습니다.');
    
    -- 해당 과목종료일 가져오기
    select subjectfinishdate into venddate from tblsubjectlist where subjectlistseq = :new.subjectlistseq;
    
    if venddate > sysdate then -- 현재날짜가 더 이르면 아직 안끝난 과목
        dbms_output.put_line('해당 과목이 아직 종료되지 않았습니다. 배점 입력이 불가합니다.');
        raise_application_error(-20001, '해당 과목이 아직 종료되지 않았습니다. 배점 입력이 불가합니다.');
    end if;
    
end trgDateCompGrade; 
/


commit;