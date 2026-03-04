--SQLQuery0-CHECK.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

EXEC SP_SelectScheduleFor N'PV_521';
--PRINT dbo.GetNextStudyDay(N'PV_521', DEFAULT);
--PRINT dbo.GetNextStudyDate(N'PV_521', DEFAULT);
PRINT dbo.GetNextStudyDay(N'PV_521', N'2026-03-06');
PRINT dbo.GetNextStudyDate(N'SPU_411', N'2026-03-07');