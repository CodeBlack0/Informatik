--Setup
DROP TABLE IF EXISTS pair;
DROP TABLE IF EXISTS single;
DROP TABLE IF EXISTS partnercand;
DROP TABLE IF EXISTS chats;
DROP TABLE IF EXISTS news;
DROP TABLE IF EXISTS partner;
DROP TABLE IF EXISTS dbuser;

DROP TYPE IF EXISTS hcolor_t;
DROP TYPE IF EXISTS ecolor_t;
DROP TYPE IF EXISTS body_t;
DROP TYPE IF EXISTS sex_t;

--Farbenumerationen erstellen
CREATE TYPE hcolor_t AS ENUM ('blond', 'dark blond', 'red', 'auburn', 'brown', 'dark brown', 'black', 'rainbow');
CREATE TYPE ecolor_t AS ENUM ('blue', 'teal', 'green', 'gray', 'brown', 'black');

--Staturenumeration erstellen
CREATE TYPE body_t AS ENUM ('skinny', 'slim', 'average', 'muscular', 'athletic', 'belly', 'stocky');

--Geschelchtenumerationen erstellen
CREATE TYPE sex_t AS ENUM ('m', 'f', 'mf');
	
--Tabelle für Benutzerprofile
CREATE TABLE dbuser (
	id serial PRIMARY KEY, 
	name text, 
	sex sex_t,
	bday date,
	size integer,
	hcolor hcolor_t,
	ecolor ecolor_t,
	body body_t,
	city text,
	hobbies text
);

--Tabelle für Partnerprofile
CREATE TABLE partner (
	searcher integer PRIMARY KEY REFERENCES dbuser(id) ON DELETE CASCADE,
	psex sex_t[],
	page_min integer,
	page_max integer,
	psize_min integer,
	psize_max integer,
	phcolor hcolor_t[],
	pecolor ecolor_t[],
	pbody body_t[],
	distance integer 
);

--Tabelle für Statusupdates
CREATE TABLE news (
	id serial PRIMARY KEY,
	sender integer NOT NULL REFERENCES dbuser(id) ON DELETE RESTRICT,
	reciever integer NOT NULL REFERENCES dbuser(id) ON DELETE RESTRICT,
	ts_sent timestamp NOT NULL DEFAULT now(),
	ts_read timestamp,
	message	text NOT NULL
);

--Tabelle für Privatenachrichten
CREATE TABLE chats (
	Sender integer REFERENCES dbuser (ID),
	Reciever integer REFERENCES dbuser (ID),
	Text text,
	Sendtime timestamp,
	Recievetime timestamp,
	GPSDatum float[3],
	bilddatei text
);

--Tabelle für Partnercand
CREATE TABLE partnercand (
	searcher integer REFERENCES partner(searcher),
	cand integer REFERENCES dbuser(id)
);

--Tabelle für Pair
CREATE TABLE pair (
	p1 integer,
	p2 integer
);

--Tabelle für Single
CREATE TABLE single (
	s integer REFERENCES dbuser(id)
);

--Daten laden
\i /home/public/Datebook/dbuser.sql
\i /home/public/Datebook/partner.sql

--Partnercand füllen
INSERT INTO partnercand (searcher, cand) 
	SELECT searcher, id
	FROM dbuser, partner WHERE
	searcher != id AND
	(sex = ANY(psex)				OR psex 	IS NULL) AND
	(page_min <= EXTRACT(year FROM age(bday)) 	OR page_min 	IS NULL) AND
	(EXTRACT(year FROM age(bday)) <= page_max 	OR page_max 	IS NULL) AND	
	(psize_min <= size				OR psize_min 	IS NULL) AND
	(size <= psize_max				OR psize_max 	IS NULL) AND
	(hcolor = ANY(phcolor)				OR phcolor	IS NULL) AND
	(ecolor = ANY(pecolor)				OR pecolor	IS NULL) AND
	(body = ANY(pbody) 				OR pbody	IS NULL);

--Pair füllen
INSERT INTO pair (p1, p2)
	SELECT DISTINCT t1.searcher, t1.cand
	FROM partnercand AS t1, partnercand AS t2 WHERE
	t1.searcher = t2.cand AND
	t2.searcher = t1.cand AND
	t1.searcher < t2.searcher;

--Single füllen
INSERT INTO single (s)
	SELECT DISTINCT id
	FROM dbuser EXCEPT
	SELECT p1
	FROM pair EXCEPT
	SELECT p2
	FROM pair;
