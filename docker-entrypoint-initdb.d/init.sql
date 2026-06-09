--
-- PostgreSQL database dump
--

\restrict q8r2OzMXzxmoWC0bAfCJ9dTdG1FUoKsr6FGq0aSqPkTNKPJ8JUDFd10Wyms8UwJ

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.teachers DROP CONSTRAINT IF EXISTS teachers_id_user_fkey;
ALTER TABLE IF EXISTS ONLY public.teacher_flags DROP CONSTRAINT IF EXISTS teacher_flags_session_id_fkey;
ALTER TABLE IF EXISTS ONLY public.teacher_flags DROP CONSTRAINT IF EXISTS teacher_flags_id_teacher_fkey;
ALTER TABLE IF EXISTS ONLY public.subjects DROP CONSTRAINT IF EXISTS subjects_id_course_fkey;
ALTER TABLE IF EXISTS ONLY public.students DROP CONSTRAINT IF EXISTS students_id_user_fkey;
ALTER TABLE IF EXISTS ONLY public.students DROP CONSTRAINT IF EXISTS students_id_course_fkey;
ALTER TABLE IF EXISTS ONLY public.sessions DROP CONSTRAINT IF EXISTS sessions_id_classroom_fkey;
ALTER TABLE IF EXISTS ONLY public.sessions DROP CONSTRAINT IF EXISTS sessions_id_class_fkey;
ALTER TABLE IF EXISTS ONLY public.schedule DROP CONSTRAINT IF EXISTS schedule_id_classroom_fkey;
ALTER TABLE IF EXISTS ONLY public.schedule DROP CONSTRAINT IF EXISTS schedule_id_class_fkey;
ALTER TABLE IF EXISTS ONLY public.justification_attachment DROP CONSTRAINT IF EXISTS justification_attachment_id_attendance_fkey;
ALTER TABLE IF EXISTS ONLY public.enrollments DROP CONSTRAINT IF EXISTS enrollments_id_student_fkey;
ALTER TABLE IF EXISTS ONLY public.enrollments DROP CONSTRAINT IF EXISTS enrollments_id_class_fkey;
ALTER TABLE IF EXISTS ONLY public.courses DROP CONSTRAINT IF EXISTS courses_id_area_fkey;
ALTER TABLE IF EXISTS ONLY public.classes DROP CONSTRAINT IF EXISTS classes_id_teacher_fkey;
ALTER TABLE IF EXISTS ONLY public.classes DROP CONSTRAINT IF EXISTS classes_id_subject_fkey;
ALTER TABLE IF EXISTS ONLY public.classes DROP CONSTRAINT IF EXISTS classes_id_period_fkey;
ALTER TABLE IF EXISTS ONLY public.classes DROP CONSTRAINT IF EXISTS classes_id_group_fkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_id_teacher_justifies_fkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_id_student_fkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_id_session_fkey;
ALTER TABLE IF EXISTS ONLY public.attendance_event DROP CONSTRAINT IF EXISTS attendance_event_id_attendance_fkey;
ALTER TABLE IF EXISTS ONLY public.attendance_event DROP CONSTRAINT IF EXISTS attendance_event_id_actor_fkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_email_key;
ALTER TABLE IF EXISTS ONLY public.teachers DROP CONSTRAINT IF EXISTS teachers_teacher_card_key;
ALTER TABLE IF EXISTS ONLY public.teachers DROP CONSTRAINT IF EXISTS teachers_pkey;
ALTER TABLE IF EXISTS ONLY public.teachers DROP CONSTRAINT IF EXISTS teachers_id_user_key;
ALTER TABLE IF EXISTS ONLY public.teacher_flags DROP CONSTRAINT IF EXISTS teacher_flags_pkey;
ALTER TABLE IF EXISTS ONLY public.subjects DROP CONSTRAINT IF EXISTS subjects_pkey;
ALTER TABLE IF EXISTS ONLY public.students DROP CONSTRAINT IF EXISTS students_student_card_key;
ALTER TABLE IF EXISTS ONLY public.students DROP CONSTRAINT IF EXISTS students_pkey;
ALTER TABLE IF EXISTS ONLY public.students DROP CONSTRAINT IF EXISTS students_id_user_key;
ALTER TABLE IF EXISTS ONLY public.sessions DROP CONSTRAINT IF EXISTS sessions_qr_token_key;
ALTER TABLE IF EXISTS ONLY public.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.schedule DROP CONSTRAINT IF EXISTS schedule_pkey;
ALTER TABLE IF EXISTS ONLY public.periods DROP CONSTRAINT IF EXISTS periods_year_cycle_key;
ALTER TABLE IF EXISTS ONLY public.periods DROP CONSTRAINT IF EXISTS periods_pkey;
ALTER TABLE IF EXISTS ONLY public.knowledge_area DROP CONSTRAINT IF EXISTS knowledge_area_pkey;
ALTER TABLE IF EXISTS ONLY public.justification_attachment DROP CONSTRAINT IF EXISTS justification_attachment_pkey;
ALTER TABLE IF EXISTS ONLY public.groups_ DROP CONSTRAINT IF EXISTS groups__pkey;
ALTER TABLE IF EXISTS ONLY public.enrollments DROP CONSTRAINT IF EXISTS enrollments_pkey;
ALTER TABLE IF EXISTS ONLY public.enrollments DROP CONSTRAINT IF EXISTS enrollments_id_student_id_class_key;
ALTER TABLE IF EXISTS ONLY public.courses DROP CONSTRAINT IF EXISTS courses_pkey;
ALTER TABLE IF EXISTS ONLY public.classrooms DROP CONSTRAINT IF EXISTS classrooms_pkey;
ALTER TABLE IF EXISTS ONLY public.classes DROP CONSTRAINT IF EXISTS classes_pkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_pkey;
ALTER TABLE IF EXISTS ONLY public.attendance DROP CONSTRAINT IF EXISTS attendance_id_session_id_student_key;
ALTER TABLE IF EXISTS ONLY public.attendance_event DROP CONSTRAINT IF EXISTS attendance_event_pkey;
DROP TABLE IF EXISTS public.users;
DROP TABLE IF EXISTS public.teachers;
DROP TABLE IF EXISTS public.teacher_flags;
DROP TABLE IF EXISTS public.subjects;
DROP TABLE IF EXISTS public.students;
DROP TABLE IF EXISTS public.sessions;
DROP TABLE IF EXISTS public.schedule;
DROP TABLE IF EXISTS public.periods;
DROP TABLE IF EXISTS public.knowledge_area;
DROP TABLE IF EXISTS public.justification_attachment;
DROP TABLE IF EXISTS public.groups_;
DROP TABLE IF EXISTS public.enrollments;
DROP TABLE IF EXISTS public.courses;
DROP TABLE IF EXISTS public.classrooms;
DROP TABLE IF EXISTS public.classes;
DROP TABLE IF EXISTS public.attendance_event;
DROP TABLE IF EXISTS public.attendance;
DROP TYPE IF EXISTS public.weekday;
DROP TYPE IF EXISTS public.userrole;
DROP TYPE IF EXISTS public.shift;
DROP TYPE IF EXISTS public.sessionstatus;
DROP TYPE IF EXISTS public.flagstatus;
DROP TYPE IF EXISTS public.flaglevel;
DROP TYPE IF EXISTS public.eventtype;
DROP TYPE IF EXISTS public.attendancestatus;
DROP TYPE IF EXISTS public.attendancemethod;
DROP TYPE IF EXISTS public.attachmenttype;
--
-- Name: attachmenttype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attachmenttype AS ENUM (
    'IMAGE',
    'PDF'
);


ALTER TYPE public.attachmenttype OWNER TO postgres;

--
-- Name: attendancemethod; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attendancemethod AS ENUM (
    'QR',
    'MANUAL'
);


ALTER TYPE public.attendancemethod OWNER TO postgres;

--
-- Name: attendancestatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attendancestatus AS ENUM (
    'PRESENT',
    'ABSENT',
    'LATE',
    'JUSTIFIED'
);


ALTER TYPE public.attendancestatus OWNER TO postgres;

--
-- Name: eventtype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.eventtype AS ENUM (
    'CREATION',
    'STATUS_CHANGE',
    'JUSTIFICATION'
);


ALTER TYPE public.eventtype OWNER TO postgres;

--
-- Name: flaglevel; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.flaglevel AS ENUM (
    'LOW',
    'MEDIUM',
    'HIGH'
);


ALTER TYPE public.flaglevel OWNER TO postgres;

--
-- Name: flagstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.flagstatus AS ENUM (
    'ACTIVE',
    'UNDER_REVIEW',
    'CLOSED'
);


ALTER TYPE public.flagstatus OWNER TO postgres;

--
-- Name: sessionstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sessionstatus AS ENUM (
    'SCHEDULED',
    'ACTIVE',
    'CANCELED',
    'FINISHED'
);


ALTER TYPE public.sessionstatus OWNER TO postgres;

--
-- Name: shift; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.shift AS ENUM (
    'MORNING',
    'AFTERNOON'
);


ALTER TYPE public.shift OWNER TO postgres;

--
-- Name: userrole; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.userrole AS ENUM (
    'STUDENT',
    'TEACHER',
    'ADMIN'
);


ALTER TYPE public.userrole OWNER TO postgres;

--
-- Name: weekday; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.weekday AS ENUM (
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN'
);


ALTER TYPE public.weekday OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    id_attendance character varying NOT NULL,
    id_session character varying NOT NULL,
    id_student character varying NOT NULL,
    status public.attendancestatus,
    method public.attendancemethod,
    record_date timestamp without time zone,
    ip_address character varying,
    latitude double precision,
    longitude double precision,
    justification character varying,
    id_teacher_justifies character varying,
    justification_date timestamp without time zone
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: attendance_event; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance_event (
    id_event character varying NOT NULL,
    id_attendance character varying NOT NULL,
    type public.eventtype,
    previous_status character varying,
    new_status character varying,
    comment character varying,
    id_actor character varying NOT NULL,
    date timestamp without time zone
);


ALTER TABLE public.attendance_event OWNER TO postgres;

--
-- Name: classes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classes (
    id_class character varying NOT NULL,
    id_teacher character varying NOT NULL,
    id_subject character varying NOT NULL,
    id_group character varying NOT NULL,
    id_period character varying NOT NULL
);


ALTER TABLE public.classes OWNER TO postgres;

--
-- Name: classrooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.classrooms (
    id_classroom character varying NOT NULL,
    pavilion character varying NOT NULL,
    type character varying NOT NULL,
    latitude double precision,
    longitude double precision,
    allowed_radius double precision
);


ALTER TABLE public.classrooms OWNER TO postgres;

--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    id_course character varying NOT NULL,
    name character varying NOT NULL,
    id_area character varying NOT NULL,
    duration_years integer
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: enrollments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollments (
    id_enrollment character varying NOT NULL,
    id_student character varying NOT NULL,
    id_class character varying NOT NULL
);


ALTER TABLE public.enrollments OWNER TO postgres;

--
-- Name: groups_; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups_ (
    id_group character varying NOT NULL,
    code character varying NOT NULL
);


ALTER TABLE public.groups_ OWNER TO postgres;

--
-- Name: justification_attachment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.justification_attachment (
    id_attachment character varying NOT NULL,
    id_attendance character varying NOT NULL,
    file_url character varying NOT NULL,
    type public.attachmenttype,
    upload_date timestamp without time zone
);


ALTER TABLE public.justification_attachment OWNER TO postgres;

--
-- Name: knowledge_area; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.knowledge_area (
    id_area character varying NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.knowledge_area OWNER TO postgres;

--
-- Name: periods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.periods (
    id_period character varying NOT NULL,
    year integer NOT NULL,
    cycle integer NOT NULL,
    start_date date,
    end_date date
);


ALTER TABLE public.periods OWNER TO postgres;

--
-- Name: schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schedule (
    id_schedule character varying NOT NULL,
    id_class character varying NOT NULL,
    weekday public.weekday NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    shift public.shift NOT NULL,
    id_classroom character varying NOT NULL,
    end_next_day boolean DEFAULT false NOT NULL
);


ALTER TABLE public.schedule OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id_session character varying NOT NULL,
    id_class character varying NOT NULL,
    date date NOT NULL,
    actual_start_time time without time zone,
    actual_end_time time without time zone,
    status public.sessionstatus NOT NULL,
    id_classroom character varying NOT NULL,
    qr_token character varying NOT NULL,
    qr_expires timestamp without time zone,
    opens_at timestamp without time zone,
    closes_at timestamp without time zone,
    extended_mode boolean NOT NULL,
    extension_reason character varying,
    close_notification_minutes integer
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    id_student character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    student_card character varying NOT NULL,
    id_course character varying NOT NULL,
    id_user character varying NOT NULL,
    deleted_at timestamp without time zone,
    editable_fields character varying,
    photo_url character varying
);


ALTER TABLE public.students OWNER TO postgres;

--
-- Name: subjects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subjects (
    id_subject character varying NOT NULL,
    name character varying NOT NULL,
    id_course character varying NOT NULL
);


ALTER TABLE public.subjects OWNER TO postgres;

--
-- Name: teacher_flags; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_flags (
    id_flag character varying NOT NULL,
    id_teacher character varying NOT NULL,
    reason character varying,
    level public.flaglevel,
    status public.flagstatus,
    creation_date timestamp without time zone,
    session_id character varying
);


ALTER TABLE public.teacher_flags OWNER TO postgres;

--
-- Name: teachers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teachers (
    id_teacher character varying NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    teacher_card character varying NOT NULL,
    id_user character varying NOT NULL,
    modifications_count integer NOT NULL,
    teacher_flag boolean NOT NULL,
    must_change_password boolean NOT NULL,
    deleted_at timestamp without time zone,
    photo_url character varying
);


ALTER TABLE public.teachers OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id_user character varying NOT NULL,
    email character varying NOT NULL,
    password_hash character varying NOT NULL,
    role public.userrole NOT NULL,
    must_change_password boolean NOT NULL,
    created_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (id_attendance, id_session, id_student, status, method, record_date, ip_address, latitude, longitude, justification, id_teacher_justifies, justification_date) FROM stdin;
