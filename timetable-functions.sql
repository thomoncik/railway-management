IF OBJECT_ID('train_timetable', 'FN') IS NOT NULL DROP FUNCTION train_timetable
GO
IF OBJECT_ID('station_timetable', 'FN') IS NOT NULL DROP FUNCTION station_timetable
GO

CREATE FUNCTION train_timetable(@train_id INT, @train_name NVARCHAR(256))
  RETURNS TABLE
    AS
    RETURN
          (
            SELECT t.*
            FROM dbo.timetable AS t
            WHERE t.train_id = @train_id
              AND t.train_name = @train_name
          )

GO

CREATE FUNCTION station_timetable(@station_id INT)
  RETURNS TABLE
    AS
    RETURN
          (
            SELECT t.*
            FROM dbo.timetable AS t
            WHERE t.station_id = @station_id
          )
GO