--SQLQuery3-CREATE_SCHEDULE_EXAMS_GRADES_HOMEWORKS.sql

USE PV_521_DDL;

CREATE TABLE Schedule
(
	lesson_id BIGINT         PRIMARY KEY IDENTITY(1, 1),
	[date]    DATE           NOT NULL,
	[time]    TIME(0)        NOT NULL,
	[group]   INT            NOT NULL CONSTRAINT FK_Schedule_Groups     FOREIGN KEY REFERENCES Groups(group_id),
	subject   SMALLINT       NOT NULL CONSTRAINT FK_Schedule_Subjects   FOREIGN KEY REFERENCES Subjects(subject_id),
	teacher   INT            NOT NULL CONSTRAINT FK_Schedule_Teachers   FOREIGN KEY REFERENCES Teachers(teacher_id),
	topic     NVARCHAR(256)  NULL,
	status    BIT            NOT NULL
);
CREATE TABLE Exams
(
	student   INT            NOT NULL CONSTRAINT FK_Exams_Students     FOREIGN KEY REFERENCES Students(student_id),
	subject   SMALLINT       NOT NULL CONSTRAINT FK_Exams_Subjects     FOREIGN KEY REFERENCES Subjects(subject_id),
	grade     TINYINT        NULL     CONSTRAINT CK_Exam_Grade         CHECK (grade > 0 AND grade <= 12),
	PRIMARY KEY(student, subject)
);
CREATE TABLE Grades
(
	student   INT            NOT NULL CONSTRAINT FK_Grades_Students    FOREIGN KEY REFERENCES Students(student_id),
	lesson    BIGINT         NOT NULL CONSTRAINT FK_Grades_Schedule    FOREIGN KEY REFERENCES Schedule(lesson_id),
	grade_1   TINYINT        NULL     CONSTRAINT CK_Grade_1            CHECK (grade_1 > 0 AND grade_1 <= 12),
	grade_2   TINYINT        NULL     CONSTRAINT CK_Grade_2            CHECK (grade_2 > 0 AND grade_2 <= 12),
	PRIMARY KEY(student, lesson)
);
CREATE TABLE Homeworks
(
	[group]   INT            NOT NULL CONSTRAINT FK_Homeworks_Groups   FOREIGN KEY REFERENCES Groups(group_id),
	lesson    BIGINT         NOT NULL CONSTRAINT FK_Homeworks_Schedule FOREIGN KEY REFERENCES Schedule(lesson_id),
	[data]    VARBINARY(MAX) NULL,
	comment   NVARCHAR(1024) NULL,
	deadline  DATE           NOT NULL,
	PRIMARY KEY([group], lesson),
	CONSTRAINT CK_Data_OR_Comment    CHECK ([data] IS NOT NULL OR comment IS NOT NULL)
);
CREATE TABLE ResultsHW
(
	student   INT            NOT NULL CONSTRAINT FK_ResultsHW_Students FOREIGN KEY REFERENCES Students(student_id),
	[group]   INT            NOT NULL,
	lesson    BIGINT         NOT NULL,
	result    VARBINARY(MAX) NULL,
	report    NVARCHAR(1024) NULL,
	grade     TINYINT        NULL     CONSTRAINT  CK_HW_Grade          CHECK (grade > 0 AND grade <= 12),
	PRIMARY KEY(student, [group], lesson),
	CONSTRAINT FK_ResultsHW_Homework FOREIGN KEY ([group], lesson) REFERENCES Homeworks([group], lesson),
	CONSTRAINT CK_Result_OR_Report   CHECK (result IS NOT NULL OR report IS NOT NULL)
);
--DROP TABLE Exams, Grades, ResultsHW, Homeworks, Schedule;