b8f0dd68-21cf-4c7f-9714-a4787e856bba	210b42c2-20ca-482f-b89c-62a3800ada36	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-03-23 11:02:00	192.168.182.112	\N	\N	\N	\N	\N
83c47fb6-5b1b-4c13-8dd0-58a859334c53	210b42c2-20ca-482f-b89c-62a3800ada36	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	MANUAL	2026-03-23 15:43:00	192.168.185.241	\N	\N	\N	\N	\N
caf71e8c-eaa1-436f-a962-6e9ed2862ebe	210b42c2-20ca-482f-b89c-62a3800ada36	90b6848c-4a8e-447a-a391-b4fdf2fced42	LATE	QR	2026-03-23 12:27:00	192.168.18.243	\N	\N	\N	\N	\N
f7679656-6e5f-492c-9d36-760088b5e72e	b38c805e-448b-4db8-b944-17a89a8a191c	2fc60451-e195-4038-96f9-0fde54fe06e8	LATE	QR	2026-05-25 12:42:00	192.168.218.32	\N	\N	\N	\N	\N
94826636-5bae-4cb7-bc6e-6379e03d3ead	b38c805e-448b-4db8-b944-17a89a8a191c	60312bc6-4b87-4433-b945-549246dab02c	LATE	QR	2026-05-25 11:42:00	192.168.105.84	\N	\N	\N	\N	\N
fd805d43-226a-4276-b1f5-821a12bc0ab6	b38c805e-448b-4db8-b944-17a89a8a191c	90b6848c-4a8e-447a-a391-b4fdf2fced42	PRESENT	QR	2026-05-25 09:12:00	192.168.108.171	\N	\N	\N	\N	\N
52fb3ecf-486b-4179-b662-4f53d4168779	a74d0e3e-29c4-4785-9611-a489867d4bc8	2fc60451-e195-4038-96f9-0fde54fe06e8	JUSTIFIED	QR	2026-04-27 09:39:00	192.168.78.74	\N	\N	Viaje personal	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-04-27 09:39:00
b1e72787-c809-45e3-861f-21f6a3ab0f35	a74d0e3e-29c4-4785-9611-a489867d4bc8	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	QR	2026-04-27 16:41:00	192.168.83.120	\N	\N	\N	\N	\N
c1d37c5d-8cc9-4f33-a991-d90ab8e1b05f	a74d0e3e-29c4-4785-9611-a489867d4bc8	90b6848c-4a8e-447a-a391-b4fdf2fced42	PRESENT	QR	2026-04-27 15:30:00	192.168.204.231	\N	\N	\N	\N	\N
2cd15ffc-f087-4b4d-9b19-98fdc0cf58d2	591f1ae1-2ecf-4643-a042-99d54d6cc0d2	2fc60451-e195-4038-96f9-0fde54fe06e8	JUSTIFIED	QR	2026-05-04 17:05:00	192.168.210.244	\N	\N	Viaje personal	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-05-04 17:05:00
cf4b6e33-f5c9-4417-b10b-202416082aef	591f1ae1-2ecf-4643-a042-99d54d6cc0d2	60312bc6-4b87-4433-b945-549246dab02c	ABSENT	QR	2026-05-04 10:51:00	192.168.51.38	\N	\N	\N	\N	\N
bd4c8ddf-69f6-4592-896e-19d971297ae7	591f1ae1-2ecf-4643-a042-99d54d6cc0d2	90b6848c-4a8e-447a-a391-b4fdf2fced42	PRESENT	QR	2026-05-04 14:39:00	192.168.218.197	\N	\N	\N	\N	\N
8e2196df-f519-42bb-b025-3a5a53202a97	9cc1c919-7c87-4742-a416-419d1360908b	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-03-02 17:36:00	192.168.50.184	\N	\N	\N	\N	\N
3950d61a-e4c8-4b9b-8e34-f22667c92f12	9cc1c919-7c87-4742-a416-419d1360908b	60312bc6-4b87-4433-b945-549246dab02c	LATE	QR	2026-03-02 10:09:00	192.168.168.177	\N	\N	\N	\N	\N
3d8c9fc4-a6a9-4401-b2f4-1c2006aee179	9cc1c919-7c87-4742-a416-419d1360908b	90b6848c-4a8e-447a-a391-b4fdf2fced42	PRESENT	QR	2026-03-02 08:49:00	192.168.109.57	\N	\N	\N	\N	\N
5d9147a8-053f-4590-aa6c-7e5de35b045c	57045a5d-9b4c-4a11-a060-cc6f2e5f1ec2	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	MANUAL	2026-05-18 15:29:00	192.168.13.143	\N	\N	\N	\N	\N
c43eecd9-4d04-4374-b869-71bd4eb8a790	57045a5d-9b4c-4a11-a060-cc6f2e5f1ec2	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	MANUAL	2026-05-18 14:08:00	192.168.206.119	\N	\N	\N	\N	\N
5b3c65a2-a423-4520-8777-9f7e3166deae	57045a5d-9b4c-4a11-a060-cc6f2e5f1ec2	90b6848c-4a8e-447a-a391-b4fdf2fced42	LATE	MANUAL	2026-05-18 16:20:00	192.168.244.194	\N	\N	\N	\N	\N
36397cbd-0a6c-4a63-afe3-e9488ad55da8	7bb56821-b9b7-4211-8e89-f4144efb90fe	2fc60451-e195-4038-96f9-0fde54fe06e8	JUSTIFIED	QR	2026-04-06 18:57:00	192.168.191.221	\N	\N	Cita médica	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-04-07 18:57:00
3a7e627f-fb35-43a0-a55a-eba510ebffc4	7bb56821-b9b7-4211-8e89-f4144efb90fe	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	QR	2026-04-06 10:53:00	192.168.164.71	\N	\N	\N	\N	\N
a7233ca0-25cb-43fb-b93c-4e22d3d73d7f	7bb56821-b9b7-4211-8e89-f4144efb90fe	90b6848c-4a8e-447a-a391-b4fdf2fced42	ABSENT	QR	2026-04-06 17:15:00	192.168.71.113	\N	\N	\N	\N	\N
77f993a5-6f60-4755-a78b-9be498957f34	7128bea3-1c8c-46ec-8717-ece83a0ad306	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-04-13 11:21:00	192.168.82.229	\N	\N	\N	\N	\N
58686104-d06f-40ca-abfa-02decde532e5	7128bea3-1c8c-46ec-8717-ece83a0ad306	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	QR	2026-04-13 10:24:00	192.168.178.40	\N	\N	\N	\N	\N
5fad863d-72e0-4a0e-966e-bd02e9395855	7128bea3-1c8c-46ec-8717-ece83a0ad306	90b6848c-4a8e-447a-a391-b4fdf2fced42	LATE	QR	2026-04-13 13:21:00	192.168.139.120	\N	\N	\N	\N	\N
8d589358-ec2d-4e64-88d2-7cff146a3056	d853d766-b1e0-4f7c-b236-11f7b1706f0f	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-04-14 13:24:00	192.168.232.198	\N	\N	\N	\N	\N
5ff32c3a-b5cb-41c6-af4d-acd929635566	d853d766-b1e0-4f7c-b236-11f7b1706f0f	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	QR	2026-04-14 16:24:00	192.168.123.2	\N	\N	\N	\N	\N
a2494ac5-6c96-4e50-8a9f-f32029470ca7	d853d766-b1e0-4f7c-b236-11f7b1706f0f	90b6848c-4a8e-447a-a391-b4fdf2fced42	JUSTIFIED	QR	2026-04-14 13:54:00	192.168.57.70	\N	\N	Cita médica	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-04-17 13:54:00
44b52db1-0f2b-4b0a-8d38-bed925dc487d	f7f7e72a-c360-4a1f-b760-74685eb2d04f	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-03-10 12:42:00	192.168.174.205	\N	\N	\N	\N	\N
55b22ae3-e500-4de0-aee6-568adcceea5e	f7f7e72a-c360-4a1f-b760-74685eb2d04f	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	QR	2026-03-10 14:58:00	192.168.33.252	\N	\N	\N	\N	\N
201abac9-c718-4587-aca7-56df5caacf4f	f7f7e72a-c360-4a1f-b760-74685eb2d04f	90b6848c-4a8e-447a-a391-b4fdf2fced42	LATE	QR	2026-03-10 13:37:00	192.168.145.170	\N	\N	\N	\N	\N
a985abbc-561e-4ebd-837d-53e6e12499be	243d4d6f-dd83-4b33-814e-1a2c079a3e37	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-04-07 09:55:00	192.168.119.47	\N	\N	\N	\N	\N
c4f55df3-8677-4e79-a6f2-ed27e46b3515	243d4d6f-dd83-4b33-814e-1a2c079a3e37	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	QR	2026-04-07 10:29:00	192.168.84.87	\N	\N	\N	\N	\N
eeb47eb1-1889-410f-9ae8-d45ae8493958	243d4d6f-dd83-4b33-814e-1a2c079a3e37	90b6848c-4a8e-447a-a391-b4fdf2fced42	ABSENT	QR	2026-04-07 13:16:00	192.168.214.21	\N	\N	\N	\N	\N
bbf79bad-23ea-4922-8363-19074438ae1b	3fb2a16c-41d1-4473-9c4e-b77e7ff52858	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-05-12 07:22:00	192.168.58.167	\N	\N	\N	\N	\N
b3b2cbf1-7b1b-40fb-a970-819275694d8c	3fb2a16c-41d1-4473-9c4e-b77e7ff52858	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	MANUAL	2026-05-12 07:48:00	192.168.8.244	\N	\N	\N	\N	\N
dac03233-4a30-4799-a9be-0705e6311d0e	3fb2a16c-41d1-4473-9c4e-b77e7ff52858	90b6848c-4a8e-447a-a391-b4fdf2fced42	PRESENT	MANUAL	2026-05-12 16:09:00	192.168.62.33	\N	\N	\N	\N	\N
047d9e58-6ce6-4776-a1bd-f8bc65c519b4	ab813360-d2af-4913-b6bc-c9f19c2200dc	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-03-31 10:29:00	192.168.180.66	\N	\N	\N	\N	\N
238d2251-b42b-492d-89ee-092707d986c6	ab813360-d2af-4913-b6bc-c9f19c2200dc	60312bc6-4b87-4433-b945-549246dab02c	ABSENT	QR	2026-03-31 16:47:00	192.168.184.30	\N	\N	\N	\N	\N
e9ab9337-5428-49bd-8cdf-e364d21bdf8b	ab813360-d2af-4913-b6bc-c9f19c2200dc	90b6848c-4a8e-447a-a391-b4fdf2fced42	ABSENT	QR	2026-03-31 11:06:00	192.168.149.7	\N	\N	\N	\N	\N
70b5d689-cf42-4ed2-a4b4-40e1c5c0d28d	d18a1d48-ced7-4b27-89be-5d8ff5ed602e	2fc60451-e195-4038-96f9-0fde54fe06e8	JUSTIFIED	QR	2026-03-03 13:25:00	192.168.27.179	\N	\N	Emergencia familiar	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-03-04 13:25:00
1b0dd3dd-00b7-4488-8009-098de47271af	d18a1d48-ced7-4b27-89be-5d8ff5ed602e	60312bc6-4b87-4433-b945-549246dab02c	ABSENT	MANUAL	2026-03-03 16:51:00	192.168.31.204	\N	\N	\N	\N	\N
291f560f-bda4-4ba7-a294-6ca233937325	d18a1d48-ced7-4b27-89be-5d8ff5ed602e	90b6848c-4a8e-447a-a391-b4fdf2fced42	JUSTIFIED	QR	2026-03-03 12:34:00	192.168.130.166	\N	\N	Cita médica	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-03-03 12:34:00
437c3ad6-498c-4f4a-b417-a5eeae928d07	319e1f66-cd45-455e-aaf9-a18ce70cfa5a	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	MANUAL	2026-05-05 14:06:00	192.168.111.246	\N	\N	\N	\N	\N
013bab05-7f03-4105-bb51-4e8414df0d9c	319e1f66-cd45-455e-aaf9-a18ce70cfa5a	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	MANUAL	2026-05-05 14:45:00	192.168.40.112	\N	\N	\N	\N	\N
9e79e07a-90ac-4c62-8ea2-f980c1fc3ebf	319e1f66-cd45-455e-aaf9-a18ce70cfa5a	90b6848c-4a8e-447a-a391-b4fdf2fced42	PRESENT	QR	2026-05-05 17:17:00	192.168.158.207	\N	\N	\N	\N	\N
ed52b5e0-ff87-4ffa-9858-deaf23ae514b	482af3f7-9985-49dd-9721-ce26cf567793	2fc60451-e195-4038-96f9-0fde54fe06e8	JUSTIFIED	QR	2026-03-24 14:27:00	192.168.213.240	\N	\N	Viaje personal	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-03-25 14:27:00
e1183bd4-93fc-4018-898a-4ad3e2d29a30	482af3f7-9985-49dd-9721-ce26cf567793	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	MANUAL	2026-03-24 10:48:00	192.168.119.146	\N	\N	\N	\N	\N
e478fcb8-6601-4db5-8613-f72f173b0cb6	482af3f7-9985-49dd-9721-ce26cf567793	90b6848c-4a8e-447a-a391-b4fdf2fced42	LATE	QR	2026-03-24 07:31:00	192.168.218.84	\N	\N	\N	\N	\N
e1bbcc22-8831-45d0-ba51-03120d2327e2	3eda2558-c0bb-4ba0-b8f3-24e13e90dc6d	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-03-25 11:21:00	192.168.72.226	\N	\N	\N	\N	\N
6545c549-5be2-4074-ab16-f125107b98aa	3eda2558-c0bb-4ba0-b8f3-24e13e90dc6d	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	MANUAL	2026-03-25 15:00:00	192.168.133.243	\N	\N	\N	\N	\N
0119dd72-251d-4c72-b692-0542b955f801	3eda2558-c0bb-4ba0-b8f3-24e13e90dc6d	90b6848c-4a8e-447a-a391-b4fdf2fced42	PRESENT	QR	2026-03-25 13:31:00	192.168.143.195	\N	\N	\N	\N	\N
5702ce54-643d-4694-a63a-bd3e6c0fa6e1	0d3ba0da-3af6-489b-b3fd-c9a7df9deec9	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-03-11 18:31:00	192.168.115.203	\N	\N	\N	\N	\N
4ed9d3d1-3a49-41c4-8f8d-62ff7fe02ec2	0d3ba0da-3af6-489b-b3fd-c9a7df9deec9	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	QR	2026-03-11 13:44:00	192.168.63.79	\N	\N	\N	\N	\N
e9cb88ee-76b6-4571-8c81-1508ce9e065a	0d3ba0da-3af6-489b-b3fd-c9a7df9deec9	90b6848c-4a8e-447a-a391-b4fdf2fced42	LATE	QR	2026-03-11 15:33:00	192.168.89.109	\N	\N	\N	\N	\N
52e45915-c77c-4fc8-9c9c-5c8acd8c608d	4ba08f61-4553-4da5-8fe4-4446b0ac48ab	2fc60451-e195-4038-96f9-0fde54fe06e8	JUSTIFIED	QR	2026-04-15 12:44:00	192.168.65.60	\N	\N	Cita médica	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-04-17 12:44:00
429e8bbd-ec65-483c-b79f-7dc84bbf8d82	4ba08f61-4553-4da5-8fe4-4446b0ac48ab	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	QR	2026-04-15 08:47:00	192.168.138.244	\N	\N	\N	\N	\N
30fd6497-1c36-4dc9-9a86-5364fd1cc9ef	4ba08f61-4553-4da5-8fe4-4446b0ac48ab	90b6848c-4a8e-447a-a391-b4fdf2fced42	ABSENT	QR	2026-04-15 10:47:00	192.168.124.71	\N	\N	\N	\N	\N
4352dea5-db5d-440a-9b62-7cc01497dc5d	995611ab-18f4-4c98-b6a3-a91ec0cd3e6e	2fc60451-e195-4038-96f9-0fde54fe06e8	LATE	MANUAL	2026-04-01 15:38:00	192.168.73.252	\N	\N	\N	\N	\N
263ec4e0-b785-4681-b409-c6fc88bfd78e	995611ab-18f4-4c98-b6a3-a91ec0cd3e6e	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	QR	2026-04-01 10:23:00	192.168.46.78	\N	\N	\N	\N	\N
552f05e1-f110-4aa0-9842-9efb182f8ac6	995611ab-18f4-4c98-b6a3-a91ec0cd3e6e	90b6848c-4a8e-447a-a391-b4fdf2fced42	PRESENT	QR	2026-04-01 11:02:00	192.168.250.14	\N	\N	\N	\N	\N
02bed79c-7d77-414e-bedd-08ed4639860c	6748b0a2-c503-49c0-9559-dc137b2ae243	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	QR	2026-04-22 09:40:00	192.168.223.193	\N	\N	\N	\N	\N
7d09f5d8-feae-4694-97a0-d3a7e0351659	6748b0a2-c503-49c0-9559-dc137b2ae243	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	MANUAL	2026-04-22 16:18:00	192.168.121.123	\N	\N	\N	\N	\N
d9bacb70-4ac2-4749-b007-a5318d1b29e2	6748b0a2-c503-49c0-9559-dc137b2ae243	90b6848c-4a8e-447a-a391-b4fdf2fced42	PRESENT	QR	2026-04-22 07:16:00	192.168.241.221	\N	\N	\N	\N	\N
31e8ef10-b59c-4009-b5ee-ac2c5a812cb8	b4aefea6-9810-4427-9323-e9f82b76b59a	2fc60451-e195-4038-96f9-0fde54fe06e8	PRESENT	MANUAL	2026-04-08 13:31:00	192.168.19.148	\N	\N	\N	\N	\N
260115ca-bf05-4e2d-87a5-a353da8b23fe	b4aefea6-9810-4427-9323-e9f82b76b59a	60312bc6-4b87-4433-b945-549246dab02c	LATE	QR	2026-04-08 09:51:00	192.168.145.243	\N	\N	\N	\N	\N
fbec0524-6dbf-435d-b78d-b1f99ba44dc4	b4aefea6-9810-4427-9323-e9f82b76b59a	90b6848c-4a8e-447a-a391-b4fdf2fced42	PRESENT	MANUAL	2026-04-08 08:35:00	192.168.196.107	\N	\N	\N	\N	\N
f32b76e8-55ef-4035-b2d8-b16234b8e285	7fafc2b2-c93e-4b41-ad53-336c19f321a3	2fc60451-e195-4038-96f9-0fde54fe06e8	LATE	QR	2026-05-20 10:49:00	192.168.134.98	\N	\N	\N	\N	\N
a6f3b6f5-22d3-44e7-bc06-2180b282a20a	7fafc2b2-c93e-4b41-ad53-336c19f321a3	60312bc6-4b87-4433-b945-549246dab02c	PRESENT	QR	2026-05-20 16:27:00	192.168.79.146	\N	\N	\N	\N	\N
18e133a8-67a5-4834-b2ad-16a22c53eb98	7fafc2b2-c93e-4b41-ad53-336c19f321a3	90b6848c-4a8e-447a-a391-b4fdf2fced42	LATE	QR	2026-05-20 18:06:00	192.168.243.196	\N	\N	\N	\N	\N
5bcfbfb1-e43b-45c5-a97d-76678e34fc6b	f7a2166b-b0da-4a97-97f2-170876ba8d23	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-04-13 17:05:00	192.168.41.62	\N	\N	\N	\N	\N
08a876af-fbce-41fb-b065-eff82bfd2977	f7a2166b-b0da-4a97-97f2-170876ba8d23	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	QR	2026-04-13 07:26:00	192.168.116.177	\N	\N	\N	\N	\N
daf11bf4-e0d7-4992-b3a9-b64133369e97	f7a2166b-b0da-4a97-97f2-170876ba8d23	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-04-13 10:18:00	192.168.181.73	\N	\N	\N	\N	\N
e4b57381-b598-4318-8c70-ebac130694ab	075fab53-ba08-49f5-84e3-7f8abc83e0d1	f513bdc6-4405-4051-a139-a9b2c156827e	LATE	QR	2026-03-30 17:14:00	192.168.237.68	\N	\N	\N	\N	\N
40be1485-e38a-421e-8819-ef8496a22974	075fab53-ba08-49f5-84e3-7f8abc83e0d1	78f3e5e9-1a20-4230-a0f1-8d6708510733	ABSENT	QR	2026-03-30 17:51:00	192.168.240.51	\N	\N	\N	\N	\N
afb46a46-0a8a-48ba-b513-04a1529d61ff	075fab53-ba08-49f5-84e3-7f8abc83e0d1	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-03-30 17:09:00	192.168.233.69	\N	\N	\N	\N	\N
87eb8367-9763-42ad-a5a0-8c724121b007	ac422110-f6f0-4d18-a782-c8d922794d64	f513bdc6-4405-4051-a139-a9b2c156827e	ABSENT	QR	2026-05-11 09:50:00	192.168.79.153	\N	\N	\N	\N	\N
e006dc40-0249-4886-9064-f8107044292e	ac422110-f6f0-4d18-a782-c8d922794d64	78f3e5e9-1a20-4230-a0f1-8d6708510733	LATE	QR	2026-05-11 11:28:00	192.168.32.120	\N	\N	\N	\N	\N
6f545b66-b65a-427e-aeeb-b43523da2dbd	ac422110-f6f0-4d18-a782-c8d922794d64	4bf30010-daaf-4197-9cce-c792742fabdd	LATE	QR	2026-05-11 11:32:00	192.168.139.127	\N	\N	\N	\N	\N
227d735f-9ec0-4c78-897e-fafb61aa7671	0cb129ed-9218-43d2-899c-3ac00328dd3c	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-04-27 13:47:00	192.168.83.155	\N	\N	\N	\N	\N
1ab0d200-c9f5-41de-8e53-b7e0cd930132	0cb129ed-9218-43d2-899c-3ac00328dd3c	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	QR	2026-04-27 17:53:00	192.168.221.148	\N	\N	\N	\N	\N
60671ef1-378d-4faa-877e-4071a74246cd	0cb129ed-9218-43d2-899c-3ac00328dd3c	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-04-27 17:52:00	192.168.69.148	\N	\N	\N	\N	\N
3d5d2516-8353-4840-b154-2196ae69f9d5	284aa7b6-c623-4888-bf87-40877c551106	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-03-23 14:33:00	192.168.167.114	\N	\N	\N	\N	\N
1bb1951b-de64-483c-9d61-9671043d3cb8	284aa7b6-c623-4888-bf87-40877c551106	78f3e5e9-1a20-4230-a0f1-8d6708510733	JUSTIFIED	QR	2026-03-23 16:27:00	192.168.90.105	\N	\N	Cita médica	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-03-26 16:27:00
2b90f97f-0132-42fd-beb0-c72bc73c7f78	284aa7b6-c623-4888-bf87-40877c551106	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-03-23 09:21:00	192.168.106.178	\N	\N	\N	\N	\N
d20a9e6f-ed12-463f-9072-6152105cea32	55f40303-7aff-4869-b852-37b13c820d09	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-04-06 13:52:00	192.168.195.141	\N	\N	\N	\N	\N
a1f6e320-8094-4068-98dc-9cf5fa0679eb	55f40303-7aff-4869-b852-37b13c820d09	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	QR	2026-04-06 11:20:00	192.168.30.249	\N	\N	\N	\N	\N
c4d54586-4ede-4d1c-9978-3131028504b5	55f40303-7aff-4869-b852-37b13c820d09	4bf30010-daaf-4197-9cce-c792742fabdd	ABSENT	MANUAL	2026-04-06 07:42:00	192.168.223.139	\N	\N	\N	\N	\N
e5a8ecfc-5e49-4cea-8f20-0597fc747e64	092e340b-d3e0-466d-8ba4-5fa35279888a	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-05-25 15:23:00	192.168.160.194	\N	\N	\N	\N	\N
45f8cca5-4e5d-431f-aae3-5b0aa7edd45f	092e340b-d3e0-466d-8ba4-5fa35279888a	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	QR	2026-05-25 07:13:00	192.168.69.141	\N	\N	\N	\N	\N
a0f5b8f9-9a27-4062-80a2-b2f2c621bf7e	092e340b-d3e0-466d-8ba4-5fa35279888a	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-05-25 18:31:00	192.168.32.8	\N	\N	\N	\N	\N
5d3b3664-a6b7-41a8-bd0f-a8e20d234711	132077ff-cfb9-4fa9-a712-f9ab8afb4d29	f513bdc6-4405-4051-a139-a9b2c156827e	JUSTIFIED	QR	2026-03-02 10:45:00	192.168.142.105	\N	\N	Emergencia familiar	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-03-02 10:45:00
ddedfa31-6766-4c56-9422-dd0a519ebc69	132077ff-cfb9-4fa9-a712-f9ab8afb4d29	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	MANUAL	2026-03-02 08:29:00	192.168.243.31	\N	\N	\N	\N	\N
c013b95d-80ce-470f-866e-1f2df7f6cb1b	132077ff-cfb9-4fa9-a712-f9ab8afb4d29	4bf30010-daaf-4197-9cce-c792742fabdd	LATE	QR	2026-03-02 18:18:00	192.168.131.181	\N	\N	\N	\N	\N
a9fa546b-52ff-4ae9-a436-ae53ed05fe62	151efe43-5300-4c1f-a395-8886de0b41d1	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	MANUAL	2026-04-28 14:15:00	192.168.117.142	\N	\N	\N	\N	\N
07bae203-bf95-453b-b914-2589e270e501	151efe43-5300-4c1f-a395-8886de0b41d1	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	QR	2026-04-28 16:32:00	192.168.192.226	\N	\N	\N	\N	\N
10f9e180-d083-4f0d-9626-51d555c1d3fa	151efe43-5300-4c1f-a395-8886de0b41d1	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-04-28 13:21:00	192.168.240.202	\N	\N	\N	\N	\N
253f266f-a668-4fc1-938e-6dcb76698758	b03072ca-3c5f-4a12-b331-edb682780e10	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	MANUAL	2026-05-26 11:46:00	192.168.77.215	\N	\N	\N	\N	\N
dda38cde-209b-4ade-bda9-c8c4fe986f91	b03072ca-3c5f-4a12-b331-edb682780e10	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	MANUAL	2026-05-26 14:55:00	192.168.39.115	\N	\N	\N	\N	\N
13429e54-b0e3-4669-b265-e6a7961ee970	b03072ca-3c5f-4a12-b331-edb682780e10	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-05-26 15:48:00	192.168.140.97	\N	\N	\N	\N	\N
d8582f15-e997-4f35-b181-27ad7ee15229	d5dd586a-a1a8-45c3-89d1-5b05a11e2b04	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-03-31 10:44:00	192.168.62.147	\N	\N	\N	\N	\N
e202d276-3111-42ef-9f24-6fcebc360b5e	d5dd586a-a1a8-45c3-89d1-5b05a11e2b04	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	MANUAL	2026-03-31 13:02:00	192.168.82.191	\N	\N	\N	\N	\N
33fe7958-c607-4390-92a3-8899c97928f7	d5dd586a-a1a8-45c3-89d1-5b05a11e2b04	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	MANUAL	2026-03-31 13:24:00	192.168.254.170	\N	\N	\N	\N	\N
71823f79-3708-4dc3-bf31-715aa566db2e	cfad4e4a-d6e9-48b9-9f05-d0d3c45096a3	f513bdc6-4405-4051-a139-a9b2c156827e	ABSENT	QR	2026-05-05 09:31:00	192.168.247.10	\N	\N	\N	\N	\N
f4653d43-c413-4ec3-aa2e-e4d19ba0538a	cfad4e4a-d6e9-48b9-9f05-d0d3c45096a3	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	MANUAL	2026-05-05 12:55:00	192.168.26.224	\N	\N	\N	\N	\N
027bfca7-6b41-4271-a3d9-e870a54196e0	cfad4e4a-d6e9-48b9-9f05-d0d3c45096a3	4bf30010-daaf-4197-9cce-c792742fabdd	ABSENT	QR	2026-05-05 14:00:00	192.168.185.37	\N	\N	\N	\N	\N
585fd098-9f20-467b-8705-2007b61443f9	0d22d998-cf80-468d-bfc4-fa4ef24a104e	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-04-14 09:04:00	192.168.121.201	\N	\N	\N	\N	\N
8d604d09-3c91-4f6f-91a3-fa2ad37d364b	0d22d998-cf80-468d-bfc4-fa4ef24a104e	78f3e5e9-1a20-4230-a0f1-8d6708510733	JUSTIFIED	QR	2026-04-14 18:25:00	192.168.245.82	\N	\N	Problemas de salud	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-04-17 18:25:00
f577481f-2f7f-46d8-822f-d1fbee193456	0d22d998-cf80-468d-bfc4-fa4ef24a104e	4bf30010-daaf-4197-9cce-c792742fabdd	LATE	MANUAL	2026-04-14 14:55:00	192.168.139.10	\N	\N	\N	\N	\N
7bf3feb3-f51e-48f4-9b66-a7678eae136a	f25f8af4-8078-4450-9871-bc2886a6a129	f513bdc6-4405-4051-a139-a9b2c156827e	LATE	QR	2026-05-19 17:58:00	192.168.74.59	\N	\N	\N	\N	\N
a04078c5-f2b3-4fb0-a3b2-afbe28845350	f25f8af4-8078-4450-9871-bc2886a6a129	78f3e5e9-1a20-4230-a0f1-8d6708510733	LATE	QR	2026-05-19 08:48:00	192.168.163.181	\N	\N	\N	\N	\N
0ac2468f-95a1-45da-9e0c-26a781eac867	f25f8af4-8078-4450-9871-bc2886a6a129	4bf30010-daaf-4197-9cce-c792742fabdd	ABSENT	QR	2026-05-19 18:19:00	192.168.232.8	\N	\N	\N	\N	\N
a137a839-4360-46a0-bd8a-937c27e3026f	c87fa6aa-2459-476d-8636-36d3a22cec8b	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-03-17 11:22:00	192.168.96.111	\N	\N	\N	\N	\N
73f52c4b-cae4-48db-9095-6d16cb6e98aa	c87fa6aa-2459-476d-8636-36d3a22cec8b	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	QR	2026-03-17 16:43:00	192.168.203.47	\N	\N	\N	\N	\N
ba52a6dd-eed2-4ac5-820b-33a2478d2d25	c87fa6aa-2459-476d-8636-36d3a22cec8b	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-03-17 13:39:00	192.168.175.62	\N	\N	\N	\N	\N
22e34872-13f8-4ce5-b39a-ec9b6c453147	1f835efa-537d-491c-a47f-e972d5ab71f1	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-05-06 10:29:00	192.168.164.66	\N	\N	\N	\N	\N
95a57c63-8803-4d99-b6c6-a76a3662db43	1f835efa-537d-491c-a47f-e972d5ab71f1	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	QR	2026-05-06 14:57:00	192.168.74.174	\N	\N	\N	\N	\N
393db446-89f3-4734-bf9c-cdae4f6dd0d8	1f835efa-537d-491c-a47f-e972d5ab71f1	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-05-06 12:37:00	192.168.77.164	\N	\N	\N	\N	\N
aa6d7c31-9476-41f6-9a6b-4716709db194	1a1a7b9a-76ec-41d3-9972-9e5cd4fa1b27	f513bdc6-4405-4051-a139-a9b2c156827e	JUSTIFIED	QR	2026-04-22 14:54:00	192.168.219.124	\N	\N	Viaje personal	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-04-25 14:54:00
58d60d81-b7ea-4ecb-9331-277cd5567044	1a1a7b9a-76ec-41d3-9972-9e5cd4fa1b27	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	QR	2026-04-22 12:36:00	192.168.76.180	\N	\N	\N	\N	\N
bf22a78b-d161-4722-b534-fd15024b6cbf	1a1a7b9a-76ec-41d3-9972-9e5cd4fa1b27	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	MANUAL	2026-04-22 17:25:00	192.168.71.3	\N	\N	\N	\N	\N
762f85a5-2c1a-4707-94e2-5891e7be4206	1a877ffd-a1b3-40a5-9eff-f94a541b714e	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-04-29 18:03:00	192.168.234.156	\N	\N	\N	\N	\N
9bb187e8-b794-413c-975d-1b67a3b62a16	1a877ffd-a1b3-40a5-9eff-f94a541b714e	78f3e5e9-1a20-4230-a0f1-8d6708510733	LATE	MANUAL	2026-04-29 11:49:00	192.168.205.59	\N	\N	\N	\N	\N
b61d125f-7766-43ef-8361-63a9c309ac24	1a877ffd-a1b3-40a5-9eff-f94a541b714e	4bf30010-daaf-4197-9cce-c792742fabdd	LATE	QR	2026-04-29 17:12:00	192.168.159.65	\N	\N	\N	\N	\N
72123fdc-a433-4a16-aed9-e0334b412da5	06086179-0d87-47d0-a1a6-4397c2b24a4e	f513bdc6-4405-4051-a139-a9b2c156827e	LATE	QR	2026-04-01 17:43:00	192.168.215.36	\N	\N	\N	\N	\N
2c252521-386c-4374-8d48-448ed4b8deea	06086179-0d87-47d0-a1a6-4397c2b24a4e	78f3e5e9-1a20-4230-a0f1-8d6708510733	LATE	MANUAL	2026-04-01 17:02:00	192.168.80.202	\N	\N	\N	\N	\N
26ccdc05-63ab-43f0-9be4-77f92666e929	06086179-0d87-47d0-a1a6-4397c2b24a4e	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-04-01 18:08:00	192.168.24.233	\N	\N	\N	\N	\N
10d46cc8-cacd-48a9-972a-cc90bfc67605	9fbcc8b6-0468-427a-a704-c0e5221cba2f	f513bdc6-4405-4051-a139-a9b2c156827e	PRESENT	QR	2026-05-13 09:12:00	192.168.34.202	\N	\N	\N	\N	\N
e852248c-84ff-4a61-9926-7eacde9b61e9	9fbcc8b6-0468-427a-a704-c0e5221cba2f	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	MANUAL	2026-05-13 15:32:00	192.168.234.70	\N	\N	\N	\N	\N
fc039f78-5388-4615-bb5d-409fc401ec7d	9fbcc8b6-0468-427a-a704-c0e5221cba2f	4bf30010-daaf-4197-9cce-c792742fabdd	ABSENT	QR	2026-05-13 14:51:00	192.168.76.192	\N	\N	\N	\N	\N
83898051-d493-4e4b-bcdf-8611aa93e424	d57f4431-9f66-43f7-811c-fc83533f67a5	f513bdc6-4405-4051-a139-a9b2c156827e	ABSENT	MANUAL	2026-03-04 14:04:00	192.168.37.194	\N	\N	\N	\N	\N
77e1f187-0a5e-49c9-a427-b6f11eb0a345	d57f4431-9f66-43f7-811c-fc83533f67a5	78f3e5e9-1a20-4230-a0f1-8d6708510733	JUSTIFIED	MANUAL	2026-03-04 18:43:00	192.168.203.102	\N	\N	Cita médica	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-03-04 18:43:00
3cfce9a3-4a27-4623-b715-79e67354941b	d57f4431-9f66-43f7-811c-fc83533f67a5	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-03-04 14:23:00	192.168.173.192	\N	\N	\N	\N	\N
22c138cc-3bd5-42c1-b503-492bfb40c985	89d4879a-0fb8-4a44-a716-865e27256976	f513bdc6-4405-4051-a139-a9b2c156827e	LATE	QR	2026-04-08 17:23:00	192.168.28.173	\N	\N	\N	\N	\N
7c5b2bb9-0aa0-4a46-9403-175ae7ddaa9e	89d4879a-0fb8-4a44-a716-865e27256976	78f3e5e9-1a20-4230-a0f1-8d6708510733	PRESENT	QR	2026-04-08 15:20:00	192.168.235.157	\N	\N	\N	\N	\N
8f0ef1b0-e0ca-4665-a7b4-e25314427117	89d4879a-0fb8-4a44-a716-865e27256976	4bf30010-daaf-4197-9cce-c792742fabdd	PRESENT	QR	2026-04-08 14:58:00	192.168.180.78	\N	\N	\N	\N	\N
97417bdf-dfb4-46ee-9914-14159bf27432	c3ba0c70-58d0-49fe-8c08-581228a1356e	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	LATE	QR	2026-03-09 07:02:00	192.168.78.127	\N	\N	\N	\N	\N
e2ebeb59-f912-49cf-88df-18b6c4abcc5b	c3ba0c70-58d0-49fe-8c08-581228a1356e	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-03-09 15:08:00	192.168.100.117	\N	\N	\N	\N	\N
fac8d25f-166a-48b3-883f-ef549227ea5e	c3ba0c70-58d0-49fe-8c08-581228a1356e	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	MANUAL	2026-03-09 18:34:00	192.168.108.151	\N	\N	\N	\N	\N
b4771c69-56a8-4583-ab07-7a5665b8b1ea	a3c4109e-e2f9-4292-85a8-3b60e61dc453	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	LATE	QR	2026-05-11 13:41:00	192.168.26.214	\N	\N	\N	\N	\N
ae302adb-edc1-4083-86af-60d458b50450	a3c4109e-e2f9-4292-85a8-3b60e61dc453	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-05-11 11:02:00	192.168.177.95	\N	\N	\N	\N	\N
e7712ec4-576f-406a-bec4-a1808118c113	a3c4109e-e2f9-4292-85a8-3b60e61dc453	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-05-11 10:54:00	192.168.93.26	\N	\N	\N	\N	\N
4d79b7b3-190d-4f46-9e1b-e0791106ef91	484ae03c-a8cf-49c0-aaca-cc366027f27b	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	JUSTIFIED	QR	2026-03-30 17:22:00	192.168.49.248	\N	\N	Problemas de salud	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-04-01 17:22:00
069bb564-db1c-4e17-aa99-53449d7ea7a2	484ae03c-a8cf-49c0-aaca-cc366027f27b	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	MANUAL	2026-03-30 14:05:00	192.168.170.55	\N	\N	\N	\N	\N
1c26cddb-f747-43bd-95cc-cd531519fd56	484ae03c-a8cf-49c0-aaca-cc366027f27b	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	LATE	QR	2026-03-30 07:03:00	192.168.202.86	\N	\N	\N	\N	\N
1f2a5aef-981d-443a-8ebe-138f704970f6	6cf894f4-8d8a-4e83-ac60-ab12cf5c9283	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-04-27 16:13:00	192.168.18.213	\N	\N	\N	\N	\N
1096dc6b-9271-4908-bbf5-181caf4d2db2	6cf894f4-8d8a-4e83-ac60-ab12cf5c9283	2b6abd12-6a83-4789-bf54-d577970897a1	ABSENT	QR	2026-04-27 10:52:00	192.168.223.60	\N	\N	\N	\N	\N
6158de7a-233f-406d-bb14-f78a5887d8f0	6cf894f4-8d8a-4e83-ac60-ab12cf5c9283	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-04-27 16:00:00	192.168.71.220	\N	\N	\N	\N	\N
e3038c60-d838-48c1-96c3-0d38fccfa9bd	d2b9fe66-1be4-4d63-9a0f-4b3468fd3756	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	JUSTIFIED	MANUAL	2026-03-23 15:16:00	192.168.34.4	\N	\N	Emergencia familiar	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-03-23 15:16:00
50e8987e-ba85-428c-bb62-a50ff1065cb7	d2b9fe66-1be4-4d63-9a0f-4b3468fd3756	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-03-23 16:20:00	192.168.5.45	\N	\N	\N	\N	\N
bab83bea-1b28-43e4-bdb6-6d641e547370	d2b9fe66-1be4-4d63-9a0f-4b3468fd3756	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-03-23 13:33:00	192.168.30.191	\N	\N	\N	\N	\N
19acfac1-eb4d-44d4-b79a-1cb980ffae54	54093705-f69a-4c03-9a43-a7441d0ab869	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-03-16 12:32:00	192.168.152.28	\N	\N	\N	\N	\N
84a87297-aeda-45d0-8dd5-68096f9f9724	54093705-f69a-4c03-9a43-a7441d0ab869	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-03-16 16:02:00	192.168.187.201	\N	\N	\N	\N	\N
81296835-7301-4c6a-aecb-95715d551d84	54093705-f69a-4c03-9a43-a7441d0ab869	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	JUSTIFIED	QR	2026-03-16 11:29:00	192.168.217.103	\N	\N	Problemas de salud	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-03-19 11:29:00
70c7cd2e-e757-4adb-bd8b-fc89cb3bed2e	f94a900b-bfde-4740-8d85-4fbffe492c86	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-04-20 18:58:00	192.168.114.19	\N	\N	\N	\N	\N
671a08d6-67d5-41b6-8a10-a97a3c2f5d91	f94a900b-bfde-4740-8d85-4fbffe492c86	2b6abd12-6a83-4789-bf54-d577970897a1	JUSTIFIED	QR	2026-04-20 09:04:00	192.168.98.153	\N	\N	Emergencia familiar	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-04-22 09:04:00
0572a860-02d8-4c55-bb1b-2a821284846e	f94a900b-bfde-4740-8d85-4fbffe492c86	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-04-20 16:27:00	192.168.26.204	\N	\N	\N	\N	\N
50ceb2d4-fba4-4fa4-bd89-240a9297927f	6a1fd541-41c0-4a19-98d0-c59cd8e75015	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	LATE	MANUAL	2026-05-25 17:56:00	192.168.197.142	\N	\N	\N	\N	\N
a2fab147-203b-41e0-9ef7-43fa634e8646	6a1fd541-41c0-4a19-98d0-c59cd8e75015	2b6abd12-6a83-4789-bf54-d577970897a1	LATE	QR	2026-05-25 14:56:00	192.168.59.106	\N	\N	\N	\N	\N
573abdf7-e4dd-47ca-93a5-1ce17a11374a	6a1fd541-41c0-4a19-98d0-c59cd8e75015	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-05-25 13:46:00	192.168.25.81	\N	\N	\N	\N	\N
88b605e8-6281-4fd2-ae71-a79beb777af8	322c60c5-51e9-4c86-a2fd-fbd089a0c9c6	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-03-10 12:09:00	192.168.176.237	\N	\N	\N	\N	\N
6d64f307-9499-401a-8fa7-d851fd6683de	322c60c5-51e9-4c86-a2fd-fbd089a0c9c6	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-03-10 08:05:00	192.168.111.25	\N	\N	\N	\N	\N
b22c2811-ebfa-4c4a-a2f7-20d463e8abd0	322c60c5-51e9-4c86-a2fd-fbd089a0c9c6	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	LATE	QR	2026-03-10 09:35:00	192.168.16.151	\N	\N	\N	\N	\N
64b4d6d1-6ae6-4b2e-8975-1dd5ca559d27	b6b1a3ca-001d-4d5b-91ac-a2a9d4eda911	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	JUSTIFIED	QR	2026-04-28 17:07:00	192.168.223.235	\N	\N	Cita médica	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-05-01 17:07:00
532a18f5-1a49-47ba-8794-323eebf43699	b6b1a3ca-001d-4d5b-91ac-a2a9d4eda911	2b6abd12-6a83-4789-bf54-d577970897a1	LATE	MANUAL	2026-04-28 16:19:00	192.168.91.27	\N	\N	\N	\N	\N
21fa589e-583b-4ea6-a48a-a4f80e185c17	b6b1a3ca-001d-4d5b-91ac-a2a9d4eda911	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-04-28 17:30:00	192.168.58.217	\N	\N	\N	\N	\N
1b362e9d-e313-48ea-90b1-7c85e8b8b411	a9af1500-bd74-4e18-b2c2-552b0d64f0e6	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	MANUAL	2026-03-17 12:07:00	192.168.196.72	\N	\N	\N	\N	\N
07ba76fa-0084-41ee-a14c-ce59ed473a56	a9af1500-bd74-4e18-b2c2-552b0d64f0e6	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	MANUAL	2026-03-17 15:49:00	192.168.210.160	\N	\N	\N	\N	\N
2a88c601-861d-4537-92cd-8502d206a6ef	a9af1500-bd74-4e18-b2c2-552b0d64f0e6	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	LATE	QR	2026-03-17 07:38:00	192.168.238.169	\N	\N	\N	\N	\N
51241dac-7eca-411d-bad6-9b86b839d8bc	44695009-c2f5-40ef-a79f-69d62c64f342	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	ABSENT	QR	2026-05-12 09:17:00	192.168.180.196	\N	\N	\N	\N	\N
a6c72fa9-636c-4ee1-ae70-e0dbf2df7636	44695009-c2f5-40ef-a79f-69d62c64f342	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-05-12 07:11:00	192.168.223.37	\N	\N	\N	\N	\N
22a474e5-d31d-48be-82a4-7aa8329a2b07	44695009-c2f5-40ef-a79f-69d62c64f342	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-05-12 09:47:00	192.168.163.249	\N	\N	\N	\N	\N
c650b26c-a87c-404d-a74b-1805f4a77291	0efe0b1f-4876-44ed-916a-0deed4b86116	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-04-21 10:24:00	192.168.108.117	\N	\N	\N	\N	\N
44ce0c9b-0a38-4990-8937-16075db83fe9	0efe0b1f-4876-44ed-916a-0deed4b86116	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-04-21 18:20:00	192.168.199.242	\N	\N	\N	\N	\N
eb2f8a34-6a15-4e5e-8b3f-88a0e80a3cbd	0efe0b1f-4876-44ed-916a-0deed4b86116	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-04-21 07:09:00	192.168.41.194	\N	\N	\N	\N	\N
1080fbb0-647b-49c5-8f11-41f02cd8c8cb	8a2ea0e5-5159-4a09-889e-da59552da5b9	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	LATE	QR	2026-05-05 11:28:00	192.168.170.109	\N	\N	\N	\N	\N
35866177-ffed-47d4-9a77-d43a642194b1	8a2ea0e5-5159-4a09-889e-da59552da5b9	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-05-05 11:13:00	192.168.194.132	\N	\N	\N	\N	\N
8e207a2a-6a02-4c0e-a44b-7b6491e95ca4	8a2ea0e5-5159-4a09-889e-da59552da5b9	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-05-05 11:43:00	192.168.174.152	\N	\N	\N	\N	\N
ab30a2bf-055c-4b22-83fd-b77241926ba9	6414bd69-ff96-4117-bc23-50745ecb8eb0	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-05-19 07:14:00	192.168.102.253	\N	\N	\N	\N	\N
515d42ac-8636-4c73-a5ad-6414ed8f1da7	6414bd69-ff96-4117-bc23-50745ecb8eb0	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-05-19 11:13:00	192.168.197.36	\N	\N	\N	\N	\N
cc55eafe-fc67-4802-95dd-ddf9a3322c9e	6414bd69-ff96-4117-bc23-50745ecb8eb0	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	ABSENT	QR	2026-05-19 08:00:00	192.168.128.192	\N	\N	\N	\N	\N
8219fe2f-af15-4c22-8bc8-0e144bebc9c4	b9933c8f-6af0-4b3c-ac9b-a7f166f2a4b2	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-03-25 15:45:00	192.168.59.129	\N	\N	\N	\N	\N
d3ffc750-57c8-45da-9d14-0ea039286eb2	b9933c8f-6af0-4b3c-ac9b-a7f166f2a4b2	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-03-25 12:04:00	192.168.102.221	\N	\N	\N	\N	\N
bea18fd1-dfe0-46f0-b792-a97033cbcafa	b9933c8f-6af0-4b3c-ac9b-a7f166f2a4b2	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	LATE	QR	2026-03-25 14:58:00	192.168.20.221	\N	\N	\N	\N	\N
a32c8048-d149-47a2-99ec-4985cfc3fc68	2febcbb7-e35b-4fa0-81d1-610bb8d0a0d8	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-05-27 13:45:00	192.168.164.107	\N	\N	\N	\N	\N
24ad77f9-0f48-41ac-a464-747b3f7e16c3	2febcbb7-e35b-4fa0-81d1-610bb8d0a0d8	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-05-27 12:10:00	192.168.206.243	\N	\N	\N	\N	\N
ee058a42-f4a2-4e15-bc6f-f08ab06012e1	2febcbb7-e35b-4fa0-81d1-610bb8d0a0d8	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	LATE	MANUAL	2026-05-27 12:05:00	192.168.112.217	\N	\N	\N	\N	\N
b44ea0d8-efb4-4a60-86ae-cd3e25694eb1	863cc6ef-37cd-4922-89a3-42d0340abea6	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-03-11 13:33:00	192.168.21.102	\N	\N	\N	\N	\N
59ea9e85-61d5-4947-a343-ecbe01ede676	863cc6ef-37cd-4922-89a3-42d0340abea6	2b6abd12-6a83-4789-bf54-d577970897a1	ABSENT	QR	2026-03-11 10:21:00	192.168.200.44	\N	\N	\N	\N	\N
6c93d7ab-6151-49a9-983c-075936997d0e	863cc6ef-37cd-4922-89a3-42d0340abea6	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-03-11 15:32:00	192.168.50.232	\N	\N	\N	\N	\N
ceec5326-eb05-4016-a2f3-73553872ddae	2767806c-764c-4a57-b40a-d46709dc05be	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	ABSENT	QR	2026-04-08 17:52:00	192.168.38.61	\N	\N	\N	\N	\N
2e83dd38-627c-4893-b38d-c219691d2436	2767806c-764c-4a57-b40a-d46709dc05be	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-04-08 09:38:00	192.168.40.195	\N	\N	\N	\N	\N
51867a94-f69f-4741-98b0-5ae179a87432	2767806c-764c-4a57-b40a-d46709dc05be	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	ABSENT	QR	2026-04-08 17:31:00	192.168.119.194	\N	\N	\N	\N	\N
d3346c6d-2f8c-4074-9e3e-0b32a1eb4916	bf07d702-4af6-4a2b-81d8-343bd50918c9	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-03-04 17:59:00	192.168.226.145	\N	\N	\N	\N	\N
a3b93af5-a825-43f2-ad79-0edc6253c267	bf07d702-4af6-4a2b-81d8-343bd50918c9	2b6abd12-6a83-4789-bf54-d577970897a1	LATE	MANUAL	2026-03-04 12:55:00	192.168.249.161	\N	\N	\N	\N	\N
a1fb8a95-5afb-4307-b849-49995b8cdcd7	bf07d702-4af6-4a2b-81d8-343bd50918c9	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	PRESENT	QR	2026-03-04 14:28:00	192.168.162.78	\N	\N	\N	\N	\N
d6b87399-2369-46e7-a330-51b29f23b0b0	895ff08e-837e-4e19-8f95-e4fc1aeb9c78	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	ABSENT	QR	2026-05-20 12:32:00	192.168.19.80	\N	\N	\N	\N	\N
22461960-a973-4985-b64f-8b305f849456	895ff08e-837e-4e19-8f95-e4fc1aeb9c78	2b6abd12-6a83-4789-bf54-d577970897a1	PRESENT	QR	2026-05-20 12:53:00	192.168.74.20	\N	\N	\N	\N	\N
89a97381-5969-4113-9263-e208e2a379c0	895ff08e-837e-4e19-8f95-e4fc1aeb9c78	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	LATE	MANUAL	2026-05-20 08:39:00	192.168.153.130	\N	\N	\N	\N	\N
1fe80810-dd95-445d-848f-57dffed33e50	b147877b-6080-4c42-92f2-0d2a02f11de7	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	PRESENT	QR	2026-04-01 18:57:00	192.168.11.116	\N	\N	\N	\N	\N
ed549930-efaa-4338-9a7a-eeb79a8f9a28	b147877b-6080-4c42-92f2-0d2a02f11de7	2b6abd12-6a83-4789-bf54-d577970897a1	JUSTIFIED	QR	2026-04-01 10:20:00	192.168.116.27	\N	\N	Cita médica	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-04-01 10:20:00
5d9259d9-5f3d-4ea9-821d-b17c1fd79c28	b147877b-6080-4c42-92f2-0d2a02f11de7	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	ABSENT	MANUAL	2026-04-01 18:05:00	192.168.130.166	\N	\N	\N	\N	\N
8a99368d-cdf4-458f-9636-bc16fef334d3	50471ae4-c3aa-41ea-b6d7-d65e5a6560a0	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-03-23 14:28:00	192.168.135.134	\N	\N	\N	\N	\N
30b33d76-69df-4764-b4e4-83fdf7a987d9	50471ae4-c3aa-41ea-b6d7-d65e5a6560a0	f63c1fcf-9552-474d-836b-b77bfdcae1ce	LATE	QR	2026-03-23 11:24:00	192.168.105.199	\N	\N	\N	\N	\N
b136c836-b069-469c-be2a-224b4bc984af	50471ae4-c3aa-41ea-b6d7-d65e5a6560a0	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-03-23 17:41:00	192.168.86.17	\N	\N	\N	\N	\N
a801611c-17fc-43bd-a110-529b61d208ac	8d1e380b-5d6e-442f-945d-2d25cd387704	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-04-27 13:18:00	192.168.65.186	\N	\N	\N	\N	\N
5b366404-6206-40cf-b9b8-9ff9db1cac67	8d1e380b-5d6e-442f-945d-2d25cd387704	f63c1fcf-9552-474d-836b-b77bfdcae1ce	ABSENT	MANUAL	2026-04-27 16:55:00	192.168.39.86	\N	\N	\N	\N	\N
ba131f6f-cfc2-41ee-9210-650233709862	8d1e380b-5d6e-442f-945d-2d25cd387704	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-04-27 12:19:00	192.168.248.168	\N	\N	\N	\N	\N
d0c2ba24-5656-41f9-b2ee-a740da6c7719	991b9881-9eeb-4219-b775-8a619db978d2	af583bcf-eeaa-451d-988d-987d293cb523	LATE	QR	2026-03-16 16:45:00	192.168.241.22	\N	\N	\N	\N	\N
9a4538c3-e94f-4397-b256-fa690dd9fe54	991b9881-9eeb-4219-b775-8a619db978d2	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-03-16 12:52:00	192.168.33.172	\N	\N	\N	\N	\N
2f103cd8-ffda-4d79-bad4-616bcdad294d	991b9881-9eeb-4219-b775-8a619db978d2	d88bf4a1-0278-4023-a674-0faa04857eb6	LATE	MANUAL	2026-03-16 17:58:00	192.168.135.24	\N	\N	\N	\N	\N
c19cce20-6207-4bb1-ac52-8fd50bbbf10c	0a242ff4-ba4d-444d-a1df-64de5fb63339	af583bcf-eeaa-451d-988d-987d293cb523	LATE	QR	2026-05-04 12:01:00	192.168.93.80	\N	\N	\N	\N	\N
c4275de9-b661-4bc3-b531-31d0c7dc6ee0	0a242ff4-ba4d-444d-a1df-64de5fb63339	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-05-04 14:12:00	192.168.58.36	\N	\N	\N	\N	\N
37e61542-96b6-46e2-a317-92e93757946d	0a242ff4-ba4d-444d-a1df-64de5fb63339	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-05-04 08:32:00	192.168.198.139	\N	\N	\N	\N	\N
e29f8db0-bd35-4d99-a42e-79974feee59b	ea2b68e9-24f1-4faf-858b-b3501c79ac30	af583bcf-eeaa-451d-988d-987d293cb523	ABSENT	MANUAL	2026-04-20 07:42:00	192.168.87.225	\N	\N	\N	\N	\N
18aaf01c-9464-4c5f-894b-3ea5e184f210	ea2b68e9-24f1-4faf-858b-b3501c79ac30	f63c1fcf-9552-474d-836b-b77bfdcae1ce	ABSENT	QR	2026-04-20 13:09:00	192.168.42.47	\N	\N	\N	\N	\N
77a09e01-dc39-4161-b4b9-12e9ba3eb4b0	ea2b68e9-24f1-4faf-858b-b3501c79ac30	d88bf4a1-0278-4023-a674-0faa04857eb6	ABSENT	QR	2026-04-20 09:46:00	192.168.113.12	\N	\N	\N	\N	\N
b407572e-44c6-45f3-98a1-0499f85f891d	7ef6dd06-7f81-42ea-9abb-c3487a751076	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-05-25 10:28:00	192.168.157.73	\N	\N	\N	\N	\N
56a41c43-071c-4044-b44f-6b7a9d8021cf	7ef6dd06-7f81-42ea-9abb-c3487a751076	f63c1fcf-9552-474d-836b-b77bfdcae1ce	ABSENT	QR	2026-05-25 10:34:00	192.168.62.80	\N	\N	\N	\N	\N
3070f898-b62e-4bab-b938-329e0a50d62d	7ef6dd06-7f81-42ea-9abb-c3487a751076	d88bf4a1-0278-4023-a674-0faa04857eb6	JUSTIFIED	QR	2026-05-25 10:23:00	192.168.200.98	\N	\N	Cita médica	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-05-27 10:23:00
a48ce8c6-1a4b-420f-a7ab-61b5cddc218e	36ce13ce-bfdb-48e4-bfc6-512493a9c1bf	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-04-13 09:52:00	192.168.52.206	\N	\N	\N	\N	\N
5fb4cb57-cfef-49a8-ab24-005ea040ebd2	36ce13ce-bfdb-48e4-bfc6-512493a9c1bf	f63c1fcf-9552-474d-836b-b77bfdcae1ce	LATE	MANUAL	2026-04-13 07:41:00	192.168.124.224	\N	\N	\N	\N	\N
1d4e3b9b-c490-4b8c-bd97-cf16ca4bb8ef	36ce13ce-bfdb-48e4-bfc6-512493a9c1bf	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	MANUAL	2026-04-13 18:54:00	192.168.133.218	\N	\N	\N	\N	\N
fff688d2-4da7-41d3-a9dc-537e8cf7546d	36700e99-401d-4a67-bff6-791838c4d586	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-05-18 09:17:00	192.168.116.232	\N	\N	\N	\N	\N
6d33b07c-f332-4f7a-89ca-9057ec5ddb02	36700e99-401d-4a67-bff6-791838c4d586	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	MANUAL	2026-05-18 08:58:00	192.168.57.210	\N	\N	\N	\N	\N
97e21007-05b8-4473-a9d4-74aad961e67b	36700e99-401d-4a67-bff6-791838c4d586	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-05-18 07:26:00	192.168.14.102	\N	\N	\N	\N	\N
060c7ea2-9ee5-4ec0-8556-f81243aa0fcd	dbce3bea-5813-4083-90b7-ba6fe9c88609	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-05-26 08:23:00	192.168.58.8	\N	\N	\N	\N	\N
0873007d-c3e0-4dd4-98b9-ba7d29589fb0	dbce3bea-5813-4083-90b7-ba6fe9c88609	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-05-26 18:41:00	192.168.86.203	\N	\N	\N	\N	\N
09f1a699-1422-42d6-838f-82e41c29cd85	dbce3bea-5813-4083-90b7-ba6fe9c88609	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-05-26 14:44:00	192.168.213.36	\N	\N	\N	\N	\N
98a5db10-885f-41aa-881e-dc1549aee68e	dff1bc36-98c3-4e7b-a9d3-471bf6164ef0	af583bcf-eeaa-451d-988d-987d293cb523	ABSENT	QR	2026-03-10 16:00:00	192.168.232.21	\N	\N	\N	\N	\N
6dafc325-7bce-43c2-8cfa-8687fa18bcd5	dff1bc36-98c3-4e7b-a9d3-471bf6164ef0	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-03-10 09:35:00	192.168.241.187	\N	\N	\N	\N	\N
2a807d0c-5f3c-47f1-a535-f162bbbcbfe6	dff1bc36-98c3-4e7b-a9d3-471bf6164ef0	d88bf4a1-0278-4023-a674-0faa04857eb6	LATE	QR	2026-03-10 11:15:00	192.168.78.32	\N	\N	\N	\N	\N
9efeba46-5053-443b-abef-c89c4372a93d	75e02e2c-e932-4d94-b0c8-3f2d8ac52cd7	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-03-24 16:29:00	192.168.17.29	\N	\N	\N	\N	\N
694e5e05-7140-4a5a-bcb7-30253dc16dc5	75e02e2c-e932-4d94-b0c8-3f2d8ac52cd7	f63c1fcf-9552-474d-836b-b77bfdcae1ce	ABSENT	QR	2026-03-24 15:01:00	192.168.162.132	\N	\N	\N	\N	\N
a344ed64-b574-486d-abbe-bc288f2d97fa	75e02e2c-e932-4d94-b0c8-3f2d8ac52cd7	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-03-24 11:27:00	192.168.1.158	\N	\N	\N	\N	\N
eb99c74e-cfc9-4335-9b4a-c766b3c393d8	9824169e-6124-429c-9b62-d29f5103f2b3	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-05-12 09:42:00	192.168.172.22	\N	\N	\N	\N	\N
2f478c5f-58d8-46b5-99c7-c2a545116cbc	9824169e-6124-429c-9b62-d29f5103f2b3	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-05-12 15:34:00	192.168.130.202	\N	\N	\N	\N	\N
d4977b53-f4ec-4313-8f6d-323591daf4cf	9824169e-6124-429c-9b62-d29f5103f2b3	d88bf4a1-0278-4023-a674-0faa04857eb6	JUSTIFIED	QR	2026-05-12 13:55:00	192.168.252.96	\N	\N	Cita médica	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-05-15 13:55:00
4e26bec9-8860-48c2-a8e7-e65ffaf88a2f	7762e6c1-2bd3-4c82-b1ee-c98d7f881b63	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-05-05 08:22:00	192.168.62.188	\N	\N	\N	\N	\N
c65637b8-bb02-4190-aa8c-61fc8109dea1	7762e6c1-2bd3-4c82-b1ee-c98d7f881b63	f63c1fcf-9552-474d-836b-b77bfdcae1ce	LATE	QR	2026-05-05 16:47:00	192.168.194.86	\N	\N	\N	\N	\N
c8913fa4-363f-4316-9745-e40a85f4bacf	7762e6c1-2bd3-4c82-b1ee-c98d7f881b63	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-05-05 12:52:00	192.168.165.45	\N	\N	\N	\N	\N
efe03a3b-719f-4ce3-88ca-f9bc2d74b6ad	6fd294e3-d165-4488-9739-2ea791a0b54a	af583bcf-eeaa-451d-988d-987d293cb523	ABSENT	QR	2026-04-21 18:30:00	192.168.162.47	\N	\N	\N	\N	\N
bc0a2115-aef1-41ea-872b-974840ba9523	6fd294e3-d165-4488-9739-2ea791a0b54a	f63c1fcf-9552-474d-836b-b77bfdcae1ce	ABSENT	QR	2026-04-21 14:02:00	192.168.76.52	\N	\N	\N	\N	\N
eb585ca5-1b23-4a65-8806-addd4b2f5159	6fd294e3-d165-4488-9739-2ea791a0b54a	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-04-21 07:20:00	192.168.239.80	\N	\N	\N	\N	\N
56adec2b-d54d-41e3-9b4a-9f361751c49d	42aaf634-be7d-43fc-b765-809862f6036d	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	MANUAL	2026-05-19 15:30:00	192.168.65.10	\N	\N	\N	\N	\N
34f56c4a-cf12-462f-b985-d4a6acfd6c3f	42aaf634-be7d-43fc-b765-809862f6036d	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-05-19 12:55:00	192.168.200.13	\N	\N	\N	\N	\N
f36eff32-7089-4ad3-a8b7-fd97cc468cab	42aaf634-be7d-43fc-b765-809862f6036d	d88bf4a1-0278-4023-a674-0faa04857eb6	ABSENT	QR	2026-05-19 08:51:00	192.168.95.112	\N	\N	\N	\N	\N
0b70d887-18ed-4e5e-ae20-c877ac5fc7e5	4e0c525a-4835-4aea-8a5e-7cc6ad9697f9	af583bcf-eeaa-451d-988d-987d293cb523	JUSTIFIED	QR	2026-04-22 13:21:00	192.168.95.237	\N	\N	Emergencia familiar	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-04-25 13:21:00
c37a4d6a-58d2-4258-86c8-1d9dc24dd9f4	4e0c525a-4835-4aea-8a5e-7cc6ad9697f9	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-04-22 08:46:00	192.168.109.21	\N	\N	\N	\N	\N
40bc7f5c-a213-447b-834d-04402738583a	4e0c525a-4835-4aea-8a5e-7cc6ad9697f9	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	MANUAL	2026-04-22 09:34:00	192.168.76.83	\N	\N	\N	\N	\N
a5e25e99-85a4-47ba-b682-2f15d1107cf6	6a82503f-dd01-4a88-8973-a8ad44605c69	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-03-25 11:19:00	192.168.115.155	\N	\N	\N	\N	\N
7128a425-f184-4103-861d-39ca3afe6171	6a82503f-dd01-4a88-8973-a8ad44605c69	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-03-25 14:22:00	192.168.115.11	\N	\N	\N	\N	\N
436ab16c-b7eb-47e4-a12e-f68bbe8d738a	6a82503f-dd01-4a88-8973-a8ad44605c69	d88bf4a1-0278-4023-a674-0faa04857eb6	LATE	MANUAL	2026-03-25 16:27:00	192.168.71.164	\N	\N	\N	\N	\N
d3f6a939-bcf1-4957-86c1-b2d2ad645a9d	f5524a32-0a7b-4f1e-b8c7-a9a5a7d3fb82	af583bcf-eeaa-451d-988d-987d293cb523	JUSTIFIED	MANUAL	2026-04-15 08:42:00	192.168.244.8	\N	\N	Cita médica	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-04-16 08:42:00
1b7d0f79-955b-4283-ade1-9c52de0d540e	f5524a32-0a7b-4f1e-b8c7-a9a5a7d3fb82	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-04-15 14:02:00	192.168.33.18	\N	\N	\N	\N	\N
3b54adcf-d990-4b2a-ac6a-0ddc46f86049	f5524a32-0a7b-4f1e-b8c7-a9a5a7d3fb82	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-04-15 12:24:00	192.168.244.146	\N	\N	\N	\N	\N
c26f4660-fe1e-4345-98ca-d4cf963f5370	169e2b2f-85dd-4175-8c69-66a3dd7127f0	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-03-04 14:23:00	192.168.96.114	\N	\N	\N	\N	\N
eeddcd3e-f9cf-46d3-b810-143d5da879f8	169e2b2f-85dd-4175-8c69-66a3dd7127f0	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-03-04 15:23:00	192.168.102.81	\N	\N	\N	\N	\N
09148aa7-5adc-451e-96f0-9b3bdd2f3fd4	169e2b2f-85dd-4175-8c69-66a3dd7127f0	d88bf4a1-0278-4023-a674-0faa04857eb6	LATE	QR	2026-03-04 08:01:00	192.168.189.48	\N	\N	\N	\N	\N
c84b9ed3-d538-4dcb-8b53-4846606d0ad2	193922b1-9df4-4be9-aa99-c6fddca667ef	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-03-18 15:07:00	192.168.68.199	\N	\N	\N	\N	\N
a19100d1-0d13-4682-9da9-e8916d204c96	193922b1-9df4-4be9-aa99-c6fddca667ef	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-03-18 16:18:00	192.168.178.235	\N	\N	\N	\N	\N
980ebe9a-6c2d-434b-b522-7b644e40a2eb	193922b1-9df4-4be9-aa99-c6fddca667ef	d88bf4a1-0278-4023-a674-0faa04857eb6	JUSTIFIED	QR	2026-03-18 09:54:00	192.168.231.183	\N	\N	Problemas de salud	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-03-19 09:54:00
ee3fbfd8-86a8-4be6-9f4d-3b849d2ed384	f9ba474d-83ee-45aa-b0e3-2c774ecb3236	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-05-13 17:54:00	192.168.253.82	\N	\N	\N	\N	\N
b05cc045-6887-48ad-8e2d-1bc7f97a7250	f9ba474d-83ee-45aa-b0e3-2c774ecb3236	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-05-13 15:34:00	192.168.75.229	\N	\N	\N	\N	\N
b061da81-7f87-4aa4-8ab8-e50f1411331e	f9ba474d-83ee-45aa-b0e3-2c774ecb3236	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-05-13 18:59:00	192.168.180.164	\N	\N	\N	\N	\N
5d2ee843-3ef6-415f-aa01-668433bc0f59	63af7991-7ce7-42c4-a7f8-664c695acc7a	af583bcf-eeaa-451d-988d-987d293cb523	PRESENT	QR	2026-05-06 10:07:00	192.168.253.52	\N	\N	\N	\N	\N
e7a06922-82ef-43a7-a166-3a0850ad0811	63af7991-7ce7-42c4-a7f8-664c695acc7a	f63c1fcf-9552-474d-836b-b77bfdcae1ce	PRESENT	QR	2026-05-06 14:01:00	192.168.93.142	\N	\N	\N	\N	\N
cca7726c-2c2c-4064-9f9c-80e00cfbe2ba	63af7991-7ce7-42c4-a7f8-664c695acc7a	d88bf4a1-0278-4023-a674-0faa04857eb6	PRESENT	QR	2026-05-06 15:08:00	192.168.157.227	\N	\N	\N	\N	\N
971b474a-52e9-4f6b-aab3-30fd0563c426	0cc7d669-3891-426f-b7eb-3c62ee2e75f8	af1756ba-1982-4621-9340-1528c61ce0e2	PRESENT	QR	2026-05-18 18:46:00	192.168.123.135	\N	\N	\N	\N	\N
2f6cc998-2bcc-43bf-9fc1-cdb428be62f2	0cc7d669-3891-426f-b7eb-3c62ee2e75f8	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	QR	2026-05-18 16:04:00	192.168.33.249	\N	\N	\N	\N	\N
14e6b280-62ea-42f7-8c2b-4d97b6e5e956	b3c6b239-cfa1-44cf-8674-f52919b08e39	af1756ba-1982-4621-9340-1528c61ce0e2	PRESENT	QR	2026-04-06 14:43:00	192.168.133.89	\N	\N	\N	\N	\N
a8b78f14-e0b3-42fa-8a8c-be4216d59782	b3c6b239-cfa1-44cf-8674-f52919b08e39	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	MANUAL	2026-04-06 15:40:00	192.168.151.47	\N	\N	\N	\N	\N
e088497c-9287-48a4-82b8-68360e49f872	ec2bacfc-5eae-4647-8025-bc672c840a84	af1756ba-1982-4621-9340-1528c61ce0e2	ABSENT	QR	2026-03-02 15:58:00	192.168.223.15	\N	\N	\N	\N	\N
e8402a3d-51d9-485f-8493-d9cf23ca2205	ec2bacfc-5eae-4647-8025-bc672c840a84	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	ABSENT	QR	2026-03-02 11:10:00	192.168.42.83	\N	\N	\N	\N	\N
72d97848-c322-48d4-9640-abf7217aad05	557ed8ca-4785-4fb1-9f9b-731ccaadfbeb	af1756ba-1982-4621-9340-1528c61ce0e2	JUSTIFIED	QR	2026-05-11 15:57:00	192.168.51.163	\N	\N	Viaje personal	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-05-13 15:57:00
3b191e54-2beb-4b60-adb6-c5254c2ee50b	557ed8ca-4785-4fb1-9f9b-731ccaadfbeb	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	JUSTIFIED	QR	2026-05-11 17:19:00	192.168.44.169	\N	\N	Problemas de salud	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-05-12 17:19:00
897e9ec5-b68a-422f-8b83-c5424a9964ff	b7b1dbf5-8844-4f27-a448-15a325ff4d55	af1756ba-1982-4621-9340-1528c61ce0e2	LATE	MANUAL	2026-04-20 12:53:00	192.168.237.145	\N	\N	\N	\N	\N
68327f03-e61e-4f6b-b5ff-3137ee790063	b7b1dbf5-8844-4f27-a448-15a325ff4d55	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	MANUAL	2026-04-20 08:02:00	192.168.243.165	\N	\N	\N	\N	\N
6ea0beb8-f63e-4cc5-a625-56c1ee57b10d	7cc47342-9473-44db-a2e0-6a2d88263655	af1756ba-1982-4621-9340-1528c61ce0e2	ABSENT	QR	2026-03-16 10:49:00	192.168.147.107	\N	\N	\N	\N	\N
937a614d-5374-409b-bbcf-3d55dc1a0928	7cc47342-9473-44db-a2e0-6a2d88263655	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	LATE	QR	2026-03-16 17:34:00	192.168.75.165	\N	\N	\N	\N	\N
80801d42-d115-47e9-b78f-b0abcb28bea3	a55c877f-fc65-4167-b0f8-7fe48453029c	af1756ba-1982-4621-9340-1528c61ce0e2	JUSTIFIED	QR	2026-05-04 17:25:00	192.168.177.16	\N	\N	Viaje personal	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-05-04 17:25:00
1833ee99-d7be-48f9-8b25-629639881196	a55c877f-fc65-4167-b0f8-7fe48453029c	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	QR	2026-05-04 14:13:00	192.168.88.156	\N	\N	\N	\N	\N
dd2c2683-8de3-41f8-be68-0b38bc809b00	af4ff1e1-74f0-4a89-8058-375475011007	af1756ba-1982-4621-9340-1528c61ce0e2	PRESENT	MANUAL	2026-03-30 12:46:00	192.168.253.221	\N	\N	\N	\N	\N
ae63a3ad-4e76-47b8-98da-35fe321c6ce8	af4ff1e1-74f0-4a89-8058-375475011007	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	QR	2026-03-30 12:32:00	192.168.144.28	\N	\N	\N	\N	\N
06c27398-50f3-4ac2-b737-9d6f91f2725d	4ee08b9b-4dd6-45c6-83d4-5c94db060f2a	af1756ba-1982-4621-9340-1528c61ce0e2	PRESENT	QR	2026-05-12 11:28:00	192.168.64.37	\N	\N	\N	\N	\N
fe53aa47-8266-42d5-95c7-869466207e71	4ee08b9b-4dd6-45c6-83d4-5c94db060f2a	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	QR	2026-05-12 13:55:00	192.168.158.108	\N	\N	\N	\N	\N
21fbe960-e8f8-4546-b650-1570aff0b873	f0d4e4db-064c-4813-b7af-73d55ec9e498	af1756ba-1982-4621-9340-1528c61ce0e2	PRESENT	MANUAL	2026-05-05 09:52:00	192.168.84.240	\N	\N	\N	\N	\N
0726097d-a2e8-4c6b-89fa-79621ed67280	f0d4e4db-064c-4813-b7af-73d55ec9e498	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	QR	2026-05-05 09:31:00	192.168.132.120	\N	\N	\N	\N	\N
11bb8a06-3f7d-4721-a127-8c44daa8bc61	d40d79aa-9dc4-4de3-bdf4-f711fdedfb07	af1756ba-1982-4621-9340-1528c61ce0e2	PRESENT	QR	2026-05-19 07:05:00	192.168.242.101	\N	\N	\N	\N	\N
24babec0-8c4b-4086-99a8-c1be079d0009	d40d79aa-9dc4-4de3-bdf4-f711fdedfb07	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	MANUAL	2026-05-19 10:37:00	192.168.91.13	\N	\N	\N	\N	\N
cd11524a-c0f7-4abb-83a3-02ea7c021843	a88b31ab-a035-42c1-bd9d-aa262b90e71c	af1756ba-1982-4621-9340-1528c61ce0e2	PRESENT	QR	2026-04-28 17:43:00	192.168.121.74	\N	\N	\N	\N	\N
05d6053e-557b-482a-93cb-486bda71234a	a88b31ab-a035-42c1-bd9d-aa262b90e71c	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	MANUAL	2026-04-28 13:08:00	192.168.226.68	\N	\N	\N	\N	\N
1c1f51b4-b380-4d70-b2fc-be9a35b55ea4	41fe7b13-6171-4f8b-9f11-c9d03b48a9f1	af1756ba-1982-4621-9340-1528c61ce0e2	LATE	QR	2026-04-07 12:02:00	192.168.103.14	\N	\N	\N	\N	\N
d9d4a895-fbb1-45c2-b66b-3a7314d4c104	41fe7b13-6171-4f8b-9f11-c9d03b48a9f1	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	QR	2026-04-07 15:18:00	192.168.19.99	\N	\N	\N	\N	\N
31ed5e50-30f2-45fa-9e63-f7f492e6b94b	55c6348f-4e85-44ac-8696-cdde8a9315c0	af1756ba-1982-4621-9340-1528c61ce0e2	PRESENT	QR	2026-03-31 11:52:00	192.168.254.160	\N	\N	\N	\N	\N
56fdbf0b-ab80-48cf-bf9b-cc6d6f19bab3	55c6348f-4e85-44ac-8696-cdde8a9315c0	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	LATE	QR	2026-03-31 08:25:00	192.168.96.204	\N	\N	\N	\N	\N
f9cec2f7-3634-47c4-8daa-88868d5c53c8	d15a305e-5403-463d-821c-9dd52c6a7fb2	af1756ba-1982-4621-9340-1528c61ce0e2	JUSTIFIED	QR	2026-03-10 12:48:00	192.168.129.11	\N	\N	Emergencia familiar	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-03-13 12:48:00
633852fd-0583-4902-a4b7-c5e669ecff90	d15a305e-5403-463d-821c-9dd52c6a7fb2	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	PRESENT	QR	2026-03-10 12:51:00	192.168.122.133	\N	\N	\N	\N	\N
d78bce61-f13a-4d94-ac4b-2f8a61b54c0a	b5e22e02-da2e-47c6-baeb-6809a25c49ef	1a34ac02-47c9-463a-9454-fcff07b08dd7	PRESENT	QR	2026-05-04 15:08:00	192.168.84.239	\N	\N	\N	\N	\N
08dc58c1-21b1-4728-918e-3af81742944a	b5e22e02-da2e-47c6-baeb-6809a25c49ef	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	LATE	QR	2026-05-04 16:47:00	192.168.216.77	\N	\N	\N	\N	\N
5d9cbf96-d22c-454e-97e9-2c94a3a3a82f	a3cecac0-6039-4cf5-9bfd-5c2bc319f717	1a34ac02-47c9-463a-9454-fcff07b08dd7	PRESENT	QR	2026-03-09 15:34:00	192.168.126.182	\N	\N	\N	\N	\N
552c81ac-2b78-4c36-8e65-cd560632aeb3	a3cecac0-6039-4cf5-9bfd-5c2bc319f717	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	PRESENT	QR	2026-03-09 07:23:00	192.168.85.173	\N	\N	\N	\N	\N
bdccfdcf-0265-4cc3-91fe-7244ae4cb611	74f37bc7-2159-4506-a455-a4848d84b243	1a34ac02-47c9-463a-9454-fcff07b08dd7	PRESENT	QR	2026-05-18 11:50:00	192.168.231.186	\N	\N	\N	\N	\N
13e2d4ac-93d1-44b7-9b31-b65a0c1df152	74f37bc7-2159-4506-a455-a4848d84b243	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	ABSENT	QR	2026-05-18 16:30:00	192.168.68.248	\N	\N	\N	\N	\N
136dd2df-b638-418c-a94c-06571dca8f9a	c0881d47-a1bc-4faf-831e-ee260af1612a	1a34ac02-47c9-463a-9454-fcff07b08dd7	LATE	MANUAL	2026-04-27 16:36:00	192.168.59.185	\N	\N	\N	\N	\N
2b689939-925a-46c5-a2f1-72eb669d1f05	c0881d47-a1bc-4faf-831e-ee260af1612a	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	PRESENT	QR	2026-04-27 15:40:00	192.168.185.159	\N	\N	\N	\N	\N
303f2b1a-a58b-4849-ba9a-39270d2642d4	f1994397-ee1a-40b4-ad82-75bf99de4792	1a34ac02-47c9-463a-9454-fcff07b08dd7	ABSENT	QR	2026-03-23 17:15:00	192.168.9.147	\N	\N	\N	\N	\N
e8753d60-e8e2-4cdb-a967-0335fbc00d9a	f1994397-ee1a-40b4-ad82-75bf99de4792	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	JUSTIFIED	QR	2026-03-23 07:28:00	192.168.106.177	\N	\N	Viaje personal	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-03-24 07:28:00
81541ed2-9198-4950-8ef5-9102a86697db	d3f19049-e0e3-495d-9574-1ae61a99e219	1a34ac02-47c9-463a-9454-fcff07b08dd7	PRESENT	QR	2026-03-30 16:58:00	192.168.121.224	\N	\N	\N	\N	\N
e4da96e5-92cc-4b5e-84bd-8649a0c8a4bc	d3f19049-e0e3-495d-9574-1ae61a99e219	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	ABSENT	QR	2026-03-30 18:08:00	192.168.133.54	\N	\N	\N	\N	\N
3de669b4-df05-4b45-8bba-314b908f96af	6ed32118-367c-468d-acdb-aa3d32776997	1a34ac02-47c9-463a-9454-fcff07b08dd7	PRESENT	MANUAL	2026-05-11 14:33:00	192.168.97.81	\N	\N	\N	\N	\N
7dbc22ea-32ca-4a3b-9de4-20a185b24072	6ed32118-367c-468d-acdb-aa3d32776997	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	JUSTIFIED	QR	2026-05-11 15:21:00	192.168.50.246	\N	\N	Viaje personal	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-05-14 15:21:00
32f9f3f9-15d5-49eb-8c1f-809ee839faa5	8856e354-5d0e-4d16-bda2-7df23e3bbef0	1a34ac02-47c9-463a-9454-fcff07b08dd7	PRESENT	QR	2026-03-16 10:19:00	192.168.198.74	\N	\N	\N	\N	\N
b183a669-16f2-415a-bed7-8dfa15940904	8856e354-5d0e-4d16-bda2-7df23e3bbef0	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	LATE	QR	2026-03-16 14:20:00	192.168.123.90	\N	\N	\N	\N	\N
679dc5a0-4ef6-4712-a51e-09dc24f40281	dc92a7e4-2660-4b8f-875b-3646dc856214	1a34ac02-47c9-463a-9454-fcff07b08dd7	PRESENT	MANUAL	2026-03-12 18:17:00	192.168.74.32	\N	\N	\N	\N	\N
aa17841d-820c-4822-8939-bdad3c033d0f	dc92a7e4-2660-4b8f-875b-3646dc856214	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	PRESENT	QR	2026-03-12 13:52:00	192.168.89.245	\N	\N	\N	\N	\N
643bae69-4ea1-43e0-806e-cede40e41e94	31b2b273-9678-455a-ae27-2e01b0964c90	1a34ac02-47c9-463a-9454-fcff07b08dd7	ABSENT	QR	2026-03-19 07:18:00	192.168.245.183	\N	\N	\N	\N	\N
f32bc363-4d7e-4999-9c75-c70f9017a1ac	31b2b273-9678-455a-ae27-2e01b0964c90	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	PRESENT	MANUAL	2026-03-19 17:16:00	192.168.192.123	\N	\N	\N	\N	\N
9e758194-c5e2-401f-bbdc-7e4c17a0f5ee	318361f5-70e6-47de-bc94-5cb3220e4359	1a34ac02-47c9-463a-9454-fcff07b08dd7	PRESENT	MANUAL	2026-04-02 11:59:00	192.168.144.179	\N	\N	\N	\N	\N
ee646af2-623f-4632-b137-a0aaeb4fa42a	318361f5-70e6-47de-bc94-5cb3220e4359	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	PRESENT	QR	2026-04-02 18:37:00	192.168.62.63	\N	\N	\N	\N	\N
b18fe9ed-7996-4014-9531-7ed8fbdd340f	73a19752-e281-4e4d-8165-0f5df902fe14	1a34ac02-47c9-463a-9454-fcff07b08dd7	PRESENT	MANUAL	2026-05-28 10:40:00	192.168.60.14	\N	\N	\N	\N	\N
2d6a9a6a-64fd-4fe8-bbf9-6e4f311f1e8f	73a19752-e281-4e4d-8165-0f5df902fe14	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	PRESENT	QR	2026-05-28 14:06:00	192.168.175.198	\N	\N	\N	\N	\N
9d153d14-369c-45f1-a718-4be97ff681a3	be073ae0-0db2-48b2-8b99-1dc409c58840	1a34ac02-47c9-463a-9454-fcff07b08dd7	PRESENT	MANUAL	2026-05-07 09:26:00	192.168.168.240	\N	\N	\N	\N	\N
7e28e09b-7150-4ed9-9b03-c80316b45ac7	be073ae0-0db2-48b2-8b99-1dc409c58840	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	JUSTIFIED	QR	2026-05-07 17:12:00	192.168.166.16	\N	\N	Viaje personal	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-05-09 17:12:00
bcefc012-53b8-4a25-b997-00d894de7be2	c0bf3100-ad6f-4925-8a82-4a9b4e9b2fb7	1a34ac02-47c9-463a-9454-fcff07b08dd7	JUSTIFIED	QR	2026-05-21 16:14:00	192.168.226.215	\N	\N	Problemas de salud	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-05-24 16:14:00
8fae07f3-84e1-4083-9b6a-ea8221092c8e	c0bf3100-ad6f-4925-8a82-4a9b4e9b2fb7	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	PRESENT	MANUAL	2026-05-21 13:50:00	192.168.127.48	\N	\N	\N	\N	\N
8c17dd00-e45a-46af-b130-e9f12f74e5e6	8cc62cb9-3d58-4414-8a60-ef0e4fcf02a7	1a34ac02-47c9-463a-9454-fcff07b08dd7	JUSTIFIED	MANUAL	2026-04-23 11:56:00	192.168.146.155	\N	\N	Problemas de salud	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-04-25 11:56:00
9b964540-af36-47da-8d4b-870c009a564e	8cc62cb9-3d58-4414-8a60-ef0e4fcf02a7	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	PRESENT	MANUAL	2026-04-23 11:29:00	192.168.254.165	\N	\N	\N	\N	\N
2e42ffd1-299b-4838-a312-5dc67cf8f4fe	13edadb5-8294-4503-b4ec-99e713dc4609	634e1ef3-b7dd-45b9-82d3-f259314d39ac	PRESENT	QR	2026-04-02 09:54:00	192.168.130.120	\N	\N	\N	\N	\N
587ca71f-55f7-46b9-8e6c-98128cf5ccd6	13edadb5-8294-4503-b4ec-99e713dc4609	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	MANUAL	2026-04-02 12:10:00	192.168.188.118	\N	\N	\N	\N	\N
302c115b-8f0f-419a-a8a8-daef208f8548	13edadb5-8294-4503-b4ec-99e713dc4609	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	LATE	QR	2026-04-02 07:47:00	192.168.87.203	\N	\N	\N	\N	\N
b1020906-83bb-4db0-a76a-92c19244ab39	5fdbf914-d42c-41c0-849c-539bc7f6dc3b	634e1ef3-b7dd-45b9-82d3-f259314d39ac	PRESENT	QR	2026-03-05 10:11:00	192.168.157.220	\N	\N	\N	\N	\N
2ee9a220-41ed-4b14-bfa0-b4e479888a82	5fdbf914-d42c-41c0-849c-539bc7f6dc3b	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	LATE	QR	2026-03-05 13:32:00	192.168.84.23	\N	\N	\N	\N	\N
c75e34f6-18d2-4841-bcd3-df3e246327e1	5fdbf914-d42c-41c0-849c-539bc7f6dc3b	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	PRESENT	QR	2026-03-05 09:30:00	192.168.83.240	\N	\N	\N	\N	\N
c87e41fb-6903-429e-8d0a-c17999bb7761	fbd33247-4c5e-4a08-91ec-8dc1d4b74146	634e1ef3-b7dd-45b9-82d3-f259314d39ac	PRESENT	QR	2026-05-21 10:28:00	192.168.193.69	\N	\N	\N	\N	\N
3a315f35-c743-46e5-9167-dcf0b2761859	fbd33247-4c5e-4a08-91ec-8dc1d4b74146	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	JUSTIFIED	QR	2026-05-21 18:36:00	192.168.178.61	\N	\N	Problemas de salud	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-05-23 18:36:00
7a2959e2-e254-4a6c-bf03-0c6981903112	fbd33247-4c5e-4a08-91ec-8dc1d4b74146	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	PRESENT	QR	2026-05-21 11:10:00	192.168.104.176	\N	\N	\N	\N	\N
74c0c019-57f4-41f4-bbb6-e44ae849a5cf	105e53a8-0efd-4e78-b179-2768f36495be	634e1ef3-b7dd-45b9-82d3-f259314d39ac	PRESENT	MANUAL	2026-04-09 18:49:00	192.168.80.177	\N	\N	\N	\N	\N
4b6c7500-beec-4836-a8e2-d713b4e450e8	105e53a8-0efd-4e78-b179-2768f36495be	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	MANUAL	2026-04-09 11:23:00	192.168.158.57	\N	\N	\N	\N	\N
4335cbed-47b5-4632-afde-916fe1b06901	105e53a8-0efd-4e78-b179-2768f36495be	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	PRESENT	QR	2026-04-09 09:29:00	192.168.192.254	\N	\N	\N	\N	\N
7635ab0b-0ea7-43a4-a2e2-2f1b0d3589c1	d196abad-c46e-4512-9907-8272d2684fd1	634e1ef3-b7dd-45b9-82d3-f259314d39ac	LATE	QR	2026-03-19 15:58:00	192.168.121.194	\N	\N	\N	\N	\N
9ae4944b-54f8-487e-8601-a34d3e1bec61	d196abad-c46e-4512-9907-8272d2684fd1	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	QR	2026-03-19 10:48:00	192.168.64.175	\N	\N	\N	\N	\N
088e8a60-098c-461c-9a4d-10500440f121	d196abad-c46e-4512-9907-8272d2684fd1	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	ABSENT	MANUAL	2026-03-19 08:33:00	192.168.115.136	\N	\N	\N	\N	\N
4c390eae-3a74-40a3-91a3-adf23d18bbfe	08d50fbf-9774-4955-b59b-ccaa87776ab2	634e1ef3-b7dd-45b9-82d3-f259314d39ac	LATE	QR	2026-05-28 16:07:00	192.168.16.213	\N	\N	\N	\N	\N
cb1485db-8358-426a-8b6b-ddfbd68d53b2	08d50fbf-9774-4955-b59b-ccaa87776ab2	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	QR	2026-05-28 16:34:00	192.168.39.43	\N	\N	\N	\N	\N
74fda793-1594-443d-8389-97059c0359b2	08d50fbf-9774-4955-b59b-ccaa87776ab2	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	PRESENT	QR	2026-05-28 08:43:00	192.168.53.184	\N	\N	\N	\N	\N
60e79acd-d430-4db4-9114-b16b2ce761a8	54305795-e919-475d-8ba2-340fcedf116a	634e1ef3-b7dd-45b9-82d3-f259314d39ac	PRESENT	QR	2026-03-12 15:28:00	192.168.208.15	\N	\N	\N	\N	\N
60c1f9d5-1153-458a-ac62-500cd5fe445e	54305795-e919-475d-8ba2-340fcedf116a	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	QR	2026-03-12 14:36:00	192.168.15.144	\N	\N	\N	\N	\N
dd1a746d-5bc2-4025-b1de-68ea6f7a80ad	54305795-e919-475d-8ba2-340fcedf116a	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	PRESENT	MANUAL	2026-03-12 18:01:00	192.168.102.66	\N	\N	\N	\N	\N
d6d5c141-f93b-4b80-b719-50b919dacb47	a0ac8bfe-473c-4f65-969c-2065ffffdbc2	634e1ef3-b7dd-45b9-82d3-f259314d39ac	ABSENT	QR	2026-05-07 16:04:00	192.168.12.109	\N	\N	\N	\N	\N
d0d763da-096f-4e24-9a33-5c3f98984b36	a0ac8bfe-473c-4f65-969c-2065ffffdbc2	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	QR	2026-05-07 07:59:00	192.168.229.18	\N	\N	\N	\N	\N
846bb217-e9a1-4aae-8f88-bdb1765ed078	a0ac8bfe-473c-4f65-969c-2065ffffdbc2	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	JUSTIFIED	QR	2026-05-07 11:26:00	192.168.96.229	\N	\N	Emergencia familiar	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-05-10 11:26:00
dd8b25cb-dc08-4cc4-b02a-a78388b75eec	54a3a5bf-a0d7-4153-8c15-7a54a817012a	634e1ef3-b7dd-45b9-82d3-f259314d39ac	PRESENT	MANUAL	2026-04-02 13:24:00	192.168.21.175	\N	\N	\N	\N	\N
86f27bc8-0e1e-4701-aff1-3a260f190361	54a3a5bf-a0d7-4153-8c15-7a54a817012a	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	JUSTIFIED	MANUAL	2026-04-02 09:41:00	192.168.138.101	\N	\N	Viaje personal	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-04-03 09:41:00
5bdd6a80-d6bb-42ac-b736-c3c029feb4a9	54a3a5bf-a0d7-4153-8c15-7a54a817012a	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	PRESENT	QR	2026-04-02 10:53:00	192.168.1.194	\N	\N	\N	\N	\N
915dab5b-ccb9-4f38-a450-45c2248cd1d8	d6b94b1c-bc27-4bfc-bb44-17e45f482afa	634e1ef3-b7dd-45b9-82d3-f259314d39ac	PRESENT	QR	2026-04-09 17:46:00	192.168.140.109	\N	\N	\N	\N	\N
114caed6-5242-4d65-8a5b-9faaad07ff7d	d6b94b1c-bc27-4bfc-bb44-17e45f482afa	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	MANUAL	2026-04-09 10:29:00	192.168.89.40	\N	\N	\N	\N	\N
bea483d0-26ea-4af1-92f6-523bb7804b76	d6b94b1c-bc27-4bfc-bb44-17e45f482afa	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	PRESENT	MANUAL	2026-04-09 18:48:00	192.168.29.9	\N	\N	\N	\N	\N
2bb4a337-b5a1-44e8-94f6-4701f3bcc1dc	f8a73f55-a479-4b02-ae3a-8ba4ff61ef55	634e1ef3-b7dd-45b9-82d3-f259314d39ac	ABSENT	QR	2026-03-05 07:15:00	192.168.53.18	\N	\N	\N	\N	\N
89b0fee2-d443-4c6f-ad8d-0cd928b21cdb	f8a73f55-a479-4b02-ae3a-8ba4ff61ef55	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	QR	2026-03-05 16:43:00	192.168.181.224	\N	\N	\N	\N	\N
3ba01a5f-5ca6-4dcf-8758-09def31cf1fc	f8a73f55-a479-4b02-ae3a-8ba4ff61ef55	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	PRESENT	QR	2026-03-05 13:28:00	192.168.60.139	\N	\N	\N	\N	\N
c454e46a-5ff5-467c-8af3-ea335ff10c7d	e0b492b5-77ce-4461-bda0-ec7c2876ef74	634e1ef3-b7dd-45b9-82d3-f259314d39ac	PRESENT	MANUAL	2026-05-21 07:08:00	192.168.129.75	\N	\N	\N	\N	\N
d3249a91-500d-4913-ad86-0e5a437679f9	e0b492b5-77ce-4461-bda0-ec7c2876ef74	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	MANUAL	2026-05-21 16:20:00	192.168.148.154	\N	\N	\N	\N	\N
a0901362-2bda-413a-9df0-d7d1ce11acec	e0b492b5-77ce-4461-bda0-ec7c2876ef74	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	ABSENT	MANUAL	2026-05-21 10:19:00	192.168.225.37	\N	\N	\N	\N	\N
8782e8e6-46a8-494c-9dd7-b8fe6917f8e3	71fa5a29-e1a3-4437-b598-ebd6994541a0	634e1ef3-b7dd-45b9-82d3-f259314d39ac	JUSTIFIED	QR	2026-03-26 13:19:00	192.168.161.174	\N	\N	Viaje personal	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-03-27 13:19:00
f155c6b1-e71d-4e78-9d0c-d9228840c3aa	71fa5a29-e1a3-4437-b598-ebd6994541a0	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	QR	2026-03-26 12:41:00	192.168.172.98	\N	\N	\N	\N	\N
e3105897-1822-45d8-a90f-4c2e5b7b05f1	71fa5a29-e1a3-4437-b598-ebd6994541a0	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	ABSENT	QR	2026-03-26 13:26:00	192.168.39.77	\N	\N	\N	\N	\N
f9dbc815-af91-42f5-91b7-2297faa4a61e	f544a5b3-c208-4715-89e0-56b2cf8d3da5	634e1ef3-b7dd-45b9-82d3-f259314d39ac	PRESENT	QR	2026-04-30 14:15:00	192.168.218.58	\N	\N	\N	\N	\N
ccc8435b-22fa-4ba6-8e3f-3a40e77e88a9	f544a5b3-c208-4715-89e0-56b2cf8d3da5	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	QR	2026-04-30 14:58:00	192.168.15.144	\N	\N	\N	\N	\N
968dee25-2de0-4b78-8d6d-b2f1305354b9	f544a5b3-c208-4715-89e0-56b2cf8d3da5	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	PRESENT	QR	2026-04-30 15:08:00	192.168.100.63	\N	\N	\N	\N	\N
606b5836-c73c-4b39-bb0e-200284834d73	006c3605-ca1d-4dd7-b30d-ee8fdd4b2043	634e1ef3-b7dd-45b9-82d3-f259314d39ac	PRESENT	QR	2026-05-07 08:59:00	192.168.116.217	\N	\N	\N	\N	\N
90d68483-0bcc-4103-a512-0149caba9767	006c3605-ca1d-4dd7-b30d-ee8fdd4b2043	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	PRESENT	QR	2026-05-07 10:03:00	192.168.69.97	\N	\N	\N	\N	\N
0520b039-4a04-409e-8fe9-0dd5aba265db	006c3605-ca1d-4dd7-b30d-ee8fdd4b2043	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	LATE	QR	2026-05-07 08:12:00	192.168.206.195	\N	\N	\N	\N	\N
4b193e1b-4fb3-422e-9432-e04e3c986e83	f192579c-2a69-4ebf-8e3e-5df6abe3a807	38627842-6a22-4667-9f01-4c99af03904b	PRESENT	QR	2026-05-21 10:30:00	192.168.54.223	\N	\N	\N	\N	\N
e5bfa665-a2f2-429a-ad87-ce94cf74dfa3	f192579c-2a69-4ebf-8e3e-5df6abe3a807	171c242e-3656-44e0-a314-b7b97ab6d437	JUSTIFIED	QR	2026-05-21 07:13:00	192.168.235.63	\N	\N	Emergencia familiar	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-05-24 07:13:00
025b6afa-7990-41ea-af23-b4526a938ad4	f192579c-2a69-4ebf-8e3e-5df6abe3a807	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	LATE	QR	2026-05-21 13:58:00	192.168.62.142	\N	\N	\N	\N	\N
75a04d69-339d-48ea-80a6-76adbbb474a2	58c88aa7-e3a9-403d-b9f1-26a5444476da	38627842-6a22-4667-9f01-4c99af03904b	PRESENT	QR	2026-03-26 14:34:00	192.168.167.92	\N	\N	\N	\N	\N
3913c585-d519-420e-9df2-686aa037b050	58c88aa7-e3a9-403d-b9f1-26a5444476da	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	QR	2026-03-26 14:29:00	192.168.26.206	\N	\N	\N	\N	\N
257b3243-e02d-4958-8fd7-0a2a656441a5	58c88aa7-e3a9-403d-b9f1-26a5444476da	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	JUSTIFIED	QR	2026-03-26 12:58:00	192.168.106.12	\N	\N	Emergencia familiar	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-03-28 12:58:00
3c763ffa-2f4c-452d-93e6-9bc8f502f86b	6e4dcbef-9bb0-4eca-af06-b91d853d4ec0	38627842-6a22-4667-9f01-4c99af03904b	PRESENT	QR	2026-04-02 09:01:00	192.168.67.142	\N	\N	\N	\N	\N
5229dc75-eec4-484b-860c-97e11d6906f1	6e4dcbef-9bb0-4eca-af06-b91d853d4ec0	171c242e-3656-44e0-a314-b7b97ab6d437	JUSTIFIED	QR	2026-04-02 13:18:00	192.168.59.98	\N	\N	Emergencia familiar	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-04-04 13:18:00
26485634-3948-4b51-92b3-65dbb97da4b6	6e4dcbef-9bb0-4eca-af06-b91d853d4ec0	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	QR	2026-04-02 15:41:00	192.168.242.176	\N	\N	\N	\N	\N
daf694d8-c511-430b-a29b-86e06c3159ab	06a3477b-9694-4d42-9594-85696d9a6eb4	38627842-6a22-4667-9f01-4c99af03904b	PRESENT	QR	2026-03-19 14:46:00	192.168.165.190	\N	\N	\N	\N	\N
b73f44e3-a453-4ef6-a16b-77b06142b4a8	06a3477b-9694-4d42-9594-85696d9a6eb4	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	QR	2026-03-19 12:10:00	192.168.36.185	\N	\N	\N	\N	\N
587265f7-a16e-4924-aa57-cd28920d2c36	06a3477b-9694-4d42-9594-85696d9a6eb4	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	QR	2026-03-19 15:41:00	192.168.246.16	\N	\N	\N	\N	\N
dd6efcd1-a517-4160-8484-fc1213360ed5	cf685df8-d2fb-4823-9313-c0ef281b1c62	38627842-6a22-4667-9f01-4c99af03904b	PRESENT	MANUAL	2026-03-12 08:52:00	192.168.172.13	\N	\N	\N	\N	\N
ad89709c-136e-4960-bce1-2a489ea1ca53	cf685df8-d2fb-4823-9313-c0ef281b1c62	171c242e-3656-44e0-a314-b7b97ab6d437	ABSENT	QR	2026-03-12 17:14:00	192.168.18.182	\N	\N	\N	\N	\N
7be4f9e2-ff6e-472b-9faa-754c3feb7775	cf685df8-d2fb-4823-9313-c0ef281b1c62	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	QR	2026-03-12 14:23:00	192.168.16.159	\N	\N	\N	\N	\N
0c8562e1-7472-489b-b47f-fdcb6af87595	85f353f2-5978-4ae8-9370-6e61e9066d15	38627842-6a22-4667-9f01-4c99af03904b	LATE	MANUAL	2026-04-16 14:42:00	192.168.125.5	\N	\N	\N	\N	\N
59035a65-1bfa-4490-abbc-71373c46f1b9	85f353f2-5978-4ae8-9370-6e61e9066d15	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	QR	2026-04-16 07:01:00	192.168.136.185	\N	\N	\N	\N	\N
8bf550ad-63b1-4143-a3eb-75ddc6542255	85f353f2-5978-4ae8-9370-6e61e9066d15	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	MANUAL	2026-04-16 07:32:00	192.168.209.179	\N	\N	\N	\N	\N
b6c131fa-9873-4e68-8ff7-2df19e780fe3	53962c33-5de6-42e5-a879-40566d973a3b	38627842-6a22-4667-9f01-4c99af03904b	LATE	MANUAL	2026-04-23 09:06:00	192.168.236.25	\N	\N	\N	\N	\N
73c67ce1-6a86-4832-8133-49bbba8cc26e	53962c33-5de6-42e5-a879-40566d973a3b	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	QR	2026-04-23 16:33:00	192.168.65.209	\N	\N	\N	\N	\N
dbe2f1db-dc0c-497b-ad4b-a206a88ef439	53962c33-5de6-42e5-a879-40566d973a3b	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	QR	2026-04-23 08:23:00	192.168.246.104	\N	\N	\N	\N	\N
33de9a18-0148-45e0-9323-52b48fa90809	97f0dd3a-166e-4fde-a512-4f22996bb25d	38627842-6a22-4667-9f01-4c99af03904b	PRESENT	QR	2026-03-05 18:14:00	192.168.77.176	\N	\N	\N	\N	\N
9e5fef11-4d80-4cec-b91c-e9b3102e4ada	97f0dd3a-166e-4fde-a512-4f22996bb25d	171c242e-3656-44e0-a314-b7b97ab6d437	ABSENT	QR	2026-03-05 17:48:00	192.168.9.24	\N	\N	\N	\N	\N
73385f53-49fe-4aaf-8336-344c7963b7ec	97f0dd3a-166e-4fde-a512-4f22996bb25d	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	QR	2026-03-05 14:03:00	192.168.164.3	\N	\N	\N	\N	\N
553ae8d1-6fa4-455c-8c61-1ea9d7a30869	4fb55d8f-137f-44d9-8516-98052a13f58e	38627842-6a22-4667-9f01-4c99af03904b	LATE	QR	2026-04-09 13:41:00	192.168.201.85	\N	\N	\N	\N	\N
ca3f045d-b014-4e96-8a8d-63c7b274ac9f	4fb55d8f-137f-44d9-8516-98052a13f58e	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	MANUAL	2026-04-09 08:57:00	192.168.136.236	\N	\N	\N	\N	\N
c3e5736d-0963-4142-bf87-cbaed3041d86	4fb55d8f-137f-44d9-8516-98052a13f58e	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	QR	2026-04-09 18:56:00	192.168.146.122	\N	\N	\N	\N	\N
2da321fa-9862-4517-a0e2-24db1086c757	900c24d3-4ceb-45a5-8c68-02db78e77ecf	38627842-6a22-4667-9f01-4c99af03904b	PRESENT	MANUAL	2026-05-14 17:59:00	192.168.72.231	\N	\N	\N	\N	\N
f8725c62-d419-4bbc-81a3-a0ce143c1932	900c24d3-4ceb-45a5-8c68-02db78e77ecf	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	QR	2026-05-14 09:59:00	192.168.218.81	\N	\N	\N	\N	\N
ba7994f0-4dae-46ff-b600-585ac1aafc6a	900c24d3-4ceb-45a5-8c68-02db78e77ecf	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	QR	2026-05-14 09:48:00	192.168.211.183	\N	\N	\N	\N	\N
fbf8a203-f19e-40fe-bfe2-ab306e4ef083	cf90e009-f83c-4602-8e3f-8ca0f58c6a85	38627842-6a22-4667-9f01-4c99af03904b	ABSENT	MANUAL	2026-04-30 11:10:00	192.168.145.62	\N	\N	\N	\N	\N
7c6c9818-bcf4-4e93-8a80-0f2133a8ba79	cf90e009-f83c-4602-8e3f-8ca0f58c6a85	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	MANUAL	2026-04-30 17:57:00	192.168.139.85	\N	\N	\N	\N	\N
fe08430b-00f9-4938-8bc9-22eb50ea1f54	cf90e009-f83c-4602-8e3f-8ca0f58c6a85	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	QR	2026-04-30 18:46:00	192.168.21.129	\N	\N	\N	\N	\N
60ed16f1-5684-4c1d-acbd-a70308d0280c	6840952a-7ae5-4797-9a23-c996ea8d649b	38627842-6a22-4667-9f01-4c99af03904b	LATE	QR	2026-04-16 08:27:00	192.168.60.215	\N	\N	\N	\N	\N
044a9d4a-5fb0-4a3b-96b8-ae0066250a65	6840952a-7ae5-4797-9a23-c996ea8d649b	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	QR	2026-04-16 16:38:00	192.168.102.249	\N	\N	\N	\N	\N
c1420e6d-3377-4653-bc12-cb1cbdef3583	6840952a-7ae5-4797-9a23-c996ea8d649b	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	ABSENT	QR	2026-04-16 11:50:00	192.168.116.126	\N	\N	\N	\N	\N
c97c7f0b-d71a-42f6-b318-88e9a62923c0	9ed9249a-adb5-44ea-99a7-ea27e59ed093	38627842-6a22-4667-9f01-4c99af03904b	PRESENT	QR	2026-05-21 13:27:00	192.168.48.175	\N	\N	\N	\N	\N
70c80a0e-ff2f-4e1d-b692-a5e7b105aa3b	9ed9249a-adb5-44ea-99a7-ea27e59ed093	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	QR	2026-05-21 16:18:00	192.168.205.64	\N	\N	\N	\N	\N
4d4d213e-de67-462a-8a8b-3942c3f2a67e	9ed9249a-adb5-44ea-99a7-ea27e59ed093	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	LATE	QR	2026-05-21 09:24:00	192.168.183.201	\N	\N	\N	\N	\N
05e43afd-a892-498e-8880-d2005d692031	159d3c4e-1c60-4033-8875-663130d7ffc5	38627842-6a22-4667-9f01-4c99af03904b	LATE	QR	2026-05-28 12:23:00	192.168.28.24	\N	\N	\N	\N	\N
96f41c00-42e6-4557-8202-648e29ffc3b7	159d3c4e-1c60-4033-8875-663130d7ffc5	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	QR	2026-05-28 12:48:00	192.168.70.27	\N	\N	\N	\N	\N
f9896537-bcd3-4c4e-b1dc-44714ca006d3	159d3c4e-1c60-4033-8875-663130d7ffc5	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	QR	2026-05-28 14:35:00	192.168.143.132	\N	\N	\N	\N	\N
5cc8e14d-0014-4b70-a855-9a3197d7ac69	d3d670bc-262f-4112-8397-2c9a87ec6db0	38627842-6a22-4667-9f01-4c99af03904b	PRESENT	QR	2026-03-05 12:35:00	192.168.24.153	\N	\N	\N	\N	\N
272a697c-7b13-4b57-897c-645e1c8fd1ec	d3d670bc-262f-4112-8397-2c9a87ec6db0	171c242e-3656-44e0-a314-b7b97ab6d437	PRESENT	QR	2026-03-05 13:00:00	192.168.75.106	\N	\N	\N	\N	\N
a94feaa1-003d-4c19-af47-1382b482b95e	d3d670bc-262f-4112-8397-2c9a87ec6db0	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	PRESENT	QR	2026-03-05 15:57:00	192.168.251.63	\N	\N	\N	\N	\N
\.


