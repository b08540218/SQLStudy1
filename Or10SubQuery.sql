/***
파일명 : Or10SubQuery.sql
서브쿼리
설명 : 쿼리문안에 또 다른 쿼리문이 돌아가는 형태의 select문
***/

/*
당일행 서브쿼리
형식] selcet * from 테이브명 hwere 컬럼=(
        select 컬럼 from 테이블명 where 조건 
        );
        ※괄호안의 서브쿼리는 반드시 하나의 결과를 인출해야한다.
*/

/*
시나리오] 사원테이블에서 전체사원의 평균급여보다 낮은 급여를 받는 사원들을 
추출하여 출력하시오.
    출력항목 : 사원번호, 이름, 이메일, 연락처, 급여
*/
--1.형균급여 구하기(결과 : 6462)
SELECT avg(salary) from employees;
--2.앞에서 구한 평균급여보다 낮은 직원들을 인출(결과 : 56명)
SELECT * FROM employees where salary<6462;
/* 1,2번을 아래와 같이 합쳐서 작성하면 에러가 발생한다. 문맥상 맞는것처럼
보이지만 그룹함수를 단일행에 적용한 잘못된 쿼리문이다.*/
SELECT * FROM employees where salary<round(avg(salary));
--3.서브 쿼리문 작성
SELECT * FROM employees where salary<(
    SELECT round(avg(salary)) from employees
);

/*
시나리오] 전체 사원중 급여가 가장적은 사원의 이름과 급여를 출력하는 
서브쿼리문을 작성하시오.
출력항목 : 이름1, 이름2, 이메일, 급여
*/

--최소금여 확인(결과 : 2100)
SELECT min(salary) from employees;
--그룹함수를 단일행에 사용했으므로 에러발생
SELECT
    first_name, last_name, email, salary
from employees where salary=min(salary);
--2100분을 받은 직원을 인출
SELECT
    first_name, last_name, email, salary
from employees where salary=2100;
--2개의 쿼리문을 합쳐서 서브쿼리를 만든다
SELECT
    first_name, last_name, email, salary
    from employees where salary=(
    SELECT min(salary) from employees
);


/*
시나리오] 평균급여보다 많은 급여를 받는 사원들의 명단을 조회할수 있는 
서브쿼리문을 작성하시오.
출력내용 : 이름1, 이름2, 담당업무명, 급여
※ 담당업무명은 jobs 테이블에 있으므로 join해야 한다. 
*/
--평균급여 확인 
SELECT round(avg(salary)) from employees;
--jobs 테이블과 내부조인하여 조건에 맞는 레코드 인출
SELECT
    first_name, last_name, job_title, salary
from employees Em inner join jobs Jo
    on em.job_id=jo.job_id
where salary>6462;
--서브쿼리문을 병합
SELECT
    first_name, last_name, job_title, salary
from employees Em inner join jobs Jo
    on em.job_id=jo.job_id
where salary>(
    SELECT round(avg(salary)) from employees
);

--inner join에서 on절을 using으로 변경(좀 더 간단히 표현 가능)
SELECT
    first_name, last_name, job_title, salary
from employees inner join jobs 
    using(job_id)
where salary>(
    SELECT round(avg(salary)) from employees
);

/*
복수행 서브쿼리
형식] select * from 테이블명 where 컬럼 in(
        select 컬럼 from 테이블명 where 조건
    );
 ※괄호안의 서브쿼리는 2개 이상의 결과를 인출해야한다.
 ※경우에 따라 1개의 결과가 나오더라도 에러가 발생하진 않는다.
*/

/*
시나리오] 담당업무별로 가장 높은 급여를 받는 사원의 명단을 조회하시오.
    출력목록 : 사원아이디, 이름, 담당업무아이디, 급여
*/
--담당업무별로 가장 높은 급여를 확인
SELECT 
    job_id, max(salary)
from employees group by job_id;

--group by로 그룹화 되어 있으므로 단일컬럼은 사용할 수 없어 에러발생
SELECT 
    job_id, max(salary), first_name
from employees group by job_id;
--앞에서 나온 결과를 바탕으로 단순한 or조건으로 쿼리문 작성
SELECT
    employee_id, first_name, last_name, job_id, salary
FROM employees where
    (job_id='AD_PRES' and salary=24000) or
    (job_id='AD_VP' and salary=17000) or
    (job_id='IT_PROG' and salary=9000) or
    (job_id='FI_MGR' and salary=12008);
