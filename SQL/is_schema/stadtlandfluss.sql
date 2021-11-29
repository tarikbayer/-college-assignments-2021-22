--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: stadtlandfluss; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA stadtlandfluss;


ALTER SCHEMA stadtlandfluss OWNER TO postgres;

--
-- Name: SCHEMA stadtlandfluss; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA stadtlandfluss IS 'Beispielschema für VL IS WS 10/11';


SET search_path = stadtlandfluss, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bezirk; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE bezirk (
    name character varying(50) NOT NULL,
    einwohner integer,
    "fläche" integer
);


ALTER TABLE stadtlandfluss.bezirk OWNER TO postgres;

--
-- Name: COLUMN bezirk.einwohner; Type: COMMENT; Schema: stadtlandfluss; Owner: postgres
--

COMMENT ON COLUMN bezirk.einwohner IS 'Einwohner in Tausend';


--
-- Name: COLUMN bezirk."fläche"; Type: COMMENT; Schema: stadtlandfluss; Owner: postgres
--

COMMENT ON COLUMN bezirk."fläche" IS 'Fläche in km2';


--
-- Name: bezirk_in_land; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE bezirk_in_land (
    bezirk character varying(50),
    land character varying(50)
);


ALTER TABLE stadtlandfluss.bezirk_in_land OWNER TO postgres;

--
-- Name: fluss; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE fluss (
    name character varying(50) NOT NULL,
    "LängeInD" bigint,
    "Gesamtlänge" bigint,
    CONSTRAINT fluss_c CHECK ((("LängeInD" > 0) OR ("LängeInD" IS NULL)))
);


ALTER TABLE stadtlandfluss.fluss OWNER TO postgres;

--
-- Name: fluss_durch_land; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE fluss_durch_land (
    fluss character varying(50),
    land character varying(50)
);


ALTER TABLE stadtlandfluss.fluss_durch_land OWNER TO postgres;

--
-- Name: fluss_entspringt_in_land; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE fluss_entspringt_in_land (
    fluss character varying(50),
    ursprungsland character varying(50)
);


ALTER TABLE stadtlandfluss.fluss_entspringt_in_land OWNER TO postgres;

--
-- Name: fluss_entspringt_in_nachbarstaat; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE fluss_entspringt_in_nachbarstaat (
    fluss character varying(50),
    nachbarstaat character varying(3)
);


ALTER TABLE stadtlandfluss.fluss_entspringt_in_nachbarstaat OWNER TO postgres;

--
-- Name: nebenfluss_von; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE nebenfluss_von (
    fluss character varying(50),
    nebenfluss character varying(50),
    seite character varying(50)
);


ALTER TABLE stadtlandfluss.nebenfluss_von OWNER TO postgres;

--
-- Name: quellfluss_von; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE quellfluss_von (
    quellfluss character varying(50),
    fluss character varying(50)
);


ALTER TABLE stadtlandfluss.quellfluss_von OWNER TO postgres;

--
-- Name: fluss_mündet_in; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW "fluss_mündet_in" AS
    SELECT nebenfluss_von.nebenfluss, nebenfluss_von.fluss FROM nebenfluss_von UNION SELECT quellfluss_von.quellfluss AS nebenfluss, quellfluss_von.fluss FROM quellfluss_von;


ALTER TABLE stadtlandfluss."fluss_mündet_in" OWNER TO postgres;

--
-- Name: grenzfluss_international; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE grenzfluss_international (
    fluss character varying(50),
    land character varying(50),
    nachbarstaat character varying(50)
);


ALTER TABLE stadtlandfluss.grenzfluss_international OWNER TO postgres;

--
-- Name: grenzfluss_national; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE grenzfluss_national (
    fluss character varying(50),
    land1 character varying(50),
    land2 character varying(50)
);


ALTER TABLE stadtlandfluss.grenzfluss_national OWNER TO postgres;

--
-- Name: stadt; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE stadt (
    kfz character varying(3),
    name character varying(50) NOT NULL,
    einwohner bigint,
    CONSTRAINT stadt_c CHECK ((einwohner > 49))
);


ALTER TABLE stadtlandfluss.stadt OWNER TO postgres;

--
-- Name: COLUMN stadt.kfz; Type: COMMENT; Schema: stadtlandfluss; Owner: postgres
--

COMMENT ON COLUMN stadt.kfz IS 'Kraftfahrzeugkennzeichen des zugehörigen Kreises';


--
-- Name: COLUMN stadt.name; Type: COMMENT; Schema: stadtlandfluss; Owner: postgres
--

COMMENT ON COLUMN stadt.name IS 'Name der Stadt';


--
-- Name: COLUMN stadt.einwohner; Type: COMMENT; Schema: stadtlandfluss; Owner: postgres
--

COMMENT ON COLUMN stadt.einwohner IS 'Einwohnerzahl  in Tausend';


--
-- Name: großstadt; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW "großstadt" AS
    SELECT stadt.kfz, stadt.name, stadt.einwohner FROM stadt WHERE (stadt.einwohner >= 100);


ALTER TABLE stadtlandfluss."großstadt" OWNER TO postgres;

--
-- Name: stadt_in_land; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE stadt_in_land (
    stadt character varying(50) NOT NULL,
    land character varying(2)
);


ALTER TABLE stadtlandfluss.stadt_in_land OWNER TO postgres;

--
-- Name: größe_der_größten_stadt_im_land; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW "größe_der_größten_stadt_im_land" AS
    SELECT stadt_in_land.land, max(stadt.einwohner) AS "Max von Einwohner" FROM (stadt JOIN stadt_in_land ON (((stadt.name)::text = (stadt_in_land.stadt)::text))) GROUP BY stadt_in_land.land;


ALTER TABLE stadtlandfluss."größe_der_größten_stadt_im_land" OWNER TO postgres;

--
-- Name: größte_stadt_im_land; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW "größte_stadt_im_land" AS
    SELECT stadt.name, stadt.einwohner, stadt_in_land.land FROM (stadt JOIN (stadt_in_land JOIN "größe_der_größten_stadt_im_land" ON (((stadt_in_land.land)::text = ("größe_der_größten_stadt_im_land".land)::text))) ON ((((stadt.name)::text = (stadt_in_land.stadt)::text) AND (stadt.einwohner = "größe_der_größten_stadt_im_land"."Max von Einwohner"))));


ALTER TABLE stadtlandfluss."größte_stadt_im_land" OWNER TO postgres;

--
-- Name: hauptstadt_von_land; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE hauptstadt_von_land (
    bundesland character varying(2),
    hauptstadt character varying(50) NOT NULL
);


ALTER TABLE stadtlandfluss.hauptstadt_von_land OWNER TO postgres;

--
-- Name: größte_stadt_nicht_hauptstadt; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW "größte_stadt_nicht_hauptstadt" AS
    SELECT "größte_stadt_im_land".name AS "GrößteStadt", "größte_stadt_im_land".einwohner, "größte_stadt_im_land".land, hauptstadt_von_land.hauptstadt, stadt.einwohner AS einwohnerhauptstadt FROM (("größte_stadt_im_land" JOIN hauptstadt_von_land ON ((("größte_stadt_im_land".land)::text = (hauptstadt_von_land.bundesland)::text))) JOIN stadt ON (((hauptstadt_von_land.hauptstadt)::text = (stadt.name)::text))) WHERE (NOT (("größte_stadt_im_land".name)::text IN (SELECT hauptstadt_von_land.hauptstadt FROM hauptstadt_von_land WHERE (("größte_stadt_im_land".land)::text = ("größte_stadt_im_land".land)::text))));


ALTER TABLE stadtlandfluss."größte_stadt_nicht_hauptstadt" OWNER TO postgres;

--
-- Name: hafenstadt; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE hafenstadt (
    stadt character varying(50),
    "Gewässer" character varying(50),
    typ character varying(50)
);


ALTER TABLE stadtlandfluss.hafenstadt OWNER TO postgres;

--
-- Name: hauptstadt_von_bezirk; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE hauptstadt_von_bezirk (
    bezirk character varying(50),
    hauptstadt character varying(50)
);


ALTER TABLE stadtlandfluss.hauptstadt_von_bezirk OWNER TO postgres;

--
-- Name: kanal; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE kanal (
    "Kürzel" character varying(50),
    name character varying(50),
    "Länge" bigint
);


ALTER TABLE stadtlandfluss.kanal OWNER TO postgres;

--
-- Name: kanal_durch_land; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE kanal_durch_land (
    kanal character varying(50),
    land character varying(50)
);


ALTER TABLE stadtlandfluss.kanal_durch_land OWNER TO postgres;

--
-- Name: kanal_verbindet_wasserstrassen; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE kanal_verbindet_wasserstrassen (
    kanal character varying(50),
    wasserstrasse1 character varying(50),
    wasserstrasse2 character varying(50)
);


ALTER TABLE stadtlandfluss.kanal_verbindet_wasserstrassen OWNER TO postgres;

--
-- Name: kanal_verbindet_wasserstrassen_inv; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW kanal_verbindet_wasserstrassen_inv AS
    SELECT kanal_verbindet_wasserstrassen.kanal, kanal_verbindet_wasserstrassen.wasserstrasse2, kanal_verbindet_wasserstrassen.wasserstrasse1 FROM kanal_verbindet_wasserstrassen;


ALTER TABLE stadtlandfluss.kanal_verbindet_wasserstrassen_inv OWNER TO postgres;

--
-- Name: kanal_verbindet_wasserstrassen*; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW "kanal_verbindet_wasserstrassen*" AS
    SELECT kanal_verbindet_wasserstrassen.kanal, kanal_verbindet_wasserstrassen.wasserstrasse1, kanal_verbindet_wasserstrassen.wasserstrasse2 FROM kanal_verbindet_wasserstrassen UNION SELECT kanal_verbindet_wasserstrassen_inv.kanal, kanal_verbindet_wasserstrassen_inv.wasserstrasse2 AS wasserstrasse1, kanal_verbindet_wasserstrassen_inv.wasserstrasse1 AS wasserstrasse2 FROM kanal_verbindet_wasserstrassen_inv;


ALTER TABLE stadtlandfluss."kanal_verbindet_wasserstrassen*" OWNER TO postgres;

--
-- Name: kreisstadt; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE kreisstadt (
    kfz character varying(3),
    name character varying(50) NOT NULL
);


ALTER TABLE stadtlandfluss.kreisstadt OWNER TO postgres;

--
-- Name: COLUMN kreisstadt.kfz; Type: COMMENT; Schema: stadtlandfluss; Owner: postgres
--

COMMENT ON COLUMN kreisstadt.kfz IS 'Kraftfahrzeugkennzeichen des zugehörigen Kreises';


--
-- Name: COLUMN kreisstadt.name; Type: COMMENT; Schema: stadtlandfluss; Owner: postgres
--