--
-- Data for Name: attendance_event; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance_event (id_event, id_attendance, type, previous_status, new_status, comment, id_actor, date) FROM stdin;
42fc38a4-673f-48e4-8bf9-b9fc9694b84b	e006dc40-0249-4886-9064-f8107044292e	CREATION	\N	LATE	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665533
f4cc866a-afbd-4d56-9574-e4557485bb07	6f545b66-b65a-427e-aeeb-b43523da2dbd	CREATION	\N	LATE	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665534
de367dc8-71c2-42cc-a040-e057e795acf8	60671ef1-378d-4faa-877e-4071a74246cd	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665536
77c8939e-5bce-446e-b85b-1022f3617ef6	1bb1951b-de64-483c-9d61-9671043d3cb8	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665537
334ca8e3-4d43-4f67-a81f-ff5020ff3c0e	d20a9e6f-ed12-463f-9072-6152105cea32	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665539
a8dca8d1-f13e-4315-9947-46fb4812a497	a1f6e320-8094-4068-98dc-9cf5fa0679eb	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.66554
a2a6f26f-587e-4b75-97c0-5bf8962bfe6c	c4d54586-4ede-4d1c-9978-3131028504b5	STATUS_CHANGE	ABSENT	ABSENT	Cambio de estado manual	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665542
b4ada3e5-8692-41cb-ae13-1a88cc2057fb	b8f0dd68-21cf-4c7f-9714-a4787e856bba	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665446
c3feea19-ccfe-432d-b74c-9fd19fc58695	83c47fb6-5b1b-4c13-8dd0-58a859334c53	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665457
eeef01a3-2c5f-4775-900f-b86483f582a4	caf71e8c-eaa1-436f-a962-6e9ed2862ebe	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665459
9830d1a5-69cb-4c00-a61e-0f6187ce36ce	f7679656-6e5f-492c-9d36-760088b5e72e	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.66546
dc985100-c9af-4674-a262-4181dc3519e9	94826636-5bae-4cb7-bc6e-6379e03d3ead	CREATION	\N	LATE	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665462
adc5aa84-d0c8-48bf-8404-8d863fc92e92	fd805d43-226a-4276-b1f5-821a12bc0ab6	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665464
e9ce277e-d7e3-4d5d-b183-488fed20b427	52fb3ecf-486b-4179-b662-4f53d4168779	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665466
35bf80c7-ba68-4967-960c-21cde31813b3	b1e72787-c809-45e3-861f-21f6a3ab0f35	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665467
069df613-20e9-4cda-afe7-3fbf1bcf8989	c1d37c5d-8cc9-4f33-a991-d90ab8e1b05f	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665468
d95e6358-6cce-4d44-a007-13d429b901ab	2cd15ffc-f087-4b4d-9b19-98fdc0cf58d2	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.66547
775e14ec-a529-4cbb-ae61-0dec90d6abd9	cf4b6e33-f5c9-4417-b10b-202416082aef	CREATION	\N	ABSENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665471
222ecbba-b1b6-4ab6-a00b-3a0d81cb8e0d	bd4c8ddf-69f6-4592-896e-19d971297ae7	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665473
01efec09-7ac4-4c62-b80c-9f89b25a9dab	3d8c9fc4-a6a9-4401-b2f4-1c2006aee179	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665474
b0cb8912-6b9f-4451-8e93-29d22f5e6b02	5d9147a8-053f-4590-aa6c-7e5de35b045c	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665476
9539beed-b0fb-4c4c-a4a9-419afbe43868	c43eecd9-4d04-4374-b869-71bd4eb8a790	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665477
2b556eec-24f3-485e-8e5a-bf4d4fda206f	36397cbd-0a6c-4a63-afe3-e9488ad55da8	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665478
ba87a31a-6c5e-411d-8e8d-def039569a55	77f993a5-6f60-4755-a78b-9be498957f34	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.66548
e8787583-6b7e-40f5-8d32-e3478e493870	5fad863d-72e0-4a0e-966e-bd02e9395855	CREATION	\N	LATE	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665481
e1bd373d-6a07-4380-af7f-e4f9c6955c31	44b52db1-0f2b-4b0a-8d38-bed925dc487d	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665483
2f47ffac-0adc-4422-bdb0-6c83149812cf	55b22ae3-e500-4de0-aee6-568adcceea5e	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665484
fd0a810d-951b-4f3e-88d5-175d521fc4c5	201abac9-c718-4587-aca7-56df5caacf4f	CREATION	\N	LATE	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665485
d8e2305b-788e-435a-a151-999d344cfbcd	eeb47eb1-1889-410f-9ae8-d45ae8493958	CREATION	\N	ABSENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665487
c7ff1b49-a5b9-4d51-83dc-9975efd1559f	dac03233-4a30-4799-a9be-0705e6311d0e	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665488
7e9f420b-55bd-49e7-b41d-11e965fa6051	047d9e58-6ce6-4776-a1bd-f8bc65c519b4	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.66549
c7d87f84-de59-43eb-a4f0-36eea7fa1c25	e9ab9337-5428-49bd-8cdf-e364d21bdf8b	CREATION	\N	ABSENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665491
f6c87c61-504f-48ca-a0c0-463927ea5aee	70b5d689-cf42-4ed2-a4b4-40e1c5c0d28d	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665493
273ab9fc-9ca6-40ef-9b6c-bfc22a48971c	1b0dd3dd-00b7-4488-8009-098de47271af	CREATION	\N	ABSENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665495
e75072f2-0609-439b-b31f-540038516377	291f560f-bda4-4ba7-a294-6ca233937325	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665496
4b141fff-8930-4b2a-8d16-b37944fec124	013bab05-7f03-4105-bb51-4e8414df0d9c	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665498
1af9284a-da8e-4806-9cb2-1860a9e11197	ed52b5e0-ff87-4ffa-9858-deaf23ae514b	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665499
aaf0b714-cf96-43dd-989c-65dbe2a0a947	e478fcb8-6601-4db5-8613-f72f173b0cb6	CREATION	\N	LATE	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665501
762338c1-10b7-4e25-94e4-10e6df3986a4	e1bbcc22-8831-45d0-ba51-03120d2327e2	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665502
b829e836-ae84-48eb-8414-6e475d263a9b	6545c549-5be2-4074-ab16-f125107b98aa	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665503
8ed176ef-ba9a-44a8-9223-d870878cfc5f	0119dd72-251d-4c72-b692-0542b955f801	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665505
5a97389d-83c6-4350-a155-1c7459a68f23	5702ce54-643d-4694-a63a-bd3e6c0fa6e1	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665506
c5314123-a672-4e78-b48d-253c213c785e	4ed9d3d1-3a49-41c4-8f8d-62ff7fe02ec2	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665508
8d41b66a-ccea-48b5-bf85-b0f82e90ca9f	52e45915-c77c-4fc8-9c9c-5c8acd8c608d	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665509
80f00101-5888-4425-b5db-a7646bd5fc26	429e8bbd-ec65-483c-b79f-7dc84bbf8d82	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.66551
1527c21b-0c32-4229-b150-f2c4e8bd6322	4352dea5-db5d-440a-9b62-7cc01497dc5d	CREATION	\N	LATE	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665512
ee36114e-8772-4720-8bc5-26e59f1c927c	263ec4e0-b785-4681-b409-c6fc88bfd78e	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665513
b10ec128-cd17-46c5-bdc6-1d79956fd99b	552f05e1-f110-4aa0-9842-9efb182f8ac6	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665515
4a2768e2-0b82-40ed-a58f-ede5d6845566	02bed79c-7d77-414e-bedd-08ed4639860c	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665516
10f03b32-351f-4f2b-8bf4-43386bf18e74	d9bacb70-4ac2-4749-b007-a5318d1b29e2	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665517
8ef82e57-8274-4e91-9457-14d3a96a5f77	31e8ef10-b59c-4009-b5ee-ac2c5a812cb8	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665519
b69b3f51-e238-423c-b374-520969fdf342	260115ca-bf05-4e2d-87a5-a353da8b23fe	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.66552
f1eb79db-4564-433f-9738-50dfb3543c90	fbec0524-6dbf-435d-b78d-b1f99ba44dc4	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665522
f66e1a1d-687b-4abd-86b8-53a0b8987b2d	f32b76e8-55ef-4035-b2d8-b16234b8e285	CREATION	\N	LATE	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665523
b4c7259c-9584-4bcd-9caa-6918d7b0928e	a6f3b6f5-22d3-44e7-bc06-2180b282a20a	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665525
dc5cedd6-c22a-4134-a1af-1b5e7d12aef0	08a876af-fbce-41fb-b065-eff82bfd2977	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665526
5a51bc90-8074-4101-8851-ea8cb2100c89	e4b57381-b598-4318-8c70-ebac130694ab	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665527
0a89638a-d2a4-4992-a9a4-03af3840be37	40be1485-e38a-421e-8819-ef8496a22974	CREATION	\N	ABSENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665529
1741d3c8-a90f-4d57-bb35-75dde831aeea	afb46a46-0a8a-48ba-b513-04a1529d61ff	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.66553
a3cd3bb7-a387-42da-8bd9-354748b34e1b	87eb8367-9763-42ad-a5a0-8c724121b007	CREATION	\N	ABSENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665532
10976624-a5a5-4434-8997-f739d4932505	e5a8ecfc-5e49-4cea-8f20-0597fc747e64	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665543
30b7c868-7171-4586-9297-a867e5778b06	45f8cca5-4e5d-431f-aae3-5b0aa7edd45f	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665544
f46f1915-ba50-4c95-b419-84fa91ca18a7	a0f5b8f9-9a27-4062-80a2-b2f2c621bf7e	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665546
583f8c5d-abf3-4bea-b216-e42d79140cbb	5d3b3664-a6b7-41a8-bd0f-a8e20d234711	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665547
0695f07c-4220-4ecd-b2cd-8873ef1625b5	ddedfa31-6766-4c56-9422-dd0a519ebc69	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665549
8570fd5a-8c6c-49b1-b2aa-ead38cd6b101	07bae203-bf95-453b-b914-2589e270e501	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.66555
fc65b101-bf8e-4c0e-9305-991c6b65e755	10f9e180-d083-4f0d-9626-51d555c1d3fa	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665551
20b80a65-052c-4734-9e49-af631f7f97f6	253f266f-a668-4fc1-938e-6dcb76698758	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665553
fb47e97d-c15b-42fe-8e48-30ed6d13f4a0	dda38cde-209b-4ade-bda9-c8c4fe986f91	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665554
89077c8f-a19f-4565-b74a-8666cfce49af	e202d276-3111-42ef-9f24-6fcebc360b5e	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665556
a3c20d9f-1e46-43ee-9a1d-0c3a429374f0	f4653d43-c413-4ec3-aa2e-e4d19ba0538a	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665557
4c11afcf-ad16-4d59-b794-e203c7457645	027bfca7-6b41-4271-a3d9-e870a54196e0	CREATION	\N	ABSENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665559
d542d56b-6f1a-4edc-8853-ef9b856b1666	585fd098-9f20-467b-8705-2007b61443f9	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.66556
fb84f6ad-3346-4460-b5dd-fe9c890812a2	8d604d09-3c91-4f6f-91a3-fa2ad37d364b	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665562
cb0d1ac7-f8e7-4245-8e51-81e2ed6f7c33	a04078c5-f2b3-4fb0-a3b2-afbe28845350	CREATION	\N	LATE	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665563
de30356b-2592-4e8c-b10f-4946d7f62efb	0ac2468f-95a1-45da-9e0c-26a781eac867	CREATION	\N	ABSENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665565
ca39cd4d-75de-4271-b173-d1f452faccfe	ba52a6dd-eed2-4ac5-820b-33a2478d2d25	CREATION	\N	PRESENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665566
f51f871b-a95a-46b7-b4e8-4b278815d5da	95a57c63-8803-4d99-b6c6-a76a3662db43	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665568
84d3e0e3-c700-49ff-871d-73a6b999caf6	393db446-89f3-4734-bf9c-cdae4f6dd0d8	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665569
289f0605-81de-4af4-bad4-18157ad6fd49	aa6d7c31-9476-41f6-9a6b-4716709db194	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.66557
d2a20825-8703-4f1e-b5d2-4b8140d40873	58d60d81-b7ea-4ecb-9331-277cd5567044	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665572
bc090ed2-b476-4b7d-a0f0-93b3b2e74051	762f85a5-2c1a-4707-94e2-5891e7be4206	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665573
70d78d94-d417-4816-bb5b-dbda2d8491ca	72123fdc-a433-4a16-aed9-e0334b412da5	CREATION	\N	LATE	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665574
e7d47a27-caaa-4ea8-9b15-d7d6a0a22fb8	2c252521-386c-4374-8d48-448ed4b8deea	CREATION	\N	LATE	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665576
87e11fb3-a0eb-47c6-9426-71fb8dc48664	26ccdc05-63ab-43f0-9be4-77f92666e929	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665577
d80239c2-3aba-4ff0-b3eb-9d60d38e98ff	83898051-d493-4e4b-bcdf-8611aa93e424	CREATION	\N	ABSENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665579
4268c55d-67c5-464c-8d8e-297ddc21073e	77e1f187-0a5e-49c9-a427-b6f11eb0a345	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.66558
dc87f435-93fa-41f6-b2e3-b045163c41ba	3cfce9a3-4a27-4623-b715-79e67354941b	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665581
ef7fd596-6f82-48b6-87a5-8164c59ab3f2	22c138cc-3bd5-42c1-b503-492bfb40c985	CREATION	\N	LATE	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665583
ada548d7-725f-44d0-b6fe-f4c69028e5f0	8f0ef1b0-e0ca-4665-a7b4-e25314427117	CREATION	\N	PRESENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665584
0df38c6d-33de-4750-bede-704a012b8df7	97417bdf-dfb4-46ee-9914-14159bf27432	CREATION	\N	LATE	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665585
0816b714-c373-4967-ba52-dee2a210104d	e2ebeb59-f912-49cf-88df-18b6c4abcc5b	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665587
1ea4b3ed-4369-4c01-aac0-4b8609ff361c	fac8d25f-166a-48b3-883f-ef549227ea5e	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665588
c044c869-6937-4f69-b518-c0b9811ab6f3	b4771c69-56a8-4583-ab07-7a5665b8b1ea	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.66559
5dbfdfe3-5cac-4b8f-8ba8-7dc0d7ff3fe1	ae302adb-edc1-4083-86af-60d458b50450	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665591
00a9fd38-7bb4-4a4e-b857-6ea6b4dd4e73	e7712ec4-576f-406a-bec4-a1808118c113	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665593
115d423b-aa4a-45d5-96d1-83cb132bf899	4d79b7b3-190d-4f46-9e1b-e0791106ef91	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665594
58042bb0-4c51-429c-8384-457c1d02f2f1	1c26cddb-f747-43bd-95cc-cd531519fd56	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665596
1c8cd9a2-7104-4825-86b7-79bbda4ff880	1f2a5aef-981d-443a-8ebe-138f704970f6	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665597
eb61b76b-9e42-4ec4-99ed-25a94ece64e4	1096dc6b-9271-4908-bbf5-181caf4d2db2	CREATION	\N	ABSENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665598
b826345b-1c15-4ebb-ac70-f4e00c6cd803	6158de7a-233f-406d-bb14-f78a5887d8f0	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.6656
54e570d5-f11e-4d8a-80a2-51111771e7a6	bab83bea-1b28-43e4-bdb6-6d641e547370	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665601
8b79b588-3f90-4f47-a1cb-5de5a7fcae20	19acfac1-eb4d-44d4-b79a-1cb980ffae54	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665603
6938807f-a0f5-41ba-bf07-84a3c0741082	70c7cd2e-e757-4adb-bd8b-fc89cb3bed2e	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665604
55a4eddc-26d4-455f-8c07-7d39a8d5aff8	671a08d6-67d5-41b6-8a10-a97a3c2f5d91	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665605
4e38a51b-150a-45ac-9a02-c20338257d78	0572a860-02d8-4c55-bb1b-2a821284846e	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665607
9fba46b1-7c64-4cc8-85c6-7ea2bde27e9b	50ceb2d4-fba4-4fa4-bd89-240a9297927f	CREATION	\N	LATE	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665608
9ced1f11-3dad-472b-bbd8-51ef3db4a997	a2fab147-203b-41e0-9ef7-43fa634e8646	CREATION	\N	LATE	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.66561
73bc69bc-dc01-495b-8b62-db7d76915530	64b4d6d1-6ae6-4b2e-8975-1dd5ca559d27	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665611
64a4a6dc-6648-4a73-9422-77013f5e235d	532a18f5-1a49-47ba-8794-323eebf43699	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665612
a3359c98-6fa7-4222-96c9-049b4be7882a	21fa589e-583b-4ea6-a48a-a4f80e185c17	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665614
ad791a36-6a39-4a3c-bfa6-94d774c16d13	07ba76fa-0084-41ee-a14c-ce59ed473a56	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665615
f78ef07f-bad4-4cb6-83ed-b8353efee7f7	a6c72fa9-636c-4ee1-ae70-e0dbf2df7636	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665617
e4d1d84f-f70d-4b5e-8909-0724c01865cf	22a474e5-d31d-48be-82a4-7aa8329a2b07	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665618
a970b3e0-9e0e-4d40-b88a-535e1738f9c1	eb2f8a34-6a15-4e5e-8b3f-88a0e80a3cbd	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665619
51d0063c-f948-4fff-a7b8-b70ed1a330a9	1080fbb0-647b-49c5-8f11-41f02cd8c8cb	CREATION	\N	LATE	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665621
6fe21941-6e94-4482-a61a-6ae24994cedd	35866177-ffed-47d4-9a77-d43a642194b1	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665622
c44ebb49-ce8f-491e-817d-474596a733b0	8e207a2a-6a02-4c0e-a44b-7b6491e95ca4	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665624
94dc6bc8-ae03-46b3-87b2-4d61cacb3e87	ab30a2bf-055c-4b22-83fd-b77241926ba9	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665625
fc9ea49f-f050-4226-8505-2ec21e418196	cc55eafe-fc67-4802-95dd-ddf9a3322c9e	CREATION	\N	ABSENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665626
b16117a0-6efa-4261-85fd-3ebd08314c73	8219fe2f-af15-4c22-8bc8-0e144bebc9c4	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665628
d8fe271f-982d-4e1f-a141-604fc277ca6e	d3ffc750-57c8-45da-9d14-0ea039286eb2	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665629
8aba1816-29a5-486b-b919-2ccc38880937	bea18fd1-dfe0-46f0-b792-a97033cbcafa	CREATION	\N	LATE	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665631
2ccb78a1-7fe7-4f58-871d-f09cae85b8ba	a32c8048-d149-47a2-99ec-4985cfc3fc68	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665632
2e2ea82f-3ff1-49bf-b934-c5b5ac64aa20	24ad77f9-0f48-41ac-a464-747b3f7e16c3	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665633
f0ed522c-3b30-4df8-9b2d-1f54f4b53766	ee058a42-f4a2-4e15-bc6f-f08ab06012e1	CREATION	\N	LATE	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665635
a42f4dc4-722e-4dde-8272-ff1824720e68	b44ea0d8-efb4-4a60-86ae-cd3e25694eb1	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665636
5c1ba9ad-5f91-49db-b48d-b8167b0af033	6c93d7ab-6151-49a9-983c-075936997d0e	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665637
d5231629-0dac-436f-b45c-66464b6c59ae	2e83dd38-627c-4893-b38d-c219691d2436	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665639
c72f024b-e6e5-442d-b3c6-d224dacdbd9b	51867a94-f69f-4741-98b0-5ae179a87432	CREATION	\N	ABSENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.66564
7c76e3ef-6d57-45cc-adda-0116937be79c	d3346c6d-2f8c-4074-9e3e-0b32a1eb4916	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665642
b2247b93-e247-4fc7-a239-0ad6c575b702	a3b93af5-a825-43f2-ad79-0edc6253c267	CREATION	\N	LATE	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665643
fe0296de-5bee-461b-9627-4a0d12352a35	a1fb8a95-5afb-4307-b849-49995b8cdcd7	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665645
867fc44f-9042-4471-8ab9-ab8a9d68a431	22461960-a973-4985-b64f-8b305f849456	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665646
5a014d83-7234-473c-badc-e8bb5121118e	89a97381-5969-4113-9263-e208e2a379c0	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665647
a5d809ad-7de3-4e16-9583-f5701997c2a0	1fe80810-dd95-445d-848f-57dffed33e50	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665649
040b4201-d101-474e-812d-74875e15e073	ed549930-efaa-4338-9a7a-eeb79a8f9a28	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.66565
d9a8dca2-d7a2-4ee1-8215-ba0920f796a3	8a99368d-cdf4-458f-9636-bc16fef334d3	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665652
6d5a8c6b-c5b0-40c9-ae0c-e8521a9e66e3	30b33d76-69df-4764-b4e4-83fdf7a987d9	CREATION	\N	LATE	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665653
90c19624-8be8-4201-b83b-2dc1896fa0cf	b136c836-b069-469c-be2a-224b4bc984af	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665654
f3de1514-918f-4d81-bac1-f1df07655d34	5b366404-6206-40cf-b9b8-9ff9db1cac67	CREATION	\N	ABSENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665656
6b5a9ddc-36a0-4d25-8ecb-97e6af511b4d	d0c2ba24-5656-41f9-b2ee-a740da6c7719	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665657
80eb27b9-dbf1-450c-a18d-381ade234f23	9a4538c3-e94f-4397-b256-fa690dd9fe54	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665659
099bdbce-4eed-4e8e-9086-323d4bf7bec8	c19cce20-6207-4bb1-ac52-8fd50bbbf10c	CREATION	\N	LATE	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.66566
94068b17-72e6-4581-98ce-378f24b0eb4e	18aaf01c-9464-4c5f-894b-3ea5e184f210	CREATION	\N	ABSENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665661
c088832a-3e48-48ab-8175-704339fe8223	77a09e01-dc39-4161-b4b9-12e9ba3eb4b0	CREATION	\N	ABSENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665663
d8e02ef8-b717-4668-a102-7c478bafe70b	b407572e-44c6-45f3-98a1-0499f85f891d	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665664
12638378-f356-4e84-a959-aa0594ddef76	3070f898-b62e-4bab-b938-329e0a50d62d	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665665
31acab8d-a1b6-47fd-9012-e68af41c1daa	a48ce8c6-1a4b-420f-a7ab-61b5cddc218e	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665667
0b22de3a-66d8-47e0-8c77-ae6a302170ad	5fb4cb57-cfef-49a8-ab24-005ea040ebd2	CREATION	\N	LATE	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665668
15828aad-d433-4532-92ad-b110ab50e559	fff688d2-4da7-41d3-a9dc-537e8cf7546d	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.66567
e288912e-a8a0-45c0-8a1d-e6e5964b7cd4	97e21007-05b8-4473-a9d4-74aad961e67b	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665671
91779d5e-06fd-4896-9196-d9466a4be8a9	060c7ea2-9ee5-4ec0-8556-f81243aa0fcd	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665672
a35b7e29-d70a-40da-a46f-aa2d7586aac2	0873007d-c3e0-4dd4-98b9-ba7d29589fb0	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665674
39909a42-4304-4652-9078-ce9a65e8239e	98a5db10-885f-41aa-881e-dc1549aee68e	STATUS_CHANGE	ABSENT	ABSENT	Cambio de estado manual	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665675
e27dbbd6-c214-42ac-ac67-56f85f7a2e6b	2a807d0c-5f3c-47f1-a535-f162bbbcbfe6	CREATION	\N	LATE	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665677
00a0d125-ecd6-4ff8-98e1-b3353b196c52	9efeba46-5053-443b-abef-c89c4372a93d	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665678
b8a0f1e4-d57c-4634-99fc-c0d6394d2335	a344ed64-b574-486d-abbe-bc288f2d97fa	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665679
f8f432aa-61e6-482e-867e-b21ce9cb1694	eb99c74e-cfc9-4335-9b4a-c766b3c393d8	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665681
96c4519e-5893-49d4-9175-379ba6c9424d	2f478c5f-58d8-46b5-99c7-c2a545116cbc	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665682
96540ab4-bd37-4986-8309-f66da545b6ba	4e26bec9-8860-48c2-a8e7-e65ffaf88a2f	CREATION	\N	PRESENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665684
f0d77c9a-e791-4923-b8ff-2418baf1bece	c8913fa4-363f-4316-9745-e40a85f4bacf	CREATION	\N	PRESENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665685
2e49a57f-0d1e-42c7-bf7a-6599ac83269f	eb585ca5-1b23-4a65-8806-addd4b2f5159	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665687
a81dd421-c012-443b-b879-03b59319f39f	56adec2b-d54d-41e3-9b4a-9f361751c49d	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665688
7e61b9fa-53e6-4c41-a77e-f305360a6471	34f56c4a-cf12-462f-b985-d4a6acfd6c3f	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665689
ddc2f9a2-6f77-4da2-a151-b8930ddfdbee	f36eff32-7089-4ad3-a8b7-fd97cc468cab	CREATION	\N	ABSENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665691
bbd688cb-1406-4583-8984-dfd99afdc5c1	40bc7f5c-a213-447b-834d-04402738583a	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665692
e4cddbca-d9e6-402e-b3e8-b4335a9ea1a8	a5e25e99-85a4-47ba-b682-2f15d1107cf6	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665694
9483f075-bf21-4535-a6c4-8805ec585013	7128a425-f184-4103-861d-39ca3afe6171	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665695
67ade9fd-d6e7-4dc8-a998-be5392a98a4f	436ab16c-b7eb-47e4-a12e-f68bbe8d738a	CREATION	\N	LATE	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665696
5e6991b2-7a31-424a-a166-5338388e94d1	3b54adcf-d990-4b2a-ac6a-0ddc46f86049	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665698
f186f239-e9a9-42bc-9953-e0ebf3923a41	c26f4660-fe1e-4345-98ca-d4cf963f5370	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665699
b6c20055-0e02-4c9c-bc49-2ff30039f751	09148aa7-5adc-451e-96f0-9b3bdd2f3fd4	CREATION	\N	LATE	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665701
8e5b6c82-9a61-48c3-b1e8-a70a64c16241	c84b9ed3-d538-4dcb-8b53-4846606d0ad2	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665702
b8246235-5bcc-41c7-bb7b-bc6f46377948	a19100d1-0d13-4682-9da9-e8916d204c96	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665703
24e84d81-b41d-48a4-803c-01371ad1eeee	980ebe9a-6c2d-434b-b522-7b644e40a2eb	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665705
8c92d93b-2e41-480d-a272-fb111f9d5ffa	ee3fbfd8-86a8-4be6-9f4d-3b849d2ed384	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665706
a40d6389-d10f-4adf-a1cb-981c9428b01b	b05cc045-6887-48ad-8e2d-1bc7f97a7250	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665708
3d22fac6-0a52-440b-b1b7-c28020f69222	b061da81-7f87-4aa4-8ab8-e50f1411331e	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665709
5b31e3ed-7044-456b-9446-cce095b82da1	e7a06922-82ef-43a7-a166-3a0850ad0811	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665711
3adfe691-7623-4423-841b-1fe10fd17690	cca7726c-2c2c-4064-9f9c-80e00cfbe2ba	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665712
ae53d553-ccbf-487f-aa21-604e0e01cf8b	971b474a-52e9-4f6b-aab3-30fd0563c426	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665713
ecfb9162-e560-4e48-aaba-6f9548c2c985	72d97848-c322-48d4-9640-abf7217aad05	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665715
42c6328c-d12d-44a8-982b-42be462baadf	897e9ec5-b68a-422f-8b83-c5424a9964ff	CREATION	\N	LATE	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665716
c7539bbe-f248-4817-9141-4fd0024928d4	68327f03-e61e-4f6b-b5ff-3137ee790063	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665718
143fc9a7-14db-4802-a05a-116ace5c240f	80801d42-d115-47e9-b78f-b0abcb28bea3	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665719
1405ced2-6745-4ea7-a1f1-ed6ffd856e13	06c27398-50f3-4ac2-b737-9d6f91f2725d	CREATION	\N	PRESENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665721
8d95e166-efad-406c-9c9c-bf9ad0a8e78a	fe53aa47-8266-42d5-95c7-869466207e71	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665722
2b6a883e-5172-494b-bdf7-8b79ff199a57	11bb8a06-3f7d-4721-a127-8c44daa8bc61	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665723
50bcbd22-1b37-4114-bd95-cba369f4e586	24babec0-8c4b-4086-99a8-c1be079d0009	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665725
b008efe0-6c88-45f2-8f9b-063475cab621	cd11524a-c0f7-4abb-83a3-02ea7c021843	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665726
6ee5f3a2-3dc6-43b0-ba15-53d9d3be94ce	1c1f51b4-b380-4d70-b2fc-be9a35b55ea4	CREATION	\N	LATE	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665728
aef0b8a8-2c4f-4e5d-9418-47114c8f948d	d9d4a895-fbb1-45c2-b66b-3a7314d4c104	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665729
ebf01376-01a6-4ec6-a72c-8f8f63866672	31ed5e50-30f2-45fa-9e63-f7f492e6b94b	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.66573
387449a9-9b79-4328-b202-fa724aadc5b7	56fdbf0b-ab80-48cf-bf9b-cc6d6f19bab3	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665732
157a5032-eeb3-403b-8462-60ceaba9313f	f9cec2f7-3634-47c4-8daa-88868d5c53c8	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665733
500867ad-b930-457c-9186-e28b4fdd95d8	633852fd-0583-4902-a4b7-c5e669ecff90	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665735
a65ae9e4-1153-48f2-bc22-ab868c7c658c	d78bce61-f13a-4d94-ac4b-2f8a61b54c0a	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665736
a32d5958-dca5-4a62-a0da-d547ab8a52e1	08dc58c1-21b1-4728-918e-3af81742944a	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665737
aa322204-61b9-43a5-91b5-bd96853a7ba5	136dd2df-b638-418c-a94c-06571dca8f9a	CREATION	\N	LATE	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665739
e6d9728b-08d2-464a-9a7d-63704f2c1ed6	2b689939-925a-46c5-a2f1-72eb669d1f05	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.66574
89fee5a2-8bdc-449b-a59c-253b49cc445e	303f2b1a-a58b-4849-ba9a-39270d2642d4	STATUS_CHANGE	ABSENT	ABSENT	Cambio de estado manual	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665742
a29ca217-c798-47fd-87af-6ef5ce5ad2cb	3de669b4-df05-4b45-8bba-314b908f96af	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665743
668ba863-e43f-4b48-a338-b120d49eb3a7	7dbc22ea-32ca-4a3b-9de4-20a185b24072	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665744
6462a03a-7677-4452-9768-9adc207e5ce2	32f9f3f9-15d5-49eb-8c1f-809ee839faa5	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665746
fd4520c3-2996-41d8-a6b1-9de18a038cfe	b183a669-16f2-415a-bed7-8dfa15940904	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665747
28cd55c0-9e49-49c6-9e5f-6b0222d61f68	643bae69-4ea1-43e0-806e-cede40e41e94	STATUS_CHANGE	ABSENT	ABSENT	Cambio de estado manual	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665748
150dd6a5-ba39-4328-9306-8f7b580e2510	ee646af2-623f-4632-b137-a0aaeb4fa42a	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.66575
67337a39-9e78-4cda-abcb-20265496ee79	b18fe9ed-7996-4014-9531-7ed8fbdd340f	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665751
ffe3a332-32e3-4b7d-bd7d-298764aa6b70	2d6a9a6a-64fd-4fe8-bbf9-6e4f311f1e8f	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665753
bf09e0a0-c2e3-4c0c-bfd5-89a3921dc012	8fae07f3-84e1-4083-9b6a-ea8221092c8e	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665754
c9b7d9b7-6ac4-424e-a555-adb3f7bced8b	8c17dd00-e45a-46af-b130-e9f12f74e5e6	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665755
bf7ec3c8-7664-4413-a675-0d962a76046b	9b964540-af36-47da-8d4b-870c009a564e	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665757
6da14c84-7118-43f2-b352-ad7763468b3d	2e42ffd1-299b-4838-a312-5dc67cf8f4fe	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665758
96ebfb87-e317-4a4f-8334-858478a97dfa	b1020906-83bb-4db0-a76a-92c19244ab39	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665759
d25e2c7b-0861-41b7-a7b9-74dc86265f09	2ee9a220-41ed-4b14-bfa0-b4e479888a82	CREATION	\N	LATE	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665761
cf03ce86-026e-488d-848f-509bd7d6e104	c75e34f6-18d2-4841-bcd3-df3e246327e1	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665762
3694bf78-15cc-4916-b1dd-beb0743526e4	c87e41fb-6903-429e-8d0a-c17999bb7761	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665764
f01ed40f-1d84-4aec-bbc2-50d736a0d775	3a315f35-c743-46e5-9167-dcf0b2761859	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665765
1781ac4a-cd9e-45a0-a3dc-2163e25f4f36	7a2959e2-e254-4a6c-bf03-0c6981903112	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665767
f5c985d7-c8ef-4a0e-bfb0-4e1e76514396	74c0c019-57f4-41f4-bbb6-e44ae849a5cf	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665768
a13d05ef-47e7-49bc-b377-e7824854a611	4335cbed-47b5-4632-afde-916fe1b06901	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665769
25d86551-53dc-42f2-8c79-1a0cab9f0580	7635ab0b-0ea7-43a4-a2e2-2f1b0d3589c1	STATUS_CHANGE	ABSENT	LATE	Cambio de estado manual	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665771
eea08669-31d0-4070-a0d8-1f1a9fc70ad8	088e8a60-098c-461c-9a4d-10500440f121	CREATION	\N	ABSENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665772
9c4f9d64-dddb-4837-9e5a-a23df308f6f6	cb1485db-8358-426a-8b6b-ddfbd68d53b2	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665774
69a5acc1-e5a6-4975-9467-fa7a4dc95528	74fda793-1594-443d-8389-97059c0359b2	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665775
19b2bdba-e80c-49d9-b18c-7d6e4c851a61	60e79acd-d430-4db4-9114-b16b2ce761a8	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665777
ca0d7190-7628-46ad-8f97-148f1dfaeaea	60c1f9d5-1153-458a-ac62-500cd5fe445e	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665778
5a31f3d0-4285-4d7c-b910-4329bc56a7ce	dd1a746d-5bc2-4025-b1de-68ea6f7a80ad	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665779
ae5176fa-2548-4495-a826-442b69e7114d	846bb217-e9a1-4aae-8f88-bdb1765ed078	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665781
443a89dc-62de-4be5-bfab-370437245412	86f27bc8-0e1e-4701-aff1-3a260f190361	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665782
dc1caea4-4ba1-425f-8f28-a5ee7125aa4a	915dab5b-ccb9-4f38-a450-45c2248cd1d8	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665784
4e1eff52-ce23-4b83-a427-d290baf0bfd7	114caed6-5242-4d65-8a5b-9faaad07ff7d	CREATION	\N	PRESENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665785
a3d39548-dbac-453a-b9b1-66211ba62720	bea483d0-26ea-4af1-92f6-523bb7804b76	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665786
87fd9532-199f-41b1-a6e7-f90b1f8ed85b	2bb4a337-b5a1-44e8-94f6-4701f3bcc1dc	STATUS_CHANGE	ABSENT	ABSENT	Cambio de estado manual	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665788
df5467d1-8192-4583-bfd4-376976a787cf	89b0fee2-d443-4c6f-ad8d-0cd928b21cdb	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665789
6b101618-15f9-4d07-a46a-b0e6797711a6	c454e46a-5ff5-467c-8af3-ea335ff10c7d	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665791
a188269f-0e27-4c93-b3e7-d70c0f3a3e21	a0901362-2bda-413a-9df0-d7d1ce11acec	CREATION	\N	ABSENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665792
f60c9e5c-6e11-4e41-9a7d-fae82ea445fc	8782e8e6-46a8-494c-9dd7-b8fe6917f8e3	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665794
158c4d63-f78a-451f-8f3b-dd302e0dfb01	f155c6b1-e71d-4e78-9d0c-d9228840c3aa	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665795
f140c68f-4a5a-4f4e-a6b8-7f52e4cd0798	e3105897-1822-45d8-a90f-4c2e5b7b05f1	CREATION	\N	ABSENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665796
69913102-32e4-4a96-abf4-6dcd31746295	f9dbc815-af91-42f5-91b7-2297faa4a61e	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665798
0e572207-2cde-47cc-8d41-4f851a92f0de	968dee25-2de0-4b78-8d6d-b2f1305354b9	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665799
363c1449-6a9a-4349-bb23-ae9bf9f79529	606b5836-c73c-4b39-bb0e-200284834d73	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.6658
f2f1d840-2294-4ef8-bb21-1d2379b8e2ea	90d68483-0bcc-4103-a512-0149caba9767	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665802
913251fc-01c9-4df8-a887-b5bd8edcf020	4b193e1b-4fb3-422e-9432-e04e3c986e83	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665803
7c30570b-e37c-450b-946c-3337df005336	e5bfa665-a2f2-429a-ad87-ce94cf74dfa3	JUSTIFICATION	\N	JUSTIFIED	Justificación por enfermedad	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665805
bdbe171c-38ec-4d06-893e-cda35fb3c43a	75a04d69-339d-48ea-80a6-76adbbb474a2	CREATION	\N	PRESENT	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665806
c5d14baa-6f90-44a6-ad8a-948d0afdc2da	3c763ffa-2f4c-452d-93e6-9bc8f502f86b	CREATION	\N	PRESENT	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665807
07166275-262e-4652-a8fa-3059e8e68b27	5229dc75-eec4-484b-860c-97e11d6906f1	JUSTIFICATION	\N	JUSTIFIED	Justificación aceptada	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665809
0f842fb4-9319-4280-bfc1-ae435f9f6638	26485634-3948-4b51-92b3-65dbb97da4b6	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.66581
fd8fffc4-31cf-4a72-b037-4a5fea5c6a3b	dd6efcd1-a517-4160-8484-fc1213360ed5	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665812
0008a9ab-1406-4a67-8bf0-6335a572ecfe	ad89709c-136e-4960-bce1-2a489ea1ca53	STATUS_CHANGE	ABSENT	ABSENT	Cambio de estado manual	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665813
7bc31b07-93f1-4ba9-83a2-b676839f17ec	59035a65-1bfa-4490-abbc-71373c46f1b9	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665814
966e1a60-a1aa-4572-8122-5796cf0ec6ad	b6c131fa-9873-4e68-8ff7-2df19e780fe3	CREATION	\N	LATE	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665816
7c773982-ea3b-49b2-88f3-2458f4d883b2	dbe2f1db-dc0c-497b-ad4b-a206a88ef439	CREATION	\N	PRESENT	\N	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665817
9c4a6763-7d01-4165-ba3a-8cf363f984b9	33de9a18-0148-45e0-9323-52b48fa90809	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665819
ac475ff7-d0d8-4781-957f-bfaabd2aa1a8	73385f53-49fe-4aaf-8336-344c7963b7ec	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.66582
def3094d-0414-4f48-b5f0-81dd81ce7ce0	ca3f045d-b014-4e96-8a8d-63c7b274ac9f	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665821
c996880f-8cb5-4507-a332-c03be017b8d2	c3e5736d-0963-4142-bf87-cbaed3041d86	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.665823
22c1b13f-60d8-40ae-96a4-44d44d756f76	7c6c9818-bcf4-4e93-8a80-0f2133a8ba79	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	dd793121-b7f3-4a66-a517-42c10fcc06a5	2026-06-06 22:00:27.665824
75526e26-8331-46de-898c-6f252d0563c6	60ed16f1-5684-4c1d-acbd-a70308d0280c	CREATION	\N	LATE	\N	3cd3e8a4-f163-4265-b39d-31f2a1592570	2026-06-06 22:00:27.665826
60340632-15ed-49b1-9e9a-b6099eb15dc8	044a9d4a-5fb0-4a3b-96b8-ae0066250a65	CREATION	\N	PRESENT	\N	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2026-06-06 22:00:27.665827
6628a414-9677-41d5-9d25-ca83fdbace26	c97c7f0b-d71a-42f6-b318-88e9a62923c0	CREATION	\N	PRESENT	\N	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665828
f5777295-f095-459b-a000-78274aff919d	4d4d213e-de67-462a-8a8b-3942c3f2a67e	CREATION	\N	LATE	\N	faf73658-e40a-4abe-9d93-3ec6e7da1040	2026-06-06 22:00:27.66583
daddfb94-86d7-4399-9152-47e7dd801a44	96f41c00-42e6-4557-8202-648e29ffc3b7	STATUS_CHANGE	ABSENT	PRESENT	Cambio de estado manual	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2026-06-06 22:00:27.665831
cadc4e00-9ad5-42e2-8db6-a462ebcf951b	f9896537-bcd3-4c4e-b1dc-44714ca006d3	CREATION	\N	PRESENT	\N	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	2026-06-06 22:00:27.665833
a2c1500f-5ebf-480e-8616-69433583353c	5cc8e14d-0014-4b70-a855-9a3197d7ac69	CREATION	\N	PRESENT	\N	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	2026-06-06 22:00:27.665834
79c902b3-c4e9-4f96-8b37-fa6fc7d708d8	a94feaa1-003d-4c19-af47-1382b482b95e	CREATION	\N	PRESENT	\N	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	2026-06-06 22:00:27.665835
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classes (id_class, id_teacher, id_subject, id_group, id_period) FROM stdin;
069e299d-9ef1-4d67-af85-1729d39efc78	3cd3e8a4-f163-4265-b39d-31f2a1592570	991e2700-cfa9-4591-b1bf-d7a3ad2769e5	f6ae2831-2e35-4b37-ba1c-8847dd39fc7f	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
bf1896c9-e9c9-4afd-9328-372fbed03964	3cd3e8a4-f163-4265-b39d-31f2a1592570	b19a0dbe-09b5-4942-9fe3-09f13de20a31	f6ae2831-2e35-4b37-ba1c-8847dd39fc7f	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
9fa006fa-0f74-49d0-b405-9a96d9d27785	3cd3e8a4-f163-4265-b39d-31f2a1592570	116af7d2-0e28-465d-ac58-4b1eb777653b	48ae7ecc-f23a-4563-a5b9-3227f64c91e6	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
e0220c71-4670-4133-ade0-693941a03ea4	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	351237e6-5bdc-42a1-a373-b29c185b592c	3052cd63-1645-4507-8d07-a5e732fe938c	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
ad1ec0fb-7398-4f7a-9653-769565330b46	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	f766c156-8964-4d92-af2e-88c5560ed655	313e5020-dcca-4ced-a1ea-69d8d7a4e457	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
4f6b60dc-a542-4a5c-b946-69af663c401b	ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	88618baf-2855-4435-bf2f-aaed75455b9c	8e97f695-d211-4957-9d1c-f70b305b9ae7	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
95987e5a-5a06-425d-9b3f-62d2efbc260a	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	c6b3b67f-d4eb-488f-99b4-8d0c6172f39e	bcb634de-2dc5-4bde-b0cf-668ba50a2f4c	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
376b8ace-74c2-4f1a-88e4-04bd8683dcbe	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	697c1a17-4ade-4682-8268-f5257b5773d6	8deabb55-b9b9-4bab-8b54-296bffdfac1b	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
2b8b1a41-01ed-4cbc-8138-a9ace9957528	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	d92e3f87-8c1e-42f9-924b-55975db369cc	043aa3f6-3483-42b3-843a-b962626c947e	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
88321b86-dcd6-4fa5-b01b-83891a6b945c	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	6a3557af-f475-4411-be03-c149a6abfca7	ca0ee015-bf73-407b-bee0-47fcc80d392a	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
74fdbdb4-ef0a-45d6-b4c1-be03605ad829	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	2800cf4d-0438-405e-8c36-535eba33b3a1	db29b776-57a6-48b7-8607-cb2749ecdd8b	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
d721eedb-2e39-431e-b3d0-122e135aa628	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	ddb06fe1-04a6-4505-8dfa-2ee72911e75d	861e86b6-697b-4a19-b536-f9a9d9c4a64e	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
516d8f80-ae71-4a61-81e3-157cf6ae6be7	dd793121-b7f3-4a66-a517-42c10fcc06a5	2ac87119-b13c-4e5c-8e43-830c70faeacb	e91e4a5d-3b43-4ca2-8d55-6ee2aaf2d075	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
679e9757-8d90-44b6-97f6-f11ef00f3a6c	dd793121-b7f3-4a66-a517-42c10fcc06a5	d7895b15-6326-4894-a5d8-059bb96c9af5	921c3b1e-a620-4fba-89b4-2d1a2345d939	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
9d9afeac-3020-421a-bae9-a9ebd4980fcb	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	2d07416c-b641-4d1d-bfc9-49b990c4f07a	ed7519d4-8086-46f6-ae16-ec69f746d394	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
86e1ae58-a186-47a3-a212-5eff6526b974	36b54513-3d1e-48de-ab5d-d4bcab8e64e3	28e73204-3d9c-4cf2-b3cf-c43496c8f3ce	ea3a6f23-ed04-4dfa-8e14-76ad6629198c	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
edc7dad4-08b6-4865-a87a-3b3b944c9637	faf73658-e40a-4abe-9d93-3ec6e7da1040	2c7fc36b-04ce-4e27-b92c-91b49557fa96	03f75a98-f6e2-4741-b4b8-702241a6172f	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
02663d0e-87ab-4c1d-9292-1664b4377cc6	faf73658-e40a-4abe-9d93-3ec6e7da1040	33c827c9-fe38-49b7-89ab-5362c24a30df	187eed02-52c0-4241-92a8-860d6e93969f	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
d28a1e6f-8803-4e9d-ae3c-23123cf1931f	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	d2926248-5b03-4868-98ce-aa1cc15154b7	d51dd354-a529-456b-9cbd-a95a5e80583e	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
c04e0158-0e80-4cc8-85c5-c7ff1a00225b	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	ade7ac2c-78ec-49a2-b29f-78626c1114ef	6ec8ce66-2e41-498e-84e8-b11f6f47acc2	b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c
\.


