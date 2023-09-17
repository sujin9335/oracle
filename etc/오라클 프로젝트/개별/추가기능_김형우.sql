--------------------------------------추가기능-------------------------------------------------------------------
-- 스터디 정보 출력시 각 스터디의 참여한 학생의 정보(교육생번호 , 이름 , 전화번호)를 조회할수있다.

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

BEGIN
    GetStudyStudent;
END;

--스터디에 참여한 교육생들의  스터디 시작일자 , 종료일자 스터디 자료의 파일첨부여부 , 작성일자를 조회할수있다

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

begin
    GETSTUDYINFO();
end;
 이거 sql 부탁드릴께요 ㅠㅠ