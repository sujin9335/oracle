-- ex06_column.sql

-- 컬럼 리스트에서 할 수 있는 행동
-- select 컬럼 리스트

-- 컬럼 명시
SELECT * FROM TBLINSA ;

SELECT NAME, SSN FROM TBLINSA ;

-- 연산
SELECT NAME||'님', BASICPAY*2 FROM TBLINSA ;

-- 상수
SELECT 100, '홍길동' FROM TBLINSA ;


/*

	Java Stream > list.stream().distinct().forEach()
	
	distinct
	- 컬럼 리스트에서 사용
	- 중복값 제거
	- distinct 컬럼명(x) > distinct 컬림리스트(o)

*/

SELECT DISTINCT CONTINENT FROM TBLCOUNTRY ;

-- tblInsa. > 수많은 부서 > 어떤 부서가 있습니까? > 중복값 제거
SELECT DISTINCT BUSEO FROM TBLINSA ;

SELECT DISTINCT JIKWI FROM TBLINSA ;

SELECT DISTINCT NAME FROM TBLINSA ;


SELECT 
	DISTINCT BUSEO , NAME -- DISTINCT 는 뒤에나온 buseo 와 name 을 한묶음으로 본다
FROM TBLINSA ;

SELECT 
	DISTINCT NAME ,	BUSEO  
FROM TBLINSA ;

SELECT 
	DISTINCT BUSEO , JIKWI  
FROM TBLINSA ;



/*

	case
	- 대부분의 절에서 사용 가능
	- 조건문 역할 > 컬럼값 조작
	- 조건을 만족하지 못하면 null을 반환(******************)

*/

SELECT 
	LAST || FIRST AS name,
	GENDER -- 성별이 m, f로 나옴
FROM TBLCOMEDIAN ;

SELECT 
	LAST || FIRST AS name,
	CASE --({) { 열기
		--WHEN 조건 THEN 값
		WHEN GENDER = 'm' THEN '남자'
		WHEN GENDER = 'f' THEN '여자'
	END AS GENDER --(}) } 닫기
FROM TBLCOMEDIAN ;


SELECT 
	NAME, CONTINENT,
	CASE 
		WHEN CONTINENT = 'AS' THEN '아시아'
		WHEN CONTINENT = 'EU' THEN '유럽'
		WHEN CONTINENT = 'AF' THEN '아프리카'
		--ELSE '기타'
		--ELSE CONTINENT
		--ELSE 100 -- 위에랑 동일한 타입(문자)으로 나와야되서 오류나옴
		ELSE CAPITAL 
	END AS continentName
FROM TBLCOUNTRY ;



SELECT 
	LAST || FIRST AS name,
	WEIGHT,
	CASE 
		WHEN WEIGHT >= 50 AND WEIGHT <= 90 THEN '정상체중'
		ELSE '주의체중'
	END AS state
FROM TBLCOMEDIAN ;

SELECT 
	LAST || FIRST AS name,
	WEIGHT,
	CASE 
		WHEN WEIGHT BETWEEN 50 AND 90 THEN '정상체중'
		ELSE '주의체중'
	END AS state
FROM TBLCOMEDIAN ;


SELECT 
	NAME, JIKWI ,
	CASE
		WHEN JIKWI = '과장' OR JIKWI = '부장' THEN '관리직'
		ELSE '생산직'
	END,
	CASE
		WHEN JIKWI IN ('과장', '부장') THEN '관리직'
		ELSE '생산직'
	END
FROM TBLINSA ;

SELECT 
	NAME , SUDANG ,
	CASE
		WHEN NAME LIKE '홍%' THEN 50000
		ELSE 0
	END + SUDANG 
FROM TBLINSA ;


SELECT 
	TITLE,
	CASE 
		WHEN COMPLETEDATE IS NULL THEN '미완료'
		WHEN COMPLETEDATE IS NOT NULL THEN '완료'
	END AS status
FROM TBLTODO ;











