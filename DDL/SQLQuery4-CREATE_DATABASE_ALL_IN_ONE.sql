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
	major_id          TINYINT        PRIMARY KEY,
	major_name        NVARCHAR(128)  NOT NULL
);
CREATE TABLE StudyForms
(
	study_form_id   TINYINT       PRIMARY KEY,
	study_form_name NVARCHAR(256) NOT NULL
);
CREATE TABLE StudyDays
(
	study_days_id   TINYINT       PRIMARY KEY,
	study_days      NVARCHAR(256) NOT NULL
);
CREATE TABLE StudyTime
(
	study_time_id   TINYINT       PRIMARY KEY,
	start_time      time          NOT NULL,
	end_time        time          NOT NULL
);
CREATE TABLE Groups
(
	group_id          INT            PRIMARY KEY,
	group_name        NVARCHAR(24)   NOT NULL,
	major             TINYINT        NOT NULL CONSTRAINT FK_Groups_Majors      FOREIGN KEY REFERENCES Majors(major_id),
	study_form        TINYINT        NOT NULL CONSTRAINT FK_Groups_StudyForms  FOREIGN KEY REFERENCES StudyForms(study_form_id),
	study_days        TINYINT        NOT NULL CONSTRAINT FK_Groups_StudyDays   FOREIGN KEY REFERENCES StudyDays(study_days_id),
	study_time        TINYINT        NOT NULL CONSTRAINT FK_Groups_StudyTime   FOREIGN KEY REFERENCES StudyTime(study_time_id)
);
CREATE TABLE Students
(
	student_id        INT            PRIMARY KEY IDENTITY(1, 1),
	last_name         NVARCHAR(64)   NOT NULL,
	first_name        NVARCHAR(64)   NOT NULL,
	middle_name       NVARCHAR(64)   NULL,
	birth_date        date           NOT NULL,
	[group]           INT            NOT NULL CONSTRAINT FK_Students_Groups    FOREIGN KEY REFERENCES Groups(group_id)
);
--DROP TABLE Students, Groups, Majors, StudyForms, StudyDays, StudyTime;

CREATE TABLE Teachers
(
	teacher_id        INT            PRIMARY KEY,
	last_name         NVARCHAR(64)   NOT NULL,
	first_name        NVARCHAR(64)   NOT NULL,
	middle_name       NVARCHAR(64)   NULL,
	birth_date        date           NOT NULL
);
CREATE TABLE Subjects
(
	subject_id        SMALLINT       PRIMARY KEY,
	subject_name      NVARCHAR(256)  NOT NULL,
	number_of_classes TINYINT        NOT NULL
);
CREATE TABLE SubjectsMajorsRelation
(
	subject           SMALLINT,
	major             TINYINT,
	PRIMARY KEY(subject, major),
	CONSTRAINT FK_SMR_Subjects       FOREIGN KEY (subject)           REFERENCES Subjects(subject_id),
	CONSTRAINT FK_SMR_Majors         FOREIGN KEY (major)             REFERENCES Majors(major_id)
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
	CONSTRAINT FK_RS_Subjects        FOREIGN KEY (subject)           REFERENCES Subjects(subject_id),
	CONSTRAINT FK_RS_Required        FOREIGN KEY (required_subject)  REFERENCES Subjects(subject_id)
);
CREATE TABLE DependentSubjects
(
	subject           SMALLINT,
	dependent_subject SMALLINT,
	PRIMARY KEY(subject, dependent_subject),
	CONSTRAINT FK_DS_Subjects        FOREIGN KEY (subject)           REFERENCES Subjects(subject_id),
	CONSTRAINT FK_DS_Dependent       FOREIGN KEY (dependent_subject) REFERENCES Subjects(subject_id)
);
--DROP TABLE SubjectsMajorsRelation, TeachersSubjectsRelation, RequiredSubjects, DependentSubjects, Teachers, Subjects;

