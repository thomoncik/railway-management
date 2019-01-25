IF OBJECT_ID('sp_BackupDatabases') IS NOT NULL DROP PROC sp_BackupDatabases

USE [master]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_BackupDatabases] @databasename SYSNAME = NULL,
                                            @backuptype CHAR(1),
                                            @backuplocation NVARCHAR(200)
AS
SET NOCOUNT ON;
DECLARE @dbs TABLE
             (
                 id     INT IDENTITY PRIMARY KEY,
                 dbname NVARCHAR(500)
             )

INSERT INTO @dbs (dbname)
SELECT name
FROM master.sys.databases
WHERE state = 0 AND name = @databasename
   OR @databasename IS NULL
ORDER BY name

    -- Declare variables
DECLARE @backupname VARCHAR(100)
DECLARE @backupfile VARCHAR(100)
DECLARE @dbname VARCHAR(300)
DECLARE @sqlcommand NVARCHAR(1000)
DECLARE @datetime NVARCHAR(20)

    -- Database Names have to be in [dbname] format since some have - or _ in their name
SET @dbname = '[' + @databasename + ']'

    -- Set the current date and time n yyyyhhmmss format
SET @datetime =
        REPLACE(CONVERT(VARCHAR, GETDATE(), 101), '/', '') + '_' + REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', '')

    -- Create backup filename in pathfilename.extension format for full,diff and log backups
SET @backupfile = @backuplocation + REPLACE(REPLACE(@dbname, '[', ''), ']', '') + '_FULL_' + @datetime + '.BAK'

    -- Provide the backup a name for storing in the media
SET @backupname = REPLACE(REPLACE(@dbname, '[', ''), ']', '') + ' full backup for ' + @datetime

    -- Generate the dynamic SQL command to be executed
SET @sqlcommand =
        'BACKUP DATABASE ' + @dbname + ' TO DISK = ''' + @backupfile + ''' WITH INIT, NAME= ''' + @backupname +
        ''', NOSKIP, NOFORMAT'

    -- Execute the generated SQL command
EXEC (@sqlcommand)

-- EXEC sp_BackupDatabases @backupLocation='C:\RailwayBackup\', @databaseName='RAILWAY', @backupType='F'
