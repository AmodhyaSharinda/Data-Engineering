use AdventureWorksDW
go

CREATE TABLE dbo.FactSales
(
    SalesOrderID INT PRIMARY KEY,
    CustomerID INT,                          -- Foreign key to DimCustomer
    ProductID INT,                           -- Foreign key to DimProduct
    DateKey INT,                             -- Foreign key to DimDate
    EmployeeID INT,                          -- Foreign key to DimEmployee
    SalesAmount DECIMAL(18, 2),
    Quantity INT,
    TotalAmount DECIMAL(18, 2),
    Discount DECIMAL(18, 2),
    TaxAmount DECIMAL(18, 2),
    rowguid UNIQUEIDENTIFIER,
    ModifiedDate DATETIME,
    StartDate DATETIME DEFAULT GETDATE(),
    EndDate DATETIME DEFAULT '2099-12-31',
    IsCurrent BIT DEFAULT 1
);
