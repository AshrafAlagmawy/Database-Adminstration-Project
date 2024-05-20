use company_database;

-- Query 1 
SELECT e.fname AS Employee_FirstName,
       e.lname AS Employee_LastName,
       d.dependent_name AS Dependent_Name,
       d.sex AS Dependent_Sex,
       d.bdate AS Dependent_Birthdate,
       d.relationship AS Relationship
FROM EMPLOYEE e
INNER JOIN DEPENDENT d ON e.ssn = d.essn

-----------------------------------------------------------------------------------------------

-- Query 2 
SELECT e.fname AS Employee_FirstName,
       e.lname AS Employee_LastName,
       p.pname AS Project_Name
FROM EMPLOYEE e
JOIN WORKS_ON w ON e.ssn = w.essn
JOIN PROJECT p ON w.pno = p.pnumber
ORDER BY Project_Name;

-----------------------------------------------------------------------------------------------

-- Query 3 
SELECT DISTINCT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM EMPLOYEE
) ranked_salaries
WHERE salary_rank <= 2;

-----------------------------------------------------------------------------------------------

-- Query 4 
SELECT fname AS Employee_FirstName, lname AS Employee_LastName, COALESCE(salary, 3000) AS Salary
FROM EMPLOYEE;

-- COALESCE function checks salary for each employee.
--		If salary is null, COALESCE returns 3000 (default value).
--		If salary has a value, COALESCE returns the actual salary.

-----------------------------------------------------------------------------------------------

-- Query 5
SELECT e.fname AS Employee_FirstName,
       s.fname AS Supervisor_FirstName,
       s.lname AS Supervisor_LastName
FROM EMPLOYEE e
LEFT JOIN EMPLOYEE s ON e.superssn = s.ssn;

-- ON = WHERE

-----------------------------------------------------------------------------------------------
-- Query 6
SELECT *
FROM (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_dense_rank
    FROM EMPLOYEE
) AS ranked_employees
WHERE salary_dense_rank = 2;

-----------------------------------------------------------------------------------------------

-- Query 7
SELECT pname AS Project_Name
FROM PROJECT
WHERE pname LIKE 'B%';

-----------------------------------------------------------------------------------------------

-- Query 8 
SELECT * FROM EMPLOYEE WHERE salary >= 6000;
UPDATE EMPLOYEE SET salary = 5999.99 WHERE salary >= 6000;
-- ALTER TABLE EMPLOYEE
-- DROP CONSTRAINT chk_salary_limit; 
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_salary_limit CHECK (salary < 6000);

--CREATE RULE salary_rule
--AS @salary < 6000;
--exec sp_bindrule 'salary_rule','EMPLOYEE.salary'

-----------------------------------------------------------------------------------------------

-- Query 9 
SELECT * FROM EMPLOYEE WHERE address NOT IN ('alex', 'mansoura', 'cairo');
UPDATE EMPLOYEE SET address = 'alex' WHERE address NOT IN ('alex', 'mansoura', 'cairo');
-- ALTER TABLE EMPLOYEE
-- DROP CONSTRAINT chk_address_values;
ALTER TABLE EMPLOYEE
ADD CONSTRAINT chk_address_values CHECK (address IN ('alex', 'mansoura', 'cairo'));

-----------------------------------------------------------------------------------------------

-- Query 10

 --DROP FUNCTION CheckEmployeeName;

CREATE FUNCTION CheckEmployeeName
(
    @ssn CHAR(9)
)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @message VARCHAR(100);

    DECLARE @firstName VARCHAR(15);
    DECLARE @lastName VARCHAR(15);

    -- Retrieve the first name and last name of the employee
    SELECT @firstName = fname, @lastName = lname
    FROM EMPLOYEE 
    WHERE ssn = @ssn;

    -- Check conditions and set message accordingly
    IF @firstName IS NULL AND @lastName IS NULL
        SET @message = 'First name & last name are null';
    ELSE IF @firstName IS NULL
        SET @message = 'First name is null';
    ELSE IF @lastName IS NULL
        SET @message = 'Last name is null';
    ELSE
        SET @message = 'First name & last name are not null';

    RETURN @message;
END;

DECLARE @employeeSSN CHAR(9) = '333333300'; 

SELECT dbo.CheckEmployeeName(@employeeSSN) AS NameStatus;

-----------------------------------------------------------------------------------------------

-- Query 11

 --DROP FUNCTION GetEmployeeData;

