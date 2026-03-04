--SQLQuery3-GET_NEW_YEAR_HOLIDAYS_START_DATE.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER FUNCTION GetNewYearHolidaysStartDay(@year AS SMALLINT) RETURNS DATE
AS
BEGIN
	DECLARE @new_year_date AS DATE    = DATEFROMPARTS(@year, 01, 01);
	DECLARE @weekday       AS TINYINT = DATEPART(WEEKDAY, @new_year_date);
	DECLARE @start_date    AS DATE    = DATEADD(DAY, 1 - @weekday, @new_year_date);
	IF @weekday = 7 SET @start_date   = DATEADD(DAY, -1, @new_year_date);
	RETURN @start_date;
END