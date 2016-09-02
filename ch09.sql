CREATE TABLE dbo.Employees
(
	empid INT NOT NULL
		CONSTRAINT PK_Employees PRIMARY KEY NONCLUSTERED,
	empname VARCHAR(25) NOT NULL,
	department VARCHAR(50) NOT NULL,
	salary NUMERIC(10, 2) NOT NULL,
	sysstart DATETIME2(0)
		GENERATED ALWAYS AS ROW START HIDDEN NOT NULL,
	sysend DATETIME2(0)
		GENERATED ALWAYS AS ROW END HIDDEN NOT NULL,
	PERIOD FOR SYSTEM_TIME (sysstart, sysend),
	INDEX ix_Employees CLUSTERED (empid, sysstart, sysend)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeesHistory));

PRINT SYSUTCDATETIME();
INSERT INTO dbo.Employees(empid, empname, department, salary)
  VALUES(1, 'Sara', 'IT'       , 50000.00),
        (2, 'Don' , 'HR'       , 45000.00),
        (3, 'Judy', 'Sales'    , 55000.00),
        (4, 'Yael', 'Marketing', 55000.00),
        (5, 'Sven', 'IT'       , 45000.00),
        (6, 'Paul', 'Sales'    , 40000.00);

SELECT empid, empname, department, salary, sysstart, sysend
FROM dbo.Employees;

SELECT empid, empname, department, salary, sysstart, sysend
FROM dbo.EmployeesHistory;

DELETE FROM dbo.Employees
WHERE empid = 6;

	UPDATE dbo.Employees
	  SET salary *= 1.05
	WHERE department = 'IT';

BEGIN TRAN;
PRINT SYSUTCDATETIME();

UPDATE dbo.Employees
  SET department = 'Sales'
WHERE empid = 5;

UPDATE dbo.Employees
  SET department = 'IT'
WHERE empid = 3;
PRINT SYSUTCDATETIME();
COMMIT TRAN;

-- Re-create table
USE TSQLV4;

-- Drop tables if exist
IF OBJECT_ID(N'dbo.Employees', N'U') IS NOT NULL
BEGIN
  IF OBJECTPROPERTY(OBJECT_ID(N'dbo.Employees', N'U'), N'TableTemporalType') = 2
    ALTER TABLE dbo.Employees SET ( SYSTEM_VERSIONING = OFF );
  DROP TABLE IF EXISTS dbo.EmployeesHistory, dbo.Employees;
END;
GO

-- Create and populate Employees table
CREATE TABLE dbo.Employees
(
  empid      INT            NOT NULL
    CONSTRAINT PK_Employees PRIMARY KEY NONCLUSTERED,
  empname    VARCHAR(25)    NOT NULL,
  department VARCHAR(50)    NOT NULL,
  salary     NUMERIC(10, 2) NOT NULL,
  sysstart   DATETIME2(0)   NOT NULL,
  sysend     DATETIME2(0)   NOT NULL,
  INDEX ix_Employees CLUSTERED(empid, sysstart, sysend)
);

INSERT INTO dbo.Employees(empid, empname, department, salary, sysstart, sysend) VALUES
  (1 , 'Sara', 'IT'       , 52500.00, '2016-02-16 17:20:02', '9999-12-31 23:59:59'),
  (2 , 'Don' , 'HR'       , 45000.00, '2016-02-16 17:08:41', '9999-12-31 23:59:59'),
  (3 , 'Judy', 'IT'       , 55000.00, '2016-02-16 17:28:10', '9999-12-31 23:59:59'),
  (4 , 'Yael', 'Marketing', 55000.00, '2016-02-16 17:08:41', '9999-12-31 23:59:59'),
  (5 , 'Sven', 'Sales'    , 47250.00, '2016-02-16 17:28:10', '9999-12-31 23:59:59');

