/* 
Assignment 3 : PROG3200
Name: Bishwajit Barua
Reg: 6397699
CPA student (Level 3)
Conestoga College
*/

--Answer Question 1
SET SERVEROUTPUT ON;
DECLARE 

   c_salutation studentdb.instructor.salutation%type; 
   c_first_name studentdb.instructor.first_name%type; 
   c_last_name studentdb.instructor.first_name%type;  
   CURSOR c_instructor is 
      SELECT salutation, first_name, last_name FROM STUDENTDB.INSTRUCTOR; 
      
      TYPE t_assoc_array IS TABLE OF VARCHAR2(20) INDEX BY VARCHAR2(15); 
      v_instructor_array t_assoc_array;  
  
BEGIN 
   OPEN c_instructor; 
   LOOP 
   FETCH c_instructor into c_salutation, c_first_name, c_last_name; 
      EXIT WHEN c_instructor%notfound; 
      
    v_instructor_array('Salution') := c_salutation;   
    v_instructor_array('first_name') := c_first_name;   
    v_instructor_array('last_name') := c_last_name;
      
      DBMS_OUTPUT.PUT_LINE(v_instructor_array('Salution')  || ' ' || v_instructor_array('first_name') || ' ' || v_instructor_array('last_name')); 
   END LOOP; 
   CLOSE c_instructor; 
END; 
/

--Answer Question 2
SET SERVEROUTPUT ON;
DECLARE 

   c_salutation STUDENTDB.INSTRUCTOR.salutation%type; 
   c_first_name STUDENTDB.INSTRUCTOR.first_name%type; 
   c_last_name STUDENTDB.INSTRUCTOR.first_name%type;  
   CURSOR c_instructor is 
      SELECT salutation, first_name, last_name FROM STUDENTDB.INSTRUCTOR; 
      
    TYPE inBlock_vry IS VARRAY (3) OF VARCHAR2(10);
    vry_obj inBlock_vry := inBlock_vry();
  
BEGIN 
  OPEN c_instructor; 
  vry_obj.EXTEND(3);
  LOOP 

   FETCH c_instructor into c_salutation, c_first_name, c_last_name; 
    EXIT WHEN c_instructor%notfound; 
    vry_obj := inBlock_vry(c_salutation, c_first_name, c_last_name);  
  
    FOR i IN 1..vry_obj.LIMIT
    LOOP
        DBMS_OUTPUT.PUT(vry_obj (i)|| ' ');
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(' ');
 END LOOP; 
 CLOSE c_instructor; 
END; 
/


--Answer Question 3
SET SERVEROUTPUT ON;
DECLARE 

   c_student_id CHAR(20); 
   c_first_name CHAR(20); 
   c_last_name CHAR(20); 
   c_grade CHAR(20); 
  
   
   CURSOR c_student is 
      SELECT CAST(s.student_id AS CHAR(20)) AS studentID, s.first_name, 
        s.last_name, CAST(TO_CHAR(AVG(g.numeric_grade),'999.99') AS CHAR(20)) AS grade
      FROM studentdb.student s LEFT OUTER JOIN studentdb.grade g
      ON s.student_id = g.student_id
      GROUP BY s.student_id, s.first_name, s.last_name; 
      
      TYPE t_assoc_array IS TABLE OF VARCHAR2(20) INDEX BY VARCHAR2(15); 
      v_instructor_array t_assoc_array;  
  
BEGIN 
   OPEN c_student; 
   
    DBMS_OUTPUT.PUT_LINE(rpad('Student id', 20)  || ' ' 
    || rpad('First name',20) || ' ' || rpad('Last_name', 20)
    || ' ' || rpad('Avarage grade',20)); 
   
   LOOP 
   FETCH c_student into c_student_id, c_first_name, c_last_name, c_grade; 
      EXIT WHEN c_student%notfound; 
      
    v_instructor_array('student_id') := c_student_id;   
    v_instructor_array('first_name') := c_first_name;   
    v_instructor_array('last_name') := c_last_name;
    v_instructor_array('grade') := c_grade;
      
      DBMS_OUTPUT.PUT_LINE(v_instructor_array('student_id')  || ' ' 
      || v_instructor_array('first_name') || ' ' || v_instructor_array('last_name')
      || ' ' || v_instructor_array('grade')); 
   END LOOP; 
   CLOSE c_student; 
END; 
/


--Answer Question 4 

SET SERVEROUTPUT ON;
DECLARE 

   c_student_id CHAR(20); 
   c_first_name CHAR(20); 
   c_last_name CHAR(20); 
   c_grade CHAR(20); 
  
   CURSOR c_student is 
      SELECT CAST(s.student_id AS CHAR(20)) AS studentID, s.first_name, 
        s.last_name, CAST(TO_CHAR(AVG(g.numeric_grade),'999.99') AS CHAR(20)) AS grade
      FROM studentdb.student s LEFT OUTER JOIN studentdb.grade g
      ON s.student_id = g.student_id
      GROUP BY s.student_id, s.first_name, s.last_name; 
      
      TYPE t_nested_table IS TABLE OF VARCHAR2(255); 
      v_instructor_list t_nested_table := t_nested_table(); 
      
      i INTEGER := 0;
      
