-- Create Database Called company_database
create database company_database;
-- Drop The Database 
drop database company_database;
-- Using Database Called company_database
use company_database 

-- Creation all the tables

-- DEPARTMENT Table
DROP TABLE IF EXISTS DEPARTMENT;
CREATE TABLE DEPARTMENT (
  dname        varchar(25) not null,
  dnumber      int not null,
  mgrssn      char(9) not null, 
  CONSTRAINT pk_Department primary key (dnumber),
  CONSTRAINT uk_dname UNIQUE (dname) 
);

-- EMPLOYEE Table
DROP TABLE IF EXISTS EMPLOYEE;
CREATE TABLE EMPLOYEE (
  fname    varchar(15) not null, 
  lname    varchar(15) not null,
  ssn     char(9), 
  bdate    date,
  address  varchar(50),
  salary   decimal(10,2),
  superssn char(9),
  dno      int,
  CONSTRAINT pk_employee primary key (ssn),
  CONSTRAINT fk_employee_department foreign key (dno) references DEPARTMENT(dnumber)
);

-- Adding foreign key superssn reference to ssn
ALTER TABLE EMPLOYEE
ADD CONSTRAINT fk_employee_superssn FOREIGN KEY (superssn) REFERENCES EMPLOYEE(ssn);

-- Adding foreign key mgrssn reference to ssn
ALTER TABLE DEPARTMENT
ADD CONSTRAINT fk_department_mgrssn FOREIGN KEY (mgrssn) REFERENCES EMPLOYEE(ssn);

-- DEPENDENT Table
DROP TABLE IF EXISTS DEPENDENT;
CREATE TABLE DEPENDENT (
  essn           char(9),
  dependent_name varchar(15),
  sex            char,
  bdate          date,
  relationship   varchar(8),
  CONSTRAINT pk_essn_dependent_name primary key (essn,dependent_name),
  CONSTRAINT fk_dependent_employee foreign key (essn) references EMPLOYEE(ssn)
);

-- DEPT_LOCATIONS Table
DROP TABLE IF EXISTS DEPT_LOCATIONS;
CREATE TABLE DEPT_LOCATIONS (
  dnumber   int,
  dlocation varchar(15), 
  CONSTRAINT pk_dept_locations primary key (dnumber,dlocation),
  CONSTRAINT fk_deptlocations_department foreign key (dnumber) references DEPARTMENT(dnumber)
);

-- PROJECT Table
DROP TABLE IF EXISTS PROJECT;
CREATE TABLE PROJECT (
  pname      varchar(25) not null,
  pnumber    int,
  plocation  varchar(15),
  dnum       int not null,
  CONSTRAINT ok_project primary key (pnumber),
  CONSTRAINT uc_pnumber unique (pname),
  CONSTRAINT fk_project_department foreign key (dnum) references DEPARTMENT(dnumber)
);

-- WORKS_ON Table
DROP TABLE IF EXISTS WORKS_ON;
CREATE TABLE WORKS_ON (
  essn   char(9),
  pno    int,
  hours  decimal(4,1),
  CONSTRAINT pk_worksOn primary key (essn,pno),
  CONSTRAINT fk_workson_employee foreign key (essn) references EMPLOYEE(ssn),
  CONSTRAINT fk_workson_project foreign key (pno) references PROJECT(pnumber)
);

-- Insertion all the data with dummy data

-- Insert Data Into DEPARTMENT Table
INSERT INTO DEPARTMENT VALUES ('Research','5','333445555');
INSERT INTO DEPARTMENT VALUES ('Administration','4','987654321');
INSERT INTO DEPARTMENT VALUES ('Headquarters','1','888665555');
INSERT INTO DEPARTMENT VALUES ('Software','6','111111100');
INSERT INTO DEPARTMENT VALUES ('Hardware','7','444444400');
INSERT INTO DEPARTMENT VALUES ('Sales','8','555555500');