--
-- Data for Name: classrooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.classrooms (id_classroom, pavilion, type, latitude, longitude, allowed_radius) FROM stdin;
5993162f-2faa-436d-868c-2e6fd41afaab	A	SALÓN	\N	\N	\N
2ad28dde-182f-4114-887c-6b2c95875b5d	A	SALÓN	\N	\N	\N
9debd9f0-2efe-4d63-8866-1b4aafb19fa6	A	SALÓN	\N	\N	\N
fdd78d0a-16d3-4a0b-a255-19bdab1335bb	A	SALÓN	\N	\N	\N
ee96f90e-3e42-4141-88fa-d7be7e2fb8e7	A	SALÓN	\N	\N	\N
4b9fd945-11dc-4480-9309-f252a082f029	A	SALÓN	\N	\N	\N
6cc09658-319a-40b9-b616-b0536c27b555	A	SALÓN	\N	\N	\N
293d282f-1389-4756-8a76-9b1879315439	A	SALÓN	\N	\N	\N
ca1b243e-fe66-451d-8988-c27303c75ba2	A	SALÓN	\N	\N	\N
c67a0297-6e74-4b31-a257-023783fd6bcc	A	SALÓN	\N	\N	\N
de12418c-8905-4c19-84b6-d10f91fc02d2	B	SALÓN	\N	\N	\N
a33e34d3-9989-40bd-8577-6229770a9150	B	SALÓN	\N	\N	\N
6ce5f225-989b-4382-b6f1-8a4231113a1c	B	SALÓN	\N	\N	\N
37723e46-c4c8-41bc-9438-87b5102c0e17	B	SALÓN	\N	\N	\N
712c3034-43e6-4ec6-a316-a8bc0c98de72	B	SALÓN	\N	\N	\N
18538df1-f05a-49d6-8e46-a26346890db0	B	SALÓN	\N	\N	\N
ae36bd11-8d3c-4e4d-bfc2-f909bdf3b5ac	B	SALÓN	\N	\N	\N
05201eb0-de88-43a5-9dae-19c6b8f35667	B	SALÓN	\N	\N	\N
e0694bed-44e4-40a5-9ea9-5946fd45cf1f	C	LAB	\N	\N	\N
c0a919d8-6d49-4876-8325-b96d8a6952c7	C	LAB	\N	\N	\N
cb2f6f0f-a443-4396-a752-b6757f21faf2	C	LAB	\N	\N	\N
2c657dfa-4ad0-4568-94c3-0dae0f4040f2	C	LAB	\N	\N	\N
b5c2f738-ca9f-4e49-bea1-a02969dbf3e6	C	LAB	\N	\N	\N
b12fd2eb-e16b-4931-bdbd-1c3918053bc0	C	LAB	\N	\N	\N
c5c90fcb-8f4b-4b62-8e2e-d22f6a20a03c	C	LAB	\N	\N	\N
89b43388-b396-48d7-a8ac-90a67dfbc4f6	C	LAB	\N	\N	\N
32b7238b-7c72-4fd1-accf-2643addcef1c	D	TALLER	\N	\N	\N
468276b7-faa3-4027-898f-6b6931bbf908	D	TALLER	\N	\N	\N
433c7ba8-22bd-48e5-8a98-672a8fea6b22	D	TALLER	\N	\N	\N
eb3f1da0-9b3e-41df-b095-df6de0e1ea8e	D	TALLER	\N	\N	\N
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id_course, name, id_area, duration_years) FROM stdin;
6e8acf3f-bcb6-4b54-a593-04e6d30d07c0	Ingeniería Civil	bb6a04c5-c7d2-46d0-bf2e-531351b176cb	5
d603f622-e1be-4093-9e1e-a1208a3e1831	Ingeniería de Sistemas	c5546739-c8fc-4875-b4f5-58b4532abf0b	5
8c5ff310-7cf5-40ca-adb2-e705628d251f	Ingeniería Industrial	c5546739-c8fc-4875-b4f5-58b4532abf0b	5
8483d94d-4edd-476d-9b8a-9c28e9310657	Arquitectura	87df83f0-c031-4243-8c20-d5715006ba8c	5
a82ac075-2f05-477e-b393-94b33403a8a0	Administración de Empresas	9e74aca1-918a-415d-ae9f-e7b8831eb6dd	4
dce66adc-2126-41ca-b347-f70abc337bc3	Derecho	9e74aca1-918a-415d-ae9f-e7b8831eb6dd	5
1c8b3db4-2850-448a-989c-6d293f4989ce	Medicina	bb6a04c5-c7d2-46d0-bf2e-531351b176cb	6
9df01df7-2683-412d-99ea-49f704095fc4	Diseño Gráfico	87df83f0-c031-4243-8c20-d5715006ba8c	4
\.


