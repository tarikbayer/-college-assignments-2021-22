--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: film; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA film;


ALTER SCHEMA film OWNER TO postgres;

--
-- Name: SCHEMA film; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA film IS 'Beispielschema für VL IS WS 10/11';


SET search_path = film, pg_catalog;

--
-- Name: film_sq; Type: SEQUENCE; Schema: film; Owner: postgres
--

CREATE SEQUENCE film_sq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE film.film_sq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: film; Type: TABLE; Schema: film; Owner: postgres; Tablespace: 
--

CREATE TABLE film (
    id integer DEFAULT nextval('film_sq'::regclass) NOT NULL,
    titel character varying(50),
    jahr integer,
    fsk integer,
    CONSTRAINT film_c CHECK (((fsk >= 0) AND (fsk <= 18)))
);


ALTER TABLE film.film OWNER TO postgres;

--
-- Name: COLUMN film.id; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN film.id IS 'ID des Films';


--
-- Name: COLUMN film.titel; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN film.titel IS 'Titel des Films';


--
-- Name: COLUMN film.jahr; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN film.jahr IS 'Produktionsjahr';


--
-- Name: COLUMN film.fsk; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN film.fsk IS 'Freigabe gemäß Freiwilliger Selbstkontrolle';


--
-- Name: kino_sq; Type: SEQUENCE; Schema: film; Owner: postgres
--

CREATE SEQUENCE kino_sq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE film.kino_sq OWNER TO postgres;

--
-- Name: kino; Type: TABLE; Schema: film; Owner: postgres; Tablespace: 
--

CREATE TABLE kino (
    id integer DEFAULT nextval('kino_sq'::regclass) NOT NULL,
    name character varying(50) NOT NULL,
    telefon character varying(20),
    adresse character varying(60)
);


ALTER TABLE film.kino OWNER TO postgres;

--
-- Name: COLUMN kino.id; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN kino.id IS 'ID des Kinos';


--
-- Name: COLUMN kino.name; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN kino.name IS 'Name des Kinos, z.B.: Metropol A';


--
-- Name: COLUMN kino.telefon; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN kino.telefon IS 'Telefonnummer für Kartenreservierung';


--
-- Name: COLUMN kino.adresse; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN kino.adresse IS 'Anschrift des Kinos';


--
-- Name: mitwirkung; Type: TABLE; Schema: film; Owner: postgres; Tablespace: 
--

CREATE TABLE mitwirkung (
    film integer NOT NULL,
    person integer NOT NULL,
    funktion character varying(20)
);


ALTER TABLE film.mitwirkung OWNER TO postgres;

--
-- Name: person_sq; Type: SEQUENCE; Schema: film; Owner: postgres
--

CREATE SEQUENCE person_sq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE film.person_sq OWNER TO postgres;

--
-- Name: person; Type: TABLE; Schema: film; Owner: postgres; Tablespace: 
--

CREATE TABLE person (
    id integer DEFAULT nextval('person_sq'::regclass) NOT NULL,
    name character varying(30),
    vorname character varying(30)
);


ALTER TABLE film.person OWNER TO postgres;

--
-- Name: COLUMN person.id; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN person.id IS 'ID der Person';


--
-- Name: COLUMN person.name; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN person.name IS 'Nachname der Person, z.B.: von Stroheim';


--
-- Name: COLUMN person.vorname; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN person.vorname IS 'Vorname(n) der Person';


--
-- Name: vorstellung; Type: TABLE; Schema: film; Owner: postgres; Tablespace: 
--

CREATE TABLE vorstellung (
    film integer NOT NULL,
    datum date NOT NULL,
    kino integer NOT NULL
);


ALTER TABLE film.vorstellung OWNER TO postgres;

--
-- Name: COLUMN vorstellung.film; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN vorstellung.film IS 'ID des Films';


--
-- Name: COLUMN vorstellung.datum; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN vorstellung.datum IS 'Datum der Vorstellung';


--
-- Name: COLUMN vorstellung.kino; Type: COMMENT; Schema: film; Owner: postgres
--

COMMENT ON COLUMN vorstellung.kino IS 'ID des Kinos';


--
-- Data for Name: film; Type: TABLE DATA; Schema: film; Owner: postgres
--

COPY film (id, titel, jahr, fsk) FROM stdin;
1	Die Bruecke am Fluss	1995	12
2	101 Dalmatiner	1961	0
3	Vernetzt - Johnny Mnemonic	1995	16
4	Waehrend Du schliefst...	1995	6
5	Casper	1995	6
6	French Kiss	1995	6
7	Stadtgespraech	1995	12
8	Apollo 13	1995	6
9	Schlafes Bruder	1995	12
10	Assassins - Die Killer	1995	16
11	Braveheart	1995	16
12	Das Netz	1995	12
13	Free Willy 2	1995	6
14	Waterworld	1995	12
15	Kleine Morde unter Freunden	1994	16
16	Smoke	1995	12
17	True Lies	1994	16
18	Kindergarten Cop	1990	6
19	Forrest Gump	1994	12
20	Batman Returns	1992	12
21	Das Russlandhaus	1990	16
22	Robin Hood: Koenig der Diebe	1991	12
23	Bullets over Broadway	1994	16
24	Radio Days	1987	16
25	Hannah und ihre Schwestern	1986	16
26	Jurassic Park	1993	12
27	Hook	1991	6
28	Indiana Jones II	1984	16
29	Indiana Jones III	1989	12
30	E.T.	1981	0
31	Forget Paris	1995	6
32	Braindead	1992	18
33	Die grosse Niete	1995	18
\.


