--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: bundesliga0607; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA bundesliga0607;


ALTER SCHEMA bundesliga0607 OWNER TO postgres;

--
-- Name: SCHEMA bundesliga0607; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA bundesliga0607 IS 'Beispielschema für VL IS WS 10/11';


SET search_path = bundesliga0607, pg_catalog;

--
-- Name: torereignisse_sq; Type: SEQUENCE; Schema: bundesliga0607; Owner: postgres
--

CREATE SEQUENCE torereignisse_sq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE bundesliga0607.torereignisse_sq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: torereignisse; Type: TABLE; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

CREATE TABLE torereignisse (
    id integer DEFAULT nextval('torereignisse_sq'::regclass) NOT NULL,
    verein character varying(50),
    spieltag double precision,
    minute double precision,
    spieler character varying(50),
    eigentor boolean,
    elfmetertor boolean
);


ALTER TABLE bundesliga0607.torereignisse OWNER TO postgres;

--
-- Name: Eigentore; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Eigentore" AS
    SELECT torereignisse.spieltag, torereignisse.verein, count(torereignisse.id) AS eigentore FROM torereignisse WHERE (torereignisse.eigentor = true) GROUP BY torereignisse.spieltag, torereignisse.verein;


ALTER TABLE bundesliga0607."Eigentore" OWNER TO postgres;

--
-- Name: ReguläreTore; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "ReguläreTore" AS
    SELECT torereignisse.spieltag, torereignisse.verein, count(torereignisse.id) AS tore FROM torereignisse WHERE (torereignisse.eigentor = false) GROUP BY torereignisse.spieltag, torereignisse.verein;


ALTER TABLE bundesliga0607."ReguläreTore" OWNER TO postgres;

--
-- Name: spielpaarungen; Type: TABLE; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

CREATE TABLE spielpaarungen (
    spieltag integer NOT NULL,
    heim character varying(15) NOT NULL,
    "auswärts" character varying(15),
    datum timestamp without time zone,
    absolviert boolean,
    CONSTRAINT spielpaarungen_c CHECK (((spieltag > 0) AND (spieltag < 35)))
);


ALTER TABLE bundesliga0607.spielpaarungen OWNER TO postgres;

--
-- Name: Gegentore; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Gegentore" AS
    SELECT spielpaarungen.spieltag, spielpaarungen.heim, spielpaarungen."auswärts", (COALESCE("reguläreTore".tore, (0)::bigint) + COALESCE(eigentore.eigentore, (0)::bigint)) AS torea, spielpaarungen.datum FROM ((spielpaarungen LEFT JOIN "ReguläreTore" "reguläreTore" ON ((((spielpaarungen."auswärts")::text = ("reguläreTore".verein)::text) AND ((spielpaarungen.spieltag)::double precision = "reguläreTore".spieltag)))) LEFT JOIN "Eigentore" eigentore ON ((((spielpaarungen.heim)::text = (eigentore.verein)::text) AND ((spielpaarungen.spieltag)::double precision = eigentore.spieltag)))) WHERE (spielpaarungen.absolviert = true);


ALTER TABLE bundesliga0607."Gegentore" OWNER TO postgres;

--
-- Name: Tore; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Tore" AS
    SELECT spielpaarungen.spieltag, spielpaarungen.heim, (COALESCE("reguläreTore".tore, (0)::bigint) + COALESCE(eigentore.eigentore, (0)::bigint)) AS toreh, spielpaarungen."auswärts", spielpaarungen.datum FROM ((spielpaarungen LEFT JOIN "ReguläreTore" "reguläreTore" ON ((((spielpaarungen.heim)::text = ("reguläreTore".verein)::text) AND ((spielpaarungen.spieltag)::double precision = "reguläreTore".spieltag)))) LEFT JOIN "Eigentore" eigentore ON ((((spielpaarungen."auswärts")::text = (eigentore.verein)::text) AND ((spielpaarungen.spieltag)::double precision = eigentore.spieltag)))) WHERE (spielpaarungen.absolviert = true);


ALTER TABLE bundesliga0607."Tore" OWNER TO postgres;

--
-- Name: Spielereignisse; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Spielereignisse" AS
    SELECT tore.spieltag, tore.heim, tore.toreh, tore."auswärts", gegentore.torea, tore.datum FROM ("Tore" tore JOIN "Gegentore" gegentore ON ((((tore.heim)::text = (gegentore.heim)::text) AND (tore.spieltag = gegentore.spieltag))));


ALTER TABLE bundesliga0607."Spielereignisse" OWNER TO postgres;

--
-- Name: SpieleA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "SpieleA" AS
    SELECT spielereignisse.spieltag, spielereignisse."auswärts" AS verein, spielereignisse.torea AS tore, spielereignisse.heim AS gegner, spielereignisse.toreh AS gegentore, spielereignisse.datum FROM "Spielereignisse" spielereignisse;


ALTER TABLE bundesliga0607."SpieleA" OWNER TO postgres;

--
-- Name: NiederlagenA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "NiederlagenA" AS
    SELECT "SpieleA".spieltag, "SpieleA".verein, "SpieleA".tore, "SpieleA".gegner, "SpieleA".gegentore, "SpieleA".datum FROM "SpieleA" WHERE ("SpieleA".tore < "SpieleA".gegentore);


ALTER TABLE bundesliga0607."NiederlagenA" OWNER TO postgres;

--
-- Name: vereine; Type: TABLE; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

CREATE TABLE vereine (
    name character varying(20),
    stadt character varying(25),
    trainer character varying(20),
    kurzform character varying(50) NOT NULL
);


ALTER TABLE bundesliga0607.vereine OWNER TO postgres;

--
-- Name: CountNiederlagenA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "CountNiederlagenA" AS
    SELECT vereine.kurzform AS verein, count("NiederlagenA".gegner) AS n FROM ("NiederlagenA" RIGHT JOIN vereine ON ((("NiederlagenA".verein)::text = (vereine.kurzform)::text))) GROUP BY vereine.kurzform ORDER BY count("NiederlagenA".gegner);


ALTER TABLE bundesliga0607."CountNiederlagenA" OWNER TO postgres;

--
-- Name: SpieleH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "SpieleH" AS
    SELECT spielereignisse.spieltag, spielereignisse.heim AS verein, spielereignisse.toreh AS tore, spielereignisse."auswärts" AS gegner, spielereignisse.torea AS gegentore, spielereignisse.datum FROM "Spielereignisse" spielereignisse;


ALTER TABLE bundesliga0607."SpieleH" OWNER TO postgres;

--
-- Name: NiederlagenH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "NiederlagenH" AS
    SELECT "SpieleH".spieltag, "SpieleH".verein, "SpieleH".tore, "SpieleH".gegner, "SpieleH".gegentore, "SpieleH".datum FROM "SpieleH" WHERE ("SpieleH".tore < "SpieleH".gegentore);


ALTER TABLE bundesliga0607."NiederlagenH" OWNER TO postgres;

--
-- Name: CountNiederlagenH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "CountNiederlagenH" AS
    SELECT vereine.kurzform AS verein, count("NiederlagenH".gegner) AS n FROM ("NiederlagenH" RIGHT JOIN vereine ON ((("NiederlagenH".verein)::text = (vereine.kurzform)::text))) GROUP BY vereine.kurzform ORDER BY count("NiederlagenH".gegner);


ALTER TABLE bundesliga0607."CountNiederlagenH" OWNER TO postgres;

--
-- Name: SiegeA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "SiegeA" AS
    SELECT "SpieleA".spieltag, "SpieleA".verein, "SpieleA".tore, "SpieleA".gegner, "SpieleA".gegentore, "SpieleA".datum FROM "SpieleA" WHERE ("SpieleA".tore > "SpieleA".gegentore);


ALTER TABLE bundesliga0607."SiegeA" OWNER TO postgres;

--
-- Name: CountSiegeA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "CountSiegeA" AS
    SELECT vereine.kurzform AS verein, count("SiegeA".gegner) AS s FROM ("SiegeA" RIGHT JOIN vereine ON ((("SiegeA".verein)::text = (vereine.kurzform)::text))) GROUP BY vereine.kurzform ORDER BY count("SiegeA".gegner) DESC;


