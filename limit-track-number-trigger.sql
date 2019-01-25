CREATE OR ALTER TRIGGER limit_track_number_for_platform ON track
INSTEAD OF INSERT AS BEGIN

  DECLARE @platform_id INT
  SELECT @platform_id=platform_id FROM inserted;

  DECLARE @tracks INT
  SELECT @tracks=COUNT(*) FROM track WHERE platform_id = @platform_id;

  print @tracks
  print @platform_id

  IF (@tracks < 2)
    INSERT INTO track SELECT * from inserted;

  THROW 50000, 'Platform cannot contain more than two tracks.', 1;
END

