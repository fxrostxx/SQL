--SQLQuery5-COUNT_GROUPS_STUDENTS.sql

USE PV_521_Import;

SELECT
       direction_name  AS N'Направление обучения',
       COUNT(group_id) AS N'Количество групп',
       COUNT(stud_id)  AS N'Количество студентов'
FROM Directions, Groups, Students
WHERE [group] = group_id AND direction = direction_id
GROUP BY direction_name;