ALTER TABLE bundesliga0607."CountSiegeA" OWNER TO postgres;

--
-- Name: SiegeH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "SiegeH" AS
    SELECT "SpieleH".spieltag, "SpieleH".verein, "SpieleH".tore, "SpieleH".gegner, "SpieleH".gegentore, "SpieleH".datum FROM "SpieleH" WHERE ("SpieleH".tore > "SpieleH".gegentore);


ALTER TABLE bundesliga0607."SiegeH" OWNER TO postgres;

--
-- Name: CountSiegeH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "CountSiegeH" AS
    SELECT vereine.kurzform AS verein, count("SiegeH".gegner) AS s FROM ("SiegeH" RIGHT JOIN vereine ON ((("SiegeH".verein)::text = (vereine.kurzform)::text))) GROUP BY vereine.kurzform ORDER BY count("SiegeH".gegner) DESC;


ALTER TABLE bundesliga0607."CountSiegeH" OWNER TO postgres;

--
-- Name: CountToreProSpieltag; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "CountToreProSpieltag" AS
    SELECT count(torereignisse.id) AS "Anzahl Tore", torereignisse.spieltag AS tag FROM torereignisse GROUP BY torereignisse.spieltag;


ALTER TABLE bundesliga0607."CountToreProSpieltag" OWNER TO postgres;

--
-- Name: UnentschiedenA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "UnentschiedenA" AS
    SELECT "SpieleA".spieltag, "SpieleA".verein, "SpieleA".tore, "SpieleA".gegner, "SpieleA".gegentore, "SpieleA".datum FROM "SpieleA" WHERE ("SpieleA".tore = "SpieleA".gegentore);


ALTER TABLE bundesliga0607."UnentschiedenA" OWNER TO postgres;

--
-- Name: CountUnentschiedenA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "CountUnentschiedenA" AS
    SELECT vereine.kurzform AS verein, count("UnentschiedenA".verein) AS u FROM ("UnentschiedenA" RIGHT JOIN vereine ON ((("UnentschiedenA".verein)::text = (vereine.kurzform)::text))) GROUP BY vereine.kurzform ORDER BY count("UnentschiedenA".verein) DESC;


ALTER TABLE bundesliga0607."CountUnentschiedenA" OWNER TO postgres;

--
-- Name: UnentschiedenH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "UnentschiedenH" AS
    SELECT "SpieleH".spieltag, "SpieleH".verein, "SpieleH".tore, "SpieleH".gegner, "SpieleH".gegentore, "SpieleH".datum FROM "SpieleH" WHERE ("SpieleH".tore = "SpieleH".gegentore);


ALTER TABLE bundesliga0607."UnentschiedenH" OWNER TO postgres;

--
-- Name: CountUnentschiedenH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "CountUnentschiedenH" AS
    SELECT vereine.kurzform AS verein, count("UnentschiedenH".verein) AS u FROM ("UnentschiedenH" RIGHT JOIN vereine ON ((("UnentschiedenH".verein)::text = (vereine.kurzform)::text))) GROUP BY vereine.kurzform ORDER BY count("UnentschiedenH".verein) DESC;


ALTER TABLE bundesliga0607."CountUnentschiedenH" OWNER TO postgres;

--
-- Name: Elfmeterschützenliste; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Elfmeterschützenliste" AS
    SELECT torereignisse.spieler, torereignisse.verein, count(torereignisse.id) AS tore FROM torereignisse WHERE ((torereignisse.eigentor = false) AND (torereignisse.elfmetertor = true)) GROUP BY torereignisse.spieler, torereignisse.verein ORDER BY count(torereignisse.id) DESC;


ALTER TABLE bundesliga0607."Elfmeterschützenliste" OWNER TO postgres;

--
-- Name: Niederlagen; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Niederlagen" AS
    SELECT "NiederlagenA".spieltag, "NiederlagenA".verein, "NiederlagenA".tore, "NiederlagenA".gegner, "NiederlagenA".gegentore, "NiederlagenA".datum FROM "NiederlagenA" UNION SELECT "NiederlagenH".spieltag, "NiederlagenH".verein, "NiederlagenH".tore, "NiederlagenH".gegner, "NiederlagenH".gegentore, "NiederlagenH".datum FROM "NiederlagenH";


ALTER TABLE bundesliga0607."Niederlagen" OWNER TO postgres;

--
-- Name: PunkteA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "PunkteA" AS
    SELECT "CountSiegeA".verein, (("CountSiegeA".s + "CountUnentschiedenA".u) + "CountNiederlagenA".n) AS spiele, "CountSiegeA".s, "CountUnentschiedenA".u, "CountNiederlagenA".n, ((3 * "CountSiegeA".s) + "CountUnentschiedenA".u) AS punkte FROM (("CountSiegeA" JOIN "CountUnentschiedenA" ON ((("CountSiegeA".verein)::text = ("CountUnentschiedenA".verein)::text))) JOIN "CountNiederlagenA" ON ((("CountUnentschiedenA".verein)::text = ("CountNiederlagenA".verein)::text))) ORDER BY ((3 * "CountSiegeA".s) + "CountUnentschiedenA".u) DESC;


ALTER TABLE bundesliga0607."PunkteA" OWNER TO postgres;

--
-- Name: PunkteH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "PunkteH" AS
    SELECT "CountSiegeH".verein, (("CountSiegeH".s + "CountUnentschiedenH".u) + "CountNiederlagenH".n) AS spiele, "CountSiegeH".s, "CountUnentschiedenH".u, "CountNiederlagenH".n, ((3 * "CountSiegeH".s) + "CountUnentschiedenH".u) AS punkte FROM (("CountSiegeH" JOIN "CountUnentschiedenH" ON ((("CountSiegeH".verein)::text = ("CountUnentschiedenH".verein)::text))) JOIN "CountNiederlagenH" ON ((("CountUnentschiedenH".verein)::text = ("CountNiederlagenH".verein)::text))) ORDER BY ((3 * "CountSiegeH".s) + "CountUnentschiedenH".u) DESC;


ALTER TABLE bundesliga0607."PunkteH" OWNER TO postgres;

--
-- Name: TorbilanzA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "TorbilanzA" AS
    SELECT "SpieleA".verein, sum("SpieleA".tore) AS tore, sum("SpieleA".gegentore) AS gegentore, (sum("SpieleA".tore) - sum("SpieleA".gegentore)) AS tordifferenz FROM (vereine LEFT JOIN "SpieleA" ON (((vereine.kurzform)::text = ("SpieleA".verein)::text))) GROUP BY "SpieleA".verein ORDER BY sum("SpieleA".tore) DESC, sum("SpieleA".gegentore) DESC;


ALTER TABLE bundesliga0607."TorbilanzA" OWNER TO postgres;

--
-- Name: TabelleOhnePositionenA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "TabelleOhnePositionenA" AS
    SELECT "PunkteA".verein, "PunkteA".spiele AS sp, "PunkteA".s, "PunkteA".u, "PunkteA".n, "TorbilanzA".tore AS t, "TorbilanzA".gegentore AS gt, "TorbilanzA".tordifferenz AS tdiff, "PunkteA".punkte AS pkte FROM ("PunkteA" JOIN "TorbilanzA" ON ((("PunkteA".verein)::text = ("TorbilanzA".verein)::text)));


ALTER TABLE bundesliga0607."TabelleOhnePositionenA" OWNER TO postgres;

--
-- Name: TorbilanzH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "TorbilanzH" AS
    SELECT "SpieleH".verein, sum("SpieleH".tore) AS tore, sum("SpieleH".gegentore) AS gegentore, (sum("SpieleH".tore) - sum("SpieleH".gegentore)) AS tordifferenz FROM (vereine LEFT JOIN "SpieleH" ON (((vereine.kurzform)::text = ("SpieleH".verein)::text))) GROUP BY "SpieleH".verein ORDER BY sum("SpieleH".tore) DESC, sum("SpieleH".gegentore) DESC;


ALTER TABLE bundesliga0607."TorbilanzH" OWNER TO postgres;