--
-- Data for Name: enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enrollments (id_enrollment, id_student, id_class) FROM stdin;
ddbff49c-a8ef-4f2d-b0c5-40d823bc8d82	2fc60451-e195-4038-96f9-0fde54fe06e8	069e299d-9ef1-4d67-af85-1729d39efc78
07340115-46a5-4082-80a9-2111d4edfe51	2fc60451-e195-4038-96f9-0fde54fe06e8	bf1896c9-e9c9-4afd-9328-372fbed03964
6f150f2b-881d-4216-a5cb-7f4f7d066011	2fc60451-e195-4038-96f9-0fde54fe06e8	9fa006fa-0f74-49d0-b405-9a96d9d27785
3b798ab6-af9b-4ec1-b61e-0369b662e76a	60312bc6-4b87-4433-b945-549246dab02c	069e299d-9ef1-4d67-af85-1729d39efc78
3f6e8c8a-092d-4959-ab6b-b89fa404dae6	60312bc6-4b87-4433-b945-549246dab02c	bf1896c9-e9c9-4afd-9328-372fbed03964
22a7b591-e40e-4fbd-b9b1-a21b24e62a9e	60312bc6-4b87-4433-b945-549246dab02c	9fa006fa-0f74-49d0-b405-9a96d9d27785
a5520a0f-ea9b-4979-86b8-2867a54e3f08	90b6848c-4a8e-447a-a391-b4fdf2fced42	069e299d-9ef1-4d67-af85-1729d39efc78
50bd65b0-2e00-4b9e-9d8f-e1f22f4020ac	90b6848c-4a8e-447a-a391-b4fdf2fced42	bf1896c9-e9c9-4afd-9328-372fbed03964
26772460-7cfc-4051-bb0b-72d0d4a1943c	90b6848c-4a8e-447a-a391-b4fdf2fced42	9fa006fa-0f74-49d0-b405-9a96d9d27785
263114c7-38a8-44cc-868c-77bbb7b08d2f	f513bdc6-4405-4051-a139-a9b2c156827e	e0220c71-4670-4133-ade0-693941a03ea4
0d61b784-f181-47fa-8caa-5255835aa6de	f513bdc6-4405-4051-a139-a9b2c156827e	ad1ec0fb-7398-4f7a-9653-769565330b46
76dcc6bd-7636-487e-a1bc-b1961e475fe1	f513bdc6-4405-4051-a139-a9b2c156827e	4f6b60dc-a542-4a5c-b946-69af663c401b
1552b459-1414-44e6-b38f-6402927151a1	78f3e5e9-1a20-4230-a0f1-8d6708510733	e0220c71-4670-4133-ade0-693941a03ea4
bf30c252-42bf-4bfa-8380-b3f35e441876	78f3e5e9-1a20-4230-a0f1-8d6708510733	ad1ec0fb-7398-4f7a-9653-769565330b46
278b0783-22b1-462f-9a3a-4438412f78e6	78f3e5e9-1a20-4230-a0f1-8d6708510733	4f6b60dc-a542-4a5c-b946-69af663c401b
ea9e471a-4412-4ee2-a7cc-6bf921e57cac	4bf30010-daaf-4197-9cce-c792742fabdd	e0220c71-4670-4133-ade0-693941a03ea4
f1ab18ce-884d-46cd-a3d2-d3df4aefa960	4bf30010-daaf-4197-9cce-c792742fabdd	ad1ec0fb-7398-4f7a-9653-769565330b46
52ca3e6f-8b09-4f30-b73a-75055547435c	4bf30010-daaf-4197-9cce-c792742fabdd	4f6b60dc-a542-4a5c-b946-69af663c401b
d7398ee4-b335-4565-8372-5267107e9515	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	95987e5a-5a06-425d-9b3f-62d2efbc260a
bb2ae28b-f308-4604-8326-d18a39ee5f3e	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	376b8ace-74c2-4f1a-88e4-04bd8683dcbe
81d77b48-6202-4450-84bf-0db3947c195c	1e430cd0-f63d-4b2c-95a7-62fe9b907abe	2b8b1a41-01ed-4cbc-8138-a9ace9957528
05d55e5a-d7cd-439d-b396-e151394613d5	2b6abd12-6a83-4789-bf54-d577970897a1	95987e5a-5a06-425d-9b3f-62d2efbc260a
9966bb97-96fa-41d6-9568-6a72136a5b6b	2b6abd12-6a83-4789-bf54-d577970897a1	376b8ace-74c2-4f1a-88e4-04bd8683dcbe
ed0c63e2-b2ba-44e4-b17d-4cc284cf2fc7	2b6abd12-6a83-4789-bf54-d577970897a1	2b8b1a41-01ed-4cbc-8138-a9ace9957528
af36ee53-0d75-4002-859c-3edff1ea6c0a	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	95987e5a-5a06-425d-9b3f-62d2efbc260a
035f580d-5471-48c8-a703-1146279f5c5d	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	376b8ace-74c2-4f1a-88e4-04bd8683dcbe
9881235a-77f4-4c2b-aac1-1e4c14ab176d	50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	2b8b1a41-01ed-4cbc-8138-a9ace9957528
98d08054-cc73-431b-adba-41479941b90e	af583bcf-eeaa-451d-988d-987d293cb523	88321b86-dcd6-4fa5-b01b-83891a6b945c
59e716a6-00e7-48a6-8bf6-8b0aad20feaa	af583bcf-eeaa-451d-988d-987d293cb523	74fdbdb4-ef0a-45d6-b4c1-be03605ad829
9b20dedc-2a32-4fe4-8d6e-fdcd003861c6	af583bcf-eeaa-451d-988d-987d293cb523	d721eedb-2e39-431e-b3d0-122e135aa628
8250e9e1-336c-4dcc-8480-32d4326d8054	f63c1fcf-9552-474d-836b-b77bfdcae1ce	88321b86-dcd6-4fa5-b01b-83891a6b945c
5be7012e-49eb-4011-a4c6-dd9c8325a619	f63c1fcf-9552-474d-836b-b77bfdcae1ce	74fdbdb4-ef0a-45d6-b4c1-be03605ad829
d4688621-0914-4da0-ad8e-b166bb094af0	f63c1fcf-9552-474d-836b-b77bfdcae1ce	d721eedb-2e39-431e-b3d0-122e135aa628
7a24c46b-b2ad-42be-86bb-57540fcd1208	d88bf4a1-0278-4023-a674-0faa04857eb6	88321b86-dcd6-4fa5-b01b-83891a6b945c
471368de-812f-4a3f-b9a8-90e2f3774986	d88bf4a1-0278-4023-a674-0faa04857eb6	74fdbdb4-ef0a-45d6-b4c1-be03605ad829
cf658236-0ec6-43c0-a744-99bffc415706	d88bf4a1-0278-4023-a674-0faa04857eb6	d721eedb-2e39-431e-b3d0-122e135aa628
bffca3be-fa45-465e-89cf-3745071446bd	af1756ba-1982-4621-9340-1528c61ce0e2	516d8f80-ae71-4a61-81e3-157cf6ae6be7
3e2e50fc-0f73-4bce-9026-6bb2833ecc53	af1756ba-1982-4621-9340-1528c61ce0e2	679e9757-8d90-44b6-97f6-f11ef00f3a6c
ef6af3f3-af7e-49c6-8493-314f59d1baf8	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	516d8f80-ae71-4a61-81e3-157cf6ae6be7
a0f6adf8-c0b1-4139-b4f6-4d7b480548fe	f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	679e9757-8d90-44b6-97f6-f11ef00f3a6c
3a79e06d-b1a0-4cd3-bacd-efd31a391d5a	1a34ac02-47c9-463a-9454-fcff07b08dd7	9d9afeac-3020-421a-bae9-a9ebd4980fcb
8c7af7fe-87c2-4823-a722-077d4e5164f7	1a34ac02-47c9-463a-9454-fcff07b08dd7	86e1ae58-a186-47a3-a212-5eff6526b974
50c57d16-88e5-4f6b-b457-3ce60982353e	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	9d9afeac-3020-421a-bae9-a9ebd4980fcb
a886e8de-6d9d-443a-b5de-d79cb421f031	1f56c43e-b4d2-4901-af59-d5142d0aa2e5	86e1ae58-a186-47a3-a212-5eff6526b974
5f7b0afa-2215-4d7d-b002-0f5b5fd51786	634e1ef3-b7dd-45b9-82d3-f259314d39ac	edc7dad4-08b6-4865-a87a-3b3b944c9637
ed7a6d49-cd50-4d40-b4bc-40dd08ab60c4	634e1ef3-b7dd-45b9-82d3-f259314d39ac	02663d0e-87ab-4c1d-9292-1664b4377cc6
bde62b08-5f24-4fa9-87a3-3749e78967da	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	edc7dad4-08b6-4865-a87a-3b3b944c9637
bc58d972-b88a-40e1-8fc1-ef20b629e61b	c430bb4e-5b38-4b76-afe3-8f53bf7daeda	02663d0e-87ab-4c1d-9292-1664b4377cc6
4dd9cf54-76e4-4b4c-855e-df889657b328	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	edc7dad4-08b6-4865-a87a-3b3b944c9637
9ba66518-828d-4db7-aaf4-e1301b2b959e	0eb13f5a-6e6b-4eae-b58d-c679b6d08703	02663d0e-87ab-4c1d-9292-1664b4377cc6
4e181555-b356-42d6-b403-09ddebfaba64	38627842-6a22-4667-9f01-4c99af03904b	d28a1e6f-8803-4e9d-ae3c-23123cf1931f
c86548b5-6927-4aa8-8149-19912c70b7e1	38627842-6a22-4667-9f01-4c99af03904b	c04e0158-0e80-4cc8-85c5-c7ff1a00225b
3b8e6366-18cf-43e5-81d6-d08cdf239e84	171c242e-3656-44e0-a314-b7b97ab6d437	d28a1e6f-8803-4e9d-ae3c-23123cf1931f
bddf65b3-26e9-4d70-ae51-c1b10ee03015	171c242e-3656-44e0-a314-b7b97ab6d437	c04e0158-0e80-4cc8-85c5-c7ff1a00225b
aa3f8c26-069a-4eed-9b39-378745825588	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	d28a1e6f-8803-4e9d-ae3c-23123cf1931f
6000e5f2-5bc8-46ce-9e2e-1604c7d8b8f6	a9cf5359-ea2e-4674-a0cd-62f1e465cde6	c04e0158-0e80-4cc8-85c5-c7ff1a00225b
\.


--
-- Data for Name: groups_; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups_ (id_group, code) FROM stdin;
f6ae2831-2e35-4b37-ba1c-8847dd39fc7f	IC1A
48ae7ecc-f23a-4563-a5b9-3227f64c91e6	IC2A
cd2e27d2-d5b7-4105-9ce5-a208f4bcb987	IC3A
76148283-8674-441c-baee-caaf2fc0c907	IC4A
3052cd63-1645-4507-8d07-a5e732fe938c	IS1A
6621cb6b-5fe0-432a-898d-17a8ba2e1949	IS1B
313e5020-dcca-4ced-a1ea-69d8d7a4e457	IS2A
e79c0ec1-0a2f-4683-a5cb-18f5ae44ef34	IS2B
8e97f695-d211-4957-9d1c-f70b305b9ae7	IS3A
97febc24-637a-49c2-bbfc-69aca8962e4f	IS3B
036786db-bc62-4259-9817-8ec56a4d0e20	IS4A
a7873ed8-2167-4272-9a56-bca383bf081b	IS4B
bcb634de-2dc5-4bde-b0cf-668ba50a2f4c	II1A
8deabb55-b9b9-4bab-8b54-296bffdfac1b	II2A
043aa3f6-3483-42b3-843a-b962626c947e	II3A
ca0ee015-bf73-407b-bee0-47fcc80d392a	AR1A
db29b776-57a6-48b7-8607-cb2749ecdd8b	AR2A
861e86b6-697b-4a19-b536-f9a9d9c4a64e	AR3A
e91e4a5d-3b43-4ca2-8d55-6ee2aaf2d075	AD1A
921c3b1e-a620-4fba-89b4-2d1a2345d939	AD2A
ed0dc05d-ce91-4279-9a55-91569e0d2cab	AD3A
ed7519d4-8086-46f6-ae16-ec69f746d394	DE1A
ea3a6f23-ed04-4dfa-8e14-76ad6629198c	DE2A
1564916d-89b4-4ab5-adb8-3d566e754b1f	DE3A
03f75a98-f6e2-4741-b4b8-702241a6172f	ME1A
187eed02-52c0-4241-92a8-860d6e93969f	ME2A
58923fc8-4afd-4018-a064-082f88a65f69	ME3A
d51dd354-a529-456b-9cbd-a95a5e80583e	DG1A
6ec8ce66-2e41-498e-84e8-b11f6f47acc2	DG2A
65c44953-6f13-42d1-bc44-c2aee4a0b337	DG3A
\.


