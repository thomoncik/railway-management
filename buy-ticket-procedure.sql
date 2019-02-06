IF OBJECT_ID('buy_ticket') IS NOT NULL DROP PROCEDURE buy_ticket
GO

CREATE PROCEDURE buy_ticket(@id INT,
                            @departure_time DATETIME,
                            @departure_day NVARCHAR(26),
                            @departure_station_id INT,
                            @arrival_station_id INT,
                            @discount_id INT,
                            @train_id NVARCHAR(16),
                            @train_name NVARCHAR(256),
                            @seat_placement CHAR(1))
AS
BEGIN TRY
    PRINT @departure_time
    IF NOT EXISTS(SELECT *
                  FROM timetable
                  WHERE station_id = @departure_station_id
                    AND departure_time = @departure_time
                    AND day = @departure_day
                    AND train_id = @train_id
                    AND train_name = @train_name)
        BEGIN
            RAISERROR ('No such connection available!', 16, 1)
        END

    IF NOT EXISTS(SELECT *
                  FROM timetable
                  WHERE station_id = @arrival_station_id
                    AND train_id = @train_id
                    AND train_name = @train_name)
        BEGIN
            RAISERROR ('No such connection available!', 16, 1)
        END

    IF @seat_placement NOT IN ('W', 'C')
        BEGIN
            RAISERROR ('Unrecognised seat placement %s!', 16, 1, @seat_placement)
        END

    DECLARE @selected BIT
    DECLARE @seat_id INT
    DECLARE @seat_train_id NVARCHAR(16)
    DECLARE @seat_train_name NVARCHAR(256)
    DECLARE @seat_coach_id INT
    DECLARE @seat_departure DATETIME

    IF NOT EXISTS(SELECT seat.id AS seat_id,
                         t.id    AS train_id,
                         t.name  AS train_name,
                         c.id    AS coach_id,
                         t2.departure,
                         seat.placement
                  FROM seat
                           JOIN      coach c ON seat.coach_id = c.id
                           JOIN      train t ON c.train_id = t.id AND c.train_name = t.name
                           FULL JOIN ticket t2 ON seat.id = t2.seat_id AND seat.coach_id = t2.seat_coach_id
                  WHERE seat.placement = @seat_placement)
        BEGIN
            RAISERROR ('No available seats in the preferred placement!', 16, 1)
        END


    SET @selected = 0

    DECLARE seat CURSOR FOR
        (SELECT seat.id AS seat_id,
                t.id    AS train_id,
                t.name  AS train_name,
                c.id    AS coach_id,
                t2.departure
         FROM seat
                  JOIN      coach c ON seat.coach_id = c.id
                  JOIN      train t ON c.train_id = t.id AND c.train_name = t.name
                  FULL JOIN ticket t2 ON seat.id = t2.seat_id AND seat.coach_id = t2.seat_coach_id)
    OPEN seat

    FETCH seat INTO @seat_id, @seat_train_id, @seat_train_name, @seat_coach_id, @seat_departure
    WHILE @@FETCH_STATUS = 0 AND @selected = 0
    BEGIN
        IF @seat_train_id = @train_id AND @seat_train_name = @train_name AND @seat_departure IS NULL
            BEGIN
                SET @selected = 1

                INSERT INTO ticket (id, departure, seat_id, station_id, station_id2, discount_id, seat_coach_id)
                VALUES (@id, @departure_time, @seat_train_id, @departure_station_id, @arrival_station_id, @discount_id,
                        @seat_coach_id);
            END

        IF @selected = 0
            FETCH seat INTO @seat_id, @seat_train_id, @seat_train_name, @seat_coach_id, @seat_departure
    END
    CLOSE seat
    DEALLOCATE seat

    IF @selected = 0
        RAISERROR ('No free seats available!', 16, 1)
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
