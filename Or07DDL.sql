/*** 
파일명 : Or07DDL.sql
DDL :  Data definition Language(데이터 정의어)
설명 : 테이블, 뷰와 같은 객체를 생성 및 변경하는 쿼리문을 말한다.
***/

--system 계정으로 접속한 후 아래 명령을 실행
--계정 생성시 c##을 생략하고 만들 수 있도록 session을 변경
alter session set "_ORACLE_SCRIPT"=true;
--새로운 사용자 계정 생성
create user education IDENTIFIED by 1234;
--Role(역할)을 통해 접속 및 테이블생성 등 권한을 부여
grant connect, resource, UNLIMITED TABLESPACE to education;


----------------------------------------------------------------
--education 계정으로 접속한 후 학습을 진행합니다.

--생성된 모든 계정에 논리적으로 존재하는 테이블
SELECT * FROM dual;
/* 현재 접속한 계정에 생성된 테이블의 목록을 저장한 시스템 테이블.
이와같이 관리의 목적으로 생성된 테이블을 '데이터사전'이라고 표현한다.*/
SELECT * FROM tab;



--테이블생성
/*
형식] create table 테이블명 (
        컬럼명1 자료형(크기),
        컬럼명2 자료형(크기)
        ....
        primary key(컬럼명) 등의 제약조건 추가
    );
*/
create table tb_member(
    idx number(10), /* 숫자형(정수) */
    userid VARCHAR2(30), /* 문자형 */
    passwd VARCHAR2(50),
    username VARCHAR2(30),
    mileage number(7,2) /* 숫자형(실수) */
);
--현재 접속된 계정에 생성에 테이블의 목록을 확인
SELECT * FROM tab;
--테이블의 구조(스키마) 확인. 컬럼명, 자료형, 크기를 확인할 수 있다.
desc tb_member;

/*
기존 생성된 테이블에 새로운 컬럼 추가하기
    형식] alter table 테이블명 add 추가할컬럼 자료형(크기) 제약조건;
*/
--tb_member 태이블에 email 컬럼을 추가하시오
ALTER table tb_member add email VARCHAR2(100);
desc tb_member;

/*
기존 생성된 테이블 컬럼 수정(변경)하기
형식] alter table 테이블명 modify 수정할컬럼명 자료형(크기);
*/
--email컬럼의 사이즈를 200으로 확장하시오.
--이름이 저장되는 컬럼도 60으로 확장하시오.
ALTER TABLE tb_member MODIFY email VARCHAR2(200);
ALTER TABLE tb_member MODIFY username VARCHAR2(60);
desc tb_member;

/*
기존 생성된 테이블에서 컬럼 삭제하기
형식] alter table 테이블명 drop column 삭제할컬럼
*/

--mileage 컬럼을 삭제하시오
ALTER table tb_member drop COLUMN mileage;
desc tb_member;

/*
퀴즈] 테이블 정의서로 작성한 employees테이블을 해당 education계정에 그대로
    생성하시오. 단, 제약조건은 명시하지 않습니다. 
*/

create table employees(
    
    employee_id number(6), 
    first_name VARCHAR2(20), 
    last_name VARCHAR2(25),
    email varchar2(25),
    phone_number varchar2(20),
    hire_date date,
    job_id varchar2(10),
    salary number(8,2),
    commission_pct number(2,2),
    manager_id number(6,0),
    department_id number(4,0)
);
desc employees;

/*
테이블 삭제하기
형식] drop table 삭제할티이블명;
*/

--employees 테이브를 삭제하시오
SELECT * FROM tab;
drop table employees; --tb_member, tb_member_copy1, tb_member_copy2
desc employees;

--테이블을 삭제(drop) 하면 휴지통(recyclebin)에 임시 보관된다.
show recyclebin;
--휴지통 비우기
PURGE recyclebin;
--휴지통에 보관된 테이블 복원하기
FLASHBACK TABLE employees to BEFORE drop;


--tb_member 테이블에 새로운 레코드 입력하기
insert into tb_member VALUES(1, 'kosmo1', '1234', '코스모155기',
    'kosmo155@naver.com');
SELECT * FROM tb_member;

insert into tb_member VALUES(2, 'kosmo2', '1234', '코스모156기',
    'kosmo156@gmail.com');
insert into tb_member VALUES(3, 'kosmo3', '1234', '코스모157기',
    'kosmo157@nate.com');
--삽입된 레코드 확인하기
SELECT * FROM tb_member;
--명시적 true조건이므로 모든 레코드를 대상으로 인출한다.
SELECT * FROM tb_member where 1=1;
--명시적 false조건이므로 리코드를 인출하지 않는다.
SELECT * FROM tb_member where 1=0;

--테이블복사 1 : 테이블의 스키마(구조)만 복사
create table tb_member_copy1
as
SELECT * FROM tb_member WHERE 1=0;
--테이블의 구조만 복사되었으므로 레코드는 인출되지 않는다.
SELECT * FROM tb_member_copy1;


--테이블복사 2 : 테이블의 스키마(구조)와 레코드까지 모두 복사
create table tb_member_copy2
as
SELECT * FROM tb_member WHERE 1=1;
--true의 조건으로 레코드까지 복사했으므로 인출된다.
SELECT * FROM tb_member_copy2;

