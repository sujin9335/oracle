
--교사 정보 등록
BEGIN
    INSERT_TEACHER('흐형원', '2221232', '010-1414-5678');
END;

/
select * from tblteacher;
/
----------------------------------------------------------------------------

-- 교사의 강의 가능 과목 입력 (선택적으로 추가)
BEGIN
    InsertAvailableSubject(11, 'HTML');
END;


/
----------------------------------------------------------------------------


--교사 정보 출력
BEGIN
    GetTeacherSubjects;
END;


/
----------------------------------------------------------------------------
--특정 교사 정보 출력

BEGIN
    procOptionTeacher(6); -- 교사의 TEACHERSEQ를 원하는 값으로 변경
END;


/
----------------------------------------------------------------------------

-- 교사 정보 수정 (teacherseq으로 교사 선택)

BEGIN
    UpdateTeacherInfo('17', '흐지훈', '1920921', '010-6734-0102');
END;
/
select * from tblteacher;
/
select * from tblavailablesubject;
/
----------------------------------------------------------------------------

-- 교사 정보 삭제

BEGIN
    DeleteTeacher(11); -- 삭제할 교사의 teacherSeq 값을 입력하세요.
END;



/
select * from tblteacher;
/
----------------------------------------------------------------------------

    -- 전체 교사 평가 점수 확인
BEGIN
    GetAllTeacherRatings;
END;
/


----------------------------------------------------------------------------


-- 전체 교사 평가 평균 점수 확인



BEGIN
    GetTeacherAverageRatings;
END;
/

-------------------------------------------------------------------------


 -- 우수 교사 선정


BEGIN
    SelectExcellentTeachers;
END;
