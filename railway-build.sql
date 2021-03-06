-- Generated by Oracle SQL Developer Data Modeler 18.3.0.268.1156
--   at:        2019-02-04 23:49:02 CET
--   site:      SQL Server 2012
--   type:      SQL Server 2012


CREATE TABLE carrier
(
    id           INTEGER       NOT NULL,
    name         NVARCHAR(256) NOT NULL,
    ticket_price MONEY         NOT NULL
)
GO

ALTER TABLE carrier
    ADD CONSTRAINT carrier_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE city
(
    id   INTEGER       NOT NULL,
    name NVARCHAR(256) NOT NULL
)
GO

ALTER TABLE city
    ADD CONSTRAINT city_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE coach
(
    id                             VARCHAR(16)  NOT NULL,
    number                         INTEGER      NOT NULL,
    class                          INTEGER,
    capacity                       INTEGER      NOT NULL,
    has_ac                         BIT,
    has_230v_plug                  BIT,
    bicycle_seats                  INTEGER      NOT NULL,
    places_with_wheelchair_support INTEGER      NOT NULL,
    places_beside_table            INTEGER      NOT NULL,
    train_id                       VARCHAR(16)  NOT NULL,
    train_name                     VARCHAR(256) NOT NULL,
    coach_type_id                  INTEGER      NOT NULL
)
GO



CREATE UNIQUE NONCLUSTERED INDEX coach__idx ON coach (coach_type_id)
GO

ALTER TABLE coach
    ADD CONSTRAINT coach_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE coach_type
(
    id   INTEGER       NOT NULL,
    type NVARCHAR(256) NOT NULL
)
GO

ALTER TABLE coach_type
    ADD CONSTRAINT coach_type_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE discount
(
    id          INTEGER       NOT NULL,
    name        NVARCHAR(256) NOT NULL,
    description NVARCHAR(256),
    value       INTEGER       NOT NULL
)
GO

ALTER TABLE discount
    ADD CONSTRAINT discount_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE employee
(
    id          INTEGER NOT NULL,
    roles_id    INTEGER NOT NULL,
    person_id   INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    train_id    VARCHAR(16),
    train_name  VARCHAR(256)
)

GO



CREATE UNIQUE NONCLUSTERED INDEX
    employee__idx ON employee
    (
     employee_id
        )
GO


CREATE UNIQUE NONCLUSTERED INDEX
    employee__idxv1 ON employee
    (
     person_id
        )
GO


CREATE UNIQUE NONCLUSTERED INDEX employee__idxv2 ON employee (roles_id)
GO

ALTER TABLE employee
    ADD CONSTRAINT employee_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE permission
(
    id   INTEGER       NOT NULL,
    name NVARCHAR(256) NOT NULL
)
GO

ALTER TABLE permission
    ADD CONSTRAINT permission_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE person
(
    id                INTEGER       NOT NULL,
    first_name        NVARCHAR(256) NOT NULL,
    last_name         NVARCHAR(256),
    sex               CHAR,
    pesel             NVARCHAR(11),
    address           NVARCHAR(256),
    postal_code       NVARCHAR(256),
    region            NVARCHAR(256),
    city              NVARCHAR(256),
    country           NVARCHAR(256),
    birth_date        DATETIME,
    title_of_courtesy NVARCHAR(256),
    email             NVARCHAR(256)
)
GO


ALTER TABLE person
    ADD CHECK (sex IN (
                       'F', 'M'
        ))
GO

ALTER TABLE person
    ADD CONSTRAINT person_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE platform
(
    id         INTEGER NOT NULL,
    station_id INTEGER NOT NULL
)

GO