--
-- Name: film_sq; Type: SEQUENCE SET; Schema: film; Owner: postgres
--

SELECT pg_catalog.setval('film_sq', 1, false);


--
-- Data for Name: kino; Type: TABLE DATA; Schema: film; Owner: postgres
--

COPY kino (id, name, telefon, adresse) FROM stdin;
1	Gangolf-Lichtspiele	0228 / 63 81 81	Gangolfstr. 2-4, Bonn
2	Universum-Lichtspiele	0228 / 65 30 55	Bertha-von-Suttner-Platz 1-7, Bonn
3	Metropol-Filmtheater	0228 / 69 59 95	Markt 24, Bonn
4	Metropol	0228 / 69 59 79	Markt 24, Bonn
5	Hansa-Theater	0228 / 65 17 50	Kaiserplatz 18, Bonn
6	Stern	0228 / 63 52 66	Markt 8, Bonn
7	Sternchen	0228 / 63 52 66	Markt 8, Bonn
8	Comet	0228 / 63 52 66	Markt 8, Bonn
9	Filmstudio	0228 / 65 40 00	Markt 10, Bonn
10	Kinemathek	0228 / 47 84 89	Kreuzstr. 16, Bonn-Beuel
11	Atlantis	0228 / 69 21 21	Kesselgasse 1, Bonn
12	Rex-Theater	0228 / 62 23 30	Bonn-Endenich
13	Neue Filmbuehne Beuel	0228 / 46 97 90	Friedrich-Breuer-Strasse, Bonn
14	Capitol	0221 / 51 88 22	Hohenzollernring 79, Koeln
15	Cinedom	0221 / 95 19 51 95	Mediapark, Koeln
16	Filmhaus Schildergasse	0221 / 2 58 01 22	Schildergasse, Koeln
17	Odeon	0221 / 31 31 10	Severinsstrasse 81, Koeln
18	Rex-Cine-Center	0221 / 25 41 41	Hohenzollernring, Koeln
19	UFA-Palast-Kino-Center	0221 / 25 62 88	Hohenzollernring, Koeln
20	UFA-Scala	0221 / 25 42 24	Hohenzollernring 48, Koeln
\.


--
-- Name: kino_sq; Type: SEQUENCE SET; Schema: film; Owner: postgres
--

SELECT pg_catalog.setval('kino_sq', 1, false);


--
-- Data for Name: mitwirkung; Type: TABLE DATA; Schema: film; Owner: postgres
--

COPY mitwirkung (film, person, funktion) FROM stdin;
1	1	Regisseur
1	1	Schauspieler
1	2	Schauspielerin
2	3	Regisseur
3	4	Regisseur
3	5	Schauspieler
3	6	Schauspieler
4	7	Schauspielerin
4	8	Schauspieler
5	1	Schauspieler
5	8	Schauspieler
5	14	Schauspieler
6	9	Schauspieler
7	10	Schauspielerin
7	11	Schauspieler
8	12	Schauspieler
10	13	Schauspieler
11	14	Regisseur
11	14	Schauspieler
11	15	Schauspielerin
12	7	Schauspielerin
12	16	Regisseur
14	17	Schauspieler
16	20	Regisseur
16	21	Schauspieler
17	22	Schauspieler
17	24	Schauspielerin
18	22	Schauspieler
19	12	Schauspieler
20	23	Schauspielerin
20	26	Regisseur
21	23	Schauspielerin
21	27	Regisseur
21	28	Schauspieler
22	28	Schauspieler
22	17	Schauspieler
23	29	Regisseur
23	30	Schauspieler
24	29	Regisseur
24	31	Schauspielerin
25	29	Regisseur
25	29	Schauspieler
25	31	Schauspielerin
26	32	Regisseur
27	32	Regisseur
28	32	Regisseur
28	33	Schauspieler
29	32	Regisseur
29	33	Schauspieler
29	28	Schauspieler
30	32	Regisseur
30	19	Stimme von E.T.
31	18	Schauspieler
31	19	Schauspielerin
1	1	Regisseur
1	1	Schauspieler
1	2	Schauspielerin
2	3	Regisseur
3	4	Regisseur
3	5	Schauspieler
3	6	Schauspieler
4	7	Schauspielerin
4	8	Schauspieler
5	1	Schauspieler
5	8	Schauspieler
5	14	Schauspieler
6	9	Schauspieler
7	10	Schauspielerin
7	11	Schauspieler
8	12	Schauspieler
10	13	Schauspieler
11	14	Regisseur
11	14	Schauspieler
11	15	Schauspielerin
12	7	Schauspielerin
12	16	Regisseur
14	17	Schauspieler
16	20	Regisseur
16	21	Schauspieler
17	22	Schauspieler
17	24	Schauspielerin
18	22	Schauspieler
19	12	Schauspieler
20	23	Schauspielerin
20	26	Regisseur
21	23	Schauspielerin
21	27	Regisseur
21	28	Schauspieler
22	28	Schauspieler
22	17	Schauspieler
23	29	Regisseur
23	30	Schauspieler
24	29	Regisseur
24	31	Schauspielerin
25	29	Regisseur
25	29	Schauspieler
25	31	Schauspielerin
26	32	Regisseur
27	32	Regisseur
28	32	Regisseur
28	33	Schauspieler
29	32	Regisseur
29	33	Schauspieler
29	28	Schauspieler
30	32	Regisseur
30	19	Stimme von E.T.
31	18	Schauspieler
31	19	Schauspielerin
1	1	Regisseur
1	1	Schauspieler
1	2	Schauspielerin
2	3	Regisseur
3	4	Regisseur
3	5	Schauspieler
3	6	Schauspieler
4	7	Schauspielerin
4	8	Schauspieler
5	1	Schauspieler
5	8	Schauspieler
5	14	Schauspieler
6	9	Schauspieler
7	10	Schauspielerin
7	11	Schauspieler
8	12	Schauspieler
10	13	Schauspieler
11	14	Regisseur
11	14	Schauspieler
11	15	Schauspielerin
12	7	Schauspielerin
12	16	Regisseur
14	17	Schauspieler
16	20	Regisseur
16	21	Schauspieler
17	22	Schauspieler
17	24	Schauspielerin
18	22	Schauspieler
19	12	Schauspieler
20	23	Schauspielerin
20	26	Regisseur
21	23	Schauspielerin
21	27	Regisseur
21	28	Schauspieler
22	28	Schauspieler
22	17	Schauspieler
23	29	Regisseur
23	30	Schauspieler
24	29	Regisseur
24	31	Schauspielerin
25	29	Regisseur
25	29	Schauspieler
25	31	Schauspielerin
26	32	Regisseur
27	32	Regisseur
28	32	Regisseur
28	33	Schauspieler
29	32	Regisseur
29	33	Schauspieler
29	28	Schauspieler
30	32	Regisseur
30	19	Stimme von E.T.
31	18	Schauspieler
31	19	Schauspielerin
\.