COMMENT ON COLUMN kreisstadt.name IS 'Name der Stadt';


--
-- Name: land; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE land (
    name character varying(50),
    kurzform character varying(2) NOT NULL,
    einwohner bigint,
    "Fläche" bigint
);


ALTER TABLE stadtlandfluss.land OWNER TO postgres;

--
-- Name: millionenstadt; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW millionenstadt AS
    SELECT stadt.kfz, stadt.name, stadt.einwohner FROM stadt WHERE (stadt.einwohner >= 1000);


ALTER TABLE stadtlandfluss.millionenstadt OWNER TO postgres;

--
-- Name: nachbarland_von; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE nachbarland_von (
    land1 character varying(2),
    land2 character varying(2)
);


ALTER TABLE stadtlandfluss.nachbarland_von OWNER TO postgres;

--
-- Name: nachbarland_von_inv; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW nachbarland_von_inv AS
    SELECT nachbarland_von.land2, nachbarland_von.land1 FROM nachbarland_von;


ALTER TABLE stadtlandfluss.nachbarland_von_inv OWNER TO postgres;

--
-- Name: nachbarland_von*; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW "nachbarland_von*" AS
    SELECT nachbarland_von.land1, nachbarland_von.land2 FROM nachbarland_von UNION SELECT nachbarland_von_inv.land2 AS land1, nachbarland_von_inv.land1 AS land2 FROM nachbarland_von_inv;


ALTER TABLE stadtlandfluss."nachbarland_von*" OWNER TO postgres;

--
-- Name: nachbarstaat; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE nachbarstaat (
    staat character varying(50),
    kennzeichen character varying(3) NOT NULL,
    vorwahl character varying(50),
    "Grenzlänge mit D" bigint
);


ALTER TABLE stadtlandfluss.nachbarstaat OWNER TO postgres;

--
-- Name: regierungsbezirk; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW regierungsbezirk AS
    SELECT bezirk.name, bezirk_in_land.land, hauptstadt_von_bezirk.hauptstadt, bezirk.einwohner, bezirk."fläche" FROM (bezirk JOIN (bezirk_in_land JOIN hauptstadt_von_bezirk ON (((bezirk_in_land.bezirk)::text = (hauptstadt_von_bezirk.bezirk)::text))) ON (((bezirk.name)::text = (bezirk_in_land.bezirk)::text)));


ALTER TABLE stadtlandfluss.regierungsbezirk OWNER TO postgres;

--
-- Name: stadt_an_fluss; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE stadt_an_fluss (
    stadt character varying(50),
    fluss character varying(50)
);


ALTER TABLE stadtlandfluss.stadt_an_fluss OWNER TO postgres;

--
-- Name: stadt_an_kanal; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE stadt_an_kanal (
    stadt character varying(50),
    kanal character varying(50)
);


ALTER TABLE stadtlandfluss.stadt_an_kanal OWNER TO postgres;

--
-- Name: stadt_flaeche; Type: TABLE; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

CREATE TABLE stadt_flaeche (
    name character varying(50) NOT NULL,
    "Fläche" integer
);


ALTER TABLE stadtlandfluss.stadt_flaeche OWNER TO postgres;

--
-- Name: COLUMN stadt_flaeche."Fläche"; Type: COMMENT; Schema: stadtlandfluss; Owner: postgres
--

COMMENT ON COLUMN stadt_flaeche."Fläche" IS 'Fläche in km²';


--
-- Name: wasserstraße; Type: VIEW; Schema: stadtlandfluss; Owner: postgres
--

CREATE VIEW "wasserstraße" AS
    SELECT fluss.name, fluss."LängeInD" AS "Länge" FROM fluss UNION SELECT kanal.name, kanal."Länge" FROM kanal;


ALTER TABLE stadtlandfluss."wasserstraße" OWNER TO postgres;

--
-- Data for Name: bezirk; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY bezirk (name, einwohner, "fläche") FROM stdin;
Arnsberg	0	0
Braunschweig	0	0
Chemnitz	0	0
Darmstadt	0	0
Dessau	0	0
Detmold	0	0
Dresden	0	0
Düsseldorf	0	0
Freiburg	0	0
Giessen	0	0
Halle	0	0
Hannover	0	0
Karlsruhe	0	0
Kassel	0	0
Koblenz	0	0
Köln	0	0
Leipzig	0	0
Lüneburg	0	0
Magdeburg	0	0
Mittelfranken	0	0
Münster	0	0
Niederbayern	0	0
Oberbayern	0	0
Oberfranken	0	0
Oberpfalz	0	0
Rheinhessen-Pfalz	0	0
Schwaben	0	0
Stuttgart	0	0
Trier	0	0
Tübingen	0	0
Unterfranken	0	0
Weser-Ems	0	0
\.


--
-- Data for Name: bezirk_in_land; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY bezirk_in_land (bezirk, land) FROM stdin;
Weser-Ems	NI
Lüneburg	NI
Braunschweig	NI
Hannover	NI
Arnsberg	NW
Detmold	NW
Düsseldorf	NW
Köln	NW
Münster	NW
Koblenz	RP
Rheinhessen-Pfalz	RP
Trier	RP
Darmstadt	HE
Giessen	HE
Kassel	HE
Freiburg	BW
Karlsruhe	BW
Stuttgart	BW
Tübingen	BW
Dessau	ST
Halle	ST
Magdeburg	ST
Chemnitz	SN
Dresden	SN
Leipzig	SN
Oberfranken	BY
Mittelfranken	BY
Unterfranken	BY
Oberpfalz	BY
Schwaben	BY
Oberbayern	BY
Niederbayern	BY
Weser-Ems	NI
Lüneburg	NI
Braunschweig	NI
Hannover	NI
Arnsberg	NW
Detmold	NW
Düsseldorf	NW
Köln	NW
Münster	NW
Koblenz	RP
Rheinhessen-Pfalz	RP
Trier	RP
Darmstadt	HE
Giessen	HE
Kassel	HE
Freiburg	BW
Karlsruhe	BW
Stuttgart	BW
Tübingen	BW
Dessau	ST
Halle	ST
Magdeburg	ST
Chemnitz	SN
Dresden	SN
Leipzig	SN
Oberfranken	BY
Mittelfranken	BY
Unterfranken	BY
Oberpfalz	BY
Schwaben	BY
Oberbayern	BY
Niederbayern	BY
Weser-Ems	NI
Lüneburg	NI
Braunschweig	NI
Hannover	NI
Arnsberg	NW
Detmold	NW
Düsseldorf	NW
Köln	NW
Münster	NW
Koblenz	RP
Rheinhessen-Pfalz	RP
Trier	RP
Darmstadt	HE
Giessen	HE
Kassel	HE
Freiburg	BW
Karlsruhe	BW
Stuttgart	BW
Tübingen	BW
Dessau	ST
Halle	ST
Magdeburg	ST
Chemnitz	SN
Dresden	SN
Leipzig	SN
Oberfranken	BY
Mittelfranken	BY
Unterfranken	BY
Oberpfalz	BY
Schwaben	BY
Oberbayern	BY
Niederbayern	BY
\.


--
-- Data for Name: fluss; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY fluss (name, "LängeInD", "Gesamtlänge") FROM stdin;
Agger	\N	\N
Ahr	89	89
Aller	263	263
Altmühl	225	225
Blies	\N	\N
Breg	\N	\N
Brenz	\N	\N
Brigach	\N	\N
Delme	\N	\N
Diemel	\N	\N
Donau	647	2850
Dreisam	\N	\N
Eder	\N	\N
Elbe	793	1165
Elde	208	208
Else	\N	\N
Elster, Schwarze	\N	\N
Elster, Weisse	\N	\N
Ems	371	371
Emscher	\N	\N
Enz	\N	\N
Erft	\N	\N
Fuhse	\N	\N
Fulda	154	154
Gera	\N	\N
Glan	68	68
Hase	\N	\N
Havel	343	343
Hunte	189	189
Iller	165	165
Ilm	\N	\N
Ilmenau	\N	\N
Inn	\N	510
Innerste	\N	\N
Isar	295	295
Jagst	196	196
Kinzig	82	82
Kocher	180	180
Lahn	\N	\N
Lauter	\N	\N
Lech	263	263
Leda	\N	\N
Leine	280	280
Lippe	255	255
llmenau	\N	\N
Main	524	524
Main, Roter	\N	\N
Main, Weisser	\N	\N
Mosel	\N	242
Mulde	\N	\N
Mulde, Freiberger	\N	\N
Mulde, Zwickauer	\N	\N
Naab	\N	\N
Nahe	116	116
Neckar	367	367
Neisse, Görlitzer	\N	225
Oder	162	860
Oker	105	105
Oste	\N	\N
Pegnitz	85	85
Rednitz	40	40
Regen	184	184
Regnitz	75	75
Rems	\N	\N
Rhein	865	1320
Ruhr	235	235
Rur	\N	207
Ryck	\N	\N
Saale	427	427
Saale, Fränkische	135	135
Saar	\N	\N
Sieg	130	130
Spree	382	382
Stör	\N	\N
Tauber	120	120
Unstrut	188	188
Vechte	\N	\N
Warnow	\N	\N
Werra	276	276
Werre	\N	\N
Weser	440	440
Wied	\N	\N
Wümme	\N	\N
Wupper	105	105
\.


--
-- Data for Name: fluss_durch_land; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY fluss_durch_land (fluss, land) FROM stdin;
Donau	BY
Donau	BW
Rhein	BW
Rhein	HE
Rhein	NW
Neckar	BW
Isar	BY
Inn	BY
Regen	BY
Altmühl	BY
Naab	BY
Lech	BY
Breg	BW
Brigach	BW
Donau	BY
Donau	BW
Rhein	BW
Rhein	HE
Rhein	NW
Neckar	BW
Isar	BY
Inn	BY
Regen	BY
Altmühl	BY
Naab	BY
Lech	BY
Breg	BW
Brigach	BW
Donau	BY
Donau	BW
Rhein	BW
Rhein	HE
Rhein	NW
Neckar	BW
Isar	BY
Inn	BY
Regen	BY
Altmühl	BY
Naab	BY
Lech	BY
Breg	BW
Brigach	BW
\.


--
-- Data for Name: fluss_entspringt_in_land; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY fluss_entspringt_in_land (fluss, ursprungsland) FROM stdin;
Neckar	BW
Dreisam	BW
Iller	BY
Altmühl	BY
Brigach	BW
Breg	BW
Neckar	BW
Dreisam	BW
Iller	BY
Altmühl	BY
Brigach	BW
Breg	BW
Neckar	BW
Dreisam	BW
Iller	BY
Altmühl	BY
Brigach	BW
Breg	BW
\.


