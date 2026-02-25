--SQLQuery3-CHECK.sql

USE PV_521_Import;
SET DATEFIRST 1;

--DELETE FROM Schedule WHERE discipline = (SELECT discipline_id FROM Disciplines WHERE discipline_name LIKE N'%ADO.NET%')

EXEC SP_InsertScheduleFullTime N'PV_521', N'%ADO.NET%', N'Олег', N'2026-01-21';
EXEC SP_SelectScheduleFor N'PV_521';