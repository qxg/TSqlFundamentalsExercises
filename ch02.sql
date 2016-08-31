-- Exercies 1
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20150101' AND '20150131'

-- Exercise 2
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE DAY(DATEADD(DAY, 1, orderdate)) = 1

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate = EOMONTH(orderdate)

-- Exercise 3
SELECT empid, firstname, lastname
FROM HR.Employees
CROSS APPLY string_split(lastname, 'e')
GROUP BY empid, firstname, lastname
HAVING COUNT(*) > 2

SELECT empid, firstname, lastname
FROM HR.Employees
WHERE lastname LIKE '%e%e%';

-- Exercise 4
SELECT orderid, SUM(qty * unitprice) AS totalvalue
FROM Sales.OrderDetails
GROUP BY orderid
HAVING SUM(qty * unitprice) > 10000
ORDER BY totalvalue DESC

-- Exercise 5
SELECT empid, lastname
FROM HR.Employees 
WHERE lastname COLLATE Latin1_General_CS_AS LIKE N'[a-z]%'

SELECT empid, lastname
FROM HR.Employees
WHERE lastname COLLATE Latin1_General_CS_AS LIKE N'[abcdefghijklmnopqrstuvwxyz]%';

-- Exercise 6

-- Exercise 7
SELECT shipcountry, AVG(freight) AS avgfreight
FROM Sales.Orders
GROUP BY shipcountry
ORDER BY avgfreight DESC
OFFSET 0 ROW FETCH NEXT 3 ROWS ONLY;

SELECT shipcountry, AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE orderdate >= '20150101' AND orderdate < '20160101'
GROUP BY shipcountry
ORDER BY avgfreight DESC
OFFSET 0 ROWS FETCH NEXT 3 ROWS ONLY;

-- Exercise 8
SELECT custid, orderdate, orderid, 
	ROW_NUMBER() OVER(PARTITION BY custid ORDER BY orderdate, orderid) AS rwonum
FROM Sales.Orders
ORDER BY custid, orderdate, orderid

-- Exercise 9
SELECT empid, firstname, lastname, titleofcourtesy,
	CASE titleofcourtesy 
		WHEN 'Ms.' THEN 'Female' 
		WHEN 'Mrs.' THEN 'Female'
		WHEN 'Mr.' THEN 'Male'
		ELSE 'Unknown'
	END AS gender
FROM HR.Employees

-- Exercise 10
SELECT custid, region
FROM Sales.Customers
ORDER BY coalesce( region, 'ZZZZZ')

SELECT custid, region
FROM Sales.Customers
ORDER BY
  CASE WHEN region IS NULL THEN 1 ELSE 0 END, region;