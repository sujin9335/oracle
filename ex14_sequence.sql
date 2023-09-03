-- ex14_sequence.sql

/*

	시퀀스, Sequence
	- 데이터베이스 객체 중 하나
	- 오라클 전용 객체(다른 DBMS 제품에는 없음)
	- 일련 번호를 생성하는 객체(***)
	- (주로) 식별자(일련번호)를 만드는데 사용한다. > pk 값으로 사용한다
	
	시퀀스 객체 생성하기
	- create sequence 시퀀스명;
	
	시퀀스 객체 삭제하기
	- drop sequence 시퀀스명;
	
	시퀀스 객체 사용하기(함수)
	- 시퀀스객체.nextVal(***)
	- 시퀀스객체.currVal
	
	

*/

CREATE SEQUENCE seqNum;

SELECT seqNum.nextVal FROM dual; --일련 번호 생성



DELETE FROM tblmemo;

SELECT * FROM tblmemo;

CREATE SEQUENCE seqMemo;

INSERT INTO tblmemo (seq, name, memo, regdate)
	VALUES (seqMemo.nextVal, '홍길동', '메모입니다.', sysdate);


-- 쇼핑몰 > 상품 번호 > ABC100
SELECT 'A' || seqNum.nextVal FROM dual; --all


-- nextVal 호출하면 나오게될 숫자를 반환
-- Queue, stack > pop() / peak()
SELECT seqNum.currVal FROM dual; 

-- 프로그램 껏다키면 ORA-08002: sequence SEQNUM.CURRVAL is not yet defined in this session
-- currVal는 최소 1번 이상의 nextVal를 호출해야 사용이 가능하다 (그래서 잘안씀)

SELECT seqNum.nextVal FROM dual;


/*

	시퀀스 객체 생성하기
	
	create sequence 시퀀스명;
	
	create sequence 시퀀스명 
				increment by n	--증감치(양수/음수)
				start with n 	--시작값(Seed)
				maxvalue n 		--최댓값
				minavlue n 		--최솟값
				cycle n			--순환
				cache n;		--임시 저장

*/


DROP SEQUENCE seqTest;

CREATE SEQUENCE seqTest
				--INCREMENT BY -1;
				--START WITH 10;
				--MAXVALUE 10
				--CYCLE
				CACHE 20; 

SELECT seqTest.nextVal FROM dual;

--ORA-12505, TNS:listener does not currently know of SID given in connect descriptor
SELECT * FROM tblInsa;-- 오라클 강제종료시 호출을 못함








