--계정 생성
create user user_ksj identified by java1234;

grant connect, resource, dba to user_ksj;

--테이블 생성

CREATE TABLE member (
	id VARCHAR2(30), 
	pass VARCHAR2(100),
    name VARCHAR2(50),
    gender char(1),
    tel VARCHAR2(13),
    regdate date default sysdate,
    
    CONSTRAINT member_id_pk PRIMARY KEY(id)
);

CREATE TABLE schedule_movie (
	movie_code char(15), 
	mv_title VARCHAR2(100),
    mv_stroy VARCHAR2(4000),
    mv_runtime number,
    mv_regdate DATE default sysdate,
    
    CONSTRAINT schedule_movie_code_pk PRIMARY KEY(movie_code)
);

CREATE TABLE director (
	dr_code NUMBER, 
	dr_name VARCHAR2(50),
    dr_regdate date default sysdate,
    movie_code char(15),
    
    CONSTRAINT director_code_pk PRIMARY KEY(dr_code),
    CONSTRAINT director_moive_code_fk foreign key(movie_code) references schedule_movie(movie_code)
);



CREATE TABLE reservation (
	res_num NUMBER, 
	id VARCHAR2(30),
    movie_code char(15),
    regdate date default sysdate,
    
    CONSTRAINT reservation_num_pk PRIMARY KEY(res_num, id, movie_code),
    CONSTRAINT reservation_id_fk foreign key(id) references member(id),
    CONSTRAINT reservation_movie_code_fk foreign key(movie_code) references schedule_movie(movie_code)
);

--데이터 추가


--drop table reservation;
--drop table director;
--drop table schedule_movie;
--drop table member;

INSERT INTO member VALUES ('son', '1234', '손재옥', 'M', '010-7361-9876', default);
INSERT INTO member VALUES ('kim', '1234', '김영주', 'M', '010-6712-7652', default);
INSERT INTO member VALUES ('jung', '1234', '정헌석', 'M', '010-7731-1471', default);

create sequence movie_seq;

INSERT INTO schedule_movie VALUES (('MV_' || LPAD(movie_seq.nextVal, 12, '0')), '007 노 타임 투 다이(No time to Die)', '가장 강력한 운명의 적과 마주하게된 제임스 본드의 마지막 미션이 시작된다.' , 163, default);
INSERT INTO schedule_movie VALUES (('MV_' || LPAD(movie_seq.nextVal, 12, '0')), '보이스(On the Line)', '단 한 통의 전화!걸려오는 순간 걸려들었다!' ,109, default);
INSERT INTO schedule_movie VALUES (('MV_' || LPAD(movie_seq.nextVal, 12, '0')), '수색자(The Recon)', '억울하게 죽은 영혼들의 무덤 DMZ', 111, default);
INSERT INTO schedule_movie VALUES (('MV_' || LPAD(movie_seq.nextVal, 12, '0')), '기적(Mircle)', '오갈 수 있는 길은 기찻길밖에 없지만 정작 기차역은 없는 마을.' , 117, default);

drop sequence movie_seq;

create sequence dr_seq;

INSERT INTO director VALUES (dr_seq.nextVal, '캐리 후쿠나가', default, 'MV_000000000001');
INSERT INTO director VALUES (dr_seq.nextVal, '김선', default, 'MV_000000000002');
INSERT INTO director VALUES (dr_seq.nextVal, '김곡', default, 'MV_000000000002');
INSERT INTO director VALUES (dr_seq.nextVal, '김민섭', default, 'MV_000000000003');
INSERT INTO director VALUES (dr_seq.nextVal, '이창훈', default, 'MV_000000000004');

drop sequence dr_seq;


create sequence res_seq;

INSERT INTO reservation VALUES (res_seq.nextVal, 'son', 'MV_000000000002', default);
INSERT INTO reservation VALUES (res_seq.nextVal, 'son', 'MV_000000000003', default);
INSERT INTO reservation VALUES (res_seq.nextVal, 'kim', 'MV_000000000001', default);
INSERT INTO reservation VALUES (res_seq.nextVal, 'jung', 'MV_000000000002', default);

drop sequence res_seq;

--검색
select
    id,
    pass,
    name,
    case
        when gender = 'M' then '남'
        when gender = 'F' then '여'
    end as gender,
    tel,
    regdate
from member;

select 
    m.name as 예약자이름,
    s.mv_title as 영화제목,
    to_char(r.regdate, 'yy-mm-dd hh24:mi:ss') as 예약시간
from reservation r
    inner join member m
        on r.id = m.id
            inner join schedule_movie s
                on r.movie_code = s.movie_code; 

select 
    d.dr_name as 감독이름,
    s.mv_title as 영화제목
from director d
    inner join schedule_movie s
        on d.movie_code = s.movie_code;



select * from schedule_movie;
select * from member;
select * from director;
select * from reservation;




