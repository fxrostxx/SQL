--SQLQuery5-CREATE_STUDY_FORMS_AND_STUDY_DAYS.sql

USE PV_521_DDL;

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
--DROP TABLE StudyForms, StudyDays, StudyTime;