--
-- Data for Name: fluss_entspringt_in_nachbarstaat; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY fluss_entspringt_in_nachbarstaat (fluss, nachbarstaat) FROM stdin;
Rhein	CH
Inn	A
Isar	A
Iller	A
Elbe	CZ
Mosel	F
Saar	F
Oder	PL
Rur	NL
Rhein	CH
Inn	A
Isar	A
Iller	A
Elbe	CZ
Mosel	F
Saar	F
Oder	PL
Rur	NL
Rhein	CH
Inn	A
Isar	A
Iller	A
Elbe	CZ
Mosel	F
Saar	F
Oder	PL
Rur	NL
\.


--
-- Data for Name: grenzfluss_international; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY grenzfluss_international (fluss, land, nachbarstaat) FROM stdin;
Oder	BB	PL
Oder	MV	PL
Neisse, Görlitzer	SN	PL
Inn	BY	A
Donau	BY	A
Rhein	BW	CH
Rhein	BW	F
Mosel	RP	L
Saar	SL	F
Oder	BB	PL
Oder	MV	PL
Neisse, Görlitzer	SN	PL
Inn	BY	A
Donau	BY	A
Rhein	BW	CH
Rhein	BW	F
Mosel	RP	L
Saar	SL	F
Oder	BB	PL
Oder	MV	PL
Neisse, Görlitzer	SN	PL
Inn	BY	A
Donau	BY	A
Rhein	BW	CH
Rhein	BW	F
Mosel	RP	L
Saar	SL	F
\.


--
-- Data for Name: grenzfluss_national; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY grenzfluss_national (fluss, land1, land2) FROM stdin;
Elbe	HH	NI
Elbe	SH	NI
Elbe	MV	NI
Elbe	NI	BB
Elbe	SH	BB
Elbe	SN	BB
Rhein	RP	HE
Rhein	RP	BW
Iller	BW	BY
Neckar	HE	BW
Main	HE	BY
Elbe	HH	NI
Elbe	SH	NI
Elbe	MV	NI
Elbe	NI	BB
Elbe	SH	BB
Elbe	SN	BB
Rhein	RP	HE
Rhein	RP	BW
Iller	BW	BY
Neckar	HE	BW
Main	HE	BY
Elbe	HH	NI
Elbe	SH	NI
Elbe	MV	NI
Elbe	NI	BB
Elbe	SH	BB
Elbe	SN	BB
Rhein	RP	HE
Rhein	RP	BW
Iller	BW	BY
Neckar	HE	BW
Main	HE	BY
\.


--
-- Data for Name: hafenstadt; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY hafenstadt (stadt, "Gewässer", typ) FROM stdin;
Flensburg	Ostsee	Seehafen
Wilhelmshaven	Nordsee	Seehafen
Cuxhaven	Nordsee	Seehafen
Rostock	Ostsee	Seehafen
Kiel	Ostsee	Seehafen
Stralsund	Ostsee	Seehafen
Lübeck	Ostsee	Seehafen
Friedrichshafen	Bodensee	Binnenhafen
Konstanz	Bodensee	Binnenhafen
Flensburg	Ostsee	Seehafen
Wilhelmshaven	Nordsee	Seehafen
Cuxhaven	Nordsee	Seehafen
Rostock	Ostsee	Seehafen
Kiel	Ostsee	Seehafen
Stralsund	Ostsee	Seehafen
Lübeck	Ostsee	Seehafen
Friedrichshafen	Bodensee	Binnenhafen
Konstanz	Bodensee	Binnenhafen
Flensburg	Ostsee	Seehafen
Wilhelmshaven	Nordsee	Seehafen
Cuxhaven	Nordsee	Seehafen
Rostock	Ostsee	Seehafen
Kiel	Ostsee	Seehafen
Stralsund	Ostsee	Seehafen
Lübeck	Ostsee	Seehafen
Friedrichshafen	Bodensee	Binnenhafen
Konstanz	Bodensee	Binnenhafen
\.


--
-- Data for Name: hauptstadt_von_bezirk; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY hauptstadt_von_bezirk (bezirk, hauptstadt) FROM stdin;
Weser-Ems	Oldenburg
Lüneburg	Lüneburg
Braunschweig	Braunschweig
Hannover	Hannover
Arnsberg	Arnsberg
Detmold	Detmold
Düsseldorf	Düsseldorf
Köln	Köln
Münster	Münster
Koblenz	Koblenz
Rheinhessen-Pfalz	Neustadt a.d.W.
Trier	Trier
Darmstadt	Darmstadt
Giessen	Giessen
Kassel	Kassel
Freiburg	Freiburg
Karlsruhe	Karlsruhe
Stuttgart	Stuttgart
Tübingen	Tübingen
Dessau	Dessau
Halle	Halle
Magdeburg	Magdeburg
Chemnitz	Chemnitz
Dresden	Dresden
Leipzig	Leipzig
Oberfranken	Bayreuth
Mittelfranken	Ansbach
Unterfranken	Würzburg
Oberpfalz	Regensburg
Schwaben	Augsburg
Oberbayern	München
Niederbayern	Landshut
Weser-Ems	Oldenburg
Lüneburg	Lüneburg
Braunschweig	Braunschweig
Hannover	Hannover
Arnsberg	Arnsberg
Detmold	Detmold
Düsseldorf	Düsseldorf
Köln	Köln
Münster	Münster
Koblenz	Koblenz
Rheinhessen-Pfalz	Neustadt a.d.W.
Trier	Trier
Darmstadt	Darmstadt
Giessen	Giessen
Kassel	Kassel
Freiburg	Freiburg
Karlsruhe	Karlsruhe
Stuttgart	Stuttgart
Tübingen	Tübingen
Dessau	Dessau
Halle	Halle
Magdeburg	Magdeburg
Chemnitz	Chemnitz
Dresden	Dresden
Leipzig	Leipzig
Oberfranken	Bayreuth
Mittelfranken	Ansbach
Unterfranken	Würzburg
Oberpfalz	Regensburg
Schwaben	Augsburg
Oberbayern	München
Niederbayern	Landshut
Weser-Ems	Oldenburg
Lüneburg	Lüneburg
Braunschweig	Braunschweig
Hannover	Hannover
Arnsberg	Arnsberg
Detmold	Detmold
Düsseldorf	Düsseldorf
Köln	Köln
Münster	Münster
Koblenz	Koblenz
Rheinhessen-Pfalz	Neustadt a.d.W.
Trier	Trier
Darmstadt	Darmstadt
Giessen	Giessen
Kassel	Kassel
Freiburg	Freiburg
Karlsruhe	Karlsruhe
Stuttgart	Stuttgart
Tübingen	Tübingen
Dessau	Dessau
Halle	Halle
Magdeburg	Magdeburg
Chemnitz	Chemnitz
Dresden	Dresden
Leipzig	Leipzig
Oberfranken	Bayreuth
Mittelfranken	Ansbach
Unterfranken	Würzburg
Oberpfalz	Regensburg
Schwaben	Augsburg
Oberbayern	München
Niederbayern	Landshut
\.


--
-- Data for Name: hauptstadt_von_land; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY hauptstadt_von_land (bundesland, hauptstadt) FROM stdin;
BE	Berlin
HB	Bremen
SN	Dresden
NW	Düsseldorf
TH	Erfurt
HH	Hamburg
NI	Hannover
SH	Kiel
ST	Magdeburg
RP	Mainz
BY	München
BB	Potsdam
SL	Saarbrücken
MV	Schwerin
BW	Stuttgart
HE	Wiesbaden
\.


--
-- Data for Name: kanal; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY kanal ("Kürzel", name, "Länge") FROM stdin;
MLK	Mittellandkanal	321
ESK	Elbe-Seitenkanal	113
DEK	Dortmund-Ems-Kanal	223
KüK	Küstenkanal	70
RHK	Rhein-Herne-Kanal	46
WDK	Weser-Datteln-Kanal	60
MDK	Main-Donau-Kanal	171
EHK	Elbe-Havel-Kanal	56
HvK	Havelkanal	35
ELK	Elbe-Lübeck-Kanal	62
DHK	Datteln-Hamm-Kanal	47
ESK	Elbe-Seitenkanal	115
EJK	Ems-Jade-Kanal	62
NOK	Nord-Ostsee-Kanal	99
TeK	Teltowkanal	36
WDK	Wesel-Datteln-Kanal	60
EFK	Elisabethfehnkanal	15
HOW	Havel-Oder-Wasserstrasse	150
SOW	Spree-Oder-Wasserstrasse	125
BSK	Berlin-Spandauer-Kanal	12
UHW	Untere Havel-Wasserstrasse	148
OHW	Obere Havel-Wasserstrasse	94
MHW	Müritz-Havel-Wasserstrasse	32
MEW	Müritz-Elde-Wasserstrasse	56
StW	Stör-Wasserstrasse	44
MLK	Mittellandkanal	321
ESK	Elbe-Seitenkanal	113
DEK	Dortmund-Ems-Kanal	223
KüK	Küstenkanal	70
RHK	Rhein-Herne-Kanal	46
WDK	Weser-Datteln-Kanal	60
MDK	Main-Donau-Kanal	171
EHK	Elbe-Havel-Kanal	56
HvK	Havelkanal	35
ELK	Elbe-Lübeck-Kanal	62
DHK	Datteln-Hamm-Kanal	47
ESK	Elbe-Seitenkanal	115
EJK	Ems-Jade-Kanal	62
NOK	Nord-Ostsee-Kanal	99
TeK	Teltowkanal	36
WDK	Wesel-Datteln-Kanal	60
EFK	Elisabethfehnkanal	15
HOW	Havel-Oder-Wasserstrasse	150
SOW	Spree-Oder-Wasserstrasse	125
BSK	Berlin-Spandauer-Kanal	12
UHW	Untere Havel-Wasserstrasse	148
OHW	Obere Havel-Wasserstrasse	94
MHW	Müritz-Havel-Wasserstrasse	32
MEW	Müritz-Elde-Wasserstrasse	56
StW	Stör-Wasserstrasse	44
MLK	Mittellandkanal	321
ESK	Elbe-Seitenkanal	113
DEK	Dortmund-Ems-Kanal	223
KüK	Küstenkanal	70
RHK	Rhein-Herne-Kanal	46
WDK	Weser-Datteln-Kanal	60
MDK	Main-Donau-Kanal	171
EHK	Elbe-Havel-Kanal	56
HvK	Havelkanal	35
ELK	Elbe-Lübeck-Kanal	62
DHK	Datteln-Hamm-Kanal	47
ESK	Elbe-Seitenkanal	115
EJK	Ems-Jade-Kanal	62
NOK	Nord-Ostsee-Kanal	99
TeK	Teltowkanal	36
WDK	Wesel-Datteln-Kanal	60
EFK	Elisabethfehnkanal	15
HOW	Havel-Oder-Wasserstrasse	150
SOW	Spree-Oder-Wasserstrasse	125
BSK	Berlin-Spandauer-Kanal	12
UHW	Untere Havel-Wasserstrasse	148
OHW	Obere Havel-Wasserstrasse	94
MHW	Müritz-Havel-Wasserstrasse	32
MEW	Müritz-Elde-Wasserstrasse	56
StW	Stör-Wasserstrasse	44
\.


