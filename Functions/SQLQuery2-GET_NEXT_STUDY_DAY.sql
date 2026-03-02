--SQLQuery2-GET_NEXT_STUDY_DAY.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION GetNextStudyDay(@group_name AS NCHAR(10)) RETURNS TINYINT
AS
BEGIN
	DECLARE @group_id  AS INT     = (SELECT group_id    FROM Groups   WHERE group_name = @group_name);
	DECLARE @weekdays  AS TINYINT = (SELECT weekdays    FROM Groups   WHERE group_id = @group_id);
	DECLARE @last_date AS DATE    = (SELECT MAX([date]) FROM Schedule WHERE [group] = @group_id);
	DECLARE @last_day  AS TINYINT = DATEPART(WEEKDAY, @last_date);
	DECLARE @day       AS TINYINT = @last_day + 1;
	DECLARE @counter   AS TINYINT = 0;

	WHILE @counter < 7
	BEGIN
		SET @day = @day % 7 + 1;
		IF (@weekdays & POWER(2, @day - 1) != 0) RETURN @day;
		SET @counter += 1;
	END
	RETURN NULL;
END

GO

CREATE OR ALTER FUNCTION GetNextStudyDate(@group AS INT, @date AS DATE) RETURNS DATE
AS
BEGIN
	WHILE 1 = 1
	BEGIN
		SET @date = DATEADD(DAY, 1, @date);
		IF DATEPART(WEEKDAY, @date) = dbo.GetNextStudyDay(@group, @date) RETURN @date;
	END
	RETURN @date;
END