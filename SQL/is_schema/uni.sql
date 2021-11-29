--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: uni; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA uni;


ALTER SCHEMA uni OWNER TO postgres;

SET search_path = uni, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: abteilungen; Type: TABLE; Schema: uni; Owner: postgres; Tablespace: 
--

CREATE TABLE abteilungen (
    nr integer NOT NULL,
    leiter integer,
    "#Profs" integer,
    CONSTRAINT "abteilungen_#Profs_check" CHECK (("#Profs" > 0))
);


ALTER TABLE uni.abteilungen OWNER TO postgres;

--
-- Name: beteiligt; Type: TABLE; Schema: uni; Owner: postgres; Tablespace: 
--

CREATE TABLE beteiligt (
    profid integer NOT NULL,
    projektid integer NOT NULL,
    anteil numeric,
    CONSTRAINT beteiligt_anteil_check CHECK (((anteil >= (0)::numeric) AND (anteil <= (100)::numeric)))
);


ALTER TABLE uni.beteiligt OWNER TO postgres;

--
-- Name: mitarbeiter; Type: TABLE; Schema: uni; Owner: postgres; Tablespace: 
--

CREATE TABLE mitarbeiter (
    name character varying(50) NOT NULL,
    chef integer,
    gehalt integer DEFAULT 400,
    qualifikation character varying(20),
    CONSTRAINT mitarbeiter_qualifikation_check CHECK (((qualifikation)::text = ANY (ARRAY[('Bachelor'::character varying)::text, ('Master'::character varying)::text, ('Diplom'::character varying)::text, ('Doktor'::character varying)::text])))
);


ALTER TABLE uni.mitarbeiter OWNER TO postgres;

--
-- Name: professoren; Type: TABLE; Schema: uni; Owner: postgres; Tablespace: 
--

CREATE TABLE professoren (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    grad character(2),
    abteilung integer,
    gehalt numeric,
    alter integer NOT NULL,
    CONSTRAINT profalter CHECK ((alter < 120)),
    CONSTRAINT professoren_alter_check CHECK ((alter > 0)),
    CONSTRAINT professoren_gehalt_check CHECK ((gehalt > (0)::numeric)),
    CONSTRAINT professoren_grad CHECK ((grad = ANY (ARRAY['W1'::bpchar, 'W2'::bpchar, 'W3'::bpchar, 'C1'::bpchar, 'C2'::bpchar, 'C3'::bpchar, 'C4'::bpchar])))
);


ALTER TABLE uni.professoren OWNER TO postgres;

--
-- Name: projekte; Type: TABLE; Schema: uni; Owner: postgres; Tablespace: 
--

CREATE TABLE projekte (
    id integer NOT NULL,
    bezeichnung character varying(100),
    beginn timestamp without time zone NOT NULL,
    ende timestamp without time zone NOT NULL,
    volumen numeric,
    CONSTRAINT projekte_check CHECK ((ende > beginn))
);


ALTER TABLE uni.projekte OWNER TO postgres;

--
-- Name: studenten; Type: TABLE; Schema: uni; Owner: postgres; Tablespace: 
--

CREATE TABLE studenten (
    id integer NOT NULL,
    name character varying(50),
    job character varying(50),
    semester integer,
    diplomvater integer,
    vordiplom boolean
);


ALTER TABLE uni.studenten OWNER TO postgres;

--
-- Name: vorlesungen; Type: TABLE; Schema: uni; Owner: postgres; Tablespace: 
--

CREATE TABLE vorlesungen (
    id integer NOT NULL,
    titel character varying(50),
    dozent integer,
    hoerer integer,
    semester character varying(10)
);


ALTER TABLE uni.vorlesungen OWNER TO postgres;

--
-- Data for Name: abteilungen; Type: TABLE DATA; Schema: uni; Owner: postgres
--

COPY abteilungen (nr, leiter, "#Profs") FROM stdin;
1	8	5
2	4	6
3	6	2
4	12	1
\.


--
-- Data for Name: beteiligt; Type: TABLE DATA; Schema: uni; Owner: postgres
--

COPY beteiligt (profid, projektid, anteil) FROM stdin;
4	2	\N
3	2	\N
1	2	\N
1	1	\N
1	3	\N
1	4	\N
2	2	\N
5	7	\N
4	10	\N
6	10	\N
8	10	\N
9	10	\N
5	4	\N
5	6	\N
5	8	\N
5	9	\N
7	10	\N
\.


