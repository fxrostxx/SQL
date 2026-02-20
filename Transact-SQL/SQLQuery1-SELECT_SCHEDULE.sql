--SQLQuery1-SELECT_SCHEDULE.sql

USE PV_521_Import;

SELECT
       [Группа]        = [group_name],
       [Дисциплина]    = [discipline_name],
       [Преподаватель] = FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name),
       [День недели]   = DATENAME(WEEKDAY, [date]),
       [Дата]          = [date],
       [Время]         = [time],
       [Статус]        = IIF(spent = 1, N'Проведено', N'Запланировано')
FROM Schedule, Groups, Teachers, Disciplines
WHERE [group] = group_id
AND   discipline = discipline_id
AND   teacher = teacher_id
AND   [group] = (SELECT group_id FROM Groups WHERE group_name = N'PV_521');

--DELETE FROM Schedule WHERE [group] = (SELECT group_id FROM Groups WHERE group_name = N'PV_521');