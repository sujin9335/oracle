-- ex17_delete.sql

/*

	DELETE
	- DML
	- 원하는 행을 삭제하는 명령어
	
	DELETE
	- delete [from] 테이블명 [where 절]


*/
COMMIT;
ROLLBACK;

SELECT * FROM tblinsa;

DELETE FROM tblinsa WHERE num = 1001;
DELETE FROM tblinsa;