--
-- Name: TabelleOhnePositionenH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "TabelleOhnePositionenH" AS
    SELECT "PunkteH".verein, "PunkteH".spiele AS sp, "PunkteH".s, "PunkteH".u, "PunkteH".n, "TorbilanzH".tore AS t, "TorbilanzH".gegentore AS gt, "TorbilanzH".tordifferenz AS tdiff, "PunkteH".punkte AS pkte FROM ("PunkteH" JOIN "TorbilanzH" ON ((("PunkteH".verein)::text = ("TorbilanzH".verein)::text)));


ALTER TABLE bundesliga0607."TabelleOhnePositionenH" OWNER TO postgres;

--
-- Name: punktabzug; Type: TABLE; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

CREATE TABLE punktabzug (
    verein character varying(50) NOT NULL,
    punktabzug integer,
    CONSTRAINT punktabzug_c CHECK (((punktabzug >= 0) AND (punktabzug < 51)))
);


ALTER TABLE bundesliga0607.punktabzug OWNER TO postgres;

--
-- Name: TabelleOhnePositionen; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "TabelleOhnePositionen" AS
    SELECT "TabelleOhnePositionenH".verein, ("TabelleOhnePositionenH".sp + "TabelleOhnePositionenA".sp) AS sp, ("TabelleOhnePositionenH".s + "TabelleOhnePositionenA".s) AS s, ("TabelleOhnePositionenH".u + "TabelleOhnePositionenA".u) AS u, ("TabelleOhnePositionenH".n + "TabelleOhnePositionenA".n) AS n, ("TabelleOhnePositionenH".t + "TabelleOhnePositionenA".t) AS t, ("TabelleOhnePositionenH".gt + "TabelleOhnePositionenA".gt) AS gt, ("TabelleOhnePositionenH".tdiff + "TabelleOhnePositionenA".tdiff) AS tdiff, (("TabelleOhnePositionenH".pkte + "TabelleOhnePositionenA".pkte) - punktabzug.punktabzug) AS pkte FROM (("TabelleOhnePositionenA" JOIN "TabelleOhnePositionenH" ON ((("TabelleOhnePositionenA".verein)::text = ("TabelleOhnePositionenH".verein)::text))) JOIN punktabzug ON ((("TabelleOhnePositionenH".verein)::text = (punktabzug.verein)::text))) ORDER BY (("TabelleOhnePositionenH".pkte + "TabelleOhnePositionenA".pkte) - punktabzug.punktabzug) DESC, ("TabelleOhnePositionenH".tdiff + "TabelleOhnePositionenA".tdiff) DESC, ("TabelleOhnePositionenH".t + "TabelleOhnePositionenA".t) DESC, punktabzug.verein;


ALTER TABLE bundesliga0607."TabelleOhnePositionen" OWNER TO postgres;

--
-- Name: Positionen; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Positionen" AS
    SELECT x.verein, count(y.verein) AS pos FROM "TabelleOhnePositionen" x, "TabelleOhnePositionen" y WHERE ((((x.pkte < y.pkte) OR ((x.pkte = y.pkte) AND (x.tdiff < y.tdiff))) OR (((x.pkte = y.pkte) AND (x.tdiff = y.tdiff)) AND (x.t < y.t))) OR ((x.verein)::text = (y.verein)::text)) GROUP BY x.verein ORDER BY count(y.verein), x.verein;


ALTER TABLE bundesliga0607."Positionen" OWNER TO postgres;

--
-- Name: PositionenA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "PositionenA" AS
    SELECT x.verein, count(y.verein) AS pos FROM "TabelleOhnePositionenA" x, "TabelleOhnePositionenA" y WHERE ((((x.pkte < y.pkte) OR ((x.pkte = y.pkte) AND (x.tdiff < y.tdiff))) OR (((x.pkte = y.pkte) AND (x.tdiff = y.tdiff)) AND (x.t < y.t))) OR ((x.verein)::text = (y.verein)::text)) GROUP BY x.verein ORDER BY count(y.verein);


ALTER TABLE bundesliga0607."PositionenA" OWNER TO postgres;

--
-- Name: PositionenH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "PositionenH" AS
    SELECT x.verein, count(y.verein) AS pos FROM "TabelleOhnePositionenH" x, "TabelleOhnePositionenH" y WHERE ((((x.pkte < y.pkte) OR ((x.pkte = y.pkte) AND (x.tdiff < y.tdiff))) OR (((x.pkte = y.pkte) AND (x.tdiff = y.tdiff)) AND (x.t < y.t))) OR ((x.verein)::text = (y.verein)::text)) GROUP BY x.verein ORDER BY count(y.verein);


ALTER TABLE bundesliga0607."PositionenH" OWNER TO postgres;

--
-- Name: Siege; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Siege" AS
    SELECT "SiegeA".spieltag, "SiegeA".verein, "SiegeA".tore, "SiegeA".gegner, "SiegeA".gegentore, "SiegeA".datum FROM "SiegeA" UNION SELECT "SiegeH".spieltag, "SiegeH".verein, "SiegeH".tore, "SiegeH".gegner, "SiegeH".gegentore, "SiegeH".datum FROM "SiegeH";


ALTER TABLE bundesliga0607."Siege" OWNER TO postgres;

--
-- Name: Tabelle; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Tabelle" AS
    SELECT "Positionen".pos, "TabelleOhnePositionen".verein, "TabelleOhnePositionen".sp, "TabelleOhnePositionen".s, "TabelleOhnePositionen".u, "TabelleOhnePositionen".n, "TabelleOhnePositionen".t, "TabelleOhnePositionen".gt, "TabelleOhnePositionen".tdiff, "TabelleOhnePositionen".pkte FROM ("Positionen" JOIN "TabelleOhnePositionen" ON ((("Positionen".verein)::text = ("TabelleOhnePositionen".verein)::text))) ORDER BY "Positionen".pos, "Positionen".verein;


ALTER TABLE bundesliga0607."Tabelle" OWNER TO postgres;

--
-- Name: TabelleA; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "TabelleA" AS
    SELECT "PositionenA".pos, "TabelleOhnePositionenA".verein, "TabelleOhnePositionenA".sp, "TabelleOhnePositionenA".s, "TabelleOhnePositionenA".u, "TabelleOhnePositionenA".n, "TabelleOhnePositionenA".t, "TabelleOhnePositionenA".gt, "TabelleOhnePositionenA".tdiff, "TabelleOhnePositionenA".pkte FROM ("PositionenA" JOIN "TabelleOhnePositionenA" ON ((("PositionenA".verein)::text = ("TabelleOhnePositionenA".verein)::text))) ORDER BY "PositionenA".pos, "PositionenA".verein;


ALTER TABLE bundesliga0607."TabelleA" OWNER TO postgres;

--
-- Name: TabelleH; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "TabelleH" AS
    SELECT "PositionenH".pos, "TabelleOhnePositionenH".verein, "TabelleOhnePositionenH".sp, "TabelleOhnePositionenH".s, "TabelleOhnePositionenH".u, "TabelleOhnePositionenH".n, "TabelleOhnePositionenH".t, "TabelleOhnePositionenH".gt, "TabelleOhnePositionenH".tdiff, "TabelleOhnePositionenH".pkte FROM ("PositionenH" JOIN "TabelleOhnePositionenH" ON ((("PositionenH".verein)::text = ("TabelleOhnePositionenH".verein)::text))) ORDER BY "PositionenH".pos, "PositionenH".verein;


ALTER TABLE bundesliga0607."TabelleH" OWNER TO postgres;

--
-- Name: Torschützenliste; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Torschützenliste" AS
    SELECT torereignisse.spieler, torereignisse.verein, count(torereignisse.id) AS tore FROM torereignisse WHERE (torereignisse.eigentor = false) GROUP BY torereignisse.spieler, torereignisse.verein ORDER BY count(torereignisse.id) DESC, torereignisse.spieler;


ALTER TABLE bundesliga0607."Torschützenliste" OWNER TO postgres;

--
-- Name: Unentschieden; Type: VIEW; Schema: bundesliga0607; Owner: postgres
--

CREATE VIEW "Unentschieden" AS
    SELECT "UnentschiedenA".spieltag, "UnentschiedenA".verein, "UnentschiedenA".tore, "UnentschiedenA".gegner, "UnentschiedenA".gegentore, "UnentschiedenA".datum FROM "UnentschiedenA" UNION SELECT "UnentschiedenH".spieltag, "UnentschiedenH".verein, "UnentschiedenH".tore, "UnentschiedenH".gegner, "UnentschiedenH".gegentore, "UnentschiedenH".datum FROM "UnentschiedenH";


