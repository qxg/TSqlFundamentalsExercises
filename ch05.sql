-- Exercise 1
SELECT orderid, orderdate, custid, empid,
  DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
FROM Sales.Orders
WHERE orderdate <> DATEFROMPARTS(YEAR(orderdate), 12, 31);

SELECT *
FROM
(
	SELECT orderid, orderdate, custid, empid,
	  DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
	FROM Sales.Orders
) AS T
WHERE orderdate <> endofyear;

WITH C AS
(
  SELECT *,
    DATEFROMPARTS(YEAR(orderdate), 12, 31) AS endofyear
  FROM Sales.Orders
)
SELECT orderid, orderdate, custid, empid, endofyear
FROM C
WHERE orderdate <> endofyear;

-- Exercise 2-1
SELECT empid, MAX(orderdate) AS maxorderdate
FROM Sales.Orders
GROUP BY empid;

-- Exercise 2-2
SELECT Sales.Orders.empid, orderdate, orderid, custid
FROM Sales.Orders
INNER JOIN
(
	SELECT empid, MAX(orderdate) AS maxorderdate
	FROM Sales.Orders
	GROUP BY empid
) AS T 
	ON Sales.Orders.empid = T.empid 
		AND Sales.Orders.orderdate = T.maxorderdate;

-- Exercise 3-1
SELECT orderid, orderdate, custid, empid,
	ROW_NUMBER() OVER (ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders;

-- Exercise 3-2
WITH order_rownum AS
(
	SELECT orderid, orderdate, custid, empid, ROW_NUMBER() OVER (ORDER BY orderdate, orderid) AS rownum
	FROM Sales.Orders
)
SELECT *
FROM order_rownum
WHERE rownum BETWEEN 11 AND 20;

SELECT orderid, orderdate, custid, empid, ROW_NUMBER() OVER (ORDER BY orderdate, orderid) AS rownum
FROM Sales.Orders
ORDER BY rownum
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

-- Exercise 4
WITH employee_manager AS
(
	SELECT empid, mgrid, firstname, lastname
	FROM HR.Employees
	WHERE empid = 9

	UNION ALL

	SELECT HR.Employees.empid, HR.Employees.mgrid, HR.Employees.firstname, HR.Employees.lastname
	FROM employee_manager
	INNER JOIN HR.Employees ON employee_manager.mgrid = HR.Employees.empid
)
SELECT *
FROM employee_manager

-- Exercise 5-1
DROP VIEW IF EXISTS Sales.VEmpOrders;
GO
CREATE VIEW Sales.VEmpOrders
AS
	SELECT empid, YEAR(orderdate) AS orderyear, SUM(qty) AS qty
	FROM Sales.Orders
		INNER JOIN Sales.OrderDetails
			ON Sales.Orders.orderid = Sales.OrderDetails.orderid
	GROUP BY empid, YEAR(orderdate);
GO
SELECT *
FROM Sales.VEmpOrders
ORDER BY empid, orderyear;

-- Exercise 5-2
SELECT *, SUM(qty) OVER (PARTITION BY empid ORDER BY orderyear) AS runqty
FROM Sales.VEmpOrders;

-- Exercise 6-1
DROP FUNCTION IF EXISTS Production.TopProducts; 
GO
CREATE FUNCTION Production.TopProducts
(
	@supid AS INT,
	@n AS INT
)
RETURNS TABLE
	RETURN 
		SELECT productid, productname, unitprice
		FROM Production.Products
		WHERE supplierid = @supid
		ORDER BY unitprice DESC
		OFFSET 0 ROW FETCH NEXT @n ROWS ONLY;
GO
SELECT * FROM Production.TopProducts(5, 2);

-- Exercise 6-2
SELECT S.supplierid, S.companyname, TP.*
FROM Production.Suppliers AS S
CROSS APPLY Production.TopProducts(S.supplierid, 2) AS TP