DROP TABLE IF EXISTS partnercand;

CREATE TABLE partnercand (
	searcher integer REFERENCES partner(searcher),
	cand integer REFERENCES dbuser(id)
);

INSERT INTO partnercand (searcher, cand) 
	SELECT searcher, id
	FROM dbuser, partner WHERE
	searcher != id AND
	(sex = ANY(psex) 							OR psex 		IS NULL) AND
	(page_min <= EXTRACT(year FROM age(bday)) 	OR page_min 	IS NULL) AND
	(EXTRACT(year FROM age(bday)) <= page_max 	OR page_max 	IS NULL) AND	
	(psize_min <= size 							OR psize_min 	IS NULL) AND
	(size <= psize_max 							OR psize_max 	IS NULL) AND
	(hcolor = ANY(phcolor) 						OR phcolor 		IS NULL) AND
	(ecolor = ANY(pecolor) 						OR pecolor 		IS NULL) AND
	(body = ANY(pbody) 							OR pbody 		IS NULL);

DROP TABLE IF EXISTS pair;
	
CREATE TABLE pair (
	p1 integer,
	p2 integer
);

INSERT INTO pair (p1, p2)
	SELECT DISTINCT t1.searcher, t1.cand
	FROM partnercand AS t1, partnercand AS t2 WHERE
	t1.searcher = t2.cand AND
	t2.searcher = t1.cand AND
	t1.searcher < t2.searcher;

DROP TABLE IF EXISTS single;
	
CREATE TABLE single (
	s integer REFERENCES dbuser(id)
);

INSERT INTO single (s)
	SELECT DISTINCT id
	FROM dbuser EXCEPT
	SELECT p1
	FROM pair EXCEPT
	SELECT p2
	FROM pair;