--
-- Data for Name: kanal_durch_land; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY kanal_durch_land (kanal, land) FROM stdin;
DWK	NW
RHK	NW
DHK	NW
DEK	NW
DEK	NI
MLK	NW
MLK	NS
MLK	ST
NOK	SH
KüK	NI
EJK	NI
ELK	SH
ESK	NI
DWK	NW
RHK	NW
DHK	NW
DEK	NW
DEK	NI
MLK	NW
MLK	NS
MLK	ST
NOK	SH
KüK	NI
EJK	NI
ELK	SH
ESK	NI
DWK	NW
RHK	NW
DHK	NW
DEK	NW
DEK	NI
MLK	NW
MLK	NS
MLK	ST
NOK	SH
KüK	NI
EJK	NI
ELK	SH
ESK	NI
\.


--
-- Data for Name: kanal_verbindet_wasserstrassen; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY kanal_verbindet_wasserstrassen (kanal, wasserstrasse1, wasserstrasse2) FROM stdin;
KüK	Ems	Hunte
MDK	Main	Donau
ELK	Elbe	Trave
EHK	Elbe	Havel
MLK	DEK	Elbe
ESK	MLK	Elbe
RHK	DEK	Rhein
DEK	Ems	RHK
WDK	Rhein	DEK
EFK	Leda	KüK
SOW	Spree	Oder
HOW	Havel	Oder
MEW	Elbe	StW
BSK	HOW	SOW
TeK	Havel	SOW
HvK	UHW	HOW
KüK	Ems	Hunte
MDK	Main	Donau
ELK	Elbe	Trave
EHK	Elbe	Havel
MLK	DEK	Elbe
ESK	MLK	Elbe
RHK	DEK	Rhein
DEK	Ems	RHK
WDK	Rhein	DEK
EFK	Leda	KüK
SOW	Spree	Oder
HOW	Havel	Oder
MEW	Elbe	StW
BSK	HOW	SOW
TeK	Havel	SOW
HvK	UHW	HOW
KüK	Ems	Hunte
MDK	Main	Donau
ELK	Elbe	Trave
EHK	Elbe	Havel
MLK	DEK	Elbe
ESK	MLK	Elbe
RHK	DEK	Rhein
DEK	Ems	RHK
WDK	Rhein	DEK
EFK	Leda	KüK
SOW	Spree	Oder
HOW	Havel	Oder
MEW	Elbe	StW
BSK	HOW	SOW
TeK	Havel	SOW
HvK	UHW	HOW
\.


--
-- Data for Name: kreisstadt; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY kreisstadt (kfz, name) FROM stdin;
AC	Aachen
AA	Aalen
WAF	Ahlen
HSK	Arnsberg
AB	Aschaffenburg
A	Augsburg
HG	Bad Homburg
BAD	Baden-Baden
BA	Bamberg
BT	Bayreuth
BM	Bergheim
GL	Bergisch Gladbach
B	Berlin
BI	Bielefeld
BO	Bochum
BN	Bonn
BRB	Brandenburg
BS	Braunschweig
HB	Bremen
CE	Celle
C	Chemnitz
CB	Cottbus
CUX	Cuxhaven
DA	Darmstadt
DEL	Delmenhorst
DE	Dessau
LIP	Detmold
DO	Dortmund
DD	Dresden
DU	Duisburg
DN	Düren
D	Düsseldorf
EMD	Emden
EF	Erfurt
ER	Erlangen
E	Essen
ES	Esslingen
EU	Euskirchen
FL	Flensburg
F	Frankfurt
FF	Frankfurt/Oder
FR	Freiburg
FN	Friedrichshafen
FD	Fulda
FÜ	Fürth
GE	Gelsenkirchen
G	Gera
GI	Giessen
GP	Göppingen
GR	Görlitz
GÖ	Göttingen
GW	Greifswald
GM	Gummersbach
GT	Gütersloh
HA	Hagen
HAL	Halle
HH	Hamburg
HM	Hameln
HAM	Hamm
HN	Hanau
H	Hannover
HD	Heidelberg
HDH	Heidenheim
HN	Heilbronn
HF	Herford
HER	Herne
HI	Hildesheim
HO	Hof
HY	Hoyerswerda
IN	Ingolstadt
MK	Iserlohn
J	Jena
KL	Kaiserslautern
KA	Karlsruhe
KS	Kassel
KE	Kempten
KI	Kiel
KO	Koblenz
K	Köln
KN	Konstanz
KR	Krefeld
LA	Landshut
L	Leipzig
LEV	Leverkusen
EL	Lingen
HL	Lübeck
MK	Lüdenscheid
LB	Ludwigsburg
LU	Ludwigshafen
LG	Lüneburg
LN	Lünen
MD	Magdeburg
MZ	Mainz
MA	Mannheim
MR	Marburg
MI	Minden
MG	Mönchengladbach
MH	Mülheim
M	München
MS	Münster
NB	Neubrandenburg
NMS	Neumünster
NK	Neunkirchen
NE	Neuss
NW	Neustadt a.d. Weinstrasse
NU	Neu-Ulm
NR	Neuwied
NOH	Nordhorn
N	Nürnberg
OB	Oberhausen
OF	Offenbach
OG	Offenburg
OL	Oldenburg
OS	Osnabrück
PB	Paderborn
PA	Passau
PF	Pforzheim
PL	Plauen
P	Potsdam
RE	Recklinghausen
R	Regensburg
RS	Remscheid
RT	Reutlingen
ST	Rheine
RO	Rosenheim
HRO	Rostock
SB	Saarbrücken
SZ	Salzgitter
SW	Schweinfurt
SN	Schwerin
SI	Siegen
SG	Solingen
SP	Speyer
HST	Stralsund
S	Stuttgart
TR	Trier
TÜ	Tübingen
UL	Ulm
UN	Unna
VIE	Viersen
VS	Villingen-Schwennigen
WN	Waiblingen
WE	Weimar
WES	Wesel
LDK	Wetzlar
WI	Wiesbaden
WHV	Wilhelmshaven
EN	Witten
WF	Wolfenbüttel
WO	Worms
W	Wuppertal
WÜ	Würzburg
Z	Zwickau
\.


--
-- Data for Name: land; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY land (name, kurzform, einwohner, "Fläche") FROM stdin;
Brandenburg	BB	2590	29476
Berlin	BE	3339	890
Baden-Württemberg	BW	10462	35752
Bayern	BY	12087	70548
Bremen	HB	668	404
Hessen	HE	6035	21115
Hamburg	HH	1700	755
Mecklenburg-Vorpommern	MV	1799	23171
Niedersachsen	NI	7866	47614
Nordrhein_Westfalen	NW	17976	34080
Rheinland-Pfalz	RP	4025	19847
Schleswig-Holstein	SH	2766	15769
Saarland	SL	1074	2570
Sachsen	SN	4489	18412
Sachsen-Anhalt	ST	2674	20446
Thüringen	TH	2463	16171
\.


--
-- Data for Name: nachbarland_von; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY nachbarland_von (land1, land2) FROM stdin;
SH	MV
SH	HH
SH	NI
HB	NI
NI	NW
NI	HE
NI	BB
NI	ST
NI	TH
MV	BB
BB	BE
BB	ST
BB	SN
ST	SN
ST	TH
SN	TH
SN	BY
TH	BY
TH	HE
NW	HE
NW	RP
HE	BY
HE	RP
SL	RP
RP	BW
BY	BW
NI	HH
NI	MV
SH	MV
SH	HH
SH	NI
HB	NI
NI	NW
NI	HE
NI	BB
NI	ST
NI	TH
MV	BB
BB	BE
BB	ST
BB	SN
ST	SN
ST	TH
SN	TH
SN	BY
TH	BY
TH	HE
NW	HE
NW	RP
HE	BY
HE	RP
SL	RP
RP	BW
BY	BW
NI	HH
NI	MV
SH	MV
SH	HH
SH	NI
HB	NI
NI	NW
NI	HE
NI	BB
NI	ST
NI	TH
MV	BB
BB	BE
BB	ST
BB	SN
ST	SN
ST	TH
SN	TH
SN	BY
TH	BY
TH	HE
NW	HE
NW	RP
HE	BY
HE	RP
SL	RP
RP	BW
BY	BW
NI	HH
NI	MV
\.


--
-- Data for Name: nachbarstaat; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY nachbarstaat (staat, kennzeichen, vorwahl, "Grenzlänge mit D") FROM stdin;
Österreich	A	0043	815
Belgien	B	0032	156
Schweiz	CH	0041	316
Tschechische Republik	CZ	\N	811
Dänemark	DK	0045	67
Frankreich	F	0033	446
Luxemburg	L	00352	135
Niederlande	NL	0031	567
Polen	PL	0048	442
\.


