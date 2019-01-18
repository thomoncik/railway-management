-- Generated by Oracle SQL Developer Data Modeler 18.3.0.268.1156
--   at:        2019-01-18 18:14:21 CET
--   site:      SQL Server 2012
--   type:      SQL Server 2012



CREATE TABLE carrier
    (
    id     INTEGER NOT NULL,
    name   nvarchar (256) NOT NULL ) go

ALTER TABLE carrier ADD constraint carrier_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE city
    (
    id     INTEGER NOT NULL,
    name   nvarchar (256) NOT NULL ) go

ALTER TABLE city ADD constraint city_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE coach
    ( id VARCHAR(16) NOT NULL,
     number INTEGER NOT NULL ,
     class INTEGER ,
     capacity INTEGER ,
     has_compartments BIT ,
     has_ac BIT ,
     has_230v_plug BIT ,
     bicycle_seats INTEGER ,
     places_with_wheelchair_support INTEGER ,
     train_id VARCHAR (16) NOT NULL ,
     train_name VARCHAR (256) NOT NULL ,
     type_id INTEGER NOT NULL ,
     coach_type_id INTEGER NOT NULL
    )
GO




CREATE unique nonclustered index coach__idx ON coach ( coach_type_id ) go

ALTER TABLE coach ADD constraint coach_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE coach_type
    (
    id     INTEGER NOT NULL,
    type   nvarchar (256) NOT NULL ) go

ALTER TABLE coach_type ADD constraint coach_type_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE discount
    (
    id     INTEGER NOT NULL,
    name   nvarchar (256) NOT NULL ,
     description NVARCHAR (256) ,
     value INTEGER NOT NULL ) go

ALTER TABLE discount ADD constraint discount_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE employee (
    id           INTEGER NOT NULL,
    roles_id     INTEGER NOT NULL,
    person_id    INTEGER NOT NULL,
    boss_id      INTEGER NOT NULL,
    train_id     VARCHAR(16) NOT NULL,
    train_name   VARCHAR(256) NOT NULL
)

go




CREATE UNIQUE NONCLUSTERED INDEX
    employee__IDX ON employee
    (
     boss_id
    )
GO


CREATE UNIQUE NONCLUSTERED INDEX
    employee__IDXv1 ON employee
    (
     person_id
    )
GO


CREATE unique nonclustered index employee__idxv2 ON employee ( roles_id ) go

ALTER TABLE employee ADD constraint employee_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE permission
    (
    id     INTEGER NOT NULL,
    name   nvarchar (256) NOT NULL ) go

ALTER TABLE permission ADD constraint permission_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE person
    (
    id           INTEGER NOT NULL,
    first_name   nvarchar (256) NOT NULL ,
     last_name NVARCHAR (256) ,
     PESEL NVARCHAR (256) ,
     address NVARCHAR (256) ,
     postal_code NVARCHAR (256) ,
     region NVARCHAR (256) ,
     city NVARCHAR (256) ,
     country NVARCHAR (256) ,
     birth_date DATETIME ,
     title_of_courtesy NVARCHAR (256) , email nvarchar(256) )
GO

ALTER TABLE person ADD constraint person_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE platform
    ( id nvarchar (256) NOT NULL ,
     station_id INTEGER NOT NULL ) go

