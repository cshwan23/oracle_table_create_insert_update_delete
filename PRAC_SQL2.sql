--mmmmmmmmmmmmmmmmmmmmmmmmm
-- 숫자를 다양한 문자형태로 만들기
--mmmmmmmmmmmmmmmmmmmmmmmmm
---------------------------------------
-- Q1. 1234를 001234로 만들기
---------------------------------------
    -- 1234의 앞을 0으로 채우면서 6자리로 만들기
---------------------------------------
select
    to_char(1234,'099999')
from dual;


---------------------------------------
-- Q2. 123456789를 123,456,789 로 만들기
--     1234를 1,234로 만들기
---------------------------------------
-- 천단위로 콤마를 집어넣기
---------------------------------------
select
    to_char(123456789,'999,999,999'),
    to_char(1234,'999,999')
from dual;

---------------------------------------
-- Q3. 1234를 1234.00으로 만들기
---------------------------------------
-- 소수점 자리수를 확보해보기
---------------------------------------
select
    to_char(1234,'99999.99')
from dual;


---------------------------------------
-- Q4. 0.234 를 .234로 만들기
---------------------------------------
-- 정수자리에 0이라면 그 0을 지워버리기
---------------------------------------
select
    to_char(0.234, '999.999')
from dual;

---------------------------------------
-- Q5. .2345를 0.2345로 만들기
---------------------------------------
-- 정수자리에 숫자가 없다면, 정수 첫째 자리에 0하나 집어넣기
---------------------------------------
select
    to_char(.2345, '9990.9999')
from dual;


---------------------------------------
-- Q6. 0.5를 000.50으로 만들기
---------------------------------------
select
    to_char(0.5,'099.99')
from dual;


---------------------------------------
-- Q7. 맨앞에 $ , ₩ 넣기 (천단위콤마, 소수2째자리까지 0으로 넣기)
---------------------------------------
select
    to_char(12345678,'$999,999,999.00'),
    to_char(12345678,'L999,999,999.00')
from DUAL;

---------------------------------------
-- Q8. 숫자문자를 숫자로 만들기
---------------------------------------
select
to_number('12345.9')
from DUAL;

---------------------------------------
-- Q9. 콤마있는 숫자패턴을 빼버리고 숫자로만 구성하기
---------------------------------------
select
    to_number('1,234,567.8','999,999,999.9')
from DUAL;


--mmmmmmmmmmmmmmmmmmmmmmmmm
-- 기타 함수 ( decode, case )
--mmmmmmmmmmmmmmmmmmmmmmmmm

---------------------------------------
-- Q10. employee- 직원번호/명/성별 출력하기
---------------------------------------
select
    emp_no "직원번호"
    ,EMP_NAME "직원명"
    ,decode(substr(JUMIN_NUM,7,1),'1','남','3','남','여') "성별"
from EMPLOYEE;

select
    emp_no
    ,EMP_NAME
    ,   case substr(JUMIN_NUM,7,1)
        when '1' then '남'
        when '3' then '남'
        else '여'
        end
from EMPLOYEE;


---------------------------------------
-- Q11. employee-table 직원번호/명/<월급등급>출력하기
---------------------------------------
select
    emp_no "직원번호"
    ,EMP_NAME "직원명"
    ,
        case
            when SALARY>=5000 then 'A'
            when SALARY>=4000 and SALARY<5000 then 'B'
            when SALARY>=3000 and SALARY<4000 then 'C'
            when SALARY>=2000 and SALARY<3000 then 'D'
            else 'F'

        end "월급등급"
from EMPLOYEE;


--mmmmmmmmmmmmmmmmmmmmmmmmm
-- 통계 관련 함수
--mmmmmmmmmmmmmmmmmmmmmmmmm

---------------------------------------
-- Q12. employee-table 최소연봉/최대연봉/평균연봉/연봉총합/총인원수 출력하기
---------------------------------------

select

    min(SALARY), max(SALARY), avg(SALARY), sum(SALARY), count(emp_no)
from EMPLOYEE;



---------------------------------------
-- Q13. employee-table 소속부서 총 개수 출력하기
---------------------------------------
select
    count(distinct DEP_NO)
from EMPLOYEE;

---------------------------------------
-- Q14.  담당직원이 있는 고객수 출력하기
---------------------------------------
select
    count(EMP_NO)
from CUSTOMER;

---------------------------------------
-- Q15. 고객을 담당하는 직원수 출력하기
---------------------------------------
select
    count(distinct EMP_NO)
from CUSTOMER;

---------------------------------------
-- Q16. employee-table 직번,직명,입사분기 출력
---------------------------------------
select
    EMP_NO,
    EMP_NAME,
       to_char(HIRE_DATE,'Q')||'/4분기'
from EMPLOYEE;


---------------------------------------
-- Q17. employee-table 직번,직명,근무년차 출력
---------------------------------------
select
    EMP_NO,
    EMP_NAME,
       floor((extract(year from sysdate)-
       extract(year from HIRE_DATE))+1)||''||'년차'