--
-- Data for Name: justification_attachment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.justification_attachment (id_attachment, id_attendance, file_url, type, upload_date) FROM stdin;
370a8fd7-2a8a-4221-a052-fb64fe9b6df7	52fb3ecf-486b-4179-b662-4f53d4168779	/uploads/justificacion_370a8fd7.pdf	PDF	2026-06-06 22:00:27.731091
ec6b276c-0a8f-41d3-9a5f-6e81a8089ace	2cd15ffc-f087-4b4d-9b19-98fdc0cf58d2	/uploads/justificacion_ec6b276c.pdf	PDF	2026-06-06 22:00:27.731106
040aacda-4f43-4425-b75f-babaa3ab4846	bd4c8ddf-69f6-4592-896e-19d971297ae7	/uploads/justificacion_040aacda.pdf	PDF	2026-06-06 22:00:27.731108
6708470e-643e-4e6f-84ca-f1a60e15bd36	36397cbd-0a6c-4a63-afe3-e9488ad55da8	/uploads/justificacion_6708470e.pdf	PDF	2026-06-06 22:00:27.73111
8b8ce004-08a3-45da-a1c6-8439a0739b2b	5ff32c3a-b5cb-41c6-af4d-acd929635566	/uploads/justificacion_8b8ce004.jpg	IMAGE	2026-06-06 22:00:27.731112
b5045cb1-e83b-4c9b-961a-13b273ece377	a2494ac5-6c96-4e50-8a9f-f32029470ca7	/uploads/justificacion_b5045cb1.jpg	IMAGE	2026-06-06 22:00:27.731114
8738a33b-9b58-43fa-bc4b-3f212e2f231a	e9ab9337-5428-49bd-8cdf-e364d21bdf8b	/uploads/justificacion_8738a33b.jpg	IMAGE	2026-06-06 22:00:27.731116
7ad9f155-1f5f-4b75-a6c7-e1ad00be306a	70b5d689-cf42-4ed2-a4b4-40e1c5c0d28d	/uploads/justificacion_7ad9f155.pdf	PDF	2026-06-06 22:00:27.731118
9bde366e-8a9c-4d0f-aaee-ba44433573dc	291f560f-bda4-4ba7-a294-6ca233937325	/uploads/justificacion_9bde366e.jpg	IMAGE	2026-06-06 22:00:27.73112
82e3dbe6-d64a-489f-bd9b-2e0c07a7ccf5	ed52b5e0-ff87-4ffa-9858-deaf23ae514b	/uploads/justificacion_82e3dbe6.pdf	PDF	2026-06-06 22:00:27.731122
394de4a6-76c7-49a8-af24-ec96cac964fe	0119dd72-251d-4c72-b692-0542b955f801	/uploads/justificacion_394de4a6.jpg	IMAGE	2026-06-06 22:00:27.731124
c66fa30e-af89-4b3d-9eef-6b6c9174f31b	52e45915-c77c-4fc8-9c9c-5c8acd8c608d	/uploads/justificacion_c66fa30e.jpg	IMAGE	2026-06-06 22:00:27.731126
b35313c1-8dbc-4b2a-8c83-aabbcd097b39	f32b76e8-55ef-4035-b2d8-b16234b8e285	/uploads/justificacion_b35313c1.jpg	IMAGE	2026-06-06 22:00:27.731128
997c39b9-a111-42ba-b084-b3022aca7cbb	08a876af-fbce-41fb-b065-eff82bfd2977	/uploads/justificacion_997c39b9.jpg	IMAGE	2026-06-06 22:00:27.73113
359ae69d-d131-4d72-857a-f716c4617280	87eb8367-9763-42ad-a5a0-8c724121b007	/uploads/justificacion_359ae69d.jpg	IMAGE	2026-06-06 22:00:27.731132
df182d0a-30d4-4b60-94e4-48fe51ffcc22	e006dc40-0249-4886-9064-f8107044292e	/uploads/justificacion_df182d0a.jpg	IMAGE	2026-06-06 22:00:27.731134
ff2bbfb5-2273-4e1f-b2f0-a1f3e6a38992	3d5d2516-8353-4840-b154-2196ae69f9d5	/uploads/justificacion_ff2bbfb5.jpg	IMAGE	2026-06-06 22:00:27.731135
1d475d42-e082-4f77-b458-3ef49929047a	1bb1951b-de64-483c-9d61-9671043d3cb8	/uploads/justificacion_1d475d42.jpg	IMAGE	2026-06-06 22:00:27.731138
7686f0ed-7ebb-47fd-bb68-8eae30af0ce0	a1f6e320-8094-4068-98dc-9cf5fa0679eb	/uploads/justificacion_7686f0ed.jpg	IMAGE	2026-06-06 22:00:27.731139
e35d1931-df1c-43f5-945a-b213bd269d70	c4d54586-4ede-4d1c-9978-3131028504b5	/uploads/justificacion_e35d1931.pdf	PDF	2026-06-06 22:00:27.731141
14e1358c-f7e5-478c-b1be-94e7b3b92a3f	5d3b3664-a6b7-41a8-bd0f-a8e20d234711	/uploads/justificacion_14e1358c.jpg	IMAGE	2026-06-06 22:00:27.731143
55db0c25-9787-446d-a8e1-aefd107fc56f	a9fa546b-52ff-4ae9-a436-ae53ed05fe62	/uploads/justificacion_55db0c25.pdf	PDF	2026-06-06 22:00:27.731145
124e1e92-e145-4052-b551-1109fbec05ae	13429e54-b0e3-4669-b265-e6a7961ee970	/uploads/justificacion_124e1e92.jpg	IMAGE	2026-06-06 22:00:27.731147
9422cd0b-104d-4d8f-9550-57a7a7238405	027bfca7-6b41-4271-a3d9-e870a54196e0	/uploads/justificacion_9422cd0b.jpg	IMAGE	2026-06-06 22:00:27.731149
5282c848-b509-410c-8609-90155f49ca38	8d604d09-3c91-4f6f-91a3-fa2ad37d364b	/uploads/justificacion_5282c848.jpg	IMAGE	2026-06-06 22:00:27.731151
ef76bc11-8d91-4f56-92a3-0629faeffc5f	0ac2468f-95a1-45da-9e0c-26a781eac867	/uploads/justificacion_ef76bc11.pdf	PDF	2026-06-06 22:00:27.731153
15700627-3c9d-410a-9e33-0f534d155422	a137a839-4360-46a0-bd8a-937c27e3026f	/uploads/justificacion_15700627.jpg	IMAGE	2026-06-06 22:00:27.731155
9dd05dda-e628-4470-b527-ea4423f326b2	aa6d7c31-9476-41f6-9a6b-4716709db194	/uploads/justificacion_9dd05dda.jpg	IMAGE	2026-06-06 22:00:27.731157
ee19915a-389e-417f-89a2-887268d46403	9bb187e8-b794-413c-975d-1b67a3b62a16	/uploads/justificacion_ee19915a.pdf	PDF	2026-06-06 22:00:27.731159
d0e4b0c0-216c-4a80-bdcd-849ce04c9b7a	b61d125f-7766-43ef-8361-63a9c309ac24	/uploads/justificacion_d0e4b0c0.jpg	IMAGE	2026-06-06 22:00:27.731161
55f1d86c-6aa1-4ae1-a55f-debce3875c38	2c252521-386c-4374-8d48-448ed4b8deea	/uploads/justificacion_55f1d86c.jpg	IMAGE	2026-06-06 22:00:27.731163
2d408bc7-4e1e-4006-ad44-e9f11315b524	10d46cc8-cacd-48a9-972a-cc90bfc67605	/uploads/justificacion_2d408bc7.pdf	PDF	2026-06-06 22:00:27.731165
3a6a123d-6796-4092-b761-29191d9d02fc	77e1f187-0a5e-49c9-a427-b6f11eb0a345	/uploads/justificacion_3a6a123d.pdf	PDF	2026-06-06 22:00:27.731167
65910fdc-042b-46c1-bd36-b1e48a50bfbc	8f0ef1b0-e0ca-4665-a7b4-e25314427117	/uploads/justificacion_65910fdc.jpg	IMAGE	2026-06-06 22:00:27.731168
5cdd18d0-a310-44cb-b984-e1284869ca0d	e2ebeb59-f912-49cf-88df-18b6c4abcc5b	/uploads/justificacion_5cdd18d0.jpg	IMAGE	2026-06-06 22:00:27.73117
de6f7fad-e6c7-44b4-a024-491e8eb45836	4d79b7b3-190d-4f46-9e1b-e0791106ef91	/uploads/justificacion_de6f7fad.jpg	IMAGE	2026-06-06 22:00:27.731172
dbc39923-5689-4033-8cb2-00c5a1ee04ea	1f2a5aef-981d-443a-8ebe-138f704970f6	/uploads/justificacion_dbc39923.pdf	PDF	2026-06-06 22:00:27.731174
363b26fe-f9a5-4728-bdbb-2b77c420bcea	e3038c60-d838-48c1-96c3-0d38fccfa9bd	/uploads/justificacion_363b26fe.pdf	PDF	2026-06-06 22:00:27.731176
dd9d6698-4174-47e3-b554-41b491b38aaa	81296835-7301-4c6a-aecb-95715d551d84	/uploads/justificacion_dd9d6698.jpg	IMAGE	2026-06-06 22:00:27.731178
3699a16d-49b1-43c6-b6e4-3fcb08ab0ddb	671a08d6-67d5-41b6-8a10-a97a3c2f5d91	/uploads/justificacion_3699a16d.jpg	IMAGE	2026-06-06 22:00:27.73118
5e2cf228-c863-411e-aa82-ce51abd8635a	64b4d6d1-6ae6-4b2e-8975-1dd5ca559d27	/uploads/justificacion_5e2cf228.jpg	IMAGE	2026-06-06 22:00:27.731182
b824852c-886d-4e7b-84fc-1422cbac0eaa	532a18f5-1a49-47ba-8794-323eebf43699	/uploads/justificacion_b824852c.pdf	PDF	2026-06-06 22:00:27.731184
e611bed6-14d4-46b6-9765-51fd79c76fac	51241dac-7eca-411d-bad6-9b86b839d8bc	/uploads/justificacion_e611bed6.jpg	IMAGE	2026-06-06 22:00:27.731186
9f9f6d76-fba9-4bed-a31c-e5a24eb62d73	44ce0c9b-0a38-4990-8937-16075db83fe9	/uploads/justificacion_9f9f6d76.jpg	IMAGE	2026-06-06 22:00:27.731188
dbab6c90-c999-463f-b142-d30da34cf943	1080fbb0-647b-49c5-8f11-41f02cd8c8cb	/uploads/justificacion_dbab6c90.jpg	IMAGE	2026-06-06 22:00:27.73119
377a180e-5ced-4a75-901c-edeabde523a5	8219fe2f-af15-4c22-8bc8-0e144bebc9c4	/uploads/justificacion_377a180e.jpg	IMAGE	2026-06-06 22:00:27.731192
6dc7f816-9850-4d84-89cb-dbd44e591257	b44ea0d8-efb4-4a60-86ae-cd3e25694eb1	/uploads/justificacion_6dc7f816.jpg	IMAGE	2026-06-06 22:00:27.731194
9705d4c1-64e3-4d8d-9cbb-0bff0ce85b6d	59ea9e85-61d5-4947-a343-ecbe01ede676	/uploads/justificacion_9705d4c1.jpg	IMAGE	2026-06-06 22:00:27.731196
1ae11a93-f3fb-481f-bfcd-987f73f595d6	ceec5326-eb05-4016-a2f3-73553872ddae	/uploads/justificacion_1ae11a93.pdf	PDF	2026-06-06 22:00:27.731198
df136122-9a20-4b1e-b3c6-40e2aa99d20d	22461960-a973-4985-b64f-8b305f849456	/uploads/justificacion_df136122.pdf	PDF	2026-06-06 22:00:27.731199
538d5c54-1c32-4807-9744-2b79650a98be	ed549930-efaa-4338-9a7a-eeb79a8f9a28	/uploads/justificacion_538d5c54.pdf	PDF	2026-06-06 22:00:27.731201
3e75dd19-e604-4b46-b879-e2a9c9a96b4c	a801611c-17fc-43bd-a110-529b61d208ac	/uploads/justificacion_3e75dd19.jpg	IMAGE	2026-06-06 22:00:27.731203
da5d2f36-2a9b-47a8-9f92-86045f1f09f6	ba131f6f-cfc2-41ee-9210-650233709862	/uploads/justificacion_da5d2f36.jpg	IMAGE	2026-06-06 22:00:27.731205
1ef101b1-6e2b-4c6d-801f-19c3a05d73d3	d0c2ba24-5656-41f9-b2ee-a740da6c7719	/uploads/justificacion_1ef101b1.pdf	PDF	2026-06-06 22:00:27.731207
bc67836b-8401-4635-b59e-954f1b2ee497	c19cce20-6207-4bb1-ac52-8fd50bbbf10c	/uploads/justificacion_bc67836b.pdf	PDF	2026-06-06 22:00:27.731209
30d7fce0-53ff-41a7-b44a-69f3a8a3fd50	3070f898-b62e-4bab-b938-329e0a50d62d	/uploads/justificacion_30d7fce0.pdf	PDF	2026-06-06 22:00:27.731211
fdc41f6c-7990-4f8d-9ece-6a0868b6a872	a48ce8c6-1a4b-420f-a7ab-61b5cddc218e	/uploads/justificacion_fdc41f6c.pdf	PDF	2026-06-06 22:00:27.731213
5768f1f0-215b-421f-81d7-d2df4c2c316a	1d4e3b9b-c490-4b8c-bd97-cf16ca4bb8ef	/uploads/justificacion_5768f1f0.pdf	PDF	2026-06-06 22:00:27.731215
a0b87b30-2a7d-4334-a39e-386148fe1375	fff688d2-4da7-41d3-a9dc-537e8cf7546d	/uploads/justificacion_a0b87b30.jpg	IMAGE	2026-06-06 22:00:27.731217
59c93a2d-18ce-4a89-8e8d-6b7f3ac42660	98a5db10-885f-41aa-881e-dc1549aee68e	/uploads/justificacion_59c93a2d.jpg	IMAGE	2026-06-06 22:00:27.731219
7a9a71cb-8fa7-4492-95ce-986024974808	694e5e05-7140-4a5a-bcb7-30253dc16dc5	/uploads/justificacion_7a9a71cb.jpg	IMAGE	2026-06-06 22:00:27.731221
73cd05e4-7d29-4c4a-bcce-d5dc7bb45b62	a344ed64-b574-486d-abbe-bc288f2d97fa	/uploads/justificacion_73cd05e4.jpg	IMAGE	2026-06-06 22:00:27.731223
69b22890-ff4c-494f-a25b-835f47663cbe	d4977b53-f4ec-4313-8f6d-323591daf4cf	/uploads/justificacion_69b22890.pdf	PDF	2026-06-06 22:00:27.731225
b516fd66-99e8-4b54-8f0d-5629aef48ab6	c65637b8-bb02-4190-aa8c-61fc8109dea1	/uploads/justificacion_b516fd66.pdf	PDF	2026-06-06 22:00:27.731226
d6b7262d-a9dd-4992-82bc-375d0152db84	0b70d887-18ed-4e5e-ae20-c877ac5fc7e5	/uploads/justificacion_d6b7262d.jpg	IMAGE	2026-06-06 22:00:27.731228
b3fb6552-2303-40d3-915a-3b6eb0d50540	d3f6a939-bcf1-4957-86c1-b2d2ad645a9d	/uploads/justificacion_b3fb6552.jpg	IMAGE	2026-06-06 22:00:27.73123
cb342a2a-d848-4861-a182-35d3836a0b85	c26f4660-fe1e-4345-98ca-d4cf963f5370	/uploads/justificacion_cb342a2a.pdf	PDF	2026-06-06 22:00:27.731232
a1cbf9ca-3d5e-46f5-91cc-2f99e70c968d	c84b9ed3-d538-4dcb-8b53-4846606d0ad2	/uploads/justificacion_a1cbf9ca.jpg	IMAGE	2026-06-06 22:00:27.731234
cdb2c495-3b24-4c43-9a78-0e15bfa2b015	980ebe9a-6c2d-434b-b522-7b644e40a2eb	/uploads/justificacion_cdb2c495.pdf	PDF	2026-06-06 22:00:27.731236
543875f3-b570-4693-8deb-f379afd44bed	72d97848-c322-48d4-9640-abf7217aad05	/uploads/justificacion_543875f3.pdf	PDF	2026-06-06 22:00:27.731238
3a9ac9bb-51f9-4b57-9891-a6ac1613e352	3b191e54-2beb-4b60-adb6-c5254c2ee50b	/uploads/justificacion_3a9ac9bb.pdf	PDF	2026-06-06 22:00:27.73124
5747d5eb-3c16-4b16-a20d-239621062bda	897e9ec5-b68a-422f-8b83-c5424a9964ff	/uploads/justificacion_5747d5eb.jpg	IMAGE	2026-06-06 22:00:27.731242
09879b30-b091-40cc-8476-7da899e2f38d	68327f03-e61e-4f6b-b5ff-3137ee790063	/uploads/justificacion_09879b30.pdf	PDF	2026-06-06 22:00:27.731244
043859e7-ac09-430e-a651-b477ba17eb97	80801d42-d115-47e9-b78f-b0abcb28bea3	/uploads/justificacion_043859e7.pdf	PDF	2026-06-06 22:00:27.731246
f3925865-50a4-4f29-9da3-26b83e8b2cf0	ae63a3ad-4e76-47b8-98da-35fe321c6ce8	/uploads/justificacion_f3925865.jpg	IMAGE	2026-06-06 22:00:27.731248
b958bf21-a49d-4ee2-8f0d-9190aab4d4b0	24babec0-8c4b-4086-99a8-c1be079d0009	/uploads/justificacion_b958bf21.jpg	IMAGE	2026-06-06 22:00:27.731249
89038aea-8c5d-41d0-ac38-946deecadfc8	56fdbf0b-ab80-48cf-bf9b-cc6d6f19bab3	/uploads/justificacion_89038aea.pdf	PDF	2026-06-06 22:00:27.731251
1d3eef71-fb19-4f80-a124-d46d74a43079	f9cec2f7-3634-47c4-8daa-88868d5c53c8	/uploads/justificacion_1d3eef71.jpg	IMAGE	2026-06-06 22:00:27.731253
522820ea-fd3f-43e5-895d-1071ad7aa443	136dd2df-b638-418c-a94c-06571dca8f9a	/uploads/justificacion_522820ea.pdf	PDF	2026-06-06 22:00:27.731255
2007ee15-8846-47b6-84e0-9113c88f3d72	2b689939-925a-46c5-a2f1-72eb669d1f05	/uploads/justificacion_2007ee15.jpg	IMAGE	2026-06-06 22:00:27.731257
89230fbc-789c-4fe3-84f0-37e55e8bdb06	e8753d60-e8e2-4cdb-a967-0335fbc00d9a	/uploads/justificacion_89230fbc.pdf	PDF	2026-06-06 22:00:27.731259
f86ad8f8-323d-48e1-bd89-46c789823741	7dbc22ea-32ca-4a3b-9de4-20a185b24072	/uploads/justificacion_f86ad8f8.jpg	IMAGE	2026-06-06 22:00:27.731261
128ede3a-859f-4c0c-b3b5-1f97a60bcff4	b183a669-16f2-415a-bed7-8dfa15940904	/uploads/justificacion_128ede3a.jpg	IMAGE	2026-06-06 22:00:27.731263
f5e31f18-bafe-48b8-840c-305a80940f29	679dc5a0-4ef6-4712-a51e-09dc24f40281	/uploads/justificacion_f5e31f18.pdf	PDF	2026-06-06 22:00:27.731265
42eecce6-2d09-4987-8aed-956584d0f07f	7e28e09b-7150-4ed9-9b03-c80316b45ac7	/uploads/justificacion_42eecce6.pdf	PDF	2026-06-06 22:00:27.731267
e4a8a1b6-a490-4c63-b3ee-85516156690c	bcefc012-53b8-4a25-b997-00d894de7be2	/uploads/justificacion_e4a8a1b6.jpg	IMAGE	2026-06-06 22:00:27.731269
83526420-a4bf-48e9-8c41-40fccad503a4	8fae07f3-84e1-4083-9b6a-ea8221092c8e	/uploads/justificacion_83526420.pdf	PDF	2026-06-06 22:00:27.731271
d2adecaa-c993-4c3f-b985-34373464c7a9	8c17dd00-e45a-46af-b130-e9f12f74e5e6	/uploads/justificacion_d2adecaa.pdf	PDF	2026-06-06 22:00:27.731273
40191540-1f05-40ee-a8f9-2265f5ed1273	3a315f35-c743-46e5-9167-dcf0b2761859	/uploads/justificacion_40191540.jpg	IMAGE	2026-06-06 22:00:27.731275
18a21d76-6564-41a3-a9f7-d9383a3f329a	4335cbed-47b5-4632-afde-916fe1b06901	/uploads/justificacion_18a21d76.pdf	PDF	2026-06-06 22:00:27.731277
ed306941-f4d8-40c0-b13f-a77b426f39ec	d6d5c141-f93b-4b80-b719-50b919dacb47	/uploads/justificacion_ed306941.jpg	IMAGE	2026-06-06 22:00:27.731279
230fb2a1-16f8-4622-9942-080c4166b8d8	d0d763da-096f-4e24-9a33-5c3f98984b36	/uploads/justificacion_230fb2a1.jpg	IMAGE	2026-06-06 22:00:27.731281
5b1cced8-871f-4895-a8da-9df0e5d6b73a	846bb217-e9a1-4aae-8f88-bdb1765ed078	/uploads/justificacion_5b1cced8.jpg	IMAGE	2026-06-06 22:00:27.731284
27c5ba15-257b-43f3-8f37-550e3973d713	86f27bc8-0e1e-4701-aff1-3a260f190361	/uploads/justificacion_27c5ba15.jpg	IMAGE	2026-06-06 22:00:27.731286
b0043e0c-c7e1-4863-8a03-c6b6568d46e1	2bb4a337-b5a1-44e8-94f6-4701f3bcc1dc	/uploads/justificacion_b0043e0c.jpg	IMAGE	2026-06-06 22:00:27.731288
549e182a-9e97-418e-9e07-083361a312a8	d3249a91-500d-4913-ad86-0e5a437679f9	/uploads/justificacion_549e182a.pdf	PDF	2026-06-06 22:00:27.73129
b14186cd-9195-4201-a234-e7cec9387c43	a0901362-2bda-413a-9df0-d7d1ce11acec	/uploads/justificacion_b14186cd.jpg	IMAGE	2026-06-06 22:00:27.731292
3b64203e-7a4c-48a0-8537-16a927e50d04	8782e8e6-46a8-494c-9dd7-b8fe6917f8e3	/uploads/justificacion_3b64203e.pdf	PDF	2026-06-06 22:00:27.731294
497086db-1e5c-4ca8-b681-bac5ce5db3b1	e5bfa665-a2f2-429a-ad87-ce94cf74dfa3	/uploads/justificacion_497086db.pdf	PDF	2026-06-06 22:00:27.731296
fc9e8447-c246-4aa9-9edc-2743b3de51b5	75a04d69-339d-48ea-80a6-76adbbb474a2	/uploads/justificacion_fc9e8447.pdf	PDF	2026-06-06 22:00:27.731298
d12925f7-dbb7-489f-add1-3790750812f6	257b3243-e02d-4958-8fd7-0a2a656441a5	/uploads/justificacion_d12925f7.pdf	PDF	2026-06-06 22:00:27.7313
b2b0c2f8-66e4-4014-a64c-b72395732e22	5229dc75-eec4-484b-860c-97e11d6906f1	/uploads/justificacion_b2b0c2f8.pdf	PDF	2026-06-06 22:00:27.731302
b1ec84e4-4b82-4f8d-bcb4-f5008f571188	7be4f9e2-ff6e-472b-9faa-754c3feb7775	/uploads/justificacion_b1ec84e4.jpg	IMAGE	2026-06-06 22:00:27.731304
f9ce87d6-77b1-4d4a-8c16-97fb188c3383	0c8562e1-7472-489b-b47f-fdcb6af87595	/uploads/justificacion_f9ce87d6.jpg	IMAGE	2026-06-06 22:00:27.731306
933f0350-4f0f-45e5-931d-eceed1a1df92	8bf550ad-63b1-4143-a3eb-75ddc6542255	/uploads/justificacion_933f0350.jpg	IMAGE	2026-06-06 22:00:27.731308
e61fd7e2-a982-4b9b-b07c-0f696af21366	dbe2f1db-dc0c-497b-ad4b-a206a88ef439	/uploads/justificacion_e61fd7e2.pdf	PDF	2026-06-06 22:00:27.73131
886876b3-e3be-4a98-ac0e-9ac1a5eca1cb	33de9a18-0148-45e0-9323-52b48fa90809	/uploads/justificacion_886876b3.pdf	PDF	2026-06-06 22:00:27.731312
1e72a4c8-0e66-4942-baa3-211dc8280324	73385f53-49fe-4aaf-8336-344c7963b7ec	/uploads/justificacion_1e72a4c8.jpg	IMAGE	2026-06-06 22:00:27.731314
da9cfc0e-a490-498e-8941-17e0fd03a9b2	fe08430b-00f9-4938-8bc9-22eb50ea1f54	/uploads/justificacion_da9cfc0e.pdf	PDF	2026-06-06 22:00:27.731316
f5d65bba-7161-413a-8afa-1bd0e83812ad	70c80a0e-ff2f-4e1d-b692-a5e7b105aa3b	/uploads/justificacion_f5d65bba.pdf	PDF	2026-06-06 22:00:27.731318
fc83586e-917c-491b-a119-07dc53539b74	4d4d213e-de67-462a-8a8b-3942c3f2a67e	/uploads/justificacion_fc83586e.jpg	IMAGE	2026-06-06 22:00:27.73132
\.


--
-- Data for Name: knowledge_area; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.knowledge_area (id_area, name) FROM stdin;
bb6a04c5-c7d2-46d0-bf2e-531351b176cb	Ciencias Básicas
c5546739-c8fc-4875-b4f5-58b4532abf0b	Ingeniería y Tecnología
9e74aca1-918a-415d-ae9f-e7b8831eb6dd	Ciencias Sociales
46142990-bbc2-4fb5-af12-c32bb1882f05	Humanidades
87df83f0-c031-4243-8c20-d5715006ba8c	Arte y Diseño
\.


--
-- Data for Name: periods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.periods (id_period, year, cycle, start_date, end_date) FROM stdin;
b0b3c3a9-48d1-4068-bb75-3eb70c5cb31c	2026	1	2026-03-01	2026-06-30
d6b6e56a-819e-4b01-8e36-9a4435229200	2026	2	2026-08-01	2026-11-30
\.


