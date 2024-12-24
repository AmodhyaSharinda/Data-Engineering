use AdventureWorksDW
go

CREATE PROCEDURE dbo.UpdateDimProductCategory
    @ProductCategoryID INT,
    @ProductCategoryName NVARCHAR(50),
	@rowguid uniqueidentifier,
    @ModifiedDate DATETIME,
	@EndDate DATETIME = '01/01/2099'

AS
BEGIN
    -- Check if the ProductCategoryID already exists
    IF NOT EXISTS (
        SELECT ProductCategorySK
        FROM dbo.DimProductCategory
        WHERE ProductCategoryID = @ProductCategoryID
          AND IsCurrent = 1 -- Check only current records
    )
    BEGIN
        -- Insert new record for ProductCategory
        INSERT INTO dbo.DimProductCategory
        (ProductCategoryID, Name, rowguid, ModifiedDate, StartDate, EndDate, IsCurrent)
        VALUES
        (@ProductCategoryID, @ProductCategoryName, @rowguid, @ModifiedDate, GETDATE(), @EndDate, 1)
    END;
    ELSE
    BEGIN
		-- Check if the values have changed before updating
        IF EXISTS (
            SELECT 1
            FROM dbo.DimProductCategory
            WHERE ProductCategoryID = @ProductCategoryID
              AND IsCurrent = 1 -- Check only current records
              AND (Name <> @ProductCategoryName 
                   OR rowguid <> @rowguid
                   OR ModifiedDate <> @ModifiedDate)
        )

		BEGIN

			-- Close the previous record by setting the EndDate and IsCurrent flag
			UPDATE dbo.DimProductCategory
			SET EndDate = GETDATE(), 
				IsCurrent = 0
			WHERE ProductCategoryID = @ProductCategoryID
			  AND IsCurrent = 1; -- Update only the current record

			-- Insert a new record for the updated ProductCategory
			INSERT INTO dbo.DimProductCategory
			(ProductCategoryID, Name, rowguid, ModifiedDate, StartDate, EndDate, IsCurrent)
			VALUES
			(@ProductCategoryID, @ProductCategoryName, @rowguid, @ModifiedDate, GETDATE(), @EndDate, 1)

		END;
    END;
END;


