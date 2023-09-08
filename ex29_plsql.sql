-- ex29_plsql.sql

/*

	PL/SQL
    - Oracle's Procedural Language extension to SQL
    - 기존의 ANSI-SQL + 절차 지향 언어 기능 추가
    - ANSI-SQL + 확장팩(변수, 제어 흐름(제어문), 객체(메소드) 정의)

    프로시저, Preocedure
    - 메서드, 함수 등..
    - 순서가 있는 명령어의 집합
    - 모든 PL/SQL 구문은 프로시저내에서만 작성/동작이 가능하다
    - 프로시저 아닌 영역 > ANSI-SQL 영역
    
    1. 익명 프로시저
        - 1회용 코드 작성용
        
    2. 실명 프로시저
        - 데이터베이스 객체
        - 저장용
        - 재호출


    PL/SQL 프로시저 구조
    
    1. 4개의 블럭(키워드)으로 구성
        - DECLARE
        - BEGIN
        - EXCEPTION
        - END

    2. DECLARE
        - 선언부
        - 프로시저내에서 사용할 변수, 객체 등을 선언하는 영역
        - 생략 가능
    
    3. BEGIN ~ END
        - 실행부, 구현부
        - 구현부 코드를 가지는 영역(메서드의 body 영역)
        - 생략 불가능
        - 구현된 코드 > ANSI-SQL + PL/SQL(연산, 제어 등)
        
    4. EXCEPTION
        - 예외처리부
        - catch 역할, 3번 영역 try 역할
        - 생략 가능

    
    자료형 + 변수
    
    
    PL/SQL 자료형
    - ANSI-SQL과 동일

    
    변수 선언하기
    - 변수명 자료형 [not null] [default 값];
    
    
    PL/SQL 연산자
    - ANSI-SQL과 동일
    
    
    대입 연산자
    - ANSI-SQL 대입 연산자
        ex) update table set colum = '값';
    - PL/SQL 대입 연산자
        ex) 변수 := '값';


*/

set serveroutput on; -- 현재 세션에서만 유효(접속 해제 > 초기화;;)
set serverout on;

set serveroutput off;

-- 익명 프로시저
declare
    num number;
    name varchar2(30);
    today date;
begin

    num := 10;
    dbms_output.put_line(num); --syso
    
    name := '홍길동';
    dbms_output.put_line(name);
    
    today := sysdate;
    dbms_output.put_line(today);
    
    
end;
/

/-- 프로시저 ctrl+엔터 나누는 구분
declare
    num1 number;
    num2 number;
    num3 number := 30;
    num4 number default 40;
    num5 number not null; -- declare 블럭에서 선언과 동시에 초기화를 해야됨 (구현부 x)
begin

    dbms_output.put_line(num1); --null
    
    num2 := 20;
    dbms_output.put_line(num2);
    
    dbms_output.put_line(num3);
    
    dbms_output.put_line(num4); --null일경우 디폴트값 40출력
    
    num5 := 50;
    dbms_output.put_line(num5); --값을 넣어줘도 선언과 동시에 초기화 안해서 오류

end;
/

/*

    변수 > 어떤 용도로 사용?
    - select 결과를 담는 용도(**************************)
    - select into 절(PL/SQL)

*/
/
declare
    vbuseo varchar2(15);
begin
    
    --vvuseo := select buseo from tblInsa where name = '홍길동'; --이렇게하면 안됨
    
    select buseo into vbuseo from tblInsa where name = '홍길동'; -- into 사용 O
    dbms_output.put_line(vbuseo);

--    select buseo from tblInsa where name = '홍길동'; -- 얘도 이렇게 쓰면안됨
--    dbms_output.put_line(buseo);

end;
/

begin
    -- PL/SQL 프로시저안에는 순수한 select 문은 올 수 없다.(절대)
    -- PL/SQL 프로시저안에는 select into문만 사용한다
    select buseo from tblInsa where name = '홍길동';
end;
/

-- 성과급 받는 직원명
create table tblName(
    name varchar2(15)
);


-- 1. 개발부 + 부장 + > select > name?
-- 2. tblName > name > insert

insert into tblname (name)
    values ((select name from tblInsa where buseo ='개발부' and jikwi = '부장'));
    
