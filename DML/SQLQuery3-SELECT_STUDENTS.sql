--SQLQuery3-SELECT_STUDENTS.sql

USE PV_521_Import;

SELECT
       --last_name      AS N'Фамилия',
       --first_name     AS N'Имя',
       --middle_name    AS N'Отчество',
       [Студент] =    FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name),
       birth_date     AS N'Дата рождения',
       group_name     AS N'Группа',
       direction_name AS N'Направление обучения'
FROM Students, Groups, Directions WHERE [group] = group_id AND direction = direction_id;