-- Insert Data Into EMPLOYEE Table
INSERT INTO EMPLOYEE VALUES ('Bob','Bender','666666600','1968-04-17','8794 Garfield, Chicago, IL','96000.00',NULL,'8' );
INSERT INTO EMPLOYEE VALUES ('Bob','Bender','666866600','1968-04-17','8794 Garfield, Chicago, IL','96000.00',NULL,'8' );
INSERT INTO EMPLOYEE VALUES ('Kim','Grace','333333300','1970-10-23','6677 Mills Ave, Sacramento, CA','79000.00',NULL,'6'); 
INSERT INTO EMPLOYEE VALUES ('James','Borg','888665555','1927-11-10','450 Stone, Houston, TX','55000.00',NULL,'1'); 
INSERT INTO EMPLOYEE VALUES ('Alex','Freed','444444400','1950-10-09','4333 Pillsbury, Milwaukee, WI','89000.00',NULL,'7'); 
INSERT INTO EMPLOYEE VALUES ('Evan','Wallis','222222200','1958-01-16','134 Pelham, Milwaukee, WI','92000.00',NULL,'7'); 
INSERT INTO EMPLOYEE VALUES ('Evan','Wallis','2222200','1958-01-16','134 Pelham, Milwaukee, WI','92000.00',NULL,'7'); 
INSERT INTO EMPLOYEE VALUES ('Jared','James','111111100','1966-10-10','123 Peachtree, Atlanta, GA','85000.00',NULL,'6'); 
INSERT INTO EMPLOYEE VALUES ('John','James','555555500','1975-06-30','7676 Bloomington, Sacramento, CA','81000.00',NULL,'6'); 
INSERT INTO EMPLOYEE VALUES ('Andy','Vile','222222202','1944-06-21','1967 Jordan, Milwaukee, WI','53000.00','222222200','7'); 
INSERT INTO EMPLOYEE VALUES ('Brad','Knight','111111103','1968-02-13','176 Main St., Atlanta, GA','44000.00','111111100','6'); 
INSERT INTO EMPLOYEE VALUES ('Josh','Zell','222222201','1954-05-22','266 McGrady, Milwaukee, WI','56000.00','222222200','7'); 
INSERT INTO EMPLOYEE VALUES ('Justin','Mark','111111102','1966-01-12','2342 May, Atlanta, GA','40000.00','111111100','6'); 
INSERT INTO EMPLOYEE VALUES ('Jon','Jones','111111101','1967-11-14','111 Allgood, Atlanta, GA','45000.00','111111100','6'); 
INSERT INTO EMPLOYEE VALUES ('Ahmad','Jabbar','987987987','1959-03-29','980 Dallas, Houston, TX','25000.00','987654321','4'); 
INSERT INTO EMPLOYEE VALUES ('Joyce','English','453453453','1962-07-31','5631 Rice, Houston, TX','25000.00','333445555','5'); 
INSERT INTO EMPLOYEE VALUES ('Ramesh','Narayan','666884444','1952-09-15','971 Fire Oak, Humble, TX','38000.00','333445555','5'); 
INSERT INTO EMPLOYEE VALUES ('Alicia','Zelaya','999887777','1958-07-19','3321 Castle, Spring, TX','25000.00','987654321','4'); 
INSERT INTO EMPLOYEE VALUES ('John','Smith','123456789','1955-01-09','731 Fondren, Houston, TX','30000.00','333445555','5'); 
INSERT INTO EMPLOYEE VALUES ('Jennifer','Wallace','987654321','1931-06-20','291 Berry, Bellaire, TX','43000.00','888665555','4'); 
INSERT INTO EMPLOYEE VALUES ('Franklin','Wong','333445555','1945-12-08','638 Voss, Houston, TX','40000.00','888665555','5'); 
INSERT INTO EMPLOYEE VALUES ('Tom','Brand','222222203','1966-12-16','112 Third St, Milwaukee, WI','62500.00','222222200','7'); 
INSERT INTO EMPLOYEE VALUES ('Jenny','Vos','222222204','1967-11-11','263 Mayberry, Milwaukee, WI','61000.00','222222201','7'); 
INSERT INTO EMPLOYEE VALUES ('Chris','Carter','222222205','1960-03-21','565 Jordan, Milwaukee, WI','43000.00','222222201','7'); 
INSERT INTO EMPLOYEE VALUES ('Jeff','Chase','333333301','1970-01-07','145 Bradbury, Sacramento, CA','44000.00','333333300','6'); 
INSERT INTO EMPLOYEE VALUES ('Bonnie','Bays','444444401','1956-06-19','111 Hollow, Milwaukee, WI','70000.00','444444400','7'); 
INSERT INTO EMPLOYEE VALUES ('Alec','Best','444444402','1966-06-18','233 Solid, Milwaukee, WI','60000.00','444444400','7'); 
INSERT INTO EMPLOYEE VALUES ('Sam','Snedden','444444403','1977-07-31','987 Windy St, Milwaukee, WI','48000.00','444444400','7'); 
INSERT INTO EMPLOYEE VALUES ('Nandita','Ball','555555501','1969-04-16','222 Howard, Sacramento, CA','62000.00','555555500','6'); 
INSERT INTO EMPLOYEE VALUES ('Jill','Jarvis','666666601','1966-01-14','6234 Lincoln, Chicago, IL','36000.00','666666600','8'); 
INSERT INTO EMPLOYEE VALUES ('Kate','King','666666602','1966-04-16','1976 Boone Trace, Chicago, IL','44000.00','666666600','8'); 
INSERT INTO EMPLOYEE VALUES ('Lyle','Leslie','666666603','1963-06-09','417 Hancock Ave, Chicago, IL','41000.00','666666601','8'); 
INSERT INTO EMPLOYEE VALUES ('Billie','King','666666604','1960-01-01','556 Washington, Chicago, IL','38000.00','666666603','8'); 
INSERT INTO EMPLOYEE VALUES ('Jon','Kramer','666666605','1964-08-22','1988 Windy Creek, Seattle, WA','41500.00','666666603','8'); 
INSERT INTO EMPLOYEE VALUES ('Ray','King','666666606','1949-08-16','213 Delk Road, Seattle, WA','44500.00','666666604','8'); 
INSERT INTO EMPLOYEE VALUES ('Gerald','Small','666666607','1962-05-15','122 Ball Street, Dallas, TX','29000.00','666666602','8'); 
INSERT INTO EMPLOYEE VALUES ('Arnold','Head','666666608','1967-05-19','233 Spring St, Dallas, TX','33000.00','666666602','8'); 
INSERT INTO EMPLOYEE VALUES ('Helga','Pataki','666666609','1969-03-11','101 Holyoke St, Dallas, TX','32000.00','666666602','8'); 
INSERT INTO EMPLOYEE VALUES ('Naveen','Drew','666666610','1970-05-23','198 Elm St, Philadelphia, PA','34000.00','666666607','8'); 
INSERT INTO EMPLOYEE VALUES ('Carl','Reedy','666666611','1977-06-21','213 Ball St, Philadelphia, PA','32000.00','666666610','8'); 
INSERT INTO EMPLOYEE VALUES ('Sammy','Hall','666666612','1970-01-11','433 Main Street, Miami, FL','37000.00','666666611','8'); 
INSERT INTO EMPLOYEE VALUES ('Red','Bacher','666666613','1980-05-21','196 Elm Street, Miami, FL','33500.00','666666612','8'); 