/* 앞의 쿼리에서 196개의 결과가 인출되었지만 쿼리를 직접 기술하는것은
불가능하므로 4개만으로 결과를 확인해본다.*/

SELECT
    employee_id, first_name, last_name, job_id, salary
FROM employees where
    (job_id, salary) in(
        SELECT 
            job_id, max(salary)
        from employees group by job_id
    ); 

/*
복수행 연산자 : any 
    메인쿼리의 비교조건이 서브쿼리의 검색결과와 하나 이상 일치하면
    true가 되는 연산자. 즉 둘중 하나만 만족하면 해당 레코드를 인출한다.
*/

/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를
    받는 직원들을 인출하는 서브쿼리문을 작성하시오. 단 둘 중 하나만
    만족하더라도 인출하시오. 
*/
--20번 부서의 급여를 확인 (결과 : 6000, 13000)
SELECT first_name, salary FROM employees where department_id=20;
--위 결과를 단순한 or절로 쿼리문 작성 (결과 : 55개)
SELECT first_name, salary from employees where
    salary>6000 or salary>13000;
--위 2개의 쿼리문을 서브쿼리문으로 작성
SELECT first_name, salary from employees where
   salary > any (
        SELECT salary FROM employees where department_id=20
   );
/*
    결과로 인출된 2개의 급여중 하나만 만족하면 되므로 복수행 연산자
    any를 이용해서 서브쿼리문을 작성하면된다. 즉 여기서는 6000이상에
    조건에 만족하는 모든 레코드가 인출된다.
*/

/*
복수행 연산자 : all
    메인쿼리의 비교조건이 서브쿼리의 검색결과와 모두 일치해야
    레코드를 인출한다.
*/

/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를
    받는 직원들을 인출하는 서브쿼리문을 작성하시오. 단 둘다 만족하는 
    레코드만 인출하시오. 
*/

SELECT first_name, salary from employees where
    salary>6000 AND salary>13000;

SELECT first_name, salary from employees where
   salary > all (
        SELECT salary FROM employees where department_id=20
   );
/*
    6000보다도 크고 동시에 13000보다도 커야하므로 결과적으로
    13000 보다 큰 레코드만 인출한다. (결과 : 5개)
*/

/*
rownum : 테이블에서 레코드를 조회한 순서대로 순번이 부여되는 가상의
    컬럼을 말한다. 해당 컬럼은 모든 테이블에 논리적으로 존재한다.
*/
--모든 계정에 논리적으로 존재하는 테이블
SELECT * FROM dual;
/* 레코드를 정렬없이 모든 레코드를 가져와서 rownum을 부여한다.
이 경우 rownum은 순서대로 인출된다.*/
SELECT employee_id, first_name, rownum from employees;
/* 이름이나 사원번호를 통해 정렬하면 rownum이 섞여져서 나오기도 하고
순서대로 나오기도 한다.*/
SELECT employee_id, first_name, rownum 
from employees ORDER by first_name;
SELECT employee_id, first_name, rownum 
from employees ORDER by employee_id;

/*
rownum을 우리가 정렬한 순서대로 재무여하기 위해 서크쿼리를 사용한다.
from 절에는 테이블이 위치해야 하지만, 아래의 서브쿼리에서는 사원
테입ㄹ의 전체레코드를 대상으로 하되 이름으로 정렬된 상태로 레코드를
인출하기 때문에 테이블을 대체할 수 있다.
또한 정렬된 상태에서 rownum을 부여하므로 순차적으로 순번이 된다
*/
SELECT first_name, rownum from 
    (SELECT * FROM employees ORDER by first_name asc);

/* 이름을 기준으로 정렬된 레코드에 rownum을 부여했으므로 where절에
아래와 같은 조건을 부여해서 구간을 결정할 수 있다.*/
SELECT * FROM 
(SELECT tb.*, rownum from 
    (SELECT * FROM employees ORDER by first_name asc) tb)
WHERE rownum>=1 and rownum<=10;

--rownum에 별칭을 부여해서 조건으로 사용한다.
SELECT * FROM 
(SELECT tb.*, rownum rNum from 
    (SELECT * FROM employees ORDER by first_name asc) tb)
--WHERE rNum>=1 and rNum<=10;
--WHERE rNum>=11 and rNum<=20;
where rnum BETWEEN 21 and 30;
--구간을 정할때는 between을 사용해도 된다.


commit;













