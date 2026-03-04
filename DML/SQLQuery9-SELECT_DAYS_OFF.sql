--SQLQuery9-SELECT_DAYS_OFF.sql

USE PV_521_Import;
SET DATEFIRST 1;

SELECT
	[Дата]     = [date],
	[Праздник] = holiday_name
FROM Holidays, DaysOFF
WHERE holiday = holiday_id
ORDER BY [date];