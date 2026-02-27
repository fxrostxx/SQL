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
	DECLARE @discipline        AS SMALLINT = (SELECT discipline_id     FROM Disciplines WHERE discipline_name LIKE @discipline_name);
	DECLARE @teacher           AS SMALLINT = (SELECT teacher_id        FROM Teachers    WHERE first_name      LIKE @teacher_first_name);
	DECLARE @number_of_lessons AS TINYINT  = (SELECT number_of_lessons FROM Disciplines WHERE discipline_name LIKE @discipline_name);
	DECLARE @lesson_number     AS TINYINT  = dbo.CountLessons(@group, @discipline);
	DECLARE @date              AS DATE     = @start_date;
	DECLARE @start_time        AS TIME     = (SELECT start_time        FROM Groups      WHERE group_id        =    @group);

	PRINT(@group);
	PRINT(@discipline);
	PRINT(@teacher);
	PRINT(@number_of_lessons);
	PRINT(@start_date);
	PRINT(@start_time);
	
	DECLARE @time AS TIME = @start_time;
	
	WHILE @lesson_number < @number_of_lessons
	BEGIN
	    SET @time = @start_time;

		EXEC SP_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lesson_number OUTPUT;
		EXEC SP_InsertLesson @group, @discipline, @teacher, @date, @time OUTPUT, @lesson_number OUTPUT;

		DECLARE @day AS TINYINT = DATEPART(WEEKDAY, @date);
		PRINT(@day);
		SET @date = DATEADD(DAY, IIF(@day = 5, 3, 2), @date);
	END
END