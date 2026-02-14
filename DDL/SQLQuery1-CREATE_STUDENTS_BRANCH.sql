--SQLQuery1-CREATE_STUDENTS_BRANCH.sql

USE PV_521_DDL;

CREATE TABLE Majors
(
	major_id    TINYINT       PRIMARY KEY,
	major_name  NVARCHAR(128) NOT NULL
);
CREATE TABLE Groups
(
	group_id    INT           PRIMARY KEY,
	group_name  NVARCHAR(24)  NOT NULL,
	major       TINYINT       NOT NULL CONSTRAINT FK_Groups_Majors     FOREIGN KEY REFERENCES Majors(major_id),
	study_form  TINYINT       NOT NULL CONSTRAINT FK_Groups_StudyForms FOREIGN KEY REFERENCES StudyForms(study_form_id),
	study_days  TINYINT       NOT NULL CONSTRAINT FK_Groups_StudyDays  FOREIGN KEY REFERENCES StudyDays(study_days_id),
	study_time  TINYINT       NOT NULL CONSTRAINT FK_Groups_StudyTime  FOREIGN KEY REFERENCES StudyTime(study_time_id)
);
CREATE TABLE Students
(
	student_id  INT           PRIMARY KEY IDENTITY(1, 1),
	last_name   NVARCHAR(64)  NOT NULL,
	first_name  NVARCHAR(64)  NOT NULL,
	middle_name NVARCHAR(64)  NULL,
	birth_date  date          NOT NULL,
	[group]     INT           NOT NULL CONSTRAINT FK_Students_Groups   FOREIGN KEY REFERENCES Groups(group_id)
);
--DROP TABLE Students, Groups, Majors;