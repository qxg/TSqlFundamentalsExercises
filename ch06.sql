-- Exercise 1

-- Exercise 2
SELECT *
FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10)) T(n)

-- Exercise 3
SELECT custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20160101' AND '20160131'
EXCEPT
SELECT custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20160201' AND '20160229';

-- Exercise 4
SELECT custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20160101' AND '20160131'
INTERSECT
SELECT custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20160201' AND '20160229';

-- Exercise 5
SELECT custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20160101' AND '20160131'
INTERSECT
SELECT custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20160201' AND '20160229'
EXCEPT
SELECT custid, empid
FROM Sales.Orders
WHERE orderdate BETWEEN '20150101' AND '20151231';

-- Exercise 6
SELECT country, region, city
FROM 
(
	SELECT country, region, city, 0 AS segment
	FROM HR.Employees
	UNION ALL
	SELECT country, region, city, 1 as segment
	FROM Production.Suppliers
) AS T
ORDER BY segment, country, region, city

-- Exercise 7
SELECT 
FROM 

-- Exercise 8
SELECT 
FROM 

-- Exercise 9
SELECT 
FROM 

-- Exercise 10
SELECT 
FROM 

-- Exercise 11
SELECT 
FROM 

-- Exercise 12
SELECT 
FROM 

-- Exercise 13
SELECT 
FROM 

-- Exercise 14
SELECT 
FROM 

-- Exercise 15
SELECT 
FROM 

-- Exercise 16
SELECT 
FROM 

-- Exercise 17
SELECT 
FROM 

-- Exercise 18
SELECT 
FROM 

-- Exercise 19
SELECT 
FROM 

-- Exercise 20
SELECT 
FROM 

-- Exercise 21
SELECT 
FROM 

-- Exercise 22
SELECT 
FROM 

-- Exercise 23
SELECT 
FROM 

-- Exercise 24
SELECT 
FROM 

-- Exercise 25
SELECT 
FROM 

-- Exercise 26
SELECT 
FROM 

-- Exercise 27
SELECT 
FROM 

-- Exercise 28
SELECT 
FROM 

-- Exercise 29
SELECT 
FROM 

-- Exercise 30
SELECT 
FROM 

