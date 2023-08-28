-- 참고자료
SELECT * FROM tblCountry;

SELECT * FROM TBLTODO t ;

INSERT INTO TBLTODO (seq, title, adddate, completedate)
	VALUES (22, '자바 복습하기', sysdate, null);
    
    
/*
    select
    vs
    insert, update, delete > commit (마지막에 최종적으로 데이터베이스 원본에적용함)


*/




/*

    연산자, Operator

    1. 산술 연산자
    - +, -, *, /
    - %(없음) > 함수로 제공(mod())

	2. 문자열 연산자(concat)
	- +(X) > ||(O)

	3. 비교 연산자
	- >, >=, <, <=
	- =(==), <>(!=)
	- 논리값 반환 > SQL에는 boolean이 없다 > 명시적으로 표현 불가능 > 조건이 필요한 상황에서
	내부적으로 사용
	- 컬럼 리스트에서 사용 불가
	- 조건절에서 사용
	
	4. 논리 연산자
	- and(&&), or(||), not(!)
	- 논리값 반환
	- 컬럼 리스트에서 사용 불가
	- 조건절에서 사용
	
	5. 대입 연산자
	- =
	- 컬럼 = 값
	- update문
	
	6. 3항 연산자
	- 없음
	- 제어문 없음
	
	7. 증감 연산자
	- 없음
	
	8. SQL 연산자
	- 자바 연산자 > instanceof, typeof 등...
	- in, between, like, is 등..(00절, 00구..)
	
		
			
			
	

*/


    
SELECT
	population,
	area,
	population + area,
	population - area,
	population * area,
	population / area
FROM TBLCOUNTRY ;


SELECT name, couple, name + couple FROM TBLMEN ; -- 오류 나옴
SELECT name, couple, name || couple FROM TBLMEN ; -- ||가 문자열 합


SELECT HEIGHT, WEIGHT HEIGHT > WEIGHT FROM TBLMEN ;

SELECT height, weight FROM TBLMEN WHERE height > weight;



SELECT name, age FROM TBLMEN; -- 이전 나이(한국식)

-- 컬럼의 별칭(Alias)
-- : 되도록 가공된 컬럼에 적용
-- : 함수 결과에 적용
-- : *** 컬럼명이 식별자로 적합하지 않을 때 사용 > 적합한 식별자로 수정
-- : 식별자로 사용 불가능 상황 > ""사용 권장 x
SELECT 
	name AS 이름,
	age, 
	age -1 AS 나이, 
	length(name) AS 길이,
	COUPLE AS 여자친구 --(띄어쓰기 사용시 "" 쓸수있으나 권장x)
	--name AS select 사용x
FROM TBLMEN ; -- 컬럼명(***)
-- 컬럼명(***)


-- 테이블 별칭(Alias)
-- : 편하게.. + 가독성 향상
SELECT * FROM TBLMEN t;

SELECT  hr.tblMen.name, hr.tblMen.age, hr.tblMen.height, hr.tblMen.weight, hr.tblMen.couple 
FROM hr.TBLMEN;

SELECT tblMen.name, tblMen.age, tblMen.height, tblMen.weight, tblMen.couple FROM TBLMEN ;

-- 각 절의 실행 순서
-- 2. select 절
-- 1. from 절

SELECT m.name, m.age, m.height, m.weight, m.couple 
FROM TBLMEN m;


SELECT name, age, height, weight, couple FROM TBLMEN ;



    