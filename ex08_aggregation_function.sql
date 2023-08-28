-- ex08_aggregation_function.sql


/*
	
	함수, Function
	1. 내장형 함수(Built-in Function)
	2. 사용자 정의 함수(User Function > ANSI-SQL(X), PL/SQL(O)
	
	집계 함수, Aggregation Function(***********************)
	- 아주 쉬움 > 뒤에 나오는 수업과 결합 > 꽤 어려움;;
	1. count()
	2. sum()
	3. avg()
	4. max()
	5. min()
	
	1. count()
	- 결과 테이블의 레코드 수를 반환한다.
	- number count(컬럼명)
	- null 값은 카운트에서 제외된다(****)

*/

-- tblCountry 총 나라 몇개국?
SELECT count(*) FROM tblcountry;			--14(모든 레코드, 일부 컬럼에 null 무관)
SELECT count(name) FROM tblcountry;			--14
SELECT count(population) FROM tblcountry;	--13

SELECT * FROM tblcountry;			--14
SELECT name FROM tblcountry;		--14
SELECT population FROM tblcountry;	--13


-- 모든 직원수?
SELECT count(*) FROM tblinsa; --60

-- 연락처가 있는 직원수?
SELECT count(tel) FROM tblinsa; --57

-- 연락처가 없는 직원수?
SELECT count(*) - count(tel) FROM tblinsa; --3

SELECT count(*) FROM tblinsa WHERE tel IS NOT NULL; --57
SELECT count(*) FROM tblinsa WHERE tel IS NULL; --3


-- tblInsa. 어떤 부서들이 있나요?
SELECT DISTINCT buseo FROM tblinsa;

-- tblInsa. 부서가 총 몇개?
SELECT count(DISTINCT buseo) FROM tblinsa;

-- tblComedian. 남자수? 여자수?
SELECT * FROM tblcomedian;

SELECT count(*) FROM tblcomedian WHERE gender = 'm';
SELECT count(*) FROM tblcomedian WHERE gender = 'f';

-- 남자수 + 여자수 > 1개의 테이블로 가져오시오 *** 자주 사용되는 패턴
SELECT 
	count(CASE
		WHEN gender = 'm' THEN 1
	END),
	count(CASE
		WHEN gender = 'f' THEN 1
	END)
FROM tblcomedian;



-- tblInsa. 기획부 몇명?, 총무부 몇명?, 개발부 몇명?, 총인원?, 나머지부서 몇명?
SELECT count(*) FROM tblinsa WHERE buseo = '기획부'; --7
SELECT count(*) FROM tblinsa WHERE buseo = '총무부'; --7
SELECT count(*) FROM tblinsa WHERE buseo = '개발부'; --14

SELECT
	count(CASE
		WHEN buseo = '기획부' THEN '0'		
	END) AS 기획부,
	count(CASE
		WHEN buseo = '총무부' THEN '0'		
	END) AS 총무부,
	count(CASE
		WHEN buseo = '개발부' THEN '0'		
	END) AS 개발부
	count(*) 전체인원수,
	count(
		CASE
			WHEN buseo NOT IN ('기획부', '총무부', '개발부') THEN '0'
		END
	) AS 나머지
FROM tblinsa




