-- ex12_datetime_function.sql

/*

	날짜 시간 함수
	
	sysdate
	- 현재 시스템의 시각을 반환
	- Calendar.getInstance()
	- date sysdate


*/

/*

	날짜 연산
	1. 시각 - 시각 = 시간
	2. 시각 + 시간 = 시각
	3. 시각 - 시간 = 시각

*/

-- 1. 시각 - 시각 = 시간(일)
SELECT
	name,
	ibsadate,
	round(sysdate - ibsadate) AS 근무일수, -- 1998-10-11 9088.6일
	round((sysdate - ibsadate) / 365) AS 근무년수, --사용금지 
	round((sysdate - ibsadate) * 24) AS 근무시수,
	round((sysdate - ibsadate) * 24 * 60) AS 근무분수,
	round((sysdate - ibsadate) * 24 * 60 * 60) AS 근무초수
FROM tblinsa;

SELECT
	title,
	adddate,
	completedate,
	round((completedate - adddate) * 24) AS 실행하기까지걸린시간 --AS "할일을 실행하기까지 걸린 시간"(너무 길어서 에러뜸) 식별자길이 30byte
FROM tbltodo
	WHERE completedate IS NOT null
	ORDER BY round((completedate - adddate) * 24) DESC;


-- 2. 시각 + 시간 = 시각
-- 3. 시각 - 시간 = 시각
SELECT
	sysdate,
	sysdate + 100 AS "100일뒤",
	sysdate - 100 AS "100일전",
	sysdate + (3 / 24) AS "3시간 후",
	sysdate - (3 / 24) AS "5시간 전",
	sysdate + (30 / 60 / 24) AS "30분 뒤"
FROM dual;


/*

	시각 - 시각 = 시간(일)	> 일 > 시 > 분 > 초 환산 가능
						> 일 > 월 > 년 환산 불가능	

	시각 + 시간(일) = 시각 	> 일, 시, 분, 초 가능
						> 월, 일 불가능
	
	
*/
SELECT sysdate + 3 * 30 FROM dual;

/*

	months_between()
	- number months_between(date, date)
	- 식가 - 시각 = 시간(월)

*/

SELECT
	name,
	round(sysdate - ibsadate) AS "근무일수",
	round((sysdate - ibsadate) / 30) AS "근무일수",
	round(months_between(sysdate, ibsadate)) AS "근무일수",
	round(months_between(sysdate, ibsadate)/ 12) AS "근무일수"
FROM tblinsa;


/* 

	add_months()
	- date add_months(date, 시간)
	- 시각 + 시간(일) = 시각


*/
SELECT
	sysdate,
	add_months(sysdate, 3),
	add_months(sysdate, -2),
	add_months(sysdate, 5 * 12)
FROM dual;


/*

	시각 - 시각
	1. 일, 시, 분, 초 > 연산자(-)
	2. 월, 년 > months_between()
	
	시각 +- 시간
	1. 일, 시, 분, 초 > 연산자(+,-)
	2. 월, 년 > add_months()
	

*/



SELECT
	sysdate,
	last_day(sysdate) -- 해당 날짜가 포함된 마지막 날짜 반환(해당월이 며칠까지?)
FROM dual;