from EMPLOYEE;
select
EMP_NO,
       EMP_NAME,
       ceil((sysdate - HIRE_DATE)/365)||'년차'
from EMPLOYEE;


---------------------------------------
-- Q18. customer-table 고객번호,고객명, 담당직원번호 출력(없으면 '없음'으로)
---------------------------------------
select

CUS_NO,
       CUS_NAME,
       nvl(EMP_NO||'','없음')

from CUSTOMER;
-- 없으면 null이면 이라는 함수
-- nvl(실행문1 ,실행문2) => 실행문2은 없으면실행 실행문1는 있으면 실행



---------------------------------------
-- Q19. customer-table 고객번호,고객명, 담당직원존재여부출력(없으면 '없음'있으면'있음')
---------------------------------------

select

CUS_NO,
       CUS_NAME,
       decode(EMP_NO,null,'없음','있음')

from CUSTOMER;


select

CUS_NO,
       CUS_NAME,
       case
            when EMP_NO is null then '없음'
            else '있음'
        end

from CUSTOMER;

select

CUS_NO,
       CUS_NAME,
       nvl2(emp_no,'있음','없음')
from CUSTOMER;


---------------------------------------
-- Q20. employee-table 직번호,직명, 나이, 연령대 검색
---------------------------------------
select


EMP_NO,
       EMP_NAME,
        extract(year from sysdate)-
       to_number(decode(substr(JUMIN_NUM,7,1),'1','19','2','19','20')||
       substr(JUMIN_NUM,1,2))+1
,
        floor((extract(year from sysdate)-
       to_number(decode(substr(JUMIN_NUM,7,1),'1','19','2','19','20')||
       substr(JUMIN_NUM,1,2))+1)*0.1)*10||''||'대'

from EMPLOYEE;


---------------------------------------
-- Q21. employee-table 직급순서대로 정렬하여 모든 칼럼을보이게 하라
---------------------------------------
select * from EMPLOYEE order by
decode(jikup,'사장',1,'부장',2,'과장',3,'대리',4,'사원',5) asc;


---------------------------------------
-- Q22. employee-table 직급순서대로 정렬하여 모든 칼럼을보이게 하라
        -- 직급같다면 나이가 많은사람이 위로
--------------------------------------
select * from EMPLOYEE order by
decode(jikup,'사장',1,'부장',2,'과장',3,'대리',4,'사원',5) asc
,         extract(year from sysdate)-
       to_number(decode(substr(JUMIN_NUM,7,1),'1','19','2','19','20')||
       substr(JUMIN_NUM,1,2))+1 desc;

---------------------------------------
-- Q23. employee-table 직급순서대로 정렬하여 모든 칼럼을보이게 하라
        -- 직급 같다면 먼저 태어난 사람이 위로가게
--------------------------------------
select * from EMPLOYEE order by
decode(jikup,'사장',1,'부장',2,'과장',3,'대리',4,'사원',5) asc
,   decode(substr(JUMIN_NUM,7,1),'1',19,'2',19,20)||
       substr(JUMIN_NUM,1,6) ;

---------------------------------------
-- Q24. employee-table 수요일에 태어난 직원 검색
--------------------------------------
select * from EMPLOYEE where
to_char(to_date(decode(substr(JUMIN_NUM,7,1),'1','19','2','19','20')||
       substr(JUMIN_NUM,1,6),'YYYYMMDD'),'D')=4;

---------------------------------------
-- Q25. employee-table 직급이 과장인 직원을 검색
--------------------------------------
select *from EMPLOYEE
where JIKUP='과장';

---------------------------------------
-- Q26. employee-table 직급이 과장이 아닌 직원을 검색
--------------------------------------
select * from EMPLOYEE
where JIKUP != '과장';

---------------------------------------
-- Q27. employee-table 10번부서의 직급이 과장인 직원 검색
--------------------------------------
select *
from EMPLOYEE
where DEP_NO = 10 and JIKUP = '과장';


---------------------------------------
-- Q28. employee-table 직급이 과장 또는 부장인 직원 검색
---------------------------------------
select * from EMPLOYEE
where JIKUP='과장'or JIKUP='부장';

select * from EMPLOYEE
where JIKUP = any('과장','부장');

select * from EMPLOYEE
where JIKUP in('과장','부장');


---------------------------------------
-- Q29. employee-table 10,20부서중 직급이 과장 검색
---------------------------------------
select * from EMPLOYEE
where (DEP_NO=10 or DEP_NO=20) and JIKUP = '과장';


---------------------------------------
-- Q30. customer 테이블 담당직원이 없는 고객 검색
---------------------------------------
select * from CUSTOMER
where emp_no is null;


---------------------------------------
-- Q31. customer 테이블 담당직원이 없는 고객 검색
---------------------------------------
select * from CUSTOMER
where emp_no is not null;

---------------------------------------
-- Q32. customer 테이블 담당직원번호가 9번이 아닌 고객 검색
---------------------------------------
select * from CUSTOMER
where EMP_NO!=9 or EMP_NO is null;

---------------------------------------
-- Q33. employee 테이블 연봉 4000 이상인 직원
---------------------------------------
select * from EMPLOYEE
where SALARY >= 4000;