--
-- Data for Name: mitarbeiter; Type: TABLE DATA; Schema: uni; Owner: postgres
--

COPY mitarbeiter (name, chef, gehalt, qualifikation) FROM stdin;
Christian Cool	6	640	Doktor
Edward Ernst	10	1500	Bachelor
Emily Emsig	1	350	Bachelor
Florian Flink	1	400	Doktor
Frida Fröhlich	2	1300	Diplom
Gerd Galle	9	600	Doktor
Hansi Helfer	3	850	Diplom
Heike Hell	8	100	Doktor
Hugo Bürohengst	2	900	Doktor
Jack Jeopardy	1	4000	Doktor
Karl Kalle	11	980	Doktor
Kurt Krömer	6	1000	Diplom
Ludwig Locher	4	1500	Doktor
Paris Puder	1	3000	Doktor
Peter Putzig	3	750	Bachelor
Stefan Stramm	7	450	Doktor
Waltraud Werkelein	2	1100	Master
\.


--
-- Data for Name: professoren; Type: TABLE DATA; Schema: uni; Owner: postgres
--

COPY professoren (id, name, grad, abteilung, gehalt, alter) FROM stdin;
1	Magdalene Meier	W2	2	3000	30
2	Michaela Müller	W3	2	5200	35
3	Wilhelm Wusel	W3	3	6000	36
4	Dagobert Dusel	W3	2	6200	57
5	Xenia Xylophonos	W2	2	3500	28
6	Katja Kiesel	W3	3	6500	45
7	Winfried Wurst	W2	1	4000	33
8	Konstantin Korte	C3	1	8000	64
9	Waldemar Wiesel	W2	1	3000	20
10	Adelbert August	W1	1	1000	15
11	Julian Schmitz	W1	2	1100	21
12	Julian Schmitz	W3	4	5900	45
13	Michael Müller	W2	1	4000	44
14	Michael Müller	C4	2	10000	81
\.


--
-- Data for Name: projekte; Type: TABLE DATA; Schema: uni; Owner: postgres
--

COPY projekte (id, bezeichnung, beginn, ende, volumen) FROM stdin;
1	Forschungsprojekt 2378	2014-05-01 00:00:00	2018-04-30 00:00:00	1000000
2	Intelligent Data Abstraction	2014-05-01 00:00:00	2018-04-30 00:00:00	50000
3	Workshop on Sophisticated SQL Queries	2004-10-01 00:00:00	2004-10-08 00:00:00	5000
4	Workshop on Programming Techniques	2008-08-15 00:00:00	2008-08-22 00:00:00	8000
6	Research group for young IT specialists	2009-09-12 00:00:00	2009-09-22 00:00:00	7000
7	Research group for young IT specialists	2010-09-11 00:00:00	2010-09-21 00:00:00	5000
8	Research group for young IT specialists	2011-09-10 00:00:00	2011-09-20 00:00:00	4000
9	Research group for young IT specialists	2012-09-09 00:00:00	2012-09-19 00:00:00	15000
10	Mice Databases	2013-01-08 00:00:00	2018-12-31 00:00:00	90000
\.


--
-- Data for Name: studenten; Type: TABLE DATA; Schema: uni; Owner: postgres
--

COPY studenten (id, name, job, semester, diplomvater, vordiplom) FROM stdin;
1	August August	\N	15	13	t
2	Betram Bulle	\N	12	13	t
3	Celine Chrysis	\N	10	13	t
4	Dorothee Dösel	\N	24	14	f
5	Elenore Esselwang	\N	10	14	\N
6	Florian Finke	\N	5	2	f
7	Gisela Gaukelei	\N	15	11	\N
8	Hasso Habenichts	\N	14	14	\N
9	Ingeborg Igel	\N	1	\N	\N
10	Jakob Jockel	\N	3	\N	\N
11	Klaus Kleber	\N	37	14	t
12	Zacharias Ziegenpeter	\N	17	14	\N
13	Xerxes Xi	\N	15	13	\N
14	Odysseus Ochsenknecht	\N	15	13	\N
\.


--
-- Data for Name: vorlesungen; Type: TABLE DATA; Schema: uni; Owner: postgres
--

