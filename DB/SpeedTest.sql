-- Speed test integrating the AdventureWorks and Northwind databases as PartialNorthwind.
DECLARE @QueryStartAt DATETIME = GETDATE();

SELECT N_O.Orderid                         AS Origino_Id
     , YEAR(N_O.Orderdate)                 AS Year
     , MONTH(N_O.Orderdate)                AS Month
     , DAY(N_O.Orderdate)                  AS Day
     , N_O.Shippeddate                     AS Shipdate
     , N_O.Freight
     , N_O.Shipcity                        AS City
     , N_O.Shipcountry                     AS Countryregion
     , N_O.Shippostalcode                  AS Postalcode
     , N_O.Shipaddress                     AS Addressline
     , N_Od.Productid                      AS Product_Id
     , N_Od.Unitprice
     , N_Od.Discount
     , N_Od.Orderid                        AS Originod_Id
     , N_Od.Quantity
     , N_C.Companyname
     , N_C.Contactname
     , N_C.Phone
     , CAST(N_O.Customerid AS VARCHAR(10)) AS Originclient_Id
     , N_P.Productname
     , N_P.Unitprice                       AS Price
     , N_P.Productid                       AS Originp_Id
     , N_Pc.Categoryid                     AS Originc_Id
     , N_Pc.Categoryname
     , 'N'                                 AS Origin
FROM Parcialnorthwind.Dbo.Orders N_O
       INNER JOIN Parcialnorthwind.Dbo.[ORDER DETAILS] N_Od
                  ON N_Od.Orderid = N_O.Orderid
       INNER JOIN Parcialnorthwind.Dbo.Products N_P
                  ON N_P.Productid = N_Od.Productid
       INNER JOIN Parcialnorthwind.Dbo.Categories N_Pc
                  ON N_Pc.Categoryid = N_P.Categoryid
       INNER JOIN Parcialnorthwind.Dbo.Customers N_C
                  ON N_C.Customerid = N_O.Customerid
UNION
SELECT Aw_O.Salesorderid                                                                     AS Id_Order
     , YEAR(Aw_O.Orderdate)                                                                  AS Year
     , MONTH(Aw_O.Orderdate)                                                                 AS Month
     , DAY(Aw_O.Orderdate)                                                                   AS Day
     , Aw_O.Shipdate
     , Aw_O.Freight
     , Aw_A.City COLLATE Database_Default
     , Aw_A.Countryregion COLLATE Database_Default
     , Aw_A.Postalcode COLLATE Database_Default
     , Aw_A.Addressline1 COLLATE Database_Default
     , Aw_Od.Productid
     , Aw_Od.Unitprice
     , Aw_Od.Unitpricediscount
     , Aw_Od.Salesorderid                                                                    AS Originod_Id
     , Aw_Od.Orderqty
     , Aw_C.Companyname COLLATE Database_Default
     , CONCAT(
    Firstname,
    CASE
      WHEN Aw_C.Middlename COLLATE Database_Default IS NULL
        THEN ''
        ELSE CONCAT(' ', Aw_C.Middlename COLLATE Database_Default) END,
    ' ', Lastname COLLATE Database_Default,
    CASE
      WHEN Aw_C.Suffix COLLATE Database_Default IS NULL
        THEN ''
        ELSE CONCAT(' ', Aw_C.Suffix COLLATE Database_Default) END) COLLATE Database_Default AS Contactname
     , Aw_C.Phone COLLATE Database_Default
     , CAST(Aw_C.Customerid AS VARCHAR(10))                                                  AS Originclient_Id
     , Aw_P.Name COLLATE Database_Default
     , Aw_P.Listprice
     , Aw_P.Productid                                                                        AS Originp_Id
     , Aw_Ct.Childproductcategoryid                                                          AS Originc_Id
     , Aw_Ct.Name COLLATE Database_Default
     , 'A'                                                                                   AS Origin
FROM Adventureworkslt2014.Saleslt.Salesorderheader Aw_O
       INNER JOIN Adventureworkslt2014.Saleslt.Address Aw_A
                  ON Aw_A.Addressid = Aw_O.Billtoaddressid
       INNER JOIN Adventureworkslt2014.Saleslt.Salesorderdetail Aw_Od
                  ON Aw_Od.Salesorderid = Aw_O.Salesorderid
       INNER JOIN Adventureworkslt2014.Saleslt.Product Aw_P
                  ON Aw_P.Productid = Aw_Od.Productid
       INNER JOIN Adventureworkslt2014.Saleslt.Productcategory Aw_Pc
                  ON Aw_Pc.Productcategoryid = Aw_P.Productcategoryid
       INNER JOIN Adventureworkslt2014.Saleslt.Customer Aw_C
                  ON Aw_C.Customerid = Aw_O.Customerid
       INNER JOIN (SELECT Productcategoryid AS Childproductcategoryid,
                          Name
                   FROM Adventureworkslt2014.Saleslt.Productcategory
                   WHERE Parentproductcategoryid IS NULL
                   UNION
                   SELECT Child.Productcategoryid,
                          CONCAT(Parent.Name, ' - ', Child.Name) AS Child
                   FROM Adventureworkslt2014.Saleslt.Productcategory Parent
                          INNER JOIN Adventureworkslt2014.Saleslt.Productcategory Child
                                     ON Child.Parentproductcategoryid = Parent.Productcategoryid
                   WHERE Child.Parentproductcategoryid IS NOT NULL) AS Aw_Ct
                  ON Aw_Ct.Childproductcategoryid = Aw_Pc.Parentproductcategoryid
ORDER BY Origino_Id;

DECLARE @QueryEndedAt DATETIME = GETDATE();
SELECT DATEDIFF(MCS, @QueryStartAt, @QueryEndedAt) AS DurationInMicroSeconds;
GO

-- Speed test with the final (denormalised) database.
DECLARE @FinalQueryStartAt DATETIME = GETDATE();

SELECT
     Origino_Id
     , Year
     , Month
     , Day
     , Shipdate
     , Freight
     , City
     , Countryregion
     , Postalcode
     , Addressline
     , Product_Id
     , Unitprice
     , Discount
     , Originod_Id
     , Quantity
     , Companyname
     , Contactname
     , Phone
     , Origin_Id
     , Productname
     , Price
     , Originp_Id
     , Originc_Id
     , Categoryname
     , DW_O.Origin
FROM DataWarehouse.dbo.Orders DW_O
INNER JOIN DataWarehouse.dbo.Clients DW_C
  ON DW_C.Id_Client = DW_O.Customer_Id
INNER JOIN DataWarehouse.dbo.Products DW_P
  ON DW_P.Id_Product = DW_O.Product_Id
INNER JOIN DataWarehouse.dbo.Time DW_T
  ON DW_T.Id_Time = DW_O.OrderTime_Id
ORDER BY Origino_Id;

DECLARE @FinalQueryEndedAt DATETIME = GETDATE();
SELECT DATEDIFF(MCS, @FinalQueryStartAt, @FinalQueryEndedAt) AS DurationInMicroSecondsDW;
GO