--SQLQuery4-GET_SUMMER_HOLIDAYS_START_DATE.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION GetSummerHolidaysStartDay(@year AS SMALLINT) RETURNS DATE
AS
BEGIN
	DECLARE @date       AS DATE    = DATEFROMPARTS(@year, 08, 01);
	DECLARE @weekday    AS TINYINT = DATEPART(WEEKDAY, @date);
	DECLARE @start_date AS DATE    = DATEADD(DAY, 1 - @weekday, @date);
	IF @weekday = 7 SET @start_date   = DATEADD(DAY, -1, @date);
	RETURN @start_date;
END