IF OBJECT_ID('new_coach', 'P') IS NOT NULL DROP PROC new_coach GO

CREATE PROC new_coach(@coach_id NVARCHAR(16),
                      @class INT,
                      @capacity INT,
                      @has_ac BIT,
                      @has_230v_plug BIT,
                      @bicycle_seats INT,
                      @places_with_wheelchair_support INT,
                      @places_beside_table INT,
                      @train_id NVARCHAR(16),
                      @train_name NVARCHAR(256),
                      @coach_type_id INT)
AS

IF EXISTS(SELECT C.*
          FROM coach AS C
          WHERE C.id = @coach_id)
  BEGIN
    RAISERROR ('Given coach %s already exists!', 16, 1, @coach_id)
    RETURN (1)
  END


IF (@class < 1 OR @class > 2)
  BEGIN
    RAISERROR ('Given class %d is invalid!', 16, 1, @class)
    RETURN (1)
  END

IF @capacity < 0
  BEGIN
    RAISERROR ('Coach capacity cannot be negative!', 16, 1)
    RETURN (1)
  END

IF (@bicycle_seats < 0 OR @places_beside_table < 0 OR @places_with_wheelchair_support < 0)
  BEGIN
    RAISERROR ('Number of places cannot be negative!', 16, 1)
    RETURN (1)
  END

IF @places_beside_table > @capacity
  BEGIN
    RAISERROR ('Number of places beside table cannot be greater than coachs capacity!', 16, 1)
    RETURN (1)
  END

IF NOT EXISTS(SELECT T.*
              FROM train AS T
              WHERE T.id = @train_id
                AND T.name = @train_name)
  BEGIN
    RAISERROR ('Given train %s %s does not exist!', 16, 1, @train_id, @train_name)
    RETURN (1)
  END

IF NOT EXISTS(SELECT CT.*
              FROM coach_type AS CT
              WHERE CT.id = @coach_type_id)
  BEGIN
    RAISERROR ('Given coach type %s does not exist!', 16, 1, @coach_type_id)
    RETURN (1)
  END

DECLARE @number INT

IF NOT EXISTS(SELECT C.*
              FROM coach AS C
              WHERE C.train_id = @train_id
                AND C.train_name = @train_name)
  BEGIN
    IF @coach_type_id = 0 --engine
      SET @number = 0
    ELSE
      SET @number = 1
  END
ELSE
  SET @number = 1 + (SELECT MAX(C.number) FROM coach AS C WHERE C.train_id = @train_id AND C.train_name = @train_name)

INSERT INTO coach
VALUES (@coach_id, @number, @class, @capacity, @has_ac, @has_230v_plug, @bicycle_seats,
        @places_with_wheelchair_support, @places_beside_table, @train_id, @train_name, @coach_type_id)


DECLARE @seats INT

CREATE SEQUENCE numeration
  START WITH 1
  INCREMENT BY 1;

DECLARE @seat_number INT


SET @seats = @places_beside_table

WHILE @seats > 0
BEGIN
  SET @seat_number = NEXT VALUE FOR numeration
  IF @seat_number % 2 = 1
    BEGIN
      INSERT INTO seat
      VALUES (@seat_number, 'W', @coach_id, 1)
    END
  ELSE
    BEGIN
      INSERT INTO seat
      VALUES (@seat_number, 'O', @coach_id, 1)
    END
  SET @seats = @seats - 1
END


SET @seats = @capacity - @places_beside_table

WHILE @seats > 0
BEGIN
  SET @seat_number = NEXT VALUE FOR numeration
  IF @seat_number % 2 = 1
    BEGIN
      INSERT INTO seat
      VALUES (@seat_number, 'W', @coach_id, 0)
    END
  ELSE
    BEGIN
      INSERT INTO seat
      VALUES (@seat_number, 'O', @coach_id, 0)
    END
  SET @seats = @seats - 1
END

RETURN (0)
GO