---------------------------------------
-- Q34. employee 테이블 연봉 3000~4000 사이인 직원
---------------------------------------
select * from EMPLOYEE
where SALARY >=3000 and SALARY < 4000;

select * from EMPLOYEE
where SALARY between 3000 and 3999;

select * from EMPLOYEE
where SALARY between 3000 and 4000 and SALARY != 4000;

select * from EMPLOYEE
where SALARY between 3000 and 4000 and SALARY <> 4000;

---------------------------------------
-- Q35. employee 테이블 연봉 5% 인상할 경우 3000이상인 직원 검색
---------------------------------------
select *
from EMPLOYEE
where (SALARY*1.05)>=3000;


---------------------------------------
-- Q36. employee 테이블 입사일이 1995-1-1 이후인 사람
---------------------------------------
select * from EMPLOYEE
where HIRE_DATE>to_date('1995-1-1','YYYY-MM-DD');

---------------------------------------
-- Q37. employee 테이블 입사일이 1990-1999년인 사람 즉 90년대생검색
---------------------------------------
select * from EMPLOYEE
where HIRE_DATE>=to_date('1990-1-1','YYYY-MM-DD') and HIRE_DATE<to_date('2000-1-1','YYYY-MM-DD');

select * from EMPLOYEE
where extract(year from HIRE_DATE)>=1990 and extract(year from HIRE_DATE)<=1999;

select * from EMPLOYEE
where extract(year from HIRE_DATE) between 1990 and 1999;

select * from EMPLOYEE
where substr(to_char(HIRE_DATE,'YYYY'),1,3)='199';

select * from EMPLOYEE
where to_char(HIRE_DATE,'YYYY') like '199%';


---------------------------------------
-- Q38. employee 테이블 부서번호가 10 or 30 중 연봉이 3000 미만, 입사일이 1996-1-1이후인 직원
---------------------------------------
select * from EMPLOYEE
where (DEP_NO=10 or DEP_NO=30) and SALARY<3000 and HIRE_DATE<to_date('1996-1-1','YYYY-MM-DD');


---------------------------------------
-- Q39. employee 테이블 부서번호가 10 중 연봉이 2000 미만,
--                    부서번호가 20 중 연봉이 3500 이상,
---------------------------------------
select *
from EMPLOYEE
where (DEP_NO=10 and SALARY<2000) or (DEP_NO=20 and SALARY>3500);


---------------------------------------
-- Q40. employee 테이블 성이 김씨
---------------------------------------
select * from EMPLOYEE
where substr(EMP_NAME,1,1)='김';

select *
from EMPLOYEE
where EMP_NAME like '김%';

---------------------------------------
-- Q41. employee 테이블 직원이름 '라' 로 끝나는 직원
---------------------------------------
select * from EMPLOYEE
where substr(EMP_NAME,length(EMP_NAME),1)='라';


select * from EMPLOYEE
where EMP_NAME like '%라';

---------------------------------------
-- Q42. employee 테이블 성이 김씨이고 3글자이름인 직원
---------------------------------------
select * from EMPLOYEE
where EMP_NAME like '김%' and EMP_NAME like '___';


select * from EMPLOYEE
where substr(EMP_NAME,1,1)='김'and length(EMP_NAME)=3 ;

select *
from EMPLOYEE where EMP_NAME like '김__';


---------------------------------------
-- Q43. employee 테이블 김이 들어간 직원
---------------------------------------
select * from EMPLOYEE
where EMP_NAME like '%김%';


---------------------------------------
-- Q44. employee 테이블 이름이 두자
---------------------------------------

select * from EMPLOYEE
where EMP_NAME like '__';

select *from EMPLOYEE where length(EMP_NAME)=2;

---------------------------------------
-- Q45. employee 테이블 이름에 중간에만 미가 들어간 직원
---------------------------------------
select * from EMPLOYEE
where substr(EMP_NAME,1,1)!='미'
  and substr(EMP_NAME,length(EMP_NAME),1)!='미'
  and EMP_NAME like'%미%';

select *
from EMPLOYEE where EMP_NAME like '%미%' and EMP_NAME not like '미%%' and EMP_NAME not like '%%미';

select * from EMPLOYEE
where regexp_like(EMP_NAME,'^[^미][미][^미]$');


---------------------------------------
-- Q46. employee 테이블 여자직원 검색 (3가지방법)
---------------------------------------
select * from EMPLOYEE where substr(JUMIN_NUM,7,1)=2 or substr(JUMIN_NUM,7,1)=4;

select * from EMPLOYEE where substr(JUMIN_NUM,7,1) = any(2,4);
select * from EMPLOYEE where substr(JUMIN_NUM,7,1) in(2,4);

select * from EMPLOYEE where JUMIN_NUM like '______2%' or JUMIN_NUM like '______4%';


---------------------------------------
-- Q47. 아래 select 문은 무슨 요구사항을 반영한 것인가
---------------------------------------
select *from EMPLOYEE where JUMIN_NUM like '______1%' or JUMIN_NUM like '______2%';
--1900년대생 검색