--
-- Data for Name: nebenfluss_von; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY nebenfluss_von (fluss, nebenfluss, seite) FROM stdin;
Donau	Inn	rechts
Donau	Isar	rechts
Donau	Regen	links
Donau	Naab	links
Donau	Regen	links
Donau	Altmühl	links
Donau	Lech	rechts
Donau	Iller	rechts
Leine	Innerste	rechts
Rhein	Dreisam	rechts
Rhein	Neckar	rechts
Neckar	Kocher	rechts
Neckar	Jagst	rechts
Rhein	Main	rechts
Main	Kinzig	rechts
Main	Saale, Fränkische	rechts
Main	Tauber	links
Rhein	Lahn	rechts
Rhein	Nahe	links
Rhein	Ahr	links
Rhein	Mosel	links
Rhein	Erft	links
Rhein	Sieg	rechts
Rhein	Wupper	rechts
Rhein	Ruhr	rechts
Rhein	Lippe	rechts
Ems	Hase	rechts
Weser	Aller	rechts
Aller	Leine	links
Aller	Oker	links
Weser	Hunte	links
Elbe	Mulde	links
Elbe	Saale	links
Saale	Elster, Weisse	rechts
Saale	Unstrut	links
Elbe	Havel	rechts
Havel	Spree	links
Elbe	Elde	rechts
Oder	Neisse, Görlitzer	links
Elbe	Elster, Schwarze	rechts
Weser	Else	links
Else	Werre	rechts
Nahe	Glan	rechts
Lauter	Glan	rechts
Gera	Unstrut	rechts
Elbe	Ilmenau	links
Sieg	Agger	rechts
Rhein	Wied	rechts
Neckar	Rems	rechts
Saale	Ilm	links
Aller	Fuhse	links
Neckar	Enz	links
Saar	Blies	rechts
Ems	Leda	rechts
Weser	Wümme	rechts
Elbe	Oste	links
Fulda	Eder	links
Weser	Diemel	links
Donau	Inn	rechts
Donau	Isar	rechts
Donau	Regen	links
Donau	Naab	links
Donau	Regen	links
Donau	Altmühl	links
Donau	Lech	rechts
Donau	Iller	rechts
Leine	Innerste	rechts
Rhein	Dreisam	rechts
Rhein	Neckar	rechts
Neckar	Kocher	rechts
Neckar	Jagst	rechts
Rhein	Main	rechts
Main	Kinzig	rechts
Main	Saale, Fränkische	rechts
Main	Tauber	links
Rhein	Lahn	rechts
Rhein	Nahe	links
Rhein	Ahr	links
Rhein	Mosel	links
Rhein	Erft	links
Rhein	Sieg	rechts
Rhein	Wupper	rechts
Rhein	Ruhr	rechts
Rhein	Lippe	rechts
Ems	Hase	rechts
Weser	Aller	rechts
Aller	Leine	links
Aller	Oker	links
Weser	Hunte	links
Elbe	Mulde	links
Elbe	Saale	links
Saale	Elster, Weisse	rechts
Saale	Unstrut	links
Elbe	Havel	rechts
Havel	Spree	links
Elbe	Elde	rechts
Oder	Neisse, Görlitzer	links
Elbe	Elster, Schwarze	rechts
Weser	Else	links
Else	Werre	rechts
Nahe	Glan	rechts
Lauter	Glan	rechts
Gera	Unstrut	rechts
Elbe	Ilmenau	links
Sieg	Agger	rechts
Rhein	Wied	rechts
Neckar	Rems	rechts
Saale	Ilm	links
Aller	Fuhse	links
Neckar	Enz	links
Saar	Blies	rechts
Ems	Leda	rechts
Weser	Wümme	rechts
Elbe	Oste	links
Fulda	Eder	links
Weser	Diemel	links
Donau	Inn	rechts
Donau	Isar	rechts
Donau	Regen	links
Donau	Naab	links
Donau	Regen	links
Donau	Altmühl	links
Donau	Lech	rechts
Donau	Iller	rechts
Leine	Innerste	rechts
Rhein	Dreisam	rechts
Rhein	Neckar	rechts
Neckar	Kocher	rechts
Neckar	Jagst	rechts
Rhein	Main	rechts
Main	Kinzig	rechts
Main	Saale, Fränkische	rechts
Main	Tauber	links
Rhein	Lahn	rechts
Rhein	Nahe	links
Rhein	Ahr	links
Rhein	Mosel	links
Rhein	Erft	links
Rhein	Sieg	rechts
Rhein	Wupper	rechts
Rhein	Ruhr	rechts
Rhein	Lippe	rechts
Ems	Hase	rechts
Weser	Aller	rechts
Aller	Leine	links
Aller	Oker	links
Weser	Hunte	links
Elbe	Mulde	links
Elbe	Saale	links
Saale	Elster, Weisse	rechts
Saale	Unstrut	links
Elbe	Havel	rechts
Havel	Spree	links
Elbe	Elde	rechts
Oder	Neisse, Görlitzer	links
Elbe	Elster, Schwarze	rechts
Weser	Else	links
Else	Werre	rechts
Nahe	Glan	rechts
Lauter	Glan	rechts
Gera	Unstrut	rechts
Elbe	Ilmenau	links
Sieg	Agger	rechts
Rhein	Wied	rechts
Neckar	Rems	rechts
Saale	Ilm	links
Aller	Fuhse	links
Neckar	Enz	links
Saar	Blies	rechts
Ems	Leda	rechts
Weser	Wümme	rechts
Elbe	Oste	links
Fulda	Eder	links
Weser	Diemel	links
\.


--
-- Data for Name: quellfluss_von; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY quellfluss_von (quellfluss, fluss) FROM stdin;
Fulda	Weser
Werra	Weser
Pegnitz	Regnitz
Rednitz	Regnitz
Main, Weisser	Main
Main, Roter	Main
Mulde, Freiberger	Mulde
Mulde, Zwickauer	Mulde
Brigach	Donau
Breg	Donau
Fulda	Weser
Werra	Weser
Pegnitz	Regnitz
Rednitz	Regnitz
Main, Weisser	Main
Main, Roter	Main
Mulde, Freiberger	Mulde
Mulde, Zwickauer	Mulde
Brigach	Donau
Breg	Donau
Fulda	Weser
Werra	Weser
Pegnitz	Regnitz
Rednitz	Regnitz
Main, Weisser	Main
Main, Roter	Main
Mulde, Freiberger	Mulde
Mulde, Zwickauer	Mulde
Brigach	Donau
Breg	Donau
\.


--
-- Data for Name: stadt; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY stadt (kfz, name, einwohner) FROM stdin;
AC	Aachen	244
AA	Aalen	66
WAF	Ahlen	56
HSK	Arnsberg	77
AB	Aschaffenburg	68
A	Augsburg	255
HG	Bad Homburg	53
MI	Bad Oeynhausen	50
LIP	Bad Salzuflen	55
BAD	Baden-Baden	53
BA	Bamberg	69
BT	Bayreuth	74
BM	Bergheim	64
GL	Bergisch Gladbach	106
B	Berlin	3340
BI	Bielefeld	322
BOR	Bocholt	72
BO	Bochum	391
BN	Bonn	311
BRB	Brandenburg	78
BS	Braunschweig	246
HB	Bremen	539
HB	Bremerhaven	122
RE	Castrop-Rauxel	79
CE	Celle	72
C	Chemnitz	259
CB	Cottbus	108
CUX	Cuxhaven	53
DA	Darmstadt	138
DEL	Delmenhorst	77
DE	Dessau	83
LIP	Detmold	74
WES	Dinslaken	71
NE	Dormagen	63
RE	Dorsten	81
DO	Dortmund	589
DD	Dresden	478
DU	Duisburg	515
DN	Düren	92
D	Düsseldorf	569
EMD	Emden	51
BM	Erftstadt	51
EF	Erfurt	201
ER	Erlangen	101
AC	Eschweiler	55
E	Essen	595
ES	Esslingen	90
EU	Euskirchen	50
FL	Flensburg	84
F	Frankfurt	647
FF	Frankfurt/Oder	72
FR	Freiburg	205
FN	Friedrichshafen	57
FD	Fulda	63
FÜ	Fürth	110
H	Garbsen	63
GE	Gelsenkirchen	279
G	Gera	113
GI	Giessen	73
RE	Gladbeck	78
GP	Göppingen	57
GR	Görlitz	62
GÖ	Göttingen	124
GW	Greifswald	54
NE	Grevenbroich	65
GM	Gummersbach	53
GT	Gütersloh	95
HA	Hagen	203
HAL	Halle	248
HH	Hamburg	1715
HM	Hameln	59
HAM	Hamm	182
HN	Hanau	88
H	Hannover	515
EN	Hattingen	58
HD	Heidelberg	140
HDH	Heidenheim	51
HN	Heilbronn	119
HF	Herford	65
HER	Herne	175
RE	Herten	67
ME	Hilden	56
HI	Hildesheim	104
HO	Hof	51
HY	Hoyerswerda	50
BM	Hürth	53
IN	Ingolstadt	116
MK	Iserlohn	99
J	Jena	100
KL	Kaiserslautern	100
KA	Karlsruhe	279
KS	Kassel	195
KE	Kempten	61
BM	Kerpen	63
KI	Kiel	233
KO	Koblenz	108
K	Köln	963
KN	Konstanz	79
KR	Krefeld	240
LA	Landshut	59
ME	Langenfeld	58
L	Leipzig	493
LEV	Leverkusen	161
EL	Lingen	52
SO	Lippstadt	67
HL	Lübeck	213
MK	Lüdenscheid	81
LB	Ludwigsburg	87
LU	Ludwigshafen	162
LG	Lüneburg	67
LN	Lünen	92
MD	Magdeburg	231
MZ	Mainz	183
MA	Mannheim	307
MR	Marburg	77
RE	Marl	93
NE	Meerbusch	55
MK	Menden	59
MI	Minden	83
WES	Moers	104
MG	Mönchengladbach	263
MH	Mülheim	173
M	München	1210
MS	Münster	265
NB	Neubrandenburg	73
NMS	Neumünster	80
NK	Neunkirchen	51
NE	Neuss	150
NW	Neustadt a.d. Weinstrasse	54
NU	Neu-Ulm	50
NR	Neuwied	67
SE	Norderstedt	72
NOH	Nordhorn	52
N	Nürnberg	488
OB	Oberhausen	222
OF	Offenbach	118
OG	Offenburg	57
OL	Oldenburg	155
OS	Osnabrück	164
PB	Paderborn	139
PA	Passau	51
PF	Pforzheim	117
PL	Plauen	72
P	Potsdam	129
BM	Pulheim	53
ME	Ratingen	91
RE	Recklinghausen	125
R	Regensburg	126
RS	Remscheid	119
RT	Reutlingen	111
ST	Rheine	76
RO	Rosenheim	59
HRO	Rostock	201
GG	Rüsselsheim	59
SB	Saarbrücken	183
SZ	Salzgitter	112
AA	Schwäbisch Gmünd	62
SW	Schweinfurt	54
SN	Schwerin	101
UN	Schwerte	51
SI	Siegen	108
BB	Sindelfingen	61
SG	Solingen	165
SP	Speyer	50
SU	St. Augustin	55
AC	Stolberg	59
HST	Stralsund	61
S	Stuttgart	584
TR	Trier	99
SU	Troisdorf	73
TÜ	Tübingen	81
UL	Ulm	117
UN	Unna	71
ME	Velbert	90
VIE	Viersen	77
VS	Villingen-Schwennigen	81
WN	Waiblingen	52
WE	Weimar	62
WES	Wesel	62
LDK	Wetzlar	53
WI	Wiesbaden	270
WHV	Wilhelmshaven	85
VIE	Willich	50
EN	Witten	103
WF	Wolfenbüttel	55
WO	Worms	80
W	Wuppertal	366
WÜ	Würzburg	128
Z	Zwickau	103
\.


