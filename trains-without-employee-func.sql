IF OBJECT_ID('trains_without_employee', 'FN') IS NOT NULL DROP FUNCTION trains_without_employee
GO

CREATE FUNCTION trains_without_employee()
  RETURNS TABLE
    AS
    RETURN
          (
            SELECT *
            FROM train T
            WHERE NOT EXISTS(SELECT E.* FROM employee E WHERE E.train_name = T.name AND E.train_id = T.id)
          )
GO