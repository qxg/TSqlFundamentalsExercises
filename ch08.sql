USE TSQLV4;

DROP TABLE IF EXISTS dbo.Customers;

CREATE TABLE dbo.Customers
(
  custid      INT          NOT NULL PRIMARY KEY,
  companyname NVARCHAR(40) NOT NULL,
  country     NVARCHAR(15) NOT NULL,
  region      NVARCHAR(15) NULL,
  city        NVARCHAR(15) NOT NULL
);

-- Exercise 1-1
INSERT INTO dbo.Customers(custid, companyname, country, region, city)
VALUES(100, 'Coho Winery', 'USA', 'WA', 'Redmond')

-- Exercise 1-2
INSERT INTO dbo.Customers
SELECT custid, companyname, country, region, city
FROM Sales.Customers
WHERE custid IN (SELECT custid FROM Sales.Orders)

-- Exercise 1-3
DROP TABLE IF EXISTS dbo.Orders;

SELECT *
INTO dbo.Orders
FROM Sales.Orders
WHERE orderdate BETWEEN '20140101' AND '20161231';

-- Exercise 2
DELETE dbo.Orders
OUTPUT DELETED.orderid, DELETED.orderdate
WHERE orderdate < '20140801';

-- Exercise 3
DELETE O
FROM dbo.Orders AS O
INNER JOIN Sales.Customers AS C ON o.custid = C.custid
WHERE C.country = 'Brazil';

-- Exercise 4
SELECT * FROM dbo.Customers;

UPDATE dbo.Customers
SET region = '<None>'
OUTPUT INSERTED.custid, DELETED.region, INSERTED.region
WHERE region IS NULL;

-- Exercise 5
UPDATE O
SET O.shipcountry = C.country,
	O.shipregion = C.region,
	O.shipcity = C.city
FROM dbo.Orders AS O
INNER JOIN Sales.Customers AS C
	ON O.custid = C.custid
WHERE C.country = 'UK'

-- Exercise 6
USE TSQLV4;

DROP TABLE IF EXISTS dbo.OrderDetails, dbo.Orders;

CREATE TABLE dbo.Orders
(
  orderid        INT          NOT NULL,
  custid         INT          NULL,
  empid          INT          NOT NULL,
  orderdate      DATE         NOT NULL,
  requireddate   DATE         NOT NULL,
  shippeddate    DATE         NULL,
  shipperid      INT          NOT NULL,
  freight        MONEY        NOT NULL
    CONSTRAINT DFT_Orders_freight DEFAULT(0),
  shipname       NVARCHAR(40) NOT NULL,
  shipaddress    NVARCHAR(60) NOT NULL,
  shipcity       NVARCHAR(15) NOT NULL,
  shipregion     NVARCHAR(15) NULL,
  shippostalcode NVARCHAR(10) NULL,
  shipcountry    NVARCHAR(15) NOT NULL,
  CONSTRAINT PK_Orders PRIMARY KEY(orderid)
);

CREATE TABLE dbo.OrderDetails
(
  orderid   INT           NOT NULL,
  productid INT           NOT NULL,
  unitprice MONEY         NOT NULL
    CONSTRAINT DFT_OrderDetails_unitprice DEFAULT(0),
  qty       SMALLINT      NOT NULL
    CONSTRAINT DFT_OrderDetails_qty DEFAULT(1),
  discount  NUMERIC(4, 3) NOT NULL
    CONSTRAINT DFT_OrderDetails_discount DEFAULT(0),
  CONSTRAINT PK_OrderDetails PRIMARY KEY(orderid, productid),
  CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY(orderid)
    REFERENCES dbo.Orders(orderid),
  CONSTRAINT CHK_discount  CHECK (discount BETWEEN 0 AND 1),
  CONSTRAINT CHK_qty  CHECK (qty > 0),
  CONSTRAINT CHK_unitprice CHECK (unitprice >= 0)
);
GO

INSERT INTO dbo.Orders SELECT * FROM Sales.Orders;
INSERT INTO dbo.OrderDetails SELECT * FROM Sales.OrderDetails;

TRUNCATE TABLE dbo.OrderDetails;
DELETE dbo.Orders;

SELECT * FROM dbo.Orders;
SELECT * FROM dbo.OrderDetails;

DROP TABLE IF EXISTS dbo.OrderDetails, dbo.Orders, dbo.Customers;