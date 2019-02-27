/*  Bishwajit Barua
    Reg: 6397699
    CPA student 
    
    Database name: project
    */

--Answer Question 1
    
DROP TABLE inventory CASCADE CONSTRAINTS;

CREATE TABLE inventory (
    inventory_id NUMBER CONSTRAINT inventory_id_pk PRIMARY KEY,
    item_name VARCHAR2(255),
    quantity NUMBER,
    price NUMBER,
    item_size VARCHAR(255),
    inventory_value NUMBER
);

DESCRIBE inventory;


CREATE OR REPLACE TRIGGER after_inventory_insert BEFORE INSERT 
ON inventory
FOR EACH ROW
BEGIN
    IF :new.item_size NOT IN ('S', 'M', 'L', 'XL', 'small', 'medium', 'large', 'extra-large') then
        RAISE_APPLICATION_ERROR(20000, 'Sorry, item sized not matched.');
    END IF;
END;
/

INSERT INTO inventory VALUES (1, 'Web Shooter', 2, 19.00, 's', 38.00);
INSERT INTO inventory VALUES (2, 'Fantasticar', 4, 3000.00, 'very big', 12000.00);
INSERT INTO inventory VALUES (3, 'Mjolnir', 1, 100.00, 'medium', 100.00);

SELECT *
FROM inventory;

--Answer Question 2

DELETE 
FROM inventory;

INSERT INTO inventory VALUES (42, 'LMD', 331, 199.99, 'M', null);


SELECT *
FROM inventory;

CREATE OR REPLACE TRIGGER before_inventory_update 
    BEFORE INSERT OR UPDATE ON inventory
    FOR EACH ROW
BEGIN
    :NEW.inventory_value := :NEW.price * :NEW.quantity;
END;
/

INSERT INTO inventory VALUES (43, 'Arc Reactor Cube', 5, 999.99, 'M', null);


SELECT *
FROM inventory;

UPDATE inventory
    SET price = 299.99
WHERE inventory_id=42;

SELECT *
FROM inventory;

--Answer Question 3

DROP TABLE inventory_audit CASCADE CONSTRAINTS;

CREATE TABLE inventory_audit (
    date_changed DATE,
    user_name VARCHAR2(30),
    inv_id NUMBER(6),
      CONSTRAINT fk_inv_id 
      FOREIGN KEY(inv_id) 
      REFERENCES inventory(inventory_id),
    old_quantity NUMBER,
    new_quantity NUMBER
);

DESCRIBE inventory_audit;

CREATE OR REPLACE TRIGGER audit_entry AFTER UPDATE 
OF quantity ON inventory
FOR EACH ROW
BEGIN
    INSERT INTO inventory_audit
        (date_changed, user_name, inv_id, old_quantity, new_quantity)
    VALUES
        (SYSDATE, USER, :OLD.inventory_id, :OLD.quantity, :NEW.quantity );
END;
/

SELECT *
FROM inventory;

UPDATE inventory
SET 
quantity = quantity-1;

SELECT *
FROM inventory_audit;


--Answer Question 4

DROP TABLE table_audit CASCADE CONSTRAINTS;

CREATE TABLE table_audit (
    date_changed DATE,
    user_name VARCHAR2(30),
    table_name VARCHAR2(30)
);

DESCRIBE table_audit;


CREATE OR REPLACE TRIGGER create_table
AFTER CREATE ON SCHEMA
BEGIN
    INSERT INTO table_audit VALUES (
    SYSDATE, USER, ORA_DICT_OBJ_NAME);
END;
/

DROP TABLE customer CASCADE CONSTRAINTS;

CREATE TABLE customer (
    customer_id  NUMBER(6) CONSTRAINT customer_id_pk PRIMARY KEY,
    first_name VARCHAR2(30),
    last_name VARCHAR2(30),
    phone_num NUMBER
);

SELECT *
FROM table_audit;

--Answer Question 5

INSERT INTO customer VALUES (1, 'Peter', 'Parker', 5554242);
INSERT INTO customer VALUES (2, 'Tony', 'Stark', 5550000);
INSERT INTO customer VALUES (3, 'Carol', 'Danvers', 5550504);

DROP TABLE reserve_item CASCADE CONSTRAINTS;

CREATE TABLE reserve_item (
reserve_id  NUMBER(6) CONSTRAINT reserve_id_pk PRIMARY KEY,
inv_id NUMBER(6),
  CONSTRAINT fk_inv_id 
  FOREIGN KEY(inv_id) 
  REFERENCES inventory(inventory_id),
CID NUMBER(6),
  CONSTRAINT fk_cid 
  FOREIGN KEY(CID) 
  REFERENCES customer(customer_id)
);
DESCRIBE reserve_item;

CREATE OR REPLACE TRIGGER reserve_item_insert 
BEFORE INSERT ON reserve_item
FOR EACH ROW
DECLARE
  l_exst0 number:=0;
  l_exst1 number:=0;
  l_exst2 number:=0;
  l_exst3 number:=0;
  item_name VARCHAR2(30);
BEGIN
      SELECT count(*) 
        INTO l_exst0
      FROM inventory
      WHERE inventory_id = :NEW.inv_id;
      
      
      SELECT count(*)
        INTO l_exst1
      FROM customer
      WHERE customer_id = :NEW.CID;
      
      SELECT count(*)
        INTO l_exst2
      FROM inventory  
      WHERE inventory_id = :NEW.inv_id AND quantity = 0;
      
      SELECT count(*)
        INTO l_exst3
      FROM inventory  
      WHERE inventory_id NOT IN(43) AND quantity > 0;
      
      -- Decision
        IF l_exst0 = 0 THEN
        RAISE_APPLICATION_ERROR(-20010,'Invalid INVENTORY ID' );
        END IF;
        IF l_exst1 = 0 THEN
        RAISE_APPLICATION_ERROR(-20011,'Invalid CUSTOMER ID' );
        END IF;
        
        IF l_exst2 > 0 THEN
        RAISE_APPLICATION_ERROR(-20011,'Item is currently out of stock' );
        END IF;
        
        IF l_exst3 > 0 THEN
          UPDATE inventory
          SET 
          quantity = quantity-1
          WHERE inventory_id = :NEW.inv_id;
        END IF;
END;
/
      
SELECT *
FROM inventory;

SELECT *
FROM customer;

INSERT INTO reserve_item (reserve_id,inv_id, CID ) VALUES(1, 101, 1);
INSERT INTO reserve_item (reserve_id,inv_id, CID ) VALUES(2, 42, 4);
INSERT INTO reserve_item (reserve_id,inv_id, CID ) VALUES(3, 42, 1);
INSERT INTO reserve_item (reserve_id,inv_id, CID ) VALUES(4, 42, 2);
INSERT INTO reserve_item (reserve_id,inv_id, CID ) VALUES(5, 42, 3);

SELECT *
FROM reserve_item;

SELECT *
FROM inventory;