ALTER TABLE bundesliga0607."Unentschieden" OWNER TO postgres;

--
-- Data for Name: punktabzug; Type: TABLE DATA; Schema: bundesliga0607; Owner: postgres
--

COPY punktabzug (verein, punktabzug) FROM stdin;
AC	0
B	0
BI	0
BO	0
CB	0
DO	0
F	0
GE	0
H	0
HB	0
HH	0
LEV	0
M	0
MG	0
MZ	0
N	0
S	0
WO	0
\.


--
-- Data for Name: spielpaarungen; Type: TABLE DATA; Schema: bundesliga0607; Owner: postgres
--

COPY spielpaarungen (spieltag, heim, "auswärts", datum, absolviert) FROM stdin;
2	AC	GE	2006-08-19 15:30:00	t
1	S	N	2006-08-12 15:30:00	t
2	B	H	2006-08-19 15:30:00	t
2	CB	HH	2006-08-19 15:30:00	t
2	DO	MZ	2006-08-19 15:30:00	t
2	F	WO	2006-08-19 15:30:00	t
2	N	MG	2006-08-18 20:30:00	t
3	GE	HB	2006-08-25 20:30:00	t
4	WO	H	2006-09-15 20:30:00	t
5	MG	DO	2006-09-22 20:30:00	t
6	DO	H	2006-09-29 20:30:00	t
7	MZ	AC	2006-10-13 20:30:00	t
8	DO	BO	2006-10-20 20:30:00	t
9	MZ	HB	2006-10-27 20:30:00	t
10	H	BO	2006-11-03 20:30:00	t
12	HB	DO	2006-11-10 20:30:00	t
13	BO	F	2006-11-17 20:30:00	t
14	GE	BO	2006-11-24 20:30:00	t
4	CB	MZ	2006-09-16 15:30:00	t
4	DO	HH	2006-09-16 15:30:00	t
4	HB	S	2006-09-16 15:30:00	t
4	N	BO	2006-09-16 15:30:00	t
5	GE	WO	2006-09-23 15:30:00	t
5	H	LEV	2006-09-23 15:30:00	t
5	HH	HB	2006-09-23 15:30:00	t
5	M	AC	2006-09-23 15:30:00	t
5	MZ	B	2006-09-23 15:30:00	t
5	S	F	2006-09-23 15:30:00	t
6	AC	BO	2006-09-30 15:30:00	t
6	BI	CB	2006-09-30 15:30:00	t
6	F	HH	2006-09-30 15:30:00	t
6	HB	MG	2006-09-30 15:30:00	t
6	N	MZ	2006-09-30 15:30:00	t
6	WO	M	2006-09-30 15:30:00	t
7	BO	HB	2006-10-14 15:30:00	t
7	H	F	2006-10-14 15:30:00	t
7	HH	GE	2006-10-14 15:30:00	t
7	M	B	2006-10-14 15:30:00	t
7	MG	WO	2006-10-14 15:30:00	t
7	S	LEV	2006-10-14 15:30:00	t
8	AC	CB	2006-10-21 15:30:00	t
8	B	MG	2006-10-21 15:30:00	t
8	BI	MZ	2006-10-21 15:30:00	t
8	GE	H	2006-10-21 15:30:00	t
8	HB	M	2006-10-21 15:30:00	t
8	WO	S	2006-10-21 15:30:00	t
9	BO	WO	2006-10-28 15:30:00	t
9	CB	B	2006-10-28 15:30:00	t
9	HH	H	2006-10-28 15:30:00	t
9	M	F	2006-10-28 15:30:00	t
9	MG	LEV	2006-10-28 15:30:00	t
9	N	DO	2006-10-28 15:30:00	t
10	AC	S	2006-11-04 15:30:00	t
10	B	N	2006-11-04 15:30:00	t
10	DO	BI	2006-11-04 15:30:00	t
10	HB	CB	2006-11-04 15:30:00	t
10	LEV	MZ	2006-11-04 15:30:00	t
10	WO	HH	2006-11-04 15:30:00	t
12	B	BO	2006-11-11 15:30:00	t
12	F	BI	2006-11-11 15:30:00	t
12	GE	MZ	2006-11-11 15:30:00	t
12	HH	MG	2006-11-11 15:30:00	t
12	LEV	M	2006-11-11 15:30:00	t
12	WO	CB	2006-11-11 15:30:00	t
13	AC	HB	2006-11-18 15:30:00	t
13	CB	GE	2006-11-18 15:30:00	t
1	M	DO	2006-08-11 20:45:00	t
1	WO	B	2006-08-13 17:00:00	t
2	BI	S	2006-08-20 17:00:00	t
2	BO	M	2006-08-20 17:00:00	t
3	HH	B	2006-08-27 17:00:00	t
3	MZ	F	2006-08-27 17:00:00	t
4	B	GE	2006-09-17 17:00:00	t
4	F	LEV	2006-09-17 17:00:00	t
5	BO	BI	2006-09-24 17:00:00	t
5	CB	N	2006-09-24 17:00:00	t
6	B	S	2006-01-01 17:00:00	t
6	LEV	GE	2006-01-01 17:00:00	t
7	CB	DO	2006-10-15 17:00:00	t
7	N	BI	2006-10-15 17:00:00	t
8	F	N	2006-10-22 17:00:00	t
8	LEV	HH	2006-10-22 17:00:00	t
9	BI	AC	2006-10-29 17:00:00	t
9	S	GE	2006-10-29 17:00:00	t
10	F	MG	2006-11-05 17:00:00	t
10	GE	M	2006-11-05 17:00:00	t
12	AC	N	2006-11-12 17:00:00	t
12	H	S	2006-11-12 17:00:00	t
13	BI	WO	2006-11-19 17:00:00	t
13	MG	H	2006-11-19 17:00:00	t
1	H	HB	2006-08-13 17:00:00	t
11	BI	B	2006-11-08 20:00:00	t
11	BO	LEV	2006-11-08 20:00:00	t
11	CB	F	2006-11-08 20:00:00	t
11	DO	AC	2006-11-07 20:00:00	t
11	M	H	2006-11-08 20:00:00	t
11	MG	GE	2006-11-08 20:00:00	t
11	MZ	WO	2006-11-07 20:00:00	t
11	N	HB	2006-11-07 20:00:00	t
11	S	HH	2006-11-07 20:00:00	t
14	LEV	CB	2006-11-26 00:00:00	t
14	S	MG	2006-11-26 00:00:00	t
14	HB	BI	2006-11-25 15:30:00	t
15	AC	F	2006-12-03 17:00:00	t
15	N	GE	2006-12-03 17:00:00	t
16	GE	DO	2006-12-10 17:00:00	t
16	WO	AC	2006-12-10 17:00:00	t
17	DO	LEV	2006-12-17 17:00:00	t
17	HB	WO	2006-12-17 17:00:00	t
14	HH	M	2006-11-25 15:30:00	t
14	WO	N	2006-11-25 15:30:00	t
15	BI	LEV	2006-12-02 15:30:00	t
15	BO	HH	2006-12-02 15:30:00	t
1	HH	BI	2006-08-12 15:30:00	t
1	LEV	AC	2006-08-12 15:30:00	t
1	MZ	BO	2006-08-12 15:30:00	t
1	MG	CB	2006-08-12 15:30:00	t
1	GE	F	2006-08-12 15:30:00	t
2	HB	LEV	2006-08-19 15:30:00	t
3	BO	CB	2006-08-26 15:30:00	t
3	H	AC	2006-08-26 15:30:00	t
3	LEV	WO	2006-08-26 15:30:00	t
3	M	N	2006-08-26 15:30:00	t
3	MG	BI	2006-08-26 15:30:00	t
3	S	DO	2006-08-26 15:30:00	t
4	AC	MG	2006-09-16 15:30:00	t
4	BI	M	2006-09-16 15:30:00	t
13	DO	B	2006-11-18 15:30:00	t
13	M	S	2006-11-18 15:30:00	t
13	MZ	HH	2006-11-18 15:30:00	t
13	N	LEV	2006-11-18 15:30:00	t
14	B	AC	2006-11-25 15:30:00	t
14	F	DO	2006-11-25 15:30:00	t
14	H	MZ	2006-11-25 15:30:00	t
15	CB	H	2006-12-02 15:30:00	t
15	DO	WO	2006-12-02 15:30:00	t
15	HB	B	2006-12-02 15:30:00	t
15	M	MG	2006-12-02 15:30:00	t
16	F	HB	2006-12-09 15:30:00	t
16	H	BI	2006-12-09 15:30:00	t
16	HH	N	2006-12-09 15:30:00	t
16	M	CB	2006-12-09 15:30:00	t
16	MG	MZ	2006-12-09 15:30:00	t
16	S	BO	2006-12-09 15:30:00	t
17	AC	HH	2006-12-16 15:30:00	t
17	B	F	2006-12-16 15:30:00	t
17	BI	GE	2006-12-16 15:30:00	t
17	CB	S	2006-12-16 15:30:00	t
17	MZ	M	2006-12-16 15:30:00	t
15	MZ	S	2006-12-01 20:30:00	t
16	LEV	B	2006-12-08 20:30:00	t
17	BO	MG	2006-12-15 20:30:00	t
17	N	H	2006-12-16 15:30:00	t
\.