ALTER TABLE platform ADD constraint platform_pk PRIMARY KEY CLUSTERED (id, station_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE role_permission (
    roles_id        INTEGER NOT NULL,
    permission_id   INTEGER NOT NULL
)

go

ALTER TABLE role_permission ADD constraint role_permission_pk PRIMARY KEY CLUSTERED (roles_id, permission_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE roles
    (
    id     INTEGER NOT NULL,
    name   nvarchar (256) NOT NULL ) go

ALTER TABLE roles ADD constraint roles_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE seat (
    id                INTEGER NOT NULL,
    placement         CHAR(1),
    coach_id          VARCHAR(16) NOT NULL,
    is_couchette      bit NOT NULL,
    is_beside_table   bit NOT NULL,
    reserved_from     datetime,
    reserved_to       datetime
)

go

ALTER TABLE seat ADD constraint seat_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE station
    (
    id     INTEGER NOT NULL,
    name   nvarchar (256) NOT NULL ,
     city_id INTEGER NOT NULL ) go

ALTER TABLE station ADD constraint station_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE ticket (
    id                     INTEGER NOT NULL,
    departure              datetime NOT NULL,
    seat_id                INTEGER NOT NULL,
    departure_station_id   INTEGER NOT NULL,
    arrival_station_id     INTEGER NOT NULL,
    discount_id            INTEGER NOT NULL
)

go




CREATE UNIQUE NONCLUSTERED INDEX
    ticket__IDX ON ticket
    (
     discount_id
    )
GO


CREATE UNIQUE NONCLUSTERED INDEX
    ticket__IDXv1 ON ticket
    (
     seat_id
    )
GO


CREATE UNIQUE NONCLUSTERED INDEX
    ticket__IDXv2 ON ticket
    (
     arrival_station_id
    )
GO


CREATE unique nonclustered index ticket__idxv3 ON ticket ( departure_station_id ) go

ALTER TABLE ticket ADD constraint ticket_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE track
    ( id nvarchar (256) NOT NULL ,
     platform_id NVARCHAR (256) NOT NULL ,
     station_id INTEGER NOT NULL ) go

ALTER TABLE track ADD constraint track_pk PRIMARY KEY CLUSTERED (id, platform_id, station_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE train (
    id           VARCHAR(16) NOT NULL,
    name         VARCHAR(256) NOT NULL,
    carrier_id   INTEGER NOT NULL
)

go




CREATE unique nonclustered index train__idx ON train ( carrier_id ) go

ALTER TABLE train ADD constraint train_pk PRIMARY KEY CLUSTERED (id, name)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE train_station (
    train_id         VARCHAR(16) NOT NULL,
    train_name       VARCHAR(256) NOT NULL,
    station_id       INTEGER NOT NULL,
    arrival_time     datetime NOT NULL,
    departure_time   datetime NOT NULL,
    day              VARCHAR(32) NOT NULL
)

go


ALTER TABLE train_station add check(day IN(
    'Friday', 'Monday', 'Saturday', 'Sunday', 'Thursday', 'Tuesday', 'Wednesday'
)) go

ALTER TABLE train_station ADD constraint train_station_pk PRIMARY KEY CLUSTERED (train_id, train_name, station_id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

CREATE TABLE "user"
    (
    id          INTEGER NOT NULL,
    person_id   INTEGER NOT NULL,
    login       nvarchar (256) NOT NULL ,
     encrypted_password NVARCHAR (256) NOT NULL ,
     reset_password_token NVARCHAR (256) ,
     reset_password_sent_at DATETIME ,
     remeber_created_at DATETIME ,
     created_at DATETIME NOT NULL ,
     updated_at DATETIME NOT NULL
    )
GO




CREATE unique nonclustered index user__idx ON "user" ( person_id ) go

ALTER TABLE "user" ADD constraint user_pk PRIMARY KEY CLUSTERED (id)
     WITH (
     ALLOW_PAGE_LOCKS = ON ,
     ALLOW_ROW_LOCKS = ON ) go

ALTER TABLE coach
    ADD CONSTRAINT coach_coach_type_fk FOREIGN KEY ( coach_type_id )
        REFERENCES coach_type ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE coach
    ADD CONSTRAINT coach_train_fk FOREIGN KEY ( train_id,
                                                train_name )
        REFERENCES train ( id,
                           name )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE employee
    ADD CONSTRAINT employee_employee_fk FOREIGN KEY ( boss_id )
        REFERENCES employee ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE employee
    ADD CONSTRAINT employee_person_fk FOREIGN KEY ( person_id )
        REFERENCES person ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE employee
    ADD CONSTRAINT employee_roles_fk FOREIGN KEY ( roles_id )
        REFERENCES roles ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE employee
    ADD CONSTRAINT employee_train_fk FOREIGN KEY ( train_id,
                                                   train_name )
        REFERENCES train ( id,
                           name )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE platform
    ADD CONSTRAINT platform_station_fk FOREIGN KEY ( station_id )
        REFERENCES station ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE role_permission
    ADD CONSTRAINT role_permission_permission_fk FOREIGN KEY ( permission_id )
        REFERENCES permission ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE role_permission
    ADD CONSTRAINT role_permission_roles_fk FOREIGN KEY ( roles_id )
        REFERENCES roles ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE seat
    ADD CONSTRAINT seat_coach_fk FOREIGN KEY ( coach_id )
        REFERENCES coach ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE station
    ADD CONSTRAINT station_city_fk FOREIGN KEY ( city_id )
        REFERENCES city ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE ticket
    ADD CONSTRAINT ticket_discount_fk FOREIGN KEY ( discount_id )
        REFERENCES discount ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE ticket
    ADD CONSTRAINT ticket_seat_fk FOREIGN KEY ( seat_id )
        REFERENCES seat ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE ticket
    ADD CONSTRAINT ticket_station_fk FOREIGN KEY ( arrival_station_id )
        REFERENCES station ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE ticket
    ADD CONSTRAINT ticket_station_fkv2 FOREIGN KEY ( departure_station_id )
        REFERENCES station ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE track
    ADD CONSTRAINT track_platform_fk FOREIGN KEY ( platform_id,
                                                   station_id )
        REFERENCES platform ( id,
                              station_id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE train
    ADD CONSTRAINT train_carrier_fk FOREIGN KEY ( carrier_id )
        REFERENCES carrier ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE train_station
    ADD CONSTRAINT train_station_station_fk FOREIGN KEY ( station_id )
        REFERENCES station ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE train_station
    ADD CONSTRAINT train_station_train_fk FOREIGN KEY ( train_id,
                                                        train_name )
        REFERENCES train ( id,
                           name )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE "user"
    ADD CONSTRAINT user_person_fk FOREIGN KEY ( person_id )
        REFERENCES person ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

CREATE VIEW timetable  AS
SELECT
    city.id,
    city.name,
    station.id     AS station_id,
    station.name   AS station_name,
    train.id       AS train_id,
    train.name     AS train_name,
    carrier.id     AS carrier_id,
    carrier.name   AS carrier_name,
    train_station.departure_time,
    train_station.arrival_time,
    platform.id    AS platform,
    track.id       AS track
FROM
    train
    INNER JOIN train_station ON train.id = train_station.train_id
                                AND train.name = train_station.train_name
    INNER JOIN station ON station.id = train_station.station_id
    INNER JOIN city ON city.id = station.city_id
    INNER JOIN carrier ON carrier.id = train.carrier_id
    INNER JOIN platform ON station.id = platform.station_id
    INNER JOIN track ON platform.id = track.platform_id
GO

ALTER TABLE coach
    ADD CONSTRAINT coach_coach_type_fk FOREIGN KEY ( coach_type_id )
        REFERENCES coach_type ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE coach
    ADD CONSTRAINT coach_train_fk FOREIGN KEY ( train_id,
                                                train_name )
        REFERENCES train ( id,
                           name )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE employee
    ADD CONSTRAINT employee_employee_fk FOREIGN KEY ( boss_id )
        REFERENCES employee ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE employee
    ADD CONSTRAINT employee_person_fk FOREIGN KEY ( person_id )
        REFERENCES person ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE employee
    ADD CONSTRAINT employee_roles_fk FOREIGN KEY ( roles_id )
        REFERENCES roles ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE employee
    ADD CONSTRAINT employee_train_fk FOREIGN KEY ( train_id,
                                                   train_name )
        REFERENCES train ( id,
                           name )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE platform
    ADD CONSTRAINT platform_station_fk FOREIGN KEY ( station_id )
        REFERENCES station ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE role_permission
    ADD CONSTRAINT role_permission_permission_fk FOREIGN KEY ( permission_id )
        REFERENCES permission ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE role_permission
    ADD CONSTRAINT role_permission_roles_fk FOREIGN KEY ( roles_id )
        REFERENCES roles ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE seat
    ADD CONSTRAINT seat_coach_fk FOREIGN KEY ( coach_id )
        REFERENCES coach ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE station
    ADD CONSTRAINT station_city_fk FOREIGN KEY ( city_id )
        REFERENCES city ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE ticket
    ADD CONSTRAINT ticket_discount_fk FOREIGN KEY ( discount_id )
        REFERENCES discount ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE ticket
    ADD CONSTRAINT ticket_seat_fk FOREIGN KEY ( seat_id )
        REFERENCES seat ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE ticket
    ADD CONSTRAINT ticket_station_fk FOREIGN KEY ( arrival_station_id )
        REFERENCES station ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE ticket
    ADD CONSTRAINT ticket_station_fkv2 FOREIGN KEY ( departure_station_id )
        REFERENCES station ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE track
    ADD CONSTRAINT track_platform_fk FOREIGN KEY ( platform_id,
                                                   station_id )
        REFERENCES platform ( id,
                              station_id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE train
    ADD CONSTRAINT train_carrier_fk FOREIGN KEY ( carrier_id )
        REFERENCES carrier ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE train_station
    ADD CONSTRAINT train_station_station_fk FOREIGN KEY ( station_id )
        REFERENCES station ( id )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE train_station
    ADD CONSTRAINT train_station_train_fk FOREIGN KEY ( train_id,
                                                        train_name )
        REFERENCES train ( id,
                           name )
ON DELETE NO ACTION
    ON UPDATE no action go

ALTER TABLE "user"
    ADD CONSTRAINT user_person_fk FOREIGN KEY ( person_id )
        REFERENCES person ( id )
ON DELETE NO ACTION
    ON UPDATE no action go



-- Oracle SQL Developer Data Modeler Summary Report:
--
-- CREATE TABLE                            18
-- CREATE INDEX                            10
-- ALTER TABLE                             59
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
