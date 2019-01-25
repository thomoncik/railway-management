IF OBJECT_ID('get_train_departure_station') IS NOT NULL DROP FUNCTION get_train_departure_station
GO

CREATE FUNCTION get_train_departure_station(
    @train_id VARCHAR(16)
)
    RETURNS INT
AS
BEGIN
    DECLARE @departure_station_id INT;
    SET @departure_station_id = CONVERT(INT, LEFT(@train_id, 1))

    RETURN @departure_station_id
END
GO

IF OBJECT_ID('get_train_arrival_station') IS NOT NULL DROP FUNCTION get_train_arrival_station
GO

CREATE FUNCTION get_train_arrival_station(
    @train_id VARCHAR(16)
)
    RETURNS INT
AS
BEGIN
    DECLARE @arrival_station_id INT;
    SET @arrival_station_id = CONVERT(INT, SUBSTRING(@train_id, 2, 1))

    RETURN @arrival_station_id
END
GO