/
declare
    vname varchar2(15);
begin

    --1
    select name into vname from tblInsa where buseo ='개발부' and jikwi = '부장';
    
    --2
    insert into tblName (name) values (vname);
    
    
end;
/

select * from tblName;


declare
    vname varchar2(15);
    vbuseo varchar2(15);
    vjikwi varchar2(15);
    vbasicpay number;
    
begin

--    select name into vname, buseo into vbuseo, jikwi into vjikwi, basicpay into vbasicpay
--        from tblInsa where num = 1001;-- 이렇게 하면안됨
        
    -- into 사용시
    -- 1. 컬럼의 개수와 변수의 개수 일치
    -- 2. 컬럼의 순서와 변수의 순서 일치
    -- 3. 컬럼의 변수 자료형과 일치
    select name, buseo, jikwi, basicpay into vname, vbuseo, vjikwi, vbasicpay
        from tblInsa where num = 1001;
    
    dbms_output.put_line(vname);
    dbms_output.put_line(vbuseo);
    dbms_output.put_line(vjikwi);
    dbms_output.put_line(vbasicpay);
    
end;
/

desc tblInsa;


/*

    타입 참조
    
    %type
    - 사용하는 테이블의 특정 컬럼값의 스키마를 알아내서 변수에 적용
    - 복사되는 정보
        a. 자료형
        b. 길이
    - 컬럼 1개 참조
    
    %rowtype
    - 행 전체 참조(여러개의 컬럼을 한번에 참조)
    - %type의 집합형
    - 레코드 전체(여러개 컬럼)을 하나의 변수에 저장 가능
    
*/
/
declare
--    vbuseo varchar2(15);
    vbuseo tblInsa.buseo%type;
begin

    select buseo into vbuseo from tblInsa where name = '홍길동';
    dbms_output.put_line(vbuseo);
    
end;
/

declare
    vname tblInsa.name%type;
    vbuseo tblInsa.buseo%type;
    vjikwi tblInsa.jikwi%type;
    vbasicpay tblInsa.vbasicpay%type;
    
begin

    select name, buseo, jikwi, basicpay into vname, vbuseo, vjikwi, vbasicpay
        from tblInsa where num = 1001;
    
    dbms_output.put_line(vname);
    dbms_output.put_line(vbuseo);
    dbms_output.put_line(vjikwi);
    dbms_output.put_line(vbasicpay);
    
end;
/


--직원 중 일부에게 보너스 지급(급여 * 1.5) > 내역 저장
create table tblBonus(
    seq number primary key,
    num number(5) not null references tblInsa(num), --직원번호(FK)
    bonus number not null
);

/
declare
    vnum tblInsa.num%type;
    vbasicpay tblInsa.basicpay%type;
begin

    select num, basicpay into vnum, vbasicpay 
        from tblInsa where city = '서울' and jikwi = '부장' and buseo = '영업부';

    insert into tblBonus (seq, num, bonus)
        values ((select nvl(max(seq), 0) +1 from tblBonus), vnum, vbasicpay * 1.5);

end;
/
select * from tblBonus;

select * from tblBonus b
    inner join tblInsa i
        on i.num = b.num; 
        
        
select * from tblMen;
select * from tblWomen;

--무명씨 > 성전환 수술 > tblMen -> tblWomen 옮기기
--1. '무명씨' > tblMen >select 
--2. tblWomen > insert 
--3. tblMen > delete


/
declare
    vname tblMen.name%type;
    vage tblMen.age%type;
    vheight tblMen.height%type;
    vweight tblMen.weight%type;
    vcouple tblMen.couple%type; 
begin
    select name, age, height, weight, couple into vname, vage, vheight, vweight, vcouple 
        from tblmen where name = '무명씨';
    dbms_output.put_line(vcouple);
    insert into tblWomen (name ,age, height, weight, couple)
        values (vname , vage, vheight, vweight, vcouple);
        
    delete from tblMen where name = '무명씨';
    
end;
/      
        
