use AdventureWorksDW
go

CREATE PROCEDURE dbo.UpdateDimEmployee
    @BusinessEntityID INT,
    @TerritoryID INT,
    @SalesQuota DECIMAL(18, 2),
    @Bonus DECIMAL(18, 2),
    @CommissionPct DECIMAL(18, 2),
    @SalesYTD DECIMAL(18, 2),
    @SalesLastYear DECIMAL(18, 2),
    @rowguid UNIQUEIDENTIFIER,
    @ModifiedDate DATETIME,
    @EndDate DATETIME = '01/01/2099'
AS
BEGIN
	-- Check if the record exists in the DimProduct table with the given ProductID
    IF NOT EXISTS(
        SELECT EmployeeSK
        FROM dbo.DimEmployee
        WHERE BusinessEntityID = @BusinessEntityID
            AND IsCurrent = 1 -- Check only current records
    )
    BEGIN
        -- Insert new record for Customer
        INSERT INTO dbo.DimEmployee
        (BusinessEntityID, TerritoryID, SalesQuota, Bonus, CommissionPct, SalesYTD, SalesLastYear, rowguid, ModifiedDate, StartDate, EndDate, IsCurrent)
        VALUES
        (@BusinessEntityID, @TerritoryID, @SalesQuota, @Bonus, @CommissionPct, @SalesYTD, @SalesLastYear, @rowguid, @ModifiedDate, GETDATE(), @EndDate, 1)
    END
    ELSE
    BEGIN
		-- Check if any of the relevant values have changed
        IF EXISTS (
            SELECT 1
            FROM dbo.DimEmployee
            WHERE BusinessEntityID = @BusinessEntityID
			  AND IsCurrent = 1
			  AND (
				  TerritoryID <> @TerritoryID
				  OR SalesQuota <> @SalesQuota
				  OR Bonus <> @Bonus
				  OR CommissionPct <> @CommissionPct
				  OR SalesYTD <> @SalesYTD
				  OR SalesLastYear <> @SalesLastYear
				  OR rowguid <> @rowguid
				  OR ModifiedDate <> @ModifiedDate
			  )
        )
        BEGIN
			-- Close the previous record by setting the EndDate and IsCurrent flag
			UPDATE dbo.DimEmployee
			SET EndDate = GETDATE(), 
				IsCurrent = 0
            WHERE BusinessEntityID = @BusinessEntityID
			  AND IsCurrent = 1; -- Update only the current record

			INSERT INTO dbo.DimEmployee
			(BusinessEntityID, TerritoryID, SalesQuota, Bonus, CommissionPct, SalesYTD, SalesLastYear, rowguid, ModifiedDate, StartDate, EndDate, IsCurrent)
			VALUES
			(@BusinessEntityID, @TerritoryID, @SalesQuota, @Bonus, @CommissionPct, @SalesYTD, @SalesLastYear, @rowguid, @ModifiedDate, GETDATE(), @EndDate, 1)
		END
    END
END;