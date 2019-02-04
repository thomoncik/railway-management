CREATE OR ALTER PROCEDURE reset_password(@user_id int)
AS
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM [user] WHERE [user].id = @user_id)
    BEGIN
      RAISERROR ('Given user(%d) does not exist!', 16, 1, @user_id)
    END

  UPDATE [user]
  SET [reset_password_token] = newid(), [reset_password_sent_at] = SYSDATETIME()
  WHERE [user].id = @user_id
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