--
-- Data for Name: torereignisse; Type: TABLE DATA; Schema: bundesliga0607; Owner: postgres
--

COPY torereignisse (id, verein, spieltag, minute, spieler, eigentor, elfmetertor) FROM stdin;
1	M	1	23	Makaay	f	f
2	M	1	54	Schweinsteiger	f	f
306	M	13	27	Makaay	f	f
307	CB	13	28	Radu	f	f
309	CB	13	31	Radu	f	f
310	BO	13	33	Maltritz	f	f
311	AC	13	33	Rösler	f	f
312	BO	13	36	Butscher	f	f
313	M	13	36	Pizarro	f	f
314	BO	13	46	Gekas	f	f
315	HB	13	47	Mertesacker	f	f
316	N	13	48	Schroth	f	f
317	H	13	50	Balitsch	f	f
318	GE	13	51	Pander	f	f
319	F	13	56	Amanatidis	f	f
320	AC	13	68	Schlaudraff	f	f
322	HB	13	79	Klose	f	f
323	GE	13	83	Kobiashvili	f	f
324	N	13	85	Saenko	f	f
325	S	14	6	Cacau	f	f
326	N	14	7	Saenko	f	f
328	GE	14	19	Rafinha	f	f
329	LEV	14	19	Barbarez	f	f
330	GE	14	27	Lövenkrands	f	f
331	HB	14	29	Klose	f	f
332	F	14	38	Kyrgiakos	f	f
333	B	14	41	Pantelic	f	f
334	HB	14	45	Klose	f	f
335	AC	14	45	Lehmann	f	f
336	BO	14	49	Gekas	f	f
337	CB	14	51	Munteanu	f	f
338	M	14	56	Makaay	f	f
339	B	14	62	Dejagah	f	f
340	LEV	14	66	Rolfes	f	f
341	WO	14	74	Menseguez	f	f
342	HB	14	75	Hunt	f	f
343	H	14	75	Hashemian	f	f
344	M	14	78	Pizarro	f	f
345	DO	14	79	Smolarek	f	f
346	LEV	14	80	Voronin	f	f
347	BO	15	5	Dabrowski	f	f
348	F	15	14	Takahara	f	f
349	H	15	22	Cherundolo	f	f
350	M	15	23	Demichelis	f	f
352	B	15	25	Simunic	f	f
353	HB	15	32	Klose	f	f
354	AC	15	32	Schlaudraff	f	f
355	MG	15	33	Delura	f	f
356	HB	15	40	Klose	f	f
357	HH	15	42	Ljuboja	f	f
358	F	15	44	Takahara	f	f
359	F	15	62	Takahara	f	f
360	BO	15	70	Misimovic	f	f
361	AC	15	81	Fiel	f	f
362	DO	15	91	Smolarek	f	f
363	BO	1	86	Zdebel	f	f
364	B	16	22	Pantelic	f	f
365	LEV	16	33	Freier	f	f
366	LEV	16	79	Babic	f	f
367	HB	16	3	Naldo	f	f
368	F	16	4	Russ	f	f
369	HB	16	11	Jensen	f	f
371	HB	16	31	Naldo	f	f
372	M	16	42	Schweinsteiger	f	f
373	HB	16	48	Naldo	f	f
374	CB	16	52	Baumgart	f	f
375	M	16	54	van Buyten	f	f
376	BI	16	66	Ndjeng	f	f
377	H	16	68	Brdaric	f	f
378	F	16	81	Kyrgiakos	f	f
379	HB	16	86	Vranjes	f	f
380	S	16	87	Streller	f	f
381	MZ	16	89	Jovanovic	f	f
382	HB	16	90	Diego	f	f
383	GE	16	14	Pander	f	f
384	GE	16	25	Kuranyi	f	f
385	GE	16	47	Löwenkrands	f	f
386	WO	16	50	Madlung	f	f
389	DO	16	83	Frei	f	f
390	BO	17	46	Gekas	f	f
392	H	17	4	Brdaric	f	f
393	N	17	31	Banovic	f	f
394	M	17	31	Salihamidzic	f	f
395	HH	17	32	Berisha	f	f
396	M	17	45	Makaay	f	f
397	N	17	55	Schroth	f	f
399	B	17	63	Gimenez	f	f
400	M	17	64	Pizarro	f	f
401	M	17	65	Schweinsteiger	f	f
402	HH	17	67	Benjamin	f	f
403	HH	17	76	Ljuboja	f	f
404	AC	17	77	Fiel	f	f
405	GE	17	81	Bajramovic	f	f
408	HB	17	17	Jensen	f	f
409	LEV	17	24	Voronin	f	f
410	WO	17	41	Boakye	f	f
411	LEV	17	74	Kießling	f	f
412	HB	17	86	Naldo	f	f
413	DO	17	85	Amedick	f	f
190	N	8	50	Pinola	f	f
192	MG	8	63	Neuville	f	f
193	CB	8	65	Munteanu	f	f
194	HH	8	71	Guerrero	f	f
196	B	8	73	Pantelic	f	f
197	CB	8	75	Rost	f	f
98	M	5	55	van Bommel	f	f
198	HH	8	86	Guerrero	f	f
199	BI	9	11	Kamper	f	f
200	LEV	9	12	Voronin	f	f
201	HB	9	14	Klose	f	f
202	BI	9	19	Kucera	f	f
203	HB	9	20	Hunt	f	f
204	HB	9	21	Klose	f	f
205	M	9	24	Makaay	f	f
206	WO	9	25	Hanke	f	f
207	M	9	29	van Bommel	f	f
208	S	9	32	Khedira	f	f
209	S	9	46	Khedira	f	f
210	AC	9	47	Plaßhenrich	f	f
211	BI	9	50	Wichniarek	f	f
213	CB	9	66	Gunkel	f	f
214	BI	9	68	Kamper	f	f
215	MZ	9	74	Adaouagh	f	f
216	LEV	9	74	Voronin	f	f
217	HB	9	75	Hunt	f	f
218	S	9	75	Tasci	f	f
219	HB	9	80	Naldo	f	f
220	CB	9	83	Shao	f	f
221	BI	9	85	Eigler	f	f
222	DO	9	87	Tinga	f	f
223	HB	9	88	Diego	f	f
224	BO	10	4	Drsek	f	f
225	GE	10	13	Lövenkrands	f	f
226	WO	10	19	Hanke	f	f
227	GE	10	20	Kobiashvili	f	f
228	S	10	24	Gomez	f	f
229	S	10	26	Hitzlsperger	f	f
230	AC	10	28	Rösler	f	f
231	MZ	10	29	Szabics	f	f
232	B	10	29	Pantelic	f	f
233	M	10	45	Ottl	f	f
234	LEV	10	46	Barbarez	f	f
235	S	10	46	Streller	f	f
236	N	10	47	Banovic	f	f
237	CB	10	49	Kioyo	f	f
238	M	10	52	Makaay	f	f
239	S	10	63	Streller	f	f
240	B	10	65	Pantelic	f	f
241	BI	10	68	Wichniarek	f	f
242	BO	10	76	Gekas	f	f
243	HB	10	76	Klasnic	f	f
244	F	10	78	Takahara	f	f
245	AC	10	86	Ibisevic	f	f
248	MZ	11	7	Szabics	f	f
249	LEV	11	7	Barbarez	f	f
251	F	11	22	Takahara	f	f
252	BI	11	27	Zuma	f	f
253	GE	11	31	Varela	f	f
254	HB	11	32	Frings	f	f
255	LEV	11	32	Voronin	f	f
256	H	11	43	Huszti	f	f
257	B	11	46	Gilberto	f	f
258	BO	11	48	Ilicevic	f	f
259	B	11	58	Gimenez	f	f
260	LEV	11	71	Barnetta	f	f
261	BI	11	76	Kucera	f	f
262	HB	11	79	Diego	f	f
263	S	11	80	Gomez	f	f
264	WO	11	84	Lamprecht	f	f
265	S	11	86	Hitzlsperger	f	f
267	DO	12	7	Frei	f	f
268	B	12	9	Pantelic	f	f
269	GE	12	13	Kuranyi	f	f
270	H	12	13	Rosenthal	f	f
271	GE	12	22	Halil Altintop	f	f
272	BI	12	26	Wichniarek	f	f
273	HB	12	29	Klose	f	f
274	N	12	29	Galasek	f	f
275	GE	12	32	Kuranyi	f	f
276	M	12	33	Salihamidzic	f	f
277	BO	12	39	Gekas	f	f
278	BO	12	46	Misimovic	f	f
279	BO	12	47	Misimovic	f	f
280	LEV	12	48	Kießling	f	f
281	S	12	49	Hitzlsperger	f	f
282	DO	12	53	Tinga	f	f
283	S	12	54	Cacau	f	f
284	B	12	58	van Burik	f	f
285	BI	12	62	Zuma	f	f
286	HH	12	65	Ljuboja	f	f
287	GE	12	67	Halil Altintop	f	f
288	B	12	80	Neuendorf	f	f
289	LEV	12	80	Athirson	f	f
290	M	12	83	Demichelis	f	f
294	M	12	86	Pizarro	f	f
295	AC	12	90	Plaßhenrich	f	f
296	F	13	1	Streit	f	f
297	GE	13	4	Hamit Altintop	f	f
298	F	13	5	Streit	f	f
299	S	13	8	Gomez	f	f
300	LEV	13	8	Madouni	f	f
301	B	13	10	Schmidt	f	f
302	N	13	12	Vittek	f	f
303	B	13	15	Gilberto	f	f
304	GE	13	15	Kuranyi	f	f
80	F	4	55	Takahara	f	f
81	S	4	58	Bardo	f	f
82	H	4	61	Brdaric	f	f
83	CB	4	61	Munteanu	f	f
84	F	4	70	Thurk	f	f
195	BI	8	72	Westermann	f	f
85	DO	4	82	Wörns	f	f
86	BI	4	84	Kamper	f	f
87	AC	4	84	Schlaudraff	f	f
88	F	4	84	Ochs	f	f
89	S	4	87	Gomez	f	f
90	MG	4	93	Kahé	f	f
91	N	5	10	Mnari	f	f
92	BI	5	11	Gabriel	f	f
93	LEV	5	37	Barbarez	f	f
94	AC	5	38	Dum	f	f
95	MG	5	39	Kahé	f	f
96	M	5	39	Pizarro	f	f
97	MZ	5	49	Diakité	f	f
99	B	5	56	Boateng	f	f
100	GE	5	57	Kuranyi	f	f
101	BO	5	57	Junior	f	f
102	HB	5	58	Borowski	f	f
103	HH	5	68	Reinhardt	f	f
104	S	5	73	Gomez	f	f
105	BO	5	73	Ilicevic	f	f
106	H	5	74	Brdaric	f	f
107	CB	5	83	Baumgart	f	f
108	F	5	88	Meier	f	f
109	GE	5	89	Lincoln	f	f
110	S	6	4	Gomez	f	f
111	DO	6	5	Smolarek	f	f
112	GE	6	6	Bordon	f	f
113	B	6	9	Friedrich	f	f
114	B	6	14	Pantelic	f	f
115	CB	6	22	Munteanu	f	f
116	N	6	24	Polak	f	f
117	LEV	6	28	Castro	f	f
118	HB	6	33	Hunt	f	f
119	HB	6	35	Schulz	f	f
120	F	6	36	Meier	f	f
121	WO	6	36	Hanke	f	f
122	BO	6	36	Misimovic	f	f
123	HB	6	38	Diego	f	f
124	LEV	6	47	Castro	f	f
125	BI	6	48	Zuma	f	f
126	AC	6	48	Schlaudraff	f	f
127	AC	6	49	Rösler	f	f
128	HH	6	51	Ljuboja	f	f
129	LEV	6	56	Ramelow	f	f
130	F	6	58	Amanatidis	f	f
131	S	6	58	Cacau	f	f
132	BI	6	62	Wichniarek	f	f
133	HH	6	69	Sanogo	f	f
134	H	6	74	Hashemian	f	f
135	BI	6	74	Masmanidis	f	f
136	DO	6	76	Smolarek	f	f
137	H	6	77	Huszti	f	f
138	MZ	6	85	Babatz	f	f
139	DO	7	2	Brzenska	f	f
140	HB	7	7	Hunt	f	f
141	M	7	9	Makaay	f	f
142	CB	7	3	da Silva	f	f
143	M	7	15	Sagnol	f	f
144	GE	7	16	Halil Altintop	f	f
145	WO	7	16	Madlung	f	f
146	H	7	21	Hashemian	f	f
147	S	7	22	Gomez	f	f
149	MZ	7	29	Rose	f	f
150	HH	7	30	Trochowski	f	f
151	AC	7	33	Stehle	f	f
152	AC	7	34	Rösler	f	f
153	MG	7	34	Kluge	f	f
154	MG	7	35	Neuville	f	f
155	N	7	39	Polak	f	f
156	S	7	48	Boka	f	f
157	M	7	53	Pizarro	f	f
158	GE	7	53	Bordon	f	f
159	F	7	56	Meier	f	f
160	DO	7	57	Brzenska	f	f
161	B	7	58	Fathi	f	f
162	DO	7	59	Frei	f	f
163	HB	7	60	Schulz	f	f
164	B	7	73	Pantelic	f	f
165	HB	7	76	Vranjes	f	f
166	HB	7	77	Diego	f	f
167	AC	7	78	Ebbers	f	f
168	M	7	78	Podolski	f	f
169	S	7	76	Hitzlsperger	f	f
170	MG	7	83	Degen	f	f
171	HB	7	88	Fritz	f	f
173	HB	7	90	Naldo	f	f
175	N	8	5	Saenko	f	f
176	HB	8	11	Diego	f	f
177	AC	8	16	Reghecampf	f	f
178	GE	8	17	Bajramovic	f	f
179	WO	8	26	Hanke	f	f
180	GE	8	27	Kobiashvili	f	f
181	BO	8	30	Gekas	f	f
182	S	8	31	Gomez	f	f
183	HB	8	34	Wome	f	f
184	DO	8	35	Smolarek	f	f
185	M	8	37	Makaay	f	f
186	LEV	8	40	Voronin	f	f
187	B	8	50	Dardai	f	f
188	H	8	52	Rosenthal	f	f
189	F	8	57	Streit	f	f
398	AC	17	62	Reghecampf	f	t
407	N	17	92	Mnari	f	t
22	HB	1	91	Jensen	f	f
23	N	2	4	Schroth	f	f
291	MG	12	84	Neuville	f	f
292	BI	12	84	Ndeng	f	f
25	B	2	20	Pantelic	f	f
26	HB	2	26	Klose	f	f
27	B	2	31	Dardai	f	f
28	HH	2	38	Sanago	f	f
29	GE	2	53	Rodriguez	f	f
30	B	2	63	Pantelic	f	f
32	CB	2	69	Radu	f	f
33	B	2	76	Ebert	f	f
34	DO	2	76	Amedick	f	f
35	HB	2	77	Almeida	f	f
36	MZ	2	77	Edu	f	f
37	HH	2	71	de Jong	f	f
38	M	2	43	Makaay	f	f
39	BO	2	52	Fabio Junior	f	f
40	M	2	65	Lahm	f	f
41	S	2	39	Meira	f	f
43	S	2	73	Cacau	f	f
44	BI	2	76	Böhme	f	f
45	S	2	82	Cacau	f	f
46	GE	3	7	Kuranyi	f	f
47	AC	3	15	Schlaudraff	f	f
48	HH	3	18	Sanogo	f	f
50	F	3	25	Amanatidis	f	f
51	S	3	30	Tasci	f	f
52	DO	3	32	Kringe	f	f
53	AC	3	47	Dum	f	f
54	LEV	3	49	Juan	f	f
55	MG	3	60	Kahé	f	f
56	B	3	64	Gimenez	f	f
58	GE	3	72	Hamit Altintop	f	f
59	AC	3	72	Plaßhenrich	f	f
60	MZ	3	84	Jovanovic	f	f
61	CB	3	86	da Silva	f	f
62	DO	3	88	Frei	f	f
64	M	4	6	van Bommel	f	f
387	AC	16	72	Reghecampf	f	f
388	AC	16	78	Herzig	f	f
66	BO	4	10	Gekas	f	f
67	BI	4	25	Wichniarek	f	f
68	N	4	39	Polak	f	f
69	AC	4	31	Schlaudraff	f	f
70	HB	4	33	Zidan	f	f
71	S	4	38	Hilbert	f	f
72	B	4	39	Gimenez	f	f
73	CB	4	49	Radu	f	f
74	MG	4	50	Kahé	f	f
75	H	4	51	Brdaric	f	f
76	AC	4	51	Ebbers	f	f
77	WO	4	52	Krznowek	f	f
78	B	4	52	Gimenez	f	f
79	LEV	4	52	Madouni	f	f
266	N	11	92	Banovic	f	t
293	DO	12	85	Kraska	f	t
305	DO	13	23	Frei	f	t
308	BO	13	29	Misimovic	f	t
327	HH	14	18	van der Vaart	f	t
351	HB	15	23	Diego	f	t
172	CB	7	89	Munteanu	f	t
174	F	8	4	Amanatidis	f	t
212	N	9	59	Mnari	f	t
246	Do	10	93	Frei	f	t
247	WO	11	4	Hanke	f	t
148	BI	7	25	Böhme	f	t
391	MG	17	85	Kahé	t	f
406	HH	17	90	Reinhardt	t	f
49	S	3	20	Magnin	t	f
57	LEV	3	70	Madouni	t	f
63	S	4	4	Hilbert	t	f
191	M	8	62	Lucio	t	f
250	MG	11	11	Antonio	t	f
321	N	13	69	Paulus	t	f
370	MZ	16	17	Demirtas	t	f
3	BI	1	31	Eigler	f	f
4	HH	1	66	Sanogo	f	f
5	GE	1	29	Halil Altintop	f	f
6	F	1	72	Amanatidis	f	f
7	LEV	1	31	Ramelow	f	f
8	LEV	1	44	Castro	f	f
9	LEV	1	59	Rolfes	f	f
10	N	1	36	Vittek	f	f
11	N	1	45	Schroth	f	f
12	N	1	77	Saenko	f	f
13	MG	1	50	Svensson	f	f
14	MG	1	59	Neuville	f	t
15	MZ	1	28	Damm	f	f
16	MZ	1	79	Azaouagh	f	t
17	H	1	40	Stajner	f	f
18	H	1	66	Hashemian	f	f
19	HB	1	18	Diego	f	f
20	HB	1	78	Almeida	f	f
21	HB	1	84	Klose	f	f
24	LEV	2	15	Freier	f	t
31	CB	2	56	Munteanu	f	t
42	BI	2	65	Ahanfouf	f	t
65	AC	4	7	Reghecampf	f	t
\.