select * from tblwomen;
select * from tblmen;
        
        
-- %rowtype
declare
--    vname tblMen.name%type;
--    vage tblMen.age%type;
--    vheight tblMen.height%type;
--    vweight tblMen.weight%type;
--    vcouple tblMen.couple%type;

    vrow tblmen%rowtype; -- vrow : tblMen 의 레코드 1개(모든 컬럼값)를 저장 할 수 있는 변수
    
begin

    --1.
    select 
        * into vrow         
    from tblMen where name = '정형돈';
    
    dbms_output.put_line(vrow.name);
    dbms_output.put_line(vrow.age);
    dbms_output.put_line(vrow.height);
    dbms_output.put_line(vrow.weight);
    dbms_output.put_line(vrow.couple);
    
    --2.
    insert into tblWomen (name, age, height, weight, couple)
        values (vrow.name, vrow.age, vrow.height, vrow.weight, vrow.couple);

    --3.
    delete from tblMen where name = vrow.name;

end;


------------------------------------------------------------------

/*

    제어문
    1. 조건문
    2. 반복문
    3. 분기문
    

*/

--if
declare
    vnum number := -10;
begin
    if vnum > 0 then
       dbms_output.put_line('양수');
    end if;

end;



--else
declare
    vnum number := -10;
begin
    if vnum > 0 then
        dbms_output.put_line('양수');
    else
        dbms_output.put_line('음수');
    end if;

end;



--elseif
declare
    vnum number := 0;
begin
    if vnum > 0 then
        dbms_output.put_line('양수');
    elsif vnum < 0 then
        dbms_output.put_line('음수');
    else
        dbms_output.put_line('0');
    end if;

end;


-- tblInsa 남자 직원 / 여자 직원 > 다른업무
declare
    vgender char(1);
begin
    select substr(ssn, 8, 1) into vgender from tblInsa where num = 1035;

    if vgender = '1' then
        dbms_output.put_line('남자 직원');
    elsif vgender = '2' then
        dbms_output.put_line('여자 직원');
    end if;

end;


-- 직원 1명 선택 > 보너스 지급
-- 차등 지급
-- a. 과장/부장 > basicpay * 1.5
-- b. 대리/사원 > basicpay * 2
declare
    vnum tblInsa.num%type;
    vbasicpay tblInsa.basicpay%type;
    vjikwi tblInsa.jikwi%type;
    vbonus number;
begin
    select num, basicpay, jikwi into vnum, vbasicpay, vjikwi
        from tblInsa where num = 1040;

    if vjikwi = '과장' or vjikwi = '부장' then
        vbonus := vbasicpay * 1.5;
    elsif vjikwi in ('사원', '대리') then
        vbonus := vbasicpay * 2;
    end if;
    dbms_output.put_line(vbonus);
    
end;


/*
    
    case문
    - ANSI-SQL의 case문과 거의 유사
    - 자바의 switch문, 다중 if문


*/



declare
    vcontinent tblCountry.continent%type;
    vresult varchar2(30);
begin
    select continent into vcontinent from tblCountry where name = '영국';
    if vcontinent = 'AS' then
        vresult := '아시아';
    elsif vcontinent = 'EU' then
        vresult := '유럽';
    elsif vcontinent = 'AF' then
        vresult := '아프리카';
    else
        vresult := '기타';
    end if;
    dbms_output.put_line(vresult);
    
    case
        when vcontinent = 'AS' then vresult := '아시아';
        when vcontinent = 'EU' then vresult := '유럽';
        when vcontinent = 'AF' then vresult := '아프리카';
        else vresult := '기타';
    end case;
    dbms_output.put_line(vresult);
    
    case vcontinent
        when 'AS' then vresult := '아시아';
        when 'EU' then vresult := '유럽';    
        when 'AF' then vresult := '아프리카';
        else vresult := '기타';
     end case;
     dbms_output.put_line(vresult);
end;

/*

    반복문
    
    1. loop
        - 단순 반복
    
    2. for loop
        - 횟수 반복(자바 for)
        - loop 기반
    
    3. while loop
        - 조건 반복(자바 while_
        - loop 기반


*/

--무한 루프
begin
    loop
        dbms_output.put_line('100');
    end loop;
end;


declare
    vnum number := 1;
