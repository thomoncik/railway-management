IF OBJECT_ID('least_crowded_coach', 'FN') IS NOT NULL DROP FUNCTION least_crowded_coach
GO
IF OBJECT_ID('coach_fill_level', 'FN') IS NOT NULL DROP FUNCTION coach_fill_level
GO

CREATE FUNCTION coach_fill_level(@coach_id INT)
    RETURNS INT
AS
BEGIN
    DECLARE @fill INT
    SET @fill = (SELECT COUNT(t.id)
                 FROM ticket AS t
                          JOIN seat AS s ON t.seat_id = s.id
                 WHERE s.coach_id = @coach_id) * 100
    SET @fill = @fill / (SELECT c.capacity FROM coach AS c WHERE c.id = @coach_id)
    RETURN @fill
END

GO

CREATE FUNCTION least_crowded_coach(@train_id INT, @train_name NVARCHAR(256))
    RETURNS INT
AS
BEGIN
    DECLARE @id INT
    SET @id = (
        SELECT TOP 1 c.id
        FROM coach AS c
        WHERE dbo.coach_fill_level(c.id) =
              (SELECT MIN(dbo.coach_fill_level(d.id))
               FROM coach AS d
               WHERE d.train_id = @train_id
                 AND d.train_name = @train_name
              )
    )
    RETURN @id
END