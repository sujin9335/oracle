-- ex11_casting_function.sql


/*

	형변환 함수
	- (int)num
	
	1. to_char(숫자)		: 숫자 > 문자
	2. to_char(날짜)		: 날짜 > 문자 ***
	3. to_number(문자)	: 문자 > 숫자 
	4. to_date(문자)		: 문자 > 날짜 ***
	
	
	
	
	1. to_char(숫자 [, 형식문자열])
	
	형식 문자열 구성요소
	a. 9: 숫자 1개를 문자 1개로 바꾸는 역할. 빈자리를 스페이스로 치환 > %5d
	b. 0: 숫자 1개를 문자 1개로 바꾸는 역할. 빈자리를 0으로 치환 > %05d
	c. $: 통화 기호 표현
	d. L: 통화 기호 표현(Locale)
	e. .: 소숫점
	f. ,: 천단위
	
	
	

*/


SELECT
	weight,
	to_char(weight),
	length(to_char(weight)),	--문자열 함수
	length(weight), 			-- weight > (암시적 형변환) > 문자열
	substr(weight, 1, 1),
	weight || 'kg',
	to_char(weight) || 'kg'
FROM tblcomedian;

SELECT
	weight,
	'@' || to_char(weight) || '@',
	'@' || to_char(weight, '99999') || '@',		-- @    64@ (9가 자릿수결정)
	'@' || to_char(-weight, '99999') || '@',	-- @   -64@
	'@' || to_char(weight, '00000') || '@',	
	'@' || to_char(-weight, '00000') || '@'
FROM tblcomedian;


SELECT
	100,
	'$'||100,
	to_char(100, '$999'),
	--to_char(100, '999달러'),
	100||'달러',
	to_char(100, 'L999')
FROM dual;


SELECT
	1234567.89,
	to_char(1234567.89, '9,999,999.99'), --%,d
	ltrim(to_char(567.89, '9,999,999.9')),
	to_char(22231234567.89, '9,999,999.9') -- ########(9를 여유롭게 최대치로 미리 설정해야된다)
FROM dual;



/*


	2. to_char(날짜)
	- 날짜 > 문자
	- char to_char(칼럼, 형식문자열)
	
	형식문자열 구성요소
	a. yyyy
	b. yy
	c. month
	d. mon
	e. mm
	f. day
	g. dy
	h. ddd
	i. dd
	j. d
	k. hh
	l. hh24
	m. mi
	n. ss
	o. am(pm)

*/

SELECT sysdate FROM dual;
SELECT to_char(sysdate) FROM dual; --23/09/04
SELECT to_char(sysdate, 'yyyy') FROM dual;	--년(4자리)            --2023
SELECT to_char(sysdate, 'yy') FROM dual;	--년(2자리)            --23
SELECT to_char(sysdate, 'month') FROM dual;	--월(풀네임)            --9월
SELECT to_char(sysdate, 'mon') FROM dual;	--월(약어) 영어일시 aug  --9월
SELECT to_char(sysdate, 'mm') FROM dual;	--월(2자리)            --09
SELECT to_char(sysdate, 'day') FROM dual;	--요일(풀네임)          --월요일
SELECT to_char(sysdate, 'dy') FROM dual;	--요일(약어)            --월
SELECT to_char(sysdate, 'ddd') FROM dual;	--일(올해의 며칠)        --247
SELECT to_char(sysdate, 'dd') FROM dual;	--일(이번달의 며칠)      --04
SELECT to_char(sysdate, 'd') FROM dual;		--일(이번주의 며칠) == 요일(숫자) --2
SELECT to_char(sysdate, 'hh') FROM dual;	--시(12시)              --12
SELECT to_char(sysdate, 'hh24') FROM dual;	--시(24시)              --00
SELECT to_char(sysdate, 'mi') FROM dual;	--분                    --22
SELECT to_char(sysdate, 'ss') FROM dual;	--초                    --51
SELECT to_char(sysdate, 'am') FROM dual;	--오전/오후              --오전
SELECT to_char(sysdate, 'pm') FROM dual;	--오전/오후              --오전

-- 암기 !!
select
	sysdate,
	to_char(sysdate, 'yyyy-mm-dd'),
	to_char(sysdate, 'hh24:mi:ss'),
	to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'),
	to_char(sysdate, 'day am hh hh24:mi:ss') --화요일 오후 02 14:48:29
FROM dual;

SELECT
	name,
	to_char(ibsadate, 'yyyy-mm-dd') AS ibsadate,
	to_char(ibsadate, 'day') AS DAY,
	CASE
		WHEN to_char(ibsadate, 'd') IN ('1', '7') THEN '휴일 입사'
		ELSE '평일입사'
	END
FROM tblinsa;


-- 요일별 입사 인원수?
SELECT
	count(CASE
		WHEN to_char(ibsadate, 'd') = '1' THEN 1		
	END) AS 일요일,
	count(decode(to_char(ibsadate, 'd'), '2', 1)) AS 월요일,
	count(decode(to_char(ibsadate, 'd'), '3', 1)) AS 화요일,
	count(decode(to_char(ibsadate, 'd'), '4', 1)) AS 수요일,
	count(decode(to_char(ibsadate, 'd'), '5', 1)) AS 목요일,
	count(decode(to_char(ibsadate, 'd'), '6', 1)) AS 금요일,
	count(decode(to_char(ibsadate, 'd'), '7', 1)) AS 토요일
FROM tblinsa;


-- SQL에는 날짜 상수(리터럴)이 없다

-- 입사날짜 > 2000년 이후
SELECT * FROM tblinsa WHERE ibsadate >= '2000-01-01'; -- 문자열 > 암시적 형변환


-- 입사날짜 > 2000년 ~ 2001년 사이
SELECT * FROM tblinsa
	WHERE ibsadate >= '2000-01-01' AND ibsadate <= '2000-12-31'; -- 오답 2000-12-31이 자정이라 23:59:59 가 맞음

SELECT * FROM tblinsa
	WHERE to_char(ibsadate, 'yyyy') = '2000';

	
	
-- 3. to_number(문자)

SELECT
	'123' * 2, --암시적 형변환
	to_number('123') * 2
FROM dual;



-- 4. date to_date(문자, 형식문자열)

SELECT
	'2023-08-29', --자료형?
	to_date('2023-08-29'),
	to_date('2023-08-29', 'yyyy-mm-dd'),
	to_date('20230829'),
	to_date('20230829', 'yyyymmdd'),
	to_date('2023/08/29'),
	to_date('2023/08/29', 'yyyy/mm/dd'),
--	to_date('2023년08월29일', 'yyyy년mm월dd일') --한글은 안됨
	to_date('2023-08-29 15:28:39', 'yyyy-mm-dd hh24:mi:ss')
FROM dual;


SELECT * FROM tblinsa
	WHERE ibsadate >= to_date('2000-01-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
		AND ibsadate <= to_date('2000-12-31 23:59:59', 'yyyy-mm-dd hh24:mi:ss')