---------------------------------------
-- Q48. 1960,70년대생 출생자 남자만 검색
---------------------------------------
select * from EMPLOYEE where JUMIN_NUM like '6_____1%' or JUMIN_NUM like '7_____1%';

---------------------------------------
-- Q49. 직원번호 직원명 주민번호 다가올생일(xxxx-xx-xx(수)) 생일까지 남은일 출력
---------------------------------------
select
    EMP_NO
    ,EMP_NAME
    ,case when
       sysdate -
        --올해 내생일
        to_date(to_char(sysdate,'YYYY')||substr(JUMIN_NUM,3,4),'YYYYMMDD')<0
    then to_char(to_date(to_char(sysdate,'YYYY')||substr(JUMIN_NUM,3,4),'YYYYMMDD'),'YYYY-MM-DD(dy)','NLS_DATE_LANGUAGE=Korean')
    else to_char(to_date(to_number(to_char(sysdate,'YYYY'))+1||substr(JUMIN_NUM,3,4),'YYYYMMDD'),'YYYY-MM-DD(dy)','NLS_DATE_LANGUAGE=Korean')
    end "다가올생일"

    ,case when
       sysdate - (to_date(to_char(sysdate,'YYYY')||substr(JUMIN_NUM,3,4),'YYYYMMDD'))<0
    then ceil(to_date(to_char(sysdate,'YYYY')||substr(JUMIN_NUM,3,4),'YYYYMMDD')- sysdate)
    else ceil(to_date((to_number(to_char(sysdate,'YYYY'))+1)||substr(JUMIN_NUM,3,4),'YYYYMMDD')-sysdate)
    end "생일 d-day"

from EMPLOYEE order by 3 asc;


---------------------------------------
-- Q50. 아래처럼 테이블을 만들고 데이터를 입력한 상태에서
--      제품 총 개수를 내람차순으로 제일 많은 것부터 정렬하여 보이면?
---------------------------------------
create table product (
    p_no number(3)
    ,p_name varchar2(20)    not null unique
    , tot_cnt varchar2(20)  not null
);

insert into product values(1,'컴퓨터1','20');
insert into product values(2,'컴퓨터2','2');
insert into product values(3,'컴퓨터3','4');
insert into product values(4,'컴퓨터4','2');
insert into product values(5,'컴퓨터5','16');
insert into product values(6,'컴퓨터6','60');
insert into product values(7,'컴퓨터7','30');
insert into product values(8,'컴퓨터8','27');
insert into product values(9,'컴퓨터9','25');
insert into product values(10,'컴퓨터10','22');
insert into product values(11,'컴퓨터11','34');
insert into product values(12,'컴퓨터12','50');
insert into product values(13,'컴퓨터13','8');
insert into product values(14,'컴퓨터14','9');
insert into product values(15,'컴퓨터15','10');

select * from product order by to_number(tot_cnt) desc;
select * from product order by length(tot_cnt) desc , tot_cnt desc;


---------------------------------------
-- join 문제
---------------------------------------
-- Q51. 직원번호 직원명 직급 소속부서명을 출력 ( 단 소속부서가 있는놈만 나와라)
---------------------------------------

-- 오라클 방식
select
e.EMP_NO    "직원번호"
,e.EMP_NAME "직원이름"
,e.JIKUP    "직원직급"
,d.DEP_NAME "소속부서명"

from EMPLOYEE e , DEPT d
where e.DEP_NO = d.DEP_NO;
-- ansi 방식
select
e.EMP_NO    "직원번호"
,e.EMP_NAME "직원이름"
,e.JIKUP    "직원직급"
,d.DEP_NAME "소속부서명"

from EMPLOYEE e inner join DEPT d
on e.DEP_NO = d.DEP_NO;

---------------------------------------
-- Q52. 고객명, 고객전화번호, 담당직원명, 담당직원직급 을 출력하면?
-- <조건> 담당직원이 있는 고객만 출력
---------------------------------------
-- 오라클 방식
select
c.CUS_NAME
,c.TEL_NUM
,e.EMP_NAME
,e.JIKUP

from EMPLOYEE e , CUSTOMER c
where e.EMP_NO = c.EMP_NO;

-- ansi 방식
select
c.CUS_NAME
,c.TEL_NUM
,e.EMP_NAME
,e.JIKUP

from EMPLOYEE e inner join CUSTOMER c
on e.EMP_NO = c.EMP_NO;

---------------------------------------
-- Q53. 고객명, 고객전화번호, 담당직원명, 담당직원직급 출력하면?
--      <조건> 10번부서의 담당직원이 있는 고객만 출력
---------------------------------------
--oracle 방식
select

c.CUS_NAME
,c.TEL_NUM
,e.EMP_NAME
,e.JIKUP

from EMPLOYEE e, CUSTOMER c
where e.DEP_NO = 10 and e.EMP_NO = c.EMP_NO;

