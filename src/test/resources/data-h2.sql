-- Вставка данных
CREATE TABLE IF NOT EXISTS USER_ROLE (
                                         USER_ID BIGINT NOT NULL,
                                         ROLE SMALLINT NOT NULL,
                                         CONSTRAINT UK_USER_ROLE UNIQUE (USER_ID, ROLE),
                                         CONSTRAINT FK_USER_ROLE FOREIGN KEY (USER_ID) REFERENCES USERS (ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS CONTACT (
                                       ID BIGINT NOT NULL,
                                       CODE VARCHAR(32) NOT NULL,
                                       VALUE VARCHAR(256) NOT NULL,
                                       PRIMARY KEY (ID, CODE),
                                       CONSTRAINT FK_CONTACT_PROFILE FOREIGN KEY (ID) REFERENCES PROFILE (ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS MAIL_CASE (
                                         ID BIGINT PRIMARY KEY,
                                         EMAIL VARCHAR(255) NOT NULL,
                                         NAME VARCHAR(255) NOT NULL,
                                         DATE_TIME TIMESTAMP NOT NULL,
                                         RESULT VARCHAR(255) NOT NULL,
                                         TEMPLATE VARCHAR(255) NOT NULL
);

CREATE SEQUENCE IF NOT EXISTS MAIL_CASE_ID_SEQ;

CREATE TABLE IF NOT EXISTS PROFILE (
                                       ID BIGINT PRIMARY KEY,
                                       LAST_LOGIN TIMESTAMP,
                                       LAST_FAILED_LOGIN TIMESTAMP,
                                       MAIL_NOTIFICATIONS BIGINT,
                                       CONSTRAINT FK_PROFILE_USERS FOREIGN KEY (ID) REFERENCES USERS (ID) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS TASK_TAG (
                                        TASK_ID BIGINT NOT NULL,
                                        TAG VARCHAR(32) NOT NULL,
                                        CONSTRAINT UK_TASK_TAG UNIQUE (TASK_ID, TAG),
                                        CONSTRAINT FK_TASK_TAG FOREIGN KEY (TASK_ID) REFERENCES TASK (ID) ON DELETE CASCADE
);

CREATE SEQUENCE IF NOT EXISTS USER_BELONG_ID_SEQ;

CREATE TABLE IF NOT EXISTS USER_BELONG (
                                           ID BIGINT PRIMARY KEY,
                                           OBJECT_ID BIGINT NOT NULL,
                                           OBJECT_TYPE SMALLINT NOT NULL,
                                           USER_ID BIGINT NOT NULL,
                                           USER_TYPE_CODE VARCHAR(32) NOT NULL,
                                           STARTPOINT TIMESTAMP,
                                           ENDPOINT TIMESTAMP,
                                           CONSTRAINT FK_USER_BELONG FOREIGN KEY (USER_ID) REFERENCES USERS (ID)
);

CREATE TABLE IF NOT EXISTS ACTIVITY (
                                        ID BIGINT PRIMARY KEY,
                                        AUTHOR_ID BIGINT NOT NULL,
                                        TASK_ID BIGINT NOT NULL,
                                        UPDATED TIMESTAMP,
                                        COMMENT VARCHAR(4096),
                                        TITLE VARCHAR(1024),
                                        DESCRIPTION VARCHAR(4096),
                                        ESTIMATE INTEGER,
                                        TYPE_CODE VARCHAR(32),
                                        STATUS_CODE VARCHAR(32),
                                        PRIORITY_CODE VARCHAR(32),
                                        CONSTRAINT FK_ACTIVITY_USERS FOREIGN KEY (AUTHOR_ID) REFERENCES USERS (ID),
                                        CONSTRAINT FK_ACTIVITY_TASK FOREIGN KEY (TASK_ID) REFERENCES TASK (ID) ON DELETE CASCADE
);

CREATE SEQUENCE IF NOT EXISTS ACTIVITY_ID_SEQ;

CREATE TABLE IF NOT EXISTS TASK (
                                    ID BIGINT PRIMARY KEY,
                                    TITLE VARCHAR(1024) NOT NULL,
                                    TYPE_CODE VARCHAR(32) NOT NULL,
                                    STATUS_CODE VARCHAR(32) NOT NULL,
                                    PROJECT_ID BIGINT NOT NULL,
                                    SPRINT_ID BIGINT,
                                    PARENT_ID BIGINT,
                                    STARTPOINT TIMESTAMP,
                                    ENDPOINT TIMESTAMP,
                                    CONSTRAINT FK_TASK_SPRINT FOREIGN KEY (SPRINT_ID) REFERENCES SPRINT (ID) ON DELETE SET NULL,
                                    CONSTRAINT FK_TASK_PROJECT FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT (ID) ON DELETE CASCADE,
                                    CONSTRAINT FK_TASK_PARENT_TASK FOREIGN KEY (PARENT_ID) REFERENCES TASK (ID) ON DELETE CASCADE
);

CREATE SEQUENCE IF NOT EXISTS TASK_ID_SEQ;

CREATE TABLE IF NOT EXISTS SPRINT (
                                      ID BIGINT PRIMARY KEY,
                                      STATUS_CODE VARCHAR(32) NOT NULL,
                                      STARTPOINT TIMESTAMP,
                                      ENDPOINT TIMESTAMP,
                                      CODE VARCHAR(1024) NOT NULL,
                                      PROJECT_ID BIGINT NOT NULL,
                                      CONSTRAINT FK_SPRINT_PROJECT FOREIGN KEY (PROJECT_ID) REFERENCES PROJECT (ID) ON DELETE CASCADE
);

CREATE SEQUENCE IF NOT EXISTS SPRINT_ID_SEQ;

CREATE TABLE IF NOT EXISTS PROJECT (
                                       ID BIGINT PRIMARY KEY,
                                       CODE VARCHAR(32) NOT NULL,
                                       TITLE VARCHAR(1024) NOT NULL,
                                       DESCRIPTION VARCHAR(4096) NOT NULL,
                                       TYPE_CODE VARCHAR(32) NOT NULL,
                                       STARTPOINT TIMESTAMP,
                                       ENDPOINT TIMESTAMP,
                                       PARENT_ID BIGINT,
                                       CONSTRAINT FK_PROJECT_PARENT FOREIGN KEY (PARENT_ID) REFERENCES PROJECT (ID) ON DELETE CASCADE
);

CREATE SEQUENCE IF NOT EXISTS PROJECT_ID_SEQ;

CREATE TABLE IF NOT EXISTS REFERENCE (
                                         ID BIGINT PRIMARY KEY,
                                         CODE VARCHAR(32) NOT NULL,
                                         REF_TYPE SMALLINT NOT NULL,
                                         ENDPOINT TIMESTAMP,
                                         STARTPOINT TIMESTAMP,
                                         TITLE VARCHAR(1024) NOT NULL,
                                         AUX VARCHAR,
                                         CONSTRAINT UK_REFERENCE_REF_TYPE_CODE UNIQUE (REF_TYPE, CODE)
);

CREATE SEQUENCE IF NOT EXISTS REFERENCE_ID_SEQ;

CREATE TABLE IF NOT EXISTS ATTACHMENT (
                                          ID BIGINT PRIMARY KEY,
                                          NAME VARCHAR(128) NOT NULL,
                                          FILE_LINK VARCHAR(2048) NOT NULL,
                                          OBJECT_ID BIGINT NOT NULL,
                                          OBJECT_TYPE SMALLINT NOT NULL,
                                          USER_ID BIGINT NOT NULL,
                                          DATE_TIME TIMESTAMP,
                                          CONSTRAINT FK_ATTACHMENT FOREIGN KEY (USER_ID) REFERENCES USERS (ID) ON DELETE CASCADE
);

CREATE SEQUENCE IF NOT EXISTS ATTACHMENT_ID_SEQ;

CREATE TABLE IF NOT EXISTS USERS (
                                     ID BIGINT PRIMARY KEY,
                                     DISPLAY_NAME VARCHAR(32) NOT NULL,
                                     EMAIL VARCHAR(128) NOT NULL,
                                     FIRST_NAME VARCHAR(32) NOT NULL,
                                     LAST_NAME VARCHAR(32),
                                     PASSWORD VARCHAR(128) NOT NULL,
                                     ENDPOINT TIMESTAMP,
                                     STARTPOINT TIMESTAMP
);

INSERT INTO USERS (EMAIL, PASSWORD, FIRST_NAME, LAST_NAME, DISPLAY_NAME)
VALUES ('user@gmail.com', '{noop}password', 'userFirstName', 'userLastName', 'userDisplayName'),
       ('admin@gmail.com', '{noop}admin', 'adminFirstName', 'adminLastName', 'adminDisplayName'),
       ('guest@gmail.com', '{noop}guest', 'guestFirstName', 'guestLastName', 'guestDisplayName'),
       ('manager@gmail.com', '{noop}manager', 'managerFirstName', 'managerLastName', 'managerDisplayName');

INSERT INTO USER_ROLE (USER_ID, ROLE)
VALUES (1, 0),
       (2, 0),
       (2, 1),
       (4, 2);

INSERT INTO PROFILE (ID, MAIL_NOTIFICATIONS)
VALUES (1, 49),
       (2, 14);

INSERT INTO CONTACT (ID, CODE, VALUE)
VALUES (1, 'skype', 'userSkype'),
       (1, 'mobile', '+01234567890'),
       (1, 'website', 'user.com'),
       (2, 'github', 'adminGitHub'),
       (2, 'tg', 'adminTg'),
       (2, 'vk', 'adminVk');

INSERT INTO PROJECT (code, title, description, type_code, parent_id)
VALUES ('PR1', 'PROJECT-1', 'test project 1', 'task_tracker', null),
       ('PR2', 'PROJECT-2', 'test project 2', 'task_tracker', 1);

INSERT INTO SPRINT (status_code, startpoint, endpoint, code, project_id)
VALUES ('finished', '2023-05-01 08:05:10', '2023-05-07 17:10:01', 'SP-1.001', 1),
       ('active', '2023-05-01 08:06:00', null, 'SP-1.002', 1),
       ('active', '2023-05-01 08:07:00', null, 'SP-1.003', 1),
       ('planning', '2023-05-01 08:08:00', null, 'SP-1.004', 1),
       ('active', '2023-05-10 08:06:00', null, 'SP-2.001', 2),
       ('planning', '2023-05-10 08:07:00', null, 'SP-2.002', 2),
       ('planning', '2023-05-10 08:08:00', null, 'SP-2.003', 2);

INSERT INTO TASK (TITLE, TYPE_CODE, STATUS_CODE, PROJECT_ID, SPRINT_ID, STARTPOINT)
VALUES ('Data', 'epic', 'in_progress', 1, 1, '2023-05-15 09:05:10'),
       ('Trees', 'epic', 'in_progress', 1, 1, '2023-05-15 12:05:10'),
       ('task-3', 'task', 'ready_for_test', 2, 5, '2023-06-14 09:28:10'),
       ('task-4', 'task', 'ready_for_review', 2, 5, '2023-06-14 09:28:10'),
       ('task-5', 'task', 'todo', 2, 5, '2023-06-14 09:28:10'),
       ('task-6', 'task', 'done', 2, 5, '2023-06-14 09:28:10'),
       ('task-7', 'task', 'canceled', 2, 5, '2023-06-14 09:28:10');

INSERT INTO ACTIVITY(AUTHOR_ID, TASK_ID, UPDATED, COMMENT, TITLE, DESCRIPTION, ESTIMATE, TYPE_CODE, STATUS_CODE,
                     PRIORITY_CODE)
VALUES (1, 1, '2023-05-15 09:05:10', null, 'Data', null, 3, 'epic', 'in_progress', 'low'),
       (2, 1, '2023-05-15 12:25:10', null, 'Data', null, null, null, null, 'normal'),
       (1, 1, '2023-05-15 14:05:10', null, 'Data', null, 4, null, null, null),
       (1, 2, '2023-05-15 12:05:10', null, 'Trees', 'Trees desc', 4, 'epic', 'in_progress', 'normal');

INSERT INTO USER_BELONG (OBJECT_ID, OBJECT_TYPE, USER_ID, USER_TYPE_CODE, STARTPOINT, ENDPOINT)
VALUES (1, 2, 2, 'task_developer', '2023-06-14 08:35:10', '2023-06-14 08:55:00'),
       (1, 2, 2, 'task_reviewer', '2023-06-14 09:35:10', null),
       (1, 2, 1, 'task_developer', '2023-06-12 11:40:00', '2023-06-12 12:35:00'),
       (1, 2, 1, 'task_developer', '2023-06-13 12:35:00', null),
       (1, 2, 1, 'task_tester', '2023-06-14 15:20:00', null),
       (2, 2, 2, 'task_developer', '2023-06-08 07:10:00', null),
       (2, 2, 1, 'task_developer', '2023-06-09 14:48:00', null),
       (2, 2, 1, 'task_tester', '2023-06-10 16:37:00', null);
