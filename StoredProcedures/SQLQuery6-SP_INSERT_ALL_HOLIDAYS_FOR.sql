--SQLQuery6-SP_INSERT_ALL_HOLIDAYS_FOR.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER PROCEDURE SP_InsertAllHolidaysFor @year AS SMALLINT
AS
BEGIN
	EXEC SP_InsertHolidaysFor @year, N'Нов%';
	EXEC SP_InsertHolidaysFor @year, N'23%';
	EXEC SP_InsertHolidaysFor @year, N'8%';
	EXEC SP_InsertHolidaysFor @year, N'Пасха';
	EXEC SP_InsertHolidaysFor @year, N'Май%';
	EXEC SP_InsertHolidaysFor @year, N'Летние каникулы';
	EXEC SP_InsertHolidaysFor @year, N'День%';
END