--
-- Name: torereignisse_sq; Type: SEQUENCE SET; Schema: bundesliga0607; Owner: postgres
--

SELECT pg_catalog.setval('torereignisse_sq', 1, false);


--
-- Data for Name: vereine; Type: TABLE DATA; Schema: bundesliga0607; Owner: postgres
--

COPY vereine (name, stadt, trainer, kurzform) FROM stdin;
Alemannia	Aachen	Frontzek	AC
Hertha BSC	Berlin	Götz	B
Arminia	Bielefeld	von Heesen	BI
VfL	Bochum	Koller	BO
Energie	Cottbus	Sander	CB
Borussia	Dortmund	van Marwijk	DO
Eintracht	Frankfurt	Funkel	F
Schalke 04	Gelsenkirchen	Slomka	GE
96	Hannover	Hecking	H
Werder	Bremen	Schaaf	HB
SV	Hamburg	Doll	HH
Bayer	Leverkusen	Skibbe	LEV
Bayern	München	Magath	M
Borussia	Mönchengladbach	Heynckes	MG
05	Mainz	Klopp	MZ
1. FC	Nürnberg	Meyer	N
VfB	Stuttgart	Veh	S
VfL	Wolfsburg	Augenthaler	WO
\.


--
-- Name: punktabzug_pkey; Type: CONSTRAINT; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY punktabzug
    ADD CONSTRAINT punktabzug_pkey PRIMARY KEY (verein);


