CREATE TABLE DimProduct (
    ProductSK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate key
    ProductID INT NOT NULL,                  -- Business key
    Name NVARCHAR(50),
    ProductNumber NVARCHAR(25),
    MakeFlag BIT,
    FinishedGoodsFlag BIT,
    Color NVARCHAR(15),
    SafetyStockLevel SMALLINT,
    ReorderPoint SMALLINT,
    StandardCost DECIMAL(19, 4),
    ListPrice DECIMAL(19, 4),
    Size NVARCHAR(5),
    SizeUnitMeasureCode NCHAR(3),
    WeightUnitMeasureCode NCHAR(3),
    Weight DECIMAL(8, 2),
    DaysToManufacture INT,
    ProductLine NCHAR(2),
    Class NCHAR(2),
    Style NCHAR(2),
    ProductSubcategoryID INT,
    ProductModelID INT,
    SellStartDate DATETIME,
    SellEndDate DATETIME,
    DiscontinuedDate DATETIME,
    rowguid UNIQUEIDENTIFIER,
    ModifiedDate DATETIME,
    StartDate DATETIME NOT NULL,             -- SCD Type 2 Start Date
    EndDate DATETIME,                        -- SCD Type 2 End Date
    IsCurrent BIT NOT NULL                   -- Is the record current?
);
