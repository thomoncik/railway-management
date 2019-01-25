IF OBJECT_ID('is_valid_pesel') IS NOT NULL DROP FUNCTION is_valid_pesel
GO

CREATE OR ALTER FUNCTION is_valid_pesel(@pesel NVARCHAR(11)) RETURNS BIT
AS
BEGIN
    IF ISNUMERIC(@pesel) = 0
        RETURN 0

    DECLARE @a AS INT = 0;

    SET @a = CAST(SUBSTRING(@pesel, 1, 1) AS INT) * 9 + @a;
    SET @a = CAST(SUBSTRING(@pesel, 2, 1) AS INT) * 7 + @a;
    SET @a = CAST(SUBSTRING(@pesel, 3, 1) AS INT) * 3 + @a;
    SET @a = CAST(SUBSTRING(@pesel, 4, 1) AS INT) * 1 + @a;
    SET @a = CAST(SUBSTRING(@pesel, 5, 1) AS INT) * 9 + @a;
    SET @a = CAST(SUBSTRING(@pesel, 6, 1) AS INT) * 7 + @a;
    SET @a = CAST(SUBSTRING(@pesel, 7, 1) AS INT) * 3 + @a;
    SET @a = CAST(SUBSTRING(@pesel, 8, 1) AS INT) * 1 + @a;
    SET @a = CAST(SUBSTRING(@pesel, 9, 1) AS INT) * 9 + @a;
    SET @a = CAST(SUBSTRING(@pesel, 10, 1) AS INT) * 7 + @a;

    IF @a % 10 = CAST(SUBSTRING(@pesel, 11, 1) AS INT)
        RETURN 1

    RETURN 0
END
GO

-- Add constraint to person table
ALTER TABLE dbo.person
    ADD CONSTRAINT check_pesel CHECK (dbo.is_valid_pesel(pesel) = 1)
GO