begin
    loop
        dbms_output.put_line(vnum);
        vnum := vnum + 1;
        
        exit when vnum > 10; --조건부 break
        
    end loop;
end;


create table tblLoop(

    seq number primary key,
    data varchar2(100) not null
);

create sequence seqLoop;

-- 데이터 x 1000건 추가
-- data > '항목1', '항목2', .. 항목1000'
/
declare 
    vnum number := 1;
begin
    loop
        insert into tblLoop values (seqLoop.nextVal, '항목' || vnum);
        vnum := vnum + 1;
        exit when vnum > 1000;
    end loop;

end;
/
select * from tblLoop;



-- 2. for loop

/*
    java의 향상된 for문
    - foreach문
    - for in
    
    for (int n : list) {
    }
    
    for (int n in list) {
    }

*/

begin
    
    for i in 1..10 loop
        dbms_output.put_line(i);
    end loop;

end;

--구구단으로 연습하기
--Case 1)테이블 수준에서 제약사항 설정
create table tblGugudan (
--PK키가 될만한 컬럼이 없다. > 인조키를 만들 수 있겠지만 이번엔 dan과 num 복합키를 PK로!!
--table can have only one primary key. > 컬럼 수준에서는 복합키 선언 불가. > 테이블 수준에서는 복합키 선언 가능.


    dan number not null,
    num number not null,
    result number not null,
    constraint tblgugudan_dan_num_pk primary key(dan, num) --복합키(Composite Key) 선언 방법
);

drop table tblGugudan;

--Case 2) 외부에서 제약사항 설정
create table tblGugudan (
    dan number not null,
    num number not null,
    result number not null
);

alter table tblGugudan
    add constraint tblgugudan_dan_num_pk primary key(dan, num);



begin
    for dan in 2..9 loop
        for num in 1..9 loop
            insert into tblGugudan (dan, num, result)
                values (dan, num, dan * num);
            end loop;
    end loop;
end; 


-- reverse
begin
    
    for i in reverse 1..10 loop
        dbms_output.put_line(i);
    end loop;

end;




-- 3. while loop
declare
    vnum number := 1;
begin
    
    loop
        dbms_output.put_line(vnum);
        vnum := vnum +1;
        exit when vnum > 10;
    end loop;

end;


declare
    vnum number := 1;
begin
    while vnum <= 10 loop
        dbms_output.put_line(vnum);
        vnum := vnum +1;
    end loop;

end;



/*

    select > 결과셋 > PL/SQL 변수 대입
    
    1. select into
        - 결과셋의 레코드가 1개일 때만 사용이 가능하다
    
    2. cursor
        - 결과셋의 레코드가 N개일 때 사용한다
        - 루프 사용    
    
    
    declare
        변수 선언;
        커서 선언; -- 결과셋 참조 객체
    begin
        커서 열기;
            loop
                데이터 접근(루프 1회전 > 레코드 1개) <- 커서 사용
            end loop;
        커서 닫기;
    end;



*/

declare 
    vname tblInsa.name%type;
begin
    -- 01422. 00000 -  "exact fetch returns more than requested number of rows"
    select name into vname from tblInsa; -- 가져온 행의 갯수가 2개이상 나오는 오류
    dbms_output.put_line(vname);
end;


create view vview
as
select 문;
-- 둘이 비슷
cursor vcursor
is
select 문;



declare
    cursor vcursor 
    is 
    select name from tblInsa;
    vname tblInsa.name%type;
begin
    
    open vcursor; --커서 열기 >  select 실행 > 결과셋을 커서가 참조
    
        --fetch vcursor into vname; --select into 역할
        --dbms_output.put_line(vname);
    
        --fetch vcursor into vname; 
        --dbms_output.put_line(vname);
        
--        for i in 1..60 loop
--            fetch vcursor into vname; 
--            dbms_output.put_line(vname);
--        end loop;

        loop
            fetch vcursor into vname;
            exit when vcursor%notfound; --bool
            
            dbms_output.put_line(vname);
        end loop;

        
    close vcursor;
    
end;



-- '기획부' > 이름, 직위, 급여 > 출력
declare
    cursor vcursor
        is select name, jikwi, basicpay from tblInsa where buseo = '기획부';
        
    vname tblInsa.name%type;
    vjikwi tblInsa.jikwi%type;
    vbasicpay tblInsa.basicpay%type;
