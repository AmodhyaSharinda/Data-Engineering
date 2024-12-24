use AdventureWorksDW
go 

CREATE TABLE DimProductSubCategory (
    SubCategorySK INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate Key
    ProductSubcategoryID INT NOT NULL,            -- Natural Key
    ProductCategoryID INT,
    Name NVARCHAR(50),
    rowguid UNIQUEIDENTIFIER,
    ModifiedDate DATETIME,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME,
    IsCurrent BIT NOT NULL
);