-- Insert Data Into DEPENDENT Table
INSERT INTO DEPENDENT VALUES ('333445555','Alice','F','1976-04-05','Daughter'); 
INSERT INTO DEPENDENT VALUES ('333445555','Theodore','M','1973-10-25','Son'); 
INSERT INTO DEPENDENT VALUES ('333445555','Joy','F','1948-05-03','Spouse'); 
INSERT INTO DEPENDENT VALUES ('987654321','Abner','M','1932-02-29','Spouse'); 
INSERT INTO DEPENDENT VALUES ('123456789','Michael','M','1978-01-01','Son'); 
INSERT INTO DEPENDENT VALUES ('123456789','Alice','F','1978-12-31','Daughter'); 
INSERT INTO DEPENDENT VALUES ('123456789','Elizabeth','F',Null,'Spouse'); 
INSERT INTO DEPENDENT VALUES ('444444400','Johnny','M','1997-04-04','Son'); 
INSERT INTO DEPENDENT VALUES ('444444400','Tommy','M','1999-06-07','Son'); 
INSERT INTO DEPENDENT VALUES ('444444401','Chris','M','1969-04-19','Spouse'); 
INSERT INTO DEPENDENT VALUES ('444444402','Sam','M','1964-02-14','Spouse');

-- Insert Data Into DEPT_LOCATIONS Table
INSERT INTO DEPT_LOCATIONS VALUES ('1','Houston'); 
INSERT INTO DEPT_LOCATIONS VALUES ('4','Stafford'); 
INSERT INTO DEPT_LOCATIONS VALUES ('5','Bellaire'); 
INSERT INTO DEPT_LOCATIONS VALUES ('5','Houston'); 
INSERT INTO DEPT_LOCATIONS VALUES ('5','Sugarland'); 
INSERT INTO DEPT_LOCATIONS VALUES ('6','Atlanta'); 
INSERT INTO DEPT_LOCATIONS VALUES ('6','Sacramento'); 
INSERT INTO DEPT_LOCATIONS VALUES ('7','Milwaukee'); 
INSERT INTO DEPT_LOCATIONS VALUES ('8','Chicago'); 
INSERT INTO DEPT_LOCATIONS VALUES ('8','Dallas'); 
INSERT INTO DEPT_LOCATIONS VALUES ('8','Miami'); 
INSERT INTO DEPT_LOCATIONS VALUES ('8','Philadephia'); 
INSERT INTO DEPT_LOCATIONS VALUES ('8','Seattle');
INSERT INTO DEPT_LOCATIONS VALUES ('8','Testing');

