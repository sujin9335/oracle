-- ex25_transaction.sql

/*

	트랜잭션, Transaction
	- 데이터를 조작하는 업무의 물리적(시간적) 단위(행동의 범위)
	- 1개 이상의 명령어를 묶어 놓은 단위
	
	트랜잭션 관련 명령어, DCL(TCL)
	1. commit
	2. rollback
	3. savepoint


*/

CREATE TABLE tblTrans
AS
SELECT name, buseo, jikwi FROM tblinsa WHERE city = '서울';

SELECT * FROM tbltrans;

-- 우리가 하는 행동 > 시간순으로 기억(******)

-- 로그인 직후(접속) > 트랜잭션이 시작함
-- 트랜잭션 > 모든 명령어(X) > INSERT, UPDATE, DELETE 명령어만 트랜잭션에 포함된다
-- INSERT, UPDATE, DELETE 작업 > 오라클 적용(X), 임시 메모리 적용(O)

DELETE FROM tblTrans WHERE name = '박문수'; --트랜잭션에 포함

SELECT * FROM tbltrans; --트랜잭션과 무관

COMMIT;
ROLLBACK; --현재 트랜잭션에서 했던 모든 행동을 데이터베이스에 적용하지 말고 취소해라!!

SELECT * FROM tbltrans;

DELETE FROM tblTrans WHERE name = '박문수';

SELECT * FROM tbltrans;

COMMIT; --현재 트랜잭션에서 했던 모든 행동을 데이터베이스에 적용한다



DELETE FROM tblTrans WHERE name = '김미나';

SELECT * FROM tbltrans;

INSERT INTO tbltrans VALUES ('호호호', '기획부', '사원');

DELETE FROM tblTrans WHERE name = '호호호';


/*

	트랜잭션이 언제 시작해서 ~ 언제 끝나는지?
	
	새로운 트랜잭션이 시작하는 시점
	1. 클라이언트 접속 직 후
	2. commit 실행 직 후
	3. rollback 실행 직 후
	
	현재 트랜잭션이 종료되는 시점
	1. commit > 현재 트랜잭션을 종료 + DB에 반영
	2. rollback > 현재 트랜잭션을 종료 + DB에 반영 안함
	3. 클라이언트 접속 종료
		a. 정상 종료
			- 현재 트랜잭션에 아직 반영이 안된 명령어가 남아있는데 > 어떻게? 질문 (commit 할건지 경고창나옴)
		b. 비정상 종료
			- 메모리 상(트랜잭션)의 모든 작업의 반영이 될만한 틈이 없이 강제 종료
			- rollback 이 됨
	4. DDL 실행
		- CREATE, ALTER, DROP > 실행 > 즉시 commit 실행
		- DDL 성격 > 구조 변경 > 데이터 영향 끼침 > 사전에 미리 저장(commit) 

*/


UPDATE tbltrans SET jikwi = '부장' WHERE name = '김말자';

SELECT * FROM tbltrans;

COMMIT;

SELECT * FROM tbltrans;

UPDATE tbltrans SET jikwi = '부장' WHERE name = '김말자';

SELECT * FROM tbltrans;


COMMIT;

UPDATE tbltrans SET jikwi = '사장' WHERE name = '김말자';

SELECT * FROM tbltrans;


-- 시퀀스 객체 생성
CREATE SEQUENCE seqTrans;

ROLLBACK;

SELECT * FROM tbltrans;



-- savepoint 라벨;

COMMIT;

SELECT * FROM tbltrans; -- 김말자	기획부	사장

INSERT INTO tbltrans VALUES ('후후후', '기획부', '직원');

SAVEPOINT a;

DELETE FROM tbltrans WHERE name = '김말자';

SAVEPOINT b;

UPDATE tbltrans SET buseo = '개발부' WHERE name = '후후후';

SELECT * FROM tbltrans;


ROLLBACK TO b;

SELECT * FROM tbltrans;

ROLLBACK TO a;

SELECT * FROM tbltrans;

ROLLBACK;

SELECT * FROM tbltrans;
