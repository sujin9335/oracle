

set serveroutput on;
--로그인PL
create or replace procedure login(
    pid in varchar2,
    ppw in varchar2
)
is
    vtype varchar2(30);
    vname varchar2(30);
    pseq vwStudent.번호%type;
    pname vwStudent.이름%type;
    pphon vwStudent.번호%type;
    psub vwStudent.과정명%type;
    pstart vwStudent.과정시작일%type;
    pend vwStudent.과정종료일%type;
    pcr vwStudent.강의실%type;
begin
    vname := pid;
    select basicSeq, logintype into pseq, vtype from tblLogin where id = pid and pw = ppw; 
    
    if vtype = '관리자' then

        dbms_output.put_line('관리자 ' || vname || '님 안녕하세요');
        dbms_output.put_line('1. 기초 정보 관리');
        dbms_output.put_line('2. 교사 계정 관리');
        dbms_output.put_line('3. 개설 과정 관리');
        dbms_output.put_line('4. 교육생 관리');
        dbms_output.put_line('5. 시험 관리 및 성적 조회');
        dbms_output.put_line('6. 출결 관리 및 조회');
    elsif vtype = '교사' then
       
        dbms_output.put_line(pseq || '번 ' || '교사 ' || vname || '님 안녕하세요');
        dbms_output.put_line('1, 강의 스케줄 조회');
        dbms_output.put_line('2. 배점 입출력');
        dbms_output.put_line('3. 성적 입출력');
        dbms_output.put_line('4. 출결 관리 및 출결 조회');
    elsif vtype = '교육생' then 
        
        select 이름, 번호, 과정명, 과정시작일, 과정종료일, 강의실 into pname, pphon, psub, pstart, pend, pcr from vwStudent where 번호 = pseq;
        dbms_output.put_line(psub || ' ' || pseq || '번 교육생 ' || vname || '님 안녕하세요');
        dbms_output.put_line(pcr || ' 강의실' ||' 기간: ' || pstart || '~' || pend);
        dbms_output.put_line('1, 성적 조회');
        dbms_output.put_line('2, 출결 관리 및 출결 조회');

    end if;
exception
    when others then

        dbms_output.put_line('로그인 실패');
end login;
/
-------------------------------------------------------------------

--관리자 상세기능 2-1-? 
create or replace procedure adminSelec(
    pinput in number
)
is
    vnum number;
begin
    vnum := pinput;

    if vnum = 1 then
        dbms_output.put_line('1. 기초 정보 목록');
        dbms_output.put_line('2. 기초 정보 등록');
        dbms_output.put_line('3. 기초 정보 수정');
        dbms_output.put_line('4. 기초 정보 삭제');
    elsif vnum = 2 then
        dbms_output.put_line('1. 교사 정보 목록');
        dbms_output.put_line('2. 교사 정보 등록');
        dbms_output.put_line('3. 교사 정보 수정');
        dbms_output.put_line('4. 교사 정보 삭제');
    elsif vnum = 3 then
        dbms_output.put_line('1. 개설 과정 목록');
        dbms_output.put_line('2. 개설 과목 목록');
        dbms_output.put_line('3. 개설 과정 등록');
        dbms_output.put_line('4. 개설 과정 수정');
        dbms_output.put_line('5. 개설 과정 삭제');
        dbms_output.put_line('6. 개설 과정 수료');
    elsif vnum = 4 then
        dbms_output.put_line('1. 교육생 목록');
        dbms_output.put_line('2. 교육생 등록');
        dbms_output.put_line('3. 교육생 수정');
        dbms_output.put_line('4. 교육생 삭제');
        dbms_output.put_line('5. 교육생 검색');
    elsif vnum = 5 then
        dbms_output.put_line('1. 시험 관리 목록');
        dbms_output.put_line('2. 성적 정보 목록');
    elsif vnum = 6 then
        dbms_output.put_line('1. 특정 과정 출결 조회');
        dbms_output.put_line('2. 특정 인원 출결 조회');
        dbms_output.put_line('3. 기간별 출결 조회');
        dbms_output.put_line('4. 출결 수정 관리');
    else
        dbms_output.put_line('잘못입력 하셨습니다');
    end if;

end adminSelec;
/
-------------------------------------------------------------------

--교사 상세기능 2-2-? 
create or replace procedure teacherSelec(
    pinput in number
)
is
    vnum number;
begin
    vnum := pinput;

    if vnum = 1 then
        dbms_output.put_line('1. 강의 예정');
        dbms_output.put_line('2. 강의 중');
        dbms_output.put_line('3. 강의 종료');
    elsif vnum = 2 then
        dbms_output.put_line('1. 과목 선택(배점 입력)');
    elsif vnum = 3 then
        dbms_output.put_line('1. 과목 선택(성적 입력)');
    elsif vnum = 4 then
        dbms_output.put_line('1. 강의 별 출결 조회');
        dbms_output.put_line('2. 기간 별 출결 조회');
        dbms_output.put_line('3. 과정 별 출결 조회');
        dbms_output.put_line('4. 인원 별 출결 조회');
    else
        dbms_output.put_line('잘못입력 하셨습니다');
    end if;

end teacherSelec;
/


-------------------------------------------------------------------

--교육생 상세기능 2-3-? 
create or replace procedure studentSelec(
    pinput in number
)
is
    vnum number;
begin
    vnum := pinput;

    if vnum = 1 then
        dbms_output.put_line('1. 과목 선택');
    elsif vnum = 2 then
        dbms_output.put_line('1. 근태 기록');
        dbms_output.put_line('2. 기간 별 출결 조회');
    else
        dbms_output.put_line('잘못입력 하셨습니다');
    end if;

end studentSelec;
/
-----------------------------------------------------------------------------관리자
----------------------------------------------------------------------기초정보
-------------------------------------------------------------------

--기초정보 조회 1-2-1
create or replace procedure basicList(
    pinput varchar2
)
is
    vcursor sys_refcursor; --커서 참조 변수
    vrow1 tblclassroom%rowtype;
    vrow2 tblBook%rowtype;
    vrow3 tblSubject%rowtype;
begin


    if pinput = '강의실' then
        open vcursor
        for
        select CLASSROOMNAME, CLASSROOMMAXPEOPLE  from tblclassroom order by CLASSROOMNAME;
        dbms_output.put_line('강의실');
        loop 
            fetch vcursor into vrow1;
            exit when vcursor%notfound;
            dbms_output.put_line('강의실명: ' || vrow1.classroomname);
            dbms_output.put_line('강의실 인원수: ' || vrow1.CLASSROOMMAXPEOPLE || '명');
            dbms_output.put_line('=======================================');
        end loop;
    elsif pinput = '교재' then
        open vcursor
        for
        select bookSeq, bookName, publisher from tblBook order by bookSeq;
        dbms_output.put_line('교재');
        loop 
            fetch vcursor into vrow2;
            exit when vcursor%notfound;
            dbms_output.put_line('번호: ' || vrow2.bookSeq);
            dbms_output.put_line('교재명: ' || vrow2.bookName);
            dbms_output.put_line('출판사명: ' || vrow2.publisher);
            dbms_output.put_line('=======================================');
        end loop;
    elsif pinput = '과목' then
        open vcursor
        for
        select subSeq, subName from tblSubject order by subSeq;
        dbms_output.put_line('과목');
        loop 
            fetch vcursor into vrow3;
            exit when vcursor%notfound;
            dbms_output.put_line('번호: ' || vrow3.subSeq);
            dbms_output.put_line('교재명: ' || vrow3.subName);
            dbms_output.put_line('=======================================');
        end loop;
    else
        dbms_output.put_line('잘못 입력하셨습니다');
    end if;

end basicList;
/
-------------------------------------------------------------------------
create or replace procedure classLoomInsert( --클레스룸 INSERT
    pname tblClassroom.classroomname%type,
    psu tblClassroom.classroomMaxPeople%type
)
is
begin
   insert into tblClassroom values (pname, psu);
end classLoomInsert;
/

-------------------------------------------------------------------------
create or replace procedure classLoomNameUpdate( --클레스룸 이름 수정
    pname tblClassroom.classroomname%type,
    pinput tblClassroom.classroomname%type
)
is
begin
    update tblClassroom set
        classroomname = pinput 
            where classroomname = pname;
end classLoomNameUpdate;
/

-------------------------------------------------------------------------
create or replace procedure classLoomSuUpdate( --클레스룸 인원 수정
    pname tblClassroom.classroomname%type,
    pinput tblClassroom.classroomMaxPeople%type
)
is
begin
    update tblClassroom set
        classroomMaxPeople = pinput 
            where classroomname = pname;
end classLoomSuUpdate;
/
-------------------------------------------------------------------------
create or replace procedure classLoomDelete( --클레스룸 삭제
    pname tblClassroom.classroomname%type
)
is
begin
    DELETE FROM tblClassroom WHERE classroomname = pname;
end classLoomDelete;
/
-------------------------------------------------------------------------
create or replace procedure bookInsert( --교재 INSERT
    pname tblBook.bookname%type,
    ppublisher tblBook.publisher%type
)
is
begin
   insert into tblBook values ((select max(bookseq) from tblBook)+1 ,pname, ppublisher);
end bookInsert;
/
-------------------------------------------------------------------------
create or replace procedure bookNameUpdate( --교재 이름 수정
    pseq tblBook.bookseq%type,
    pinput tblBook.bookname%type
)
is
begin
    update tblBook set
        bookname = pinput 
            where bookseq = pseq;
end bookNameUpdate;
/
-------------------------------------------------------------------------
create or replace procedure bookPublisherUpdate( --교재 출판사 수정
    pseq tblBook.bookseq%type,
    pinput tblBook.publisher%type
)
is
begin
    update tblBook set
        publisher = pinput 
            where bookseq = pseq;
end bookPublisherUpdate;
/
-------------------------------------------------------------------------
create or replace procedure bookDelete( --교재 삭제
    pseq tblBook.bookseq%type
)
is
begin
    DELETE FROM tblBook WHERE bookseq = pseq;
end bookDelete;
/
-------------------------------------------------------------------------
create or replace procedure subInsert( --과목 INSERT
    pname tblSubject.subname%type
)
is
begin
   insert into tblSubject values ((select max(subseq) from tblSubject)+1 ,pname);
end subInsert;
/
-------------------------------------------------------------------------
create or replace procedure subNameUpdate( --과목 이름 수정
    pseq tblSubject.subseq%type,
    pinput tblSubject.subname%type
)
is
begin
    update tblSubject set
        subname = pinput 
            where subseq = pseq;
end subNameUpdate;
/
-------------------------------------------------------------------------
create or replace procedure subDelete( --교재 삭제
    pseq tblSubject.subseq%type
)
is
begin
    DELETE FROM tblSubject WHERE subseq = pseq;
end subDelete;
/

----------------------------------------------------------------------교사계정정보
CREATE OR REPLACE PROCEDURE GetTeacherSubjects AS
BEGIN
    FOR teacher_rec IN (
        SELECT t.name AS "교사 이름",
               t.ssn AS "주민번호 뒷자리",
               t.tel AS "전화번호",
               s.subName AS "강의 가능 과목"
        FROM tblTeacher t
        LEFT OUTER JOIN tblAvailableSubject a ON t.teacherSeq = a.teacherSeq
        LEFT OUTER JOIN tblSubject s ON a.subSeq = s.subSeq
        ORDER BY t.name
    ) LOOP
        BEGIN
            DBMS_OUTPUT.PUT_LINE('교사 이름: ' || teacher_rec."교사 이름");
            DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || teacher_rec."주민번호 뒷자리");
            DBMS_OUTPUT.PUT_LINE('전화번호: ' || teacher_rec."전화번호");
            DBMS_OUTPUT.PUT_LINE('강의 가능 과목: ' || teacher_rec."강의 가능 과목");
            DBMS_OUTPUT.PUT_LINE('------------------------------------');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('교사 정보가 존재하지 않습니다.');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
        END;
    END LOOP;
END GetTeacherSubjects;
/


----------------------------------교사정보+교사가능 수업 출력
CREATE OR REPLACE PROCEDURE InsertAvailableSubject(
    p_teacherSeq IN NUMBER,
    p_subName IN VARCHAR2
)
IS
    v_maxAsSeq NUMBER;
    v_subSeq NUMBER;
