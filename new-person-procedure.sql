CREATE OR ALTER PROCEDURE new_person(@id int,
                                     @first_name nvarchar(256),
                                     @last_name nvarchar(256),
                                     @sex char,
                                     @pesel nvarchar(11),
                                     @address nvarchar(256),
                                     @postal_code nvarchar(256),
                                     @region nvarchar(256),
                                     @city nvarchar(256),
                                     @country nvarchar(256),
                                     @birth_date datetime,
                                     @title_of_courtesy nvarchar(256),
                                     @email nvarchar(256))
AS
BEGIN TRY
  DECLARE @existing_person_id int
  SELECT @existing_person_id = person.id
  FROM person
  WHERE person.pesel = @pesel

  IF (@existing_person_id IS NOT NULL)
    BEGIN
      RAISERROR ('There arleady exists person with given PESEL(%s)!', 16, 1, @pesel)
    END

  SELECT @existing_person_id = person.id
  FROM person
  WHERE person.id = @id

  IF (@existing_person_id IS NOT NULL)
    BEGIN
      RAISERROR ('There arleady exists person with given id(%d)!', 16, 1, @id)
    END

  DECLARE @year nvarchar(256) = SUBSTRING(@pesel, 1, 2);
  DECLARE @month nvarchar(256) = SUBSTRING(@pesel, 3, 2);
  DECLARE @day nvarchar(256) = SUBSTRING(@pesel, 5, 2);

  DECLARE @century INT = CAST(SUBSTRING(@pesel, 3, 1) AS INT);
  SET @century = (((@century + 2) % 10) / 2) + 18;

  DECLARE @bday datetime = CAST(@century as NVARCHAR(256)) + @year + '-' + @month + '-' + @day

  IF (@birth_date IS NOT NULL AND @bday != @birth_date)
    BEGIN
      RAISERROR ('Birth date does not match PESEL!', 16, 1)
    END

  DECLARE @is_male_from_pesel INT = CAST(SUBSTRING(@pesel, 10, 1) AS INT) % 2
  IF ((@is_male_from_pesel = 0 AND @sex = 'M') OR (@is_male_from_pesel = 1 AND @sex = 'F'))
    BEGIN
      RAISERROR ('Sex does not match PESEL!', 16, 1)
    END

  INSERT INTO [person] ([id], [first_name], [last_name], [sex], [pesel], [address], [postal_code], [region], [city],
                        [country], [birth_date], [title_of_courtesy], [email])
  VALUES (@id, @first_name, @last_name, @sex, @pesel, @address, @postal_code, @region, @city, @country, @bday,
          @title_of_courtesy, @email)
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