--
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.schedule (id_schedule, id_class, weekday, start_time, end_time, shift, id_classroom, end_next_day) FROM stdin;
052fe279-ba72-4d11-adb7-10b7ce86db4a	069e299d-9ef1-4d67-af85-1729d39efc78	MON	07:00:00	08:30:00	MORNING	cb2f6f0f-a443-4396-a752-b6757f21faf2	f
24aee75f-5851-4c94-97f2-bc176ba94de5	bf1896c9-e9c9-4afd-9328-372fbed03964	TUE	08:45:00	10:15:00	MORNING	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	f
0d4d3a51-3c00-41eb-8e04-fcba06296d87	9fa006fa-0f74-49d0-b405-9a96d9d27785	WED	10:30:00	12:00:00	MORNING	5993162f-2faa-436d-868c-2e6fd41afaab	f
fd73d70a-4687-4560-9c4e-197bacdbbf9c	e0220c71-4670-4133-ade0-693941a03ea4	MON	08:45:00	10:15:00	MORNING	b12fd2eb-e16b-4931-bdbd-1c3918053bc0	f
fc8f78cd-d832-463e-bebc-3ca42cbea3c6	ad1ec0fb-7398-4f7a-9653-769565330b46	TUE	10:30:00	12:00:00	MORNING	ca1b243e-fe66-451d-8988-c27303c75ba2	f
af7d1647-8bf5-4151-a4b5-e222f0b1914c	4f6b60dc-a542-4a5c-b946-69af663c401b	WED	13:00:00	14:30:00	AFTERNOON	293d282f-1389-4756-8a76-9b1879315439	f
f4c326b0-d178-4f55-9161-2ee1d09f0082	95987e5a-5a06-425d-9b3f-62d2efbc260a	MON	10:30:00	12:00:00	MORNING	293d282f-1389-4756-8a76-9b1879315439	f
5d2b2582-0067-4a69-91a5-d817c1093cf4	376b8ace-74c2-4f1a-88e4-04bd8683dcbe	TUE	13:00:00	14:30:00	AFTERNOON	ee96f90e-3e42-4141-88fa-d7be7e2fb8e7	f
e92579af-9c62-41ae-be60-66ad784c2889	2b8b1a41-01ed-4cbc-8138-a9ace9957528	WED	14:45:00	16:15:00	AFTERNOON	b12fd2eb-e16b-4931-bdbd-1c3918053bc0	f
46d3bc5f-f4d7-4f07-9dbb-c72dd4603424	88321b86-dcd6-4fa5-b01b-83891a6b945c	MON	13:00:00	14:30:00	AFTERNOON	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	f
81f984f3-e16d-4e07-a087-76f8b8b1dceb	74fdbdb4-ef0a-45d6-b4c1-be03605ad829	TUE	14:45:00	16:15:00	AFTERNOON	2c657dfa-4ad0-4568-94c3-0dae0f4040f2	f
65111e2b-0902-4f20-8384-a7119044c409	d721eedb-2e39-431e-b3d0-122e135aa628	WED	16:30:00	18:00:00	AFTERNOON	b12fd2eb-e16b-4931-bdbd-1c3918053bc0	f
525f05b1-2efa-417b-a493-3eea3ac988da	516d8f80-ae71-4a61-81e3-157cf6ae6be7	MON	14:45:00	16:15:00	AFTERNOON	433c7ba8-22bd-48e5-8a98-672a8fea6b22	f
60f5d5e8-3e68-4f1b-9dd0-fb7a23ec9eb1	679e9757-8d90-44b6-97f6-f11ef00f3a6c	TUE	16:30:00	18:00:00	AFTERNOON	05201eb0-de88-43a5-9dae-19c6b8f35667	f
848c4bf0-c4b8-425c-a2bb-e9766acb41e5	9d9afeac-3020-421a-bae9-a9ebd4980fcb	MON	16:30:00	18:00:00	AFTERNOON	9debd9f0-2efe-4d63-8866-1b4aafb19fa6	f
dfd22e36-e738-41f7-9346-7a3c5a49048d	86e1ae58-a186-47a3-a212-5eff6526b974	THU	07:00:00	08:30:00	MORNING	e0694bed-44e4-40a5-9ea9-5946fd45cf1f	f
db919529-c392-4d9c-b7f3-6fdc1f0e0099	edc7dad4-08b6-4865-a87a-3b3b944c9637	THU	08:45:00	10:15:00	MORNING	37723e46-c4c8-41bc-9438-87b5102c0e17	f
e0297b0c-3d2b-4ccb-b443-aeac5ec05e7d	02663d0e-87ab-4c1d-9292-1664b4377cc6	THU	10:30:00	12:00:00	MORNING	2ad28dde-182f-4114-887c-6b2c95875b5d	f
f30aaa3e-aaa9-4214-874e-5cb5682bce6e	d28a1e6f-8803-4e9d-ae3c-23123cf1931f	THU	13:00:00	14:30:00	AFTERNOON	5993162f-2faa-436d-868c-2e6fd41afaab	f
be28f611-1955-4a43-a9af-bc480df579f1	c04e0158-0e80-4cc8-85c5-c7ff1a00225b	THU	14:45:00	16:15:00	AFTERNOON	9debd9f0-2efe-4d63-8866-1b4aafb19fa6	f
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sessions (id_session, id_class, date, actual_start_time, actual_end_time, status, id_classroom, qr_token, qr_expires, opens_at, closes_at, extended_mode, extension_reason, close_notification_minutes) FROM stdin;
210b42c2-20ca-482f-b89c-62a3800ada36	069e299d-9ef1-4d67-af85-1729d39efc78	2026-03-23	07:08:00	08:24:00	CANCELED	b5c2f738-ca9f-4e49-bea1-a02969dbf3e6	9ed60e80-e391-45bb-8a67-671ff7fd95d1	2026-03-23 07:58:00	2026-03-23 06:58:00	2026-03-23 08:24:00	f	\N	\N
b38c805e-448b-4db8-b944-17a89a8a191c	069e299d-9ef1-4d67-af85-1729d39efc78	2026-05-25	07:03:00	08:23:00	FINISHED	b5c2f738-ca9f-4e49-bea1-a02969dbf3e6	b13d8bfa-c0b5-44d1-b069-26ca15ed30c6	2026-05-25 07:53:00	2026-05-25 06:53:00	2026-05-25 08:23:00	f	\N	\N
a74d0e3e-29c4-4785-9611-a489867d4bc8	069e299d-9ef1-4d67-af85-1729d39efc78	2026-04-27	07:09:00	08:26:00	FINISHED	b5c2f738-ca9f-4e49-bea1-a02969dbf3e6	e62402c5-b678-488f-8502-95d1311ab0ca	2026-04-27 07:59:00	2026-04-27 06:59:00	2026-04-27 08:26:00	f	\N	\N
591f1ae1-2ecf-4643-a042-99d54d6cc0d2	069e299d-9ef1-4d67-af85-1729d39efc78	2026-05-04	07:00:00	08:28:00	FINISHED	b5c2f738-ca9f-4e49-bea1-a02969dbf3e6	243bd9bf-13f0-4dc6-853b-b8985d44b40e	2026-05-04 07:50:00	2026-05-04 06:50:00	2026-05-04 08:28:00	f	\N	\N
9cc1c919-7c87-4742-a416-419d1360908b	069e299d-9ef1-4d67-af85-1729d39efc78	2026-03-02	07:06:00	08:25:00	FINISHED	b5c2f738-ca9f-4e49-bea1-a02969dbf3e6	e56a8bb1-ea0c-4a61-a701-798a43b43778	2026-03-02 07:56:00	2026-03-02 06:56:00	2026-03-02 08:25:00	f	\N	\N
57045a5d-9b4c-4a11-a060-cc6f2e5f1ec2	069e299d-9ef1-4d67-af85-1729d39efc78	2026-05-18	07:04:00	08:28:00	FINISHED	b5c2f738-ca9f-4e49-bea1-a02969dbf3e6	6622f75b-de2b-4f61-a0a9-ba8ebd0d7840	2026-05-18 07:54:00	2026-05-18 06:54:00	2026-05-18 08:28:00	f	\N	\N
7bb56821-b9b7-4211-8e89-f4144efb90fe	069e299d-9ef1-4d67-af85-1729d39efc78	2026-04-06	07:03:00	08:25:00	FINISHED	b5c2f738-ca9f-4e49-bea1-a02969dbf3e6	d22022ac-48ba-4e59-afad-8c4d4b46a717	2026-04-06 07:53:00	2026-04-06 06:53:00	2026-04-06 08:25:00	f	\N	\N
7128bea3-1c8c-46ec-8717-ece83a0ad306	069e299d-9ef1-4d67-af85-1729d39efc78	2026-04-13	07:01:00	08:29:00	FINISHED	b5c2f738-ca9f-4e49-bea1-a02969dbf3e6	d467f646-78e5-4864-831b-7e5a20d68d02	2026-04-13 07:51:00	2026-04-13 06:51:00	2026-04-13 08:29:00	f	\N	\N
d853d766-b1e0-4f7c-b236-11f7b1706f0f	bf1896c9-e9c9-4afd-9328-372fbed03964	2026-04-14	08:46:00	10:09:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	a10c7b87-ed10-4344-8914-5febbff436cc	2026-04-14 09:36:00	2026-04-14 08:36:00	2026-04-14 10:09:00	f	\N	\N
f7f7e72a-c360-4a1f-b760-74685eb2d04f	bf1896c9-e9c9-4afd-9328-372fbed03964	2026-03-10	08:46:00	10:07:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	644bad01-d449-424b-875a-295bce3be6d8	2026-03-10 09:36:00	2026-03-10 08:36:00	2026-03-10 10:07:00	f	\N	\N
243d4d6f-dd83-4b33-814e-1a2c079a3e37	bf1896c9-e9c9-4afd-9328-372fbed03964	2026-04-07	08:49:00	10:05:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	050edc90-a118-41a5-a2e2-44c038b557ab	2026-04-07 09:39:00	2026-04-07 08:39:00	2026-04-07 10:05:00	f	\N	\N
3fb2a16c-41d1-4473-9c4e-b77e7ff52858	bf1896c9-e9c9-4afd-9328-372fbed03964	2026-05-12	08:54:00	10:10:00	CANCELED	05201eb0-de88-43a5-9dae-19c6b8f35667	29e7890e-f655-490b-b0b4-d07be65eaa5d	2026-05-12 09:44:00	2026-05-12 08:44:00	2026-05-12 10:10:00	f	\N	\N
ab813360-d2af-4913-b6bc-c9f19c2200dc	bf1896c9-e9c9-4afd-9328-372fbed03964	2026-03-31	08:54:00	10:12:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	3489ad2e-fbea-4efe-b334-daf1d72bec63	2026-03-31 09:44:00	2026-03-31 08:44:00	2026-03-31 10:12:00	f	\N	\N
d18a1d48-ced7-4b27-89be-5d8ff5ed602e	bf1896c9-e9c9-4afd-9328-372fbed03964	2026-03-03	08:46:00	10:15:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	26401932-625c-4d07-a89c-8325ef56d4cc	2026-03-03 09:36:00	2026-03-03 08:36:00	2026-03-03 10:15:00	f	\N	\N
319e1f66-cd45-455e-aaf9-a18ce70cfa5a	bf1896c9-e9c9-4afd-9328-372fbed03964	2026-05-05	08:55:00	10:12:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	0b45ce1f-8d5c-4d73-9ac0-8d2b55728973	2026-05-05 09:45:00	2026-05-05 08:45:00	2026-05-05 10:12:00	f	\N	\N
482af3f7-9985-49dd-9721-ce26cf567793	bf1896c9-e9c9-4afd-9328-372fbed03964	2026-03-24	08:49:00	10:14:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	e70293c9-4c31-420c-abb4-bcbdf61c71b9	2026-03-24 09:39:00	2026-03-24 08:39:00	2026-03-24 10:14:00	f	\N	\N
3eda2558-c0bb-4ba0-b8f3-24e13e90dc6d	9fa006fa-0f74-49d0-b405-9a96d9d27785	2026-03-25	10:35:00	12:00:00	FINISHED	a33e34d3-9989-40bd-8577-6229770a9150	bb3f2793-554d-40bc-9ad1-0057736ded10	2026-03-25 11:25:00	2026-03-25 10:25:00	2026-03-25 12:00:00	f	\N	\N
0d3ba0da-3af6-489b-b3fd-c9a7df9deec9	9fa006fa-0f74-49d0-b405-9a96d9d27785	2026-03-11	10:40:00	12:00:00	FINISHED	a33e34d3-9989-40bd-8577-6229770a9150	9248f697-225d-47e5-836b-cf3982dc9c72	2026-03-11 11:30:00	2026-03-11 10:30:00	2026-03-11 12:00:00	f	\N	\N
4ba08f61-4553-4da5-8fe4-4446b0ac48ab	9fa006fa-0f74-49d0-b405-9a96d9d27785	2026-04-15	10:40:00	12:00:00	FINISHED	a33e34d3-9989-40bd-8577-6229770a9150	2cbf82c6-1691-40e8-aff6-a42e63b33be4	2026-04-15 11:30:00	2026-04-15 10:30:00	2026-04-15 12:00:00	f	\N	\N
995611ab-18f4-4c98-b6a3-a91ec0cd3e6e	9fa006fa-0f74-49d0-b405-9a96d9d27785	2026-04-01	10:31:00	12:00:00	FINISHED	a33e34d3-9989-40bd-8577-6229770a9150	099e6d3a-e33f-4bc9-a77c-d7bdbda303c2	2026-04-01 11:21:00	2026-04-01 10:21:00	2026-04-01 12:00:00	f	\N	\N
6748b0a2-c503-49c0-9559-dc137b2ae243	9fa006fa-0f74-49d0-b405-9a96d9d27785	2026-04-22	10:40:00	12:00:00	FINISHED	a33e34d3-9989-40bd-8577-6229770a9150	26171bcd-d5eb-4be1-aa0c-e88072e2725b	2026-04-22 11:30:00	2026-04-22 10:30:00	2026-04-22 12:00:00	f	\N	\N
b4aefea6-9810-4427-9323-e9f82b76b59a	9fa006fa-0f74-49d0-b405-9a96d9d27785	2026-04-08	10:38:00	12:00:00	FINISHED	a33e34d3-9989-40bd-8577-6229770a9150	2325e487-6474-4495-aa64-3ae2ef934e05	2026-04-08 11:28:00	2026-04-08 10:28:00	2026-04-08 12:00:00	f	\N	\N
7fafc2b2-c93e-4b41-ad53-336c19f321a3	9fa006fa-0f74-49d0-b405-9a96d9d27785	2026-05-20	10:32:00	12:00:00	CANCELED	a33e34d3-9989-40bd-8577-6229770a9150	3f53f6c4-aff0-45fe-b294-7f95fc535b47	2026-05-20 11:22:00	2026-05-20 10:22:00	2026-05-20 12:00:00	f	\N	\N
f7a2166b-b0da-4a97-97f2-170876ba8d23	e0220c71-4670-4133-ade0-693941a03ea4	2026-04-13	08:45:00	10:10:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	ebe0d53f-bf87-48b2-b39f-146229a0707c	2026-04-13 09:35:00	2026-04-13 08:35:00	2026-04-13 10:10:00	f	\N	\N
075fab53-ba08-49f5-84e3-7f8abc83e0d1	e0220c71-4670-4133-ade0-693941a03ea4	2026-03-30	08:51:00	10:11:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	cbfc10e7-1c10-4a80-8c8f-e968c0789ab0	2026-03-30 09:41:00	2026-03-30 08:41:00	2026-03-30 10:11:00	t	Clase práctica adicional	\N
ac422110-f6f0-4d18-a782-c8d922794d64	e0220c71-4670-4133-ade0-693941a03ea4	2026-05-11	08:48:00	10:06:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	77df2af6-78ad-4d0a-affa-17fa5f8669a6	2026-05-11 09:38:00	2026-05-11 08:38:00	2026-05-11 10:06:00	f	\N	\N
0cb129ed-9218-43d2-899c-3ac00328dd3c	e0220c71-4670-4133-ade0-693941a03ea4	2026-04-27	08:50:00	10:12:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	21a9bbe0-c8a5-4425-b55e-8d9af31c27a7	2026-04-27 09:40:00	2026-04-27 08:40:00	2026-04-27 10:12:00	f	\N	\N
284aa7b6-c623-4888-bf87-40877c551106	e0220c71-4670-4133-ade0-693941a03ea4	2026-03-23	08:55:00	10:08:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	6948978f-09b5-42ad-abc8-d88d788ae418	2026-03-23 09:45:00	2026-03-23 08:45:00	2026-03-23 10:08:00	t	Repaso de contenido	\N
55f40303-7aff-4869-b852-37b13c820d09	e0220c71-4670-4133-ade0-693941a03ea4	2026-04-06	08:55:00	10:08:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	69b7b391-d659-4015-a626-4edcc0c64e06	2026-04-06 09:45:00	2026-04-06 08:45:00	2026-04-06 10:08:00	f	\N	\N
092e340b-d3e0-466d-8ba4-5fa35279888a	e0220c71-4670-4133-ade0-693941a03ea4	2026-05-25	08:47:00	10:11:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	cefd8279-c3b9-4423-9d30-c14f0066a24d	2026-05-25 09:37:00	2026-05-25 08:37:00	2026-05-25 10:11:00	f	\N	\N
132077ff-cfb9-4fa9-a712-f9ab8afb4d29	e0220c71-4670-4133-ade0-693941a03ea4	2026-03-02	08:47:00	10:12:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	d7069b98-8a84-4945-9a2f-111687cdbcea	2026-03-02 09:37:00	2026-03-02 08:37:00	2026-03-02 10:12:00	t	Consulta de dudas	\N
151efe43-5300-4c1f-a395-8886de0b41d1	ad1ec0fb-7398-4f7a-9653-769565330b46	2026-04-28	10:32:00	12:00:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	3dc05b95-38cc-412e-90db-9a9f00e5b4fc	2026-04-28 11:22:00	2026-04-28 10:22:00	2026-04-28 12:00:00	f	\N	\N
b03072ca-3c5f-4a12-b331-edb682780e10	ad1ec0fb-7398-4f7a-9653-769565330b46	2026-05-26	10:37:00	12:00:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	4b13cd62-570e-4689-92c2-3d3e880fd42a	2026-05-26 11:27:00	2026-05-26 10:27:00	2026-05-26 12:00:00	f	\N	\N
d5dd586a-a1a8-45c3-89d1-5b05a11e2b04	ad1ec0fb-7398-4f7a-9653-769565330b46	2026-03-31	10:30:00	12:00:00	CANCELED	293d282f-1389-4756-8a76-9b1879315439	4a621a82-2137-4d63-81a2-25a3c934f828	2026-03-31 11:20:00	2026-03-31 10:20:00	2026-03-31 12:00:00	f	\N	\N
cfad4e4a-d6e9-48b9-9f05-d0d3c45096a3	ad1ec0fb-7398-4f7a-9653-769565330b46	2026-05-05	10:32:00	12:00:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	95d03e6d-28d4-48b0-97fb-29aea41d4d11	2026-05-05 11:22:00	2026-05-05 10:22:00	2026-05-05 12:00:00	f	\N	\N
0d22d998-cf80-468d-bfc4-fa4ef24a104e	ad1ec0fb-7398-4f7a-9653-769565330b46	2026-04-14	10:32:00	12:00:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	25116484-0848-4278-948e-19dd45eed849	2026-04-14 11:22:00	2026-04-14 10:22:00	2026-04-14 12:00:00	f	\N	\N
f25f8af4-8078-4450-9871-bc2886a6a129	ad1ec0fb-7398-4f7a-9653-769565330b46	2026-05-19	10:36:00	12:00:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	a976e0ad-4d49-4301-8981-478d41393949	2026-05-19 11:26:00	2026-05-19 10:26:00	2026-05-19 12:00:00	t	Clase práctica adicional	\N
c87fa6aa-2459-476d-8636-36d3a22cec8b	ad1ec0fb-7398-4f7a-9653-769565330b46	2026-03-17	10:36:00	12:00:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	90e42c66-4c45-4359-9b7a-3644ab373caa	2026-03-17 11:26:00	2026-03-17 10:26:00	2026-03-17 12:00:00	f	\N	\N
1f835efa-537d-491c-a47f-e972d5ab71f1	4f6b60dc-a542-4a5c-b946-69af663c401b	2026-05-06	13:01:00	14:20:00	FINISHED	b12fd2eb-e16b-4931-bdbd-1c3918053bc0	c5cab047-0aa8-49a7-8009-79f60cf88041	2026-05-06 13:51:00	2026-05-06 12:51:00	2026-05-06 14:20:00	f	\N	\N
1a1a7b9a-76ec-41d3-9972-9e5cd4fa1b27	4f6b60dc-a542-4a5c-b946-69af663c401b	2026-04-22	13:08:00	14:26:00	FINISHED	b12fd2eb-e16b-4931-bdbd-1c3918053bc0	085dac8f-7bbe-4f47-988f-ff32b6149297	2026-04-22 13:58:00	2026-04-22 12:58:00	2026-04-22 14:26:00	t	Consulta de dudas	\N
1a877ffd-a1b3-40a5-9eff-f94a541b714e	4f6b60dc-a542-4a5c-b946-69af663c401b	2026-04-29	13:05:00	14:29:00	FINISHED	b12fd2eb-e16b-4931-bdbd-1c3918053bc0	e402383f-a5ac-4502-bebc-11e369ed264d	2026-04-29 13:55:00	2026-04-29 12:55:00	2026-04-29 14:29:00	f	\N	\N
06086179-0d87-47d0-a1a6-4397c2b24a4e	4f6b60dc-a542-4a5c-b946-69af663c401b	2026-04-01	13:04:00	14:24:00	FINISHED	b12fd2eb-e16b-4931-bdbd-1c3918053bc0	5c6b80d5-3e61-4a04-a3c2-3d45cca1f64b	2026-04-01 13:54:00	2026-04-01 12:54:00	2026-04-01 14:24:00	f	\N	\N
9fbcc8b6-0468-427a-a704-c0e5221cba2f	4f6b60dc-a542-4a5c-b946-69af663c401b	2026-05-13	13:02:00	14:23:00	FINISHED	b12fd2eb-e16b-4931-bdbd-1c3918053bc0	c9bedcc4-165a-4140-9a59-7a99d5a684cb	2026-05-13 13:52:00	2026-05-13 12:52:00	2026-05-13 14:23:00	t	Clase práctica adicional	\N
d57f4431-9f66-43f7-811c-fc83533f67a5	4f6b60dc-a542-4a5c-b946-69af663c401b	2026-03-04	13:04:00	14:22:00	FINISHED	b12fd2eb-e16b-4931-bdbd-1c3918053bc0	50ccd5e7-6fb4-4c21-a144-e2c49b93d32b	2026-03-04 13:54:00	2026-03-04 12:54:00	2026-03-04 14:22:00	f	\N	\N
89d4879a-0fb8-4a44-a716-865e27256976	4f6b60dc-a542-4a5c-b946-69af663c401b	2026-04-08	13:02:00	14:22:00	CANCELED	b12fd2eb-e16b-4931-bdbd-1c3918053bc0	848df51d-7111-4333-a814-29b55eb375e6	2026-04-08 13:52:00	2026-04-08 12:52:00	2026-04-08 14:22:00	f	\N	\N
c3ba0c70-58d0-49fe-8c08-581228a1356e	95987e5a-5a06-425d-9b3f-62d2efbc260a	2026-03-09	10:38:00	12:00:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	448e7792-ccce-44fd-9043-51e7c3318445	2026-03-09 11:28:00	2026-03-09 10:28:00	2026-03-09 12:00:00	f	\N	\N
a3c4109e-e2f9-4292-85a8-3b60e61dc453	95987e5a-5a06-425d-9b3f-62d2efbc260a	2026-05-11	10:39:00	12:00:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	a9acb653-9253-4a23-9b6d-dbb6b4b294c8	2026-05-11 11:29:00	2026-05-11 10:29:00	2026-05-11 12:00:00	f	\N	\N
484ae03c-a8cf-49c0-aaca-cc366027f27b	95987e5a-5a06-425d-9b3f-62d2efbc260a	2026-03-30	10:37:00	12:00:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	bc618cb2-a8ab-42f4-9f6e-a87a2d00f5fb	2026-03-30 11:27:00	2026-03-30 10:27:00	2026-03-30 12:00:00	f	\N	\N
6cf894f4-8d8a-4e83-ac60-ab12cf5c9283	95987e5a-5a06-425d-9b3f-62d2efbc260a	2026-04-27	10:31:00	12:00:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	77b61d5a-9923-4b3d-b1ad-f22470b2a8b6	2026-04-27 11:21:00	2026-04-27 10:21:00	2026-04-27 12:00:00	f	\N	\N
d2b9fe66-1be4-4d63-9a0f-4b3468fd3756	95987e5a-5a06-425d-9b3f-62d2efbc260a	2026-03-23	10:34:00	12:00:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	26aeadfe-d235-47c8-9404-7de5a56e7d8d	2026-03-23 11:24:00	2026-03-23 10:24:00	2026-03-23 12:00:00	f	\N	\N
54093705-f69a-4c03-9a43-a7441d0ab869	95987e5a-5a06-425d-9b3f-62d2efbc260a	2026-03-16	10:30:00	12:00:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	d1f5eb7d-da9d-426e-b674-460c6380eab1	2026-03-16 11:20:00	2026-03-16 10:20:00	2026-03-16 12:00:00	f	\N	\N
f94a900b-bfde-4740-8d85-4fbffe492c86	95987e5a-5a06-425d-9b3f-62d2efbc260a	2026-04-20	10:39:00	12:00:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	8ea638ec-bbe4-42dd-add9-c69edb7996cf	2026-04-20 11:29:00	2026-04-20 10:29:00	2026-04-20 12:00:00	f	\N	\N
6a1fd541-41c0-4a19-98d0-c59cd8e75015	95987e5a-5a06-425d-9b3f-62d2efbc260a	2026-05-25	10:31:00	12:00:00	FINISHED	05201eb0-de88-43a5-9dae-19c6b8f35667	860caf68-7ddd-4d3a-a4e6-0788c7e01200	2026-05-25 11:21:00	2026-05-25 10:21:00	2026-05-25 12:00:00	f	\N	\N
322c60c5-51e9-4c86-a2fd-fbd089a0c9c6	376b8ace-74c2-4f1a-88e4-04bd8683dcbe	2026-03-10	13:09:00	14:24:00	FINISHED	ae36bd11-8d3c-4e4d-bfc2-f909bdf3b5ac	89acc72f-0675-4dc2-88ff-7ecfd603d254	2026-03-10 13:59:00	2026-03-10 12:59:00	2026-03-10 14:24:00	f	\N	\N
b6b1a3ca-001d-4d5b-91ac-a2a9d4eda911	376b8ace-74c2-4f1a-88e4-04bd8683dcbe	2026-04-28	13:03:00	14:22:00	FINISHED	ae36bd11-8d3c-4e4d-bfc2-f909bdf3b5ac	db3ed0cc-0e01-41aa-91ee-ffea4a145f00	2026-04-28 13:53:00	2026-04-28 12:53:00	2026-04-28 14:22:00	f	\N	\N
a9af1500-bd74-4e18-b2c2-552b0d64f0e6	376b8ace-74c2-4f1a-88e4-04bd8683dcbe	2026-03-17	13:03:00	14:26:00	CANCELED	ae36bd11-8d3c-4e4d-bfc2-f909bdf3b5ac	97f8ecbf-7d7c-4f91-a24a-5af6390b8a8b	2026-03-17 13:53:00	2026-03-17 12:53:00	2026-03-17 14:26:00	f	\N	\N
44695009-c2f5-40ef-a79f-69d62c64f342	376b8ace-74c2-4f1a-88e4-04bd8683dcbe	2026-05-12	13:06:00	14:20:00	FINISHED	ae36bd11-8d3c-4e4d-bfc2-f909bdf3b5ac	78737c6c-fc10-42a8-94d0-3c850a0b9119	2026-05-12 13:56:00	2026-05-12 12:56:00	2026-05-12 14:20:00	f	\N	\N
0efe0b1f-4876-44ed-916a-0deed4b86116	376b8ace-74c2-4f1a-88e4-04bd8683dcbe	2026-04-21	13:10:00	14:25:00	FINISHED	ae36bd11-8d3c-4e4d-bfc2-f909bdf3b5ac	244f2471-c0da-4b8e-bc94-88a270c38a3e	2026-04-21 14:00:00	2026-04-21 13:00:00	2026-04-21 14:25:00	f	\N	\N
8a2ea0e5-5159-4a09-889e-da59552da5b9	376b8ace-74c2-4f1a-88e4-04bd8683dcbe	2026-05-05	13:07:00	14:22:00	FINISHED	ae36bd11-8d3c-4e4d-bfc2-f909bdf3b5ac	87f229db-3641-4ed9-895d-e204f0a259c5	2026-05-05 13:57:00	2026-05-05 12:57:00	2026-05-05 14:22:00	f	\N	\N
6414bd69-ff96-4117-bc23-50745ecb8eb0	376b8ace-74c2-4f1a-88e4-04bd8683dcbe	2026-05-19	13:07:00	14:29:00	FINISHED	ae36bd11-8d3c-4e4d-bfc2-f909bdf3b5ac	c93dd854-45f8-4d6f-85b4-dab58c7f06b1	2026-05-19 13:57:00	2026-05-19 12:57:00	2026-05-19 14:29:00	f	\N	\N
b9933c8f-6af0-4b3c-ac9b-a7f166f2a4b2	2b8b1a41-01ed-4cbc-8138-a9ace9957528	2026-03-25	14:45:00	16:14:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	88108295-94f8-40be-aa2e-9eb374c09838	2026-03-25 15:35:00	2026-03-25 14:35:00	2026-03-25 16:14:00	f	\N	\N
2febcbb7-e35b-4fa0-81d1-610bb8d0a0d8	2b8b1a41-01ed-4cbc-8138-a9ace9957528	2026-05-27	14:55:00	16:15:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	9de747e0-63a1-4333-9277-884d46d9e2eb	2026-05-27 15:45:00	2026-05-27 14:45:00	2026-05-27 16:15:00	f	\N	\N
863cc6ef-37cd-4922-89a3-42d0340abea6	2b8b1a41-01ed-4cbc-8138-a9ace9957528	2026-03-11	14:48:00	16:14:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	7b6db9ba-66d5-4c8e-9022-e34f30c3c8fa	2026-03-11 15:38:00	2026-03-11 14:38:00	2026-03-11 16:14:00	f	\N	\N
2767806c-764c-4a57-b40a-d46709dc05be	2b8b1a41-01ed-4cbc-8138-a9ace9957528	2026-04-08	14:45:00	16:10:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	66bb9cba-3e1f-4ece-9eac-602a23fe6ce8	2026-04-08 15:35:00	2026-04-08 14:35:00	2026-04-08 16:10:00	f	\N	\N
bf07d702-4af6-4a2b-81d8-343bd50918c9	2b8b1a41-01ed-4cbc-8138-a9ace9957528	2026-03-04	14:46:00	16:07:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	57ab7a58-1b20-4e62-975e-ab258580344c	2026-03-04 15:36:00	2026-03-04 14:36:00	2026-03-04 16:07:00	f	\N	\N
895ff08e-837e-4e19-8f95-e4fc1aeb9c78	2b8b1a41-01ed-4cbc-8138-a9ace9957528	2026-05-20	14:48:00	16:11:00	FINISHED	293d282f-1389-4756-8a76-9b1879315439	16af5a96-2520-409b-a3a1-3cffbf76621f	2026-05-20 15:38:00	2026-05-20 14:38:00	2026-05-20 16:11:00	f	\N	\N
b147877b-6080-4c42-92f2-0d2a02f11de7	2b8b1a41-01ed-4cbc-8138-a9ace9957528	2026-04-01	14:55:00	16:08:00	CANCELED	293d282f-1389-4756-8a76-9b1879315439	6c1c3570-9e99-4571-bab3-0bf1e5347ac8	2026-04-01 15:45:00	2026-04-01 14:45:00	2026-04-01 16:08:00	f	\N	\N
50471ae4-c3aa-41ea-b6d7-d65e5a6560a0	88321b86-dcd6-4fa5-b01b-83891a6b945c	2026-03-23	13:06:00	14:27:00	FINISHED	89b43388-b396-48d7-a8ac-90a67dfbc4f6	b3457f19-8dba-4bcf-9e7e-943f4e2166f0	2026-03-23 13:56:00	2026-03-23 12:56:00	2026-03-23 14:27:00	f	\N	\N
8d1e380b-5d6e-442f-945d-2d25cd387704	88321b86-dcd6-4fa5-b01b-83891a6b945c	2026-04-27	13:01:00	14:29:00	FINISHED	89b43388-b396-48d7-a8ac-90a67dfbc4f6	456eef4d-ea35-4308-83e2-7a241d1895a8	2026-04-27 13:51:00	2026-04-27 12:51:00	2026-04-27 14:29:00	f	\N	\N
991b9881-9eeb-4219-b775-8a619db978d2	88321b86-dcd6-4fa5-b01b-83891a6b945c	2026-03-16	13:10:00	14:24:00	FINISHED	89b43388-b396-48d7-a8ac-90a67dfbc4f6	bc932768-a308-460b-b383-02611f280d1f	2026-03-16 14:00:00	2026-03-16 13:00:00	2026-03-16 14:24:00	t	Repaso de contenido	\N
0a242ff4-ba4d-444d-a1df-64de5fb63339	88321b86-dcd6-4fa5-b01b-83891a6b945c	2026-05-04	13:06:00	14:24:00	FINISHED	89b43388-b396-48d7-a8ac-90a67dfbc4f6	4f2f696a-b601-4ab4-b3b1-1a3c822deb26	2026-05-04 13:56:00	2026-05-04 12:56:00	2026-05-04 14:24:00	f	\N	\N
ea2b68e9-24f1-4faf-858b-b3501c79ac30	88321b86-dcd6-4fa5-b01b-83891a6b945c	2026-04-20	13:07:00	14:30:00	FINISHED	89b43388-b396-48d7-a8ac-90a67dfbc4f6	8134c276-f5a6-46a0-9884-cb26c47666c5	2026-04-20 13:57:00	2026-04-20 12:57:00	2026-04-20 14:30:00	f	\N	\N
7ef6dd06-7f81-42ea-9abb-c3487a751076	88321b86-dcd6-4fa5-b01b-83891a6b945c	2026-05-25	13:10:00	14:20:00	FINISHED	89b43388-b396-48d7-a8ac-90a67dfbc4f6	4ac2f77b-0b39-406d-8d52-baabbca4180e	2026-05-25 14:00:00	2026-05-25 13:00:00	2026-05-25 14:20:00	t	Consulta de dudas	\N
36ce13ce-bfdb-48e4-bfc6-512493a9c1bf	88321b86-dcd6-4fa5-b01b-83891a6b945c	2026-04-13	13:01:00	14:30:00	FINISHED	89b43388-b396-48d7-a8ac-90a67dfbc4f6	8502f036-bbcc-42ad-9ead-ed147e5a4fe6	2026-04-13 13:51:00	2026-04-13 12:51:00	2026-04-13 14:30:00	f	\N	\N
36700e99-401d-4a67-bff6-791838c4d586	88321b86-dcd6-4fa5-b01b-83891a6b945c	2026-05-18	13:06:00	14:25:00	FINISHED	89b43388-b396-48d7-a8ac-90a67dfbc4f6	2680740d-6c17-4e05-9c46-dfd3ac7b006a	2026-05-18 13:56:00	2026-05-18 12:56:00	2026-05-18 14:25:00	f	\N	\N
dbce3bea-5813-4083-90b7-ba6fe9c88609	74fdbdb4-ef0a-45d6-b4c1-be03605ad829	2026-05-26	14:47:00	16:11:00	FINISHED	37723e46-c4c8-41bc-9438-87b5102c0e17	92965585-cfe3-43aa-9207-4a1484a2bb05	2026-05-26 15:37:00	2026-05-26 14:37:00	2026-05-26 16:11:00	t	Repaso de contenido	\N
dff1bc36-98c3-4e7b-a9d3-471bf6164ef0	74fdbdb4-ef0a-45d6-b4c1-be03605ad829	2026-03-10	14:48:00	16:14:00	FINISHED	37723e46-c4c8-41bc-9438-87b5102c0e17	2380c4df-d0c0-43e6-b677-c480a9dfc5c8	2026-03-10 15:38:00	2026-03-10 14:38:00	2026-03-10 16:14:00	f	\N	\N
75e02e2c-e932-4d94-b0c8-3f2d8ac52cd7	74fdbdb4-ef0a-45d6-b4c1-be03605ad829	2026-03-24	14:52:00	16:07:00	CANCELED	37723e46-c4c8-41bc-9438-87b5102c0e17	93e4df17-3acf-4fc1-accb-47fd314bf9dd	2026-03-24 15:42:00	2026-03-24 14:42:00	2026-03-24 16:07:00	f	\N	\N
9824169e-6124-429c-9b62-d29f5103f2b3	74fdbdb4-ef0a-45d6-b4c1-be03605ad829	2026-05-12	14:46:00	16:15:00	FINISHED	37723e46-c4c8-41bc-9438-87b5102c0e17	dea9a12c-518a-42ef-9fbc-9adcc828242e	2026-05-12 15:36:00	2026-05-12 14:36:00	2026-05-12 16:15:00	t	Consulta de dudas	\N
7762e6c1-2bd3-4c82-b1ee-c98d7f881b63	74fdbdb4-ef0a-45d6-b4c1-be03605ad829	2026-05-05	14:53:00	16:15:00	FINISHED	37723e46-c4c8-41bc-9438-87b5102c0e17	73b3be7b-9502-4e9f-8182-46e04f7edad6	2026-05-05 15:43:00	2026-05-05 14:43:00	2026-05-05 16:15:00	f	\N	\N
6fd294e3-d165-4488-9739-2ea791a0b54a	74fdbdb4-ef0a-45d6-b4c1-be03605ad829	2026-04-21	14:46:00	16:12:00	FINISHED	37723e46-c4c8-41bc-9438-87b5102c0e17	508c9fb3-6b6c-4912-a504-f6641f7b440b	2026-04-21 15:36:00	2026-04-21 14:36:00	2026-04-21 16:12:00	f	\N	\N
42aaf634-be7d-43fc-b765-809862f6036d	74fdbdb4-ef0a-45d6-b4c1-be03605ad829	2026-05-19	14:47:00	16:09:00	FINISHED	37723e46-c4c8-41bc-9438-87b5102c0e17	3a050cdd-2996-41af-b957-f37e55abd229	2026-05-19 15:37:00	2026-05-19 14:37:00	2026-05-19 16:09:00	t	Repaso de contenido	\N
4e0c525a-4835-4aea-8a5e-7cc6ad9697f9	d721eedb-2e39-431e-b3d0-122e135aa628	2026-04-22	16:34:00	18:00:00	FINISHED	6ce5f225-989b-4382-b6f1-8a4231113a1c	0574a100-fe23-4132-b354-8a1e3d65ecbb	2026-04-22 17:24:00	2026-04-22 16:24:00	2026-04-22 18:00:00	f	\N	\N
6a82503f-dd01-4a88-8973-a8ad44605c69	d721eedb-2e39-431e-b3d0-122e135aa628	2026-03-25	16:34:00	18:00:00	FINISHED	6ce5f225-989b-4382-b6f1-8a4231113a1c	3beb19e7-8479-4792-9777-a83e14e8bfb6	2026-03-25 17:24:00	2026-03-25 16:24:00	2026-03-25 18:00:00	f	\N	\N
f5524a32-0a7b-4f1e-b8c7-a9a5a7d3fb82	d721eedb-2e39-431e-b3d0-122e135aa628	2026-04-15	16:38:00	18:00:00	FINISHED	6ce5f225-989b-4382-b6f1-8a4231113a1c	32248877-c40d-49b7-9a8a-3a594aa8157c	2026-04-15 17:28:00	2026-04-15 16:28:00	2026-04-15 18:00:00	t	Consulta de dudas	\N
169e2b2f-85dd-4175-8c69-66a3dd7127f0	d721eedb-2e39-431e-b3d0-122e135aa628	2026-03-04	16:37:00	18:00:00	FINISHED	6ce5f225-989b-4382-b6f1-8a4231113a1c	80d96a74-fd26-43b1-9f9e-c0fcdbd5f029	2026-03-04 17:27:00	2026-03-04 16:27:00	2026-03-04 18:00:00	f	\N	\N
193922b1-9df4-4be9-aa99-c6fddca667ef	d721eedb-2e39-431e-b3d0-122e135aa628	2026-03-18	16:33:00	18:00:00	FINISHED	6ce5f225-989b-4382-b6f1-8a4231113a1c	3685fe9f-b86c-4d5d-a4c3-f1469b95c316	2026-03-18 17:23:00	2026-03-18 16:23:00	2026-03-18 18:00:00	f	\N	\N
f9ba474d-83ee-45aa-b0e3-2c774ecb3236	d721eedb-2e39-431e-b3d0-122e135aa628	2026-05-13	16:33:00	18:00:00	FINISHED	6ce5f225-989b-4382-b6f1-8a4231113a1c	83ae7f27-8308-44e4-b7d2-6d37e6a85c89	2026-05-13 17:23:00	2026-05-13 16:23:00	2026-05-13 18:00:00	t	Consulta de dudas	\N
63af7991-7ce7-42c4-a7f8-664c695acc7a	d721eedb-2e39-431e-b3d0-122e135aa628	2026-05-06	16:38:00	18:00:00	CANCELED	6ce5f225-989b-4382-b6f1-8a4231113a1c	38e2b0c2-22e4-4f68-b58e-1b2b3a973645	2026-05-06 17:28:00	2026-05-06 16:28:00	2026-05-06 18:00:00	f	\N	\N
0cc7d669-3891-426f-b7eb-3c62ee2e75f8	516d8f80-ae71-4a61-81e3-157cf6ae6be7	2026-05-18	14:47:00	16:14:00	FINISHED	9debd9f0-2efe-4d63-8866-1b4aafb19fa6	790126dc-9069-42ac-985b-2ee081eea5d7	2026-05-18 15:37:00	2026-05-18 14:37:00	2026-05-18 16:14:00	f	\N	\N
b3c6b239-cfa1-44cf-8674-f52919b08e39	516d8f80-ae71-4a61-81e3-157cf6ae6be7	2026-04-06	14:54:00	16:14:00	FINISHED	9debd9f0-2efe-4d63-8866-1b4aafb19fa6	c6dbbf8d-ff07-48aa-bcf4-ec052775ce3d	2026-04-06 15:44:00	2026-04-06 14:44:00	2026-04-06 16:14:00	f	\N	\N
ec2bacfc-5eae-4647-8025-bc672c840a84	516d8f80-ae71-4a61-81e3-157cf6ae6be7	2026-03-02	14:55:00	16:12:00	FINISHED	9debd9f0-2efe-4d63-8866-1b4aafb19fa6	6644831f-f49b-4963-a22c-d43d93d17d2f	2026-03-02 15:45:00	2026-03-02 14:45:00	2026-03-02 16:12:00	f	\N	\N
557ed8ca-4785-4fb1-9f9b-731ccaadfbeb	516d8f80-ae71-4a61-81e3-157cf6ae6be7	2026-05-11	14:51:00	16:14:00	FINISHED	9debd9f0-2efe-4d63-8866-1b4aafb19fa6	19d28369-53ac-4fb4-a6d8-8e066420def8	2026-05-11 15:41:00	2026-05-11 14:41:00	2026-05-11 16:14:00	f	\N	\N
b7b1dbf5-8844-4f27-a448-15a325ff4d55	516d8f80-ae71-4a61-81e3-157cf6ae6be7	2026-04-20	14:54:00	16:12:00	FINISHED	9debd9f0-2efe-4d63-8866-1b4aafb19fa6	0e53d028-b9d7-4568-9af8-0552ae4c052d	2026-04-20 15:44:00	2026-04-20 14:44:00	2026-04-20 16:12:00	f	\N	\N
7cc47342-9473-44db-a2e0-6a2d88263655	516d8f80-ae71-4a61-81e3-157cf6ae6be7	2026-03-16	14:54:00	16:06:00	FINISHED	9debd9f0-2efe-4d63-8866-1b4aafb19fa6	d4a70c19-9abe-4b9e-bc86-02304d70c593	2026-03-16 15:44:00	2026-03-16 14:44:00	2026-03-16 16:06:00	f	\N	\N
a55c877f-fc65-4167-b0f8-7fe48453029c	516d8f80-ae71-4a61-81e3-157cf6ae6be7	2026-05-04	14:45:00	16:06:00	FINISHED	9debd9f0-2efe-4d63-8866-1b4aafb19fa6	d7c66c11-42cc-46a6-8d36-d8b7fa6630e7	2026-05-04 15:35:00	2026-05-04 14:35:00	2026-05-04 16:06:00	f	\N	\N
af4ff1e1-74f0-4a89-8058-375475011007	516d8f80-ae71-4a61-81e3-157cf6ae6be7	2026-03-30	14:46:00	16:09:00	FINISHED	9debd9f0-2efe-4d63-8866-1b4aafb19fa6	a9d6d993-8be9-42b3-8ae6-5785c4590f38	2026-03-30 15:36:00	2026-03-30 14:36:00	2026-03-30 16:09:00	f	\N	\N
4ee08b9b-4dd6-45c6-83d4-5c94db060f2a	679e9757-8d90-44b6-97f6-f11ef00f3a6c	2026-05-12	16:35:00	18:00:00	FINISHED	2c657dfa-4ad0-4568-94c3-0dae0f4040f2	049e1536-42c9-4ad1-aa35-292d84f73eb9	2026-05-12 17:25:00	2026-05-12 16:25:00	2026-05-12 18:00:00	f	\N	\N
f0d4e4db-064c-4813-b7af-73d55ec9e498	679e9757-8d90-44b6-97f6-f11ef00f3a6c	2026-05-05	16:34:00	18:00:00	FINISHED	2c657dfa-4ad0-4568-94c3-0dae0f4040f2	612efbc0-e11f-4d1e-badc-78adeb27fc7a	2026-05-05 17:24:00	2026-05-05 16:24:00	2026-05-05 18:00:00	f	\N	\N
d40d79aa-9dc4-4de3-bdf4-f711fdedfb07	679e9757-8d90-44b6-97f6-f11ef00f3a6c	2026-05-19	16:32:00	18:00:00	CANCELED	2c657dfa-4ad0-4568-94c3-0dae0f4040f2	1d3489c6-f8fa-4fbb-8e16-d792fb677ff9	2026-05-19 17:22:00	2026-05-19 16:22:00	2026-05-19 18:00:00	f	\N	\N
a88b31ab-a035-42c1-bd9d-aa262b90e71c	679e9757-8d90-44b6-97f6-f11ef00f3a6c	2026-04-28	16:40:00	18:00:00	FINISHED	2c657dfa-4ad0-4568-94c3-0dae0f4040f2	502d519d-949c-4711-94e0-3ecd1f24edde	2026-04-28 17:30:00	2026-04-28 16:30:00	2026-04-28 18:00:00	f	\N	\N
41fe7b13-6171-4f8b-9f11-c9d03b48a9f1	679e9757-8d90-44b6-97f6-f11ef00f3a6c	2026-04-07	16:37:00	18:00:00	FINISHED	2c657dfa-4ad0-4568-94c3-0dae0f4040f2	52ebf276-7940-4bf5-afda-560384c464ce	2026-04-07 17:27:00	2026-04-07 16:27:00	2026-04-07 18:00:00	f	\N	\N
55c6348f-4e85-44ac-8696-cdde8a9315c0	679e9757-8d90-44b6-97f6-f11ef00f3a6c	2026-03-31	16:31:00	18:00:00	FINISHED	2c657dfa-4ad0-4568-94c3-0dae0f4040f2	2d677eea-0bff-4c26-a14d-a6b4b485ffb4	2026-03-31 17:21:00	2026-03-31 16:21:00	2026-03-31 18:00:00	f	\N	\N
d15a305e-5403-463d-821c-9dd52c6a7fb2	679e9757-8d90-44b6-97f6-f11ef00f3a6c	2026-03-10	16:37:00	18:00:00	FINISHED	2c657dfa-4ad0-4568-94c3-0dae0f4040f2	c7dc634c-2c07-4e9f-b0bd-d0878d48c2fe	2026-03-10 17:27:00	2026-03-10 16:27:00	2026-03-10 18:00:00	f	\N	\N
b5e22e02-da2e-47c6-baeb-6809a25c49ef	9d9afeac-3020-421a-bae9-a9ebd4980fcb	2026-05-04	16:31:00	18:00:00	FINISHED	433c7ba8-22bd-48e5-8a98-672a8fea6b22	0176bf24-e3c4-4f20-9182-61539eb75d13	2026-05-04 17:21:00	2026-05-04 16:21:00	2026-05-04 18:00:00	f	\N	\N
a3cecac0-6039-4cf5-9bfd-5c2bc319f717	9d9afeac-3020-421a-bae9-a9ebd4980fcb	2026-03-09	16:35:00	18:00:00	FINISHED	433c7ba8-22bd-48e5-8a98-672a8fea6b22	e667d050-34fe-4800-99eb-8f775139c6de	2026-03-09 17:25:00	2026-03-09 16:25:00	2026-03-09 18:00:00	f	\N	\N
74f37bc7-2159-4506-a455-a4848d84b243	9d9afeac-3020-421a-bae9-a9ebd4980fcb	2026-05-18	16:32:00	18:00:00	FINISHED	433c7ba8-22bd-48e5-8a98-672a8fea6b22	38fb8253-f8a9-41a1-a097-ff76aad6ec79	2026-05-18 17:22:00	2026-05-18 16:22:00	2026-05-18 18:00:00	f	\N	\N
c0881d47-a1bc-4faf-831e-ee260af1612a	9d9afeac-3020-421a-bae9-a9ebd4980fcb	2026-04-27	16:38:00	18:00:00	FINISHED	433c7ba8-22bd-48e5-8a98-672a8fea6b22	24409d55-f73f-405c-9034-1bb5e13fffa9	2026-04-27 17:28:00	2026-04-27 16:28:00	2026-04-27 18:00:00	f	\N	\N
f1994397-ee1a-40b4-ad82-75bf99de4792	9d9afeac-3020-421a-bae9-a9ebd4980fcb	2026-03-23	16:39:00	18:00:00	FINISHED	433c7ba8-22bd-48e5-8a98-672a8fea6b22	f06358f8-80eb-45ce-acb6-407dd6905914	2026-03-23 17:29:00	2026-03-23 16:29:00	2026-03-23 18:00:00	f	\N	\N
d3f19049-e0e3-495d-9574-1ae61a99e219	9d9afeac-3020-421a-bae9-a9ebd4980fcb	2026-03-30	16:38:00	18:00:00	FINISHED	433c7ba8-22bd-48e5-8a98-672a8fea6b22	8d4f9510-8c22-457b-9a75-2c803a2e76bc	2026-03-30 17:28:00	2026-03-30 16:28:00	2026-03-30 18:00:00	f	\N	\N
6ed32118-367c-468d-acdb-aa3d32776997	9d9afeac-3020-421a-bae9-a9ebd4980fcb	2026-05-11	16:40:00	18:00:00	CANCELED	433c7ba8-22bd-48e5-8a98-672a8fea6b22	aeaaf34d-29d7-460a-8fee-2dee5568cae1	2026-05-11 17:30:00	2026-05-11 16:30:00	2026-05-11 18:00:00	f	\N	\N
8856e354-5d0e-4d16-bda2-7df23e3bbef0	9d9afeac-3020-421a-bae9-a9ebd4980fcb	2026-03-16	16:34:00	18:00:00	FINISHED	433c7ba8-22bd-48e5-8a98-672a8fea6b22	a9d414a4-f3b4-4138-ae4f-c3ece06cdba7	2026-03-16 17:24:00	2026-03-16 16:24:00	2026-03-16 18:00:00	f	\N	\N
dc92a7e4-2660-4b8f-875b-3646dc856214	86e1ae58-a186-47a3-a212-5eff6526b974	2026-03-12	07:09:00	08:27:00	FINISHED	c67a0297-6e74-4b31-a257-023783fd6bcc	2310328b-b2b9-4b97-966b-822bf67afc00	2026-03-12 07:59:00	2026-03-12 06:59:00	2026-03-12 08:27:00	f	\N	\N
31b2b273-9678-455a-ae27-2e01b0964c90	86e1ae58-a186-47a3-a212-5eff6526b974	2026-03-19	07:05:00	08:27:00	FINISHED	c67a0297-6e74-4b31-a257-023783fd6bcc	3a275c5b-3891-44b8-88e2-618d2e7291c1	2026-03-19 07:55:00	2026-03-19 06:55:00	2026-03-19 08:27:00	f	\N	\N
318361f5-70e6-47de-bc94-5cb3220e4359	86e1ae58-a186-47a3-a212-5eff6526b974	2026-04-02	07:10:00	08:20:00	FINISHED	c67a0297-6e74-4b31-a257-023783fd6bcc	acfeab44-d522-41bb-b037-6173c74dda11	2026-04-02 08:00:00	2026-04-02 07:00:00	2026-04-02 08:20:00	f	\N	\N
73a19752-e281-4e4d-8165-0f5df902fe14	86e1ae58-a186-47a3-a212-5eff6526b974	2026-05-28	07:04:00	08:22:00	FINISHED	c67a0297-6e74-4b31-a257-023783fd6bcc	5a5d505b-d9c1-41d0-a9f3-a98091318e16	2026-05-28 07:54:00	2026-05-28 06:54:00	2026-05-28 08:22:00	f	\N	\N
be073ae0-0db2-48b2-8b99-1dc409c58840	86e1ae58-a186-47a3-a212-5eff6526b974	2026-05-07	07:07:00	08:26:00	FINISHED	c67a0297-6e74-4b31-a257-023783fd6bcc	43bdedaa-64fd-4f85-b6cf-47b745b50bd4	2026-05-07 07:57:00	2026-05-07 06:57:00	2026-05-07 08:26:00	f	\N	\N
c0bf3100-ad6f-4925-8a82-4a9b4e9b2fb7	86e1ae58-a186-47a3-a212-5eff6526b974	2026-05-21	07:00:00	08:29:00	FINISHED	c67a0297-6e74-4b31-a257-023783fd6bcc	11965231-5cac-475a-bffb-6d4456701b5d	2026-05-21 07:50:00	2026-05-21 06:50:00	2026-05-21 08:29:00	f	\N	\N
8cc62cb9-3d58-4414-8a60-ef0e4fcf02a7	86e1ae58-a186-47a3-a212-5eff6526b974	2026-04-23	07:10:00	08:24:00	FINISHED	c67a0297-6e74-4b31-a257-023783fd6bcc	122f9a44-d254-4e36-8a8a-89132d4e2db4	2026-04-23 08:00:00	2026-04-23 07:00:00	2026-04-23 08:24:00	f	\N	\N
13edadb5-8294-4503-b4ec-99e713dc4609	edc7dad4-08b6-4865-a87a-3b3b944c9637	2026-04-02	08:53:00	10:09:00	FINISHED	712c3034-43e6-4ec6-a316-a8bc0c98de72	ade3e03c-9f00-432e-9689-5c5e05185282	2026-04-02 09:43:00	2026-04-02 08:43:00	2026-04-02 10:09:00	f	\N	\N
5fdbf914-d42c-41c0-849c-539bc7f6dc3b	edc7dad4-08b6-4865-a87a-3b3b944c9637	2026-03-05	08:53:00	10:15:00	FINISHED	712c3034-43e6-4ec6-a316-a8bc0c98de72	2c7395f9-e7f0-4d24-8906-7d4f58dd6f69	2026-03-05 09:43:00	2026-03-05 08:43:00	2026-03-05 10:15:00	f	\N	\N
fbd33247-4c5e-4a08-91ec-8dc1d4b74146	edc7dad4-08b6-4865-a87a-3b3b944c9637	2026-05-21	08:46:00	10:14:00	CANCELED	712c3034-43e6-4ec6-a316-a8bc0c98de72	b60431bf-6940-4a5b-aabd-ce5f9d1d2db2	2026-05-21 09:36:00	2026-05-21 08:36:00	2026-05-21 10:14:00	f	\N	\N
105e53a8-0efd-4e78-b179-2768f36495be	edc7dad4-08b6-4865-a87a-3b3b944c9637	2026-04-09	08:47:00	10:07:00	FINISHED	712c3034-43e6-4ec6-a316-a8bc0c98de72	9cf4b3df-ee51-42f4-a91c-43061271f500	2026-04-09 09:37:00	2026-04-09 08:37:00	2026-04-09 10:07:00	f	\N	\N
d196abad-c46e-4512-9907-8272d2684fd1	edc7dad4-08b6-4865-a87a-3b3b944c9637	2026-03-19	08:45:00	10:10:00	FINISHED	712c3034-43e6-4ec6-a316-a8bc0c98de72	247fde7b-b269-47bb-bfb9-851677106c80	2026-03-19 09:35:00	2026-03-19 08:35:00	2026-03-19 10:10:00	f	\N	\N
08d50fbf-9774-4955-b59b-ccaa87776ab2	edc7dad4-08b6-4865-a87a-3b3b944c9637	2026-05-28	08:54:00	10:07:00	FINISHED	712c3034-43e6-4ec6-a316-a8bc0c98de72	1f4a8635-5dbe-4f66-a984-4e83fd8e4ad5	2026-05-28 09:44:00	2026-05-28 08:44:00	2026-05-28 10:07:00	f	\N	\N
54305795-e919-475d-8ba2-340fcedf116a	edc7dad4-08b6-4865-a87a-3b3b944c9637	2026-03-12	08:47:00	10:09:00	FINISHED	712c3034-43e6-4ec6-a316-a8bc0c98de72	9e9d1beb-bb23-4ebd-9403-4f99eff2d0ea	2026-03-12 09:37:00	2026-03-12 08:37:00	2026-03-12 10:09:00	f	\N	\N
a0ac8bfe-473c-4f65-969c-2065ffffdbc2	edc7dad4-08b6-4865-a87a-3b3b944c9637	2026-05-07	08:47:00	10:15:00	FINISHED	712c3034-43e6-4ec6-a316-a8bc0c98de72	2d089452-c191-4eb4-b26b-a9ad0aadf336	2026-05-07 09:37:00	2026-05-07 08:37:00	2026-05-07 10:15:00	f	\N	\N
54a3a5bf-a0d7-4153-8c15-7a54a817012a	02663d0e-87ab-4c1d-9292-1664b4377cc6	2026-04-02	10:35:00	12:00:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	a1190e8f-6426-4d72-9e15-17dfe51ae6b3	2026-04-02 11:25:00	2026-04-02 10:25:00	2026-04-02 12:00:00	f	\N	\N
d6b94b1c-bc27-4bfc-bb44-17e45f482afa	02663d0e-87ab-4c1d-9292-1664b4377cc6	2026-04-09	10:36:00	12:00:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	ce72aadb-fa68-47a0-be17-0292350b24c1	2026-04-09 11:26:00	2026-04-09 10:26:00	2026-04-09 12:00:00	f	\N	\N
f8a73f55-a479-4b02-ae3a-8ba4ff61ef55	02663d0e-87ab-4c1d-9292-1664b4377cc6	2026-03-05	10:32:00	12:00:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	835acfe6-fff4-44a7-b5b0-74f84562072f	2026-03-05 11:22:00	2026-03-05 10:22:00	2026-03-05 12:00:00	f	\N	\N
e0b492b5-77ce-4461-bda0-ec7c2876ef74	02663d0e-87ab-4c1d-9292-1664b4377cc6	2026-05-21	10:32:00	12:00:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	d34347a1-28ab-4262-841f-85fe28bf6e0b	2026-05-21 11:22:00	2026-05-21 10:22:00	2026-05-21 12:00:00	f	\N	\N
71fa5a29-e1a3-4437-b598-ebd6994541a0	02663d0e-87ab-4c1d-9292-1664b4377cc6	2026-03-26	10:36:00	12:00:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	b5a1d977-75cb-4b24-95c9-fe699c6b7bcc	2026-03-26 11:26:00	2026-03-26 10:26:00	2026-03-26 12:00:00	f	\N	\N
f544a5b3-c208-4715-89e0-56b2cf8d3da5	02663d0e-87ab-4c1d-9292-1664b4377cc6	2026-04-30	10:32:00	12:00:00	CANCELED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	d694c6e7-724d-475a-9d0d-937bff5ff539	2026-04-30 11:22:00	2026-04-30 10:22:00	2026-04-30 12:00:00	f	\N	\N
006c3605-ca1d-4dd7-b30d-ee8fdd4b2043	02663d0e-87ab-4c1d-9292-1664b4377cc6	2026-05-07	10:36:00	12:00:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	76758413-5b4d-46be-828a-c2035402c564	2026-05-07 11:26:00	2026-05-07 10:26:00	2026-05-07 12:00:00	f	\N	\N
f192579c-2a69-4ebf-8e3e-5df6abe3a807	d28a1e6f-8803-4e9d-ae3c-23123cf1931f	2026-05-21	13:07:00	14:27:00	FINISHED	468276b7-faa3-4027-898f-6b6931bbf908	0a83070f-316a-4223-80db-ed1d1ddb9076	2026-05-21 13:57:00	2026-05-21 12:57:00	2026-05-21 14:27:00	f	\N	\N
58c88aa7-e3a9-403d-b9f1-26a5444476da	d28a1e6f-8803-4e9d-ae3c-23123cf1931f	2026-03-26	13:03:00	14:23:00	FINISHED	468276b7-faa3-4027-898f-6b6931bbf908	c0b31c7f-9378-44c1-bc2f-f9e354c150b6	2026-03-26 13:53:00	2026-03-26 12:53:00	2026-03-26 14:23:00	f	\N	\N
6e4dcbef-9bb0-4eca-af06-b91d853d4ec0	d28a1e6f-8803-4e9d-ae3c-23123cf1931f	2026-04-02	13:05:00	14:26:00	FINISHED	468276b7-faa3-4027-898f-6b6931bbf908	060ed282-49c2-4308-a292-68305f690e03	2026-04-02 13:55:00	2026-04-02 12:55:00	2026-04-02 14:26:00	f	\N	\N
06a3477b-9694-4d42-9594-85696d9a6eb4	d28a1e6f-8803-4e9d-ae3c-23123cf1931f	2026-03-19	13:03:00	14:27:00	FINISHED	468276b7-faa3-4027-898f-6b6931bbf908	2eaf1e59-4af9-46ac-81fb-e0f6296ead6f	2026-03-19 13:53:00	2026-03-19 12:53:00	2026-03-19 14:27:00	f	\N	\N
cf685df8-d2fb-4823-9313-c0ef281b1c62	d28a1e6f-8803-4e9d-ae3c-23123cf1931f	2026-03-12	13:00:00	14:20:00	FINISHED	468276b7-faa3-4027-898f-6b6931bbf908	e2d052e9-05a0-4ff8-bd31-4e16f8c2c479	2026-03-12 13:50:00	2026-03-12 12:50:00	2026-03-12 14:20:00	f	\N	\N
85f353f2-5978-4ae8-9370-6e61e9066d15	d28a1e6f-8803-4e9d-ae3c-23123cf1931f	2026-04-16	13:03:00	14:24:00	FINISHED	468276b7-faa3-4027-898f-6b6931bbf908	79a6d22e-1b38-45c6-bf3b-192d373e962d	2026-04-16 13:53:00	2026-04-16 12:53:00	2026-04-16 14:24:00	f	\N	\N
53962c33-5de6-42e5-a879-40566d973a3b	d28a1e6f-8803-4e9d-ae3c-23123cf1931f	2026-04-23	13:05:00	14:26:00	FINISHED	468276b7-faa3-4027-898f-6b6931bbf908	f7ad57bf-d39d-433d-81d5-aee8a40565db	2026-04-23 13:55:00	2026-04-23 12:55:00	2026-04-23 14:26:00	f	\N	\N
97f0dd3a-166e-4fde-a512-4f22996bb25d	d28a1e6f-8803-4e9d-ae3c-23123cf1931f	2026-03-05	13:01:00	14:26:00	FINISHED	468276b7-faa3-4027-898f-6b6931bbf908	cdb53d83-83b2-42d7-aead-2e72c34cc9dc	2026-03-05 13:51:00	2026-03-05 12:51:00	2026-03-05 14:26:00	f	\N	\N
4fb55d8f-137f-44d9-8516-98052a13f58e	c04e0158-0e80-4cc8-85c5-c7ff1a00225b	2026-04-09	14:49:00	16:13:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	4e3606ae-26a2-4429-bf81-78d1fdcd7875	2026-04-09 15:39:00	2026-04-09 14:39:00	2026-04-09 16:13:00	f	\N	\N
900c24d3-4ceb-45a5-8c68-02db78e77ecf	c04e0158-0e80-4cc8-85c5-c7ff1a00225b	2026-05-14	14:54:00	16:11:00	CANCELED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	18777c15-97e5-47e1-b35c-22e81b6e8b7e	2026-05-14 15:44:00	2026-05-14 14:44:00	2026-05-14 16:11:00	f	\N	\N
cf90e009-f83c-4602-8e3f-8ca0f58c6a85	c04e0158-0e80-4cc8-85c5-c7ff1a00225b	2026-04-30	14:45:00	16:14:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	441ecf65-fa15-4aed-ab82-75eb7ff6fa8e	2026-04-30 15:35:00	2026-04-30 14:35:00	2026-04-30 16:14:00	f	\N	\N
6840952a-7ae5-4797-9a23-c996ea8d649b	c04e0158-0e80-4cc8-85c5-c7ff1a00225b	2026-04-16	14:54:00	16:09:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	12b7b282-7f3f-48f2-83e2-5dcf3dc666a1	2026-04-16 15:44:00	2026-04-16 14:44:00	2026-04-16 16:09:00	f	\N	\N
9ed9249a-adb5-44ea-99a7-ea27e59ed093	c04e0158-0e80-4cc8-85c5-c7ff1a00225b	2026-05-21	14:50:00	16:10:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	b274f775-df93-4acc-996b-19494ed1abe2	2026-05-21 15:40:00	2026-05-21 14:40:00	2026-05-21 16:10:00	f	\N	\N
159d3c4e-1c60-4033-8875-663130d7ffc5	c04e0158-0e80-4cc8-85c5-c7ff1a00225b	2026-05-28	14:51:00	16:06:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	b629c748-b1fd-4274-ac06-fc000c87db6f	2026-05-28 15:41:00	2026-05-28 14:41:00	2026-05-28 16:06:00	f	\N	\N
d3d670bc-262f-4112-8397-2c9a87ec6db0	c04e0158-0e80-4cc8-85c5-c7ff1a00225b	2026-03-05	14:53:00	16:14:00	FINISHED	fdd78d0a-16d3-4a0b-a255-19bdab1335bb	b017ad52-6d3d-4ece-abc6-16074e1002b7	2026-03-05 15:43:00	2026-03-05 14:43:00	2026-03-05 16:14:00	f	\N	\N
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (id_student, first_name, last_name, student_card, id_course, id_user, deleted_at, editable_fields, photo_url) FROM stdin;
2fc60451-e195-4038-96f9-0fde54fe06e8	Dominga	Roca	ESTEECA14B4	6e8acf3f-bcb6-4b54-a593-04e6d30d07c0	7d5bc6ae-0d84-4f8e-9a88-8bc15e81eb52	\N	\N	\N
60312bc6-4b87-4433-b945-549246dab02c	Amílcar	Andrés	ESTE433A423	6e8acf3f-bcb6-4b54-a593-04e6d30d07c0	d26282a1-1d99-417f-83bf-46b347cb2a80	\N	\N	\N
90b6848c-4a8e-447a-a391-b4fdf2fced42	Ciro	Gil	EST7C14C0CC	6e8acf3f-bcb6-4b54-a593-04e6d30d07c0	70d28232-620a-47bb-8171-199d64922766	\N	\N	\N
f513bdc6-4405-4051-a139-a9b2c156827e	Joan	Vazquez	EST090BD530	d603f622-e1be-4093-9e1e-a1208a3e1831	a376d4eb-0f81-4c7b-84fc-a2d7e35758f8	\N	\N	\N
78f3e5e9-1a20-4230-a0f1-8d6708510733	Eligia	Amor	EST9BEC81EC	d603f622-e1be-4093-9e1e-a1208a3e1831	6a281cc4-def7-4be5-9c9e-7763422ca52e	\N	\N	\N
4bf30010-daaf-4197-9cce-c792742fabdd	Chelo	Flor	EST07813A86	d603f622-e1be-4093-9e1e-a1208a3e1831	644e0302-6537-41ed-88c8-89819e385b46	\N	\N	\N
1e430cd0-f63d-4b2c-95a7-62fe9b907abe	Lilia	Rivas	EST6E97FEC7	8c5ff310-7cf5-40ca-adb2-e705628d251f	e4d82904-229f-46b1-b670-cc13cf5f919b	\N	\N	\N
2b6abd12-6a83-4789-bf54-d577970897a1	Isidro	Sanchez	EST92641AF6	8c5ff310-7cf5-40ca-adb2-e705628d251f	5a6f4435-7cbf-4269-b130-6fccce3c3385	\N	\N	\N
50f12ab6-0e1e-4c2b-9370-2edc30c3f51b	Dolores	Lobo	EST64032A9E	8c5ff310-7cf5-40ca-adb2-e705628d251f	4bb89e87-7197-4db8-8c94-294ec716ad10	\N	\N	\N
af583bcf-eeaa-451d-988d-987d293cb523	Nydia	Agudo	ESTF9FD015B	8483d94d-4edd-476d-9b8a-9c28e9310657	856117f6-3afc-46eb-840f-9e2fd5bc04c6	\N	\N	\N
f63c1fcf-9552-474d-836b-b77bfdcae1ce	Martina	Cuervo	ESTB8150061	8483d94d-4edd-476d-9b8a-9c28e9310657	c939487a-d91f-43c6-bbb5-d4c12168e701	\N	\N	\N
d88bf4a1-0278-4023-a674-0faa04857eb6	José	Rocamora	ESTDBCF7D28	8483d94d-4edd-476d-9b8a-9c28e9310657	af92e2bd-cd0c-4660-a8fd-5167f3e1a5ae	\N	\N	\N
af1756ba-1982-4621-9340-1528c61ce0e2	Noé	Lobo	ESTA35109BB	a82ac075-2f05-477e-b393-94b33403a8a0	2acd04d5-4562-41a1-a91b-b4f0daae7c2a	\N	\N	\N
f22a26c5-d7e0-4edd-b2eb-ccd9a8f01e34	Fabricio	Garrido	EST016BAE49	a82ac075-2f05-477e-b393-94b33403a8a0	022e87ea-c04a-4948-8a27-1b1c0e6be951	\N	\N	\N
1a34ac02-47c9-463a-9454-fcff07b08dd7	María Carmen	Navarro	EST993691EC	dce66adc-2126-41ca-b347-f70abc337bc3	c97acd53-8156-4ab9-9821-d2d31c45c68f	\N	\N	\N
1f56c43e-b4d2-4901-af59-d5142d0aa2e5	Cristian	Bru	EST5B464EE4	dce66adc-2126-41ca-b347-f70abc337bc3	91038a64-825b-425d-a8db-c89ecfe78162	\N	\N	\N
634e1ef3-b7dd-45b9-82d3-f259314d39ac	Ricardo	Caballero	ESTB1443997	1c8b3db4-2850-448a-989c-6d293f4989ce	5e02de62-caaf-41c1-96c6-6d944d7ef0a0	\N	\N	\N
c430bb4e-5b38-4b76-afe3-8f53bf7daeda	Plinio	Núñez	EST84088B29	1c8b3db4-2850-448a-989c-6d293f4989ce	34ee925d-bc71-46aa-ac6e-ef8e958c1647	\N	\N	\N
0eb13f5a-6e6b-4eae-b58d-c679b6d08703	Elisabet	Lamas	ESTF3643553	1c8b3db4-2850-448a-989c-6d293f4989ce	ab992a2b-7510-4e67-9644-9f803e5a64f2	\N	\N	\N
38627842-6a22-4667-9f01-4c99af03904b	Noemí	Aroca	ESTB2C31521	9df01df7-2683-412d-99ea-49f704095fc4	a67ac4d1-d994-4825-854f-309add92dba4	\N	\N	\N
171c242e-3656-44e0-a314-b7b97ab6d437	Luna	Segovia	EST828EF381	9df01df7-2683-412d-99ea-49f704095fc4	8c49fe8a-e27e-4980-b163-6b2e699e62d6	\N	\N	\N
a9cf5359-ea2e-4674-a0cd-62f1e465cde6	Brunilda	Casanovas	EST0B2098E9	9df01df7-2683-412d-99ea-49f704095fc4	5301ee6e-4eca-43cd-85d3-0a06e9d113e1	\N	\N	\N
\.