-- Create and populate EmployeesHistory table
CREATE TABLE dbo.EmployeesHistory
(
  empid      INT            NOT NULL,
  empname    VARCHAR(25)    NOT NULL,
  department VARCHAR(50)    NOT NULL,
  salary     NUMERIC(10, 2) NOT NULL,
  sysstart   DATETIME2(0)   NOT NULL,
  sysend     DATETIME2(0)   NOT NULL,
  INDEX ix_EmployeesHistory CLUSTERED(sysend, sysstart)
    WITH (DATA_COMPRESSION = PAGE)
);

INSERT INTO dbo.EmployeesHistory(empid, empname, department, salary, sysstart, sysend) VALUES
  (6 , 'Paul', 'Sales' , 40000.00, '2016-02-16 17:08:41', '2016-02-16 17:15:26'),
  (1 , 'Sara', 'IT'    , 50000.00, '2016-02-16 17:08:41', '2016-02-16 17:20:02'),
  (5 , 'Sven', 'IT'    , 45000.00, '2016-02-16 17:08:41', '2016-02-16 17:20:02'),
  (3 , 'Judy', 'Sales' , 55000.00, '2016-02-16 17:08:41', '2016-02-16 17:28:10'),
  (5 , 'Sven', 'IT'    , 47250.00, '2016-02-16 17:20:02', '2016-02-16 17:28:10');

-- Enable system versioning
ALTER TABLE dbo.Employees ADD PERIOD FOR SYSTEM_TIME (sysstart, sysend);

ALTER TABLE dbo.Employees ALTER COLUMN sysstart ADD HIDDEN;
ALTER TABLE dbo.Employees ALTER COLUMN sysend ADD HIDDEN;

ALTER TABLE dbo.Employees
  SET ( SYSTEM_VERSIONING = ON ( HISTORY_TABLE = dbo.EmployeesHistory ) );

SELECT empid, empname, department, salary, sysstart, sysend
FROM dbo.Employees;

SELECT empid, empname, department, salary, sysstart, sysend
FROM dbo.EmployeesHistory;

-- For SYSTEM_TIME AS OF clause
DECLARE @datetime DATETIME2 = '2016-02-16 17:15:00';
SELECT empid, empname, department, salary, sysstart, sysend
FROM dbo.Employees
FOR SYSTEM_TIME AS OF @datetime;

SELECT empid, empname, department, salary, sysstart, sysend
FROM
(
	SELECT empid, empname, department, salary, sysstart, sysend
	FROM dbo.Employees
	UNION ALL
	SELECT empid, empname, department, salary, sysstart, sysend
	FROM dbo.EmployeesHistory
) AS T
WHERE sysstart <= @datetime AND sysend > @datetime;

SELECT T2.empid, T2.empname,
  CAST( (T2.salary / T1.salary - 1.0) * 100.0 AS NUMERIC(10, 2) ) AS pct
FROM dbo.Employees FOR SYSTEM_TIME AS OF '2016-02-16 17:10:00' AS T1
  INNER JOIN dbo.Employees FOR SYSTEM_TIME AS OF '2016-02-16 17:25:00' AS T2
    ON T1.empid = T2.empid
   AND T2.salary > T1.salary;

-- FOR SYSTEM_TIME FROM TO clause
DECLARE @start DATETIME2 = '2016-02-16 17:19:00', @end DATETIME2 = '2016-02-16 17:21:02';
SELECT empid, empname, department, salary, sysstart, sysend
FROM dbo.Employees
FOR SYSTEM_TIME FROM @start TO @end;

SELECT empid, empname, department, salary, sysstart, sysend
FROM
(
	SELECT empid, empname, department, salary, sysstart, sysend
	FROM dbo.Employees
	UNION ALL
	SELECT empid, empname, department, salary, sysstart, sysend
	FROM dbo.EmployeesHistory
) AS T
WHERE sysend >= @start AND sysstart < @end;

-- FOR SYSTEM_TIME CONTAINED IN
SELECT empid, empname, department, salary, sysstart, sysend
FROM dbo.Employees
  FOR SYSTEM_TIME CONTAINED IN('2016-02-16 17:08:00', '2016-02-16 17:22:00');