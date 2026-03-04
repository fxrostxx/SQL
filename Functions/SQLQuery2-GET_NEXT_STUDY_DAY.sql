--SQLQuery2-GET_NEXT_STUDY_DAY.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION GetNextStudyDay(@group_name AS NCHAR(10), @last_date AS DATE = N'1900-01-01') RETURNS TINYINT
AS
BEGIN
	DECLARE @group_id AS INT     = (SELECT group_id    FROM Groups   WHERE group_name = @group_name);
	DECLARE @weekdays AS TINYINT = (SELECT weekdays    FROM Groups   WHERE group_id = @group_id);
	IF @last_date = CAST(N'1900-01-01' AS DATE) SET @last_date = (SELECT MAX([date]) FROM Schedule WHERE [group] = @group_id);
	DECLARE @last_day AS TINYINT = DATEPART(WEEKDAY, @last_date);
	DECLARE @day      AS TINYINT = @last_day + 1;
	DECLARE @counter  AS TINYINT = 0;

	WHILE @counter < 7
	BEGIN
		SET @day = @day % 7 + 1;
		IF (@weekdays & POWER(2, @day - 1) != 0) RETURN @day;
		SET @counter += 1;
	END
	RETURN NULL;
END

GO

CREATE OR ALTER FUNCTION GetNextStudyDate(@group_name AS NCHAR(10), @date AS DATE = N'1900-01-01') RETURNS DATE
AS
BEGIN
	DECLARE @group_id  AS INT        = (SELECT group_id    FROM Groups   WHERE group_name = @group_name);
	IF @date = CAST(N'1900-01-01' AS DATE) SET @date = (SELECT MAX([date]) FROM Schedule WHERE [group] = @group_id);
	DECLARE @day       AS SMALLINT   = DATEPART(WEEKDAY, @date);
	DECLARE @next_day  AS SMALLINT   = dbo.GetNextStudyDay(@group_name, @date);
	DECLARE @interval  AS SMALLINT   = @next_day - @day;
	IF @interval < 0   SET @interval = 7 + @interval;
	IF @interval = 0   SET @interval = 7;
	DECLARE @next_date AS DATE       = DATEADD(DAY, @interval, @date);
	RETURN @next_date;
END