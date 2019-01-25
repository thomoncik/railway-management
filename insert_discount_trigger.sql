USE railway
GO

IF OBJECT_ID('insert_discount_trigger') IS NOT NULL DROP TRIGGER insert_discount_trigger
GO

CREATE TRIGGER insert_discount_trigger
    ON discount
    INSTEAD OF INSERT
    AS
BEGIN
    DECLARE to_insert CURSOR FOR
        SELECT * FROM inserted

    DECLARE @id INT
    DECLARE @name NVARCHAR(256)
    DECLARE @description NVARCHAR(256)
    DECLARE @value INT

    OPEN to_insert

    FETCH to_insert INTO @id, @name, @description, @value

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @value BETWEEN 0 AND 100
            BEGIN
                INSERT INTO discount
                VALUES (@id, @name, @description, @value)
            END
        ELSE
            BEGIN
                PRINT 'Discount value ' + CONVERT(VARCHAR(5), @value) + ' must be between 0 percent and 100 percent!'
            END

        FETCH to_insert INTO @id, @name, @description, @value
    END

    CLOSE to_insert
    DEALLOCATE to_insert

END
GO
