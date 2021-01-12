# oracle_table_create_insert_update_delete
테이블 설계 예제 마지막 


    [ 목록 테이블을 따로 만드는 이유 ]
    ▶︎모든 목록은 디비에 테이블로 갖다쓰나?
    ▶︎변하지 않는 목록(ex 성별, 무의미한 연도,)은 굳이 오라클꺼 안갖다 쓰는 경우도 있다.
    ▶︎목록을 만드는 이유 고객에의해 자주 바뀌거나 하면 DB에서 갖다 쓴다.
    ▶︎추가수정 반영시 그대로 갖다쓰니까 좋다. 
    ▶︎목록 테이블 특징 : code_이름 (★관용적) code_school/code_religion
    ▶︎체크박스는 1개 이상 들어올경우 테이블에 어떻게 집어넣나?
    ▶︎따로 테이블을 만들어 직원번호를 같이 따로 저장해버리면 갖다 붙일 수 있다.


    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- Q.157 아래와 같은 데이터가 웹서버로 들어왔다.
    -- 설계된 테이블에 데이터를 입력하는 insert 구문은?
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- 개발자 이름 =>문유진
    -- 개발자 주민번호 앞 =>011215
    -- 개발자 주민번호 뒤 =>401814
    -- 개발자 종교. =>무교
    -- 개발자 학력 =>일반대졸
    -- 개발자 스킬 =>java,jsp
    -- 개발자 졸업일 =>2019-12-25
    insert into developer (
    developer_no
    ,developer_name
    ,jumin_num
    ,religion_code
    ,school_code
    ,graduate_date
    )values (
    (select nvl(max(developer_no),0)+1 from developer)
    ,'문유진'
    ,'011215-4018144'
    ,(select religion_code from code_religion where religion_name='무교')
    ,(select school_code from code_school where school_name='일반대졸')
    ,to_date('2019-12-25','YYYY-MM-DD')
    );
    select *from developer;
    select *from developer_skill;

    insert into developer_skill(
    developer_no
    ,skill_code
    )values(
    (select max(developer_no) from developer)
    ,(select skill_code from code_skill where skill_name='Java')
    );

    insert into developer_skill(
    developer_no
    ,skill_code
    )values(
    (select max(developer_no) from developer)
    ,(select skill_code from code_skill where skill_name='JSP')
    );
    ----------------
    -- 위 developer_skill 코딩을 병합
    -- ----------------
    -- insert into developer_skill(
    -- developer_no, skill_code
    -- ) select (select max(developer_no) from developer), skill_code from code_skill where skill_name='Java'
    -- union select (select max(developer_no) from developer), skill_code from code_skill where skill_name='JSP';


    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- 수정
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- Q.158 아래와 같은 데이터가 수정모드로 웹서버로 들어왔다. update 구문은?
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- 개발자 고유번호 =>1
    -- 개발자 이름 =>문유진
    -- 개발자 주민번호 앞 =>011215
    -- 개발자 주민번호 뒤 =>401814
    -- 개발자 종교. =>천주교 /
    -- 개발자 학력 =>일반대졸
    -- 개발자 스킬 =>java,jsp,Delphi /
    -- 개발자 졸업일 =>2019-12-25
    --------------------------------------------
    --developer 테이블 수정하기 (수정할땐 전체를 다 수정)
    --------------------------------------------
    -- developer_no
    -- ,developer_name
    -- ,jumin_num
    -- ,religion_code
    -- ,school_code
    -- ,graduate_date
    update
    developer
    set
    developer_name='문유진'
    ,jumin_num='011215-401814'
    ,school_code=(select school_code from code_school where school_name='일반대졸')
    ,religion_code=(select religion_code from code_religion where religion_name='천주교')
    ,graduate_date=to_date('2019-12-25','YYYY-MM-DD')
    where developer_no=1;
    select * from developer;
    select * from developer_skill;
    --------------------------------------------
    --developer_skill 테이블 수정하기
    --그러나 developer_skill 테이블에는 한명의 개발자 다중행으로 데이터가 저장되어있으므로
    --update로 수정할 수 없고 지우고 입력해야 한다.
    --------------------------------------------
    delete from developer_skill where developer_no=1;

    insert into developer_skill(developer_no, skill_code)
    select 1, skill_code from code_skill where skill_name = 'Java'
    union
    select 1, skill_code from code_skill where skill_name = 'JSP'
    union
    select 1, skill_code from code_skill where skill_name = 'Delphi';


    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- 검색
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- ★★★★★★★★★★★★★★★★★★★★★★★★중요 ★★★★★★★★★★★★★★★★★★★★★★★★★★
    -- Q.159 아래 조건을 가지고 개발자를 검색하는 SQL 구문은?
    -- 출력 컬럼은 정순일련번호, 이름, 성별, 나이, 생일, 종교, 졸업일이다.
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- 검색조건
    -- 학력을 '전문대졸' 또는 '일반대졸'
    -- 기술을 'Java' 또는 'JSP'
    -- 나이를 '30세 ~ 35세'로 선택
    -- 키워드로 '오'.
    ----------------------------
    select
    rownum
    "번호"
    -----------------------------------------------------------------------------------------------------------------------------
    ,s.developer_name
    "개발자명"
    -----------------------------------------------------------------------------------------------------------------------------
    , decode( substr(s.jumin_num,7,1), '1', '남', '3', '남', '여' )
    "성별"
    -----------------------------------------------------------------------------------------------------------------------------
    , to_char(
    to_date( decode( substr(s.jumin_num,7,1), 1, '19', 2, '19', '20' )||substr(s.jumin_num,1,6), 'YYYYMMDD' )
    , 'YYYY-MM-DD'
    ) "생년월일"
    ----------------------------------------------------------------------------------------------------------------------------- "생년월일"
    , extract( year from sysdate ) -
    to_number( decode( substr(s.jumin_num,7,1), '1', '19', '2', '19', '20' )||substr(s.jumin_num,1,2) ) + 1
    "나이"
    -----------------------------------------------------------------------------------------------------------------------------
    , (select cr.religion_name from code_religion cr where cr.religion_code=s.religion_code)
    "종교"
    -----------------------------------------------------------------------------------------------------------------------------
    , to_char(s.graduate_date,'YYYY-MM-DD')
    "졸업일"
    -----------------------------------------------------------------------------------------------------------------------------
    from developer s
    where
    s.school_code=any( select school_code from code_school where school_name in('전문대졸', '일반대졸') )
    and
    s.developer_no=any(
    select developer_no from developer_skill where skill_code
    in(select skill_code from code_skill where skill_name in('Java','JSP'))
    )
    and (
    extract( year from sysdate ) -
    to_number( decode( substr(s.jumin_num,7,1), '1', '19', '2', '19', '20' )||substr(s.jumin_num,1,2) )+1 between 30 and 35
    )
    and (
    upper(s.developer_name) like upper('%오%')
    or upper(s.jumin_num) like upper('%오%')
    or upper(s.graduate_date) like upper('%오%')
    or s.religion_code= any(
    select religion_code from code_religion where upper(religion_name) like upper('%오%')
    )

    or s.school_code=any(
    select school_code from code_school where upper(school_name) like upper('%오%')
    )
    or s.developer_no=any(
    select developer_no from developer_skill where skill_code in (
    select skill_code from code_skill where upper(skill_name) like upper('%오%')
    )
    )
    );


    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- Q.160 삭제 목적으로 아래와 같은 데이터가 웹서버로 들어왔다. 삭제 SQL은?
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    delete from developer_skill where developer_no=1;
    delete from developer where developer_no=1;


    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- Q.161 아래와 같은 데이터가 웹서버로 들어왔다. 어떤 테이블에 저장되는지 테이블을 설계하면?
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- 학생이름 => 박지성
    -- 학생주민번호 앞번호 => 011215
    -- 학생주민번호 뒷번호 => 4018414
    -- 학생 전화번호 => 010-1234-1234
    -- 학생 대학지원분야 => 공대 또는 자연대 또는 인문대 또는 의대 중에 1개 이
    -- 학생 가족 정보 =>
    -- 관계 => 부 이름 => 박명수 출생연도=>1950
    -- 관계 => 모 이름 => 한수민 출생연도=>1953
    -- 관계 => 형 이름 => 박주영 출생연도=>1988
    ----------------------------------
    -- 학생 정보
    ----------------------------------
    create table student(
    stu_no number(3) not null
    ,stu_name varchar2(10) not null
    ,jumin_num varchar2(14) not null unique
    ,phone varchar2(20) not null unique
    ,primary key (stu_no)
    );
    ----------------------------------
    -- 학생 정보(가족)
    ----------------------------------
    create table stu_family(
    stu_family_no number(3)
    ,stu_no number(3)
    ,relation varchar2(20) not null
    ,family_name varchar2(20) not null
    ,birth_year number(4) not null
    ,foreign key(stu_no) references student(stu_no)
    ,primary key (stu_family_no)
    );

    ----------------------------------
    -- 학생 전공 정보
    ----------------------------------
    create table stu_univ_app(
    stu_no number(3)
    ,major_code number(3)
    ,foreign key(stu_no) references student(stu_no)
    ,foreign key (major_code) references code_major(major_code)
    );
    ----------------------------------
    -- 전공 목록
    ----------------------------------
    create table code_major(
    major_code number(3) not null
    ,major_name varchar2(20) not null unique
    ,primary key (major_code)
    );
    insert into code_major values(1,'공대');
    insert into code_major values(2,'자연대');
    insert into code_major values(3,'인문대');
    insert into code_major values(4,'의대');
    insert into code_major values(5,'기타');


    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- Q.162 아래와 같은 데이터가 웹서버로 들어왔다. 어떤 테이블에 저장되는지 insert 구문은?
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- 학생이름 => 박지성
    -- 학생주민번호 앞번호 => 011215
    -- 학생주민번호 뒷번호 => 4018414
    -- 학생 전화번호 => 010-1234-1234
    -- 학생 대학지원분야 => 공대 자연대
    -- 학생 가족 정보 =>
    -- 관계 => 부 이름 => 박명수 출생연도=>1950
    -- 관계 => 모 이름 => 한수민 출생연도=>1953
    -- 관계 => 형 이름 => 박주영 출생연도=>1988
    ----------------------------------------------------------------
    insert into student(
    stu_no, stu_name, jumin_num ,phone
    )values (
    (select nvl(max(stu_no),0)+1 from student)
    ,'박지성'
    ,'011215-4018414'
    ,'010-1234-1234'
    );
    ----------------------------------------------------------------
    insert into stu_univ_app(
    stu_no, major_code
    ) values (
    (select max(stu_no) from student)
    ,(select major_code from code_major where major_name ='공대' )
    );
    ----------------------------------------------------------------
    insert into stu_univ_app(
    stu_no, major_code
    ) values (
    (select max(stu_no) from student)
    ,(select major_code from code_major where major_name ='자연대' )
    );
    ----------------------------------------------------------------
    insert into stu_family (stu_family_no, stu_no, relation, family_name, birth_year) VALUES
    (
    (select nvl(max(stu_family_no),0)+1 from stu_family)
    ,(select max(stu_no) from student)
    ,'부'
    ,'박명수'
    ,1950
    );
    ----------------------------------------------------------------
    insert into stu_family (stu_family_no, stu_no, relation, family_name, birth_year) VALUES
    (
    (select nvl(max(stu_family_no),0)+1 from stu_family)
    ,(select max(stu_no) from student)
    ,'모'
    ,'한수민'
    ,1953
    );
    ----------------------------------------------------------------
    insert into stu_family (stu_family_no, stu_no, relation, family_name, birth_year) VALUES
    (
    (select nvl(max(stu_family_no),0)+1 from stu_family)
    ,(select max(stu_no) from student)
    ,'형'
    ,'박주영'
    ,1988
    );
    --===============================================================
    --union으로 병합하기
    --===============================================================
    insert into stu_family (stu_family_no, stu_no, relation, family_name, birth_year)

    select
    (select nvl(max(stu_family_no),0)+1 from stu_family)
    ,(select max(stu_no) from student)
    ,'부'
    ,'박명수'
    ,1950
    from dual
    union
    select
    (select nvl(max(stu_family_no),0)+2 from stu_family)
    ,(select max(stu_no) from student)
    ,'모'
    ,'한수민'
    ,1953

    from dual
    union
    select
    (select nvl(max(stu_family_no),0)+3 from stu_family)
    ,(select max(stu_no) from student)
    ,'형'
    ,'박주영'
    ,1988
    from dual;
    ------------------------------------------------------------
    select*from student;
    select*from stu_family;
    select*from stu_univ_app;
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- Q.163 161에서 만들어진 테이블에 데이터를 수정하는 update 구문은?
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- 학생번호 => 1
    -- 학생이름 => 박지성
    -- 학생주민번호 앞번호 => 011215
    -- 학생주민번호 뒷번호 => 4018414
    -- 학생 전화번호 => 010-1234-1234
    -- 학생 대학지원분야 => 의대, 자연대 /
    -- 학생 가족 정보 =>
    -- 관계 => 부 이름 => 박명수 출생연도=>1950
    -- 관계 => 모 이름 => 한수민 출생연도=>1953
    -- 관계 => 형 이름 => 박주영 출생연도=>1988
    -- 관계 => 매 이름 => 박소담 출생연도=>2021 /

    --================================================================
    -- 1.학생 정보 변경
    --================================================================
    update student set
    stu_name = '박지성'
    ,jumin_num = '011215-4018414'
    ,phone = '010-1234-1234'
    where stu_no = 1;
    --================================================================
    -- 2.학생 가족 변경
    --================================================================
    delete from stu_family where stu_no=1;
    ----------------------------------------------------------------
    insert into stu_family (stu_family_no, stu_no, relation, family_name, birth_year) VALUES
    (
    (select nvl(max(stu_family_no),0)+1 from stu_family)
    ,1
    ,'부'
    ,'박명수'
    ,1950
    );
    ----------------------------------------------------------------
    insert into stu_family (stu_family_no, stu_no, relation, family_name, birth_year) VALUES
    (
    (select nvl(max(stu_family_no),0)+1 from stu_family)
    ,1
    ,'모'
    ,'한수민'
    ,1953
    );
    ----------------------------------------------------------------
    insert into stu_family (stu_family_no, stu_no, relation, family_name, birth_year) VALUES
    (
    (select nvl(max(stu_family_no),0)+1 from stu_family)
    ,1
    ,'형'
    ,'박주영'
    ,1988
    );
    ----------------------------------------------------------------
    insert into stu_family (stu_family_no, stu_no, relation, family_name, birth_year) VALUES
    (
    (select nvl(max(stu_family_no),0)+1 from stu_family)
    ,1
    ,'매'
    ,'박소담'
    ,2021
    );
    --================================================================
    --3. 전공 수정 (지우고 들어가야 한다)
    --================================================================
    delete from stu_univ_app where stu_no=1;
    ----------------------------------------------------------------
    insert into stu_univ_app(
    stu_no, major_code
    )values(
    1
    ,(select major_code from code_major where major_name ='의대' )
    );
    ----------------------------------------------------------------
    insert into stu_univ_app(
    stu_no, major_code
    )values(
    1
    ,(select major_code from code_major where major_name ='자연대' )
    );

    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- Q.164 학생 관련 테이블들에서 조건 없이 모든 학생의
    -- [일련번호], [학생명], [학생전화번호], [학생주민번호], [학생가족수], [대학지원분야수] 검색하면?
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    select
    s1.stu_name
    ,s1.phone
    ,s1.jumin_num
    --,(select max(stu_family_no) from stu_family )
    ,(select count(*) from stu_family s2 where s2.stu_no = s1.stu_no) "가족수"
    ,(select count(*) from stu_univ_app s3 where s3.stu_no = s1.stu_no) "대학지원분야수"
    from student s1 ;


    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm
    -- Q.165 학생 관련 테이블들에서
    -- [일련번호], [학생명], [학생전화번호], [학생주민번호], [학생가족수], [대학지원분야수] 검색하면?
    --단 조건은 남학생이고, 가족수는 2명인 학생만 검색하시오.
    --mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm


    select
    s1.stu_name
    ,s1.phone
    ,s1.jumin_num
    --,(select max(stu_family_no) from stu_family )
    ,(select count(*) from stu_family s2 where s2.stu_no = s1.stu_no) "가족수"
    ,(select count(*) from stu_univ_app s3 where s3.stu_no = s1.stu_no) "대학지원분야수"
    from student s1
    where substr(s1.jumin_num,7,1) in('1','3') or (select count(*) from stu_family s2 where s2.stu_no = s1.stu_no)=2 ;
    select *from student;
    select *from stu_family;
    select *from stu_univ_app;

    insert into student(
    stu_no, stu_name, jumin_num ,phone
    )values (
    (select nvl(max(stu_no),0)+1 from student)
    ,'박아성'
    ,'011215-3018414'
    ,'010-1334-1234'
    );
    ----------------------------------------------------------------
    insert into stu_univ_app(
    stu_no, major_code
    ) values (
    (select max(stu_no) from student)
    ,(select major_code from code_major where major_name ='공대' )
    );
    ----------------------------------------------------------------
    insert into stu_univ_app(
    stu_no, major_code
    ) values (
    (select max(stu_no) from student)
    ,(select major_code from code_major where major_name ='자연대' )
    );
    ----------------------------------------------------------------
    insert into stu_family (stu_family_no, stu_no, relation, family_name, birth_year) VALUES
    (
    (select nvl(max(stu_family_no),0)+1 from stu_family)
    ,(select max(stu_no) from student)
    ,'부'
    ,'박명수'
    ,1950
    );
    ----------------------------------------------------------------
    insert into stu_family (stu_family_no, stu_no, relation, family_name, birth_year) VALUES
    (
    (select nvl(max(stu_family_no),0)+1 from stu_family)
    ,(select max(stu_no) from student)
    ,'모'
    ,'한수민'
    ,1953
    );