--
-- Data for Name: stadt_an_fluss; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY stadt_an_fluss (stadt, fluss) FROM stdin;
Köln	Rhein
Bonn	Rhein
Düsseldorf	Rhein
Duisburg	Rhein
Koblenz	Rhein
Mannheim	Rhein
Karlsruhe	Rhein
Bremen	Weser
Bremerhaven	Weser
Hamburg	Elbe
Magdeburg	Elbe
Dessau	Elbe
Dresden	Elbe
Stuttgart	Neckar
Mainz	Main
Frankfurt	Main
Würzburg	Main
Trier	Mosel
Koblenz	Mosel
Regensburg	Donau
Ludwigshafen	Rhein
Mainz	Rhein
Wiesbaden	Rhein
Offenbach	Main
Heidelberg	Neckar
Heilbronn	Neckar
Ulm	Donau
München	Isar
Regensburg	Regen
Augsburg	Lech
Halle	Saale
Jena	Saale
Berlin	Havel
Berlin	Spree
Cottbus	Spree
Oldenburg	Hunte
Osnabrück	Hase
Hannover	Leine
Braunschweig	Oker
Kassel	Fulda
Göttingen	Leine
Saarbrücken	Saar
Leverkusen	Rhein
Neuss	Rhein
Oberhausen	Rhein
Krefeld	Rhein
Bochum	Ruhr
Witten	Ruhr
Essen	Ruhr
Mülheim	Ruhr
Duisburg	Ruhr
Oberhausen	Ruhr
Bonn	Sieg
Siegen	Sieg
Nürnberg	Pegnitz
Nürnberg	Rednitz
Fürth	Rednitz
Fürth	Regnitz
Erlangen	Regnitz
Hildesheim	Innerste
Leipzig	Elster, Weisse
Gera	Elster, Weisse
Zwickau	Mulde, Zwickauer
Koblenz	Lahn
Arnsberg	Ruhr
Aschaffenburg	Main
Bamberg	Regnitz
Bayreuth	Main, Roter
Bergheim	Erft
Brandenburg	Havel
Celle	Aller
Cuxhaven	Elbe
Delmenhorst	Delme
Dinslaken	Rhein
Dorsten	Lippe
Dortmund	Emscher
Düren	Rur
Emden	Ems
Erftstadt	Erft
Erfurt	Gera
Esslingen	Neckar
Euskirchen	Erft
Frankfurt/Oder	Oder
Freiburg	Dreisam
Gelsenkirchen	Emscher
Giessen	Lahn
Wesel	Lippe
Detmold	Werre
Dormagen	Rhein
Neuwied	Wied
Troisdorf	Agger
Greifswald	Ryck
Görlitz	Neisse, Görlitzer
Grevenbroich	Erft
Hagen	Ruhr
Hameln	Weser
Hamm	Lippe
Hanau	Main
Hattingen	Ruhr
Heidenheim	Brenz
Herford	Werre
Hof	Saale
Hoyerswerda	Elster, Schwarze
Kaiserslautern	Lauter
Lübeck	\N
Moers	\N
Mönchengladbach	\N
Münster	\N
Paderborn	Lippe
Pforzheim	Enz
Potsdam	Havel
Remscheid	Wupper
Rostock	Warnow
Salzgitter	Fuhse
Solingen	Wupper
St. Augustin	Sieg
Wuppertal	Wupper
Menden	\N
Kempten	Iller
Konstanz	Rhein
Wetzlar	Lahn
Landshut	Isar
Lingen	Ems
Lippstadt	Lippe
Ludwigsburg	Neckar
Lüdenscheid	\N
Lüneburg	Ilmenau
Lünen	Lippe
Marburg	Lahn
Meerbusch	Rhein
Minden	Weser
Neubrandenburg	\N
Neumünster	Stör
Neunkirchen	Blies
Neustadt a.d. Weinstrasse	\N
Neu-Ulm	Donau
Neuwied	Rhein
Nordhorn	Vechte
Bad Oeynhausen	\N
Offenburg	Kinzig
Passau	Donau
Plauen	Elster, Weisse
Rheine	Ems
Rosenheim	Inn
Rüsselsheim	Main
Bad Salzuflen	Werre
Schwäbisch Gmünd	Rems
Schweinfurt	Main
Schwerte	Ruhr
Speyer	Rhein
Troisdorf	Sieg
Tübingen	Neckar
Viersen	\N
Villingen-Schwennigen	Brigach
Waiblingen	Rems
Weimar	Ilm
Wesel	Rhein
Willich	\N
Wolfenbüttel	Oker
Worms	Rhein
Fulda	Fulda
Ingolstadt	Donau
Köln	Rhein
Bonn	Rhein
Düsseldorf	Rhein
Duisburg	Rhein
Koblenz	Rhein
Mannheim	Rhein
Karlsruhe	Rhein
Bremen	Weser
Bremerhaven	Weser
Hamburg	Elbe
Magdeburg	Elbe
Dessau	Elbe
Dresden	Elbe
Stuttgart	Neckar
Mainz	Main
Frankfurt	Main
Würzburg	Main
Trier	Mosel
Koblenz	Mosel
Regensburg	Donau
Ludwigshafen	Rhein
Mainz	Rhein
Wiesbaden	Rhein
Offenbach	Main
Heidelberg	Neckar
Heilbronn	Neckar
Ulm	Donau
München	Isar
Regensburg	Regen
Augsburg	Lech
Halle	Saale
Jena	Saale
Berlin	Havel
Berlin	Spree
Cottbus	Spree
Oldenburg	Hunte
Osnabrück	Hase
Hannover	Leine
Braunschweig	Oker
Kassel	Fulda
Göttingen	Leine
Saarbrücken	Saar
Leverkusen	Rhein
Neuss	Rhein
Oberhausen	Rhein
Krefeld	Rhein
Bochum	Ruhr
Witten	Ruhr
Essen	Ruhr
Mülheim	Ruhr
Duisburg	Ruhr
Oberhausen	Ruhr
Bonn	Sieg
Siegen	Sieg
Nürnberg	Pegnitz
Nürnberg	Rednitz
Fürth	Rednitz
Fürth	Regnitz
Erlangen	Regnitz
Hildesheim	Innerste
Leipzig	Elster, Weisse
Gera	Elster, Weisse
Zwickau	Mulde, Zwickauer
Koblenz	Lahn
Arnsberg	Ruhr
Aschaffenburg	Main
Bamberg	Regnitz
Bayreuth	Main, Roter
Bergheim	Erft
Brandenburg	Havel
Celle	Aller
Cuxhaven	Elbe
Delmenhorst	Delme
Dinslaken	Rhein
Dorsten	Lippe
Dortmund	Emscher
Düren	Rur
Emden	Ems
Erftstadt	Erft
Erfurt	Gera
Esslingen	Neckar
Euskirchen	Erft
Frankfurt/Oder	Oder
Freiburg	Dreisam
Gelsenkirchen	Emscher
Giessen	Lahn
Wesel	Lippe
Detmold	Werre
Dormagen	Rhein
Neuwied	Wied
Troisdorf	Agger
Greifswald	Ryck
Görlitz	Neisse, Görlitzer
Grevenbroich	Erft
Hagen	Ruhr
Hameln	Weser
Hamm	Lippe
Hanau	Main
Hattingen	Ruhr
Heidenheim	Brenz
Herford	Werre
Hof	Saale
Hoyerswerda	Elster, Schwarze
Kaiserslautern	Lauter
Lübeck	\N
Moers	\N
Mönchengladbach	\N
Münster	\N
Paderborn	Lippe
Pforzheim	Enz
Potsdam	Havel
Remscheid	Wupper
Rostock	Warnow
Salzgitter	Fuhse
Solingen	Wupper
St. Augustin	Sieg
Wuppertal	Wupper
Menden	\N
Kempten	Iller
Konstanz	Rhein
Wetzlar	Lahn
Landshut	Isar
Lingen	Ems
Lippstadt	Lippe
Ludwigsburg	Neckar
Lüdenscheid	\N
Lüneburg	Ilmenau
Lünen	Lippe
Marburg	Lahn
Meerbusch	Rhein
Minden	Weser
Neubrandenburg	\N
Neumünster	Stör
Neunkirchen	Blies
Neustadt a.d. Weinstrasse	\N
Neu-Ulm	Donau
Neuwied	Rhein
Nordhorn	Vechte
Bad Oeynhausen	\N
Offenburg	Kinzig
Passau	Donau
Plauen	Elster, Weisse
Rheine	Ems
Rosenheim	Inn
Rüsselsheim	Main
Bad Salzuflen	Werre
Schwäbisch Gmünd	Rems
Schweinfurt	Main
Schwerte	Ruhr
Speyer	Rhein
Troisdorf	Sieg
Tübingen	Neckar
Viersen	\N
Villingen-Schwennigen	Brigach
Waiblingen	Rems
Weimar	Ilm
Wesel	Rhein
Willich	\N
Wolfenbüttel	Oker
Worms	Rhein
Fulda	Fulda
Ingolstadt	Donau
Köln	Rhein
Bonn	Rhein
Düsseldorf	Rhein
Duisburg	Rhein
Koblenz	Rhein
Mannheim	Rhein
Karlsruhe	Rhein
Bremen	Weser
Bremerhaven	Weser
Hamburg	Elbe
Magdeburg	Elbe
Dessau	Elbe
Dresden	Elbe
Stuttgart	Neckar
Mainz	Main
Frankfurt	Main
Würzburg	Main
Trier	Mosel
Koblenz	Mosel
Regensburg	Donau
Ludwigshafen	Rhein
Mainz	Rhein
Wiesbaden	Rhein
Offenbach	Main
Heidelberg	Neckar
Heilbronn	Neckar
Ulm	Donau
München	Isar
Regensburg	Regen
Augsburg	Lech
Halle	Saale
Jena	Saale
Berlin	Havel
Berlin	Spree
Cottbus	Spree
Oldenburg	Hunte
Osnabrück	Hase
Hannover	Leine
Braunschweig	Oker
Kassel	Fulda
Göttingen	Leine
Saarbrücken	Saar
Leverkusen	Rhein
Neuss	Rhein
Oberhausen	Rhein
Krefeld	Rhein
Bochum	Ruhr
Witten	Ruhr
Essen	Ruhr
Mülheim	Ruhr
Duisburg	Ruhr
Oberhausen	Ruhr
Bonn	Sieg
Siegen	Sieg
Nürnberg	Pegnitz
Nürnberg	Rednitz
Fürth	Rednitz
Fürth	Regnitz
Erlangen	Regnitz
Hildesheim	Innerste
Leipzig	Elster, Weisse
Gera	Elster, Weisse
Zwickau	Mulde, Zwickauer
Koblenz	Lahn
Arnsberg	Ruhr
Aschaffenburg	Main
Bamberg	Regnitz
Bayreuth	Main, Roter
Bergheim	Erft
Brandenburg	Havel
Celle	Aller
Cuxhaven	Elbe
Delmenhorst	Delme
Dinslaken	Rhein
Dorsten	Lippe
Dortmund	Emscher
Düren	Rur
Emden	Ems
Erftstadt	Erft
Erfurt	Gera
Esslingen	Neckar
Euskirchen	Erft
Frankfurt/Oder	Oder
Freiburg	Dreisam
Gelsenkirchen	Emscher
Giessen	Lahn
Wesel	Lippe
Detmold	Werre
Dormagen	Rhein
Neuwied	Wied
Troisdorf	Agger
Greifswald	Ryck
Görlitz	Neisse, Görlitzer
Grevenbroich	Erft
Hagen	Ruhr
Hameln	Weser
Hamm	Lippe
Hanau	Main
Hattingen	Ruhr
Heidenheim	Brenz
Herford	Werre
Hof	Saale
Hoyerswerda	Elster, Schwarze
Kaiserslautern	Lauter
Lübeck	\N
Moers	\N
Mönchengladbach	\N
Münster	\N
Paderborn	Lippe
Pforzheim	Enz
Potsdam	Havel
Remscheid	Wupper
Rostock	Warnow
Salzgitter	Fuhse
Solingen	Wupper
St. Augustin	Sieg
Wuppertal	Wupper
Menden	\N
Kempten	Iller
Konstanz	Rhein
Wetzlar	Lahn
Landshut	Isar
Lingen	Ems
Lippstadt	Lippe
Ludwigsburg	Neckar
Lüdenscheid	\N
Lüneburg	Ilmenau
Lünen	Lippe
Marburg	Lahn
Meerbusch	Rhein
Minden	Weser
Neubrandenburg	\N
Neumünster	Stör
Neunkirchen	Blies
Neustadt a.d. Weinstrasse	\N
Neu-Ulm	Donau
Neuwied	Rhein
Nordhorn	Vechte
Bad Oeynhausen	\N
Offenburg	Kinzig
Passau	Donau
Plauen	Elster, Weisse
Rheine	Ems
Rosenheim	Inn
Rüsselsheim	Main
Bad Salzuflen	Werre
Schwäbisch Gmünd	Rems
Schweinfurt	Main
Schwerte	Ruhr
Speyer	Rhein
Troisdorf	Sieg
Tübingen	Neckar
Viersen	\N
Villingen-Schwennigen	Brigach
Waiblingen	Rems
Weimar	Ilm
Wesel	Rhein
Willich	\N
Wolfenbüttel	Oker
Worms	Rhein
Fulda	Fulda
Ingolstadt	Donau
\.


