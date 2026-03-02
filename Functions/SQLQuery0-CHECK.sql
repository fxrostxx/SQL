--SQLQuery0-CHECK.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

EXEC SP_SelectScheduleFor N'PV_521';
PRINT dbo.GetNextStudyDay(N'PV_521');