CREATE FUNCTION GetEmployeeData (@string NVARCHAR(50))
RETURNS @EmployeeData TABLE (
    Result NVARCHAR(50)
)
AS
BEGIN
    IF @string = 'first name'
        INSERT INTO @EmployeeData(Result)
        SELECT ISNULL(fname, '') FROM EMPLOYEE;
    ELSE IF @string = 'last name'
        INSERT INTO @EmployeeData(Result)
        SELECT ISNULL(lname, '') FROM EMPLOYEE;
    ELSE IF @string = 'full name'
        INSERT INTO @EmployeeData(Result)
        SELECT ISNULL(fname, '') + ' ' + ISNULL(lname, '') FROM EMPLOYEE;
    ELSE
        INSERT INTO @EmployeeData(Result)
        SELECT NULL; -- Return NULL for any other input

    RETURN;
END

SELECT * FROM dbo.GetEmployeeData('first name');
SELECT * FROM dbo.GetEmployeeData('last name');
SELECT * FROM dbo.GetEmployeeData('full name');
SELECT * FROM dbo.GetEmployeeData('invalid input');

-----------------------------------------------------------------------------------------------

-- Query 12

--DROP VIEW ProjectEmployeeCount;

CREATE VIEW ProjectEmployeeCount AS
SELECT p.pname AS project_name, COUNT(w.essn) AS employee_count
FROM PROJECT p
LEFT JOIN WORKS_ON w ON p.pnumber = w.pno
GROUP BY p.pname;

SELECT * FROM ProjectEmployeeCount;

-----------------------------------------------------------------------------------------------

-- Query 13

--DROP VIEW EmployeesInDeptD2;

--DROP VIEW EmployeesWithJInLastName;

CREATE VIEW EmployeesInDeptD2 AS
SELECT 
    E.ssn AS EmployeeSSN,
    E.lname AS EmployeeLastName
FROM 
    EMPLOYEE E
JOIN 
    WORKS_ON W ON E.ssn = W.essn
JOIN 
    DEPARTMENT D ON E.dno = D.dnumber
WHERE 
    D.dname = 'd2';



CREATE VIEW EmployeesWithJInLastName AS
SELECT 
    EmployeeLastName
FROM 
    EmployeesInDeptD2 
WHERE 
    EmployeeLastName LIKE '%J%';

SELECT * FROM EmployeesInDeptD2;
SELECT * FROM EmployeesWithJInLastName;

-----------------------------------------------------------------------------------------------

-- Query 14

--DROP PROCEDURE UpdateEmployeeOnProject;

CREATE PROCEDURE UpdateEmployeeOnProject
    @oldEmpNumber CHAR(9),
    @newEmpNumber CHAR(9),
    @projectNumber INT
AS
BEGIN
    -- Update the works on table
    UPDATE WORKS_ON
    SET essn = @newEmpNumber
    WHERE essn = @oldEmpNumber
    AND pno = @projectNumber;

    -- Check if any rows were affected by the update
    IF @@ROWCOUNT > 0
        PRINT 'Employee updated successfully';
    ELSE
        PRINT 'No matching records found for the provided old employee number and project number.';
END;

EXEC UpdateEmployeeOnProject '123456789', '987654321', 1;

-----------------------------------------------------------------------------------------------

-- Query 15
CREATE TABLE EmployeeAudit (
    name VARCHAR(100),
    date DATETIME,
    note VARCHAR(100)
);

CREATE TRIGGER EmployeeDeletionAudit
ON EMPLOYEE	
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @UserName VARCHAR(100);
    SET @UserName = SUSER_SNAME();

    INSERT INTO EmployeeAudit (name, date, note)
    SELECT lname, GETDATE(), 'try to delete Row with Key of row = ' + CAST(ssn AS VARCHAR(100))
    FROM DELETED;

    DELETE FROM EMPLOYEE
    WHERE ssn IN (SELECT ssn FROM DELETED);
END;

drop trigger EmployeeDeletionAudit
-----------------------------------------------------------------------------------------------

drop trigger deletionTrigger

CREATE TRIGGER deletionTrigger
ON EMPLOYEE
INSTEAD OF DELETE
AS
BEGIN
    -- Insert deleted rows into EmployeeAudit
    INSERT INTO EmployeeAudit (name, date, note)
    SELECT d.fname, GETDATE(), 'try to delete Row with Key of row = ' + CAST(ssn AS VARCHAR(100))
    FROM DELETED d;

    -- Delete related rows in WORKS_ON
    DELETE FROM WORKS_ON
    WHERE essn IN (SELECT ssn FROM DELETED);

    -- Perform the delete operation
    DELETE e
    FROM EMPLOYEE e
    INNER JOIN DELETED d ON e.ssn = d.ssn;
END;