--
-- Data for Name: stadt_an_kanal; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY stadt_an_kanal (stadt, kanal) FROM stdin;
Herne	RHK
Dortmund	DEK
Hamm	DHK
Duisburg	RHK
Oberhausen	RHK
Gelsenkirchen	RHK
Magdeburg	MLK
Wolfsburg	MLK
Braunschweig	MLK
Hannover	MLK
Salzgitter	MLK
Hildesheim	MLK
Minden	MLK
Osnabrück	MLK
Oldenburg	KüK
Wilhelmshaven	EJK
Emden	EJK
Lübeck	ELK
Kiel	NOK
Münster	DEK
Berlin	TeK
Potsdam	TeK
Berlin	BSK
Berlin	SOW
Berlin	HOW
Berlin	UHW
Berlin	OHW
Herne	RHK
Dortmund	DEK
Hamm	DHK
Duisburg	RHK
Oberhausen	RHK
Gelsenkirchen	RHK
Magdeburg	MLK
Wolfsburg	MLK
Braunschweig	MLK
Hannover	MLK
Salzgitter	MLK
Hildesheim	MLK
Minden	MLK
Osnabrück	MLK
Oldenburg	KüK
Wilhelmshaven	EJK
Emden	EJK
Lübeck	ELK
Kiel	NOK
Münster	DEK
Berlin	TeK
Potsdam	TeK
Berlin	BSK
Berlin	SOW
Berlin	HOW
Berlin	UHW
Berlin	OHW
Herne	RHK
Dortmund	DEK
Hamm	DHK
Duisburg	RHK
Oberhausen	RHK
Gelsenkirchen	RHK
Magdeburg	MLK
Wolfsburg	MLK
Braunschweig	MLK
Hannover	MLK
Salzgitter	MLK
Hildesheim	MLK
Minden	MLK
Osnabrück	MLK
Oldenburg	KüK
Wilhelmshaven	EJK
Emden	EJK
Lübeck	ELK
Kiel	NOK
Münster	DEK
Berlin	TeK
Potsdam	TeK
Berlin	BSK
Berlin	SOW
Berlin	HOW
Berlin	UHW
Berlin	OHW
\.


--
-- Data for Name: stadt_flaeche; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY stadt_flaeche (name, "Fläche") FROM stdin;
Aachen	160
Augsburg	146
Bergisch Gladbach	83
Berlin	891
Bielefeld	257
Bochum	145
Bonn	141
Braunschweig	192
Bremen	326
Bremerhaven	77
Chemnitz	220
Cottbus	150
Darmstadt	122
Dessau	147
Dortmund	280
Dresden	328
Duisburg	232
Düsseldorf	217
Erfurt	269
Erlangen	76
Essen	210
Frankfurt	248
Freiburg	153
Gelsenkirchen	104
Gera	151
Göttingen	116
Hagen	160
Halle	134
Hamburg	755
Hamm	226
Hannover	204
Heidelberg	108
Heilbronn	99
Hildesheim	92
Jena	114
Kaiserslautern	139
Karlsruhe	173
Kassel	106
Kiel	118
Koblenz	105
Köln	405
Krefeld	137
Leipzig	297
Leverkusen	78
Lübeck	214
Ludwigshafen	77
Magdeburg	200
Mainz	97
Mannheim	144
Moers	67
Mönchengladbach	177
München	310
Münster	302
Neuss	99
Nürnberg	186
Oberhausen	77
Offenbach	44
Oldenburg	102
Osnabrück	119
Paderborn	179
Pforzheim	97
Potsdam	109
Recklinghausen	66
Regensburg	80
Remscheid	74
Reutlingen	87
Rostock	180
Saarbrücken	167
Salzgitter	223
Schwerin	130
Siegen	114
Solingen	89
Stuttgart	207
Trier	117
Ulm	118
Wiesbaden	203
Witten	72
Wuppertal	168
Würzburg	87
Zwickau	102
\.


--
-- Data for Name: stadt_in_land; Type: TABLE DATA; Schema: stadtlandfluss; Owner: postgres
--

COPY stadt_in_land (stadt, land) FROM stdin;
Aachen	NW
Aalen	BW
Ahlen	NW
Arnsberg	NW
Aschaffenburg	BY
Augsburg	BY
Bad Homburg	HE
Bad Oeynhausen	NW
Bad Salzuflen	NW
Baden-Baden	BW
Bamberg	BY
Bayreuth	BY
Bergheim	NW
Bergisch Gladbach	NW
Berlin	BE
Bielefeld	NW
Bocholt	NW
Bochum	NW
Bonn	NW
Brandenburg	BB
Braunschweig	NI
Bremen	HB
Bremerhaven	HB
Castrop-Rauxel	NW
Celle	NI
Chemnitz	SN
Cottbus	BB
Cuxhaven	NI
Darmstadt	HE
Delmenhorst	NI
Dessau	ST
Detmold	NW
Dinslaken	NW
Dormagen	NW
Dorsten	NW
Dortmund	NW
Dresden	SN
Duisburg	NW
Düren	NW
Düsseldorf	NW
Emden	NI
Erftstadt	NW
Erfurt	TH
Erlangen	BY
Eschweiler	NW
Essen	NW
Esslingen	BW
Euskirchen	NW
Flensburg	SH
Frankfurt	HE
Frankfurt/Oder	BB
Freiburg	BW
Friedrichshafen	BW
Fulda	HE
Fürth	BY
Garbsen	NI
Gelsenkirchen	NW
Gera	TH
Giessen	HE
Gladbeck	NW
Göppingen	BW
Görlitz	SN
Göttingen	NI
Greifswald	MV
Grevenbroich	NW
Gummersbach	NW
Gütersloh	NW
Hagen	NW
Halle	ST
Hamburg	HH
Hameln	NI
Hamm	NW
Hanau	HE
Hannover	NI
Hattingen	BW
Heidelberg	BW
Heidenheim	BW
Heilbronn	BW
Herford	NW
Herne	NW
Herten	NW
Hilden	NW
Hildesheim	NI
Hof	BY
Hoyerswerda	MV
Hürth	NW
Ingolstadt	BY
Iserlohn	NW
Jena	TH
Kaiserslautern	RP
Karlsruhe	BW
Kassel	HE
Kempten	BY
Kerpen	NW
Kiel	SH
Koblenz	RP
Köln	NW
Konstanz	BW
Krefeld	NW
Landshut	BY
Langenfeld	NW
Leipzig	SN
Leverkusen	NW
Lingen	NI
Lippstadt	NW
Lübeck	SH
Lüdenscheid	NW
Ludwigsburg	BW
Ludwigshafen	RP
Lüneburg	NI
Lünen	NW
Magdeburg	ST
Mainz	RP
Mannheim	BW
Marburg	HE
Marl	NW
Meerbusch	NW
Menden	NW
Minden	NW
Moers	NW
Mönchengladbach	NW
Mülheim	NW
München	BY
Münster	NW
Neubrandenburg	MV
Neumünster	SH
Neunkirchen	SL
Neuss	NW
Neustadt a.d. Weinstrasse	RP
Neu-Ulm	BY
Neuwied	RP
Norderstedt	SH
Nordhorn	NI
Nürnberg	BY
Oberhausen	NW
Offenbach	HE
Offenburg	BW
Oldenburg	NI
Osnabrück	NI
Paderborn	NW
Passau	BY
Pforzheim	BW
Plauen	SN
Potsdam	BB
Pulheim	NW
Ratingen	NW
Recklinghausen	NW
Regensburg	BY
Remscheid	NW
Reutlingen	BW
Rheine	NW
Rosenheim	BY
Rostock	MV
Rüsselsheim	HE
Saarbrücken	SL
Salzgitter	NI
Schwäbisch Gmünd	BW
Schweinfurt	BY
Schwerin	MV
Schwerte	NW
Siegen	NW
Sindelfingen	BW
Solingen	NW
Speyer	RP
St. Augustin	NW
Stolberg	NW
Stralsund	MV
Stuttgart	BW
Trier	RP
Troisdorf	NW
Tübingen	BW
Ulm	BW
Unna	NW
Velbert	NW
Viersen	NW
Villingen-Schwennigen	BW
Waiblingen	BW
Weimar	TH
Wesel	NW
Wetzlar	HE
Wiesbaden	HE
Wilhelmshaven	NI
Willich	NW
Witten	NW
Wolfenbüttel	NI
Worms	RP
Wuppertal	NW
Würzburg	BY
Zwickau	SN
\.


--
-- Name: bezirk_pkey; Type: CONSTRAINT; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bezirk
    ADD CONSTRAINT bezirk_pkey PRIMARY KEY (name);


--
-- Name: fluss_pkey; Type: CONSTRAINT; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fluss
    ADD CONSTRAINT fluss_pkey PRIMARY KEY (name);


