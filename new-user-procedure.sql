CREATE OR ALTER PROCEDURE new_user(@person_id int,
                                   @id int,
                                   @login nvarchar(256),
                                   @encrypted_password nvarchar(256))
AS
BEGIN TRY
  IF EXISTS(SELECT * FROM [user] WHERE [user].id = @id)
    BEGIN
      RAISERROR ('Given user(%d) does already exist!', 16, 1, @id)
    END

  IF NOT EXISTS(SELECT * FROM person WHERE person.id = @person_id)
    BEGIN
      RAISERROR ('Given person(%d) does not exist!', 16, 1, @person_id)
    END

  INSERT INTO [user] ([id], [person_id], [login], [encrypted_password], [created_at], [updated_at])
  VALUES (@id, @person_id, @login, @encrypted_password, SYSDATETIME(), SYSDATETIME())

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