--ansi 방식
select
c.CUS_NAME
,c.TEL_NUM
,e.EMP_NAME
,e.JIKUP
from EMPLOYEE e inner join CUSTOMER c
on e.EMP_NO = c.EMP_NO
where e.DEP_NO = 10;

---------------------------------------
--Q54. 직원번호, 직원명, 직원직급, 직원소속부서명, 담당고객명, 고객전화번호 를 출력하면?
--      <조건> 조건에 맞는 직원만 나오기, 직원이름 오름차순 정렬
----------------------------------------
select
     e.EMP_NO "직원번호"
    ,e.EMP_NAME "직원명"
    ,e.JIKUP "직원직급"
    ,d.DEP_NAME "직원소속부서명"
    ,e.EMP_NAME "담당고객명"
    ,c.TEL_NUM "고객전화번호"

from DEPT d , EMPLOYEE e, CUSTOMER c
where d.DEP_NO = e.DEP_NO and e.EMP_NO = c.EMP_NO
order by 2 asc;

----------------------------------------
--Q54. 직원번호e, 직원명e, 직원직급e, 연봉등급e 을 출력하면?
-- <inner join>
-- <2중조인>
-- order by 연봉등급 오름차순, 직급높은순서 오름차순, 나이많은순서 내림 유지 요망.
----------------------------------------
select
e.EMP_NO
,e.EMP_NAME
,e.JIKUP
,s.SAL_GRADE_NO

from EMPLOYEE e , SALARY_GRADE s
where e.SALARY >= s.MIN_SALARY and e.SALARY <=s.MAX_SALARY

order by s.SAL_GRADE_NO asc
        , decode(e.JIKUP,'사장',1,'부장',2,'과장',3,'대리',4,5) asc
        , TO_NUMBER(substr(JUMIN_NUM,1,6)) asc;

-------------------------------------------
-- Q.152 게시판 관련 테이블을 만들어보자.
-------------------------------------------
create table board(
     b_no       number
    ,subject    varchar2(50)    not null
    ,writer       varchar2(30)    not null
    ,reg_date   date            default sysdate
    ,readcount number(5)       default 0
    ,content    varchar2(2000)  not null
    ,pwd        varchar2(12)    not null
    ,email      varchar2(30)
    -------------------
    ,group_no       number(5)   not null
    ,print_no       number(5)   not null
    ,print_level    number(5)   not null
    ,primary key (b_no)
);

-------------------------------------------
-- Q.153 게시판에 처음으로 사오정이 글을 올린다면 sql 구문은?
-------------------------------------------

--제목 : 경제 침체의 원인
--이름 : 사오정
--내용 : 어쩌구 저쩌구
--암호 : 1234
--이메일 : a@naver.com

insert into board(
        b_no
        , subject
        , writer
        , content
        , pwd
        , email
        , group_no
        , print_no
        , print_level
) values(
         (select nvl(max(b_no),0)+1 from board)
         ,'경제 침체의 원인'
         ,'사오정'
         ,'어쩌구저쩌구'
         ,'1234'
         ,'a@naver.com'
         ,(select nvl(max(b_no),0)+1 from board)
         ,0
         ,0
        );

-------------------------------------------
-- Q.154 저팔계가 사오정의 댓글로 아래와 같은 글을 올린다면?
-- 단 사오정의 pk 번호는 1 이다.
-------------------------------------------

--제목 : 나라 빚 관리 부실
--이름 : 저팔계
--내용 : 어쩌구 저쩌구 내용물
--암호 : 2345
--이메일 : b@naver.com
----------------------------------------------------------------
-- 1. 엄마 조회수 1 증가
----------------------------------------------------------------
-- 엄마는 누구인가? pk 번호가 1인 행이 엄마다.
update board set readcount = readcount +1 where b_no=1;
----------------------------------------------------------------
-- 2. 엄마의 후손 글들 출력번호 1 증가
----------------------------------------------------------------
-- 엄마 후손글들 앞으로 들어갈거다. 그럼 엄마 후손들의 출력번호를 1씩 증가해야한다.
-- 엄마의 후손은 어떻게 얻는가?

-- 1) 엄마의 글의 그룹번호가 같고 2)엄마의 글의 출력순서보다 크다.
-- 출력번호 1 증가 시킨다.
update board set print_no = print_no +1
-- 누구를 ? 그릅넘버 = 엄마 그룹넘버
where group_no = (select group_no from board where b_no=1)
and group_no > (select group_no from board where b_no=1);
----------------------------------------------------------------
-- 3. 사오정의 글을 삽입하기.
----------------------------------------------------------------
insert into board (
    b_no
    , subject
    , writer
    , content
    , pwd
    , email
    , group_no
    , print_no
    , print_level
)
values (
        (select nvl(max(b_no),0)+1 from board)
    ,'나라 빚 관리 부실'
    ,'저팔계'
    ,'어쩌구저쩌구'
    ,'2345'
    ,'b@naver.com'
    ,(select group_no from board where b_no=1)
    ,(select print_no+1 from board where b_no=1)
    ,(select print_level+1 from board where b_no=1)
);
--------------------------------------------------
-- Q.155 ***중요*** board 테이블 안의 데이터를 웹브라우저에 출력할 때 select 문?
--------------------------------------------------

