/*  Bishwajit Barua
    Reg: 6397699
    CPA student 
    Assignment 2
    
    Database name: project
    */
        
/*Table:  project  */

clear screen;

/*Question 1 : Answer-  */

SET SERVEROUTPUT ON;
DECLARE
    v_question VARCHAR(50);
    v_one VARCHAR(50);
    v_full_string VARCHAR(50);
BEGIN
DBMS_OUTPUT.PUT_LINE('Answer of Question 1' );
DBMS_OUTPUT.PUT_LINE('========================' );
    --Set the variable
    v_question := 'Question';
    v_one := 'one';
    
    v_full_string := v_question || ' ' || v_one;
    
    DBMS_OUTPUT.PUT_LINE('Full string is : ' || v_full_string);
    DBMS_OUTPUT.PUT_LINE('Location of ne : ' || INSTR(v_full_string, 'ne'));
    
END;
/

/*Question 2 : Answer-  */
DECLARE 
    numberOfjob INTEGER;
    employeeName VARCHAR(30):='Allan';
    employee_status VARCHAR(50);
    v_counter INTEGER:=1;

    
    TYPE empployee_info
    IS RECORD (v_project VARCHAR(30),
        v_hourlyRate NUMBER(10,0),
        row_n INTEGER);
        
    employee empployee_info;
        
    
BEGIN
DBMS_OUTPUT.PUT_LINE('Answer of Question 2' );
DBMS_OUTPUT.PUT_LINE('========================' );
   
    SELECT COUNT(*) AS NumOfJob
    INTO numberOfjob
    FROM project p
    INNER JOIN project_employee pe
    ON p.project_num=pe.project_num
    INNER JOIN employee e
    ON pe.employee_id= e.employee_id
    WHERE  e.full_name=employeeName;
    

    IF numberOfjob > 0 THEN  
    DBMS_OUTPUT.PUT_LINE(employeeName || ' is assigned to ' || numberOfjob || ' project(s).');
    ELSE 
    DBMS_OUTPUT.PUT_LINE(employeeName || ' is not assigned to any projects.');
    END IF;

WHILE v_counter <= numberOfjob LOOP   

    SELECT * 
        INTO employee
    FROM
    (
        SELECT p.project_name AS "Project Name"
        , TO_CHAR(pe.hourly_rate, '9,999.99') AS "Employee Project Hourly Rate" 
        , Row_Number() OVER (Order by p.project_name) row_number
        FROM project p
        INNER JOIN project_employee pe
        ON p.project_num=pe.project_num
        INNER JOIN employee e
        ON pe.employee_id= e.employee_id
        WHERE  e.full_name=employeeName
    )
    WHERE row_number IN (v_counter);

    DBMS_OUTPUT.PUT_LINE('Project Name: ' || employee.v_project || '      Hourly rate : ' || TO_CHAR(employee.v_hourlyRate, '999,999.99'));
    
    v_counter := v_counter + 1; 

END LOOP;        
END;
/

/*Question 3 : Answer-  */
DECLARE  
    v_string VARCHAR(30):='questionthree';
    v_counter INTEGER;
BEGIN   
DBMS_OUTPUT.PUT_LINE('Answer of Question 3' );
DBMS_OUTPUT.PUT_LINE('========================' );

DBMS_OUTPUT.PUT_LINE('Using WHILE' );
v_counter := 1; 
WHILE v_counter <= LENGTH(v_string) LOOP   

 DBMS_OUTPUT.PUT_LINE(SUBSTR(v_string, v_counter, 1));

v_counter := v_counter + 1; 
END LOOP;
END; 
/

DECLARE  
    v_string VARCHAR(30):='questionthree';
    v_counter INTEGER;
BEGIN   
DBMS_OUTPUT.PUT_LINE('Using FOR' );
FOR v_counter2 IN 1..LENGTH(v_string) LOOP  
DBMS_OUTPUT.PUT_LINE(SUBSTR(v_string, v_counter2, 1));
END LOOP;
END; 
/

/*Question 4 : Answer-  */
DECLARE  
    number_of_employee INTEGER;
    project_number VARCHAR(10) :='004';
    e_project_too_many_emp EXCEPTION;
     
BEGIN   
DBMS_OUTPUT.PUT_LINE('Answer of Question 4' );
DBMS_OUTPUT.PUT_LINE('========================' );

    SELECT COUNT(*) AS NumOfJob
    INTO number_of_employee
    FROM project p
    INNER JOIN project_employee pe
    ON p.project_num=pe.project_num
    INNER JOIN employee e
    ON pe.employee_id= e.employee_id
    WHERE  p.project_num=project_number;
    
    
    IF number_of_employee > 4 THEN
        RAISE e_project_too_many_emp;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Total employee :' || number_of_employee);

EXCEPTION 
    WHEN e_project_too_many_emp THEN
        DBMS_OUTPUT.PUT_LINE('OVER STAFFED. Total employee are: ' || number_of_employee); 
END; 
/

/*Question 5 : Answer-  */
DECLARE
CURSOR employee_info IS  
    SELECT d.department_name AS "Dept. Name"
    , e.full_name AS "Employee Name"
    , p.project_name AS "Project Name"
    FROM project p
    INNER JOIN project_employee pe
    ON p.project_num=pe.project_num
    INNER JOIN employee e
    ON pe.employee_id= e.employee_id
    INNER JOIN department d
    ON e.depertment_id=d.depertment_id
    ORDER BY d.department_name, e.full_name;
    
CURSOR count_of_project IS
    SELECT d.department_name AS "Dept. Name"
    , e.full_name AS "Employee Name"
    , COUNT(*) AS "Number of project"
    FROM project p
    INNER JOIN project_employee pe
    ON p.project_num=pe.project_num
    INNER JOIN employee e
    ON pe.employee_id= e.employee_id
    INNER JOIN department d
    ON e.depertment_id=d.depertment_id
    GROUP BY d.department_name, e.full_name
    ORDER BY d.department_name, e.full_name;     

v_department VARCHAR(30);
v_full_name VARCHAR(30);
v_projectCount INTEGER;
v_project_name VARCHAR(30);


BEGIN
DBMS_OUTPUT.PUT_LINE('Answer of Question 5' );
DBMS_OUTPUT.PUT_LINE('========================' );

OPEN employee_info;
OPEN count_of_project;

DBMS_OUTPUT.PUT_LINE('Gathering all information' );
DBMS_OUTPUT.PUT_LINE('========================' );
LOOP 
    FETCH employee_info 
      INTO v_department,v_full_name, v_project_name ;
    EXIT WHEN employee_info%NOTFOUND;
    
    --Display
    DBMS_OUTPUT.PUT_LINE('Depertment : ' || v_department || ' -- Employee Name: ' || v_full_name || ' -- Project Name: ' ||v_project_name); 
END LOOP;
DBMS_OUTPUT.PUT_LINE('=======================================================================================' );

DBMS_OUTPUT.PUT_LINE('Count project by employee' );
DBMS_OUTPUT.PUT_LINE('========================' );
LOOP 
    FETCH count_of_project 
      INTO v_department,v_full_name, v_projectCount ;
    EXIT WHEN count_of_project%NOTFOUND;
    
    --Display
    DBMS_OUTPUT.PUT_LINE('Depertment : ' || v_department || ' -- Employee Name: ' || v_full_name || ' -- Number of project assign to: ' ||v_projectCount); 
END LOOP;
CLOSE employee_info;
CLOSE count_of_project;
END;
/
