--SQLQuery4-SP_INSERT_LESSON.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE PROCEDURE SP_InsertLesson
	@group_name         AS NCHAR(10),
	@discipline_name    AS NVARCHAR(150),
	@teacher_first_name AS NVARCHAR(50),
	@date               AS DATE,
	@time               AS TIME
AS
BEGIN
	DECLARE @group      AS INT      = (SELECT group_id          FROM Groups      WHERE group_name      LIKE @group_name);
	DECLARE @discipline AS SMALLINT = (SELECT discipline_id     FROM Disciplines WHERE discipline_name LIKE @discipline_name);
	DECLARE @teacher    AS SMALLINT = (SELECT teacher_id        FROM Teachers    WHERE first_name      LIKE @teacher_first_name);

	IF NOT EXISTS (SELECT lesson_id FROM Schedule WHERE [date] = @date AND [time] = @time AND [group] = @group)
		INSERT Schedule VALUES (@group, @discipline, @teacher, @date, @time, IIF(@date < GETDATE(), 1, 0));
END