BEGIN 
   OPEN c_student; 

   
    DBMS_OUTPUT.PUT_LINE(rpad('Student id', 20)  || ' ' 
    || rpad('First name',20) || ' ' || rpad('Last_name', 20)
    || ' ' || rpad('Avarage grade',20)); 
 
   LOOP 
   i := i+1;
   v_instructor_list.EXTEND;
   FETCH c_student into c_student_id, c_first_name, c_last_name, c_grade; 
      EXIT WHEN c_student%notfound; 
      
      v_instructor_list(i) := c_student_id || ' ' ||  c_first_name || ' ' || c_last_name || ' ' || c_grade;   
     
      DBMS_OUTPUT.PUT_LINE(v_instructor_list(i));
   END LOOP; 
   CLOSE c_student; 
END; 
/

--Answer Question 5

CREATE OR REPLACE TYPE section_details AS OBJECT 
(
 section_id int, 
 course_no int,
 section_no int,
 start_date_time date,
 locations varchar2(50),
 instructor_id number(3,0),
 capacity number(3,0),
 created_by varchar2(30),
 created_date date,
 modified_by varchar2(30),
 modified_date date,
 description varchar2(50)
); 
/ 

SET SERVEROUTPUT ON;

DECLARE 

  sectionID INTEGER :=100;
   CURSOR c_sction_course is 
      SELECT sc.*, c.description 
      FROM studentdb.section sc
      JOIN studentdb.course c
      ON sc.course_no=c.course_no
      WHERE sc.section_id=sectionID; 

  c_section_id studentdb.section.section_id%type; 
  c_course_no studentdb.section.course_no%type; 
  c_section_no studentdb.section.section_no%type; 
  c_start_date_time studentdb.section.start_date_time%type;
  c_locations studentdb.section.location%type; 
  c_instructor_id studentdb.section.instructor_id%type; 
  c_capacity studentdb.section.capacity%type; 
  c_created_by studentdb.section.created_by%type;
  c_created_date studentdb.section.created_date%type; 
  c_modified_by studentdb.section.modified_by%type; 
  c_modified_date studentdb.section.modified_date%type; 
  c_description studentdb.course.description%type;
  residence section_details; 
  
BEGIN 
   OPEN c_sction_course; 
   LOOP 
   FETCH c_sction_course into c_section_id, c_course_no, c_section_no, c_start_date_time, 
    c_locations, c_instructor_id, c_capacity, c_created_by, c_created_date, c_modified_by, 
    c_modified_date,c_description; 
      EXIT WHEN c_sction_course%notfound; 
       
    residence := section_details(c_section_id, c_course_no, c_section_no, c_start_date_time,
      c_locations, c_instructor_id, c_capacity, c_created_by, c_created_date, c_modified_by, 
      c_modified_date,c_description);  
    
     DBMS_OUTPUT.PUT_LINE(residence.section_id ||'   '|| residence.course_no
     ||'   '|| residence.section_no ||'   '|| residence.start_date_time ||'   '|| residence.locations
     ||'   '|| residence.instructor_id
     ||'   '|| residence.capacity ||'   '|| residence.created_by ||'   '|| residence.created_date
     ||'   '|| residence.modified_by ||'   '|| residence.modified_date ||'   '|| residence.description
     ); 
    END LOOP; 
    
    if (c_section_id is null ) then
    DBMS_OUTPUT.PUT_LINE( 'Section ID '|| sectionID ||': Not found!!' );
    end if; 
   CLOSE c_sction_course; 
END; 
/ 

SET SERVEROUTPUT ON;

DECLARE 

  sectionID INTEGER :=42;
   CURSOR c_sction_course is 
      SELECT sc.*, c.description 
      FROM studentdb.section sc
      JOIN studentdb.course c
      ON sc.course_no=c.course_no
      WHERE sc.section_id=sectionID; 

  c_section_id studentdb.section.section_id%type; 
  c_course_no studentdb.section.course_no%type; 
  c_section_no studentdb.section.section_no%type; 
  c_start_date_time studentdb.section.start_date_time%type;
  c_locations studentdb.section.location%type; 
  c_instructor_id studentdb.section.instructor_id%type; 
  c_capacity studentdb.section.capacity%type; 
  c_created_by studentdb.section.created_by%type;
  c_created_date studentdb.section.created_date%type; 
  c_modified_by studentdb.section.modified_by%type; 
  c_modified_date studentdb.section.modified_date%type; 
  c_description studentdb.course.description%type;
  residence address; 
  
BEGIN 
   OPEN c_sction_course; 
   LOOP 
   FETCH c_sction_course into c_section_id, c_course_no, c_section_no, c_start_date_time, 
    c_locations, c_instructor_id, c_capacity, c_created_by, c_created_date, c_modified_by, 
    c_modified_date,c_description; 
      EXIT WHEN c_sction_course%notfound; 
       
    residence := address(c_section_id, c_course_no, c_section_no, c_start_date_time,
      c_locations, c_instructor_id, c_capacity, c_created_by, c_created_date, c_modified_by, 
      c_modified_date,c_description);  
    
     DBMS_OUTPUT.PUT_LINE(residence.section_id ||'   '|| residence.course_no
     ||'   '|| residence.section_no ||'   '|| residence.start_date_time ||'   '|| residence.locations
     ||'   '|| residence.instructor_id
     ||'   '|| residence.capacity ||'   '|| residence.created_by ||'   '|| residence.created_date
     ||'   '|| residence.modified_by ||'   '|| residence.modified_date ||'   '|| residence.description
     ); 
    END LOOP; 
    
    if (c_section_id is null ) then
    DBMS_OUTPUT.PUT_LINE( 'Section ID '|| sectionID ||': Not found!!' );
    end if; 
   CLOSE c_sction_course; 
END; 
/ 


