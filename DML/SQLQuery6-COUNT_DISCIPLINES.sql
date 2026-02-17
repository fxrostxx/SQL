--SQLQuery6-COUNT_DISCIPLINES.sql

USE PV_521_Import;

SELECT
       [Преподаватель]                  = FORMATMESSAGE(N'%s %s %s', last_name, first_name, middle_name),
       [Кол-во преподаваемых дисциплин] = COUNT(discipline)
FROM Teachers, TeachersDisciplinesRelation
WHERE teacher_id = teacher
GROUP BY last_name, first_name, middle_name
ORDER BY [Кол-во преподаваемых дисциплин] DESC;