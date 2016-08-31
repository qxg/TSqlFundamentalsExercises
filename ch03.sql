-- Exercise 1
SELECT empid, firstname, lastname, n
FROM HR.Employees
CROSS JOIN dbo.Nums
WHERE dbo.Nums.n < 6
ORDER BY n, empid;

-- Exercise 1 - 2
SELECT empid, CAST(DATEADD(DAY, n, '20160611') AS DATE) AS dt
FROM HR.Employees
CROSS JOIN dbo.Nums
WHERE dbo.Nums.n < 6
ORDER BY empid, dt

-- Exercise 2
SELECT Customers.custid, Customers.companyname, Orders.orderid, Orders.orderdate
FROM Sales.Customers
  INNER JOIN Sales.Orders
    ON Customers.custid = Orders.custid;

-- Exercise 3
SELECT Sales.Customers.custid, COUNT(DISTINCT Sales.Orders.orderid) AS numorders, SUM(qty) AS totalqty
FROM Sales.Customers
INNER JOIN Sales.Orders ON Sales.Customers.custid = Sales.Orders.custid
INNER JOIN Sales.OrderDetails ON Sales.Orders.orderid = Sales.OrderDetails.orderid
WHERE Sales.Customers.country = 'USA'
GROUP BY Sales.Customers.custid;

-- Exercise 4
SELECT Sales.Customers.custid, companyname, orderid, orderdate
FROM Sales.Customers 
LEFT OUTER JOIN Sales.Orders ON Sales.Customers.custid = Sales.Orders.custid

-- Exercise 5
SELECT Sales.Customers.custid, companyname
FROM Sales.Customers 
LEFT OUTER JOIN Sales.Orders ON Sales.Customers.custid = Sales.Orders.custid
WHERE Sales.Orders.custid IS NULL;

-- Exercise 6
SELECT Sales.Customers.custid, companyname, orderid, orderdate
FROM Sales.Customers
  INNER JOIN Sales.Orders
    ON Customers.custid = Orders.custid
WHERE orderdate = '20160212';

-- Exercise 7
SELECT Sales.Customers.custid, companyname, orderid, orderdate
FROM Sales.Customers
  LEFT OUTER JOIN Sales.Orders
    ON Customers.custid = Orders.custid AND Orders.orderdate = '20160212';

-- Exercise 8

-- Exercise 9
SELECT Sales.Customers.custid, companyname, CASE WHEN orderdate IS NULL THEN 'No' ELSE 'Yes' END AS HasOrderOn20160212
FROM Sales.Customers
  LEFT OUTER JOIN Sales.Orders
    ON Customers.custid = Orders.custid AND Orders.orderdate = '20160212';

SELECT Sales.Customers.custid, companyname, COALESCE(YN.HasOrderOn20160212, 'No') HasOrderOn20160212
FROM Sales.Customers
  LEFT OUTER JOIN Sales.Orders
    ON Customers.custid = Orders.custid AND Orders.orderdate = '20160212'
  LEFT OUTER JOIN (VALUES ('Yes')) AS YN(HasOrderOn20160212)
	ON Orders.orderdate IS NOT NULL;