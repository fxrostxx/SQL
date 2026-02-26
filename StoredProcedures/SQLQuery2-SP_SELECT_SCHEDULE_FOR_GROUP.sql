--SQLQuery2-SP_SELECT_SCHEDULE_FOR_GROUP.sql

USE PV_521_Import;
SET DATEFIRST 1;
GO

CREATE PROCEDURE SP_SelectScheduleFor @group AS NCHAR(10)
AS
BEGIN
    DECLARE @group_id AS INT = (SELECT group_id FROM Groups WHERE group_name LIKE @group);
    SELECT
        [Группа]        = group_name,
        [Дисциплина]    = discipline_name,
        [Преподаватель] = FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name),
        [День недели]   = DATENAME(WEEKDAY, [date]),
        [Дата]          = [date],
        [Время]         = [time],
        [Статус]        = IIF(spent = 1, N'Проведено', N'Запланировано')
    FROM Schedule, Groups, Teachers, Disciplines
    WHERE [group] = @group_id
    AND   [group] = group_id
    AND   discipline = discipline_id
    AND   teacher = teacher_id
    ORDER BY [date] ASC;
END