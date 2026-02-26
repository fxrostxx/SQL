--SQLQuery1-SP_INSERT_SCHEDULE.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

ALTER PROCEDURE SP_InsertScheduleFullTime
	@group_name         AS NCHAR(10),
	@discipline_name    AS NVARCHAR(150),
	@teacher_first_name AS NVARCHAR(50),
	@start_date         AS DATE
AS
BEGIN
	DECLARE @group             AS INT      = (SELECT group_id          FROM Groups      WHERE group_name      LIKE @group_name);
	DECLARE @number_of_lessons AS TINYINT  = (SELECT number_of_lessons FROM Disciplines WHERE discipline_name LIKE @discipline_name);
	DECLARE @lesson_number     AS TINYINT  = 0;
	DECLARE @date              AS DATE     = @start_date;
	DECLARE @start_time        AS TIME     = (SELECT start_time        FROM Groups      WHERE group_id        =    @group);

	PRINT(@group);
	PRINT(@number_of_lessons);
	PRINT(@start_date);
	PRINT(@start_time);
	
	DECLARE @time AS TIME = @start_time;
	
	WHILE @lesson_number < @number_of_lessons
	BEGIN
	    SET @time = @start_time;
		PRINT(FORMATMESSAGE(N'%i %s %s %s', @lesson_number, CAST(@date AS VARCHAR(24)), DATENAME(WEEKDAY, @date), CAST(@time AS VARCHAR(24))));
		EXEC SP_InsertLesson @group_name, @discipline_name, @teacher_first_name, @date, @time;
		SET @lesson_number = @lesson_number + 1;
		SET @time = DATEADD(MINUTE, 95, @start_time);
	
		PRINT(FORMATMESSAGE(N'%i %s %s %s', @lesson_number, CAST(@date AS VARCHAR(24)), DATENAME(WEEKDAY, @date), CAST(@time AS VARCHAR(24))));
		EXEC SP_InsertLesson @group_name, @discipline_name, @teacher_first_name, @date, @time;
		SET @lesson_number = @lesson_number + 1;
	
		DECLARE @day AS TINYINT = DATEPART(WEEKDAY, @date);
		PRINT(@day);
		SET @date = DATEADD(DAY, IIF(@day = 5, 3, 2), @date);
	END

END