--SQLQuery2-GET_NEXT_STUDY_DAY.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION GetNextStudyDay(@group AS INT, @date AS DATE) RETURNS TINYINT
AS
BEGIN
	DECLARE @days        AS TINYINT = (SELECT weekdays FROM Groups WHERE group_id = @group);
	DECLARE @next_day    AS TINYINT = DATEPART(WEEKDAY, @date);
	DECLARE @counter     AS TINYINT = 0;

	WHILE @counter < 7
	BEGIN
		SET @next_day = @next_day % 7 + 1;
		IF (@days & LEFT_SHIFT(1, @next_day - 1) != 0) RETURN @next_day;
		SET @counter += 1;
	END
END

GO

CREATE OR ALTER FUNCTION GetNextStudyDate(@group AS INT, @date AS DATE) RETURNS DATE
AS
BEGIN
	RETURN DATEADD(DAY, GetNextStudyDay(@group, @date), @date);
END