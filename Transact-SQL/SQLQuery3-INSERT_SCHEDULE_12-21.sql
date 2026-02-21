--SQLQuery3-INSERT_SCHEDULE_12-21.sql

USE PV_521_Import;
SET DATEFIRST 1;

DECLARE @group                 AS INT      = (SELECT group_id          FROM Groups      WHERE group_name = N'PV_521');
DECLARE @discipline_cpp        AS SMALLINT = (SELECT discipline_id     FROM Disciplines WHERE discipline_name = N'Процедурное программирование на языке C++');
DECLARE @discipline_hw         AS SMALLINT = (SELECT discipline_id     FROM Disciplines WHERE discipline_name = 'Hardware-PC');
DECLARE @number_of_lessons_cpp AS TINYINT  = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_cpp);
DECLARE @number_of_lessons_hw  AS TINYINT  = (SELECT number_of_lessons FROM Disciplines WHERE discipline_id = @discipline_hw);
DECLARE @teacher_cpp           AS INT      = (SELECT teacher_id        FROM Teachers    WHERE first_name = N'Олег');
DECLARE @teacher_hw            AS INT      = (SELECT teacher_id        FROM Teachers    WHERE last_name = N'Свищев');
DECLARE @start_date            AS DATE     = N'2025-01-20';
DECLARE @start_time            AS TIME     = (SELECT start_time        FROM Groups      WHERE group_id = @group);

PRINT(@group);
PRINT(@discipline_cpp);
PRINT(@discipline_hw);
PRINT(@number_of_lessons_cpp);
PRINT(@number_of_lessons_hw);
PRINT(@teacher_cpp);
PRINT(@teacher_hw);
PRINT(@start_date);
PRINT(@start_time);

DECLARE @date          AS DATE    = @start_date;
DECLARE @lesson_number AS TINYINT = 1;
DECLARE @time          AS TIME = @start_time;

WHILE @lesson_number < @number_of_lessons_cpp + @number_of_lessons_hw
BEGIN
	DECLARE @week_number AS TINYINT = DATEPART(WEEK, @date);
	DECLARE @day AS TINYINT = DATEPART(WEEKDAY, @date);
    SET @time = @start_time;
	PRINT(FORMATMESSAGE(N'%i %s %s %s', @lesson_number, CAST(@date AS VARCHAR(24)), DATENAME(WEEKDAY, @date), CAST(@time AS VARCHAR(24))));
	IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date] = @date AND [time] = @time AND [group] = @group)
		INSERT Schedule VALUES (@group, IIF(@day = 1, @discipline_hw, IIF(@day = 5, @discipline_cpp, IIF(@week_number % 2 = 0 AND @day = 3, @discipline_cpp, @discipline_hw))), IIF(@day = 1, @teacher_hw, IIF(@day = 5, @teacher_cpp, IIF(@week_number % 2 = 0 AND @day = 3, @teacher_cpp, @teacher_hw))), @date, @time, IIF(@date < GETDATE(), 1, 0));
	SET @lesson_number = @lesson_number + 1;
	SET @time = DATEADD(MINUTE, 95, @start_time);

	PRINT(FORMATMESSAGE(N'%i %s %s %s', @lesson_number, CAST(@date AS VARCHAR(24)), DATENAME(WEEKDAY, @date), CAST(@time AS VARCHAR(24))));
	IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date] = @date AND [time] = @time AND [group] = @group)
		INSERT Schedule VALUES (@group, IIF(@day = 1, @discipline_hw, IIF(@day = 5, @discipline_cpp, IIF(@week_number % 2 = 0 AND @day = 3, @discipline_cpp, @discipline_hw))), IIF(@day = 1, @teacher_hw, IIF(@day = 5, @teacher_cpp, IIF(@week_number % 2 = 0 AND @day = 3, @teacher_cpp, @teacher_hw))), @date, @time, IIF(@date < GETDATE(), 1, 0));
	SET @lesson_number = @lesson_number + 1;

	PRINT(@week_number);
	PRINT(@day);
	SET @date = DATEADD(DAY, IIF(@day = 5, 3, 2), @date);
END