select
       (select count(*) from board )-ROWNUM +1
        ,d.*
from (
         select lpad(' ', print_level * 5, ' ') || decode(print_no, 0, '', 'ㄴ') || subject
              , writer
              , reg_date
              , readcount
         from board
         order by group_no desc
                , print_no asc
     )d ;
--------------------------------
select
       e.totcnt-ROWNUM +1
        ,d.*
from (
         select lpad(' ', print_level * 5, ' ') || decode(print_no, 0, '', 'ㄴ') || subject
              , writer
              , reg_date
              , readcount
         from board
         order by group_no desc
                , print_no asc
     )d , (select count(*) "TOTCNT" from board ) e
;

------------
-- 테이블 설게
------------
------------------------------------------------
-- Q.156 아래와 같은 데이터가 웹서버로 들어왔다.
-- 어떤 테이블에 저장되는지 테이블을 설계해보시오.
------------------------------------------------
-- 개발자 이름
-- 개발자 주민번호 앞
-- 개발자 주민번호 뒤
-- 개발자 종교. 단 1개만 목록은 기독교, 청주교, 불교, 이슬람교, 무교
-- 개발자 학력, 단 1개만 목록은 중졸, 고졸, 전문대졸, 일반대졸
-- 개발자 스킬, 단 1개 이상 목록은 java, jsp, php, delphi
-- 개발자 졸업일, 목록 년,월,일
------------------------------------------------
-- 1.skill 목록
------------------------------------------------
create table code_skill1(
    skill_code number(3)
    ,skill_name varchar2(20) not null unique
    ,primary key (skill_code)
);
insert into code_skill1 values(1,'Java');
insert into code_skill1 values(2,'JSP');
insert into code_skill1 values(3,'ASP');
insert into code_skill1 values(4,'PHP');
insert into code_skill1 values(5,'Delphi');
------------------------------------------------
--2.religion 목록
------------------------------------------------
create table code_religion1(
    religion_code number(3)
    ,religion_name varchar2(20) not null unique
    ,primary key (religion_code)
);
insert into code_religion1 values(1,'기독교');
insert into code_religion1 values(2,'천주교');
insert into code_religion1 values(3,'불교');
insert into code_religion1 values(4,'이슬람교');
insert into code_religion1 values(5,'무교');
------------------------------------------------
--3.school 목록
------------------------------------------------
create table code_school1(
    school_code number(3)
    ,school_name varchar2(20) not null unique
    ,primary key (school_code)
);
insert into code_school1 values (1,'고졸');
insert into code_school1 values (2,'전문대졸');
insert into code_school1 values (3,'일반대졸');
------------------------------------------------
--4. 개발자 관련 데이터 저장하는 developer 테이블 만들기
------------------------------------------------
create table developer1(
    developer_no    number(3) not null
    ,developer_name varchar2(14) not null
    ,jumin_num  varchar2(14) not null unique
    ,religion_code number(3) not null
    ,school_code    number(3) not null
    ,graduate_date date not null
    ,primary key (developer_no)
    ,foreign key (religion_code) references code_religion1(religion_code)
    ,foreign key (school_code) references code_school1(school_code)
);
------------------------------------------------
--5. 개발자가 선택한 기술을 저장하는 developer 테이블 생성하기
------------------------------------------------
create table developer_skill1(
    developer_no number(3) not null
    ,skill_code number(3) not null
    ,foreign key (developer_no) references developer1(developer_no)
    ,foreign key (skill_code) references code_skill1(skill_code)
);
------------------------------------------------
-- Q.157 아래와 같은 데이터가 웹서버로 들어왔다.
-- 설계된 테이블에 데이터를 입력하는 insert 구문은?
------------------------------------------------
-- 개발자 이름        =>문유진
-- 개발자 주민번호 앞  =>011215
-- 개발자 주민번호 뒤  =>401814
-- 개발자 종교.      =>무교
-- 개발자 학력       =>일반대졸
-- 개발자 스킬       =>java,jsp
-- 개발자 졸업일      =>2019-12-25
insert into developer1(
    developer_no
    ,developer_name
    ,jumin_num
    ,religion_code
    ,school_code
    ,graduate_date
)values (
    (select nvl(max(developer_no),0)+1 from developer1)
    ,'문유진'
    ,'911111-2222222'
    ,(select religion_code from code_religion1 where religion_name ='무교' )
    ,(select school_code from code_school1 where school_name = '일반대졸')
    ,to_date('2019-12-23','YYYY-MM-DD')
);
insert into developer_skill1(
    developer_no, skill_code
) values(
         (select max(developer_no) from developer1)
         ,(select skill_code from code_skill1 where skill_name='Java')
        );
insert into developer_skill1(
    developer_no, skill_code
) values(
         (select max(developer_no) from developer1)
         ,(select skill_code from code_skill1 where skill_name='JSP')
        );
