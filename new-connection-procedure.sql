IF OBJECT_ID('new_connection') IS NOT NULL DROP PROCEDURE new_connection
GO

CREATE PROCEDURE new_connection(@train_id VARCHAR(16),
                                @train_name NVARCHAR(256),
                                @station_id INT,
                                @arrival_time DATETIME,
                                @departure_time DATETIME,
                                @day VARCHAR(32))
AS
BEGIN TRY
    IF (NOT EXISTS(SELECT id FROM train WHERE id = @train_id AND name = @train_name))
        BEGIN
            RAISERROR ('Train %s %s does not exist!', 16, 1, @train_id, @train_name)
        END

    IF (NOT EXISTS(SELECT id FROM station WHERE id = @station_id))
        BEGIN
            RAISERROR ('Station %d does not exist!', 16, 1, @station_id)
        END

--     IF dbo.get_train_departure_station (@train_id) <> @station_id AND dbo.get_train_arrival_station (@train_id) <> @station_id
--     BEGIN
--         RAISERROR ('Invalid departure station %d!', 16, 1, @station_id)
--     END

    IF @arrival_time >= @departure_time
        BEGIN
            RAISERROR ('Departure must take place after arrival!', 16, 1)
        END

    IF @day NOT IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')
        BEGIN
            RAISERROR ('%s is not proper day!', 16, 1, @day)
        END

    DECLARE @ptrack_station INT
    DECLARE @ptrack_platform INT
    DECLARE @ptrack_track INT
    DECLARE @selected BIT

    SET @selected = 0

    DECLARE potential_track CURSOR FOR
        SELECT *
        FROM track
        WHERE platform_station_id = @station_id

    OPEN potential_track
    FETCH potential_track INTO @ptrack_track, @ptrack_platform, @ptrack_station
    WHILE @@fetch_status = 0 AND @selected = 0
    BEGIN
        IF NOT EXISTS(SELECT *
                      FROM train_station
                      WHERE (track_id = @ptrack_track AND track_platform_id = @ptrack_platform AND
                             track_platform_station_id = @station_id)
                        AND (@arrival_time BETWEEN arrival_time AND departure_time)
                        AND day = @day
            )
            BEGIN
                SET @selected = 1
            END

        IF @selected = 0
            FETCH potential_track INTO @ptrack_track, @ptrack_platform, @ptrack_station
    END

    CLOSE potential_track
    DEALLOCATE potential_track

    DECLARE @sarrival VARCHAR(25)
    SET @sarrival = convert(VARCHAR(25), @arrival_time, 120)

    DECLARE @sdeparture VARCHAR(25)
    SET @sdeparture = convert(VARCHAR(25), @departure_time, 120)

    IF @selected = 0
        BEGIN
            RAISERROR ('Every track between %s and %s is already occupied!', 16, 1, @sarrival, @sdeparture)
        END

    PRINT @ptrack_track

    INSERT INTO train_station (train_id, train_name, station_id, arrival_time, departure_time, day, track_id,
                               track_platform_id, track_platform_station_id
    )
    VALUES (@train_id, @train_name, @station_id, @arrival_time, @departure_time, @day, @ptrack_track, @ptrack_platform,
            @station_id)

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
