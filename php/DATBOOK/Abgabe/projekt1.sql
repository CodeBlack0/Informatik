--
--Aufgabe 3
--

DROP TABLE IF EXISTS partnercand;

CREATE TABLE partnercand (
	searcher integer,
	cand integer
);

INSERT INTO partnercand (searcher, cand) 
	SELECT searcher, id
	FROM dbuser, partner WHERE
	id != searcher AND
	(psex IS NULL OR sex = ANY(psex)) AND
	(page_min IS NULL OR page_min <= EXTRACT(year FROM age(bday))) AND
	(page_max IS NULL OR page_min >= EXTRACT(year FROM age(bday))) AND
	(psize_min IS NULL OR psize_min <= size) AND
	(psize_max IS NULL OR psize_max >= size) AND
	(phcolor IS NULL OR hcolor = ANY(phcolor)) AND
	(pecolor IS NULL OR ecolor = ANY(pecolor)) AND
	(pbody IS NULL OR body = ANY(pbody));

--
--Aufgabe 4
--

DROP TABLE IF EXISTS pair;

CREATE TABLE pair (
	p1 integer,
	p2 integer
);

INSERT INTO pair (p1, p2)
	SELECT t2.cand, t1.cand
	FROM partnercand AS t1, partnercand AS t2 WHERE
	t1.searcher = t2.cand AND
	t2.searcher = t1.cand AND
	t1.searcher < t2.searcher;

--
--Aufgabe 5
--

DROP TABLE IF EXISTS single;

CREATE TABLE single (
	s integer
);

INSERT INTO single (s)
	SELECT id
	FROM dbuser EXCEPT
	SELECT p1
	FROM pair EXCEPT
	SELECT p2
	FROM pair;
