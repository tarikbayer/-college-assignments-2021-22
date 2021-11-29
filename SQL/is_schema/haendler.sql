--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: haendler; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA haendler;


ALTER SCHEMA haendler OWNER TO postgres;

SET search_path = haendler, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: haendler; Type: TABLE; Schema: haendler; Owner: postgres; Tablespace: 
--

CREATE TABLE haendler (
    hnr integer NOT NULL,
    name character varying(20) NOT NULL,
    onr integer NOT NULL
);


ALTER TABLE haendler.haendler OWNER TO postgres;

--
-- Name: liefert; Type: TABLE; Schema: haendler; Owner: postgres; Tablespace: 
--

CREATE TABLE liefert (
    hnr integer NOT NULL,
    wnr integer NOT NULL,
    preis numeric(6,2) NOT NULL,
    lieferzeit smallint,
    CONSTRAINT liefert_lieferzeit_check CHECK ((lieferzeit >= 0))
);


ALTER TABLE haendler.liefert OWNER TO postgres;

--
-- Name: ort; Type: TABLE; Schema: haendler; Owner: postgres; Tablespace: 
--

CREATE TABLE ort (
    onr integer NOT NULL,
    ort character varying(30) NOT NULL,
    ort_plz character varying(5) NOT NULL
);


ALTER TABLE haendler.ort OWNER TO postgres;

--
-- Name: typ; Type: TABLE; Schema: haendler; Owner: postgres; Tablespace: 
--

CREATE TABLE typ (
    tnr integer NOT NULL,
    typ character varying(20) NOT NULL,
    obertyp integer
);


ALTER TABLE haendler.typ OWNER TO postgres;

--
-- Name: ware; Type: TABLE; Schema: haendler; Owner: postgres; Tablespace: 
--

CREATE TABLE ware (
    wnr integer NOT NULL,
    tnr integer DEFAULT 0 NOT NULL,
    bezeichnung character varying(20) NOT NULL
);


ALTER TABLE haendler.ware OWNER TO postgres;

--
-- Data for Name: haendler; Type: TABLE DATA; Schema: haendler; Owner: postgres
--

COPY haendler (hnr, name, onr) FROM stdin;
1	Maier	1
2	Müller	1
3	Maier	2
4	Huber	2
5	Schmidt	3
\.


--
-- Data for Name: liefert; Type: TABLE DATA; Schema: haendler; Owner: postgres
--

COPY liefert (hnr, wnr, preis, lieferzeit) FROM stdin;
1	1	200.00	1
1	2	100.00	\N
1	3	150.00	7
2	3	150.00	4
1	4	10.00	1
2	1	160.00	1
2	2	180.00	\N
3	1	160.00	4
3	2	190.00	1
4	1	150.00	3
4	3	180.00	5
4	3	199.99	1
\.


--
-- Data for Name: ort; Type: TABLE DATA; Schema: haendler; Owner: postgres
--

COPY ort (onr, ort, ort_plz) FROM stdin;
1	Königsbrunn	86343
2	Augsburg	86150
3	Hamburg	20038
\.


--
-- Data for Name: typ; Type: TABLE DATA; Schema: haendler; Owner: postgres
--

COPY typ (tnr, typ, obertyp) FROM stdin;
0	Sonstiges	\N
1	Hardware	\N
100	CPU	1
101	RAM	1
\.


--
-- Data for Name: ware; Type: TABLE DATA; Schema: haendler; Owner: postgres
--

COPY ware (wnr, tnr, bezeichnung) FROM stdin;
1	100	Pentium IV 3,8
2	100	Celeron 2,6
3	100	Athlon XP 3000+
4	0	Eieruhr
\.


--
-- Name: pk_haendler; Type: CONSTRAINT; Schema: haendler; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY haendler
    ADD CONSTRAINT pk_haendler PRIMARY KEY (hnr);


--
-- Name: pk_liefert; Type: CONSTRAINT; Schema: haendler; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY liefert
    ADD CONSTRAINT pk_liefert PRIMARY KEY (hnr, wnr, preis);


--
-- Name: pk_ort; Type: CONSTRAINT; Schema: haendler; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ort
    ADD CONSTRAINT pk_ort PRIMARY KEY (onr);


