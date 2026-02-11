--SQLQuery3-CREATE_SCHEDULE_EXAMS_GRADES_HOMEWORKS.sql

USE PV_521_DDL;

CREATE TABLE Schedule
(
	lesson_id BIGINT          PRIMARY KEY IDENTITY(1, 1),
	date      DATE            NOT NULL,
	time      TIME            NOT NULL,
	[group]   INT             NOT NULL CONSTRAINT FK_Schedule_Group     FOREIGN KEY REFERENCES Groups(group_id),
	subject   SMALLINT        NOT NULL CONSTRAINT FK_Schedule_Subject   FOREIGN KEY REFERENCES Subjects(subject_id),
	teacher   INT             NOT NULL CONSTRAINT FK_Schedule_Teacher   FOREIGN KEY REFERENCES Teachers(teacher_id),
	topic     NVARCHAR(256)   NULL,
	status    BIT             NOT NULL
);
CREATE TABLE Exams
(
	student   INT             NOT NULL CONSTRAINT FK_Exams_Student      FOREIGN KEY REFERENCES Students(student_id),
	subject   SMALLINT        NOT NULL CONSTRAINT FK_Exams_Subject      FOREIGN KEY REFERENCES Subjects(subject_id),
	grade     TINYINT         NOT NULL,
	PRIMARY KEY(student, subject)
);
CREATE TABLE Grades
(
	student   INT             NOT NULL CONSTRAINT FK_Grades_Student     FOREIGN KEY REFERENCES Students(student_id),
	lesson    BIGINT          NOT NULL CONSTRAINT FK_Grades_Schedule    FOREIGN KEY REFERENCES Schedule(lesson_id),
	grade_1   TINYINT         NULL,
	grade_2   TINYINT         NULL,
	PRIMARY KEY(student, lesson)
);
CREATE TABLE Homeworks
(
	[group]   INT             NOT NULL CONSTRAINT FK_Homeworks_Group    FOREIGN KEY REFERENCES Groups(group_id),
	lesson    BIGINT          NOT NULL CONSTRAINT FK_Homeworks_Schedule FOREIGN KEY REFERENCES Schedule(lesson_id),
	task      VARBINARY(1024) NOT NULL,
	deadline  DATE            NOT NULL,
	PRIMARY KEY([group], lesson)
);
CREATE TABLE ResultsHW
(
	student   INT             NOT NULL CONSTRAINT FK_ResultsHW_Student  FOREIGN KEY REFERENCES Students(student_id),
	--[group]   INT             NOT NULL CONSTRAINT FK_ResultsHW_Group    FOREIGN KEY REFERENCES Groups(group_id),
	--lesson    BIGINT          NOT NULL CONSTRAINT FK_ResultsHW_Homework FOREIGN KEY REFERENCES Homeworks(lesson),
	[group]   INT             NOT NULL,
	lesson    BIGINT          NOT NULL,
	result    VARBINARY(1024) NULL,
	report    NVARCHAR(256)   NULL,
	grade     TINYINT         NOT NULL,
	PRIMARY KEY(student, [group], lesson),
	CONSTRAINT FK_ResultsHW_Homework FOREIGN KEY ([group], lesson) REFERENCES Homeworks([group], lesson)
);
--DROP TABLE Exams, Grades, ResultsHW, Homeworks, Schedule;