--
-- Data for Name: person; Type: TABLE DATA; Schema: film; Owner: postgres
--

COPY person (id, name, vorname) FROM stdin;
1	Eastwood	Clint
2	Streep	Meryl
3	Geronimi	Clyde
4	Longo	Robert
5	Lundgren	Dolph
6	Francks	Don
7	Bullock	Sandra
8	Pullman	Bill
9	Kline	Kevin
10	Rieman	Katja
11	Wiesinger	Kai
12	Hanks	Tom
13	Stallone	Sylvester
14	Gibson	Mel
15	Marceau	Sophie
16	Winkler	Irwin
17	Costner	Kevin
18	Crystal	Billy
19	Winger	Debra
20	Wang	Wayne
21	Hurt	William
22	Schwarzenegger	Arnold
23	Pfeiffer	Michelle
24	Curtis	Jamie Lee
25	Curtis	Tony
26	Burton	Tim
27	Schepisi	Fred
28	Connery	Sean
29	Allen	Woody
30	Warden	Jack
31	Farrow	Mia
32	Spielberg	Steven
33	Ford	Harrison
\.


--
-- Name: person_sq; Type: SEQUENCE SET; Schema: film; Owner: postgres
--

SELECT pg_catalog.setval('person_sq', 1, false);


--
-- Data for Name: vorstellung; Type: TABLE DATA; Schema: film; Owner: postgres
--

