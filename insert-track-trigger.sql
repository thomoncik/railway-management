IF OBJECT_ID('limit_track_number_for_platform') IS NOT NULL DROP TRIGGER limit_track_number_for_platform
GO

CREATE OR ALTER TRIGGER limit_track_number_for_platform
    ON track
    INSTEAD OF INSERT AS
BEGIN
    DECLARE to_insert CURSOR
      FOR SELECT * FROM inserted
      FOR READ ONLY

    DECLARE @track_id INT
    DECLARE @platform_id INT
    DECLARE @station_id INT
    DECLARE @tracks INT

    OPEN to_insert
    FETCH to_insert INTO @track_id, @platform_id, @station_id

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF (@track_id < 1)
            PRINT('Track_id must be a positive integer')
        ELSE
          BEGIN
            SET @tracks =  (SELECT COUNT(*) FROM track WHERE platform_id = @platform_id AND platform_station_id = @station_id)
            IF (@tracks >= 2)
                PRINT('Platform cannot contain more than two tracks.')
            ELSE
              INSERT INTO track VALUES (@track_id, @platform_id, @station_id)
            END
        FETCH to_insert INTO @track_id, @platform_id, @station_id
    END
END