--
-- Name: spielpaarungen_pkey; Type: CONSTRAINT; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spielpaarungen
    ADD CONSTRAINT spielpaarungen_pkey PRIMARY KEY (spieltag, heim);


--
-- Name: torereignisse_pkey; Type: CONSTRAINT; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY torereignisse
    ADD CONSTRAINT torereignisse_pkey PRIMARY KEY (id);


--
-- Name: vereine_pkey; Type: CONSTRAINT; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vereine
    ADD CONSTRAINT vereine_pkey PRIMARY KEY (kurzform);


--
-- Name: vereine_idx1; Type: INDEX; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

CREATE INDEX vereine_idx1 ON vereine USING btree (name);


--
-- Name: vereine_idx2; Type: INDEX; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

CREATE INDEX vereine_idx2 ON vereine USING btree (stadt);


--
-- Name: vereine_idx3; Type: INDEX; Schema: bundesliga0607; Owner: postgres; Tablespace: 
--

CREATE INDEX vereine_idx3 ON vereine USING btree (trainer);


--
-- Name: bundesliga0607; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA bundesliga0607 FROM PUBLIC;
REVOKE ALL ON SCHEMA bundesliga0607 FROM postgres;
GRANT ALL ON SCHEMA bundesliga0607 TO postgres;


--
-- Name: torereignisse; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE torereignisse FROM PUBLIC;
REVOKE ALL ON TABLE torereignisse FROM postgres;
GRANT ALL ON TABLE torereignisse TO postgres;


--
-- Name: Eigentore; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Eigentore" FROM PUBLIC;
REVOKE ALL ON TABLE "Eigentore" FROM postgres;
GRANT ALL ON TABLE "Eigentore" TO postgres;


--
-- Name: ReguläreTore; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "ReguläreTore" FROM PUBLIC;
REVOKE ALL ON TABLE "ReguläreTore" FROM postgres;
GRANT ALL ON TABLE "ReguläreTore" TO postgres;


--
-- Name: spielpaarungen; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE spielpaarungen FROM PUBLIC;
REVOKE ALL ON TABLE spielpaarungen FROM postgres;
GRANT ALL ON TABLE spielpaarungen TO postgres;


--
-- Name: Gegentore; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Gegentore" FROM PUBLIC;
REVOKE ALL ON TABLE "Gegentore" FROM postgres;
GRANT ALL ON TABLE "Gegentore" TO postgres;


--
-- Name: Tore; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Tore" FROM PUBLIC;
REVOKE ALL ON TABLE "Tore" FROM postgres;
GRANT ALL ON TABLE "Tore" TO postgres;


--
-- Name: Spielereignisse; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Spielereignisse" FROM PUBLIC;
REVOKE ALL ON TABLE "Spielereignisse" FROM postgres;
GRANT ALL ON TABLE "Spielereignisse" TO postgres;


--
-- Name: SpieleA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "SpieleA" FROM PUBLIC;
REVOKE ALL ON TABLE "SpieleA" FROM postgres;
GRANT ALL ON TABLE "SpieleA" TO postgres;


