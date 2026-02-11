--SQLQuery2-CREATE_TEACHERS_AND_SUBJECTS.sql

USE PV_521_DDL;

CREATE TABLE Teachers
(
	teacher_id        INT           PRIMARY KEY,
	last_name         NVARCHAR(64)  NOT NULL,
	first_name        NVARCHAR(64)  NOT NULL,
	middle_name       NVARCHAR(64)  NULL,
	birth_date        date          NOT NULL
);
CREATE TABLE Subjects
(
	subject_id        SMALLINT      PRIMARY KEY,
	subject_name      NVARCHAR(256) NOT NULL,
	number_of_classes TINYINT       NOT NULL
);
CREATE TABLE SubjectsMajorsRelation
(
	subject           SMALLINT,
	major             TINYINT,
	PRIMARY KEY(subject, major),
	CONSTRAINT FK_SMR_Subject  FOREIGN KEY (subject)           REFERENCES Subjects(subject_id),
	CONSTRAINT FK_SMR_Major    FOREIGN KEY (major)             REFERENCES Majors(major_id)
);
CREATE TABLE TeachersSubjectsRelation
(
	teacher           INT,
	subject           SMALLINT,
	PRIMARY KEY(teacher, subject),
	CONSTRAINT FK_TSR_Teachers FOREIGN KEY (teacher)           REFERENCES Teachers(teacher_id),
	CONSTRAINT FK_TSR_Subjects FOREIGN KEY (subject)           REFERENCES Subjects(subject_id)
);
CREATE TABLE RequiredSubjects
(
	subject           SMALLINT,
	required_subject  SMALLINT,
	PRIMARY KEY(subject, required_subject),
	CONSTRAINT FK_RS_Subject   FOREIGN KEY (subject)           REFERENCES Subjects(subject_id),
	CONSTRAINT FK_RS_Required  FOREIGN KEY (required_subject)  REFERENCES Subjects(subject_id)
);
CREATE TABLE DependentSubjects
(
	subject           SMALLINT,
	dependent_subject SMALLINT,
	PRIMARY KEY(subject, dependent_subject),
	CONSTRAINT FK_DS_Subject   FOREIGN KEY (subject)           REFERENCES Subjects(subject_id),
	CONSTRAINT FK_DS_Dependent FOREIGN KEY (dependent_subject) REFERENCES Subjects(subject_id)
);
--DROP TABLE SubjectsMajorsRelation, TeachersSubjectsRelation, RequiredSubjects, DependentSubjects, Teachers, Subjects