begin

    open vcursor;
    
    loop
        fetch vcursor into vname, vjikwi, vbasicpay;
        exit when vcursor%notfound;
        
        --업무 > 기획부 직원 한사람씩 접근..
        dbms_output.put_line(vname || ',' || vjikwi || ',' || vbasicpay);
        
    end loop;
    
    
    close vcursor;

end;


-- 문제 tblBonus 
-- 모든 직원에게 보너스 지급. 60명 전원 > 과장/부장(1.5), 사원/대리(2) 지급
select * from tblBonus;

delete from tblBonus;

select * from tblInsa;

declare -- 왜안되는지 모르겠
    cursor vcursor
    is
    select num, jikwi, basicpay from tblInsa;

    vnum tblInsa.num%type;
    vjikwi tblInsa.jikwi%type;
    vbasicpay tblInsa.basicpay%type;
    vbonus number;
begin
    open vcursor;
        loop
            fetch vcursor into vnum, vjikwi, vbasicpay;
            exit when vcursor%notfound;
            if vjikwi = '과장' or vjikwi = '부장' then
                    vbonus := vbasicpay * 1.5;
            elsif vjikwi in ('사원', '대리') then
                    vbonus := vbasicpay * 2;
            end if;
                
            insert into tblBonus (seq, num, bonus)
                values ((select nvl(max(seq), 0) +1 from tblBonus), vnum, vbonus);
        end loop;
    close vcursor;
end;



-- 커서 탐색
-- 1. 커서 + loop
-- 2. 커서 + for loop

declare -- 기본구성
    cursor vcursor
    is select * from tblInsa;
    vrow tblInsa%rowtype;
begin
    open vcursor;
    loop
        fetch vcursor into vrow;
        exit when vcursor%notfound;
    end loop;
    close vcursor;
end;


declare
    cursor vcursor
    is select * from tblInsa;
    vrow tblInsa%rowtype;
begin
    --open vcursor;
    --loop
    for vrow in vcursor loop --loop + fetch into + vrow + exit when를 대신함
        --fetch vcursor into vrow;
        --exit when vcursor%notfound;
        dbms_output.put_line(vrow.name);
    end loop;
    --close vcursor;
end;

declare
    cursor vcursor
    is select * from tblInsa;
    vrow tblInsa%rowtype;
begin
    for vrow in vcursor loop --loop + fetch into + vrow + exit when를 대신함
        dbms_output.put_line(vrow.name);
    end loop;
end;


-- 예외처리
-- : 실행부에서(begin~end) 발생하는 예외를 처리하는 블럭 >  exception 블럭

declare
    vname varchar2(5);
begin
    dbms_output.put_line('하나');
    select name from tblInsa where num = 1001;
    dbms_output.put_line('둘');
    
    dbms_output.put_line(vname);
    
exception
    
    when others then 
        dbms_output.put_line('예외 처리');
    
end;



-- 예외 발생 > DB 저장
create table tblLog(
    seq number primary key,                     --pk
    code varchar2(7) not null check (code in ('A001', 'B001', 'B002', 'C001')), --에러 상태 코드
    message varchar2(1000) not null,            --에러 메시지
    regdate date default sysdate not null       --에러 발생처리
);

create sequence seqLog

declare
    vcnt number;
    vname tblInsa.name%type;
begin

    select count(*) into vcnt from tblCountry; --where name = '태국'; 
    dbms_output.put_line(100 / vcnt);
    
    select name into vname from tblInsa where num = 1000;
    dbms_output.put_line(vname);

exception
    when ZERO_DIVIDE then
        dbms_output.put_line('0으로 나누기');
        insert into tblLog values (seqLog.nextVal, 'B001', '가져온 레코드가 없습니다.', default);
    when NO_DATA_FOUND then
        dbms_output.put_line('데이터 없음');
        insert into tblLog values (seqLog.nextVal, 'A001', '직원이 존재하지 않습니다', default);
    when others then
        dbms_output.put_line('나머지 예외');
        insert into tblLog values (seqLog.nextVal, 'C001', '기타 예외가 발생했습니다', default);

