/***
파일명 : OR06FroupBy.sql
그룹합수(select문 2번째)
설명 : 전체 레코드에서 통계적인 결과를 구하기 위해 하나 이상의 레콛를
    그룸으로 묶어서 연산한 후 결과를 반환하는 함수 혹은 쿼리문 학습
***/
--사원테이블에서 담당업무 인출. 별도의 조건이 없으므로 107개가 인출됨.
select job_id from employees;
/*
dintinc : 동일한 값이 있는 경우 중복된 레코드를 제거한 후 하나의
    레코드만 가져와서 보여준다. 순수한 하나릐 레코드이므로 통계적인
    값을 계산할 수 없다.
*/
select DISTINCT job_id from employees;
/*
group bu : 동일한 값이 있는 레코드를 하나의 그룹으로 묶어서 인출한다.
    보여지는것은 하나의 레코드이지만 다수의 레코드가 하나의 그룹으로
    묶여진 결과이므로 통계적인 값을 계산할수 있다.
    최대, 최소, 평균, 합계 등의 연산이 가능하다.
*/
select job_id from employees group by job_id;

--각 담당업무별 직원수는 몇명일까요??

select job_id, count(*)
    from employees group by job_id;
    
/*
count() 함수를 통해 인출된 행의 갯수를 아래와 같이 일반적인 select문으로
검증할 수 있다.
*/

SELECT * from employees WHERE job_id='FI_ACCOUNT';
SELECT * from employees WHERE job_id='PU_CLERK';

/*
group by 절이 포함된 select 문의 형식
    select
        컬럼1, 컬럼2....컬럼N 혹은 *(컬럼전체)
    from
        테이블
    where
        조건1 and 조건2 or 조건N <- 물리적으로 존재하는 컬럼
    group by
        레코드의 그룹화를 위한 컬럼
    having
        그룹에서의 조건 <- 논리적으로 생성된 컬럼(평균, 합계 등)
    order by
        정렬을 위한 컬럼 및 정렬방식(오름차순, 내림차순
*/

/*
sum() : 합계를 구할때 사용하는 함수
    number 타입의 컬럼에서만 사용할 수 있다.
    필드명이 필요한 경우 as를 이용해서 별칭을 부여할 수 있다.
*/
--전체직원의 급여의 합계를 인출하시오

select
    sum(salary) sumSalary, 
    to_char(sum(salary), '999,000') as sumSalary2,
    TRIM(to_char(sum(salary), '999,000')) as sumSalary2
from employees;


--10번 부서에서 근무하는 사원들의 급여 합계는 얼마인지 인출하시오

SELECT
    TRIM(to_char(sum(salary), '$999,000')) as sumSalary2
from employees where department_id=10;

/*
count () : 그룹화된 레코드의 갯수를 카운트할때 사용하는 함수
*/

SELECT count(*) from employees;
SELECT count(employee_id) from employees;

/*
    count() 함수를 사용할때는 위 2가지 방법 모두 가능하지만
    * 사용을 권장한다. 컬럼의 특성 혹은 데이터에 따른 방해를
    받지 않으므로 실행속도가 빠르다.
*/

/*
count() 함수의 사용법
     1.count(all 컬럼명)
        : 디폴트 사용법으로 컬럼명 전체의 레코드를 기준으로 카운트
    2.count(deistinct 컬럼명)
        : 중복을 제거한 상태에서 카운트
*/

select
    count(job_id),
    count(all job_id),
    count(distinct job_id)
FROM employees;


/*
avg() : 편균값을 구할때 사용하는 함수
*/
--전체사원의 평균급여는 얼마인지 인출하시오
select
    count(*) "전체사원수",
    sum(salary) "급여합계",
    sum(salary) / count(*) "평균급여(직접계산)",
    to_char(avg(salary), '999,000.00') "avg함수사용"
from employees;
