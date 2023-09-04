-- ex25_rank.sql

/*

	순위 함수
	- rownum > 기반으로 만들어진 함수
	
	1. rank() over(order by 컬럼명 [asc|desc])
	
	2. dense_rank() over(order by 컬럼명 [asc|desc])
	
	3. row_number() over(order by 컬럼명 [asc|desc])



*/

--1.
-- tlbinsa. 급여순으로 가져오시오 + 순위 표시
SELECT name, buseo, basicpay, rownum 
	FROM (SELECT name, buseo, basicpay FROM tblinsa ORDER BY basicpay DESC);
	
SELECT 
	name, buseo, basicpay,
	rank() over(ORDER BY basicpay desc) AS rnum -- 값이 같으면 순위를 똑같이주고 준 만큼 순위 건너뜀
FROM tblinsa;


--2. 
SELECT 
	name, buseo, basicpay,
	dense_rank() over(ORDER BY basicpay desc) AS rnum -- 값이 같으면 순위를 똑같이주고 바로다음 순위
FROM tblinsa;


--3. 
SELECT 
	name, buseo, basicpay,
	row_number() over(ORDER BY basicpay desc) AS rnum -- 값이 같아도 순차적으로 순위 적용
FROM tblinsa;



-- 급여 5위?
SELECT 
	name, buseo, basicpay,
	row_number() over(ORDER BY basicpay desc) AS rnum
FROM tblinsa
	WHERE (row_number() over(ORDER BY basicpay desc)) = 5; -- 오류발생해서 아래로 만들어야됨

SELECT * FROM(SELECT 
				name, buseo, basicpay,
				row_number() over(ORDER BY basicpay desc) AS rnum
			FROM tblinsa)
				WHERE rnum = 8;


-- 순위 함수 + order by
-- 순위 함수 + partition by + order by > 순위 함수 + group by > 그룹별 순위 구하기

SELECT
	name, buseo, basicpay,
	rank() OVER(PARTITION BY buseo ORDER BY basicpay DESC) AS rum
FROM tblinsa;

SELECT * from
	(SELECT
		name, buseo, basicpay,
		rank() OVER(PARTITION BY buseo ORDER BY basicpay DESC) AS rnum
	FROM tblinsa)
		WHERE rnum = 1;





