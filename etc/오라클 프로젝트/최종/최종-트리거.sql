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