USE AdventureWorksDW
GO

CREATE PROCEDURE dbo.UpdateDimProduct
    @ProductID INT,
    @ProductNumber NVARCHAR(25),
    @Name NVARCHAR(50),
    @MakeFlag BIT,
    @FinishedGoodsFlag BIT,
    @Color NVARCHAR(15),
    @SafetyStockLevel INT,
    @ReorderPoint INT,
    @StandardCost DECIMAL(19, 4),
    @ListPrice DECIMAL(19, 4),
    @Size NVARCHAR(5),
    @SizeUnitMeasureCode NVARCHAR(3),
    @WeightUnitMeasureCode NVARCHAR(3),
    @Weight DECIMAL(8, 2),
    @DaysToManufacture INT,
    @ProductLine NVARCHAR(2),
    @Class NVARCHAR(2),
    @Style NVARCHAR(2),
    @ProductSubcategoryID INT,
    @ProductModelID INT,
    @SellStartDate DATETIME,
    @SellEndDate DATETIME,
    @DiscontinuedDate DATETIME,
    @rowguid uniqueidentifier,
    @ModifiedDate DATETIME,
    @EndDate DATETIME = '01/01/2099'

AS
BEGIN
    -- Check if the record exists in the DimProduct table with the given ProductID
    IF NOT EXISTS(
        SELECT ProductSK
        FROM dbo.DimProduct
        WHERE ProductID = @ProductID
            AND IsCurrent = 1 -- Check only current records
    )
    BEGIN
        -- Insert new record for Product
        INSERT INTO dbo.DimProduct
        (ProductID, ProductNumber, Name, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, 
         ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, 
         Weight, DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, 
         SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate, StartDate, EndDate, IsCurrent)
        VALUES
        (@ProductID, @ProductNumber, @Name, @MakeFlag, @FinishedGoodsFlag, @Color, @SafetyStockLevel,
         @ReorderPoint, @StandardCost, @ListPrice, @Size, @SizeUnitMeasureCode, @WeightUnitMeasureCode,
         @Weight, @DaysToManufacture, @ProductLine, @Class, @Style, @ProductSubcategoryID, @ProductModelID,
         @SellStartDate, @SellEndDate, @DiscontinuedDate, @rowguid, @ModifiedDate, GETDATE(), @EndDate, 1)
    END
    ELSE
    BEGIN
		-- Check if any of the relevant values have changed
        IF EXISTS (
            SELECT 1
            FROM dbo.DimProduct
            WHERE ProductID = @ProductID
              AND IsCurrent = 1 -- Check only current records
              AND (
                  ProductNumber <> @ProductNumber
                  OR Name <> @Name
                  OR MakeFlag <> @MakeFlag
                  OR FinishedGoodsFlag <> @FinishedGoodsFlag
                  OR Color <> @Color
                  OR SafetyStockLevel <> @SafetyStockLevel
                  OR ReorderPoint <> @ReorderPoint
                  OR StandardCost <> @StandardCost
                  OR ListPrice <> @ListPrice
                  OR Size <> @Size
                  OR SizeUnitMeasureCode <> @SizeUnitMeasureCode
                  OR WeightUnitMeasureCode <> @WeightUnitMeasureCode
                  OR Weight <> @Weight
                  OR DaysToManufacture <> @DaysToManufacture
                  OR ProductLine <> @ProductLine
                  OR Class <> @Class
                  OR Style <> @Style
                  OR ProductSubcategoryID <> @ProductSubcategoryID
                  OR ProductModelID <> @ProductModelID
                  OR SellStartDate <> @SellStartDate
                  OR SellEndDate <> @SellEndDate
                  OR DiscontinuedDate <> @DiscontinuedDate
                  OR rowguid <> @rowguid
                  OR ModifiedDate <> @ModifiedDate
              )
        )
        BEGIN
			-- Close the previous record by setting the EndDate and IsCurrent flag
			UPDATE dbo.DimProduct
			SET EndDate = GETDATE(), 
				IsCurrent = 0
			WHERE ProductID = @ProductID
			  AND IsCurrent = 1; -- Update only the current record

			-- Insert a new record for the updated Product
			INSERT INTO dbo.DimProduct
			(ProductID, ProductNumber, Name, MakeFlag, FinishedGoodsFlag, Color, SafetyStockLevel, 
			 ReorderPoint, StandardCost, ListPrice, Size, SizeUnitMeasureCode, WeightUnitMeasureCode, 
			 Weight, DaysToManufacture, ProductLine, Class, Style, ProductSubcategoryID, ProductModelID, 
			 SellStartDate, SellEndDate, DiscontinuedDate, rowguid, ModifiedDate, StartDate, EndDate, IsCurrent)
			VALUES
			(@ProductID, @ProductNumber, @Name, @MakeFlag, @FinishedGoodsFlag, @Color, @SafetyStockLevel,
			 @ReorderPoint, @StandardCost, @ListPrice, @Size, @SizeUnitMeasureCode, @WeightUnitMeasureCode,
			 @Weight, @DaysToManufacture, @ProductLine, @Class, @Style, @ProductSubcategoryID, @ProductModelID,
			 @SellStartDate, @SellEndDate, @DiscontinuedDate, @rowguid, @ModifiedDate, GETDATE(), @EndDate, 1)
		END;
    END
END;
