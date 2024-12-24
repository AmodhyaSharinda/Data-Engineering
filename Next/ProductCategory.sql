use AdventureWorksDW
go

-- Create the DimProductCategory table with SCD Type 2 columns
CREATE TABLE dbo.DimProductCategory (
    ProductCategorySK INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    ProductCategoryID INT NOT NULL, -- Business Key
    Name NVARCHAR(50) NOT NULL,
    rowguid UNIQUEIDENTIFIER NOT NULL,
    ModifiedDate DATETIME NOT NULL,
    StartDate DATETIME NOT NULL, -- Effective Start Date
    EndDate DATETIME NULL,       -- Effective End Date (NULL for current record)
    IsCurrent BIT NOT NULL       -- Flag to indicate if the record is current
);