COPY vorstellung (film, datum, kino) FROM stdin;
17	1995-01-01	19
18	1991-01-01	19
20	1993-01-01	19
21	1991-01-01	19
22	1992-01-01	19
23	1992-01-01	19
24	1988-01-01	19
25	1987-01-01	19
26	1994-01-01	19
27	1992-01-01	19
28	1985-01-01	19
29	1990-01-01	19
30	1982-01-01	19
31	1995-01-01	19
32	1993-01-01	4
19	1995-09-01	16
19	1995-09-02	16
19	1995-09-03	16
19	1995-09-04	16
19	1995-09-05	16
19	1995-09-06	16
19	1995-09-07	16
19	1995-09-08	16
19	1995-09-09	16
19	1995-09-10	16
19	1995-09-11	16
19	1995-09-12	16
19	1995-09-13	16
19	1995-09-14	16
19	1995-09-15	16
19	1995-09-16	16
19	1995-09-17	16
19	1995-09-18	16
19	1995-09-19	16
19	1995-09-20	16
19	1995-09-21	16
19	1995-09-22	16
19	1995-09-23	16
19	1995-09-24	16
19	1995-09-25	16
19	1995-09-26	16
19	1995-09-27	16
19	1995-09-28	16
19	1995-09-29	16
19	1995-09-30	16
19	1995-10-01	16
19	1995-10-02	16
19	1995-10-03	16
19	1995-10-04	16
19	1995-10-05	16
19	1995-10-06	16
19	1995-10-07	16
19	1995-10-08	16
19	1995-10-09	16
19	1995-10-10	16
19	1995-10-11	16
19	1995-10-12	16
19	1995-10-13	16
19	1995-10-14	16
19	1995-10-15	16
19	1995-10-16	16
19	1995-10-17	16
19	1995-10-18	16
19	1995-10-19	16
19	1995-10-20	16
19	1995-10-21	16
19	1995-10-22	16
19	1995-10-23	16
19	1995-10-24	16
19	1995-10-25	16
19	1995-10-26	16
19	1995-10-27	16
19	1995-10-28	16
19	1995-10-29	16
19	1995-10-30	16
19	1995-10-31	16
19	1995-11-01	16
1	1995-11-02	1
2	1995-11-02	1
3	1995-11-02	2
4	1995-11-02	2
5	1995-11-02	2
6	1995-11-02	3
7	1995-11-02	3
8	1995-11-02	4
9	1995-11-02	4
10	1995-11-02	5
11	1995-11-02	6
12	1995-11-02	7
13	1995-11-02	8
14	1995-11-02	9
15	1995-11-02	11
16	1995-11-02	12
1	1995-11-03	1
2	1995-11-03	1
3	1995-11-03	2
4	1995-11-03	2
5	1995-11-03	2
6	1995-11-03	3
7	1995-11-03	3
8	1995-11-03	4
9	1995-11-03	4
10	1995-11-03	5
11	1995-11-03	6
12	1995-11-03	7
13	1995-11-03	8
14	1995-11-03	9
15	1995-11-03	11
16	1995-11-03	12
1	1995-11-04	1
2	1995-11-04	1
3	1995-11-04	2
4	1995-11-04	2
5	1995-11-04	2
6	1995-11-04	3
7	1995-11-04	3
8	1995-11-04	4
9	1995-11-04	4
10	1995-11-04	5
11	1995-11-04	6
12	1995-11-04	7
13	1995-11-04	8
14	1995-11-04	9
15	1995-11-04	11
16	1995-11-04	12
1	1995-11-05	1
2	1995-11-05	1
3	1995-11-05	2
4	1995-11-05	2
5	1995-11-05	2
6	1995-11-05	3
7	1995-11-05	3
8	1995-11-05	4
9	1995-11-05	4
10	1995-11-05	5
11	1995-11-05	6
12	1995-11-05	7
13	1995-11-05	8
14	1995-11-05	9
15	1995-11-05	11
16	1995-11-05	12
1	1995-11-06	1
2	1995-11-06	1
3	1995-11-06	2
4	1995-11-06	2
5	1995-11-06	2
6	1995-11-06	3
7	1995-11-06	3
8	1995-11-06	4
9	1995-11-06	4
10	1995-11-06	5
11	1995-11-06	6
12	1995-11-06	7
13	1995-11-06	8
14	1995-11-06	9
15	1995-11-06	11
16	1995-11-06	12
1	1995-11-07	1
2	1995-11-07	1
3	1995-11-07	2
4	1995-11-07	2
5	1995-11-07	2
6	1995-11-07	3
7	1995-11-07	3
8	1995-11-07	4
9	1995-11-07	4
10	1995-11-07	5
11	1995-11-07	6
12	1995-11-07	7
13	1995-11-07	8
14	1995-11-07	9
15	1995-11-07	11
16	1995-11-07	12
1	1995-11-08	1
2	1995-11-08	1
3	1995-11-08	2
4	1995-11-08	2
5	1995-11-08	2
6	1995-11-08	3
7	1995-11-08	3
8	1995-11-08	4
9	1995-11-08	4
10	1995-11-08	5
11	1995-11-08	6
12	1995-11-08	7
13	1995-11-08	8
14	1995-11-08	9
15	1995-11-08	11
16	1995-11-08	12
16	1995-11-01	17
8	1995-11-02	15
8	1995-11-02	19
8	1995-11-02	16
10	1995-11-02	15
10	1995-11-02	19
10	1995-11-02	16
11	1995-11-02	15
11	1995-11-02	19
11	1995-11-02	16
5	1995-11-02	15
5	1995-11-02	16
1	1995-11-02	19
1	1995-11-02	18
13	1995-11-02	15
13	1995-11-02	19
13	1995-11-02	16
19	1995-11-02	16
12	1995-11-02	15
12	1995-11-02	19
12	1995-11-02	16
8	1995-11-03	15
8	1995-11-03	19
8	1995-11-03	16
10	1995-11-03	15
10	1995-11-03	19
10	1995-11-03	16
11	1995-11-03	15
11	1995-11-03	19
11	1995-11-03	16
5	1995-11-03	15
5	1995-11-03	16
1	1995-11-03	19
1	1995-11-03	18
13	1995-11-03	15
13	1995-11-03	19
13	1995-11-03	16
19	1995-11-03	16
12	1995-11-03	15
12	1995-11-03	19
12	1995-11-03	16
8	1995-11-04	15
8	1995-11-04	19
8	1995-11-04	16
10	1995-11-04	15
10	1995-11-04	19
10	1995-11-04	16
11	1995-11-04	15
11	1995-11-04	19
11	1995-11-04	16
5	1995-11-04	15
5	1995-11-04	16
1	1995-11-04	19
1	1995-11-04	18
13	1995-11-04	15
13	1995-11-04	19
13	1995-11-04	16
19	1995-11-04	16
12	1995-11-04	15
12	1995-11-04	19
12	1995-11-04	16
8	1995-11-05	15
8	1995-11-05	19
8	1995-11-05	16
10	1995-11-05	15
10	1995-11-05	19
10	1995-11-05	16
11	1995-11-05	15
11	1995-11-05	19
11	1995-11-05	16
5	1995-11-05	15
5	1995-11-05	16
1	1995-11-05	19
1	1995-11-05	18
13	1995-11-05	15
13	1995-11-05	19
13	1995-11-05	16
19	1995-11-05	16
12	1995-11-05	15
12	1995-11-05	19
12	1995-11-05	16
8	1995-11-06	15
8	1995-11-06	19
8	1995-11-06	16
10	1995-11-06	15
10	1995-11-06	19
10	1995-11-06	16
11	1995-11-06	15
11	1995-11-06	19
11	1995-11-06	16
5	1995-11-06	15
5	1995-11-06	16
1	1995-11-06	19
1	1995-11-06	18
13	1995-11-06	15
13	1995-11-06	19
13	1995-11-06	16
19	1995-11-06	16
12	1995-11-06	15
12	1995-11-06	19
12	1995-11-06	16
8	1995-11-07	15
8	1995-11-07	19
8	1995-11-07	16
10	1995-11-07	15
10	1995-11-07	19
10	1995-11-07	16
11	1995-11-07	15
11	1995-11-07	19
11	1995-11-07	16
5	1995-11-07	15
5	1995-11-07	16
1	1995-11-07	19
1	1995-11-07	18
13	1995-11-07	15
13	1995-11-07	19
13	1995-11-07	16
19	1995-11-07	16
12	1995-11-07	15
12	1995-11-07	19
12	1995-11-07	16
8	1995-11-08	15
8	1995-11-08	19
8	1995-11-08	16
10	1995-11-08	15
10	1995-11-08	19
10	1995-11-08	16
11	1995-11-08	15
11	1995-11-08	19
11	1995-11-08	16
5	1995-11-08	15
5	1995-11-08	16
1	1995-11-08	19
1	1995-11-08	18
13	1995-11-08	15
13	1995-11-08	19
13	1995-11-08	16
19	1995-11-08	16
12	1995-11-08	15
12	1995-11-08	19
12	1995-11-08	16
17	1995-01-01	19
18	1991-01-01	19
20	1993-01-01	19
21	1991-01-01	19
22	1992-01-01	19
23	1992-01-01	19
24	1988-01-01	19
25	1987-01-01	19
26	1994-01-01	19
27	1992-01-01	19
28	1985-01-01	19
29	1990-01-01	19
30	1982-01-01	19
31	1995-01-01	19
32	1993-01-01	4
19	1995-09-01	16
19	1995-09-02	16
19	1995-09-03	16
19	1995-09-04	16
19	1995-09-05	16
19	1995-09-06	16
19	1995-09-07	16
19	1995-09-08	16
19	1995-09-09	16
19	1995-09-10	16
19	1995-09-11	16
19	1995-09-12	16
19	1995-09-13	16
19	1995-09-14	16
19	1995-09-15	16
19	1995-09-16	16
19	1995-09-17	16
19	1995-09-18	16
19	1995-09-19	16
19	1995-09-20	16
19	1995-09-21	16
19	1995-09-22	16
19	1995-09-23	16
19	1995-09-24	16
19	1995-09-25	16
19	1995-09-26	16
19	1995-09-27	16
19	1995-09-28	16
19	1995-09-29	16
19	1995-09-30	16
19	1995-10-01	16
19	1995-10-02	16
19	1995-10-03	16
19	1995-10-04	16
19	1995-10-05	16
19	1995-10-06	16
19	1995-10-07	16
19	1995-10-08	16
19	1995-10-09	16
19	1995-10-10	16
19	1995-10-11	16
19	1995-10-12	16
19	1995-10-13	16
19	1995-10-14	16
19	1995-10-15	16
19	1995-10-16	16
19	1995-10-17	16
19	1995-10-18	16
19	1995-10-19	16
19	1995-10-20	16
19	1995-10-21	16
19	1995-10-22	16
19	1995-10-23	16
19	1995-10-24	16
19	1995-10-25	16
19	1995-10-26	16
19	1995-10-27	16
19	1995-10-28	16
19	1995-10-29	16
19	1995-10-30	16
19	1995-10-31	16
19	1995-11-01	16
1	1995-11-02	1
2	1995-11-02	1
3	1995-11-02	2
4	1995-11-02	2
5	1995-11-02	2
6	1995-11-02	3
7	1995-11-02	3
8	1995-11-02	4
9	1995-11-02	4
10	1995-11-02	5
11	1995-11-02	6
12	1995-11-02	7
13	1995-11-02	8
14	1995-11-02	9
15	1995-11-02	11
16	1995-11-02	12
1	1995-11-03	1
2	1995-11-03	1
3	1995-11-03	2
4	1995-11-03	2
5	1995-11-03	2
6	1995-11-03	3
7	1995-11-03	3
8	1995-11-03	4
9	1995-11-03	4
10	1995-11-03	5
11	1995-11-03	6
12	1995-11-03	7
13	1995-11-03	8
14	1995-11-03	9
15	1995-11-03	11
16	1995-11-03	12
1	1995-11-04	1
2	1995-11-04	1
3	1995-11-04	2
4	1995-11-04	2
5	1995-11-04	2
6	1995-11-04	3
7	1995-11-04	3
8	1995-11-04	4
9	1995-11-04	4
10	1995-11-04	5
11	1995-11-04	6
12	1995-11-04	7
13	1995-11-04	8
14	1995-11-04	9
15	1995-11-04	11
16	1995-11-04	12
1	1995-11-05	1
2	1995-11-05	1
3	1995-11-05	2
4	1995-11-05	2
5	1995-11-05	2
6	1995-11-05	3
7	1995-11-05	3
8	1995-11-05	4
9	1995-11-05	4
10	1995-11-05	5
11	1995-11-05	6
12	1995-11-05	7
13	1995-11-05	8
14	1995-11-05	9
15	1995-11-05	11
16	1995-11-05	12
1	1995-11-06	1
2	1995-11-06	1
3	1995-11-06	2
4	1995-11-06	2
5	1995-11-06	2
6	1995-11-06	3
7	1995-11-06	3
8	1995-11-06	4
9	1995-11-06	4
10	1995-11-06	5
11	1995-11-06	6
12	1995-11-06	7
13	1995-11-06	8
14	1995-11-06	9
15	1995-11-06	11
16	1995-11-06	12
1	1995-11-07	1
2	1995-11-07	1
3	1995-11-07	2
4	1995-11-07	2
5	1995-11-07	2
6	1995-11-07	3
7	1995-11-07	3
8	1995-11-07	4
9	1995-11-07	4
10	1995-11-07	5
11	1995-11-07	6
12	1995-11-07	7
13	1995-11-07	8
14	1995-11-07	9
15	1995-11-07	11
16	1995-11-07	12
1	1995-11-08	1
2	1995-11-08	1
3	1995-11-08	2
4	1995-11-08	2
5	1995-11-08	2
6	1995-11-08	3
7	1995-11-08	3
8	1995-11-08	4
9	1995-11-08	4
10	1995-11-08	5
11	1995-11-08	6
12	1995-11-08	7
13	1995-11-08	8
14	1995-11-08	9
15	1995-11-08	11
16	1995-11-08	12
16	1995-11-01	17
8	1995-11-02	15
8	1995-11-02	19
8	1995-11-02	16
10	1995-11-02	15
10	1995-11-02	19
10	1995-11-02	16
11	1995-11-02	15
11	1995-11-02	19
11	1995-11-02	16
5	1995-11-02	15
5	1995-11-02	16
1	1995-11-02	19
1	1995-11-02	18
13	1995-11-02	15
13	1995-11-02	19
13	1995-11-02	16
19	1995-11-02	16
12	1995-11-02	15
12	1995-11-02	19
12	1995-11-02	16
8	1995-11-03	15
8	1995-11-03	19
8	1995-11-03	16
10	1995-11-03	15
10	1995-11-03	19
10	1995-11-03	16
11	1995-11-03	15
11	1995-11-03	19
11	1995-11-03	16
5	1995-11-03	15
5	1995-11-03	16
1	1995-11-03	19
1	1995-11-03	18
13	1995-11-03	15
13	1995-11-03	19
13	1995-11-03	16
19	1995-11-03	16
12	1995-11-03	15
12	1995-11-03	19
12	1995-11-03	16
8	1995-11-04	15
8	1995-11-04	19
8	1995-11-04	16
10	1995-11-04	15
10	1995-11-04	19
10	1995-11-04	16
11	1995-11-04	15
11	1995-11-04	19
11	1995-11-04	16
5	1995-11-04	15
5	1995-11-04	16
1	1995-11-04	19
1	1995-11-04	18
13	1995-11-04	15
13	1995-11-04	19
13	1995-11-04	16
19	1995-11-04	16
12	1995-11-04	15
12	1995-11-04	19
12	1995-11-04	16
8	1995-11-05	15
8	1995-11-05	19
8	1995-11-05	16
10	1995-11-05	15
10	1995-11-05	19
10	1995-11-05	16
11	1995-11-05	15
11	1995-11-05	19
11	1995-11-05	16
5	1995-11-05	15
5	1995-11-05	16
1	1995-11-05	19
1	1995-11-05	18
13	1995-11-05	15
13	1995-11-05	19
13	1995-11-05	16
19	1995-11-05	16
12	1995-11-05	15
12	1995-11-05	19
12	1995-11-05	16
8	1995-11-06	15
8	1995-11-06	19
8	1995-11-06	16
10	1995-11-06	15
10	1995-11-06	19
10	1995-11-06	16
11	1995-11-06	15
11	1995-11-06	19
11	1995-11-06	16
5	1995-11-06	15
5	1995-11-06	16
1	1995-11-06	19
1	1995-11-06	18
13	1995-11-06	15
13	1995-11-06	19
13	1995-11-06	16
19	1995-11-06	16
12	1995-11-06	15
12	1995-11-06	19
12	1995-11-06	16
8	1995-11-07	15
8	1995-11-07	19
8	1995-11-07	16
10	1995-11-07	15
10	1995-11-07	19
10	1995-11-07	16
11	1995-11-07	15
11	1995-11-07	19
11	1995-11-07	16
5	1995-11-07	15
5	1995-11-07	16
1	1995-11-07	19
1	1995-11-07	18
13	1995-11-07	15
13	1995-11-07	19
13	1995-11-07	16
19	1995-11-07	16
12	1995-11-07	15
12	1995-11-07	19
12	1995-11-07	16
8	1995-11-08	15
8	1995-11-08	19
8	1995-11-08	16
10	1995-11-08	15
10	1995-11-08	19
10	1995-11-08	16
11	1995-11-08	15
11	1995-11-08	19
11	1995-11-08	16
5	1995-11-08	15
5	1995-11-08	16
1	1995-11-08	19
1	1995-11-08	18
13	1995-11-08	15
13	1995-11-08	19
13	1995-11-08	16
19	1995-11-08	16
12	1995-11-08	15
12	1995-11-08	19
12	1995-11-08	16
17	1995-01-01	19
18	1991-01-01	19
20	1993-01-01	19
21	1991-01-01	19
22	1992-01-01	19
23	1992-01-01	19
24	1988-01-01	19
25	1987-01-01	19
26	1994-01-01	19
27	1992-01-01	19
28	1985-01-01	19
29	1990-01-01	19
30	1982-01-01	19
31	1995-01-01	19
32	1993-01-01	4
19	1995-09-01	16
19	1995-09-02	16
19	1995-09-03	16
19	1995-09-04	16
19	1995-09-05	16
19	1995-09-06	16
19	1995-09-07	16
19	1995-09-08	16
19	1995-09-09	16
19	1995-09-10	16
19	1995-09-11	16
19	1995-09-12	16
19	1995-09-13	16
19	1995-09-14	16
19	1995-09-15	16
19	1995-09-16	16
19	1995-09-17	16
19	1995-09-18	16
19	1995-09-19	16
19	1995-09-20	16
19	1995-09-21	16
19	1995-09-22	16
19	1995-09-23	16
19	1995-09-24	16
19	1995-09-25	16
19	1995-09-26	16
19	1995-09-27	16
19	1995-09-28	16
19	1995-09-29	16
19	1995-09-30	16
19	1995-10-01	16
19	1995-10-02	16
19	1995-10-03	16
19	1995-10-04	16
19	1995-10-05	16
19	1995-10-06	16
19	1995-10-07	16
19	1995-10-08	16
19	1995-10-09	16
19	1995-10-10	16
19	1995-10-11	16
19	1995-10-12	16
19	1995-10-13	16
19	1995-10-14	16
19	1995-10-15	16
19	1995-10-16	16
19	1995-10-17	16
19	1995-10-18	16
19	1995-10-19	16
19	1995-10-20	16
19	1995-10-21	16
19	1995-10-22	16
19	1995-10-23	16
19	1995-10-24	16
19	1995-10-25	16
19	1995-10-26	16
19	1995-10-27	16
19	1995-10-28	16
19	1995-10-29	16
19	1995-10-30	16
19	1995-10-31	16
19	1995-11-01	16
1	1995-11-02	1
2	1995-11-02	1
3	1995-11-02	2
4	1995-11-02	2
5	1995-11-02	2
6	1995-11-02	3
7	1995-11-02	3
8	1995-11-02	4
9	1995-11-02	4
10	1995-11-02	5
11	1995-11-02	6
12	1995-11-02	7
13	1995-11-02	8
14	1995-11-02	9
15	1995-11-02	11
16	1995-11-02	12
1	1995-11-03	1
2	1995-11-03	1
3	1995-11-03	2
4	1995-11-03	2
5	1995-11-03	2
6	1995-11-03	3
7	1995-11-03	3
8	1995-11-03	4
9	1995-11-03	4
10	1995-11-03	5
11	1995-11-03	6
12	1995-11-03	7
13	1995-11-03	8
14	1995-11-03	9
15	1995-11-03	11
16	1995-11-03	12
1	1995-11-04	1
2	1995-11-04	1
3	1995-11-04	2
4	1995-11-04	2
5	1995-11-04	2
6	1995-11-04	3
7	1995-11-04	3
8	1995-11-04	4
9	1995-11-04	4
10	1995-11-04	5
11	1995-11-04	6
12	1995-11-04	7
13	1995-11-04	8
14	1995-11-04	9
15	1995-11-04	11
16	1995-11-04	12
1	1995-11-05	1
2	1995-11-05	1
3	1995-11-05	2
4	1995-11-05	2
5	1995-11-05	2
6	1995-11-05	3
7	1995-11-05	3
8	1995-11-05	4
9	1995-11-05	4
10	1995-11-05	5
11	1995-11-05	6
12	1995-11-05	7
13	1995-11-05	8
14	1995-11-05	9
15	1995-11-05	11
16	1995-11-05	12
1	1995-11-06	1
2	1995-11-06	1
3	1995-11-06	2
4	1995-11-06	2
5	1995-11-06	2
6	1995-11-06	3
7	1995-11-06	3
8	1995-11-06	4
9	1995-11-06	4
10	1995-11-06	5
11	1995-11-06	6
12	1995-11-06	7
13	1995-11-06	8
14	1995-11-06	9
15	1995-11-06	11
16	1995-11-06	12
1	1995-11-07	1
2	1995-11-07	1
3	1995-11-07	2
4	1995-11-07	2
5	1995-11-07	2
6	1995-11-07	3
7	1995-11-07	3
8	1995-11-07	4
9	1995-11-07	4
10	1995-11-07	5
11	1995-11-07	6
12	1995-11-07	7
13	1995-11-07	8
14	1995-11-07	9
15	1995-11-07	11
16	1995-11-07	12
1	1995-11-08	1
2	1995-11-08	1
3	1995-11-08	2
4	1995-11-08	2
5	1995-11-08	2
6	1995-11-08	3
7	1995-11-08	3
8	1995-11-08	4
9	1995-11-08	4
10	1995-11-08	5
11	1995-11-08	6
12	1995-11-08	7
13	1995-11-08	8
14	1995-11-08	9
15	1995-11-08	11
16	1995-11-08	12
16	1995-11-01	17
8	1995-11-02	15
8	1995-11-02	19
8	1995-11-02	16
10	1995-11-02	15
10	1995-11-02	19
10	1995-11-02	16
11	1995-11-02	15
11	1995-11-02	19
11	1995-11-02	16
5	1995-11-02	15
5	1995-11-02	16
1	1995-11-02	19
1	1995-11-02	18
13	1995-11-02	15
13	1995-11-02	19
13	1995-11-02	16
19	1995-11-02	16
12	1995-11-02	15
12	1995-11-02	19
12	1995-11-02	16
8	1995-11-03	15
8	1995-11-03	19
8	1995-11-03	16
10	1995-11-03	15
10	1995-11-03	19
10	1995-11-03	16
11	1995-11-03	15
11	1995-11-03	19
11	1995-11-03	16
5	1995-11-03	15
5	1995-11-03	16
1	1995-11-03	19
1	1995-11-03	18
13	1995-11-03	15
13	1995-11-03	19
13	1995-11-03	16
19	1995-11-03	16
12	1995-11-03	15
12	1995-11-03	19
12	1995-11-03	16
8	1995-11-04	15
8	1995-11-04	19
8	1995-11-04	16
10	1995-11-04	15
10	1995-11-04	19
10	1995-11-04	16
11	1995-11-04	15
11	1995-11-04	19
11	1995-11-04	16
5	1995-11-04	15
5	1995-11-04	16
1	1995-11-04	19
1	1995-11-04	18
13	1995-11-04	15
13	1995-11-04	19
13	1995-11-04	16
19	1995-11-04	16
12	1995-11-04	15
12	1995-11-04	19
12	1995-11-04	16
8	1995-11-05	15
8	1995-11-05	19
8	1995-11-05	16
10	1995-11-05	15
10	1995-11-05	19
10	1995-11-05	16
11	1995-11-05	15
11	1995-11-05	19
11	1995-11-05	16
5	1995-11-05	15
5	1995-11-05	16
1	1995-11-05	19
1	1995-11-05	18
13	1995-11-05	15
13	1995-11-05	19
13	1995-11-05	16
19	1995-11-05	16
12	1995-11-05	15
12	1995-11-05	19
12	1995-11-05	16
8	1995-11-06	15
8	1995-11-06	19
8	1995-11-06	16
10	1995-11-06	15
10	1995-11-06	19
10	1995-11-06	16
11	1995-11-06	15
11	1995-11-06	19
11	1995-11-06	16
5	1995-11-06	15
5	1995-11-06	16
1	1995-11-06	19
1	1995-11-06	18
13	1995-11-06	15
13	1995-11-06	19
13	1995-11-06	16
19	1995-11-06	16
12	1995-11-06	15
12	1995-11-06	19
12	1995-11-06	16
8	1995-11-07	15
8	1995-11-07	19
8	1995-11-07	16
10	1995-11-07	15
10	1995-11-07	19
10	1995-11-07	16
11	1995-11-07	15
11	1995-11-07	19
11	1995-11-07	16
5	1995-11-07	15
5	1995-11-07	16
1	1995-11-07	19
1	1995-11-07	18
13	1995-11-07	15
13	1995-11-07	19
13	1995-11-07	16
19	1995-11-07	16
12	1995-11-07	15
12	1995-11-07	19
12	1995-11-07	16
8	1995-11-08	15
8	1995-11-08	19
8	1995-11-08	16
10	1995-11-08	15
10	1995-11-08	19
10	1995-11-08	16
11	1995-11-08	15
11	1995-11-08	19
11	1995-11-08	16
5	1995-11-08	15
5	1995-11-08	16
1	1995-11-08	19
1	1995-11-08	18
13	1995-11-08	15
13	1995-11-08	19
13	1995-11-08	16
19	1995-11-08	16
12	1995-11-08	15
12	1995-11-08	19
12	1995-11-08	16
\.


