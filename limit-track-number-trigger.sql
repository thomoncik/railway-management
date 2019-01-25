IF OBJECT_ID('limit_track_number_for_platform') IS NOT NULL DROP TRIGGER limit_track_number_for_platform
GO

CREATE OR ALTER TRIGGER limit_track_number_for_platform
    ON track
    INSTEAD OF INSERT AS
BEGIN

    DECLARE @platform_id INT
    DECLARE @station_id INT

    SELECT @platform_id = platform_id FROM inserted;
    SELECT @station_id = platform_station_id FROM inserted;


    DECLARE @tracks INT
    SELECT @tracks = COUNT(*) FROM track WHERE platform_id = @platform_id AND platform_station_id = @station_id;

    IF (@tracks >= 2)
        THROW 50000, 'Platform cannot contain more than two tracks.', 1;

    INSERT INTO track SELECT * FROM inserted;
END