-- Insert Data Into PROJECT Table
INSERT INTO PROJECT VALUES ('ProductX','1','Bellaire','5'); 
INSERT INTO PROJECT VALUES ('ProductY','2','Sugarland','5'); 
INSERT INTO PROJECT VALUES ('ProductZ','3','Houston','5'); 
INSERT INTO PROJECT VALUES ('Computerization','10','Stafford','4'); 
INSERT INTO PROJECT VALUES ('Reorganization','20','Houston','1'); 
INSERT INTO PROJECT VALUES ('Newbenefits','30','Stafford','4'); 
INSERT INTO PROJECT VALUES ('OperatingSystems','61','Jacksonville','6'); 
INSERT INTO PROJECT VALUES ('DatabaseSystems','62','Birmingham','6'); 
INSERT INTO PROJECT VALUES ('Middleware','63','Jackson','6'); 
INSERT INTO PROJECT VALUES ('InkjetPrinters','91','Phoenix','7'); 
INSERT INTO PROJECT VALUES ('LaserPrinters','92','LasVegas','7');

-- Insert Data Into WORKS_ON Table
INSERT INTO WORKS_ON VALUES ('123456789','1','32.5'); 
INSERT INTO WORKS_ON VALUES ('123456789','2','7.5'); 
INSERT INTO WORKS_ON VALUES ('666884444','3','40.0'); 
INSERT INTO WORKS_ON VALUES ('453453453','1','20.0'); 
INSERT INTO WORKS_ON VALUES ('453453453','2','20.0'); 
INSERT INTO WORKS_ON VALUES ('333445555','2','10.0'); 
INSERT INTO WORKS_ON VALUES ('333445555','3','10.0'); 
INSERT INTO WORKS_ON VALUES ('333445555','10','10.0'); 
INSERT INTO WORKS_ON VALUES ('333445555','20','10.0'); 
INSERT INTO WORKS_ON VALUES ('999887777','30','30.0'); 
INSERT INTO WORKS_ON VALUES ('999887777','10','10.0'); 
INSERT INTO WORKS_ON VALUES ('987987987','10','35.0'); 
INSERT INTO WORKS_ON VALUES ('987987987','30','5.0'); 
INSERT INTO WORKS_ON VALUES ('987654321','30','20.0'); 
INSERT INTO WORKS_ON VALUES ('987654321','20','15.0'); 
INSERT INTO WORKS_ON VALUES ('888665555','20','0.0'); 
INSERT INTO WORKS_ON VALUES ('111111100','61','40.0'); 
INSERT INTO WORKS_ON VALUES ('111111101','61','40.0'); 
INSERT INTO WORKS_ON VALUES ('111111102','61','40.0'); 
INSERT INTO WORKS_ON VALUES ('111111103','61','40.0'); 
INSERT INTO WORKS_ON VALUES ('222222200','62','40.0'); 
INSERT INTO WORKS_ON VALUES ('222222201','62','48.0'); 
INSERT INTO WORKS_ON VALUES ('222222202','62','40.0'); 
INSERT INTO WORKS_ON VALUES ('222222203','62','40.0'); 
INSERT INTO WORKS_ON VALUES ('222222204','62','40.0'); 
INSERT INTO WORKS_ON VALUES ('222222205','62','40.0'); 
INSERT INTO WORKS_ON VALUES ('333333300','63','40.0'); 
INSERT INTO WORKS_ON VALUES ('333333301','63','46.0'); 
INSERT INTO WORKS_ON VALUES ('444444400','91','40.0'); 
INSERT INTO WORKS_ON VALUES ('444444401','91','40.0'); 
INSERT INTO WORKS_ON VALUES ('444444402','91','40.0'); 
INSERT INTO WORKS_ON VALUES ('444444403','91','40.0'); 
INSERT INTO WORKS_ON VALUES ('555555500','92','40.0'); 
INSERT INTO WORKS_ON VALUES ('555555501','92','44.0'); 
INSERT INTO WORKS_ON VALUES ('666666601','91','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666603','91','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666604','91','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666605','92','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666606','91','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666607','61','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666608','62','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666609','63','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666610','61','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666611','61','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666612','61','40.0'); 
INSERT INTO WORKS_ON VALUES ('666666613','61','30.0'); 
INSERT INTO WORKS_ON VALUES ('666666613','62','10.0'); 
INSERT INTO WORKS_ON VALUES ('666666613','63','10.0');


-- Remove Records

DELETE FROM WORKS_ON; -- Remove All Columns In WORKS_ON Table
DELETE FROM DEPENDENT; -- Remove All Columns In DEPENDENT Table
DELETE FROM PROJECT; -- Remove All Columns In PROJECT Table
DELETE FROM DEPT_LOCATIONS; -- Remove All Columns In DEPT_LOCATIONS Table
DELETE FROM EMPLOYEE; -- Remove All Columns In EMPLOYEE Table
DELETE FROM DEPARTMENT; -- Remove All Columns In DEPARTMENT Table

select * from EMPLOYEE
delete from EMPLOYEE where ssn = 111111102

select * from EmployeeAudit
