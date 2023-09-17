--혜진 추가기능
-- 협력기업
-- 조회
CREATE OR REPLACE PROCEDURE GetCompanyRecords IS
BEGIN
    FOR company_rec IN (SELECT * FROM tblCompany) LOOP
        -- 원하는 작업 수행 (예: DBMS_OUTPUT으로 출력)
        DBMS_OUTPUT.PUT_LINE('CompanySeq: ' || company_rec.companySeq || ', Name: ' || company_rec.name || ', Tel: ' || company_rec.tel);
    END LOOP;
END;
/

-- 조회(실행)
DECLARE
    CURSOR company_cursor IS
        SELECT * FROM tblCompany;
    
    v_company_rec tblCompany%ROWTYPE;
BEGIN
    OPEN company_cursor;
    LOOP
        FETCH company_cursor INTO v_company_rec;
        EXIT WHEN company_cursor%NOTFOUND;
        -- 원하는 작업 수행 (예: DBMS_OUTPUT으로 출력)
        DBMS_OUTPUT.PUT_LINE('CompanySeq: ' || v_company_rec.companySeq || ', Name: ' || v_company_rec.name || ', Tel: ' || v_company_rec.tel);
    END LOOP;
    CLOSE company_cursor;
END;
/

-- 추가
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

        COMMIT; -- 변경사항을 커밋
        DBMS_OUTPUT.PUT_LINE('새로운 기업이 추가되었습니다.');
    END;
END;
/

-- 추가(실행)
DECLARE
    v_max_company_seq NUMBER;
BEGIN
    SELECT MAX(companySeq) + 1 INTO v_max_company_seq FROM tblCompany;
    
    INSERT INTO tblCompany (companySeq, name, tel) VALUES (v_max_company_seq, '지니뮤직(주)', '010-5489-2310');

    DBMS_OUTPUT.PUT_LINE('새로운 기업이 추가되었습니다.');
END;
/

-- 수정
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

-- 수정(실행)
DECLARE
    v_company_seq NUMBER := 37; -- 수정할 기업의 companySeq
BEGIN
    UPDATE tblCompany SET name = '(주)지니뮤직' WHERE companySeq = v_company_seq;
    UPDATE tblCompany SET tel = '010-6814-3986' WHERE companySeq = v_company_seq;
    DBMS_OUTPUT.PUT_LINE('기업 정보가 수정되었습니다.');
END;
/

-- 삭제(실행)
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


-- 삭제
DECLARE
    v_company_seq_to_delete NUMBER := 36; -- 삭제할 기업의 companySeq
BEGIN
    DELETE FROM tblCompany WHERE companySeq = v_company_seq_to_delete;
    
    DBMS_OUTPUT.PUT_LINE('기업 정보가 삭제되었습니다.');
END;



-- 취업

--조회
CREATE OR REPLACE PROCEDURE SelectEmploymentData IS
BEGIN
    FOR emp_rec IN (SELECT * FROM tblEmployment) LOOP
        DBMS_OUTPUT.PUT_LINE('employmentSeq: ' || emp_rec.employmentSeq || ', studentSeq: ' || emp_rec.studentSeq || ', status: ' || emp_rec.status);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생' );
END;
/

-- 조회(실행)
DECLARE
BEGIN

    SelectEmploymentData;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/


--추가
CREATE OR REPLACE PROCEDURE InsertEmployment (
    p_studentSeq IN NUMBER
) IS
BEGIN
    INSERT INTO tblEmployment (employmentSeq, studentSeq, status)
    VALUES ((SELECT MAX(employmentSeq) + 1 FROM tblEmployment), p_studentSeq, default);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('INSERT 오류 발생');
END;
/

-- 추가(실행)
BEGIN
    InsertEmployment(245); -- 학생 번호
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/

--수정
CREATE OR REPLACE PROCEDURE insert_employment_for_completed_students (
    p_studentSeq NUMBER
) AS
BEGIN
    INSERT INTO tblEmployment (employmentSeq, studentSeq, status)
    SELECT (SELECT MAX(employmentSeq) + 1 FROM tblEmployment), p_studentSeq, 'N'
    FROM tblStudent
    WHERE complDropStatus = '수료';
    
    DBMS_OUTPUT.PUT_LINE('Employment 정보가 추가되었습니다.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/

-- 수정(실행)
BEGIN
    insert_employment_for_completed_students(245); -- 학생 번호 지정
END;
/

--삭제
CREATE OR REPLACE PROCEDURE DeleteEmployment (
    p_studentSeq IN NUMBER
) IS
BEGIN
    DELETE FROM tblEmployment WHERE studentSeq = p_studentSeq;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/

-- 삭제(실행)
BEGIN
    DeleteEmployment(245);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류 발생');
END;
/


-- 고용보험
-- 조회, 추가, 수정, 삭제
CREATE OR REPLACE PROCEDURE manage_insurance (
    p_studentSeq NUMBER,
    p_action VARCHAR2
) AS
BEGIN
    IF p_action = 'SELECT' THEN
        -- 조회
        FOR rec IN (SELECT * FROM tblInsurance WHERE studentSeq = p_studentSeq) LOOP
            DBMS_OUTPUT.PUT_LINE('Insurance 정보:');
            DBMS_OUTPUT.PUT_LINE('InsuranceSeq: ' || rec.insuranceSeq);
            DBMS_OUTPUT.PUT_LINE('StudentSeq: ' || rec.studentSeq);
            DBMS_OUTPUT.PUT_LINE('Status: ' || rec.status);
        END LOOP;
    ELSIF p_action = 'INSERT' THEN
        -- 추가
        INSERT INTO tblInsurance (insuranceSeq, studentSeq, status)
        SELECT (SELECT MAX(insuranceSeq) + 1 FROM tblInsurance), p_studentSeq, 'N'
        FROM tblEmployment e
        WHERE e.studentSeq = p_studentSeq;
        COMMIT; -- 변경사항을 커밋합니다.
        DBMS_OUTPUT.PUT_LINE('Insurance 정보가 추가되었습니다.');
    ELSIF p_action = 'UPDATE' THEN
        -- 수정
        UPDATE tblInsurance SET status = 'Y' WHERE studentSeq = p_studentSeq;
        COMMIT; -- 변경사항을 커밋합니다.
        DBMS_OUTPUT.PUT_LINE('Insurance 정보가 수정되었습니다.');
    ELSIF p_action = 'DELETE' THEN
        -- 삭제
        DELETE FROM tblInsurance WHERE studentSeq = p_studentSeq;
        COMMIT; -- 변경사항을 커밋합니다.
        DBMS_OUTPUT.PUT_LINE('Insurance 정보가 삭제되었습니다.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('잘못된 동작을 선택하셨습니다.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('오류발생');
END;

-- 실행부 코드
DECLARE
    v_studentSeq NUMBER := 245; -- 학생 번호 지정
BEGIN
    -- 조회
    manage_insurance(v_studentSeq, 'SELECT');
    
    -- 추가
    manage_insurance(v_studentSeq, 'INSERT');
    
    -- 수정
    manage_insurance(v_studentSeq, 'UPDATE');
    
    -- 삭제
    manage_insurance(v_studentSeq, 'DELETE');
END;
/