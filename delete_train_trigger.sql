IF OBJECT_ID('delete_train', 'TR') IS NOT NULL DROP TRIGGER delete_train GO

CREATE TRIGGER delete_train
  ON train
  FOR DELETE
  AS
  DELETE
  FROM platform
  WHERE station_id IN (SELECT D.id FROM deleted AS D)