--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: windsor; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA windsor;


ALTER SCHEMA windsor OWNER TO postgres;

--
-- Name: SCHEMA windsor; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA windsor IS 'Beispielschema für VL IS WS 10/11';


SET search_path = windsor, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: parents; Type: TABLE; Schema: windsor; Owner: postgres; Tablespace: 
--

CREATE TABLE parents (
    child character varying(50),
    father character varying(50),
    mother character varying(50)
);


ALTER TABLE windsor.parents OWNER TO postgres;

--
-- Name: royals; Type: TABLE; Schema: windsor; Owner: postgres; Tablespace: 
--

CREATE TABLE royals (
    title character varying(50),
    name character varying(50),
    born integer,
    died integer,
    sex character(1)
);


ALTER TABLE windsor.royals OWNER TO postgres;

--
-- Name: spouses; Type: TABLE; Schema: windsor; Owner: postgres; Tablespace: 
--

CREATE TABLE spouses (
    husband character varying(50),
    wife character varying(50),
    marriage integer,
    divorce integer
);


ALTER TABLE windsor.spouses OWNER TO postgres;

--
-- Data for Name: parents; Type: TABLE DATA; Schema: windsor; Owner: postgres
--

COPY parents (child, father, mother) FROM stdin;
Charles	Philip	Elizabeth II
Anne	Philip	Elizabeth II
Andrew	Philip	Elizabeth II
Edward	Philip	Elizabeth II
William	Charles	Diana
Henry	Charles	Diana
Peter	Mark	Anne
Zara	Mark	Anne
Louise	Edward	Sophie
James	Edward	Sophie
Beatrice	Andrew	Sarah
Eugenie	Andrew	Sarah
Charles	Philip	Elizabeth II
Anne	Philip	Elizabeth II
Andrew	Philip	Elizabeth II
Edward	Philip	Elizabeth II
William	Charles	Diana
Henry	Charles	Diana
Peter	Mark	Anne
Zara	Mark	Anne
Louise	Edward	Sophie
James	Edward	Sophie
Beatrice	Andrew	Sarah
Eugenie	Andrew	Sarah
Charles	Philip	Elizabeth II
Anne	Philip	Elizabeth II
Andrew	Philip	Elizabeth II
Edward	Philip	Elizabeth II
William	Charles	Diana
Henry	Charles	Diana
Peter	Mark	Anne
Zara	Mark	Anne
Louise	Edward	Sophie
James	Edward	Sophie
Beatrice	Andrew	Sarah
Eugenie	Andrew	Sarah
\.


--
-- Data for Name: royals; Type: TABLE DATA; Schema: windsor; Owner: postgres
--

COPY royals (title, name, born, died, sex) FROM stdin;
Prince	Philip	1921	\N	m
Queen	Elizabeth II	1926	\N	f
Duchess	Camilla	1947	\N	f
\N	Mark	1948	\N	m
Prince	Charles	1948	\N	m
Princess	Anne	1950	\N	f
\N	Timothy	1950	\N	m
Duchess	Sarah	1959	\N	f
Prince	Andrew	1960	\N	m
Princess	Diana	1961	1997	f
Prince	Edward	1964	\N	m
Countess	Sophie	1965	\N	f
\N	Serena	1970	\N	f
\N	Peter	1977	\N	m
\N	Zara	1981	\N	f
Prince	William	1982	\N	m
Prince	Henry	1984	\N	m
Princess	Beatrice	1988	\N	f
Princess	Eugenie	1990	\N	f
Lady	Louise	2003	\N	f
Viscount	James	2007	\N	m
Prince	Philip	1921	\N	m
Queen	Elizabeth II	1926	\N	f
Duchess	Camilla	1947	\N	f
\N	Mark	1948	\N	m
Prince	Charles	1948	\N	m
Princess	Anne	1950	\N	f
\N	Timothy	1950	\N	m
Duchess	Sarah	1959	\N	f
Prince	Andrew	1960	\N	m
Princess	Diana	1961	1997	f
Prince	Edward	1964	\N	m
Countess	Sophie	1965	\N	f
\N	Serena	1970	\N	f
\N	Peter	1977	\N	m
\N	Zara	1981	\N	f
Prince	William	1982	\N	m
Prince	Henry	1984	\N	m
Princess	Beatrice	1988	\N	f
Princess	Eugenie	1990	\N	f
Lady	Louise	2003	\N	f
Viscount	James	2007	\N	m
Prince	Philip	1921	\N	m
Queen	Elizabeth II	1926	\N	f
Duchess	Camilla	1947	\N	f
\N	Mark	1948	\N	m
Prince	Charles	1948	\N	m
Princess	Anne	1950	\N	f
\N	Timothy	1950	\N	m
Duchess	Sarah	1959	\N	f
Prince	Andrew	1960	\N	m
Princess	Diana	1961	1997	f
Prince	Edward	1964	\N	m
Countess	Sophie	1965	\N	f
\N	Serena	1970	\N	f
\N	Peter	1977	\N	m
\N	Zara	1981	\N	f
Prince	William	1982	\N	m
Prince	Henry	1984	\N	m
Princess	Beatrice	1988	\N	f
Princess	Eugenie	1990	\N	f
Lady	Louise	2003	\N	f
Viscount	James	2007	\N	m
\.


--
-- Data for Name: spouses; Type: TABLE DATA; Schema: windsor; Owner: postgres
--

COPY spouses (husband, wife, marriage, divorce) FROM stdin;
Philip	Elizabeth II	1947	\N
Mark	Anne	1973	1992
Timothy	Anne	1992	\N
Charles	Diana	1981	1996
Charles	Camilla	2005	\N
Andrew	Sarah	1986	1996
Edward	Sophie	1999	\N
Philip	Elizabeth II	1947	\N
Mark	Anne	1973	1992
Timothy	Anne	1992	\N
Charles	Diana	1981	1996
Charles	Camilla	2005	\N
Andrew	Sarah	1986	1996
Edward	Sophie	1999	\N
Philip	Elizabeth II	1947	\N
Mark	Anne	1973	1992
Timothy	Anne	1992	\N
Charles	Diana	1981	1996
Charles	Camilla	2005	\N
Andrew	Sarah	1986	1996
Edward	Sophie	1999	\N
\.


--
-- Name: windsor; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA windsor FROM PUBLIC;
REVOKE ALL ON SCHEMA windsor FROM postgres;
GRANT ALL ON SCHEMA windsor TO postgres;


--
-- Name: parents; Type: ACL; Schema: windsor; Owner: postgres
--

REVOKE ALL ON TABLE parents FROM PUBLIC;
REVOKE ALL ON TABLE parents FROM postgres;
GRANT ALL ON TABLE parents TO postgres;


--
-- Name: royals; Type: ACL; Schema: windsor; Owner: postgres
--

REVOKE ALL ON TABLE royals FROM PUBLIC;
REVOKE ALL ON TABLE royals FROM postgres;
GRANT ALL ON TABLE royals TO postgres;


--
-- Name: spouses; Type: ACL; Schema: windsor; Owner: postgres
--

REVOKE ALL ON TABLE spouses FROM PUBLIC;
REVOKE ALL ON TABLE spouses FROM postgres;
GRANT ALL ON TABLE spouses TO postgres;


--
-- PostgreSQL database dump complete
--

