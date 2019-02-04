IF OBJECT_ID('users_tickets') IS NOT NULL DROP FUNCTION users_tickets
GO

CREATE FUNCTION users_tickets(@user_id INT)
  RETURNS @Tickets TABLE
                   (
                     user_id           INT           NOT NULL,
                     first_name        NVARCHAR(256) NOT NULL,
                     last_name         NVARCHAR(256) NOT NULL,
                     ticket_id         INT           NOT NULL,
                     departure_time    DATE          NOT NULL,
                     seat_id           INT           NOT NULL,
                     departure_station INT           NOT NULL,
                     arrival_station   INT           NOT NULL,
                     seat_coach_id     NVARCHAR(16)  NOT NULL
                   )
AS
BEGIN
    INSERT INTO @Tickets
    SELECT U.id, P.first_name, P.last_name, T.id, T.departure, T.seat_id, T.station_id, T.station_id2, T.seat_coach_id
    FROM [dbo].[user] U
    JOIN person P ON U.person_id = P.id
    JOIN user_ticket UT ON U.id = UT.user_id
    JOIN ticket T ON UT.ticket_id = T.id
    RETURN
END