BEGIN
    -- 강의 가능 과목 테이블에서 가장 큰 asSeq 값을 찾습니다.
    SELECT COALESCE(MAX(asseq), 0) + 1 INTO v_maxAsSeq FROM tblavailablesubject;
    
    -- 과목명을 사용하여 해당 과목의 subSeq 값을 찾습니다.
    SELECT subSeq INTO v_subSeq FROM tblSubject WHERE subName = p_subName;

    -- 강의 가능 과목을 추가합니다.
    INSERT INTO tblAvailableSubject (asSeq, teacherSeq, subSeq)
    VALUES (v_maxAsSeq, p_teacherSeq, v_subSeq);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('강의 가능 과목이 추가되었습니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('과목 정보가 존재하지 않습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END InsertAvailableSubject;
/
----------------------------------교사정보 insert
CREATE OR REPLACE PROCEDURE INSERT_TEACHER (
    p_name IN tblTeacher.name%TYPE,
    p_ssn IN tblTeacher.ssn%TYPE,
    p_tel IN tblTeacher.tel%TYPE
)
AS
BEGIN
    DECLARE
        v_max_teacher_seq NUMBER;
    BEGIN
        SELECT MAX(teacherSeq) + 1 INTO v_max_teacher_seq FROM tblTeacher;
        
        INSERT INTO tblTeacher (teacherSeq, name, ssn, tel)
        VALUES (v_max_teacher_seq, p_name, p_ssn, p_tel);
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('교사 정보 등록 완료');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
    END;
END INSERT_TEACHER;
/
----------------------------------교사 강의가능 목록insert
CREATE OR REPLACE PROCEDURE InsertAvailableSubject(
    p_teacherSeq IN NUMBER,
    p_subName IN VARCHAR2
)
IS
    v_maxAsSeq NUMBER;
    v_subSeq NUMBER;
BEGIN
    -- 강의 가능 과목 테이블에서 가장 큰 asSeq 값을 찾습니다.
    SELECT COALESCE(MAX(asseq), 0) + 1 INTO v_maxAsSeq FROM tblavailablesubject;
    
    -- 과목명을 사용하여 해당 과목의 subSeq 값을 찾습니다.
    SELECT subSeq INTO v_subSeq FROM tblSubject WHERE subName = p_subName;

    -- 강의 가능 과목을 추가합니다.
    INSERT INTO tblAvailableSubject (asSeq, teacherSeq, subSeq)
    VALUES (v_maxAsSeq, p_teacherSeq, v_subSeq);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('강의 가능 과목이 추가되었습니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('과목 정보가 존재하지 않습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END InsertAvailableSubject;
/
----------------------------------교사 정보 수정
CREATE OR REPLACE PROCEDURE UpdateTeacherInfo(
    p_teacherSeq IN NUMBER,
    p_name IN VARCHAR2,
    p_ssn IN VARCHAR2,
    p_tel IN VARCHAR2
)
IS
BEGIN
    -- 기존 교사의 정보를 새로운 정보로 업데이트합니다.
    UPDATE tblTeacher
      SET
        name = p_name,
        ssn = p_ssn,
        tel = p_tel
    WHERE
        teacherSeq = p_teacherSeq;

    DBMS_OUTPUT.PUT_LINE('교사 정보가 업데이트되었습니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('교사 정보가 존재하지 않습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END UpdateTeacherInfo;
/
----------------------------------교사 정보 삭제
CREATE OR REPLACE PROCEDURE DeleteTeacher(
    p_teacherSeq IN NUMBER
)
IS
BEGIN
    -- 해당 교사의 강의 가능 과목 정보를 먼저 삭제합니다.
    DELETE FROM tblAvailableSubject
    WHERE teacherSeq = p_teacherSeq;

    -- 교사를 삭제합니다.
    DELETE FROM tblTeacher
    WHERE teacherSeq = p_teacherSeq;

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('교사 정보가 삭제되었습니다.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('교사 정보가 존재하지 않습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END DeleteTeacher;
/
----------------------------------------------------------------------개설과정관리
----------------------------------전체과정 목록
CREATE OR REPLACE PROCEDURE procCourseList IS
BEGIN
    FOR c IN (
        SELECT *
        FROM vwCourseList
        ORDER BY "과정번호"
    ) LOOP
        -- 결과를 출력
        DBMS_OUTPUT.PUT_LINE('과정번호: ' || c."과정번호");
        DBMS_OUTPUT.PUT_LINE('과정명: ' || c."과정명");
        DBMS_OUTPUT.PUT_LINE('개설과정시작일: ' || c."개설과정시작일");
        DBMS_OUTPUT.PUT_LINE('개설과정종료일: ' || c."개설과정종료일");
        DBMS_OUTPUT.PUT_LINE('강의실명: ' || c."강의실명");
        DBMS_OUTPUT.PUT_LINE('과목등록여부: ' || c."과목등록여부");
        DBMS_OUTPUT.PUT_LINE('교육생인원수: ' || c."교육생인원수");
        DBMS_OUTPUT.PUT_LINE('=======================================');
    END LOOP;
END;
/
----------------------------------전체과정 목록-선택 등록여부 정보출력
CREATE OR REPLACE PROCEDURE procCourseSearch (
    pcourseSeq IN NUMBER
) AS    
    vsubjectRegistrationStatus VARCHAR2(1);
BEGIN
    -- SubjectRegistrationStatus 값을 조회
    BEGIN
        -- "과정번호"를 사용하여 SubjectRegistrationStatus 값을 조회
        SELECT "과목등록여부"
        INTO vsubjectRegistrationStatus
        FROM vwCourseList
        WHERE "과정번호" = pcourseSeq; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('과정을 찾을 수 없습니다.');
            RETURN;
    END;

    -- SubjectRegistrationStatus 값에 따라 분기
    IF vSubjectRegistrationStatus = 'Y' THEN
        -- subjectRegistrationStatus가 'Y'인 경우에만 아래 쿼리 실행
        FOR cus IN (
            SELECT           
                (SELECT subName FROM tblSubject sj WHERE sl.subSeq = sj.subSeq) AS "과목명",
                TO_CHAR(sl.subjectStartDate, 'yyyy-mm-dd') AS "과목시작일자",
                TO_CHAR(sl.subjectFinishDate, 'yyyy-mm-dd') AS "과목종료일자",
                (SELECT bookName FROM tblBook b WHERE sl.bookSeq = b.bookSeq) AS "교재명",
                (SELECT name FROM tblTeacher t WHERE sl.teacherSeq = t.teacherSeq) AS "교사명",
                st.name AS "교육생이름",
                st.ssn AS "주민번호 뒷자리",
                st.phone AS "핸드폰번호",
                TO_CHAR(st.registerDate, 'yyyy-mm-dd') AS "등록일",
                st.applicationClass AS "수강신청횟수",
                TO_CHAR(st.complDropDate, 'yyyy-mm-dd') AS "수료일또는중도탈락일",
                st.complDropStatus AS "수료및중도탈락여부"
            FROM tblcourse cu
            LEFT JOIN tblSubjectList sl
            ON cu.courseSeq = sl.courseSeq        
            LEFT JOIN tblStudent st
            ON sl.courseSeq = st.processSeq   
            WHERE cu.courseSeq = pcourseSeq                           
            ORDER BY cu.courseSeq
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('과목명: ' || cus."과목명");
            DBMS_OUTPUT.PUT_LINE('과목시작일자: ' || cus."과목시작일자");
            DBMS_OUTPUT.PUT_LINE('과목종료일자: ' || cus."과목종료일자");
            DBMS_OUTPUT.PUT_LINE('교재명: ' || cus."교재명");
            DBMS_OUTPUT.PUT_LINE('교사명: ' || cus."교사명");
            DBMS_OUTPUT.PUT_LINE('교육생이름: ' || cus."교육생이름");
            DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || cus."주민번호 뒷자리");
            DBMS_OUTPUT.PUT_LINE('핸드폰번호: ' || cus."핸드폰번호");
            DBMS_OUTPUT.PUT_LINE('등록일: ' || cus."등록일");
            DBMS_OUTPUT.PUT_LINE('수강신청횟수: ' || cus."수강신청횟수");
            DBMS_OUTPUT.PUT_LINE('수료일또는중도탈락일: ' || cus."수료일또는중도탈락일");
            DBMS_OUTPUT.PUT_LINE('수료및중도탈락여부: ' || cus."수료및중도탈락여부");
            DBMS_OUTPUT.PUT_LINE('---------------------------------------------------'); 
        END LOOP;
    ELSIF vSubjectRegistrationStatus = 'N' THEN
       
        DBMS_OUTPUT.PUT_LINE('과목등록이 필요합니다.');       
    ELSE
        DBMS_OUTPUT.PUT_LINE('올바르지 않은 subjectRegistrationStatus 값입니다.');
    END IF;
END procCourseSearch;
/
----------------------------------등록여부 N - 개설과목 등록
create or replace PROCEDURE procShowAllBook
AS
BEGIN
    -- 모든 교재 정보를 출력
    FOR bookInfo IN (SELECT * FROM tblBook)
    LOOP
        DBMS_OUTPUT.PUT_LINE('교재번호: ' || bookInfo.bookSeq || ', 교재명: ' || bookInfo.bookName);
    END LOOP;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('오류: 해당 교재 번호에 대한 교재 정보를 찾을 수 없습니다.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END procShowAllBook;
/

--3-0. 입력받은 과목 현재 강의 가능한 교사목록

create or replace PROCEDURE procGetTeacherInfoForSubject(
    pSubSeq IN tblSubject.subSeq%TYPE
) IS
    vTeacherSeq tblTeacher.teacherSeq%TYPE;
    vTeacherName tblTeacher.name%TYPE;
BEGIN
    -- 과목번호로 해당 과목에 가능한 강사 목록 검색
    FOR teacherInfo IN (
        SELECT DISTINCT t.teacherSeq, t.name
        FROM tblTeacher t
        JOIN tblAvailableSubject a ON t.teacherSeq = a.teacherSeq
        WHERE a.subSeq = pSubSeq
    ) LOOP
        vTeacherSeq := teacherInfo.teacherSeq;
        vTeacherName := teacherInfo.name;
        DBMS_OUTPUT.PUT_LINE('강사 번호: ' || vTeacherSeq);
        DBMS_OUTPUT.PUT_LINE('강사 이름: ' || vTeacherName);
    END LOOP;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('오류: 해당 과목에 대한 강의 가능한 강사 정보를 찾을 수 없습니다.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
END procGetTeacherInfoForSubject;
/
--3. 신규 개설 과목 등록
drop procedure procInsertSubject;
commit;

CREATE OR REPLACE PROCEDURE procInsertSubject (
    vCourseSeq IN tblSubjectlist.courseSeq%TYPE,
    vStartDate IN DATE,
    vEndDate IN DATE,
    vSubjectSeq IN tblSubject.subSeq%TYPE,
    vBookSeq IN tblBook.bookSeq%TYPE,
    vTeacherSeq IN tblTeacher.teacherSeq%TYPE 
) IS
    vSubjectListSeq tblSubjectList.subjectListSeq%TYPE;
    vCurrentDate DATE := SYSDATE;
BEGIN
 
    DBMS_OUTPUT.PUT_LINE('과정 번호: ' || vCourseSeq);
    DBMS_OUTPUT.PUT_LINE('과목 시작일자: ' || TO_CHAR(vStartDate, 'yyyy-mm-dd'));
    DBMS_OUTPUT.PUT_LINE('과목 종료일자: ' || TO_CHAR(vEndDate, 'yyyy-mm-dd'));
    DBMS_OUTPUT.PUT_LINE('과목 번호: ' || vSubjectSeq);
    
    -- 과목 목록 번호 설정 (마지막 번호에 1 추가)
    SELECT NVL(MAX(subjectListSeq), 0) + 1 INTO vSubjectListSeq FROM tblSubjectList;

    -- 과목 시작일자가 현재 날짜 이후인지 확인
    IF vStartDate <= vCurrentDate THEN
        DBMS_OUTPUT.PUT_LINE('오류: 과목 시작일자는 현재 날짜 이후여야 합니다.');
        RETURN;
    END IF;
    
    -- 과목 종료일자가 현재 날짜 이후인지 확인
    IF vEndDate <= vCurrentDate THEN
        DBMS_OUTPUT.PUT_LINE('오류: 과목 종료일자는 현재 날짜 이후여야 합니다.');
        RETURN;
    END IF;
    
    -- 교재 목록
    DBMS_OUTPUT.PUT_LINE('-----교재목록---------');
    procShowAllBook; -- 교재 목록 보여주기
    DBMS_OUTPUT.PUT_LINE('-------------------');

    
    DBMS_OUTPUT.PUT_LINE('-----교사목록-------');
    procGetTeacherInfoForSubject(vSubjectSeq);
    DBMS_OUTPUT.PUT_LINE('-------------------');
    
    -- 선택한 정보로 신규 과목 등록
    INSERT INTO tblSubjectList (subjectListSeq, courseSeq, subSeq, subjectStartDate, subjectFinishDate, bookSeq, teacherSeq)
    VALUES (vSubjectListSeq, vCourseSeq, vSubjectSeq, vStartDate, vEndDate, vBookSeq, vTeacherSeq);

    COMMIT;   

    DBMS_OUTPUT.PUT_LINE('신규 과목 등록이 완료되었습니다.');
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('오류: 해당 정보로 등록할 수 없습니다.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('오류: ' || SQLERRM);
            ROLLBACK;
END procInsertSubject;
/

----------------------------------등록여부 Y - 수정
CREATE OR REPLACE PROCEDURE procUpdateSubCourse(
    pCourseSeq IN NUMBER,
    pSubSeq IN NUMBER,
    pNewSubSeq IN NUMBER
) AS
    vSubExists NUMBER;
BEGIN
      -- 선택한 과정(pcourseSeq)의 특정 과목(psubSeq)이 tblsubject 테이블에 있는지 확인
    SELECT subSeq
    INTO vSubExists
    FROM tblSubject
    WHERE subSeq = pNewSubSeq;

    -- 만약 해당 과목이 존재하지 않으면 오류 처리
    IF vSubExists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('입력한 과목 번호가 존재하지 않습니다. 과목번호를 확인해주세요.');
        RETURN;
    END IF;

    -- 선택한 과정(pcourseSeq)의 특정 과목(psubSeq)을 새로운 과목(pnewSubtSeq)으로 변경
    UPDATE tblSubjectList
     SET subSeq = pNewSubSeq
    WHERE courseSeq = pCourseSeq
      AND subSeq = pSubSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('과목이 수정되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pcourseSeq);
    DBMS_OUTPUT.PUT_LINE('변경 된 과목번호: ' || pnewSubSeq);
EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과목 수정 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/
----------------------------------등록여부 Y - 삭제
CREATE OR REPLACE PROCEDURE procDeleteSubjectList(
    pSubjectListSeq NUMBER
) IS
    vRowCount NUMBER;
BEGIN
    -- 입력한 번호가 과목 목록에 있는지 확인
    SELECT COUNT(*)
    INTO vRowCount
    FROM tblSubjectList
    WHERE subjectListSeq = pSubjectListSeq;

    IF vRowCount = 0 THEN
        -- 입력한 번호가 과목 목록에 없으면 오류 처리
        DBMS_OUTPUT.PUT_LINE('입력한 번호가 과목 목록에 존재하지 않습니다. 삭제가 불가능합니다.');
    ELSE
        -- 입력한 번호에 해당하는 과목 목록 삭제
        DELETE FROM tblSubjectList
        WHERE subjectListSeq = pSubjectListSeq;
        
        commit;
        
        DBMS_OUTPUT.PUT_LINE('과목 목록 번호 ' || pSubjectListSeq || '가 삭제되었습니다.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과목 목록 삭제 중 오류가 발생했습니다.');
END;
/
----------------------------------과목 목록출력
CREATE OR REPLACE PROCEDURE procGetAllCourseInfo AS
BEGIN
    FOR cou IN (
        SELECT  
            cu.*,
            (SELECT subName FROM tblSubject sj WHERE sl.subSeq = sj.subSeq) AS "과목명",
            TO_CHAR(sl.subjectStartDate, 'yyyy-mm-dd') AS "과목시작일자",
            TO_CHAR(sl.subjectFinishDate, 'yyyy-mm-dd') AS "과목종료일자",
            (SELECT bookName FROM tblBook b WHERE sl.bookSeq = b.bookSeq) AS "교재명",
            (SELECT name FROM tblTeacher t WHERE sl.teacherSeq = t.teacherSeq) AS "교사명"
        FROM vwCourseList cu
        LEFT JOIN tblSubjectList sl
            ON cu."과정번호" = sl.courseSeq
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('과정번호: ' || cou."과정번호");
        DBMS_OUTPUT.PUT_LINE('과목명: ' || cou."과목명");
        DBMS_OUTPUT.PUT_LINE('과목시작일자: ' || cou."과목시작일자");
        DBMS_OUTPUT.PUT_LINE('과목종료일자: ' || cou."과목종료일자");
        DBMS_OUTPUT.PUT_LINE('교재명: ' || cou."교재명");
        DBMS_OUTPUT.PUT_LINE('교사명: ' || cou."교사명");
        DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END procGetAllCourseInfo;
/
----------------------------------과정 등록
CREATE OR REPLACE PROCEDURE procInsertCourse(
    pCourseName tblCourse.courseName%TYPE,
    pStartDate tblCourse.courseStartDate%TYPE,
    pFinishDate tblCourse.courseFinishDate%TYPE,
    pClassroomName tblCourse.classroomName%TYPE,
    pSubjectStatus tblCourse.subjectRegistrationStatus%TYPE,
    pStudentNumber in out tblCourse.studentNumber%TYPE
) IS
    vClassroomName NUMBER;
    vClassroomMaxPeople NUMBER;
BEGIN
    -- 강의실명이 tblclassroom 테이블에 있는지 확인
    SELECT classroomName, classroomMaxPeople
    INTO vclassroomName, vclassroomMaxPeople
    FROM tblClassroom
    WHERE classroomName = pClassroomName;

    -- 강의실명이 없으면 오류 발생
    IF vclassroomName= 0 THEN
        DBMS_OUTPUT.PUT_LINE('오류: 입력한 강의실명이 tblclassroom에 존재하지 않습니다.');
        RETURN;
    END IF;

    -- 개설과정 시작일과 종료일이 현재 날짜 이후인지 확인
    IF pStartDate <= SYSDATE OR pFinishDate <= SYSDATE THEN
        DBMS_OUTPUT.PUT_LINE('오류: 개설과정 시작일과 종료일은 현재 날짜 이후로만 설정 가능합니다.');
        RETURN;
    END IF;

    -- 강의실에 따라 교육생 인원수 설정
    IF pClassroomName IN ('1', '2', '3') THEN
        pStudentNumber := 30;
    ELSIF pClassroomName IN ('4', '5', '6') THEN
        pStudentNumber := 26;
    ELSE
        DBMS_OUTPUT.PUT_LINE('오류: 올바른 강의실명을 입력해주세요.');
        RETURN;
    END IF;

    -- 과정 추가
    INSERT INTO tblCourse(courseSeq, courseName, courseStartDate, courseFinishDate, classroomName, subjectRegistrationStatus, studentNumber)
    VALUES (course_seq.nextval, pCourseName, pStartDate, pFinishDate, pClassroomName, pSubjectStatus, pStudentNumber);

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('새로 등록된 과정 정보');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || course_seq.currval);
    DBMS_OUTPUT.PUT_LINE('과정명: ' || pCourseName);
    DBMS_OUTPUT.PUT_LINE('개설과정시작일: ' || TO_CHAR(pStartDate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('개설과정종료일: ' || TO_CHAR(pFinishDate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('강의실명: ' || pClassroomName);
    DBMS_OUTPUT.PUT_LINE('과목등록여부: ' || pSubjectStatus);
    DBMS_OUTPUT.PUT_LINE('교육생인원수: ' || pStudentNumber);
    DBMS_OUTPUT.PUT_LINE('과정이 성공적으로 추가되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과정 추가 중 오류가 발생했습니다.');
END;
/
----------------------------------과정 수정 - 번호
CREATE OR REPLACE PROCEDURE procUpdateCourseSeq(
    pCurrentCourseSeq NUMBER,
    pNewCourseSeq NUMBER
) IS
    vCourseExists NUMBER;
BEGIN
      -- 수정하려는 과목번호가 있는지 확인
    SELECT courseSeq
    INTO vCourseExists
    FROM tblcourse
    WHERE courseSeq = pNewCourseSeq;

    -- 만약 해당 과목이 존재하지 않으면 오류 처리
    IF vCourseExists = 0 THEN
        DBMS_OUTPUT.PUT_LINE('입력한 과목 번호가 존재하지 않습니다. 과목번호를 확인해주세요.');
        RETURN;
    END IF;
    
    UPDATE tblCourse
    SET courseSeq = pNewCourseSeq
    WHERE courseSeq = pCurrentCourseSeq;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('과정 번호 ' || pCurrentCourseSeq || '가 ' || pNewCourseSeq || '로 수정되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과정 번호 수정 중 오류가 발생했습니다.');
END;
/
----------------------------------과정 수정 - 시작일
CREATE OR REPLACE PROCEDURE procUpdateCourseStartDate(
    pCourseSeq IN NUMBER,
    pNewStartDate IN DATE
) AS
    vCurrentDate DATE := SYSDATE;  -- 현재 날짜 가져오기
BEGIN
    -- 현재 날짜 이후인지 확인
    IF pNewStartDate <= vCurrentDate THEN
        DBMS_OUTPUT.PUT_LINE('과정 시작일은 현재 날짜 이후로만 수정 가능합니다.');
        RETURN;  -- 업데이트 거부
    END IF;

    -- 과정 시작일 업데이트
    UPDATE tblCourse
    SET courseStartDate = pNewStartDate
    WHERE courseSeq = pCourseSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('과정 시작일이 수정되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pCourseSeq);
    DBMS_OUTPUT.PUT_LINE('새로운 시작일: ' || TO_CHAR(pNewStartDate, 'YYYY-MM-DD'));
EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과정 시작일 수정 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/
----------------------------------과정 수정 - 종료일
CREATE OR REPLACE PROCEDURE procUpdateCourseFinishDate(
    pCourseSeq IN NUMBER,
    pNewFinishDate IN DATE
) AS
    vCurrentDate DATE := SYSDATE;  -- 현재 날짜 가져오기
BEGIN
    -- 현재 날짜 이후인지 확인
    IF pNewFinishDate <= vCurrentDate THEN
        DBMS_OUTPUT.PUT_LINE('과정 종료일은 현재 날짜 이후로만 수정 가능합니다.');
        RETURN; 
    END IF;

    -- 과정 종료일 업데이트
    UPDATE tblCourse
    SET courseFinishDate = pNewFinishDate
    WHERE courseSeq = pCourseSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('과정 종료일이 수정되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pCourseSeq);
    DBMS_OUTPUT.PUT_LINE('새로운 종료일: ' || TO_CHAR(pNewFinishDate, 'YYYY-MM-DD'));
EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과정 종료일 수정 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/
----------------------------------과정 수정 - 강의실명
CREATE OR REPLACE PROCEDURE procUpdateCuClassroomName(
    pCourseSeq IN NUMBER,
    pNewClassroomName IN VARCHAR2
) AS
    vClassroomName NUMBER;
BEGIN
    -- 새로운 강의실명(pNewClassroomName)이 tblclassroom 테이블에 있는지 확인
    SELECT classroomName INTO vClassroomName
    FROM tblclassroom
    WHERE classroomName = pNewClassroomName;

    -- 만약 새로운 강의실명이 tblclassroom 테이블에 없으면 오류 발생
    IF vClassroomName = 0 THEN
        DBMS_OUTPUT.PUT_LINE('오류: 새로운 강의실명이 tblclassroom에 존재하지 않습니다.');
        RETURN;
    END IF;

    -- tblCourse 테이블의 강의실명 업데이트
    UPDATE tblCourse
    SET classroomName = pNewClassroomName
    WHERE courseSeq = pCourseSeq;

    COMMIT;

    DBMS_OUTPUT.PUT_LINE('강의실명이 수정되었습니다.');
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pCourseSeq);
    DBMS_OUTPUT.PUT_LINE('새로운 강의실명: ' || pNewClassroomName);
EXCEPTION
     WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('강의실명 수정 중 오류가 발생했습니다.');
        DBMS_OUTPUT.PUT_LINE('오류 메시지: ' || SQLERRM);
END;
/
----------------------------------과정 삭제
CREATE OR REPLACE PROCEDURE procDeleteCourse(
    pcourseSeq NUMBER
) IS
    vCourseCount NUMBER;
BEGIN
    SELECT courseSeq
    INTO vCourseCount
    FROM tblCourse
    WHERE courseSeq = pcourseSeq;
    
     -- 과정 번호가 없으면 오류 발생
    IF vCourseCount = 0 THEN
        DBMS_OUTPUT.PUT_LINE('오류: 입력한 과정 번호가 존재하지 않습니다.');
        RETURN;
    END IF;
    
    -- 과정 삭제
    DELETE FROM tblCourse
    WHERE courseSeq = pcourseSeq;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('과정 번호 ' || pcourseSeq || '이(가) 삭제되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('과정 삭제 중 오류가 발생했습니다.');
END;
/
----------------------------------과정수료
CREATE OR REPLACE PROCEDURE procUpdateCompletionStatus
AS
BEGIN
    UPDATE tblStudent s
    SET s.complDropDate = SYSDATE,
        s.complDropStatus = '수료'
    WHERE EXISTS (
        SELECT 1
        FROM tblcourse c
        WHERE s.processSeq = c.courseSeq
        AND c.courseFinishDate <= SYSDATE
    )
    AND s.complDropDate IS NULL;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('수료 상태가 업데이트되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('업데이트 중 오류가 발생했습니다.');
END;
/

----------------------------------------------------------------------교육생관리
----------------------------------교육생 목록
CREATE OR REPLACE PROCEDURE allStudentSelect(
    pseq OUT TBLSTUDENT.STUDENTSEQ%TYPE,
    pname OUT TBLSTUDENT.NAME%TYPE,
    pssn OUT TBLSTUDENT.SSN%TYPE,
    pphone OUT TBLSTUDENT.PHONE%TYPE,
    preg OUT TBLSTUDENT.REGISTERDATE%TYPE,
    papp OUT TBLSTUDENT.APPLICATIONCLASS%TYPE,
    ppro OUT TBLSTUDENT.PROCESSSEQ%TYPE,
    pdate OUT TBLSTUDENT.COMPLDROPDATE%TYPE,
    pstatus OUT TBLSTUDENT.COMPLDROPSTATUS%TYPE
)
    IS
    CURSOR student_cursor IS
        SELECT STUDENTSEQ, NAME, SSN, PHONE, REGISTERDATE, APPLICATIONCLASS, PROCESSSEQ, COMPLDROPDATE, COMPLDROPSTATUS
        FROM TBLSTUDENT;
BEGIN
    OPEN student_cursor;
    LOOP
        FETCH student_cursor INTO pseq, pname, pssn, pphone, preg, papp, ppro, pdate, pstatus;
        EXIT WHEN student_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
        DBMS_OUTPUT.PUT_LINE('번호 : ' || pseq);
        DBMS_OUTPUT.PUT_LINE('교육생  : ' || pname);
        DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리 : ' || pssn);
        DBMS_OUTPUT.PUT_LINE('휴대폰 번호 : ' || pphone);
        DBMS_OUTPUT.PUT_LINE('등록일: ' || preg);
        DBMS_OUTPUT.PUT_LINE('수강신청횟수 : ' || papp);
        DBMS_OUTPUT.PUT_LINE('과정번호 : ' || ppro);
        DBMS_OUTPUT.PUT_LINE('수료일 및 중도탈락 날짜 : ' || pdate);
        DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락여부 : ' || pstatus);
        DBMS_OUTPUT.PUT_LINE('————————————————');
    END LOOP;
    CLOSE student_cursor;
END allStudentSelect;
/
----------------------------------교육생 선택 출력
CREATE OR REPLACE PROCEDURE GetStudentCourseInfo(
    p_student_name IN VARCHAR2
)
    IS
BEGIN
    FOR course_rec IN (
        SELECT
            c.COURSENAME AS 과정명,
            c.COURSESTARTDATE AS 시작일자,
            c.COURSEFINISHDATE AS 종료일자,
            c.CLASSROOMNAME AS 강의실,
            s.COMPLDROPDATE AS 수료일,
            s.COMPLDROPSTATUS AS 중도탈락여부
        FROM TBLSTUDENT s
                 INNER JOIN TBLCOURSE c ON s.PROCESSSEQ = c.COURSESEQ
                 INNER JOIN TBLSUBJECTLIST j ON c.COURSESEQ = j.SUBJECTLISTSEQ
        WHERE s.NAME = p_student_name
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('과정명: ' || course_rec.과정명);
            DBMS_OUTPUT.PUT_LINE('시작일자: ' || TO_CHAR(course_rec.시작일자, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('종료일자: ' || TO_CHAR(course_rec.종료일자, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('강의실: ' || course_rec.강의실);
            DBMS_OUTPUT.PUT_LINE('수료일: ' || TO_CHAR(course_rec.수료일, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('중도탈락여부: ' || course_rec.중도탈락여부);
            DBMS_OUTPUT.PUT_LINE('--------------------------');
        END LOOP;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 교육생의 개설 과정 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END GetStudentCourseInfo;
/
----------------------------------교육생 등록
CREATE OR REPLACE PROCEDURE INSERT_STUDENT (   -- 교육생 등록 프로시저
    pname VARCHAR2,
    pjumin NUMBER,
    pphone VARCHAR2,
    pcourse_number NUMBER,
    pregistration_date DATE DEFAULT trunc(SYSDATE),
    pcompletion_date DATE DEFAULT NULL,
    pcompletion_status VARCHAR2 DEFAULT NULL
) AS
BEGIN
    INSERT INTO TBLSTUDENT
    VALUES (
               (SELECT MAX(STUDENTSEQ) + 1 FROM TBLSTUDENT),
               pname,
               pjumin,
               pphone,
               pregistration_date,
               1,
               pcourse_number,
               pcompletion_date,
               pcompletion_status
           );
    COMMIT;
END INSERT_STUDENT;
/
----------------------------------교육생 수정
CREATE OR REPLACE PROCEDURE UPDATE_STUDENT (   -- 교육생 수정 프로시저
    pstudent_id NUMBER,
    pname VARCHAR2,
    pjumin NUMBER,
    pphone VARCHAR2,
    pregistration_date DATE,
    pcourse_number NUMBER,
    pcompletion_date DATE,
    pcompletion_status VARCHAR2
) AS
BEGIN
    UPDATE TBLSTUDENT
    SET
        NAME = pname,
        SSN = pjumin,
        PHONE = pphone,
        REGISTERDATE = pregistration_date,
        APPLICATIONCLASS = pcourse_number,
        COMPLDROPDATE = pcompletion_date,
        COMPLDROPSTATUS = pcompletion_status
    WHERE STUDENTSEQ = pstudent_id;

    COMMIT;
END UPDATE_STUDENT;
/
----------------------------------교육생 삭제
CREATE OR REPLACE PROCEDURE DELETE_STUDENT (  -- 교육생 삭제 프로시저
    p_student_id NUMBER
) AS
BEGIN
    DELETE FROM TBLSTUDENT
    WHERE STUDENTSEQ = p_student_id;

    COMMIT;
END DELETE_STUDENT;
/
----------------------------------교육생 이름검색
CREATE OR REPLACE PROCEDURE GetStudentInfo(  -- 교육생 검색
    pstudent_id IN NUMBER,
    pstudent_name OUT TBLSTUDENT.NAME%TYPE,
    pjumin_no_last4 OUT TBLSTUDENT.ssn%TYPE,
    pphone_number OUT TBLSTUDENT.PHONE%TYPE,
    pregistration_date OUT TBLSTUDENT.REGISTERDATE%TYPE,
    pcourse_count OUT TBLSTUDENT.COMPLDROPSTATUS%TYPE
)
    IS
BEGIN

    SELECT name, ssn, phone, registerdate, compldropstatus
    INTO pstudent_name, pjumin_no_last4, pphone_number, pregistration_date, pcourse_count
    FROM TBLSTUDENT
    WHERE STUDENTSEQ = pstudent_id;

    -- 결과를 출력합니다.
    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pstudent_name);
    DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || pjumin_no_last4);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || pphone_number);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(pregistration_date, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수강 횟수: ' || pcourse_count);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 student_id에 대한 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END GetStudentInfo;
/


----------------------------------------------------------------------시험관리조회
----------------------------------개설과정 선택
CREATE OR REPLACE PROCEDURE GetCourseSubjectsInfo (
    p_courseSeq IN NUMBER
) IS
BEGIN
    FOR subject_rec IN (
        SELECT
            c.courseName AS "과정명",
            sl.subjectListSeq AS "과목번호",
            s.subName AS "과목명",
            CASE
                WHEN st.writtenTestScoreReg = 'Y' THEN '성적등록'
                ELSE '성적미등록'
            END AS "성적등록여부",
            CASE
                WHEN st.writtenTestFileReg = 'Y' THEN '시험문제등록'
                ELSE '시험문제미등록'
            END AS "시험문제등록여부"
        FROM
            tblCourse c
        INNER JOIN
            tblSubjectList sl ON c.courseSeq = sl.courseSeq
        INNER JOIN
            tblScoreTest st ON sl.subjectListSeq = st.subjectListSeq
        INNER JOIN
            tblSubject s ON sl.subSeq = s.subSeq
        WHERE
            c.courseSeq = p_courseSeq
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('과정명: ' || subject_rec."과정명");
        DBMS_OUTPUT.PUT_LINE('과목번호: ' || subject_rec."과목번호");
        DBMS_OUTPUT.PUT_LINE('과목명: ' || subject_rec."과목명");
        DBMS_OUTPUT.PUT_LINE('성적등록여부: ' || subject_rec."성적등록여부");
        DBMS_OUTPUT.PUT_LINE('시험문제등록여부: ' || subject_rec."시험문제등록여부");
        DBMS_OUTPUT.PUT_LINE('---------------------------------');
    END LOOP;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('오류 발생: ' || SQLERRM);
END;
/
----------------------------------개설과정명 목록출력
CREATE OR REPLACE PROCEDURE get_subject_scores (
    p_selected_courseSeq NUMBER,
    p_selected_subSeq NUMBER
) AS
BEGIN
    FOR rec IN (
        SELECT
            c.courseName AS course_name,
            TO_CHAR(c.courseStartDate, 'YYYY-MM-DD') || ' ~ ' || TO_CHAR(c.courseFinishDate, 'YYYY-MM-DD') AS course_period,
            c.classroomName AS classroom_name,
            s.subName AS subject_name,
            t.name AS teacher_name,
            b.bookName AS book_name,
            st.name AS student_name,
            st.ssn AS ssn_suffix,
            si.attendanceScore AS attendance_score,
            si.writingScore AS writing_score
        FROM
            tblCourse c
        INNER JOIN
            tblSubjectList sl ON c.courseSeq = sl.courseSeq
        INNER JOIN
            tblSubject s ON sl.subSeq = s.subSeq
        INNER JOIN
            tblTeacher t ON sl.teacherSeq = t.teacherSeq
        INNER JOIN
            tblBook b ON sl.bookSeq = b.bookSeq
        INNER JOIN
            tblScoreInfo si ON sl.subjectListSeq = si.subjectListSeq
        INNER JOIN
            tblStudent st ON si.studentSeq = st.studentSeq
        WHERE
            sl.courseSeq = p_selected_courseSeq
            AND sl.subSeq = p_selected_subSeq
        ORDER BY
            c.courseName,
            s.subName,
            st.name
    ) LOOP
        -- 결과 출력
        DBMS_OUTPUT.PUT_LINE('개설 과정명: ' || rec.course_name);
        DBMS_OUTPUT.PUT_LINE('개설 과정기간: ' || rec.course_period);
        DBMS_OUTPUT.PUT_LINE('강의실명: ' || rec.classroom_name);
        DBMS_OUTPUT.PUT_LINE('개설 과목명: ' || rec.subject_name);
        DBMS_OUTPUT.PUT_LINE('교사명: ' || rec.teacher_name);
        DBMS_OUTPUT.PUT_LINE('교재명: ' || rec.book_name);
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || rec.student_name);
        DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || rec.ssn_suffix);
        DBMS_OUTPUT.PUT_LINE('필기: ' || rec.attendance_score);
        DBMS_OUTPUT.PUT_LINE('실기: ' || rec.writing_score);
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    END LOOP;
END;
/
----------------------------------교육생 개인별 성적목록
CREATE OR REPLACE PROCEDURE GetStudentScores (
    p_student_seq IN NUMBER
)
IS
BEGIN
    FOR r IN (
        SELECT
            st.name AS "교육생 이름",
            st.ssn AS "주민번호 뒷자리",
            c.courseName AS "개설 과정명",
            TO_CHAR(c.courseStartDate, 'YYYY-MM-DD') || ' ~ ' || TO_CHAR(c.courseFinishDate, 'YYYY-MM-DD') AS "개설 과정기간",
            c.classroomName AS "강의실명",
            s.subName AS "개설 과목명",
            TO_CHAR(sl.subjectStartDate, 'YYYY-MM-DD') || ' ~ ' || TO_CHAR(sl.subjectFinishDate, 'YYYY-MM-DD') AS "개설 과목 기간",
            t.name AS "교사명",
            si.attendanceScore AS "필기",
            si.writingScore AS "실기"
        FROM
            tblStudent st
        INNER JOIN
            tblScoreInfo si ON st.studentSeq = si.studentSeq
        INNER JOIN
            tblSubjectList sl ON si.subjectListSeq = sl.subjectListSeq
        INNER JOIN
            tblCourse c ON sl.courseSeq = c.courseSeq
        INNER JOIN
            tblSubject s ON sl.subSeq = s.subSeq
        INNER JOIN
            tblTeacher t ON sl.teacherSeq = t.teacherSeq
        WHERE
            st.studentSeq = p_student_seq
        ORDER BY
            c.courseName,
            s.subseq
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(r."교육생 이름" || ', ' || r."주민번호 뒷자리" || ', ' || r."개설 과정명" || ', ' || r."개설 과정기간" || ', ' || r."강의실명" || ', ' || r."개설 과목명" || ', ' || r."개설 과목 기간" || ', ' || r."교사명" || ', ' || r."필기" || ', ' || r."실기");
    END LOOP;
END GetStudentScores;
/
----------------------------------교육생 이름검색
CREATE OR REPLACE PROCEDURE GetStudentName( -- 이름검색
    pname IN TBLSTUDENT.NAME%TYPE,
    pstudentseq OUT TBLSTUDENT.STUDENTSEQ%TYPE,
    pssn OUT TBLSTUDENT.SSN%TYPE,
    pphone OUT TBLSTUDENT.PHONE%TYPE,
    pregisterdate OUT TBLSTUDENT.REGISTERDATE%TYPE,
    papplicationclass OUT TBLSTUDENT.APPLICATIONCLASS%TYPE,
    pprocessseq OUT TBLSTUDENT.PROCESSSEQ%TYPE,
    pcompldropdate OUT TBLSTUDENT.COMPLDROPDATE%TYPE,
    pcompldropstatus OUT TBLSTUDENT.COMPLDROPSTATUS%TYPE
)
    IS
BEGIN
    SELECT
        STUDENTSEQ,
        SSN,
        PHONE,
        REGISTERDATE,
        APPLICATIONCLASS,
        PROCESSSEQ,
        COMPLDROPDATE,
        COMPLDROPSTATUS
    INTO
        pstudentseq,
        pssn,
        pphone,
        pregisterdate,
        papplicationclass,
        pprocessseq,
        pcompldropdate,
        pcompldropstatus
    FROM
        TBLSTUDENT
    WHERE
            NAME = pname;

    
    DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || pstudentseq);
    DBMS_OUTPUT.PUT_LINE('주민번호: ' || pssn);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || pphone);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(pregisterdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수강신청구분: ' || papplicationclass);
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || pprocessseq);
    DBMS_OUTPUT.PUT_LINE('수료일 및 중도탈락 날짜: ' || TO_CHAR(pcompldropdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락 여부: ' || pcompldropstatus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 이름의 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END;
/
----------------------------------교육생 주민번호검색
CREATE OR REPLACE PROCEDURE GetStudentSsn(  --주민번호검색
    pssn IN TBLSTUDENT.SSN%TYPE
)
    IS
    pname TBLSTUDENT.NAME%TYPE;
    pstudentseq TBLSTUDENT.STUDENTSEQ%TYPE;
    pphone TBLSTUDENT.PHONE%TYPE;
    preg TBLSTUDENT.REGISTERDATE%TYPE;
    papp TBLSTUDENT.APPLICATIONCLASS%TYPE;
    ppro TBLSTUDENT.PROCESSSEQ%TYPE;
    pdate TBLSTUDENT.COMPLDROPDATE%TYPE;
    pstatus TBLSTUDENT.COMPLDROPSTATUS%TYPE;
BEGIN
    SELECT NAME, STUDENTSEQ, PHONE, REGISTERDATE, APPLICATIONCLASS, PROCESSSEQ, COMPLDROPDATE, COMPLDROPSTATUS
    INTO pname, pstudentseq, pphone, preg, papp, ppro, pdate, pstatus
    FROM TBLSTUDENT
    WHERE SSN = pssn;

    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pname);
    DBMS_OUTPUT.PUT_LINE('교육생 번호: ' || pstudentseq);
    DBMS_OUTPUT.PUT_LINE('주민번호: ' || pssn);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || pphone);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(preg, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수강신청횟수: ' || papp);
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || ppro);
    DBMS_OUTPUT.PUT_LINE('수료일 및 중도탈락 날짜: ' || TO_CHAR(pdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락 여부: ' || pstatus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 주민번호의 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END;
/
----------------------------------교육생 폰번호검색
CREATE OR REPLACE PROCEDURE GetStudentPhone(
    pphone IN TBLSTUDENT.PHONE%TYPE
)
    IS
    pname TBLSTUDENT.NAME%TYPE;
    pssn TBLSTUDENT.SSN%TYPE;
    preg TBLSTUDENT.REGISTERDATE%TYPE;
    papp TBLSTUDENT.APPLICATIONCLASS%TYPE;
    ppro TBLSTUDENT.PROCESSSEQ%TYPE;
    pdate TBLSTUDENT.COMPLDROPDATE%TYPE;
    pstatus TBLSTUDENT.COMPLDROPSTATUS%TYPE;
BEGIN
    SELECT NAME, SSN, REGISTERDATE, APPLICATIONCLASS, PROCESSSEQ, COMPLDROPDATE, COMPLDROPSTATUS
    INTO pname, pssn, preg, papp, ppro, pdate, pstatus
    FROM TBLSTUDENT
    WHERE PHONE = pphone;

    DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || pname);
    DBMS_OUTPUT.PUT_LINE('주민번호: ' || pssn);
    DBMS_OUTPUT.PUT_LINE('전화번호: ' || pphone);
    DBMS_OUTPUT.PUT_LINE('등록일: ' || TO_CHAR(preg, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수강신청구분: ' || papp);
    DBMS_OUTPUT.PUT_LINE('과정번호: ' || ppro);
    DBMS_OUTPUT.PUT_LINE('수료일 및 중도탈락 날짜: ' || TO_CHAR(pdate, 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('수료 및 중도탈락 여부: ' || pstatus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('해당 전화번호의 교육생 정보를 찾을 수 없습니다.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류가 발생했습니다: ' || SQLERRM);
END;
/


----------------------------------------------------------------------출결관리조회
----------------------------------개설과정선택 출결조회
CREATE OR REPLACE PROCEDURE get_attendance_info_range (
    p_selected_courseSeq NUMBER,
    p_selected_year NUMBER,
    p_start_month NUMBER,
    p_start_day NUMBER,
    p_end_month NUMBER,
    p_end_day NUMBER
) AS
BEGIN
    FOR rec IN (
        SELECT
            c.courseName AS "개설 과정명",
            TO_CHAR(a.attendanceDate, 'YYYY-MM-DD') AS "출결 날짜",
            st.name AS "교육생 이름",
            SUBSTR(st.ssn, 7) AS "주민번호 뒷자리",
            a.attendanceStatus AS "출결 상태"
        FROM
            tblCourse c
        INNER JOIN
            tblAttendance a ON c.courseSeq = a.courseSeq
        INNER JOIN
            tblStudent st ON a.studentSeq = st.studentSeq
        WHERE
            c.courseSeq = p_selected_courseSeq
            AND TO_CHAR(a.attendanceDate, 'YYYY') = p_selected_year
            AND TO_CHAR(a.attendanceDate, 'MM') = p_start_month
            AND TO_CHAR(a.attendanceDate, 'DD') >= p_start_day
            AND TO_CHAR(a.attendanceDate, 'MM') = p_end_month
            AND TO_CHAR(a.attendanceDate, 'DD') <= p_end_day
        ORDER BY
            c.courseName,
            a.attendanceDate,
            st.name
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('개설 과정명: ' || rec."개설 과정명");
        DBMS_OUTPUT.PUT_LINE('출결 날짜: ' || rec."출결 날짜");
        DBMS_OUTPUT.PUT_LINE('교육생 이름: ' || rec."교육생 이름");
        DBMS_OUTPUT.PUT_LINE('주민번호 뒷자리: ' || rec."주민번호 뒷자리");
        DBMS_OUTPUT.PUT_LINE('출결 상태: ' || rec."출결 상태");
        DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    END LOOP;
END;
/

-----------------------------------------------------------------------------교사
----------------------------------------------------------------------강의스케줄
----------------------------------스케줄 조회
create or replace procedure procGetTeacherSchedule(--1
    pteacherseq in number,
    pcursor out SYS_REFCURSOR
)
is
begin
    open pcursor
    for
    select 
        과목번호, 과정번호, 과정명, 과정시작일, 과정종료일, 강의실, 과목명, 과목시작일, 과목종료일, 교재명, 교육생등록인원, 강의진행여부
    from vwTeacherSchedule
    where 교사번호 = pteacherseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('해당 교사의 스케줄이 없습니다.');  
        
    when others then
    dbms_output.put_line('예외 처리');
end procGetTeacherSchedule;
/
create or replace procedure procGetTeacherName(--2
    pteacherseq number,
    pteachername out varchar2
)
is
begin
    select name into pteachername from tblTeacher where teacherseq = pteacherseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('해당 교사가 없습니다.');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetTeacherName;
/
create or replace procedure procPrintTeacherSchedule(
    pteacherseq number -- 교사번호
)
is
    vcursor sys_refcursor;
    vsubseq tblSubjectList.subseq%type;
    vcourseseq tblSubjectList.courseseq%type;
    vcoursename tblCourse.coursename%type;
    vcoursestartdate tblCourse.coursestartdate%type;
    vcoursefinishdate tblCourse.coursefinishdate%type;
    vclassroomname tblCourse.classroomname%type;
    vsubname tblSubject.subname%type;
    vsubjectstartdate tblSubjectList.subjectstartdate%type;
    vsubjectfinishdate tblSubjectList.subjectfinishdate%type;
    vbookname tblBook.bookname%type;
    vstudentnumber tblCourse.studentnumber%type;
    vprogress varchar2(30);
    vteachername tblTeacher.name%type;
begin
    -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '  교사명:  ' || vteachername); 
    
    dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    -- 해당 교사 스케줄 가져오기
    procGetTeacherSchedule(pteacherseq, vcursor);
    
    -- 해당 교사 스케줄 출력
    loop
        fetch vcursor into vsubseq, vcourseseq, vcoursename, vcoursestartdate, vcoursefinishdate, vclassroomname, vsubname, vsubjectstartdate, vsubjectfinishdate, vbookname, vstudentnumber, vprogress;
            exit when vcursor%notfound;
                dbms_output.put_line('과목번호: ' || vsubseq || '   과정번호: ' || vcourseseq || '   과정명: ' || vcoursename ||'   과정시작일: ' || vcoursestartdate || '   과정종료일: ' || vcoursefinishdate || '   강의실: ' || vclassroomname || '   과목명: ' || vsubname || '   과목시작일: ' || vsubjectstartdate || '   과목종료일: ' || vsubjectfinishdate || '   교재명: ' || vbookname || '   교육생등록인원: ' || vstudentnumber || '   강의진행여부: ' || vprogress);
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('결과가 없습니다.');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintTeacherSchedule;
/
----------------------------------스케줄 조회 선택-해당교육생출력
create or replace procedure procGetCourseStudentList(
    pcourseseq number,
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
    select 
        studentseq as 교육생번호, name as 교육생이름, phone as 전화번호, registerdate as 등록일, compldropstatus as 수료중도탈락여부
    from tblstudent 
    where processseq = pcourseseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('해당 과정을 듣는 교육생이 없습니다.');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseStudentList;
/
create or replace procedure procGetCourseName(
    pcourseseq number,
    pcoursename out varchar2
)
is
begin
    select coursename into pcoursename from tblCourse where courseseq = pcourseseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('해당 과정이 없습니다.');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseName;
/
create or replace procedure procPrintCourseStudentList(
    pcourseseq number
)
is
    vcursor sys_refcursor;
    vstudentseq tblstudent.studentseq%type;
    vname tblstudent.name%type;
    vphone tblstudent.phone%type;
    vregdate tblstudent.registerdate%type;
    vstatus tblstudent.compldropstatus%type;
    vcoursename tblcourse.coursename%type;
begin
    -- 입력한 번호가 교사가 진행하는 과목의 과정인지 물어보는거 나중에 시간되면 추가하기.
    -- 일단은 강사 스케줄의 번호만 입력된다는 가정임.

    -- 과정번호와 과정명 출력하기
    procGetCourseName(pcourseseq, vcoursename);
    dbms_output.put_line('과정번호: '  || pcourseseq ||'   과정명: ' || vcoursename);
    
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------');
    
    -- 교육생 목록 출력하기
    procGetCourseStudentList(pcourseseq, vcursor);
    loop
        fetch vcursor into vstudentseq, vname, vphone, vregdate, vstatus;
        exit when vcursor%notfound;
            dbms_output.put_line('교육생번호: ' || vstudentseq || '   교육생이름: ' || vname || '   전화번호: ' || vphone || '   등록일: ' || vregdate || '   수료|중도탈락 여부: ' || vstatus);
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('결과가 없습니다.');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintCourseStudentList;
/

----------------------------------------------------------------------배점입출력
----------------------------------마친강의 목록출력
create or replace procedure procGetTFinishedSubject(
    pteacherseq in number,
    pcursor out SYS_REFCURSOR
)
is
begin
    open pcursor
    for
    select 
        sl.subseq as 과목번호, sl.courseseq as 과정번호, c.coursename as 과정명, c.coursestartdate as 과정시작일, c.coursefinishdate as 과정종료일, 
        c.classroomname as 강의실, s.subname as 과목명, sl.subjectstartdate as 과목시작일, sl.subjectfinishdate as 과목종료일,
        b.bookname as 교재명,
        sg.attendancegrade as 출결배점, sg.writtengrade as 필기배점, sg.practicalgrade as 실기배점,
        sct.writtentestdate as 필기시험날짜, sct.practicaltestdate as 실기시험날짜, sct.writtentestfilereg as 필기시험등록여부, sct.practicaltestfilereg as 실기시험등록여부
    from tblSchedule sch
        inner join tblSubjectList sl
            on sch.subjectlistseq = sl.subjectlistseq
                inner join tblCourse c
                    on sl.courseseq = c.courseseq
                        inner join tblBook b
                            on sl.bookseq = b.bookseq
                                inner join tblSubject s
                                    on sl.subseq = s.subseq
                                        inner join tblsubjectgrade sg
                                            on sl.subjectlistseq = sg.subjectlistseq
                                                inner join tblscoretest sct
                                                    on sct.subjectlistseq = sl.subjectlistseq
    where sch.teacherseq = pteacherseq and sl.subjectfinishdate < sysdate
    order by sl.subjectstartdate;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetTFinishedSubject;
/
create or replace procedure procPrintTFinishedSubject(
    pteacherseq number
)
is
    vcursor sys_refcursor;
    vsubseq tblSubjectList.subseq%type;
    vcourseseq tblSubjectList.courseseq%type;
    vcoursename tblCourse.coursename%type;
    vcoursestartdate tblCourse.coursestartdate%type;
    vcoursefinishdate tblCourse.coursefinishdate%type;
    vclassroomname tblCourse.classroomname%type;
    vsubname tblSubject.subname%type;
    vsubjectstartdate tblSubjectList.subjectstartdate%type;
    vsubjectfinishdate tblSubjectList.subjectfinishdate%type;
    vbookname tblBook.bookname%type;
    vattgrade tblSubjectGrade.attendancegrade%type;
    vwgrade tblSubjectGrade.writtengrade%type;
    vpgrade tblSubjectGrade.practicalgrade%type;
    vwrittentestdate tblScoreTest.writtentestdate%type;
    vpracticaltestdate tblScoreTest.practicaltestdate%type;
    vwrittenfilereg tblScoreTest.writtentestfilereg%type;
    vpracticalfilereg tblScoreTest.practicaltestfilereg%type;
    
    vteachername tblTeacher.name%type;
    
    vattgradechar varchar2(10);
    vwgradechar varchar2(10);
    vpgradechar varchar2(10);
    
    vwrittentestdatechar varchar2(10);
    vpracticaltestdatechar varchar2(10);
begin
    -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '  교사명:  ' || vteachername); 
    
    dbms_output.put_line('----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    -- 해당 교사 스케줄 가져오기
    procGetTFinishedSubject(pteacherseq, vcursor);

    loop
        fetch vcursor into vsubseq, vcourseseq, vcoursename, vcoursestartdate, vcoursefinishdate, vclassroomname, vsubname, vsubjectstartdate, vsubjectfinishdate, vbookname, vattgrade, vwgrade, vpgrade, vwrittentestdate, vpracticaltestdate, vwrittenfilereg, vpracticalfilereg;
        exit when vcursor%notfound;
            vattgradechar := to_char(vattgrade);
            vwgradechar := to_char(vwgrade);
            vpgradechar := to_char(vpgrade);
            
            vwrittentestdatechar := to_char(vwrittentestdate, 'yy/mm/dd');
            vpracticaltestdatechar := to_char(vpracticaltestdate, 'yy/mm/dd');
            
            -- 널값 확인
            if vattgrade is null then 
                vattgradechar := 'null';
            end if;
            
            if vwgrade is null then 
                vwgradechar := 'null';
            end if;
            
            if vpgrade is null then 
                vpgradechar := 'null';
            end if;
            
            if vwrittentestdate is null then 
                vwrittentestdatechar := 'null';
            end if;
            
            if vpracticaltestdate is null then 
                vpracticaltestdatechar := 'null';
            end if;
            
            dbms_output.put_line('과목번호: ' || vsubseq || '   과정번호: ' || vcourseseq || '   과정명: ' || vcoursename ||'   과정시작일: ' || vcoursestartdate || '   과정종료일: ' || vcoursefinishdate || '   강의실: ' || vclassroomname || '   과목명: ' || vsubname || '   과목시작일: ' || vsubjectstartdate || '   과목종료일: ' || vsubjectfinishdate || '   교재명: ' || vbookname || '   출결배점: ' || vattgradechar || '   필기배점: ' || vwgradechar || '   실기배점: ' || vpgradechar || '   필기시험날짜: ' || vwrittentestdatechar || '   실기시험날짜: ' || vpracticaltestdatechar || '   필기시험문제등록여부: ' || vwrittenfilereg || '   실기시험문제등록여부: ' || vpracticalfilereg);
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end;
/
----------------------------------마친 과목 선택시-배점입력
create or replace procedure procGetSubjectListNum(
    psubnum number,
    pcoursenum number,
    presult out number
)
is
begin
    select subjectlistseq into presult from tblsubjectlist where subseq = psubnum and courseseq = pcoursenum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetSubjectListNum;
/
create or replace procedure procCheckSubjectGrade(
    psubjectlistnum number,
    presult out number
)
is
begin
    select attendancegrade into presult from tblSubjectGrade where subjectlistseq = psubjectlistnum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procCheckSubjectGrade;
/
create or replace procedure procSetSubjectGrade(
    psubnum number,         -- 과목번호
    pcoursenum number,      -- 과정번호
    pattgrade number,       -- 출결 배점
    pwrittengrade number,   -- 필기 배점
    ppracticalgrade number  -- 실기 배점
)
is
    vsubjectlistnum tblsubjectlist.subjectlistseq%type; -- 과목목록번호
    vstatus tblsubjectgrade.attendancegrade%type; -- 배점등록여부(숫자)
begin
    -- 과목 목록 번호 찾기
    procGetSubjectListNum(psubnum, pcoursenum, vsubjectlistnum);
    
    -- 해당 과목 목록으로 배점정보 물어보기
    procCheckSubjectGrade(vsubjectlistnum, vstatus);

    -- 배점이 입력되었는지 확인하기
    if vstatus != 0 then -- 배점이 입력되었다면
        dbms_output.put_line('배점이 이미 입력되었습니다. 입력을 종료합니다.');
        
    else -- 배점을 입력해야 하는 경우
        dbms_output.put_line('현재 등록된 배점이 없습니다.');
    
        -- 배점 유효성 검사
        if (pattgrade < 20 or pattgrade > 100) then -- 출결배점 범위가 유효하지 않은 경우
            dbms_output.put_line('출결배점이 유효하지 않습니다. 입력을 종료합니다.');
            
        elsif pwrittengrade < 0 or pwrittengrade > 100 then  -- 필기배점 범위가 유효하지 않은 경우
            dbms_output.put_line('필기배점이 유효하지 않습니다. 입력을 종료합니다.');
            
        elsif ppracticalgrade < 0 or ppracticalgrade > 100 then  -- 실기배점 범위가 유효하지 않은 경우
            dbms_output.put_line('실기배점이 유효하지 않습니다. 입력을 종료합니다.');
            
        elsif pattgrade + pwrittengrade + ppracticalgrade != 100 then -- 출결배점은 유효하나, 총합이 100이 아닌 경우
            dbms_output.put_line('배점의 총 합이 100이 아닙니다. 입력을 종료합니다.');
            
        else  -- 배점 입력하기
            update tblsubjectgrade 
            set attendancegrade = pattgrade, writtengrade = pwrittengrade, practicalgrade = ppracticalgrade 
            where subjectgradeseq = vsubjectlistnum;
            
            commit; -- db에 반영하기
            dbms_output.put_line('적합한 배점입니다. 새로 입력한 배점 정보 등록이 완료되었습니다.');
        end if;
    
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetSubjectGrade;
/
----------------------------------필기시험 날짜 등록
create or replace procedure procCheckWrittenDateReg(
    psubjectlistnum number,
    presult out date
)
is
begin
    select writtentestdate into presult from tblScoreTest where subjectlistseq = psubjectlistnum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procCheckWrittenDateReg;
/
create or replace procedure procSetWrtTestDate(
    psubnum number,         -- 과목번호
    pcoursenum number,      -- 과정번호
    pdate date              -- 필기시험일
)
is
    vsubjectlistnum tblsubjectlist.subjectlistseq%type; -- 과목목록번호
    vstatus tblscoretest.writtentestdate%type; -- 필기시험일
begin
    -- 과목 목록 번호 찾기
    procGetSubjectListNum(psubnum, pcoursenum, vsubjectlistnum);
    
    -- 해당 과목 목록으로 필기시험날짜 물어보기
    procCheckWrittenDateReg(vsubjectlistnum, vstatus);

    -- 날짜가 입력되었는지 확인하기
    if vstatus is null then -- 날짜를 입력해야 하는 경우
        dbms_output.put_line('현재 등록된 필기시험날짜가 없습니다.');
            
        update tblscoretest set writtentestdate = pdate where subjectlistseq = vsubjectlistnum;
        commit; -- db에 반영
        
        dbms_output.put_line('필기시험날짜가 등록되었습니다.');
    
    else -- 날짜가 입력되었다면
        
        dbms_output.put_line('필기시험날짜가 이미 등록되었습니다. 등록을 종료합니다.');

    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetWrtTestDate;
/
----------------------------------필기문제 등록
create or replace procedure procCheckWrittenFileReg(
    psubjectlistnum number,
    presult out varchar2
)
is
begin
    select writtentestfilereg into presult from tblScoreTest where subjectlistseq = psubjectlistnum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procCheckWrittenFileReg;
/
create or replace procedure procSetWrtTestDate(
    psubnum number,         -- 과목번호
    pcoursenum number       -- 과정번호
)
is
    vsubjectlistnum tblsubjectlist.subjectlistseq%type; -- 과목목록번호
    vstatus tblscoretest.writtentestfilereg%type; -- 필기시험문제등록여부
begin
    -- 과목 목록 번호 찾기
    procGetSubjectListNum(psubnum, pcoursenum, vsubjectlistnum);
    
    -- 해당 과목 목록으로 필기시험날짜 물어보기
    procCheckWrittenFileReg(vsubjectlistnum, vstatus);

    -- 날짜가 입력되었는지 확인하기
    if vstatus != 'N' then -- 날짜가 입력되었다면
        dbms_output.put_line('필기시험문제가 이미 등록되었습니다. 등록을 종료합니다.');
        
    else -- 시험문제를 등록해야 하는 경우
        dbms_output.put_line('현재 필기시험문제가 등록되지 않았습니다.');
        
        update tblscoretest set writtentestfilereg = 'Y' where subjectlistseq = vsubjectlistnum;
        commit;
        
        dbms_output.put_line('새로운 필기시험문제가 등록되었습니다.');
        
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetWrtTestDate;
/
----------------------------------실기시험 날짜 등록
create or replace procedure procCheckPrctDateReg(
    psubjectlistnum number,
    presult out date
)
is
begin
    select practicaltestdate into presult from tblScoreTest where subjectlistseq = psubjectlistnum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procCheckPrctDateReg;
/
create or replace procedure procSetPrctTestDate(
    psubnum number,         -- 과목번호
    pcoursenum number,      -- 과정번호
    pdate date              -- 실기시험일
)
is
    vsubjectlistnum tblsubjectlist.subjectlistseq%type; -- 과목목록번호
    vstatus tblscoretest.practicaltestdate%type; -- 실기시험일
begin
    -- 과목 목록 번호 찾기
    procGetSubjectListNum(psubnum, pcoursenum, vsubjectlistnum);
    
    -- 해당 과목 목록으로 실기시험날짜 물어보기
    procCheckPrctDateReg(vsubjectlistnum, vstatus);

    -- 날짜가 입력되었는지 확인하기
    if vstatus is null then -- 날짜를 입력해야 하는 경우
        dbms_output.put_line('현재 등록된 실기시험날짜가 없습니다.');
            
        update tblscoretest set practicaltestdate = pdate where subjectlistseq = vsubjectlistnum;
        commit;
        
        dbms_output.put_line('새로운 실기시험날짜가 등록되었습니다.');
    
    else -- 날짜가 입력되었다면
        
        dbms_output.put_line('실기시험날짜가 이미 입력되었습니다. 입력을 종료합니다.');
 
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetPrctTestDate;
/
----------------------------------실기시험 문제 등록
create or replace procedure procCheckPrctFileReg(
    psubjectlistnum number,
    presult out varchar2
)
is
begin
    select practicaltestfilereg into presult from tblScoreTest where subjectlistseq = psubjectlistnum;
exception
    when others then
        dbms_output.put_line('예외처리');
end procCheckPrctFileReg;
/
create or replace procedure procSetPrctTestDate(
    psubnum number,         -- 과목번호
    pcoursenum number       -- 과정번호
)
is
    vsubjectlistnum tblsubjectlist.subjectlistseq%type; -- 과목목록번호
    vstatus tblscoretest.practicaltestfilereg%type; -- 실기시험문제등록여부
begin
    -- 과목 목록 번호 찾기
    procGetSubjectListNum(psubnum, pcoursenum, vsubjectlistnum);
    
    -- 해당 과목 목록으로 필기시험날짜 물어보기
    procCheckPrctFileReg(vsubjectlistnum, vstatus);

    -- 날짜가 입력되었는지 확인하기
    if vstatus != 'N' then -- 날짜가 입력되었다면
        dbms_output.put_line('실기시험문제가 이미 등록되었습니다. 등록을 종료합니다.');
        
    else -- 시험문제를 등록해야 하는 경우
        dbms_output.put_line('현재 실기시험문제가 등록되지 않았습니다.');
        
        update tblscoretest set practicaltestfilereg = 'Y' where subjectlistseq = vsubjectlistnum;
        commit;
        
        dbms_output.put_line('새로운 실기시험문제가 등록되었습니다.');
        
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetPrctTestDate;
/

----------------------------------------------------------------------성적입출력
----------------------------------마친강의 목록
create or replace procedure procGetTFinishedSubScore(
    pteacherseq in number,
    pcursor out SYS_REFCURSOR  
)
is
begin
    open pcursor
    for
    select 
        sl.subseq as 과목번호, c.courseseq as 과정번호, c.coursename as 과정명, c.coursestartdate as 과정시작일, c.coursefinishdate as 과정종료일, 
        s.subname as 과목명, sl.subjectstartdate as 과목시작일, sl.subjectfinishdate as 과목종료일,
        b.bookname as 교재명,
        sg.attendancegrade as 출결배점, sg.writtengrade as 필기배점, sg.practicalgrade as 실기배점,
        st.writtentestscorereg as 필기성적등록여부, st.practicaltestscorereg as 실기성적등록여부
    from tblSchedule sch
        inner join tblSubjectList sl
            on sch.subjectlistseq = sl.subjectlistseq
                inner join tblCourse c
                    on sl.courseseq = c.courseseq
                        inner join tblBook b
                            on sl.bookseq = b.bookseq
                                inner join tblSubject s
                                    on sl.subseq = s.subseq
                                        inner join tblsubjectgrade sg
                                            on sl.subjectlistseq = sg.subjectlistseq
                                                inner join tblscoretest st
                                                    on sl.subjectlistseq = st.subjectlistseq
    where sch.teacherseq = pteacherseq and sl.subjectfinishdate < sysdate
    order by sl.subjectstartdate, sl.subseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetTFinishedSubScore;
/
create or replace procedure procPrintTFinishedSubScore(
    pteacherseq number
)
is
    vcursor sys_refcursor;
    vsubseq tblSubjectList.subseq%type;
    vcourseseq tblSubjectList.courseseq%type;
    vcoursename tblCourse.coursename%type;
    vcoursestartdate tblCourse.coursestartdate%type;
    vcoursefinishdate tblCourse.coursefinishdate%type;
    vsubname tblSubject.subname%type;
    vsubjectstartdate tblSubjectList.subjectstartdate%type;
    vsubjectfinishdate tblSubjectList.subjectfinishdate%type;
    vbookname tblBook.bookname%type;
    vattgrade tblSubjectGrade.attendancegrade%type;
    vwgrade tblSubjectGrade.writtengrade%type;
    vpgrade tblSubjectGrade.practicalgrade%type;
    vwrtscorereg tblScoreTest.writtentestscorereg%type;
    vprctscorereg tblScoreTest.practicaltestscorereg%type;
    
    vteachername tblTeacher.name%type;
    
    vattgradechar varchar2(10);
    vwgradechar varchar2(10);
    vpgradechar varchar2(10);
begin
    -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '  교사명:  ' || vteachername); 
    
    dbms_output.put_line('-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    -- 해당 교사 스케줄 가져오기
    procGetTFinishedSubScore(pteacherseq, vcursor);

    loop
        fetch vcursor into vsubseq, vcourseseq, vcoursename, vcoursestartdate, vcoursefinishdate, vsubname, vsubjectstartdate, vsubjectfinishdate, vbookname, vattgrade, vwgrade, vpgrade, vwrtscorereg, vprctscorereg;
        exit when vcursor%notfound;
            vattgradechar := to_char(vattgrade);
            vwgradechar := to_char(vwgrade);
            vpgradechar := to_char(vpgrade);
            
            -- 널값 확인
            if vattgrade is null then 
                vattgradechar := 'null';
            end if;
            
            if vwgrade is null then 
                vwgradechar := 'null';
            end if;
            
            if vpgrade is null then 
                vpgradechar := 'null';
            end if;
            
            dbms_output.put_line('과목번호: ' || vsubseq || '   과정번호: ' || vcourseseq || '   과정명: ' || vcoursename ||'   과정시작일: ' || vcoursestartdate || '   과정종료일: ' || vcoursefinishdate || '   과목명: ' || vsubname || '   과목시작일: ' || vsubjectstartdate || '   과목종료일: ' || vsubjectfinishdate || '   교재명: ' || vbookname || '   출결배점: ' || vattgradechar || '   필기배점: ' || vwgradechar || '   실기배점: ' || vpgradechar || '   필기시험점수등록여부: ' || vwrtscorereg || '   실기시험점수등록여부: ' || vprctscorereg);
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintTFinishedSubScore;
/
----------------------------------마친강의 선택 - 교육생 정보 성적출력
create or replace procedure procGetCourseStdScoreList(
    psubjectlistnum number, -- 과목목록번호
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
    select 
        st.studentseq as 교육생번호, st.name as 교육생이름, st.phone as 전화번호, st.compldropstatus as 수료중도탈락여부, st.compldropdate as 중도탈락일자,
        si.attendancescore as 출결성적, si.writingscore as 필기성적, si.practicalscore as 실기성적
    from tblscoreinfo si
        inner join tblstudent st
            on si.studentseq = st.studentseq
    where si.subjectlistseq = psubjectlistnum;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseStdScoreList;
/

-- 과목명 가져오기
create or replace procedure procGetSubjectName(
    psubseq number,
    psubname out varchar2
)
is
begin
    select subname into psubname from tblsubject where subseq = psubseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetSubjectName;
/

-- 교육생 정보 테이블 출력하기
create or replace procedure procPrintCourseStdScoreList(
    psubseq number,
    pcourseseq number
)
is
    vcursor sys_refcursor;
    
    vstudentseq tblstudent.studentseq%type;
    vname tblstudent.name%type;
    vphone tblstudent.phone%type;
    vstatus tblstudent.compldropstatus%type;
    vstatusdate tblstudent.compldropdate%type;
    vattscore tblscoreinfo.attendancescore%type;
    vwrtscore tblscoreinfo.writingscore%type;
    vprctscore tblscoreinfo.practicalscore%type;
    
    vsublistseq tblsubjectlist.subjectlistseq%type; -- 해당 과목의 과목목록번호
    
    vcoursename tblcourse.coursename%type;  -- 과정명
    vsubjectname tblsubject.subname%type;   -- 과목명
    
    -- 여부, 날짜, 성적 3개 null 검사 필요
    vstatuschar tblstudent.compldropstatus%type;
    vstatusdatechar varchar2(10);
    vattscorechar varchar2(10);
    vwrtscorechar varchar2(10);
    vprctscorechar varchar2(10);
begin
    -- 입력한 번호가 교사가 진행하는 과목의 과정인지 물어보는거 나중에 시간되면 추가하기.
    -- 일단은 강사 스케줄의 번호만 입력된다는 가정임.
    
    -- 과목목록번호 가져오기
    procGetSubjectListNum(psubseq, pcourseseq, vsublistseq);

    -- 과정번호와 과정명 출력하기
    procGetCourseName(pcourseseq, vcoursename);
    dbms_output.put_line('과정번호: '  || pcourseseq ||'   과정명: ' || vcoursename);
    
    -- 과목번호와 과목명 출력하기
    procGetSubjectName(psubseq, vsubjectname);
    dbms_output.put_line('과목번호: '  || psubseq ||'   과목명: ' || vsubjectname);
    
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------');
    
    -- 교육생 목록 출력하기
    procGetCourseStdScoreList(vsublistseq, vcursor);
    loop
        fetch vcursor into vstudentseq, vname, vphone, vstatus, vstatusdate, vattscore, vwrtscore, vprctscore;
        exit when vcursor%notfound;
            vstatuschar := vstatus;
            vstatusdatechar := to_char(vstatusdate, 'yy/mm/dd');
            vattscorechar := to_char(vattscore);
            vwrtscorechar := to_char(vwrtscore);
            vprctscorechar := to_char(vprctscore);
            
            -- null 검사
            if vstatus is null then
                vstatuschar := 'null';
            end if;
            
            if vstatusdate is null then
                vstatusdatechar := 'null';
            end if;
            
            if vattscore is null then
                vattscorechar := 'null';
            end if;
            
            if vwrtscore is null then
                vwrtscorechar := 'null';
            end if;
            
            if vprctscore is null then
                vprctscorechar := 'null';
            end if;
            
            if vstatuschar = '중도탈락' then -- 중도탈락일도 출력
                dbms_output.put_line('교육생번호: ' || vstudentseq || '   교육생이름: ' || vname || '   전화번호: ' || vphone || '   수료|중도탈락 여부: ' || vstatuschar || '   수료|중도탈락일: ' || vstatusdatechar || '   출결성적: ' || vattscorechar || '   필기성적: ' || vwrtscorechar || '   실기성적: ' || vprctscorechar);    
            else
                dbms_output.put_line('교육생번호: ' || vstudentseq || '   교육생이름: ' || vname || '   전화번호: ' || vphone || '   수료|중도탈락 여부: ' || vstatuschar || '   출결성적: ' || vattscorechar || '   필기성적: ' || vwrtscorechar || '   실기성적: ' || vprctscorechar);
            end if;
            
    end loop;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintCourseStdScoreList;
/
----------------------------------학생 필기 성적등록
create or replace procedure procGetStdWrtScore(
    pstdseq number,
    psublistseq number,
    pwrtscore out number
)
is
begin
    select writingscore into pwrtscore from tblscoreinfo where studentseq = pstdseq and subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdWrtScore;
/

--declare
--    vresult number;
--begin
--    procGetStdWrtScore(67, 13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 필기 배점 가져오기
create or replace procedure procGetWrtGrade(
    psublistseq number,
    pscore out number
)
is
begin
    select writtengrade into pscore from tblsubjectgrade where subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetWrtGrade;
/
--declare 
--    vresult number;
--begin
--    procGetWrtGrade(13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 학생의 중도탈락여부 가져오기
create or replace procedure procGetStdDropStatus(
    pstdseq number,
    pstatus out varchar2
)
is
begin
    select compldropstatus into pstatus from tblstudent where studentseq = pstdseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdDropStatus;
/

--declare
--    vresult tblstudent.compldropstatus%type;
--begin
--    procGetStdDropStatus(66, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 중도탈락일 가져오기
create or replace procedure procGetStdDropDate(
    pstdseq number,
    pdate out date
)
is
begin  
    select compldropdate into pdate from tblstudent where studentseq = pstdseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdDropDate;
/

-- 과목종료일 가져오기
create or replace procedure procGetSubFDate(
    psubjectlistseq number,
    pdate out date
)
is
begin
    select subjectfinishdate into pdate from tblsubjectlist where subjectlistseq = psubjectlistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetSubFDate;
/

--declare
--    vresult date;
--begin
--    procGetSubFDate(13, vresult);
--    dbms_output.put_line(vresult);
--end;


--select * from tblscoretest;

-- 모든 학생의 필기성적이 등록되었는지 확인 후 성적등록여부에 값 수정
create or replace procedure procSetWScoreRegStatus(
    psublistseq number
)
is
    vwcount number;
    vcourseseq number;
    vstudentcnt number;
begin    
    -- 해당 과목의 필기성적이 매겨진 학생 수 세기
    select count(*) into vwcount from tblscoreinfo where subjectlistseq = psublistseq and writingscore is not null; 
--    dbms_output.put_line(vwcount);
    
    -- 과정번호 찾기
    select courseseq into vcourseseq from tblsubjectlist where subjectlistseq = psublistseq;
    
    -- 강의실 수강 인원 확인
    select studentnumber into vstudentcnt from tblcourse where courseseq = vcourseseq; 
    
    -- 수강인원과 필기시험성적을 입력한 행의 수가 같은 경우
    if vwcount = vstudentcnt then
        update tblscoretest set writtentestscorereg = 'Y' where subjectlistseq = psublistseq;
        commit;
        dbms_output.put_line('해당 과목을 수강하는 모든 학생의 필기 시험 성적이 등록되었습니다.');
    end if;
        
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');

end procSetWScoreRegStatus;
/


-- 필기성적 등록하기
create or replace procedure procSetStdWrtScore(
    pstdseq number,
    psubseq number,
    pcourseseq number,
    pscore number
)
is
    vsublistseq number;
    vscore tblscoreinfo.writingscore%type;
    vstatus tblstudent.compldropstatus%type;
    vdropdate tblstudent.compldropdate%type;
    vsubfdate tblsubjectlist.subjectfinishdate%type;
    vwrtgrade tblsubjectgrade.writtengrade%type;
begin
    -- 과목목록번호 가져오기
    procGetSubjectListNum(psubseq, pcourseseq, vsublistseq);

    -- 필기성적 가져오기
    procGetStdWrtScore(pstdseq, vsublistseq, vscore);
    
    if vscore is null then
        -- 중도탈락여부 가져오기
        procGetStdDropStatus(pstdseq, vstatus);
        dbms_output.put_line('중도탈락여부: ' || vstatus);
        
        -- 중도탈락일 가져오기
        procGetStdDropDate(pstdseq, vdropdate);
        dbms_output.put_line('중도탈락일: ' || vdropdate);
        
        -- 과목종료일 가져오기
        procGetSubFDate(vsublistseq, vsubfdate);
        dbms_output.put_line('과목종료일: ' || vsubfdate);
        
        if vstatus = '중도탈락' and vdropdate < vsubfdate then -- 중도탈락 + 과목보다 일찍 탈락
            dbms_output.put_line('과목을 다 듣기 전에 탈락하였습니다. 성적을 등록할 수 없습니다. 등록을 종료합니다.');

        else -- 성적 입력 가능
        
            -- 필기배점 가져오기
            procGetWrtGrade(vsublistseq, vwrtgrade);
            dbms_output.put_line('필기배점: ' || vwrtgrade);
            
            if vwrtgrade is not null then -- 배점이 있는 경우
                -- 배점과 입력할 성적 비교
                
                -- 최대 점수가 각 시험의 배점까지이다.
                if pscore < 0 or pscore > vwrtgrade then -- 부적절한 범위
                    dbms_output.put_line('유효하지 않은 입력입니다. 입력을 종료합니다.');
                else -- 필기 성적 입력
                    update tblscoreinfo set writingscore = pscore where studentseq = pstdseq and subjectlistseq = vsublistseq;
                    commit;
                    
                    dbms_output.put_line('필기 성적 등록을 완료했습니다.');
                    
                    -- 해당 과목목록번호를 가진 학생들의 필기성적 확인하기 -> 모든 성적이 입력되었다면 'Y'로 변경
                    procSetWScoreRegStatus(vsublistseq);

                end if;
                
            else -- 필기배점이 없는 경우
                
                dbms_output.put_line('과목에 등록된 필기배점이 없습니다. 배점을 먼저 등록해주세요. 등록을 종료합니다.');
                
            end if;
            
        end if;
        
    else -- 성적이 이미 존재
        dbms_output.put_line('성적이 이미 존재합니다. 등록을 종료합니다.');
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetStdWrtScore;
/
----------------------------------학생 실기 성적등록
create or replace procedure procGetStdPrctScore(
    pstdseq number,
    psublistseq number,
    pprctscore out number
)
is
begin
    select practicalscore into pprctscore from tblscoreinfo where studentseq = pstdseq and subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdPrctScore;
/

--declare
--    vresult number;
--begin
--    procGetStPrctScore(66, 13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 실기 배점 가져오기
create or replace procedure procGetPrctGrade(
    psublistseq number,
    pscore out number
)
is
begin
    select practicalgrade into pscore from tblsubjectgrade where subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetPrctGrade;
/
--declare 
--    vresult number;
--begin
--    procGetPrctGrade(13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 모든 학생의 실기성적이 등록되었는지 확인 후 성적등록여부에 값 수정
create or replace procedure procSetPScoreRegStatus(
    psublistseq number
)
is
    vpcount number;
    vcourseseq number;
    vstudentcnt number;
begin    
   
    -- 해당 과목의 실기성적이 매겨진 학생 수 세기
    select count(*) into vpcount from tblscoreinfo where subjectlistseq = psublistseq and practicalscore is not null; 
    
    -- 과정번호 찾기
    select courseseq into vcourseseq from tblsubjectlist where subjectlistseq = psublistseq;
    
    -- 강의실 수강 인원 확인
    select studentnumber into vstudentcnt from tblcourse where courseseq = vcourseseq; 
    
    -- 수강인원과 실기시험성적을 입력한 행의 수가 같은 경우
    if vpcount = vstudentcnt then
        update tblscoretest set practicaltestscorereg = 'Y' where subjectlistseq = psublistseq;
        commit;
        
        dbms_output.put_line('해당 과목을 수강하는 모든 학생의 실기 시험 성적이 등록되었습니다.');

    end if;
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');

end procSetPScoreRegStatus;
/



-- 실기 성적 등록하기
create or replace procedure procSetStdPrctScore(
    pstdseq number,
    psubseq number,
    pcourseseq number,
    pscore number
)
is
    vsublistseq number;
    vscore tblscoreinfo.practicalscore%type;
    vstatus tblstudent.compldropstatus%type;
    vdropdate tblstudent.compldropdate%type;
    vsubfdate tblsubjectlist.subjectfinishdate%type;
    vprctgrade tblsubjectgrade.practicalgrade%type;
begin
    -- 과목목록번호 가져오기
    procGetSubjectListNum(psubseq, pcourseseq, vsublistseq);

    -- 실기성적 가져오기
    procGetStdPrctScore(pstdseq, vsublistseq, vscore);
    
    if vscore is null then
        -- 중도탈락여부 가져오기
        procGetStdDropStatus(pstdseq, vstatus);
        dbms_output.put_line('중도탈락여부: ' || vstatus);
        
        -- 중도탈락일 가져오기
        procGetStdDropDate(pstdseq, vdropdate);
        dbms_output.put_line('중도탈락일: ' || vdropdate);
        
        -- 과목종료일 가져오기
        procGetSubFDate(vsublistseq, vsubfdate);
        dbms_output.put_line('과목종료일: ' || vsubfdate);
        
        if vstatus = '중도탈락' and vdropdate < vsubfdate then -- 중도탈락 + 과목보다 일찍 탈락
            dbms_output.put_line('과목을 다 듣기 전에 탈락하였습니다. 성적을 등록할 수 없습니다. 등록을 종료합니다.');

        else -- 성적 입력 가능
        
            -- 실기배점 가져오기
            procGetPrctGrade(vsublistseq, vprctgrade);
            dbms_output.put_line('실기배점: ' || vprctgrade);
            
            if vprctgrade is not null then -- 배점이 있는 경우
                -- 배점과 입력할 성적 비교
                
                -- 최대 점수가 각 시험의 배점까지이다.
                if pscore < 0 or pscore > vprctgrade then -- 부적절한 범위
                    dbms_output.put_line('유효하지 않은 입력입니다. 입력을 종료합니다.');
                else -- 실기 성적 입력
                    update tblscoreinfo set practicalscore = pscore where studentseq = pstdseq and subjectlistseq = vsublistseq;
                    commit;
                    
                    dbms_output.put_line('실기 성적 등록을 완료했습니다.');
                    
                    -- 모든 학생의 실기 성적이 등록되었다면 'Y'로 바꾸기
                    procSetPScoreRegStatus(vsublistseq);
                end if;
                
            else -- 실기배점이 없는 경우
                dbms_output.put_line('과목에 등록된 실기배점이 없습니다. 배점을 먼저 등록해주세요. 등록을 종료합니다.');
                
            end if;
            
        end if;
        
    else -- 성적이 이미 존재
        dbms_output.put_line('성적이 이미 존재합니다. 등록을 종료합니다.');
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetStdPrctScore;
/
----------------------------------학생 출결 성적등록
create or replace procedure procGetStdAttScore(
    pstdseq number,
    psublistseq number,
    pattscore out number
)
is
begin
    select attendancescore into pattscore from tblscoreinfo where studentseq = pstdseq and subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdAttScore;
/


-- 과정종료일 가져오기
create or replace procedure procGetCourseFdate(
    pcourseseq number,
    pdate out date
)
is
begin
    select coursefinishdate into pdate from tblcourse where courseseq = pcourseseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseFdate;
/


-- 출결배점 가져오기
create or replace procedure procGetAttGrade(
    psublistseq number,
    pscore out number
)
is 
begin
    select attendancegrade into pscore from tblsubjectgrade where subjectlistseq = psublistseq; 
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetAttGrade;
/
--declare
--    vresult number;
--begin
--    procGetAttGrade(13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 학생의 출결 점수 입력하기
create or replace procedure procSetStdAttScore(
    pstdseq number,
    psubseq number,
    pcourseseq number,
    pscore number
)
is
    vsublistseq number;
    vscore tblscoreinfo.attendancescore%type;
    vstatus tblstudent.compldropstatus%type;
    vdropdate tblstudent.compldropdate%type;
    vcoursefdate tblcourse.coursefinishdate%type;
    vattgrade tblsubjectgrade.attendancegrade%type;
begin
    -- 과목목록번호 가져오기
    procGetSubjectListNum(psubseq, pcourseseq, vsublistseq);

    -- 출결성적 가져오기
    procGetStdAttScore(pstdseq, vsublistseq, vscore);
    
    if vscore is null then
        -- 중도탈락여부 가져오기
        procGetStdDropStatus(pstdseq, vstatus);
        dbms_output.put_line('중도탈락여부: ' || vstatus);
        
        -- 중도탈락일 가져오기
        procGetStdDropDate(pstdseq, vdropdate);
        dbms_output.put_line('중도탈락일: ' || vdropdate);
        
        -- 과정종료일 가져오기
        procGetCourseFdate(pcourseseq, vcoursefdate);
        dbms_output.put_line('과정종료일: ' || vcoursefdate);
        
        if vstatus = '중도탈락' and vdropdate < vcoursefdate then -- 중도탈락 + 과정보다 일찍 탈락
            dbms_output.put_line('과정을 다 듣기 전에 탈락하였습니다. 성적을 등록할 수 없습니다. 등록을 종료합니다.');

        else -- 성적 입력 가능
        
            -- 출결배점 가져오기
            procGetAttGrade(vsublistseq, vattgrade);
            dbms_output.put_line('출결배점: ' || vattgrade);
            
            if vattgrade is not null then -- 배점이 있는 경우
                -- 배점과 입력할 성적 비교
                
                -- 최대 점수가 각 시험의 배점까지이다.
                if pscore < 0 or pscore > vattgrade then -- 부적절한 범위
                    dbms_output.put_line('유효하지 않은 입력입니다. 입력을 종료합니다.');
                else -- 출결 성적 입력
                    update tblscoreinfo set attendancescore = pscore where studentseq = pstdseq and subjectlistseq = vsublistseq;
                    commit;
                    
                    dbms_output.put_line('출결 성적 등록을 완료했습니다.');
                end if;
                
            else -- 출결배점이 없는 경우
                dbms_output.put_line('과목에 등록된 출결배점이 없습니다. 배점을 먼저 등록해주세요. 등록을 종료합니다.');
                
            end if;
            
        end if;
        
    else -- 성적이 이미 존재
        dbms_output.put_line('성적이 이미 존재합니다. 등록을 종료합니다.');
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetStdAttScore;
/

----------------------------------------------------------------------출결관리조회
create or replace procedure procGetStdAttScore(
    pstdseq number,
    psublistseq number,
    pattscore out number
)
is
begin
    select attendancescore into pattscore from tblscoreinfo where studentseq = pstdseq and subjectlistseq = psublistseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdAttScore;
/


-- 과정종료일 가져오기
create or replace procedure procGetCourseFdate(
    pcourseseq number,
    pdate out date
)
is
begin
    select coursefinishdate into pdate from tblcourse where courseseq = pcourseseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseFdate;
/


-- 출결배점 가져오기
create or replace procedure procGetAttGrade(
    psublistseq number,
    pscore out number
)
is 
begin
    select attendancegrade into pscore from tblsubjectgrade where subjectlistseq = psublistseq; 
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetAttGrade;
/
--declare
--    vresult number;
--begin
--    procGetAttGrade(13, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 학생의 출결 점수 입력하기
create or replace procedure procSetStdAttScore(
    pstdseq number,
    psubseq number,
    pcourseseq number,
    pscore number
)
is
    vsublistseq number;
    vscore tblscoreinfo.attendancescore%type;
    vstatus tblstudent.compldropstatus%type;
    vdropdate tblstudent.compldropdate%type;
    vcoursefdate tblcourse.coursefinishdate%type;
    vattgrade tblsubjectgrade.attendancegrade%type;
begin
    -- 과목목록번호 가져오기
    procGetSubjectListNum(psubseq, pcourseseq, vsublistseq);

    -- 출결성적 가져오기
    procGetStdAttScore(pstdseq, vsublistseq, vscore);
    
    if vscore is null then
        -- 중도탈락여부 가져오기
        procGetStdDropStatus(pstdseq, vstatus);
        dbms_output.put_line('중도탈락여부: ' || vstatus);
        
        -- 중도탈락일 가져오기
        procGetStdDropDate(pstdseq, vdropdate);
        dbms_output.put_line('중도탈락일: ' || vdropdate);
        
        -- 과정종료일 가져오기
        procGetCourseFdate(pcourseseq, vcoursefdate);
        dbms_output.put_line('과정종료일: ' || vcoursefdate);
        
        if vstatus = '중도탈락' and vdropdate < vcoursefdate then -- 중도탈락 + 과정보다 일찍 탈락
            dbms_output.put_line('과정을 다 듣기 전에 탈락하였습니다. 성적을 등록할 수 없습니다. 등록을 종료합니다.');

        else -- 성적 입력 가능
        
            -- 출결배점 가져오기
            procGetAttGrade(vsublistseq, vattgrade);
            dbms_output.put_line('출결배점: ' || vattgrade);
            
            if vattgrade is not null then -- 배점이 있는 경우
                -- 배점과 입력할 성적 비교
                
                -- 최대 점수가 각 시험의 배점까지이다.
                if pscore < 0 or pscore > vattgrade then -- 부적절한 범위
                    dbms_output.put_line('유효하지 않은 입력입니다. 입력을 종료합니다.');
                else -- 출결 성적 입력
                    update tblscoreinfo set attendancescore = pscore where studentseq = pstdseq and subjectlistseq = vsublistseq;
                    commit;
                    
                    dbms_output.put_line('출결 성적 등록을 완료했습니다.');
                end if;
                
            else -- 출결배점이 없는 경우
                dbms_output.put_line('과목에 등록된 출결배점이 없습니다. 배점을 먼저 등록해주세요. 등록을 종료합니다.');
                
            end if;
            
        end if;
        
    else -- 성적이 이미 존재
        dbms_output.put_line('성적이 이미 존재합니다. 등록을 종료합니다.');
    end if;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procSetStdAttScore;
/

-----------------------------------------------출결관리조회
----------------------------------과정별 출결조회
create or replace procedure procGetCourseAtt(
    pcourseseq number,
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
    select 
        s.studentseq as 교육생번호, s.name as 교육생이름, a.attendancedate as 날짜, a.attendancestatus as 출결여부
    from tblattendance a
        inner join tblstudent s
            on a.studentseq = s.studentseq
                inner join tblcourse c
                    on s.processseq = c.courseseq
    where a.courseseq = pcourseseq
    order by s.studentseq, a.attendancedate;

exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetCourseAtt;
/
--declare
--    vcursor sys_refcursor;
--    
--    vseq tblstudent.studentseq%type;
--    vname tblstudent.name%type;
--    vdate tblattendance.attendancedate%type;
--    vstatus tblattendance.attendancestatus%type;
--begin
--    procGetCourseAtt(1, vcursor);
--    
--    loop
--        fetch vcursor into vseq, vname, vdate, vstatus; 
--        exit when vcursor%notfound;
--            dbms_output.put_line('교육생번호: ' || vseq || '   교육생이름: ' || vname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
--    end loop;
--
--end;


-- 과정별 출결 조회하기
create or replace procedure procPrintCourseAtt(
    pteacherseq number,
    pcourseseq number
)
is
    vteachername tblteacher.name%type;
    vcoursename tblcourse.coursename%type;
    
    vcursor sys_refcursor;
    vseq tblstudent.studentseq%type;
    vname tblstudent.name%type;
    vdate tblattendance.attendancedate%type;
    vstatus tblattendance.attendancestatus%type;
    
    vdatestr varchar2(30);
begin
     -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '   교사명:  ' || vteachername); 
    
    -- 과정번호와 과정명 출력하기
    procGetCourseName(pcourseseq, vcoursename);
    dbms_output.put_line('과정번호: '  || pcourseseq ||'   과정명: ' || vcoursename);
    
    dbms_output.put_line('--------------------------------------------------------------------');
    
    -- 목록 출력
    procGetCourseAtt(1, vcursor);
    
    loop
        fetch vcursor into vseq, vname, vdate, vstatus; 
        exit when vcursor%notfound;
            if to_char(vdate, 'd') not in ('1', '7') then  -- 평일만 출력
                dbms_output.put_line('교육생번호: ' || vseq || '   교육생이름: ' || vname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
            end if;
    end loop;
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintCourseAtt;
/
----------------------------------출결 기간별 조회
create or replace procedure procGetYmAtt(
    pteacherseq number,
    pstartdate date,
    penddate date,
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
    select 
        distinct a.courseseq as 과정번호, c.coursename as 과정명, s.studentseq as 교육생번호, s.name as 교육생이름, 
        a.attendancedate as 날짜, a.attendancestatus as 출결여부
    from tblattendance a 
        inner join tblstudent s 
            on a.studentseq = s.studentseq
                inner join tblcourse c
                    on s.processseq = c.courseseq
                        inner join tblsubjectlist sl
                            on sl.courseseq = c.courseseq
    where a.attendancedate between to_date(pstartdate) and to_date(penddate) and sl.teacherseq = pteacherseq
    order by a.attendancedate, a.courseseq, s.studentseq;
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetYmAtt;
/

-- 특정 기간 출결 조회하기
create or replace procedure procPrintYmAtt(
    pteacherseq number,
    pstartdate date,
    penddate date
)
is
    vcursor sys_refcursor;
    vcourseseq tblcourse.courseseq%type;
    vcoursename tblcourse.coursename%type;
    vstdseq tblstudent.studentseq%type;
    vstdname tblstudent.name%type;
    vdate tblattendance.attendancedate%type;
    vstatus tblattendance.attendancestatus%type;
    vteachername tblteacher.name%type;
begin
    -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '   교사명:  ' || vteachername); 
    
    -- 기간 출력하기
    dbms_output.put_line('기간: ' || to_char(pstartdate, 'yyyy-mm-dd') || ' ~ ' || to_char(penddate, 'yyyy-mm-dd'));
    
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    -- 테이블 가져오기
    procGetYmAtt(pteacherseq, pstartdate, penddate, vcursor);
    
    loop 
        fetch vcursor into vcourseseq, vcoursename, vstdseq, vstdname, vdate, vstatus;
        exit when vcursor%notfound;
        if to_char(vdate, 'd') not in ('1', '7') then  -- 평일만 출력
            dbms_output.put_line('과정번호: ' || vcourseseq || '   과정명: ' || vcoursename || '   교육생번호: ' || vstdseq || '   교육생이름: ' || vstdname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
        end if;
    end loop;
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintYmAtt;
/
----------------------------------특정년 조회
create or replace procedure procGetYmdAtt(
    pteacherseq number,
    pdate date,
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
    select 
        distinct a.courseseq as 과정번호, c.coursename as 과정명, s.studentseq as 교육생번호, s.name as 교육생이름, a.attendancedate as 날짜, a.attendancestatus as 출결여부 
    from tblattendance a 
        inner join tblstudent s 
            on a.studentseq = s.studentseq
                inner join tblcourse c
                    on s.processseq = c.courseseq
                        inner join tblsubjectlist sl
                            on c.courseseq = sl.courseseq
    where a.attendancedate = to_date(pdate) and sl.teacherseq = pteacherseq
    order by a.courseseq, s.studentseq; 
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetYmdAtt;
/

--declare
--    vcursor sys_refcursor;
--    
--    vcourseseq tblcourse.courseseq%type;
--    vcoursename tblcourse.coursename%type;
--    vstdseq tblstudent.studentseq%type;
--    vstdname tblstudent.name%type;
--    vdate tblattendance.attendancedate%type;
--    vstatus tblattendance.attendancestatus%type;
--begin
--    procGetYmdAtt(1, '2023-07-05', vcursor);
--    
--    loop
--        fetch vcursor into vcourseseq, vcoursename, vstdseq, vstdname, vdate, vstatus; 
--        exit when vcursor%notfound;
--            dbms_output.put_line('과정번호: ' || vcourseseq || '   과정명: ' || vcoursename || '   교육생번호: ' || vstdseq || '   교육생이름: ' || vstdname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
--    end loop;
--
--end;


-- 특정 년월일 조회하기
create or replace procedure procPrintYmdAtt(
    pteacherseq number,
    pdatestr varchar2
)
is
    vinputdate date;
    vcursor sys_refcursor;
    vteachername tblteacher.name%type;
    vcourseseq tblcourse.courseseq%type;
    vcoursename tblcourse.coursename%type;
    vstdseq tblstudent.studentseq%type;
    vstdname tblstudent.name%type;
    vdate tblattendance.attendancedate%type;
    vstatus tblattendance.attendancestatus%type;
begin
     -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '   교사명:  ' || vteachername); 
    
    vinputdate := to_date(pdatestr, 'yyyy/mm/dd');
    
    -- 날짜 출력하기
    dbms_output.put_line('날짜: '  || to_char(vinputdate, 'yyyy/mm/dd'));
    
    dbms_output.put_line('------------------------------------------------------------------------------------------------------------------------------------------------------');
    
    
    
    if to_char(vinputdate, 'd') in ('1', '7') then  -- 주말
        dbms_output.put_line('입력하신 날짜는 주말입니다. 조회를 종료합니다.');
    else
        -- 목록 출력
        procGetYmdAtt(pteacherseq, vinputdate, vcursor);
        
        loop
            fetch vcursor into vcourseseq, vcoursename, vstdseq, vstdname, vdate, vstatus; 
            exit when vcursor%notfound;
                dbms_output.put_line('과정번호: ' || vcourseseq || '   과정명: ' || vcoursename || '   교육생번호: ' || vstdseq || '   교육생이름: ' || vstdname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
        end loop;
    end if;
    
end procPrintYmdAtt;
/
----------------------------------출결 인원별 조회
create or replace procedure procGetStdAtt(
    pteacherseq number,
    pstdseq number,
    pcursor out sys_refcursor
)
is
begin
    open pcursor
    for
--    select 
--        a.courseseq as 과정번호, c.coursename as 과정명, a.attendancedate as 날짜, a.attendancestatus as 출결여부
--    from tblattendance a
--        inner join tblstudent s
--            on a.studentseq = s.studentseq
--                inner join tblcourse c
--                    on s.processseq = c.courseseq
--                        inner join tblsubjectlist sl
--                            on c.courseseq = sl.courseseq
--    where a.studentseq = pstdseq and sl.teacherseq = pteacherseq;
--    
    select 
        distinct a.courseseq as 과정번호, c.coursename as 과정명, a.attendancedate as 날짜, a.attendancestatus as 출결여부
    from tblattendance a
        inner join tblstudent s
            on s.studentseq =a.studentseq
                inner join tblcourse c
                    on c.courseseq = s.processseq
                        inner join tblsubjectlist sl
                            on c.courseseq = sl.courseseq
    where a.studentseq = pstdseq and sl.teacherseq = pteacherseq
    order by a.courseseq, a.attendancedate;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdAtt;
/

--declare
--    vcursor sys_refcursor;
--    
--    vseq tblcourse.courseseq%type;
--    vname tblcourse.coursename%type;
--    vdate tblattendance.attendancedate%type;
--    vstatus tblattendance.attendancestatus%type;
--begin
--    procGetStdAtt(1, 1, vcursor);
--    
--    loop
--        fetch vcursor into vseq, vname, vdate, vstatus; 
--        exit when vcursor%notfound;
--            dbms_output.put_line('과정번호: ' || vseq || '   과정명: ' || vname || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
--    end loop;
--
--end;


-- 교육생 이름 가져오기
create or replace procedure procGetStdName(
    pstdseq number,
    pname out varchar2
)
is
begin
    select name into pname from tblstudent where studentseq = pstdseq;
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procGetStdName;
/
--declare
--    vresult varchar2(50);
--begin
--    procGetStdName(1, vresult);
--    dbms_output.put_line(vresult);
--end;


-- 교육생 별 출결 조회하기
create or replace procedure procPrintStdAtt(
    pteacherseq number,
    pstdseq number
)
is
    vteachername tblteacher.name%type;
    vstdname tblstudent.name%type;
    
    vcursor sys_refcursor;
    vcourseseq tblcourse.courseseq%type;
    vcoursename tblcourse.coursename%type;
    vdate tblattendance.attendancedate%type;
    vstatus tblattendance.attendancestatus%type;
begin
     -- 해당 교사번호, 교사명 출력
    procGetTeacherName(pteacherseq, vteachername);
    dbms_output.put_line('교사번호: ' || pteacherseq || '   교사명:  ' || vteachername); 
    
    -- 교육생번호와 교육생이름 출력하기
    procGetStdName(pstdseq, vstdname);
    dbms_output.put_line('교육생번호: '  || pstdseq ||'   교육생이름: ' || vstdname);
    
    dbms_output.put_line('---------------------------------------------------------------------------------------------------');
    
    -- 목록 출력
    procGetStdAtt(pteacherseq, pstdseq, vcursor);
    
    loop
        fetch vcursor into vcourseseq, vcoursename, vdate, vstatus; 
        exit when vcursor%notfound;
            if to_char(vdate, 'd') not in ('1', '7') then  -- 평일만 출력
                dbms_output.put_line('과정번호: ' || vcourseseq || '   과정명: ' || vcoursename || '   날짜: ' || vdate || '   출결여부: ' || vstatus);
            end if;
    end loop;
    
exception
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');  
        
    when others then
        dbms_output.put_line('예외 처리');
end procPrintStdAtt;
/
-----------------------------------------------------------------------------교육생
----------------------------------교육생 성적 조회 기능
create or replace procedure subSelectList( --성적조회 전 과목선택출력
    pseq vwStudent.번호%type
)
is
    vsub vwStudent.과정명%type;
    vcursor sys_refcursor;
    vrow vwsublist%rowtype;
begin
    select 과정명 into vsub from vwstudent where 번호 = pseq;
    open vcursor
    for
    select * from vwsublist where 과정이름 = vsub;
    dbms_output.put_line(vsub);
    loop
        fetch vcursor into vrow;
        exit when vcursor%notfound;
        dbms_output.put_line('과목명: ' || vrow.과목이름);
    end loop;
    
end subSelectList;
/

------------------------------------------------------------------------- 

create or replace procedure scoreList( --성적조회
    pseq vwStudent.번호%type,
    psub vwsublist.과목이름%type
)
is
    vsub vwStudent.과정명%type;    --입력받은 학생의 과정명
    vrow vwsublist%rowtype;
    vrow2 vwscore%rowtype;

begin
    select 과정명 into vsub from vwstudent where 번호 = pseq;
    select * into vrow from vwsublist where 과정이름 = vsub and 과목이름 = psub;
    select * into vrow2 from vwscore where 번호 = pseq and 과목이름 = psub;
    dbms_output.put_line(vsub);
    dbms_output.put_line('과목번호: ' || vrow.리스트번호);
    dbms_output.put_line('과목명: ' || vrow.과목이름);
    dbms_output.put_line('과목기간: ' || vrow.과목시작일 || ' ~ ' || vrow.과목종료일);
    dbms_output.put_line('교재: ' || vrow.교재);
    dbms_output.put_line('교사: ' || vrow.교사);
    dbms_output.put_line('출결 배점: ' || vrow.출결배점);
    dbms_output.put_line('필기 배점: ' || vrow.필기배점 || ' 시험일: ' || vrow.필기시험일);
    dbms_output.put_line('실기 배점: ' || vrow.실기배점 || ' 시험일: ' || vrow.실기시험일);
    dbms_output.put_line('출결점수: ' || vrow2.출결점수);
    dbms_output.put_line('필기점수: ' || vrow2.필기점수);
    dbms_output.put_line('실기점수: ' || vrow2.실기점수);
    
end scoreList;
/
------------------------------------------------------------------------- 

create or replace procedure workIn( -- 출석등록
    pseq tblattendanceStatus.atsSeq%type
)
is
begin
    insert into tblattendanceStatus values ((SELECT nvl(max(atsSeq),0) + 1 from tblattendanceStatus), pseq, default, null);
end workIn;
/
------------------------------------------------------------------------- 

create or replace procedure workout( -- 퇴근등록
    pseq tblattendanceStatus.atsSeq%type
)
is
    pin number;
    pout number;
begin
    update tblattendanceStatus set
        stout = default 
            where studentseq = pseq;
    select to_char(stin, 'hh24'), to_char(stout, 'hh24') into pin, pout from tblattendanceStatus where studentseq = pseq;

    if pin < 9 and pout >= 18 then
        INSERT INTO tblAttendance 
            VALUES ((SELECT nvl(max(attendanceSeq),0) + 1 from tblAttendance),pseq,(select processSeq from tblstudent where studentseq = pseq),sysdate,'정상');
    elsif pin >= 9 and pout >= 18 then
        INSERT INTO tblAttendance 
            VALUES ((SELECT nvl(max(attendanceSeq),0) + 1 from tblAttendance),pseq,(select processSeq from tblstudent where studentseq = pseq),sysdate,'지각');
    else 
        INSERT INTO tblAttendance 
            VALUES ((SELECT nvl(max(attendanceSeq),0) + 1 from tblAttendance),pseq,(select processSeq from tblstudent where studentseq = pseq),sysdate,'조퇴');
    end if;
end workout;
/
-------------------------------------------------------------------

create or replace procedure workCheck(--출석 조회
    pinput varchar2,
    pstdate date,
    pendate date
)
is
    vcursor sys_refcursor; --커서 참조 변수
    vrow tblAttendance%rowtype;

begin
    open vcursor
    for
    select 
        *
    from tblAttendance 
        where AttendanceDate >= pstdate 
            and AttendanceDate < to_date((pendate || ' 23:59:59'), 'yy-mm-dd hh24:mi:ss')
            and studentseq = pinput;
    
    loop 
        fetch vcursor into vrow;
        exit when vcursor%notfound;
        dbms_output.put_line('=======================================');
        dbms_output.put_line(vrow.AttendanceDate || ' 상태: '|| vrow.AttendanceStatus);
        
    end loop;
    dbms_output.put_line('=======================================');


end workCheck;
/
----------------------------------






----------------------------------------------------관리자 추가기능
------------------------------------협력기업-목록
CREATE OR REPLACE PROCEDURE GetCompanyRecords IS
BEGIN
    FOR company_rec IN (SELECT * FROM tblCompany) LOOP
        -- 원하는 작업 수행 (예: DBMS_OUTPUT으로 출력)
        DBMS_OUTPUT.PUT_LINE('CompanySeq: ' || company_rec.companySeq || ', Name: ' || company_rec.name || ', Tel: ' || company_rec.tel);
    END LOOP;
END;
/
------------------------------------협력기업-추가
CREATE OR REPLACE PROCEDURE AddCompany(
    p_name VARCHAR2,
    p_tel VARCHAR2
) IS
BEGIN
    DECLARE
        v_max_company_seq NUMBER;
    BEGIN
        SELECT MAX(companySeq) + 1 INTO v_max_company_seq FROM tblCompany;
        INSERT INTO tblCompany (companySeq, name, tel) VALUES (v_max_company_seq, p_name, p_tel);
        DBMS_OUTPUT.PUT_LINE('새로운 기업이 추가되었습니다.');
    END;
END;
/
------------------------------------협력기업-수정
CREATE OR REPLACE PROCEDURE UpdateCompany(
    p_company_seq NUMBER,
    p_name VARCHAR2,
    p_tel VARCHAR2
) IS
BEGIN
    BEGIN
        UPDATE tblCompany SET name = p_name WHERE companySeq = p_company_seq;
        UPDATE tblCompany SET tel = p_tel WHERE companySeq = p_company_seq;
        DBMS_OUTPUT.PUT_LINE('기업 정보가 수정되었습니다.');
    END;
END;
/
------------------------------------협력기업-삭제
CREATE OR REPLACE PROCEDURE DeleteCompany(
    p_company_seq NUMBER
) IS
BEGIN
    BEGIN
        DELETE FROM tblCompany WHERE companySeq = p_company_seq;
        DBMS_OUTPUT.PUT_LINE('기업 정보가 삭제되었습니다.');
    END;
END;
/
------------------------------------취업-목록
CREATE OR REPLACE PROCEDURE SelectEmploymentData IS
BEGIN
    FOR emp_rec IN (SELECT * FROM tblEmployment) LOOP
        DBMS_OUTPUT.PUT_LINE('employmentSeq: ' || emp_rec.employmentSeq || ', studentSeq: ' || emp_rec.studentSeq || ', status: ' || emp_rec.status);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/
------------------------------------취업-추가
CREATE OR REPLACE PROCEDURE procEmployment (
    p_studentSeq NUMBER
) AS
BEGIN
    INSERT INTO tblEmployment (employmentSeq, studentSeq, status)
    SELECT (SELECT MAX(employmentSeq) + 1 FROM tblEmployment), p_studentSeq, 'N'
    FROM tblStudent
    WHERE studentSeq = p_studentSeq and complDropStatus = '수료';
    
    DBMS_OUTPUT.PUT_LINE('Employment 정보가 추가되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/
------------------------------------취업-수정
CREATE OR REPLACE PROCEDURE update_employment_status (
    p_studentSeq NUMBER
) AS
BEGIN
    UPDATE tblEmployment
    SET status = 'Y'
    WHERE studentSeq = p_studentSeq;
    COMMIT;
END update_employment_status;
/
------------------------------------취업-삭제
CREATE OR REPLACE PROCEDURE DeleteEmployment (
    p_studentSeq IN NUMBER
) IS
BEGIN
    DELETE FROM tblEmployment WHERE studentSeq = p_studentSeq;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('DELETE 오류 발생: ' || SQLERRM);
END;
/
------------------------------------고용보험
CREATE OR REPLACE PROCEDURE manage_insurance (
    p_studentSeq NUMBER,
    p_action VARCHAR2
) AS
BEGIN
    IF p_action = 'SELECT' THEN
        -- 조회
        FOR rec IN (SELECT * FROM tblInsurance) LOOP
            DBMS_OUTPUT.PUT_LINE('고용보험 정보');
            DBMS_OUTPUT.PUT_LINE('InsuranceSeq: ' || rec.insuranceSeq || ' ' || 'StudentSeq: ' || rec.studentSeq || ' ' || 'Status: ' || rec.status);
        END LOOP;
    ELSIF p_action = 'INSERT' THEN
        -- 추가
        INSERT INTO tblInsurance (insuranceSeq, studentSeq, status)
        SELECT (SELECT MAX(insuranceSeq) + 1 FROM tblInsurance), p_studentSeq, 'N'
        FROM tblEmployment e
        WHERE e.studentSeq = p_studentSeq;
        DBMS_OUTPUT.PUT_LINE('Insurance 정보가 추가되었습니다.');
    ELSIF p_action = 'UPDATE' THEN
        -- 수정
        UPDATE tblInsurance SET status = 'Y' WHERE studentSeq = p_studentSeq;
        DBMS_OUTPUT.PUT_LINE('Insurance 정보가 수정되었습니다.');
    ELSIF p_action = 'DELETE' THEN
        -- 삭제
        DELETE FROM tblInsurance WHERE studentSeq = p_studentSeq;
        DBMS_OUTPUT.PUT_LINE('Insurance 정보가 삭제되었습니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('잘못된 동작을 선택하셨습니다.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류발생');
END;
/
------------------------------------면접-조회
CREATE OR REPLACE PROCEDURE select_interview AS
BEGIN
    FOR rec IN (SELECT * FROM tblInterview) LOOP
        DBMS_OUTPUT.PUT_LINE('면접 정보:');
        DBMS_OUTPUT.PUT_LINE('InterviewSeq: ' || rec.iSeq);
        DBMS_OUTPUT.PUT_LINE('SubSeq: ' || rec.subSeq);
        DBMS_OUTPUT.PUT_LINE('Name: ' || rec.name);
        DBMS_OUTPUT.PUT_LINE('SSN: ' || rec.ssn);
        DBMS_OUTPUT.PUT_LINE('Tel: ' || rec.tel);
        DBMS_OUTPUT.PUT_LINE('PassOrNot: ' || rec.passOrNot);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END select_interview;
/
------------------------------------면접-추가
CREATE OR REPLACE PROCEDURE insert_interview_and_student (
    p_subSeq NUMBER,
    p_name VARCHAR2,
    p_ssn VARCHAR2,
    p_tel VARCHAR2,
    p_passOrNot VARCHAR2
) AS
BEGIN
    -- 면접 정보 추가
    INSERT INTO tblInterview (iSeq, subSeq, name, ssn, tel, passOrNot)
    VALUES ((SELECT MAX(iSeq) + 1 FROM tblInterview), p_subSeq, p_name, p_ssn, p_tel, p_passOrNot);
    
    -- '합격'일 경우 학생 정보 추가
    IF p_passOrNot = '합격' THEN
        INSERT INTO tblStudent (studentSeq, name, ssn, phone, ApplicationClass, processSeq)
        VALUES ((SELECT MAX(studentSeq) + 1 FROM tblStudent), p_name, p_ssn, p_tel, 1, p_subSeq);
    END IF;
END insert_interview_and_student;
/
------------------------------------면접-수정
CREATE OR REPLACE PROCEDURE update_interview_tel (
    p_iSeq NUMBER,
    p_tel VARCHAR2
) AS
BEGIN
    UPDATE tblInterview SET tel = p_tel WHERE iSeq = p_iSeq;
    
    UPDATE tblStudent
    SET phone = p_tel
    WHERE ssn = (SELECT ssn FROM tblInterview WHERE iSeq = p_iSeq)
        and name = (SELECT name FROM tblInterview WHERE iSeq = p_iSeq);
    
    DBMS_OUTPUT.PUT_LINE('면접 정보 및 학생 정보가 수정되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END update_interview_tel;
/
------------------------------------면접-삭제
CREATE OR REPLACE PROCEDURE delete_interview (
    p_iSeq NUMBER
) AS
BEGIN
    -- tblInterview에서 해당 iSeq 값 삭제
    DELETE FROM tblInterview WHERE iSeq = p_iSeq;

    -- tblStudent에서 해당 iSeq 값과 관련된 항목 삭제
    DELETE FROM tblStudent WHERE ssn = (SELECT ssn FROM tblInterview WHERE iSeq = p_iSeq)
        and name = (SELECT name FROM tblInterview WHERE iSeq = p_iSeq);
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('오류 발생');
END delete_interview;
/
------------------------------------스터디 조회1
CREATE OR REPLACE PROCEDURE GetStudyStudent
    IS
BEGIN
    FOR study_info IN (
        SELECT
            s.STUDYSEQ AS "스터디번호",
            t.STUDENTSEQ AS "교육생번호",
            t.NAME AS "교육생",
            t.PHONE AS "휴대폰번호",
            s.TOPIC AS "스터디주제"
        FROM TBLSTUDYPERSON p
                 INNER JOIN TBLSTUDY s ON p.STUDYSEQ = s.STUDYSEQ
                 INNER JOIN TBLSTUDYDATA d ON s.STUDYSEQ = d.STUDYSEQ
                 INNER JOIN TBLSTUDENT t ON p.STUDENTSEQ = t.STUDENTSEQ
        )
        LOOP
            
            DBMS_OUTPUT.PUT_LINE('스터디번호: ' || study_info."스터디번호");
            DBMS_OUTPUT.PUT_LINE('교육생번호: ' || study_info."교육생번호");
            DBMS_OUTPUT.PUT_LINE('교육생: ' || study_info."교육생");
            DBMS_OUTPUT.PUT_LINE('휴대폰번호: ' || study_info."휴대폰번호");
            DBMS_OUTPUT.PUT_LINE('스터디주제: ' || study_info."스터디주제");
            DBMS_OUTPUT.PUT_LINE('-----------------------');
        END LOOP;
END GetStudyStudent;
/
------------------------------------스터디 조회2
CREATE OR REPLACE PROCEDURE GetStudyInfo
    IS
BEGIN
    FOR study_info IN (
        SELECT
            s.STUDYSEQ   AS 스터디번호,
            t.STUDENTSEQ AS 교육생번호,
            t.NAME       AS 교육생,
            d.TITLE      AS 제목,
            d.REGDATE    AS 작성일자,
            d.STATUS     AS 파일첨부상태,
            s.STARTDATE  AS 시작일자,
            s.ENDDATE    AS 종료일자
        FROM
            TBLSTUDYPERSON p
                INNER JOIN TBLSTUDY s ON p.STUDYSEQ = s.STUDYSEQ
                INNER JOIN TBLSTUDYDATA d ON s.STUDYSEQ = d.STUDYSEQ
                INNER JOIN TBLSTUDENT t ON p.STUDENTSEQ = t.STUDENTSEQ
        )
        LOOP
           
            DBMS_OUTPUT.PUT_LINE('스터디번호: ' || study_info.스터디번호);
            DBMS_OUTPUT.PUT_LINE('교육생번호: ' || study_info.교육생번호);
            DBMS_OUTPUT.PUT_LINE('교육생: ' || study_info.교육생);
            DBMS_OUTPUT.PUT_LINE('제목: ' || study_info.제목);
            DBMS_OUTPUT.PUT_LINE('작성일자: ' || TO_CHAR(study_info.작성일자, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('파일첨부상태: ' || study_info.파일첨부상태);
            DBMS_OUTPUT.PUT_LINE('시작일자: ' || TO_CHAR(study_info.시작일자, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('종료일자: ' || TO_CHAR(study_info.종료일자, 'YYYY-MM-DD'));
            DBMS_OUTPUT.PUT_LINE('———————————');
        END LOOP;
END GetStudyInfo;
/






commit;