COPY vorlesungen (id, titel, dozent, hoerer, semester) FROM stdin;
3	DB I	13	155	\N
4	DB II	13	154	\N
5	DB III	13	49	\N
6	IP I	14	10	\N
7	IP II	14	5	\N
8	IP III	14	1	\N
9	Rhetorics in Information Design	4	52	\N
1	IS	1	250	WS2014/15
2	TI	1	250	WS2014/15
11	IS	1	220	WS2013/14
12	TI	1	220	WS2013/14
21	IS	1	180	WS2012/13
22	TI	1	180	WS2012/13
31	IS	1	80	WS2010/11
32	TI	1	80	WS2010/11
\.


--
-- Name: abteilungen_pkey; Type: CONSTRAINT; Schema: uni; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY abteilungen
    ADD CONSTRAINT abteilungen_pkey PRIMARY KEY (nr);


--
-- Name: beteiligt_pkey; Type: CONSTRAINT; Schema: uni; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY beteiligt
    ADD CONSTRAINT beteiligt_pkey PRIMARY KEY (profid, projektid);


--
-- Name: mitarbeiter_pkey; Type: CONSTRAINT; Schema: uni; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY mitarbeiter
    ADD CONSTRAINT mitarbeiter_pkey PRIMARY KEY (name);


--
-- Name: pk_id; Type: CONSTRAINT; Schema: uni; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY studenten
    ADD CONSTRAINT pk_id PRIMARY KEY (id);


--
-- Name: professoren_pkey; Type: CONSTRAINT; Schema: uni; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY professoren
    ADD CONSTRAINT professoren_pkey PRIMARY KEY (id);


--
-- Name: projekte_pkey; Type: CONSTRAINT; Schema: uni; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY projekte
    ADD CONSTRAINT projekte_pkey PRIMARY KEY (id);


--
-- Name: vorlesungen_pkey; Type: CONSTRAINT; Schema: uni; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vorlesungen
    ADD CONSTRAINT vorlesungen_pkey PRIMARY KEY (id);


--
-- Name: uni; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA uni FROM PUBLIC;
REVOKE ALL ON SCHEMA uni FROM postgres;
GRANT ALL ON SCHEMA uni TO postgres;


--
-- Name: abteilungen; Type: ACL; Schema: uni; Owner: postgres
--

REVOKE ALL ON TABLE abteilungen FROM PUBLIC;
REVOKE ALL ON TABLE abteilungen FROM postgres;
GRANT ALL ON TABLE abteilungen TO postgres;


--
-- Name: beteiligt; Type: ACL; Schema: uni; Owner: postgres
--

REVOKE ALL ON TABLE beteiligt FROM PUBLIC;
REVOKE ALL ON TABLE beteiligt FROM postgres;
GRANT ALL ON TABLE beteiligt TO postgres;


--
-- Name: mitarbeiter; Type: ACL; Schema: uni; Owner: postgres
--

REVOKE ALL ON TABLE mitarbeiter FROM PUBLIC;
REVOKE ALL ON TABLE mitarbeiter FROM postgres;
GRANT ALL ON TABLE mitarbeiter TO postgres;


--
-- Name: professoren; Type: ACL; Schema: uni; Owner: postgres
--

REVOKE ALL ON TABLE professoren FROM PUBLIC;
REVOKE ALL ON TABLE professoren FROM postgres;
GRANT ALL ON TABLE professoren TO postgres;


--
-- Name: projekte; Type: ACL; Schema: uni; Owner: postgres
--

REVOKE ALL ON TABLE projekte FROM PUBLIC;
REVOKE ALL ON TABLE projekte FROM postgres;
GRANT ALL ON TABLE projekte TO postgres;


--
-- Name: studenten; Type: ACL; Schema: uni; Owner: postgres
--

REVOKE ALL ON TABLE studenten FROM PUBLIC;
REVOKE ALL ON TABLE studenten FROM postgres;
GRANT ALL ON TABLE studenten TO postgres;


--
-- Name: vorlesungen; Type: ACL; Schema: uni; Owner: postgres
--

REVOKE ALL ON TABLE vorlesungen FROM PUBLIC;
REVOKE ALL ON TABLE vorlesungen FROM postgres;
GRANT ALL ON TABLE vorlesungen TO postgres;


--
-- PostgreSQL database dump complete
--