end;


select * from tblLog;



-- 익명 프로시저

/*

    명령어 실행
    
    1. ANSI-SQL
    2. 익명 프로시저
        a. 클라이언트 > 구문 작성(select)
        b. 실행(Ctrl + Enter)
        c. 명령어를 오라클 서버에 전달
        d. 서버가 명령어를 수신
        e. 구문 분석(파싱) + 문법 검사
        f. 컴파일
        g. 실행(select)
        h. 결과셋 도출
        i. 결과셋을 클라이언트에게 반환
        j. 결과셋을 화면에 출력
    
    2. 다시 실행
        a ~ j 다시 반복
        - 한번 실행했던 명령어를 다시 실행 > 위의 모든 과정을 처음부터 끝까지 다시 실행한다
        - 첫번째 실행 비용 = 다시 실행 비용
        
    3. 실명 프로시저
        a. 클라이언트 > 구문 작성(create)
        b. 실행(Ctrl + Enter)
        c. 명령어를 오라클 서버에 전달
        d. 서버가 명령어를 수신
        e. 구문 분석(파싱) + 문법 검사
        f. 컴파일
        h. 오라클 서버 > 르로시저 생성 > 저장 (구문 분석된 기계어(컴파일된 상태)로 저장됨)
        i. 완료
        
        a. 클라이언트 > 구문 작성(create)
        b. 실행(Ctrl + Enter)
        c. 명령어를 오라클 서버에 전달
        d. 서버가 명령어를 수신
        e. 구문 분석(파싱) + 문법 검사
        f. 컴파일
        g. 실행 > 프로시저 실행
    
    3. 다시실행
        a. 클라이언트 > 구문 작성(create)
        b. 실행(Ctrl + Enter)
        c. 명령어를 오라클 서버에 전달
        d. 서버가 명령어를 수신
        e. 구문 분석(파싱) + 문법 검사
        f. 컴파일
        g. 실행 > 프로시저 실행
    
    

*/

select * from tblInsa;

/*

    프로시저
    1. 익명 프로시저
        - 1회용
        
    2. 실명 프로시저
        - 재사용
        - 오라클에 저장


    실명 프로시저
    - 저장 프로시저(Stored Procedure)
    1. 저장 프로시저, Stored Procedure
        - 매개 변수 / 반환값 구성 > 자유
    2. 저장 함수, Stored Function
        - 매개 변수 / 반환값 구성 > 필수
        
    
    익명 프로시저 선언
    
    [declare
        변수 선언;
        커서 선언;]
    begin
        구현부;
    [exception
        예외처리;]
    end;
    
    
    
    저장 프로시저 선언
    
    create [or replace] procedure 프로시저명
    is(as)
    [   변수 선언;
        커서 선언;]
    begin
        구현부;
    [exception
        예외처리;]
    end;
    
    

*/
set serveroutput on; -- 출력하려면 실행


-- 즉시 실행
/
declare
    vnum NUMBER;
begin
    vnum := 100;
    dbms_output.put_line(vnum);
end;
/


-- 저장 프로시저
/
create or replace procedure procTest --객체를 생성(create) 한거라 결과가 출력되진않음
is
    vnum NUMBER;
begin
    vnum := 100;
    dbms_output.put_line(vnum);
end;
/


-- 저장 프로시저를 호출하는 방법
begin
    procTest; --프로시저 호출
end;



-- 저장 프로시저 = 메서드
-- 매개변수 + 반환값

-- 1. 매개변수가 있는 프로시저
create or replace procedure procTest(pnum number) --매개변수
is
    vresult number; --일반변수
begin
    vresult := pnum * 2;
    dbms_output.put_line(vresult);

end procTest;


begin
    -- PL/SQL 영역
    procTest(100);
    procTest(200);
    procTest(300);
end;


-- 무슨 영역?
-- ANSI-SQL 영역
select * from tblInsa;

execute procTest(400);
exec procTest(500);
call procTest(600);




create or replace procedure procTest(
    width number, 
    height number
)-- 오라클 매개변수 표현방식
is
    vresult number;
begin
    vresult := width * height;
    dbms_output.put_line(vresult);
