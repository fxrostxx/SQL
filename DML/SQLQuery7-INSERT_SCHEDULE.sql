--SQLQuery7-INSERT_SCHEDULE.sql

USE PV_521_Import;

INSERT Groups(group_id, group_name, direction) VALUES
       (521, N'PV_521', 1);

GO

DECLARE @start_date   DATE = '2025-05-12';
DECLARE @end_date     DATE = GETDATE();
DECLARE @current_date DATE = @start_date;

WHILE @current_date <= @end_date BEGIN
    IF DATEPART(WEEKDAY, @current_date) IN (2, 4, 6) BEGIN
        IF @current_date < '2025-06-23' BEGIN
            INSERT Schedule([group], discipline, teacher, [date], [time], spent) VALUES
                   (521, 1, 1, @current_date, '18:30', 1),
                   (521, 1, 1, @current_date, '20:05', 1);
        END;
        ELSE IF @current_date < '2025-09-17' BEGIN
            INSERT Schedule([group], discipline, teacher, [date], [time], spent) VALUES
                   (521, 2, 1, @current_date, '18:30', 1),
                   (521, 2, 1, @current_date, '20:05', 1);
        END;
        ELSE IF @current_date < '2025-10-08' BEGIN
            INSERT Schedule([group], discipline, teacher, [date], [time], spent) VALUES
                   (521, 3, 1, @current_date, '18:30', 1),
                   (521, 3, 1, @current_date, '20:05', 1);
        END;
        ELSE IF @current_date < '2025-11-17' BEGIN
            INSERT Schedule([group], discipline, teacher, [date], [time], spent) VALUES
                   (521, 4, 1, @current_date, '18:30', 1),
                   (521, 4, 1, @current_date, '20:05', 1);
        END;
        ELSE IF @current_date < '2025-12-24' BEGIN
            INSERT Schedule([group], discipline, teacher, [date], [time], spent) VALUES
                   (521, 6, 1, @current_date, '18:30', 1),
                   (521, 6, 1, @current_date, '20:05', 1);
        END;
        ELSE IF @current_date <= GETDATE() BEGIN
            INSERT Schedule([group], discipline, teacher, [date], [time], spent) VALUES
                   (521, 7, 1, @current_date, '18:30', 1),
                   (521, 7, 1, @current_date, '20:05', 1);
        END;
    END;
    SET @current_date = DATEADD(DAY, 1, @current_date);
END;