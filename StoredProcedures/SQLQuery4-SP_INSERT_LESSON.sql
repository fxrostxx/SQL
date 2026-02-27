--SQLQuery4-SP_INSERT_LESSON.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE OR ALTER PROCEDURE SP_InsertLesson
	@group         AS INT,
	@discipline    AS SMALLINT,
	@teacher       AS SMALLINT,
	@date          AS DATE,
	@time          AS TIME OUTPUT,
	@lesson_number AS INT  OUTPUT
AS
BEGIN
	PRINT(FORMATMESSAGE(N'%i %s %s %s', @lesson_number, CAST(@date AS VARCHAR(24)), DATENAME(WEEKDAY, @date), CAST(@time AS VARCHAR(24))));
	IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date] = @date AND [time] = @time AND [group] = @group)
	BEGIN
		INSERT Schedule VALUES (@group, @discipline, @teacher, @date, @time, IIF(@date < GETDATE(), 1, 0));
		SET @lesson_number = @lesson_number + 1;
	END
	SET @time = DATEADD(MINUTE, 95, @time);
END