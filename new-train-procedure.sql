IF OBJECT_ID('new_train', 'P') IS NOT NULL DROP PROC new_train
GO

CREATE PROC new_train(@train_id NVARCHAR(16), @train_name NVARCHAR(256), @carrier_name NVARCHAR(256))
AS

BEGIN TRY
    DECLARE @carrier_id INT
    SET @carrier_name = UPPER(@carrier_name)

    IF NOT EXISTS(SELECT c.name
                  FROM carrier AS c
                  WHERE c.name = @carrier_name)
        BEGIN
            RAISERROR ('Given Carrier %s does not exist!!', 16, 1, @carrier_name)
        END

    SET @carrier_id = (SELECT c.id
                       FROM carrier AS c
                       WHERE c.name = @carrier_name)

    IF EXISTS(SELECT *
              FROM train AS t
              WHERE t.id = @train_id
                AND t.name = @train_name)
        BEGIN
            RAISERROR ('Given train %s %s already exists!!', 16, 1, @train_id, @train_name)
        END

    DECLARE @departure_station_id INT
    SET @departure_station_id = CONVERT(INT, SUBSTRING(@train_id, 1, 1))

    IF NOT EXISTS(SELECT s.id
                  FROM station AS s
                  WHERE s.id = @departure_station_id)
        BEGIN
            RAISERROR ('Departure station id %d does not exist!', 16, 1, @departure_station_id)
        END

    DECLARE @arrival_station_id INT
    SET @arrival_station_id = CONVERT(INT, SUBSTRING(@train_id, 2, 1))

    IF NOT EXISTS(SELECT s.id
                  FROM station AS s
                  WHERE s.id = @arrival_station_id)
        BEGIN
            RAISERROR ('Arrival station id %d does not exist!', 16, 1, @arrival_station_id)
        END

    IF @departure_station_id = @arrival_station_id
        BEGIN
            RAISERROR ('Departure station id and arrival station id cannot be the same!', 16, 1)
        END

    INSERT INTO train
    VALUES (@train_id, @train_name, @carrier_id)
END TRY
BEGIN CATCH
    DECLARE @error_msg NVARCHAR(256)
    DECLARE @error_severity NVARCHAR(256)
    DECLARE @error_state NVARCHAR(256)

    SET @error_msg = ERROR_MESSAGE()
    SET @error_severity = ERROR_SEVERITY()
    SET @error_state = ERROR_STATE()

    RAISERROR (@error_msg, @error_severity, @error_state)
END CATCH

GO
