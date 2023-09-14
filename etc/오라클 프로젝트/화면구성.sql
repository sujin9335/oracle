
--로그인 
begin
    login('조성진', '1432698');
end;
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
----------------------------------
declare
    vcursor sys_refcursor; --커서 참조 변수
    vrow tblclassroom%rowtype;
begin
    basicList(1, vcursor);
--    loop 
--        fetch vcursor into vrow;
--        exit when vcursor%notfound;
--        dbms_output.put_line(vrow.classroomname);
--        
--    end loop;
end;

begin
    basicList(1);
    함수(1,20);
end;