--
-- Name: NiederlagenA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "NiederlagenA" FROM PUBLIC;
REVOKE ALL ON TABLE "NiederlagenA" FROM postgres;
GRANT ALL ON TABLE "NiederlagenA" TO postgres;


--
-- Name: vereine; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE vereine FROM PUBLIC;
REVOKE ALL ON TABLE vereine FROM postgres;
GRANT ALL ON TABLE vereine TO postgres;


--
-- Name: CountNiederlagenA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "CountNiederlagenA" FROM PUBLIC;
REVOKE ALL ON TABLE "CountNiederlagenA" FROM postgres;
GRANT ALL ON TABLE "CountNiederlagenA" TO postgres;


--
-- Name: SpieleH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "SpieleH" FROM PUBLIC;
REVOKE ALL ON TABLE "SpieleH" FROM postgres;
GRANT ALL ON TABLE "SpieleH" TO postgres;


--
-- Name: NiederlagenH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "NiederlagenH" FROM PUBLIC;
REVOKE ALL ON TABLE "NiederlagenH" FROM postgres;
GRANT ALL ON TABLE "NiederlagenH" TO postgres;


--
-- Name: CountNiederlagenH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "CountNiederlagenH" FROM PUBLIC;
REVOKE ALL ON TABLE "CountNiederlagenH" FROM postgres;
GRANT ALL ON TABLE "CountNiederlagenH" TO postgres;


--
-- Name: SiegeA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "SiegeA" FROM PUBLIC;
REVOKE ALL ON TABLE "SiegeA" FROM postgres;
GRANT ALL ON TABLE "SiegeA" TO postgres;


--
-- Name: CountSiegeA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "CountSiegeA" FROM PUBLIC;
REVOKE ALL ON TABLE "CountSiegeA" FROM postgres;
GRANT ALL ON TABLE "CountSiegeA" TO postgres;


--
-- Name: SiegeH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "SiegeH" FROM PUBLIC;
REVOKE ALL ON TABLE "SiegeH" FROM postgres;
GRANT ALL ON TABLE "SiegeH" TO postgres;


--
-- Name: CountSiegeH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "CountSiegeH" FROM PUBLIC;
REVOKE ALL ON TABLE "CountSiegeH" FROM postgres;
GRANT ALL ON TABLE "CountSiegeH" TO postgres;


--
-- Name: CountToreProSpieltag; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "CountToreProSpieltag" FROM PUBLIC;
REVOKE ALL ON TABLE "CountToreProSpieltag" FROM postgres;
GRANT ALL ON TABLE "CountToreProSpieltag" TO postgres;


--
-- Name: UnentschiedenA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "UnentschiedenA" FROM PUBLIC;
REVOKE ALL ON TABLE "UnentschiedenA" FROM postgres;
GRANT ALL ON TABLE "UnentschiedenA" TO postgres;


--
-- Name: CountUnentschiedenA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "CountUnentschiedenA" FROM PUBLIC;
REVOKE ALL ON TABLE "CountUnentschiedenA" FROM postgres;
GRANT ALL ON TABLE "CountUnentschiedenA" TO postgres;


--
-- Name: UnentschiedenH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "UnentschiedenH" FROM PUBLIC;
REVOKE ALL ON TABLE "UnentschiedenH" FROM postgres;
GRANT ALL ON TABLE "UnentschiedenH" TO postgres;


--
-- Name: CountUnentschiedenH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "CountUnentschiedenH" FROM PUBLIC;
REVOKE ALL ON TABLE "CountUnentschiedenH" FROM postgres;
GRANT ALL ON TABLE "CountUnentschiedenH" TO postgres;


--
-- Name: Elfmeterschützenliste; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Elfmeterschützenliste" FROM PUBLIC;
REVOKE ALL ON TABLE "Elfmeterschützenliste" FROM postgres;
GRANT ALL ON TABLE "Elfmeterschützenliste" TO postgres;


--
-- Name: Niederlagen; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Niederlagen" FROM PUBLIC;
REVOKE ALL ON TABLE "Niederlagen" FROM postgres;
GRANT ALL ON TABLE "Niederlagen" TO postgres;


--
-- Name: PunkteA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "PunkteA" FROM PUBLIC;
REVOKE ALL ON TABLE "PunkteA" FROM postgres;
GRANT ALL ON TABLE "PunkteA" TO postgres;


--
-- Name: PunkteH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "PunkteH" FROM PUBLIC;
REVOKE ALL ON TABLE "PunkteH" FROM postgres;
GRANT ALL ON TABLE "PunkteH" TO postgres;


--
-- Name: TorbilanzA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "TorbilanzA" FROM PUBLIC;
REVOKE ALL ON TABLE "TorbilanzA" FROM postgres;
GRANT ALL ON TABLE "TorbilanzA" TO postgres;


--
-- Name: TabelleOhnePositionenA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "TabelleOhnePositionenA" FROM PUBLIC;
REVOKE ALL ON TABLE "TabelleOhnePositionenA" FROM postgres;
GRANT ALL ON TABLE "TabelleOhnePositionenA" TO postgres;


--
-- Name: TorbilanzH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "TorbilanzH" FROM PUBLIC;
REVOKE ALL ON TABLE "TorbilanzH" FROM postgres;
GRANT ALL ON TABLE "TorbilanzH" TO postgres;


--
-- Name: TabelleOhnePositionenH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "TabelleOhnePositionenH" FROM PUBLIC;
REVOKE ALL ON TABLE "TabelleOhnePositionenH" FROM postgres;
GRANT ALL ON TABLE "TabelleOhnePositionenH" TO postgres;


--
-- Name: punktabzug; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE punktabzug FROM PUBLIC;
REVOKE ALL ON TABLE punktabzug FROM postgres;
GRANT ALL ON TABLE punktabzug TO postgres;


--
-- Name: TabelleOhnePositionen; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "TabelleOhnePositionen" FROM PUBLIC;
REVOKE ALL ON TABLE "TabelleOhnePositionen" FROM postgres;
GRANT ALL ON TABLE "TabelleOhnePositionen" TO postgres;


--
-- Name: Positionen; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Positionen" FROM PUBLIC;
REVOKE ALL ON TABLE "Positionen" FROM postgres;
GRANT ALL ON TABLE "Positionen" TO postgres;


--
-- Name: PositionenA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "PositionenA" FROM PUBLIC;
REVOKE ALL ON TABLE "PositionenA" FROM postgres;
GRANT ALL ON TABLE "PositionenA" TO postgres;


--
-- Name: PositionenH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "PositionenH" FROM PUBLIC;
REVOKE ALL ON TABLE "PositionenH" FROM postgres;
GRANT ALL ON TABLE "PositionenH" TO postgres;


--
-- Name: Siege; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Siege" FROM PUBLIC;
REVOKE ALL ON TABLE "Siege" FROM postgres;
GRANT ALL ON TABLE "Siege" TO postgres;


--
-- Name: Tabelle; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Tabelle" FROM PUBLIC;
REVOKE ALL ON TABLE "Tabelle" FROM postgres;
GRANT ALL ON TABLE "Tabelle" TO postgres;


--
-- Name: TabelleA; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "TabelleA" FROM PUBLIC;
REVOKE ALL ON TABLE "TabelleA" FROM postgres;
GRANT ALL ON TABLE "TabelleA" TO postgres;


--
-- Name: TabelleH; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "TabelleH" FROM PUBLIC;
REVOKE ALL ON TABLE "TabelleH" FROM postgres;
GRANT ALL ON TABLE "TabelleH" TO postgres;


--
-- Name: Torschützenliste; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Torschützenliste" FROM PUBLIC;
REVOKE ALL ON TABLE "Torschützenliste" FROM postgres;
GRANT ALL ON TABLE "Torschützenliste" TO postgres;


--
-- Name: Unentschieden; Type: ACL; Schema: bundesliga0607; Owner: postgres
--

REVOKE ALL ON TABLE "Unentschieden" FROM PUBLIC;
REVOKE ALL ON TABLE "Unentschieden" FROM postgres;
GRANT ALL ON TABLE "Unentschieden" TO postgres;


--
-- PostgreSQL database dump complete
--