--
-- Name: film_pkey; Type: CONSTRAINT; Schema: film; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY film
    ADD CONSTRAINT film_pkey PRIMARY KEY (id);


--
-- Name: kino_pkey; Type: CONSTRAINT; Schema: film; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY kino
    ADD CONSTRAINT kino_pkey PRIMARY KEY (id);


--
-- Name: person_pkey; Type: CONSTRAINT; Schema: film; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: film; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA film FROM PUBLIC;
REVOKE ALL ON SCHEMA film FROM postgres;
GRANT ALL ON SCHEMA film TO postgres;


--
-- Name: film; Type: ACL; Schema: film; Owner: postgres
--

REVOKE ALL ON TABLE film FROM PUBLIC;
REVOKE ALL ON TABLE film FROM postgres;
GRANT ALL ON TABLE film TO postgres;


--
-- Name: kino; Type: ACL; Schema: film; Owner: postgres
--

REVOKE ALL ON TABLE kino FROM PUBLIC;
REVOKE ALL ON TABLE kino FROM postgres;
GRANT ALL ON TABLE kino TO postgres;


--
-- Name: mitwirkung; Type: ACL; Schema: film; Owner: postgres
--

REVOKE ALL ON TABLE mitwirkung FROM PUBLIC;
REVOKE ALL ON TABLE mitwirkung FROM postgres;
GRANT ALL ON TABLE mitwirkung TO postgres;


--
-- Name: person; Type: ACL; Schema: film; Owner: postgres
--

REVOKE ALL ON TABLE person FROM PUBLIC;
REVOKE ALL ON TABLE person FROM postgres;
GRANT ALL ON TABLE person TO postgres;


--
-- Name: vorstellung; Type: ACL; Schema: film; Owner: postgres
--

REVOKE ALL ON TABLE vorstellung FROM PUBLIC;
REVOKE ALL ON TABLE vorstellung FROM postgres;
GRANT ALL ON TABLE vorstellung TO postgres;


--
-- PostgreSQL database dump complete
--