end procTest;

begin
    procTest(10, 20);
end;



--매개변수 길이 x
create or replace procedure procTest(
    name varchar2       -- *** 프로시저 매개변수는 길이와 not null 표현은 불가능하다
)
is--변수 선언이 없어도 반드시 기재
    
begin
    dbms_output.put_line('안녕하세요. ' || name || '님');
end procTest;



begin
    procTest('홍길동');
end;



--매개변수 default
create or replace procedure procTest(
    width number, 
    height number default 10 -- 매개변수 default 가능(하지만 디폴트가 먼저(width)오면 안됨 'procTest(10);' 할시에 10을 어디에 넣을지 몰라서 에러나옴)
)-- 오라클 매개변수 표현방식
is
    vresult number;
begin
    vresult := width * height;
    dbms_output.put_line(vresult);
end procTest;

begin
    procTest(10, 20);   -- width(10), height(10)
    procTest(10);       -- width(10), height(10-default)
end;



/*

    매개변수 모드
    - 매개변수가 값을 전달하는 방식
    - call by Value > 매개변수 > 값을 넘기는 방식(값형 인자)
    - call by Reference > 매개변수 > 참조값(주소)을 넘기는 방식(참조형 인자)
    
    1. in 모드 > 기본
    2. out 모드
    3. in out 모드(X)



*/


create or replace procedure procTest(
    pnum1 in number, -- in parameter //인자값
    pnum2 in number,
    presult out number,     -- out parameter //반환값 역할
    presult2 out number,    -- 반환값
    presult3 out number     -- 반환값
)
is
begin
    presult := pnum1 + pnum2;
    presult2 := pnum1 * pnum2;
    presult3 := pnum1 / pnum2;
end procTest;


declare
    vnum number;
    vnum2 number;
    vnum3 number;
begin
    procTest(10, 20, vnum, vnum2, vnum3); --말그대로 값을 out 해서 vnum에 값저장
    dbms_output.put_line(vnum);
    dbms_output.put_line(vnum2);
    dbms_output.put_line(vnum3);
end;




-- 문제
-- 1. 부서 전달(인자) > 해당 부서의 직원 중 급여를 가장 많이 받는 사람의 번호를 반환(out) > 출력
--      in 1개 + out 1개
-- 2. 직원 번호 전달(인자) > 같은 지역에 사는 직원수?, 같은 직위 직원수? 해당 직원보다 급여를 더 많이 받는 직원수? 
--      in 1개 + out 3개
select * from tblInsa;


create or replace procedure procTest1(
    vbuseo in varchar,
    vnum out number
)
is
begin
    select num into vnum from tblInsa 
        where basicpay = (select max(basicpay) from tblInsa where buseo = vbuseo)
            and buseo = vbuseo;
end procTest1;



declare
    vnum number;
begin
    procTest1('기획부', vnum);
    dbms_output.put_line(vnum);
end;


create or replace procedure procTest2(
    pnum in number, -- 직원번호
    pcnt1 out number,
    pcnt2 out number,
    pcnt3 out number
)
is
begin
--같은 지역에 사는 직원수?, 같은 직위 직원수? 해당 직원보다 급여를 더 많이 받는 직원수? 
    select count(*) into pcnt1 from tblInsa 
        where city = (select city from tblInsa where num = pnum);
    
    select count(*) into pcnt2 from tblInsa 
        where jikwi = (select jikwi from tblInsa where num = 1001);
            
    select count(*) into pcnt1 from tblInsa 
        where basicpay = (select basicpay from tblInsa where num = pnum);



end procTest2;


declare
    vnum number;
    vcnt1 number;
    vcnt2 number;
    vcnt3 number;
begin

    procTest1('개발부', vnum);

    procTest2(vnum, vcnt1, vcnt2, vcnt3);
    dbms_output.put_line(vcnt1);
    dbms_output.put_line(vcnt2);
    dbms_output.put_line(vcnt3);

end;



select * from tblStaff;
select * from tblProject;

delete from tblStaff;
delete from tblProject;

