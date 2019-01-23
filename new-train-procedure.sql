IF OBJECT_ID('new_train', 'P') IS NOT NULL DROP PROC new_train
GO

CREATE PROC new_train(@train_id NVARCHAR(16), @train_name NVARCHAR(256), @carrier_name NVARCHAR(256))
AS

DECLARE @carrier_id INT

IF NOT EXISTS(SELECT c.name
              FROM carrier AS c
              WHERE c.name = @carrier_name)
    BEGIN
        RAISERROR ('Given Carrier %s does not exist!!', 16, 1, @carrier_name)
        RETURN (1)
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
        RETURN (2)
    END

DECLARE @departure_station_id INT
SET @departure_station_id = CONVERT(INT, SUBSTRING(@train_id, 1, 1))

IF NOT EXISTS(SELECT s.id
              FROM station AS s
              WHERE s.id = @departure_station_id)
    BEGIN
        RAISERROR ('Departure station id %d does not exist!', 16, 1, @departure_station_id)
        RETURN (3)
    END

DECLARE @arrival_station_id INT
SET @arrival_station_id = CONVERT(INT, SUBSTRING(@train_id, 2, 1))

IF NOT EXISTS(SELECT s.id
              FROM station AS s
              WHERE s.id = @arrival_station_id)
    BEGIN
        RAISERROR ('Arrival station id %d does not exist!', 16, 1, @arrival_station_id)
        RETURN (4)
    END

IF @departure_station_id = @arrival_station_id
    BEGIN
        RAISERROR ('Departure station id and arrival station id cannot be the same!', 16, 1)
        RETURN (5)
    END

INSERT INTO train
VALUES (@train_id, @train_name, @carrier_id)

RETURN (0)
GO
