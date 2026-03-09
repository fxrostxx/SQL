--SQLQuery3-CHECK.sql

USE PV_521_Import;
SET DATEFIRST 1;

--DELETE FROM Schedule WHERE [group] = 521 AND [date] >= N'2026-03-18'
--DELETE FROM Schedule WHERE discipline = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE N'Сетевое%');

EXEC SP_InsertScheduleFullTime N'PV_521', N'%MS SQL Server', N'Олег', N'2025-12-24';
EXEC SP_InsertScheduleFullTime N'PV_521', N'%ADO.NET%', N'Олег', N'2026-02-04';
EXEC SP_InsertScheduleFullTime N'PV_521', N'Сетевое%', N'Олег', N'2026-03-09';
EXEC SP_InsertScheduleFullTime N'PV_521', N'Системное%', N'Олег', DEFAULT;
EXEC SP_InsertScheduleFullTime N'PV_521', N'HTML/CSS', N'Олег', DEFAULT;
EXEC SP_InsertScheduleFullTime N'PV_521', N'JavaScript', N'Олег', DEFAULT;
EXEC SP_InsertScheduleFullTime N'PV_521', N'ReactJS', N'Олег', DEFAULT;
EXEC SP_InsertScheduleFullTime N'PV_521', N'%ASP.NET', N'Олег', DEFAULT;
EXEC SP_SelectScheduleFor N'PV_521';

--EXEC SP_InsertAllHolidaysFor 2027;

SELECT
	[Дата]     = date,
	[Праздник] = holiday_name
FROM DaysOFF, Holidays
WHERE holiday = holiday_id AND date >= DATEFROMPARTS(2026, 12, 20);