--
-- Name: hauptstadt_von_land_pkey; Type: CONSTRAINT; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY hauptstadt_von_land
    ADD CONSTRAINT hauptstadt_von_land_pkey PRIMARY KEY (hauptstadt);


--
-- Name: kreisstadt_pkey; Type: CONSTRAINT; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY kreisstadt
    ADD CONSTRAINT kreisstadt_pkey PRIMARY KEY (name);


--
-- Name: land_pkey; Type: CONSTRAINT; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY land
    ADD CONSTRAINT land_pkey PRIMARY KEY (kurzform);


--
-- Name: nachbarstaat_pkey; Type: CONSTRAINT; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY nachbarstaat
    ADD CONSTRAINT nachbarstaat_pkey PRIMARY KEY (kennzeichen);


--
-- Name: stadt_fläche_pkey; Type: CONSTRAINT; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stadt_flaeche
    ADD CONSTRAINT "stadt_fläche_pkey" PRIMARY KEY (name);


--
-- Name: stadt_in_land_pkey; Type: CONSTRAINT; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stadt_in_land
    ADD CONSTRAINT stadt_in_land_pkey PRIMARY KEY (stadt);


--
-- Name: stadt_pkey; Type: CONSTRAINT; Schema: stadtlandfluss; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stadt
    ADD CONSTRAINT stadt_pkey PRIMARY KEY (name);


--
-- Name: stadtlandfluss; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA stadtlandfluss FROM PUBLIC;
REVOKE ALL ON SCHEMA stadtlandfluss FROM postgres;
GRANT ALL ON SCHEMA stadtlandfluss TO postgres;


--
-- Name: bezirk; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE bezirk FROM PUBLIC;
REVOKE ALL ON TABLE bezirk FROM postgres;
GRANT ALL ON TABLE bezirk TO postgres;


--
-- Name: bezirk_in_land; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE bezirk_in_land FROM PUBLIC;
REVOKE ALL ON TABLE bezirk_in_land FROM postgres;
GRANT ALL ON TABLE bezirk_in_land TO postgres;


--
-- Name: fluss; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE fluss FROM PUBLIC;
REVOKE ALL ON TABLE fluss FROM postgres;
GRANT ALL ON TABLE fluss TO postgres;


--
-- Name: fluss_durch_land; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE fluss_durch_land FROM PUBLIC;
REVOKE ALL ON TABLE fluss_durch_land FROM postgres;
GRANT ALL ON TABLE fluss_durch_land TO postgres;


--
-- Name: fluss_entspringt_in_land; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE fluss_entspringt_in_land FROM PUBLIC;
REVOKE ALL ON TABLE fluss_entspringt_in_land FROM postgres;
GRANT ALL ON TABLE fluss_entspringt_in_land TO postgres;


--
-- Name: fluss_entspringt_in_nachbarstaat; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE fluss_entspringt_in_nachbarstaat FROM PUBLIC;
REVOKE ALL ON TABLE fluss_entspringt_in_nachbarstaat FROM postgres;
GRANT ALL ON TABLE fluss_entspringt_in_nachbarstaat TO postgres;


--
-- Name: nebenfluss_von; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE nebenfluss_von FROM PUBLIC;
REVOKE ALL ON TABLE nebenfluss_von FROM postgres;
GRANT ALL ON TABLE nebenfluss_von TO postgres;


--
-- Name: quellfluss_von; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE quellfluss_von FROM PUBLIC;
REVOKE ALL ON TABLE quellfluss_von FROM postgres;
GRANT ALL ON TABLE quellfluss_von TO postgres;


--
-- Name: fluss_mündet_in; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE "fluss_mündet_in" FROM PUBLIC;
REVOKE ALL ON TABLE "fluss_mündet_in" FROM postgres;
GRANT ALL ON TABLE "fluss_mündet_in" TO postgres;


--
-- Name: grenzfluss_international; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE grenzfluss_international FROM PUBLIC;
REVOKE ALL ON TABLE grenzfluss_international FROM postgres;
GRANT ALL ON TABLE grenzfluss_international TO postgres;


--
-- Name: grenzfluss_national; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE grenzfluss_national FROM PUBLIC;
REVOKE ALL ON TABLE grenzfluss_national FROM postgres;
GRANT ALL ON TABLE grenzfluss_national TO postgres;


--
-- Name: stadt; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE stadt FROM PUBLIC;
REVOKE ALL ON TABLE stadt FROM postgres;
GRANT ALL ON TABLE stadt TO postgres;


--
-- Name: großstadt; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE "großstadt" FROM PUBLIC;
REVOKE ALL ON TABLE "großstadt" FROM postgres;
GRANT ALL ON TABLE "großstadt" TO postgres;


--
-- Name: stadt_in_land; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE stadt_in_land FROM PUBLIC;
REVOKE ALL ON TABLE stadt_in_land FROM postgres;
GRANT ALL ON TABLE stadt_in_land TO postgres;


--
-- Name: größe_der_größten_stadt_im_land; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE "größe_der_größten_stadt_im_land" FROM PUBLIC;
REVOKE ALL ON TABLE "größe_der_größten_stadt_im_land" FROM postgres;
GRANT ALL ON TABLE "größe_der_größten_stadt_im_land" TO postgres;


--
-- Name: größte_stadt_im_land; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE "größte_stadt_im_land" FROM PUBLIC;
REVOKE ALL ON TABLE "größte_stadt_im_land" FROM postgres;
GRANT ALL ON TABLE "größte_stadt_im_land" TO postgres;


--
-- Name: hauptstadt_von_land; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE hauptstadt_von_land FROM PUBLIC;
REVOKE ALL ON TABLE hauptstadt_von_land FROM postgres;
GRANT ALL ON TABLE hauptstadt_von_land TO postgres;


--
-- Name: größte_stadt_nicht_hauptstadt; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE "größte_stadt_nicht_hauptstadt" FROM PUBLIC;
REVOKE ALL ON TABLE "größte_stadt_nicht_hauptstadt" FROM postgres;
GRANT ALL ON TABLE "größte_stadt_nicht_hauptstadt" TO postgres;


--
-- Name: hafenstadt; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE hafenstadt FROM PUBLIC;
REVOKE ALL ON TABLE hafenstadt FROM postgres;
GRANT ALL ON TABLE hafenstadt TO postgres;


--
-- Name: hauptstadt_von_bezirk; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE hauptstadt_von_bezirk FROM PUBLIC;
REVOKE ALL ON TABLE hauptstadt_von_bezirk FROM postgres;
GRANT ALL ON TABLE hauptstadt_von_bezirk TO postgres;


--
-- Name: kanal; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE kanal FROM PUBLIC;
REVOKE ALL ON TABLE kanal FROM postgres;
GRANT ALL ON TABLE kanal TO postgres;


--
-- Name: kanal_durch_land; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE kanal_durch_land FROM PUBLIC;
REVOKE ALL ON TABLE kanal_durch_land FROM postgres;
GRANT ALL ON TABLE kanal_durch_land TO postgres;


--
-- Name: kanal_verbindet_wasserstrassen; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE kanal_verbindet_wasserstrassen FROM PUBLIC;
REVOKE ALL ON TABLE kanal_verbindet_wasserstrassen FROM postgres;
GRANT ALL ON TABLE kanal_verbindet_wasserstrassen TO postgres;


--
-- Name: kanal_verbindet_wasserstrassen_inv; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE kanal_verbindet_wasserstrassen_inv FROM PUBLIC;
REVOKE ALL ON TABLE kanal_verbindet_wasserstrassen_inv FROM postgres;
GRANT ALL ON TABLE kanal_verbindet_wasserstrassen_inv TO postgres;


--
-- Name: kanal_verbindet_wasserstrassen*; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE "kanal_verbindet_wasserstrassen*" FROM PUBLIC;
REVOKE ALL ON TABLE "kanal_verbindet_wasserstrassen*" FROM postgres;
GRANT ALL ON TABLE "kanal_verbindet_wasserstrassen*" TO postgres;


--
-- Name: kreisstadt; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE kreisstadt FROM PUBLIC;
REVOKE ALL ON TABLE kreisstadt FROM postgres;
GRANT ALL ON TABLE kreisstadt TO postgres;


--
-- Name: land; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE land FROM PUBLIC;
REVOKE ALL ON TABLE land FROM postgres;
GRANT ALL ON TABLE land TO postgres;


--
-- Name: millionenstadt; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE millionenstadt FROM PUBLIC;
REVOKE ALL ON TABLE millionenstadt FROM postgres;
GRANT ALL ON TABLE millionenstadt TO postgres;


--
-- Name: nachbarland_von; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE nachbarland_von FROM PUBLIC;
REVOKE ALL ON TABLE nachbarland_von FROM postgres;
GRANT ALL ON TABLE nachbarland_von TO postgres;


--
-- Name: nachbarland_von_inv; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE nachbarland_von_inv FROM PUBLIC;
REVOKE ALL ON TABLE nachbarland_von_inv FROM postgres;
GRANT ALL ON TABLE nachbarland_von_inv TO postgres;


--
-- Name: nachbarland_von*; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE "nachbarland_von*" FROM PUBLIC;
REVOKE ALL ON TABLE "nachbarland_von*" FROM postgres;
GRANT ALL ON TABLE "nachbarland_von*" TO postgres;


--
-- Name: nachbarstaat; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE nachbarstaat FROM PUBLIC;
REVOKE ALL ON TABLE nachbarstaat FROM postgres;
GRANT ALL ON TABLE nachbarstaat TO postgres;


--
-- Name: regierungsbezirk; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE regierungsbezirk FROM PUBLIC;
REVOKE ALL ON TABLE regierungsbezirk FROM postgres;
GRANT ALL ON TABLE regierungsbezirk TO postgres;


--
-- Name: stadt_an_fluss; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE stadt_an_fluss FROM PUBLIC;
REVOKE ALL ON TABLE stadt_an_fluss FROM postgres;
GRANT ALL ON TABLE stadt_an_fluss TO postgres;


--
-- Name: stadt_an_kanal; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE stadt_an_kanal FROM PUBLIC;
REVOKE ALL ON TABLE stadt_an_kanal FROM postgres;
GRANT ALL ON TABLE stadt_an_kanal TO postgres;


--
-- Name: stadt_flaeche; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE stadt_flaeche FROM PUBLIC;
REVOKE ALL ON TABLE stadt_flaeche FROM postgres;
GRANT ALL ON TABLE stadt_flaeche TO postgres;


--
-- Name: wasserstraße; Type: ACL; Schema: stadtlandfluss; Owner: postgres
--

REVOKE ALL ON TABLE "wasserstraße" FROM PUBLIC;
REVOKE ALL ON TABLE "wasserstraße" FROM postgres;
GRANT ALL ON TABLE "wasserstraße" TO postgres;


--
-- PostgreSQL database dump complete
--

