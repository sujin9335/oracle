-- 문제05.sql


-- 정렬


-- employees
-- 1. 전체 이름(first_name + last_name)이 가장 긴 -> 짧은 사람 순으로 정렬해서 가져오기
--    > 컬럼 리스트 > fullname(first_name + last_name), length(fullname)
SELECT 
	 first_name || last_name AS fullname,
	 length(first_name || last_name)
FROM employees
	ORDER BY LENGTH(first_name) + LENGTH(last_name) desc;



-- 2. 전체 이름(first_name + last_name)이 가장 긴 사람은 몇글자? 가장 짧은 사람은 몇글자? 평균 몇글자?
--    > 컬럼 리스트 > 숫자 3개 컬럼
SELECT
	max(length(first_name || last_name)),
	max(length(first_name || last_name)),
	avg(length(first_name || last_name))
FROM employees;



-- 3. last_name이 4자인 사람들의 first_name을 가져오기
--    > 컬럼 리스트 > first_name, last_name
--    > 정렬(first_name, 오름차순)
SELECT 
	*
FROM employees;

SELECT 
	first_name,
	last_name
FROM employees
	WHERE LENGTH(first_name) = 4
		ORDER BY first_name desc;




-- decode

-- 4. tblInsa. 부장 몇명? 과장 몇명? 대리 몇명? 사원 몇명?
SELECT
	*
FROM tblinsa;
	
SELECT
	count(decode(jikwi, '부장', 1)),
	count(decode(jikwi, '과장', 1)),
	count(decode(jikwi, '대리', 1)),
	count(decode(jikwi, '사원', 1))
FROM tblinsa;



-- 5. tblInsa. 간부(부장, 과장) 몇명? 사원(대리, 사원) 몇명?
SELECT
	count(decode(jikwi, '부장', 1, '과장', 1)),
	count(decode(jikwi, '대리', 1, '사원', 1))
FROM tblinsa;


-- 6. tblInsa. 기획부, 영업부, 총무부, 개발부의 각각 평균 급여?

-- 7. tblInsa. 남자 직원 가장 나이가 많은 사람이 몇년도 태생? 여자 직원 가장 나이가 어린 사람이 몇년도 태생?
