ALTER TABLE platform
    ADD CONSTRAINT platform_pk PRIMARY KEY CLUSTERED (id, station_id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE role_permission
(
    roles_id      INTEGER NOT NULL,
    permission_id INTEGER NOT NULL
)

GO

ALTER TABLE role_permission
    ADD CONSTRAINT role_permission_pk PRIMARY KEY CLUSTERED (roles_id, permission_id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE roles
(
    id   INTEGER       NOT NULL,
    name NVARCHAR(256) NOT NULL
)
GO

ALTER TABLE roles
    ADD CONSTRAINT roles_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE seat
(
    id              INTEGER     NOT NULL,
    coach_id        VARCHAR(16) NOT NULL,
    placement       CHAR(1)     NOT NULL,
    is_beside_table BIT         NOT NULL
)

GO

ALTER TABLE seat
    ADD CONSTRAINT seat_pk PRIMARY KEY CLUSTERED (id, coach_id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE station
(
    id      INTEGER       NOT NULL,
    name    NVARCHAR(256) NOT NULL,
    city_id INTEGER       NOT NULL
)
GO

ALTER TABLE station
    ADD CONSTRAINT station_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE ticket
(
    id            INTEGER     NOT NULL,
    departure     DATETIME    NOT NULL,
    seat_id       INTEGER     NOT NULL,
    station_id    INTEGER     NOT NULL,
    station_id2   INTEGER     NOT NULL,
    discount_id   INTEGER     NOT NULL,
    seat_coach_id VARCHAR(16) NOT NULL
)

GO



CREATE UNIQUE NONCLUSTERED INDEX
    ticket__idx ON ticket
    (
     station_id2
        )
GO


CREATE UNIQUE NONCLUSTERED INDEX
    ticket__idxv1 ON ticket
    (
     station_id
        )
GO


CREATE UNIQUE NONCLUSTERED INDEX
    ticket__idxv2 ON ticket
    (
     discount_id
        )
GO


CREATE UNIQUE NONCLUSTERED INDEX ticket__idxv3 ON ticket (seat_id, seat_coach_id)
GO

ALTER TABLE ticket
    ADD CONSTRAINT ticket_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE track
(
    id                  INTEGER NOT NULL,
    platform_id         INTEGER NOT NULL,
    platform_station_id INTEGER NOT NULL
)

GO

ALTER TABLE track
    ADD CONSTRAINT track_pk PRIMARY KEY CLUSTERED (id, platform_id, platform_station_id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE train
(
    id         VARCHAR(16)  NOT NULL,
    name       VARCHAR(256) NOT NULL,
    carrier_id INTEGER      NOT NULL
)

GO

ALTER TABLE train
    ADD CONSTRAINT train_pk PRIMARY KEY CLUSTERED (id, name)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE train_station
(
    train_id                  VARCHAR(16)  NOT NULL,
    train_name                VARCHAR(256) NOT NULL,
    station_id                INTEGER      NOT NULL,
    arrival_time              DATETIME     NOT NULL,
    departure_time            DATETIME     NOT NULL,
    day                       VARCHAR(32)  NOT NULL,
    track_id                  INTEGER      NOT NULL,
    track_platform_id         INTEGER      NOT NULL,
    track_platform_station_id INTEGER      NOT NULL
)

GO


ALTER TABLE train_station
    ADD CHECK (day IN (
                       'Friday', 'Monday', 'Saturday', 'Sunday', 'Thursday', 'Tuesday', 'Wednesday'
        ))
GO

ALTER TABLE train_station
    ADD CONSTRAINT train_station_pk PRIMARY KEY CLUSTERED (train_id, train_name, station_id, arrival_time, departure_time, day)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE "user"
(
    id                     INTEGER       NOT NULL,
    person_id              INTEGER       NOT NULL,
    login                  NVARCHAR(256) NOT NULL,
    encrypted_password     NVARCHAR(256) NOT NULL,
    reset_password_token   NVARCHAR(256),
    reset_password_sent_at DATETIME,
    remember_created_at    DATETIME,
    created_at             DATETIME      NOT NULL,
    updated_at             DATETIME      NOT NULL
)
GO



CREATE UNIQUE NONCLUSTERED INDEX user__idx ON "user" (person_id)
GO

ALTER TABLE "user"
    ADD CONSTRAINT user_pk PRIMARY KEY CLUSTERED (id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE user_ticket
(
    ticket_id INTEGER NOT NULL,
    user_id   INTEGER NOT NULL
)

GO

ALTER TABLE user_ticket
    ADD CONSTRAINT user_ticket_pk PRIMARY KEY CLUSTERED (ticket_id, user_id)
        WITH (
            ALLOW_PAGE_LOCKS = ON ,
            ALLOW_ROW_LOCKS = ON )
GO

ALTER TABLE coach
    ADD CONSTRAINT coach_coach_type_fk FOREIGN KEY (coach_type_id)
        REFERENCES coach_type (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE coach
    ADD CONSTRAINT coach_train_fk FOREIGN KEY (train_id,
                                               train_name)
        REFERENCES train (id,
                          name)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE employee
    ADD CONSTRAINT employee_employee_fk FOREIGN KEY (employee_id)
        REFERENCES employee (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE employee
    ADD CONSTRAINT employee_person_fk FOREIGN KEY (person_id)
        REFERENCES person (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE employee
    ADD CONSTRAINT employee_roles_fk FOREIGN KEY (roles_id)
        REFERENCES roles (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE employee
    ADD CONSTRAINT employee_train_fk FOREIGN KEY (train_id,
                                                  train_name)
        REFERENCES train (id,
                          name)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE platform
    ADD CONSTRAINT platform_station_fk FOREIGN KEY (station_id)
        REFERENCES station (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE role_permission
    ADD CONSTRAINT role_permission_permission_fk FOREIGN KEY (permission_id)
        REFERENCES permission (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE role_permission
    ADD CONSTRAINT role_permission_roles_fk FOREIGN KEY (roles_id)
        REFERENCES roles (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE seat
    ADD CONSTRAINT seat_coach_fk FOREIGN KEY (coach_id)
        REFERENCES coach (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE station
    ADD CONSTRAINT station_city_fk FOREIGN KEY (city_id)
        REFERENCES city (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE ticket
    ADD CONSTRAINT ticket_discount_fk FOREIGN KEY (discount_id)
        REFERENCES discount (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE ticket
    ADD CONSTRAINT ticket_seat_fk FOREIGN KEY (seat_id,
                                               seat_coach_id)
        REFERENCES seat (id,
                         coach_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE ticket
    ADD CONSTRAINT ticket_station_fk FOREIGN KEY (station_id2)
        REFERENCES station (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE ticket
    ADD CONSTRAINT ticket_station_fkv1 FOREIGN KEY (station_id)
        REFERENCES station (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE track
    ADD CONSTRAINT track_platform_fk FOREIGN KEY (platform_id,
                                                  platform_station_id)
        REFERENCES platform (id,
                             station_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE train
    ADD CONSTRAINT train_carrier_fk FOREIGN KEY (carrier_id)
        REFERENCES carrier (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE train_station
    ADD CONSTRAINT train_station_station_fk FOREIGN KEY (station_id)
        REFERENCES station (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE train_station
    ADD CONSTRAINT train_station_track_fk FOREIGN KEY (track_id,
                                                       track_platform_id,
                                                       track_platform_station_id)
        REFERENCES track (id,
                          platform_id,
                          platform_station_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE train_station
    ADD CONSTRAINT train_station_train_fk FOREIGN KEY (train_id,
                                                       train_name)
        REFERENCES train (id,
                          name)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE "user"
    ADD CONSTRAINT user_person_fk FOREIGN KEY (person_id)
        REFERENCES person (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE user_ticket
    ADD CONSTRAINT user_ticket_ticket_fk FOREIGN KEY (ticket_id)
        REFERENCES ticket (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE user_ticket
    ADD CONSTRAINT user_ticket_user_fk FOREIGN KEY (user_id)
        REFERENCES "user"
            (
             id
                )
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

CREATE VIEW timetable AS
SELECT city.id                                 AS city_id,
       city.name                               AS city_name,
       train_station.track_platform_station_id AS station_id,
       station.name                            AS station_name,
       train_station.train_id                  AS train_id,
       train_station.train_name                AS train_name,
       carrier.id                              AS carrier_id,
       carrier.name                            AS carrier_name,
       train_station.arrival_time,
       train_station.departure_time,
       train_station.day,
       train_station.track_platform_id         AS platform_id,
       train_station.track_id                  AS track_id
FROM train
         INNER JOIN train_station ON train.id = train_station.train_id
    AND train.name = train_station.train_name
         INNER JOIN carrier ON carrier.id = train.carrier_id
         INNER JOIN station ON station.id = train_station.station_id
         INNER JOIN city ON city.id = station.city_id
GO

ALTER TABLE coach
    ADD CONSTRAINT coach_coach_type_fk FOREIGN KEY (coach_type_id)
        REFERENCES coach_type (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE coach
    ADD CONSTRAINT coach_train_fk FOREIGN KEY (train_id,
                                               train_name)
        REFERENCES train (id,
                          name)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE employee
    ADD CONSTRAINT employee_employee_fk FOREIGN KEY (employee_id)
        REFERENCES employee (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE employee
    ADD CONSTRAINT employee_person_fk FOREIGN KEY (person_id)
        REFERENCES person (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE employee
    ADD CONSTRAINT employee_roles_fk FOREIGN KEY (roles_id)
        REFERENCES roles (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE employee
    ADD CONSTRAINT employee_train_fk FOREIGN KEY (train_id,
                                                  train_name)
        REFERENCES train (id,
                          name)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE platform
    ADD CONSTRAINT platform_station_fk FOREIGN KEY (station_id)
        REFERENCES station (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE role_permission
    ADD CONSTRAINT role_permission_permission_fk FOREIGN KEY (permission_id)
        REFERENCES permission (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE role_permission
    ADD CONSTRAINT role_permission_roles_fk FOREIGN KEY (roles_id)
        REFERENCES roles (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE seat
    ADD CONSTRAINT seat_coach_fk FOREIGN KEY (coach_id)
        REFERENCES coach (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE station
    ADD CONSTRAINT station_city_fk FOREIGN KEY (city_id)
        REFERENCES city (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE ticket
    ADD CONSTRAINT ticket_discount_fk FOREIGN KEY (discount_id)
        REFERENCES discount (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE ticket
    ADD CONSTRAINT ticket_seat_fk FOREIGN KEY (seat_id,
                                               seat_coach_id)
        REFERENCES seat (id,
                         coach_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE ticket
    ADD CONSTRAINT ticket_station_fk FOREIGN KEY (station_id2)
        REFERENCES station (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE ticket
    ADD CONSTRAINT ticket_station_fkv1 FOREIGN KEY (station_id)
        REFERENCES station (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE track
    ADD CONSTRAINT track_platform_fk FOREIGN KEY (platform_id,
                                                  platform_station_id)
        REFERENCES platform (id,
                             station_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE train
    ADD CONSTRAINT train_carrier_fk FOREIGN KEY (carrier_id)
        REFERENCES carrier (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE train_station
    ADD CONSTRAINT train_station_station_fk FOREIGN KEY (station_id)
        REFERENCES station (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE train_station
    ADD CONSTRAINT train_station_track_fk FOREIGN KEY (track_id,
                                                       track_platform_id,
                                                       track_platform_station_id)
        REFERENCES track (id,
                          platform_id,
                          platform_station_id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE train_station
    ADD CONSTRAINT train_station_train_fk FOREIGN KEY (train_id,
                                                       train_name)
        REFERENCES train (id,
                          name)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE "user"
    ADD CONSTRAINT user_person_fk FOREIGN KEY (person_id)
        REFERENCES person (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE user_ticket
    ADD CONSTRAINT user_ticket_ticket_fk FOREIGN KEY (ticket_id)
        REFERENCES ticket (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO

ALTER TABLE user_ticket
    ADD CONSTRAINT user_ticket_user_fk FOREIGN KEY (user_id)
        REFERENCES "user" (id)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
GO


-- Oracle SQL Developer Data Modeler Summary Report:
--
-- CREATE TABLE                            19
-- CREATE INDEX                             9
-- ALTER TABLE                             67
-- CREATE VIEW                              1
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE DATABASE                          0
-- CREATE DEFAULT                           0
-- CREATE INDEX ON VIEW                     0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE ROLE                              0
-- CREATE RULE                              0
-- CREATE SCHEMA                            0
-- CREATE SEQUENCE                          0
-- CREATE PARTITION FUNCTION                0
-- CREATE PARTITION SCHEME                  0
--
-- DROP DATABASE                            0
--
-- ERRORS                                   0
-- WARNINGS                                 0
