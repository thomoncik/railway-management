IF OBJECT_ID('delete_train', 'TR') IS NOT NULL DROP TRIGGER delete_train GO

CREATE TRIGGER delete_train
  ON train
  FOR DELETE
  AS
  DELETE
  FROM train_station
  WHERE EXISTS ( SELECT D.* FROM deleted as D WHERE D.id = train_id AND D.name = train_name )