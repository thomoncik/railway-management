IF OBJECT_ID('least_crowded_coach', 'FN') IS NOT NULL DROP FUNCTION least_crowded_coach
GO
IF OBJECT_ID('coach_fill_level', 'FN') IS NOT NULL DROP FUNCTION coach_fill_level
GO

CREATE FUNCTION coach_fill_level(@coach_id INT)
  RETURNS INT
AS
BEGIN
  DECLARE @fill INT
  SET @fill = (SELECT COUNT(T.id)
               FROM ticket as T
                      JOIN seat as S ON T.seat_id = S.id
               WHERE S.coach_id = @coach_id) * 100
  SET @fill = @fill / (SELECT C.capacity FROM coach as C WHERE C.id = @coach_id)
  RETURN @fill
END

GO

CREATE FUNCTION least_crowded_coach (@train_id INT, @train_name NVARCHAR(256))
RETURNS INT
AS
  BEGIN
DECLARE @id INT
SET @id =  (
    SELECT TOP 1 C.id
    FROM coach as C
    WHERE dbo.coach_fill_level( C.id ) =
          ( SELECT MIN ( dbo.coach_fill_level(D.id) )
            FROM coach as D
            WHERE D.train_id = @train_id AND D.train_name = @train_name
          )
  )
    RETURN @id
    END