--
-- Data for Name: subjects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.subjects (id_subject, name, id_course) FROM stdin;
991e2700-cfa9-4591-b1bf-d7a3ad2769e5	Cálculo I	6e8acf3f-bcb6-4b54-a593-04e6d30d07c0
b19a0dbe-09b5-4942-9fe3-09f13de20a31	Física I	6e8acf3f-bcb6-4b54-a593-04e6d30d07c0
116af7d2-0e28-465d-ac58-4b1eb777653b	Álgebra Lineal	6e8acf3f-bcb6-4b54-a593-04e6d30d07c0
46aa489b-f8be-4b18-b9cb-f5ad7621637f	Geometría Analítica	6e8acf3f-bcb6-4b54-a593-04e6d30d07c0
283a480e-41f4-488f-8a05-7e8200cf5605	Resistencia de Materiales	6e8acf3f-bcb6-4b54-a593-04e6d30d07c0
351237e6-5bdc-42a1-a373-b29c185b592c	Programación I	d603f622-e1be-4093-9e1e-a1208a3e1831
f766c156-8964-4d92-af2e-88c5560ed655	Base de Datos I	d603f622-e1be-4093-9e1e-a1208a3e1831
88618baf-2855-4435-bf2f-aaed75455b9c	Redes I	d603f622-e1be-4093-9e1e-a1208a3e1831
5fd51faa-793f-49e1-bccf-b3cdb50ba378	Sistemas Operativos	d603f622-e1be-4093-9e1e-a1208a3e1831
2106fa76-8687-4a16-9951-d4709fccbf31	Ingeniería de Software	d603f622-e1be-4093-9e1e-a1208a3e1831
c6b3b67f-d4eb-488f-99b4-8d0c6172f39e	Termodinámica	8c5ff310-7cf5-40ca-adb2-e705628d251f
697c1a17-4ade-4682-8268-f5257b5773d6	Investigación Operativa	8c5ff310-7cf5-40ca-adb2-e705628d251f
d92e3f87-8c1e-42f9-924b-55975db369cc	Gestión de Calidad	8c5ff310-7cf5-40ca-adb2-e705628d251f
6a3557af-f475-4411-be03-c149a6abfca7	Dibujo Arquitectónico	8483d94d-4edd-476d-9b8a-9c28e9310657
2800cf4d-0438-405e-8c36-535eba33b3a1	Historia de la Arquitectura	8483d94d-4edd-476d-9b8a-9c28e9310657
ddb06fe1-04a6-4505-8dfa-2ee72911e75d	Estructuras I	8483d94d-4edd-476d-9b8a-9c28e9310657
2ac87119-b13c-4e5c-8e43-830c70faeacb	Contabilidad General	a82ac075-2f05-477e-b393-94b33403a8a0
d7895b15-6326-4894-a5d8-059bb96c9af5	Marketing	a82ac075-2f05-477e-b393-94b33403a8a0
96464e5f-74da-48d3-a587-33d86c088e0c	Recursos Humanos	a82ac075-2f05-477e-b393-94b33403a8a0
2d07416c-b641-4d1d-bfc9-49b990c4f07a	Introducción al Derecho	dce66adc-2126-41ca-b347-f70abc337bc3
28e73204-3d9c-4cf2-b3cf-c43496c8f3ce	Derecho Penal	dce66adc-2126-41ca-b347-f70abc337bc3
338c229f-9ac1-4841-95ae-9f64ee47fd02	Derecho Civil	dce66adc-2126-41ca-b347-f70abc337bc3
2c7fc36b-04ce-4e27-b92c-91b49557fa96	Anatomía Humana	1c8b3db4-2850-448a-989c-6d293f4989ce
33c827c9-fe38-49b7-89ab-5362c24a30df	Fisiología	1c8b3db4-2850-448a-989c-6d293f4989ce
f4dadd68-f6dc-4a7d-951d-9000de59059d	Bioquímica	1c8b3db4-2850-448a-989c-6d293f4989ce
d2926248-5b03-4868-98ce-aa1cc15154b7	Dibujo Artístico	9df01df7-2683-412d-99ea-49f704095fc4
ade7ac2c-78ec-49a2-b29f-78626c1114ef	Tipografía	9df01df7-2683-412d-99ea-49f704095fc4
b8e254b3-ff52-43ad-b316-d8969837d30b	Diseño Digital	9df01df7-2683-412d-99ea-49f704095fc4
\.


--
-- Data for Name: teacher_flags; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teacher_flags (id_flag, id_teacher, reason, level, status, creation_date, session_id) FROM stdin;
2309bef0-a1d5-4262-9a01-a5f2375511ca	3cd3e8a4-f163-4265-b39d-31f2a1592570	Retrasos frecuentes	MEDIUM	ACTIVE	2026-06-06 22:00:27.698026	\N
6b97a543-3741-4d08-8598-1eb1e9c62ed5	a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	Retrasos frecuentes	LOW	CLOSED	2026-06-06 22:00:27.698043	\N
8a984045-59b4-4082-a7eb-c4b961e20c72	81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	Ausencias repetitivas	MEDIUM	CLOSED	2026-06-06 22:00:27.698045	\N
ed68cc12-64f9-4571-8a1c-3e6150093cc0	faf73658-e40a-4abe-9d93-3ec6e7da1040	Retrasos frecuentes	LOW	CLOSED	2026-06-06 22:00:27.698047	\N
1d01b00e-195e-4d48-b3c1-6d1911cbf59e	d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	Reporte de estudiantes	MEDIUM	CLOSED	2026-06-06 22:00:27.698048	\N
\.


--
-- Data for Name: teachers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.teachers (id_teacher, first_name, last_name, teacher_card, id_user, modifications_count, teacher_flag, must_change_password, deleted_at, photo_url) FROM stdin;
3cd3e8a4-f163-4265-b39d-31f2a1592570	María	González	DOC23EA8CB1	2d27efa2-b48d-4046-b73f-753b92090322	0	f	f	\N	\N
ce0bb1c1-525d-4e7c-80ec-1584fcfb2e34	José	Rodríguez	DOCE483E398	8a09b67e-018f-44e4-a051-2a170f2896a0	0	f	f	\N	\N
a43491d5-2e6d-4fd1-9ccd-c6926b5bc6c5	Carlos	López	DOC7EFF9A5A	c0abfa17-3328-4835-b6bf-87dfab8f3a0b	0	f	f	\N	\N
81ae79d2-ddca-4ea8-9d35-a1c90891e6f1	Feliciana	Cantón	DOCBCCC1287	694f59e0-214e-470d-a465-65e5157362e1	0	f	f	\N	\N
dd793121-b7f3-4a66-a517-42c10fcc06a5	Amador	Llopis	DOCE6A36918	6b6ed334-e026-4f44-bd09-96fd69124a70	0	f	f	\N	\N
36b54513-3d1e-48de-ab5d-d4bcab8e64e3	Jose Ignacio	Godoy	DOC8D19395D	75251412-a6b3-4a8a-89be-3fe9d079b318	0	f	f	\N	\N
faf73658-e40a-4abe-9d93-3ec6e7da1040	Emilio	Calatayud	DOC60861634	54c7c027-e903-47a7-94f1-133e21c5a055	0	f	f	\N	\N
d4e3bd62-f114-48a1-b87f-dd5b68eb54c9	Inmaculada	Bonet	DOCDF24290A	8b0db459-0253-4d9b-9004-709c3c1c62d2	0	f	f	\N	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id_user, email, password_hash, role, must_change_password, created_at, deleted_at) FROM stdin;
39a98ba3-5bba-4045-8c68-46797f6b7897	admin@catsivard.edu	$2b$12$6DXwaKWKA63goUYJYmG9mePOuZsunCWlzZZJqAWdQaD2261Vui9Du	ADMIN	f	2026-06-06 22:00:14.421459	\N
2d27efa2-b48d-4046-b73f-753b92090322	maria@catsivard.edu	$2b$12$YCSYt6TN//H5rPYQYTzY6u6OMKHaHjtU12kHPI2BsR87wi30N7U0q	TEACHER	f	2026-06-06 22:00:17.14642	\N
8a09b67e-018f-44e4-a051-2a170f2896a0	jose@catsivard.edu	$2b$12$YCSYt6TN//H5rPYQYTzY6u6OMKHaHjtU12kHPI2BsR87wi30N7U0q	TEACHER	f	2026-06-06 22:00:17.146433	\N
c0abfa17-3328-4835-b6bf-87dfab8f3a0b	carlos@catsivard.edu	$2b$12$YCSYt6TN//H5rPYQYTzY6u6OMKHaHjtU12kHPI2BsR87wi30N7U0q	TEACHER	f	2026-06-06 22:00:17.146434	\N
694f59e0-214e-470d-a465-65e5157362e1	feliciana@catsivard.edu	$2b$12$sXrLS5KIgd5RnNOLPrhb1.W1X1vwxem.0cINXvPf2m8BgNVVA895O	TEACHER	f	2026-06-06 22:00:17.146436	\N
6b6ed334-e026-4f44-bd09-96fd69124a70	amador@catsivard.edu	$2b$12$HOzUutorT8DIqilSvOpXt.RMnSJmWFiUsn8HQnKyihwplaDFlkggm	TEACHER	f	2026-06-06 22:00:17.146438	\N
75251412-a6b3-4a8a-89be-3fe9d079b318	jose2@catsivard.edu	$2b$12$i40/0Dpp6wXMww86Scir6OLCA8qyVBZaCFnpZw8UW8Z8UGsDhxqMy	TEACHER	f	2026-06-06 22:00:17.146439	\N
54c7c027-e903-47a7-94f1-133e21c5a055	emilio@catsivard.edu	$2b$12$fODO26JmTFNlgoFme.B9sOOnafTyQkiT1kld.OJ.12PqCv/UsV8k6	TEACHER	f	2026-06-06 22:00:17.146441	\N
8b0db459-0253-4d9b-9004-709c3c1c62d2	inmaculada@catsivard.edu	$2b$12$vwwlOrgcvF0rBQou3GRUlOmdJRjJJ4RR98Qtwn/z/vnILToM4w4KW	TEACHER	f	2026-06-06 22:00:17.146442	\N
7d5bc6ae-0d84-4f8e-9a88-8bc15e81eb52	dominga@catsivard.edu	$2b$12$fwdBT0D4kt3IY0QIMIFGau0A0ow9nBNnLRYtDAY/Flarwh5RxeCua	STUDENT	f	2026-06-06 22:00:27.450517	\N
d26282a1-1d99-417f-83bf-46b347cb2a80	amilcar@catsivard.edu	$2b$12$fwdBT0D4kt3IY0QIMIFGau0A0ow9nBNnLRYtDAY/Flarwh5RxeCua	STUDENT	f	2026-06-06 22:00:27.450528	\N
70d28232-620a-47bb-8171-199d64922766	ciro@catsivard.edu	$2b$12$fwdBT0D4kt3IY0QIMIFGau0A0ow9nBNnLRYtDAY/Flarwh5RxeCua	STUDENT	f	2026-06-06 22:00:27.45053	\N
a376d4eb-0f81-4c7b-84fc-a2d7e35758f8	joan@catsivard.edu	$2b$12$5Oww.KOnfHtR/buZ0MkDr.YEKuUlREuXqh.ylM5ERGvaTh0BPLvdG	STUDENT	f	2026-06-06 22:00:27.450532	\N
6a281cc4-def7-4be5-9c9e-7763422ca52e	eligia@catsivard.edu	$2b$12$A1reqplOLktUEXp49ihrmuGBd8iweO9IcmDbSwXnainzsyN7JljGW	STUDENT	f	2026-06-06 22:00:27.450533	\N
644e0302-6537-41ed-88c8-89819e385b46	chelo@catsivard.edu	$2b$12$wg.OVpgwM70KgeX15X.sGe5Qf0dDNrUl0EkRYXEh5Nqr0PjCq86ee	STUDENT	f	2026-06-06 22:00:27.450535	\N
e4d82904-229f-46b1-b670-cc13cf5f919b	lilia@catsivard.edu	$2b$12$2y/j5lg8Vfguu3QDsHEOVOPoWQePtO0SG.2PIFYZDnBImqER8a5EO	STUDENT	f	2026-06-06 22:00:27.450536	\N
5a6f4435-7cbf-4269-b130-6fccce3c3385	isidro@catsivard.edu	$2b$12$VWgCJsV3UVxm72VDRSuGJuGTJN2cpL.ojtaJWyokQDBU7zg7C/MYC	STUDENT	f	2026-06-06 22:00:27.450537	\N
4bb89e87-7197-4db8-8c94-294ec716ad10	dolores@catsivard.edu	$2b$12$clD0UWH7pUq5D5K.IYucU.OthY6mJ113VBKO8tc6eX1XcK9b/0LC6	STUDENT	f	2026-06-06 22:00:27.450539	\N
856117f6-3afc-46eb-840f-9e2fd5bc04c6	nydia@catsivard.edu	$2b$12$67fNTRoc0LC/M.yyy0151.DGUdirqAkVXt9btfj8Agjk9ZVMli1qS	STUDENT	f	2026-06-06 22:00:27.45054	\N
c939487a-d91f-43c6-bbb5-d4c12168e701	martina@catsivard.edu	$2b$12$nz5h7tppYwgYhPTEP1ccL.kulPtDhyMJ53PKovjdPlSbAwui.5cCu	STUDENT	f	2026-06-06 22:00:27.450541	\N
af92e2bd-cd0c-4660-a8fd-5167f3e1a5ae	jose3@catsivard.edu	$2b$12$WirCxJb4hlPnTGdqGdss.OtfAwhD1lFRs37Xj4nAceN8mn7Ix/vhi	STUDENT	f	2026-06-06 22:00:27.450543	\N
2acd04d5-4562-41a1-a91b-b4f0daae7c2a	noe@catsivard.edu	$2b$12$hk959ZIs2hzXa45MPHnoDuKftBiQMjpHs4lXU8/Qb7.ntWeIGYHY2	STUDENT	f	2026-06-06 22:00:27.450544	\N
022e87ea-c04a-4948-8a27-1b1c0e6be951	fabricio@catsivard.edu	$2b$12$bsBR1McHFJIsjXdVre6tMuq/WZ9tEM4YZoBvac/TDADjvO3jEi7mm	STUDENT	f	2026-06-06 22:00:27.450546	\N
c97acd53-8156-4ab9-9821-d2d31c45c68f	maria2@catsivard.edu	$2b$12$D1Fjcz9GGBmkmeMkU2bCPOoeEAE35dn/bzGDLuI6vOBVBBUFCSM1m	STUDENT	f	2026-06-06 22:00:27.450547	\N
91038a64-825b-425d-a8db-c89ecfe78162	cristian@catsivard.edu	$2b$12$BAkQTaPAtCilIlJZEX./XOWXM5Per/bEArfhhMSOTPET8/OHeeQa.	STUDENT	f	2026-06-06 22:00:27.450548	\N
5e02de62-caaf-41c1-96c6-6d944d7ef0a0	ricardo@catsivard.edu	$2b$12$dzJpGzVrOS6dU.jnmOVcHe0ee/dpNlJPrgIzZ1WU1b558GtTVcpKW	STUDENT	f	2026-06-06 22:00:27.45055	\N
34ee925d-bc71-46aa-ac6e-ef8e958c1647	plinio@catsivard.edu	$2b$12$c/g4T3przGtvWWD1i4TUzuWLJKqS/l.euz8ALs3URCH8ZQnRgqXnm	STUDENT	f	2026-06-06 22:00:27.450551	\N
ab992a2b-7510-4e67-9644-9f803e5a64f2	elisabet@catsivard.edu	$2b$12$7WfFoi/VoiNqAD.ladJLa.feHpd50j34Wla0jHoOjxBMvAjz3DOiC	STUDENT	f	2026-06-06 22:00:27.450553	\N
a67ac4d1-d994-4825-854f-309add92dba4	noemi@catsivard.edu	$2b$12$GOAfkvK.n1p4LfH5sqh6Q.s/s1qrh8vLlqc/2nNjBTadRBJhHtage	STUDENT	f	2026-06-06 22:00:27.450554	\N
8c49fe8a-e27e-4980-b163-6b2e699e62d6	luna@catsivard.edu	$2b$12$mrqisr40BLcFkSjXlITfcehoq5zzakNu6qOfcaCs.7/P5uzpkgjCC	STUDENT	f	2026-06-06 22:00:27.450555	\N
5301ee6e-4eca-43cd-85d3-0a06e9d113e1	brunilda@catsivard.edu	$2b$12$HSmxj6139zSuu0iu5w9AjOOnBxG5VY6Hxx8pQBB1/UyQ4dCUEKJCq	STUDENT	f	2026-06-06 22:00:27.450557	\N
\.


--
-- Name: attendance_event attendance_event_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_event
    ADD CONSTRAINT attendance_event_pkey PRIMARY KEY (id_event);


--
-- Name: attendance attendance_id_session_id_student_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_id_session_id_student_key UNIQUE (id_session, id_student);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id_attendance);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id_class);


--
-- Name: classrooms classrooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classrooms
    ADD CONSTRAINT classrooms_pkey PRIMARY KEY (id_classroom);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id_course);


--
-- Name: enrollments enrollments_id_student_id_class_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_id_student_id_class_key UNIQUE (id_student, id_class);


--
-- Name: enrollments enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_pkey PRIMARY KEY (id_enrollment);


--
-- Name: groups_ groups__pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups_
    ADD CONSTRAINT groups__pkey PRIMARY KEY (id_group);


--
-- Name: justification_attachment justification_attachment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.justification_attachment
    ADD CONSTRAINT justification_attachment_pkey PRIMARY KEY (id_attachment);


--
-- Name: knowledge_area knowledge_area_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.knowledge_area
    ADD CONSTRAINT knowledge_area_pkey PRIMARY KEY (id_area);


--
-- Name: periods periods_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periods
    ADD CONSTRAINT periods_pkey PRIMARY KEY (id_period);


--
-- Name: periods periods_year_cycle_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.periods
    ADD CONSTRAINT periods_year_cycle_key UNIQUE (year, cycle);


--
-- Name: schedule schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pkey PRIMARY KEY (id_schedule);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id_session);


--
-- Name: sessions sessions_qr_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_qr_token_key UNIQUE (qr_token);


--
-- Name: students students_id_user_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_id_user_key UNIQUE (id_user);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id_student);


--
-- Name: students students_student_card_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_student_card_key UNIQUE (student_card);


--
-- Name: subjects subjects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_pkey PRIMARY KEY (id_subject);


--
-- Name: teacher_flags teacher_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_flags
    ADD CONSTRAINT teacher_flags_pkey PRIMARY KEY (id_flag);


--
-- Name: teachers teachers_id_user_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_id_user_key UNIQUE (id_user);


--
-- Name: teachers teachers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_pkey PRIMARY KEY (id_teacher);


--
-- Name: teachers teachers_teacher_card_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_teacher_card_key UNIQUE (teacher_card);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id_user);


--
-- Name: attendance_event attendance_event_id_actor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_event
    ADD CONSTRAINT attendance_event_id_actor_fkey FOREIGN KEY (id_actor) REFERENCES public.teachers(id_teacher);


--
-- Name: attendance_event attendance_event_id_attendance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_event
    ADD CONSTRAINT attendance_event_id_attendance_fkey FOREIGN KEY (id_attendance) REFERENCES public.attendance(id_attendance);


--
-- Name: attendance attendance_id_session_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_id_session_fkey FOREIGN KEY (id_session) REFERENCES public.sessions(id_session);


--
-- Name: attendance attendance_id_student_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_id_student_fkey FOREIGN KEY (id_student) REFERENCES public.students(id_student);


--
-- Name: attendance attendance_id_teacher_justifies_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_id_teacher_justifies_fkey FOREIGN KEY (id_teacher_justifies) REFERENCES public.teachers(id_teacher);


--
-- Name: classes classes_id_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_id_group_fkey FOREIGN KEY (id_group) REFERENCES public.groups_(id_group);


--
-- Name: classes classes_id_period_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_id_period_fkey FOREIGN KEY (id_period) REFERENCES public.periods(id_period);


--
-- Name: classes classes_id_subject_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_id_subject_fkey FOREIGN KEY (id_subject) REFERENCES public.subjects(id_subject);


--
-- Name: classes classes_id_teacher_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_id_teacher_fkey FOREIGN KEY (id_teacher) REFERENCES public.teachers(id_teacher);


--
-- Name: courses courses_id_area_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_id_area_fkey FOREIGN KEY (id_area) REFERENCES public.knowledge_area(id_area);


--
-- Name: enrollments enrollments_id_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_id_class_fkey FOREIGN KEY (id_class) REFERENCES public.classes(id_class);


--
-- Name: enrollments enrollments_id_student_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_id_student_fkey FOREIGN KEY (id_student) REFERENCES public.students(id_student);


--
-- Name: justification_attachment justification_attachment_id_attendance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.justification_attachment
    ADD CONSTRAINT justification_attachment_id_attendance_fkey FOREIGN KEY (id_attendance) REFERENCES public.attendance(id_attendance);


--
-- Name: schedule schedule_id_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_id_class_fkey FOREIGN KEY (id_class) REFERENCES public.classes(id_class);


--
-- Name: schedule schedule_id_classroom_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_id_classroom_fkey FOREIGN KEY (id_classroom) REFERENCES public.classrooms(id_classroom);


--
-- Name: sessions sessions_id_class_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_id_class_fkey FOREIGN KEY (id_class) REFERENCES public.classes(id_class);


--
-- Name: sessions sessions_id_classroom_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_id_classroom_fkey FOREIGN KEY (id_classroom) REFERENCES public.classrooms(id_classroom);


--
-- Name: students students_id_course_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_id_course_fkey FOREIGN KEY (id_course) REFERENCES public.courses(id_course);


--
-- Name: students students_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user);


--
-- Name: subjects subjects_id_course_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subjects
    ADD CONSTRAINT subjects_id_course_fkey FOREIGN KEY (id_course) REFERENCES public.courses(id_course);


--
-- Name: teacher_flags teacher_flags_id_teacher_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_flags
    ADD CONSTRAINT teacher_flags_id_teacher_fkey FOREIGN KEY (id_teacher) REFERENCES public.teachers(id_teacher);


--
-- Name: teacher_flags teacher_flags_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_flags
    ADD CONSTRAINT teacher_flags_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id_session);


--
-- Name: teachers teachers_id_user_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teachers
    ADD CONSTRAINT teachers_id_user_fkey FOREIGN KEY (id_user) REFERENCES public.users(id_user);


--
-- PostgreSQL database dump complete
--

\unrestrict q8r2OzMXzxmoWC0bAfCJ9dTdG1FUoKsr6FGq0aSqPkTNKPJ8JUDFd10Wyms8UwJ