--
-- Name: pk_typ; Type: CONSTRAINT; Schema: haendler; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY typ
    ADD CONSTRAINT pk_typ PRIMARY KEY (tnr);


--
-- Name: pk_ware; Type: CONSTRAINT; Schema: haendler; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ware
    ADD CONSTRAINT pk_ware PRIMARY KEY (wnr);


--
-- Name: unique_name_address; Type: CONSTRAINT; Schema: haendler; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY haendler
    ADD CONSTRAINT unique_name_address UNIQUE (name, onr);


--
-- Name: unique_ort_ort_plz; Type: CONSTRAINT; Schema: haendler; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ort
    ADD CONSTRAINT unique_ort_ort_plz UNIQUE (ort, ort_plz);


--
-- Name: unique_typ; Type: CONSTRAINT; Schema: haendler; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY typ
    ADD CONSTRAINT unique_typ UNIQUE (typ);


--
-- Name: unique_typ_bezeichnung; Type: CONSTRAINT; Schema: haendler; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ware
    ADD CONSTRAINT unique_typ_bezeichnung UNIQUE (tnr, bezeichnung);


--
-- Name: fk_haendler_onr; Type: FK CONSTRAINT; Schema: haendler; Owner: postgres
--

ALTER TABLE ONLY haendler
    ADD CONSTRAINT fk_haendler_onr FOREIGN KEY (onr) REFERENCES ort(onr);


--
-- Name: fk_liefert_haendler; Type: FK CONSTRAINT; Schema: haendler; Owner: postgres
--

ALTER TABLE ONLY liefert
    ADD CONSTRAINT fk_liefert_haendler FOREIGN KEY (hnr) REFERENCES haendler(hnr);


--
-- Name: fk_liefert_ware; Type: FK CONSTRAINT; Schema: haendler; Owner: postgres
--

ALTER TABLE ONLY liefert
    ADD CONSTRAINT fk_liefert_ware FOREIGN KEY (wnr) REFERENCES ware(wnr);


--
-- Name: fk_typ_obertyp; Type: FK CONSTRAINT; Schema: haendler; Owner: postgres
--

ALTER TABLE ONLY typ
    ADD CONSTRAINT fk_typ_obertyp FOREIGN KEY (obertyp) REFERENCES typ(tnr);


--
-- Name: fk_typ_tnr; Type: FK CONSTRAINT; Schema: haendler; Owner: postgres
--

ALTER TABLE ONLY ware
    ADD CONSTRAINT fk_typ_tnr FOREIGN KEY (tnr) REFERENCES typ(tnr);


--
-- Name: haendler; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA haendler FROM PUBLIC;
REVOKE ALL ON SCHEMA haendler FROM postgres;
GRANT ALL ON SCHEMA haendler TO postgres;


--
-- Name: haendler; Type: ACL; Schema: haendler; Owner: postgres
--

REVOKE ALL ON TABLE haendler FROM PUBLIC;
REVOKE ALL ON TABLE haendler FROM postgres;
GRANT ALL ON TABLE haendler TO postgres;


--
-- Name: liefert; Type: ACL; Schema: haendler; Owner: postgres
--

REVOKE ALL ON TABLE liefert FROM PUBLIC;
REVOKE ALL ON TABLE liefert FROM postgres;
GRANT ALL ON TABLE liefert TO postgres;


--
-- Name: ort; Type: ACL; Schema: haendler; Owner: postgres
--

REVOKE ALL ON TABLE ort FROM PUBLIC;
REVOKE ALL ON TABLE ort FROM postgres;
GRANT ALL ON TABLE ort TO postgres;


--
-- Name: typ; Type: ACL; Schema: haendler; Owner: postgres
--

REVOKE ALL ON TABLE typ FROM PUBLIC;
REVOKE ALL ON TABLE typ FROM postgres;
GRANT ALL ON TABLE typ TO postgres;


--
-- Name: ware; Type: ACL; Schema: haendler; Owner: postgres
--

REVOKE ALL ON TABLE ware FROM PUBLIC;
REVOKE ALL ON TABLE ware FROM postgres;
GRANT ALL ON TABLE ware TO postgres;


--
-- PostgreSQL database dump complete
--

