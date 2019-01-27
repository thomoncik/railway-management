IF OBJECT_ID('insert_carrier') IS NOT NULL DROP TRIGGER insert_carrier
GO

CREATE TRIGGER insert_carrier
    ON carrier
    INSTEAD OF INSERT AS
BEGIN
    DECLARE to_insert CURSOR
        FOR SELECT * FROM inserted
        FOR READ ONLY

    DECLARE @carrier_id INT
    DECLARE @carrier_name NVARCHAR(256)
    DECLARE @carrier_ticket MONEY

    OPEN to_insert

    FETCH to_insert INTO @carrier_id, @carrier_name, @carrier_ticket

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @carrier_ticket >= 0
        BEGIN
            SET @carrier_name = UPPER(@carrier_name)

            INSERT INTO carrier
            VALUES (@carrier_id, @carrier_name, @carrier_ticket)

            FETCH to_insert INTO @carrier_id, @carrier_name, @carrier_ticket
        END ELSE
        BEGIN
            RAISERROR ('Ticket price must be non-negative!', 16, 1)
            RETURN
        END
    END

    CLOSE to_insert
    DEALLOCATE to_insert
END
GO