---------------
-- 병합
---------------
insert into developer_skill1(
        developer_no, skill_code
) select (select max(developer_no) from developer1),skill_code from code_skill1 where skill_name='Java'
union
select (select max(developer_no)from developer1),skill_code from code_skill1 where skill_name='Jsp' ;
select * from developer1;
select * from developer_skill1;
------------------------------------------------------------
-- Q.158 아래와 같은 데이터가 수정모드로 웹서버로 들어왔다. update 구문은?
------------------------------------------------------------
-- 개발자 고유번호    =>1
-- 개발자 이름       =>문유진
-- 개발자 주민번호 앞  =>011215
-- 개발자 주민번호 뒤  =>401814
-- 개발자 종교.      =>천주교 /
-- 개발자 학력       =>일반대졸
-- 개발자 스킬       =>java,jsp,Delphi /
-- 개발자 졸업일      =>2019-12-25
update developer1 set
 developer_name='문유진'
,jumin_num='011215-501814'
,school_code=(select school_code from code_school1 where school_name='일반대졸')
,religion_code=(select religion_code from code_religion1 where religion_name='천주교')
,graduate_date=to_date('2019-12-25','YYYY-MM-DD')
where developer_no=1;

delete from developer_skill1 where developer_no=1;

insert into developer_skill1(developer_no, skill_code)
values (1,(select skill_code from code_skill1 where skill_name = 'Java'));


insert into developer_skill1(developer_no, skill_code)
values (1,(select skill_code from code_skill1 where skill_name = 'JSP'));


insert into developer_skill1(developer_no, skill_code)
values (1,(select skill_code from code_skill1 where skill_name = 'Delphi'))

------------------------------------------------
-- 검색
------------------------------------------------

------------------------------------------------
-- ★★★★★★★★★★★★★★★★★★★★★★★★중요 ★★★★★★★★★★★★★★★★★★★★★★★★★★
-- Q.159 아래 조건을 가지고 개발자를 검색하는 SQL 구문은?
-- 출력 컬럼은 정순일련번호, 이름, 성별, 나이, 생일, 종교, 졸업일이다.
------------------------------------------------
-- 검색조건 :
-- 학력 : 전문대졸 또는 일반대졸
-- 기술 : Java 또는 JSP
-- 나이 : 30~35
-- 키워드 : 'jsp'

select
    d.developer_name
        "이름"
    ,decode(substr(d.jumin_num,7,1),'1','남','3','남','여')
        "성별"
    ,extract(year from sysdate) -
       to_number(decode(substr(d.jumin_num,7,1),'1','19','2','19','20')||substr(d.jumin_num,1,2))
        +1
        "나이"
    ,to_date(decode(substr(d.jumin_num,7,1),'1','19','2','19','20')||substr(d.jumin_num,1,6),'YYYY-MM-DD')
        "생일"
    ,(select religion_name from code_religion1 cr where cr.religion_code = d.religion_code)
    ,d.graduate_date
from developer1 d
where d.school_code = any(select d.school_code from code_school1  where school_name in( '전문대졸','일반대졸') )
and
      d.developer_no = any(select developer_no from developer_skill1
      where skill_code in (select SKILL_CODE from code_skill where SKILL_NAME= any('JSP','Java')))
and (extract(year from sysdate) -
       to_number(decode(substr(d.jumin_num,7,1),'1','19','2','19','20')||substr(d.jumin_num,1,2))
        +1) between 30 and 35
and upper(d.developer_name) like upper('%JSP%')
    or
      upper(d.jumin_num) like upper('%JSP%')
    or
      upper(d.graduate_date) like upper('%JSP%')
    or
      d.religion_code = any(select religion_code from code_religion1 where upper(religion_name) like upper('%JSP%') )
    or
      d.school_code = any(select school_code from code_school1 where upper(school_name) like upper('%JSP%'))
    or
      d.developer_no = any(
          select developer_no from developer_skill1 where skill_code =any(
              select skill_code from code_skill1 where upper(skill_name) like upper('%JSP%')) );


-- -- 개발자 이름       =>문유진
-- -- 개발자 주민번호 앞  =>011215
-- -- 개발자 주민번호 뒤  =>401814
-- -- 개발자 종교.      =>천주교 /
-- -- 개발자 학력       =>일반대졸
-- -- 개발자 스킬       =>java,jsp,Delphi /
-- -- 개발자 졸업일      =>2019-12-25

------------------------------------------------
-- Q.160 삭제 목적으로 아래와 같은 데이터가 웹서버로 들어왔다. 삭제 SQL은?
------------------------------------------------
delete from developer1 where developer_no=1;
delete from developer_skill1 where developer_no=1;

------------------------------------------------
-- Q.161 아래와 같은 데이터가 웹서버로 들어왔다. 어떤 테이블에 저장되는지 테이블을 설계하면?
------------------------------------------------
-- 학생이름             => 박지성
-- 학생주민번호 앞번호     => 011215
-- 학생주민번호 뒷번호     => 4018414
-- 학생 전화번호         => 010-1234-1234
-- 학생 대학지원분야      => 공대 또는 자연대 또는 인문대 또는 의대 중에 1개 이
-- 학생 가족 정보        =>
--                   관계 => 부     이름 => 박명수   출생연도=>1950
--                   관계 => 모     이름 => 한수민   출생연도=>1953
--                   관계 => 형     이름 => 박주영   출생연도=>1988

