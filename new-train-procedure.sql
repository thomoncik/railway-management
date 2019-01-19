IF OBJECT_ID ('new_train', 'P') IS NOT NULL DROP PROC new_train
GO

CREATE PROC new_train (
    @train_id NVARCHAR(16),
    @train_name NVARCHAR(256),
    @carrier_name NVARCHAR(256)
)
AS

DECLARE @carrier_id INT

IF NOT EXISTS (SELECT C.name FROM carrier AS C WHERE C.name = @carrier_name)
BEGIN
    RAISERROR ('Given Carrier %s does not exist!!', 16, 1, @carrier_name)
    RETURN(1)
END

SET @carrier_id = (SELECT C.id FROM carrier AS C WHERE C.name = @carrier_name)

IF EXISTS (SELECT * FROM train AS T WHERE T.id = @train_id AND T.name = @train_name)
BEGIN
    RAISERROR ('Given train %s %s already exists!!', 16, 1, @train_id, @train_name)
    RETURN(2)
END

DECLARE @departure_station_id INT
SET @departure_station_id = CONVERT(INT, SUBSTRING(@train_id, 1, 1))

IF NOT EXISTS (SELECT S.id FROM station AS S WHERE S.id = @departure_station_id)
BEGIN
    RAISERROR ('Departure station id %d does not exist!', 16, 1, @departure_station_id)
    RETURN(3)
END

DECLARE @arrival_station_id INT
SET @arrival_station_id = CONVERT(INT, SUBSTRING(@train_id, 2, 1))

IF NOT EXISTS (SELECT S.id FROM station AS S WHERE S.id = @arrival_station_id)
BEGIN
    RAISERROR ('Arrival station id %d does not exist!', 16, 1, @arrival_station_id)
    RETURN(4)
END

INSERT INTO train
    VALUES (@train_id, @train_name, @carrier_id)

RETURN(0)
GO
