--SQLQuery7-COUNT_TEACHERS.sql

USE PV_521_Import;

SELECT
       discipline_name AS N'Дисциплина',
       COUNT(teacher)  AS N'Кол-во ведущих преподавателей'
FROM Disciplines, TeachersDisciplinesRelation
WHERE discipline_id = discipline
GROUP BY discipline_name
ORDER BY COUNT(teacher) DESC;