USE AdventureWorksDW;
GO

CREATE TABLE dbo.DimEmployee
(
    -- Surrogate Key
    EmployeeSK INT IDENTITY(1,1) PRIMARY KEY, 

    -- Business Data Columns
    BusinessEntityID INT NOT NULL, 
    TerritoryID INT,
    SalesQuota DECIMAL(18, 2),
    Bonus DECIMAL(18, 2),
    CommissionPct DECIMAL(18, 2),
    SalesYTD DECIMAL(18, 2),
    SalesLastYear DECIMAL(18, 2),
    rowguid UNIQUEIDENTIFIER,
    ModifiedDate DATETIME,

    -- SCD Type 2 Tracking Columns
    StartDate DATETIME NOT NULL, 
    EndDate DATETIME NOT NULL, 
    IsCurrent BIT DEFAULT 1
);
GO
