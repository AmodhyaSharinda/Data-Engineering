use AdventureWorksDW
go

CREATE PROCEDURE dbo.UpdateDimProductSubCategory
	@ProductSubCategoryID INT,
	@ProductCategoryKey INT,
	@ProductSubCategoryName NVARCHAR(50),
	@rowguid uniqueidentifier,
	@ModifiedDate DATETIME,
	@EndDate DATETIME = '01/01/2099'

AS
BEGIN
    -- Check if the record exists in the DimProductSubCategory table with the given AlternateProductSubCategoryID
    IF NOT EXISTS(
		SELECT SubCategorySK
        FROM dbo.DimProductSubCategory
        WHERE ProductSubcategoryID = @ProductSubCategoryID
			AND IsCurrent = 1 -- Check only current records
    )
	BEGIN
        -- Insert new record for ProductSubCategory
        INSERT INTO dbo.DimProductSubCategory
        (ProductSubcategoryID, ProductCategoryID, Name, rowguid, ModifiedDate, StartDate, EndDate, IsCurrent)
        VALUES
        (@ProductSubCategoryID, @ProductCategoryKey, @ProductSubCategoryName, @rowguid, @ModifiedDate, GETDATE(), @EndDate, 1)
    END;
	ELSE
    BEGIN
		-- Check if any of the relevant values have changed
        IF EXISTS (
            SELECT 1
            FROM dbo.DimProductSubCategory
            WHERE ProductSubcategoryID = @ProductSubCategoryID
              AND IsCurrent = 1 -- Check only current records
              AND (
                  ProductCategoryID <> @ProductCategoryKey
                  OR Name <> @ProductSubCategoryName
                  OR rowguid <> @rowguid
                  OR ModifiedDate <> @ModifiedDate
              )
        )
        BEGIN
			-- Close the previous record by setting the EndDate and IsCurrent flag
			UPDATE dbo.DimProductSubCategory
			SET EndDate = GETDATE(), 
				IsCurrent = 0
			WHERE ProductSubcategoryID = @ProductSubCategoryID
			  AND IsCurrent = 1; -- Update only the current record

			-- Insert a new record for the updated ProductCategory
			INSERT INTO dbo.DimProductSubCategory
			(ProductSubcategoryID, ProductCategoryID, Name, rowguid, ModifiedDate, StartDate, EndDate, IsCurrent)
			VALUES
			(@ProductSubCategoryID, @ProductCategoryKey, @ProductSubCategoryName, @rowguid, @ModifiedDate, GETDATE(), @EndDate, 1)
		END;
    END;
END;