CREATE TABLE Schedule
(
	lesson_id         BIGINT         PRIMARY KEY IDENTITY(1, 1),
	[date]            DATE           NOT NULL,
	[time]            TIME(0)        NOT NULL,
	[group]           INT            NOT NULL CONSTRAINT FK_Schedule_Groups    FOREIGN KEY REFERENCES Groups(group_id),
	subject           SMALLINT       NOT NULL CONSTRAINT FK_Schedule_Subjects  FOREIGN KEY REFERENCES Subjects(subject_id),
	teacher           INT            NOT NULL CONSTRAINT FK_Schedule_Teachers  FOREIGN KEY REFERENCES Teachers(teacher_id),
	topic             NVARCHAR(256)  NULL,
	status            BIT            NOT NULL
);
CREATE TABLE Exams
(
	student           INT            NOT NULL CONSTRAINT FK_Exams_Students     FOREIGN KEY REFERENCES Students(student_id),
	subject           SMALLINT       NOT NULL CONSTRAINT FK_Exams_Subjects     FOREIGN KEY REFERENCES Subjects(subject_id),
	grade             TINYINT        NULL     CONSTRAINT CK_Exam_Grade         CHECK (grade > 0 AND grade <= 12),
	PRIMARY KEY(student, subject)
);
CREATE TABLE Grades
(
	student           INT            NOT NULL CONSTRAINT FK_Grades_Students    FOREIGN KEY REFERENCES Students(student_id),
	lesson            BIGINT         NOT NULL CONSTRAINT FK_Grades_Schedule    FOREIGN KEY REFERENCES Schedule(lesson_id),
	grade_1           TINYINT        NULL     CONSTRAINT CK_Grade_1            CHECK (grade_1 > 0 AND grade_1 <= 12),
	grade_2           TINYINT        NULL     CONSTRAINT CK_Grade_2            CHECK (grade_2 > 0 AND grade_2 <= 12),
	PRIMARY KEY(student, lesson)
);
CREATE TABLE Homeworks
(
	[group]           INT            NOT NULL CONSTRAINT FK_Homeworks_Groups   FOREIGN KEY REFERENCES Groups(group_id),
	lesson            BIGINT         NOT NULL CONSTRAINT FK_Homeworks_Schedule FOREIGN KEY REFERENCES Schedule(lesson_id),
	[data]            VARBINARY(MAX) NOT NULL,
	comment           NVARCHAR(1024) NULL,
	deadline          DATE           NOT NULL,
	PRIMARY KEY([group], lesson),
	CONSTRAINT CK_Data_OR_Comment    CHECK ([data] IS NOT NULL OR comment IS NOT NULL)
);
CREATE TABLE ResultsHW
(
	student           INT            NOT NULL CONSTRAINT FK_ResultsHW_Students FOREIGN KEY REFERENCES Students(student_id),
	[group]           INT            NOT NULL,
	lesson            BIGINT         NOT NULL,
	result            VARBINARY(MAX) NULL,
	report            NVARCHAR(256)  NULL,
	grade             TINYINT        NULL     CONSTRAINT  CK_HW_Grade          CHECK (grade > 0 AND grade <= 12),
	PRIMARY KEY(student, [group], lesson),
	CONSTRAINT FK_ResultsHW_Homework FOREIGN KEY ([group], lesson)   REFERENCES Homeworks([group], lesson),
	CONSTRAINT CK_Result_OR_Report   CHECK (result IS NOT NULL OR report IS NOT NULL)
);
--DROP TABLE Exams, Grades, ResultsHW, Homeworks, Schedule;

--DROP TABLE Exams, Grades, ResultsHW, Homeworks, Schedule, SubjectsMajorsRelation, TeachersSubjectsRelation, RequiredSubjects, DependentSubjects, Teachers, Subjects, Students, Groups, Majors, StudyForms, StudyDays, StudyTime;