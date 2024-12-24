USE AdventureWorksDW;
GO

-- Create the DimCustomer table
CREATE TABLE dbo.DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY, -- Surrogate Key
    CustomerID INT NOT NULL,                  -- Business Key
    PersonID INT,                             -- Optional: Link to person details
    StoreID INT,                              -- Optional: Link to store details
    TerritoryID INT,                          -- Optional: Link to territory details
    AccountNumber NVARCHAR(50),               -- Account Number for the customer
    rowguid UNIQUEIDENTIFIER NOT NULL,        -- Globally unique identifier
    ModifiedDate DATETIME NOT NULL,           -- Date of last modification
    StartDate DATETIME NOT NULL,     -- Start date for SCD tracking
    EndDate DATETIME DEFAULT '2099-12-31',    -- End date for SCD tracking
    IsCurrent BIT DEFAULT 1                   -- Flag for current record
);

ALTER TABLE dbo.DimCustomer
ALTER COLUMN AccountNumber VARCHAR(10);
