-- Exercise 1
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = (SELECT MAX(orderdate) FROM Sales.Orders)

-- Exercise 2
SELECT custid, orderid, orderdate, empid
FROM Sales.Orders
WHERE custid = (SELECT custid
				FROM Sales.Orders
				GROUP BY custid
				ORDER BY COUNT(orderid) DESC
				OFFSET 0 ROW FETCH NEXT 1 ROW ONLY);

SELECT custid, orderid, orderdate, empid
FROM 
(
	SELECT custid, orderid, orderdate, empid, RANK() OVER(ORDER BY numorders DESC) AS numorderrank
	FROM 
	(
		SELECT custid, orderid, orderdate, empid, COUNT(*) OVER(PARTITION BY custid) AS numorders
		FROM Sales.Orders
	) AS T1
) AS T2
WHERE T2.numorderrank = 1;

-- Exercise 3
SELECT empid, firstname, lastname
FROM HR.Employees
WHERE empid NOT IN
(
	SELECT empid
	FROM Sales.Orders
	WHERE orderdate >= '20160501'
);

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE EXISTS
(
	SELECT empid
	FROM Sales.Orders
	WHERE HR.Employees.empid = Sales.Orders.empid AND orderdate >= '20160501'
);

SELECT HR.Employees.empid, firstname, lastname
FROM HR.Employees
LEFT OUTER JOIN
(
	SELECT empid
	FROM Sales.Orders
	WHERE orderdate >= '20160501'
) AS employeeplacedorderafter20160501 ON HR.Employees.empid = employeeplacedorderafter20160501.empid
WHERE employeeplacedorderafter20160501.empid IS NULL;

-- Exercise 4
SELECT DISTINCT country
FROM Sales.Customers
WHERE country NOT IN (SELECT country FROM HR.Employees);

SELECT DISTINCT Sales.Customers.country
FROM Sales.Customers
LEFT OUTER JOIN HR.Employees
ON Sales.Customers.country = HR.Employees.country
WHERE HR.Employees.country IS NULL;

-- Exercise 5
SELECT Sales.Orders.custid, orderid, orderdate, empid
FROM Sales.Orders
INNER JOIN
(
	SELECT custid, MAX(orderdate) AS lastorderdate
	FROM Sales.Orders
	GROUP BY custid
) AS customerlastorder 
	ON Sales.Orders.custid = customerlastorder.custid
		AND Sales.Orders.orderdate = customerlastorder.lastorderdate
ORDER BY custid;

SELECT custid, orderid, orderdate, empid
FROM 
(
	SELECT custid, orderid, orderdate, empid, MAX(orderdate) OVER (PARTITION BY custid) AS lastorderdate
	FROM Sales.Orders
) AS T
WHERE orderdate = lastorderdate
ORDER BY custid;

-- Exercise 6
SELECT custid, companyname
FROM Sales.Customers
WHERE custid IN (SELECT custid FROM Sales.Orders WHERE orderdate BETWEEN '20150101' AND '20151231')
	AND custid NOT IN (SELECT custid FROM Sales.Orders WHERE orderdate BETWEEN '20160101' AND '20161231');

SELECT DISTINCT Sales.Customers.custid, Sales.Customers.companyname
FROM Sales.Customers
INNER JOIN Sales.Orders AS O15
	ON Sales.Customers.custid = O15.custid 
		AND O15.orderdate BETWEEN '20150101' AND '20151231'
LEFT OUTER JOIN Sales.Orders AS O16
	ON Sales.Customers.custid = O16.custid 
		AND O16.orderdate BETWEEN '20160101' AND '20161231'
WHERE O16.custid IS NULL;

-- Exercise 7
SELECT DISTINCT Sales.Customers.custid, Sales.Customers.companyname
FROM Sales.Customers
INNER JOIN Sales.Orders ON Sales.Customers.custid = Sales.Orders.custid
INNER JOIN Sales.OrderDetails ON Sales.Orders.orderid = Sales.OrderDetails.orderid
WHERE Sales.OrderDetails.productid = 12;

SELECT custid, companyname
FROM Sales.Customers
WHERE custid IN 
(
	SELECT custid
	FROM Sales.Orders
	WHERE orderid IN (SELECT orderid FROM Sales.OrderDetails WHERE productid = 12	)
);
-- Exercise 8
SELECT custid, ordermonth, qty, 
	(
		SELECT SUM(qty) 
		FROM Sales.CustOrders AS T 
		WHERE T.custid = Sales.CustOrders.custid
			AND T.ordermonth <= Sales.CustOrders.ordermonth
	) AS runqty
FROM Sales.CustOrders
ORDER BY custid, ordermonth;

SELECT custid, ordermonth, qty, SUM(qty) OVER (PARTITION BY custid ORDER BY ordermonth) AS runqty
FROM Sales.CustOrders
ORDER BY custid, ordermonth;

-- Exercise 9
SELECT custid, orderdate, orderid, DATEDIFF(DAY, 
	(
		SELECT orderdate
		FROM Sales.Orders AS TIN
		WHERE TIN.custid = TOUT.custid
			AND TIN.orderdate < TOUT.orderdate
		ORDER BY TIN.orderdate DESC, orderid
		OFFSET 0 ROW FETCH NEXT 1 ROW ONLY
	), TOUT.orderdate) AS DIFF
FROM Sales.Orders AS TOUT
ORDER BY custid, orderdate;

SELECT custid, orderdate, orderid, DATEDIFF(DAY, LAG(orderdate) OVER (PARTITION BY custid ORDER BY orderdate), orderdate) AS diff
FROM Sales.Orders;