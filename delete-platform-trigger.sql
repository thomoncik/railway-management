IF OBJECT_ID('delete_platform', 'TR') IS NOT NULL DROP TRIGGER delete_platform GO

CREATE TRIGGER delete_platform
  ON platform
  FOR DELETE
  AS
  DELETE
  FROM track
  WHERE platform_id IN (SELECT D.id FROM deleted as D)