create table student1 (
    stu_no number(3) not null
    ,stu_name varchar2(20) not null
    ,jumin_num varchar2(20) not null unique
    ,phone varchar2(20) not null unique
    ,primary key (stu_no)
);
create table stu_family1(
    family_no number(3) not null
    ,stu_no number(3) not null
    ,relation varchar2(20) not null
    ,family_name varchar2(20) not null
    ,birth_year number(4) not null
    ,foreign key (stu_no) references student1(stu_no)
);
create table stu_univ_app1(
    stu_no number(3) not null
    ,major_code number(3) not null
    ,foreign key (major_code) references code_major(major_code)
    ,foreign key (stu_no) references  student1(stu_no)
);
create table code_major1(
    major_code number(3) not null
    ,major_name varchar2(20) not null  unique
    ,primary key (major_code)
);
insert into code_major1 (major_code, major_name) values (1,'공대');
insert into code_major1 (major_code, major_name) values (2,'자연대');
insert into code_major1 (major_code, major_name) values (3,'인문대');
insert into code_major1 (major_code, major_name) values (4,'의대');
insert into code_major1 (major_code, major_name) values (5,'기타');
-- 학생이름             => 박지성
-- 학생주민번호 앞번호     => 011215
-- 학생주민번호 뒷번호     => 4018414
-- 학생 전화번호         => 010-1234-1234
-- 학생 대학지원분야      => 공대 또는 자연대 또는 인문대 또는 의대 중에 1개 이
-- 학생 가족 정보        =>
--                   관계 => 부     이름 => 박명수   출생연도=>1950
--                   관계 => 모     이름 => 한수민   출생연도=>1953
--                   관계 => 형     이름 => 박주영   출생연도=>1988
insert into student1 (stu_no, stu_name, jumin_num, phone) values
(
 (select nvl(max(stu_no),0)+1 from student1)
 ,'박지성'
 ,'011215-4018414'
 ,'010-1234-1234'
);
insert into stu_family1(family_no, stu_no, relation, family_name, birth_year) values
(
 (select nvl(max(family_no),0)+1 from stu_family1 )
 ,(select max(stu_no) from student1)
 ,'부'
 ,'박명수'
 ,1950
);
insert into stu_family1(family_no, stu_no, relation, family_name, birth_year) values
(
 (select nvl(max(family_no),0)+1 from stu_family1 )
 ,(select max(stu_no) from student1)
 ,'모'
 ,'한수민'
 ,1953
);
insert into stu_family1(family_no, stu_no, relation, family_name, birth_year) values
(
 (select nvl(max(family_no),0)+1 from stu_family1 )
 ,(select max(stu_no) from student1)
 ,'형'
 ,'박주영'
 ,1988
);
select *from student1;
select *from stu_family1;
select *from stu_univ_app1;
insert into stu_univ_app1 (stu_no, major_code) values
(
 (select max(stu_no) from student1)
 ,(select major_code from code_major1 where major_name ='자연대' )
);
insert into stu_univ_app1 (stu_no, major_code) values
(
 (select max(stu_no) from student1)
 ,(select major_code from code_major1 where major_name ='공대' )
);

--update 구문
update student1 set
    stu_name='박지성'
    ,jumin_num='011215-4018414'
    ,phone='010-1234-1234'
where stu_no =1;
--- 가족 수정
delete from stu_family1 where stu_no=1;

insert into stu_family1(family_no, stu_no, relation, family_name, birth_year) values
(
 (select nvl(max(family_no),0)+1 from stu_family1 )
 ,1
 ,'부'
 ,'박명수'
 ,1950
);
insert into stu_family1(family_no, stu_no, relation, family_name, birth_year) values
(
 (select nvl(max(family_no),0)+1 from stu_family1 )
 ,1
 ,'모'
 ,'한수민'
 ,1953
);
insert into stu_family1(family_no, stu_no, relation, family_name, birth_year) values
(
 (select nvl(max(family_no),0)+1 from stu_family1 )
 ,1
 ,'형'
 ,'박주영'
 ,1988
);
insert into stu_family1(family_no, stu_no, relation, family_name, birth_year) values
(
 (select nvl(max(family_no),0)+1 from stu_family1 )
 ,1
 ,'매'
 ,'박소담'
 ,2021
);
delete from stu_univ_app1 where stu_no=1;
insert into stu_univ_app1 (stu_no, major_code) values
(
 1
 ,(select major_code from code_major1 where major_name ='자연대' )
);
insert into stu_univ_app1 (stu_no, major_code) values
(
 1
 ,(select major_code from code_major1 where major_name ='의대' )
);

-- Q.165 학생 관련 테이블들에서
--      [일련번호], [학생명], [학생전화번호], [학생주민번호], [학생가족수], [대학지원분야수] 검색하면?
--단 조건은 남학생이고, 가족수는 2명인 학생만 검색하시오.

