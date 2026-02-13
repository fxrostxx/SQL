--SQLQuery4-CREATE_DATABASE_ALL_IN_ONE.sql

CREATE DATABASE PV_521_ALL_IN_ONE
ON
(
	NAME       = PV_521_ALL_IN_ONE,
	FILENAME   = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\PV_521_ALL_IN_ONE.mdf',
	SIZE       = 8 MB,
	MAXSIZE    = 512 MB,
	FILEGROWTH = 8 MB
)
LOG ON
(
	NAME       = PV_521_ALL_IN_ONE_log,
	FILENAME   = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\PV_521_ALL_IN_ONE_log.ldf',
	SIZE       = 8 MB,
	MAXSIZE    = 512 MB,
	FILEGROWTH = 8 MB
)

GO
USE PV_521_ALL_IN_ONE;

CREATE TABLE Majors
(
	major_id          TINYINT         PRIMARY KEY,
	major_name        NVARCHAR(128)   NOT NULL
);
CREATE TABLE Groups
(
	group_id          INT             PRIMARY KEY,
	group_name        NVARCHAR(24)    NOT NULL,
	major             TINYINT         NOT NULL CONSTRAINT FK_Groups_Major       FOREIGN KEY REFERENCES Majors(major_id)
);
CREATE TABLE Students
(
	student_id        INT             PRIMARY KEY IDENTITY(1, 1),
	last_name         NVARCHAR(64)    NOT NULL,
	first_name        NVARCHAR(64)    NOT NULL,
	middle_name       NVARCHAR(64)    NULL,
	birth_date        date            NOT NULL,
	[group]           INT             NOT NULL CONSTRAINT FK_Students_Group     FOREIGN KEY REFERENCES Groups(group_id)
);
--DROP TABLE Students, Groups, Majors;

CREATE TABLE Teachers
(
	teacher_id        INT             PRIMARY KEY,
	last_name         NVARCHAR(64)    NOT NULL,
	first_name        NVARCHAR(64)    NOT NULL,
	middle_name       NVARCHAR(64)    NULL,
	birth_date        date            NOT NULL
);
CREATE TABLE Subjects
(
	subject_id        SMALLINT        PRIMARY KEY,
	subject_name      NVARCHAR(256)   NOT NULL,
	number_of_classes TINYINT         NOT NULL
);
CREATE TABLE SubjectsMajorsRelation
(
	subject           SMALLINT,
	major             TINYINT,
	PRIMARY KEY(subject, major),
	CONSTRAINT FK_SMR_Subject        FOREIGN KEY (subject)           REFERENCES Subjects(subject_id),
	CONSTRAINT FK_SMR_Major          FOREIGN KEY (major)             REFERENCES Majors(major_id)
);
CREATE TABLE TeachersSubjectsRelation
(
	teacher           INT,
	subject           SMALLINT,
	PRIMARY KEY(teacher, subject),
	CONSTRAINT FK_TSR_Teachers       FOREIGN KEY (teacher)           REFERENCES Teachers(teacher_id),
	CONSTRAINT FK_TSR_Subjects       FOREIGN KEY (subject)           REFERENCES Subjects(subject_id)
);
CREATE TABLE RequiredSubjects
(
	subject           SMALLINT,
	required_subject  SMALLINT,
	PRIMARY KEY(subject, required_subject),
	CONSTRAINT FK_RS_Subject         FOREIGN KEY (subject)           REFERENCES Subjects(subject_id),
	CONSTRAINT FK_RS_Required        FOREIGN KEY (required_subject)  REFERENCES Subjects(subject_id)
);
CREATE TABLE DependentSubjects
(
	subject           SMALLINT,
	dependent_subject SMALLINT,
	PRIMARY KEY(subject, dependent_subject),
	CONSTRAINT FK_DS_Subject         FOREIGN KEY (subject)           REFERENCES Subjects(subject_id),
	CONSTRAINT FK_DS_Dependent       FOREIGN KEY (dependent_subject) REFERENCES Subjects(subject_id)
);
--DROP TABLE SubjectsMajorsRelation, TeachersSubjectsRelation, RequiredSubjects, DependentSubjects, Teachers, Subjects;

CREATE TABLE Schedule
(
	lesson_id         BIGINT          PRIMARY KEY IDENTITY(1, 1),
	date              DATE            NOT NULL,
	time              TIME            NOT NULL,
	[group]           INT             NOT NULL CONSTRAINT FK_Schedule_Group     FOREIGN KEY REFERENCES Groups(group_id),
	subject           SMALLINT        NOT NULL CONSTRAINT FK_Schedule_Subject   FOREIGN KEY REFERENCES Subjects(subject_id),
	teacher           INT             NOT NULL CONSTRAINT FK_Schedule_Teacher   FOREIGN KEY REFERENCES Teachers(teacher_id),
	topic             NVARCHAR(256)   NULL,
	status            BIT             NOT NULL
);
CREATE TABLE Exams
(
	student           INT             NOT NULL CONSTRAINT FK_Exams_Student      FOREIGN KEY REFERENCES Students(student_id),
	subject           SMALLINT        NOT NULL CONSTRAINT FK_Exams_Subject      FOREIGN KEY REFERENCES Subjects(subject_id),
	grade             TINYINT         NOT NULL,
	PRIMARY KEY(student, subject)
);
CREATE TABLE Grades
(
	student           INT             NOT NULL CONSTRAINT FK_Grades_Student     FOREIGN KEY REFERENCES Students(student_id),
	lesson            BIGINT          NOT NULL CONSTRAINT FK_Grades_Schedule    FOREIGN KEY REFERENCES Schedule(lesson_id),
	grade_1           TINYINT         NULL,
	grade_2           TINYINT         NULL,
	PRIMARY KEY(student, lesson)
);
CREATE TABLE Homeworks
(
	[group]           INT             NOT NULL CONSTRAINT FK_Homeworks_Group    FOREIGN KEY REFERENCES Groups(group_id),
	lesson            BIGINT          NOT NULL CONSTRAINT FK_Homeworks_Schedule FOREIGN KEY REFERENCES Schedule(lesson_id),
	task              VARBINARY(1024) NOT NULL,
	deadline          DATE            NOT NULL,
	PRIMARY KEY([group], lesson)
);
CREATE TABLE ResultsHW
(
	student           INT             NOT NULL CONSTRAINT FK_ResultsHW_Student  FOREIGN KEY REFERENCES Students(student_id),
	[group]           INT             NOT NULL,
	lesson            BIGINT          NOT NULL,
	result            VARBINARY(1024) NULL,
	report            NVARCHAR(256)   NULL,
	grade             TINYINT         NOT NULL,
	PRIMARY KEY(student, [group], lesson),
	CONSTRAINT FK_ResultsHW_Homework FOREIGN KEY ([group], lesson)   REFERENCES Homeworks([group], lesson)
);
--DROP TABLE Exams, Grades, ResultsHW, Homeworks, Schedule;

--DROP TABLE Exams, Grades, ResultsHW, Homeworks, Schedule, SubjectsMajorsRelation, TeachersSubjectsRelation, RequiredSubjects, DependentSubjects, Teachers, Subjects, Students, Groups, Majors;