INSERT INTO tblStaff (seq, name, salary, address) VALUES (1, '홍길동', 300, '서울시');
INSERT INTO tblStaff (seq, name, salary, address) VALUES (2, '아무개', 250, '인천시');
INSERT INTO tblStaff (seq, name, salary, address) VALUES (3, '하하하', 250, '부산시');
INSERT INTO tblStaff (seq, name, salary, address) VALUES (4, '호호호', 200, '광주시');


INSERT INTO tblProject (seq, project, staff_seq) VALUES (1, '홍콩 수출', 1); --홍길동
INSERT INTO tblProject (seq, project, staff_seq) VALUES (2, 'TV 광고', 2); --아무개
INSERT INTO tblProject (seq, project, staff_seq) VALUES (3, '매출 분석', 3); --하하하
INSERT INTO tblProject (seq, project, staff_seq) VALUES (4, '노조 협상', 1); --홍길동
INSERT INTO tblProject (seq, project, staff_seq) VALUES (5, '대리점 분양', 2); --아무개

commit;


-- 직원 퇴사 프로시저, procDeleteStaff
-- 1. 퇴사 직원 > 담당 프로젝트 
-- 2. 담당 프로젝트 존재 > 위임
-- 3. 퇴사 직원 삭제

create of replace procedure procDeleteStaff(
    pseq number,            --퇴사할 직원번호
    pstaff number,          --위임받을 직원번호
    presult out number      --성공(1) or 실패(0)
)
is
    vcnt number; --퇴사 직원의 담당 프로젝트 개수
begin
    
    --1. 퇴사 직원의 담당 프로젝트가 있는?
    select count(*) into vcnt from tblProject where staff_seq = pseq;
    
    --2. 조건 > 위임 유무 결정
    if vcnt > 0 then
        --3. 위임
        update tblProject set staff_seq = pstaff where staff_seq = pseq;
        
    else
        --3. 아무것도 안함
        null; -- 이 조건의 else 절에서는 아무것도 하지 마시오!!  > 개발자의 의도 표현
    end if;
    
    --4. 퇴사
    delete from tblStaff where seq = pseq;
    
    --5. 피드백 > 성공
    presult := 1;
    
    
exception
    when other then
        persult :=0;

and procDeleteStaff;



declare
    vresult number;
begin
    procDeleteStaff(1, 2, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('퇴사성공');
    else
        dbms_output.put_line('퇴사실패');
    end if;
        
    
end;


-- 위임받을 직원 > 현재 프로젝트를 가장 적게 담당 직원에게 자동으로 위임
create of replace procedure procDeleteStaff(
    pseq number,            --퇴사할 직원번호
    pstaff number,          --위임받을 직원번호
    presult out number      --성공(1) or 실패(0)
)
is
    vcnt number; --퇴사 직원의 담당 프로젝트 개수
    vstaff_seq number; --담당 프로젝트가 가장 적은 직원 번호
begin
    
    --1. 퇴사 직원의 담당 프로젝트가 있는?
    select count(*) into vcnt from tblProject where staff_seq = pseq;
    
    --2. 조건 > 위임 유무 결정
    if vcnt > 0 then
    
        --2.5 적게 맡고 있는 직원 번호?
        select seq from (
            select 
                s.seq
            from tblStaff s
                left outer join tblProject p
                    on s.seq = p.staff_seq
                        group by s.seq
                            having count(p.staff_seq) = (select                                                             
                                                                min(count(p.staff_seq))
                                                            from tblStaff s
                                                                left outer join tblProject p
                                                                    on s.seq = p.staff_seq
                                                                        group by s.seq))
                                                                         where rownum = 1;
    
    
        --3. 위임
        update tblProject set staff_seq =  where staff_seq = pseq;
        
    else
        --3. 아무것도 안함
        null; -- 이 조건의 else 절에서는 아무것도 하지 마시오!!  > 개발자의 의도 표현
    end if;
    
    --4. 퇴사
    delete from tblStaff where seq = pseq;
    
    --5. 피드백 > 성공
    presult := 1;
    
    
exception
    when other then
        persult :=0;

and procDeleteStaff;



declare
    vresult number;
begin
    procDeleteStaff(1, 2, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('퇴사성공');
    else
        dbms_output.put_line('퇴사실패');
    end if;
        
    
end;












