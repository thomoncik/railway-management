CREATE TRIGGER delete_platform
  ON platform
  FOR DELETE
  AS
  IF EXISTS(SELECT T.*
            FROM track as T
                   JOIN deleted as D ON T.platform_id = D.id)
    BEGIN
      DELETE
      FROM track
      WHERE platform_id IN (SELECT D.id FROM deleted as D)
    END