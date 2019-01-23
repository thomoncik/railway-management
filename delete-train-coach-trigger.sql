IF OBJECT_ID('delete_train', 'TR') IS NOT NULL DROP TRIGGER delete_train
GO
IF OBJECT_ID('delete_coach', 'TR') IS NOT NULL DROP TRIGGER delete_coach
GO


CREATE TRIGGER delete_train
  ON train
  FOR DELETE
  AS
BEGIN
  DELETE
  FROM train_station
  WHERE EXISTS(SELECT D.* FROM deleted as D WHERE D.id = train_id AND D.name = train_name);

  DELETE
  FROM coach
  WHERE EXISTS(SELECT D.* FROM deleted as D WHERE D.id = train_id AND D.name = train_name)
END

GO

CREATE TRIGGER delete_coach
  ON coach
  FOR DELETE
  AS
  DELETE
  FROM seat
  WHERE coach_id IN ( SELECT id FROM deleted )