use AdventureWorksDW
go

CREATE PROCEDURE dbo.UpdateDimCustomer
    @CustomerID INT,
    @PersonID INT,
    @StoreID INT,
    @TerritoryID INT,
    @AccountNumber VARCHAR(10),
    @rowguid UNIQUEIDENTIFIER,
    @ModifiedDate DATETIME,
    @EndDate DATETIME = '01/01/2099'

AS
BEGIN
    -- Check if the record exists in the DimProduct table with the given ProductID
    IF NOT EXISTS(
        SELECT CustomerKey
        FROM dbo.DimCustomer
        WHERE CustomerID = @CustomerID
            AND IsCurrent = 1 -- Check only current records
    )
    BEGIN
        -- Insert new record for Customer
        INSERT INTO dbo.DimCustomer
        (CustomerID, PersonID, StoreID, TerritoryID, AccountNumber, rowguid, ModifiedDate, StartDate, EndDate, IsCurrent)
        VALUES
        (@CustomerID, @PersonID, @StoreID, @TerritoryID, @AccountNumber, @rowguid, @ModifiedDate, GETDATE(), @EndDate, 1)
    END
    ELSE
    BEGIN
		-- Check if any of the relevant values have changed
        IF EXISTS (
            SELECT 1
            FROM dbo.DimCustomer
            WHERE CustomerID = @CustomerID
              AND IsCurrent = 1 -- Check only current records
              AND (
                  PersonID <> @PersonID
                  OR StoreID <> @StoreID
                  OR TerritoryID <> @TerritoryID
                  OR AccountNumber <> @AccountNumber
                  OR rowguid <> @rowguid
                  OR ModifiedDate <> @ModifiedDate
              )
        )
        BEGIN
			-- Close the previous record by setting the EndDate and IsCurrent flag
			UPDATE dbo.DimCustomer
			SET EndDate = GETDATE(), 
				IsCurrent = 0
			WHERE CustomerID = @CustomerID
			  AND IsCurrent = 1; -- Update only the current record

			-- Insert a new record for the updated Product
			INSERT INTO dbo.DimCustomer
			(CustomerID, PersonID, StoreID, TerritoryID, AccountNumber, rowguid, ModifiedDate, StartDate, EndDate, IsCurrent)
			VALUES
			(@CustomerID, @PersonID, @StoreID, @TerritoryID, @AccountNumber, @rowguid, @ModifiedDate, GETDATE(), @EndDate, 1)
		END;
    END
END;
