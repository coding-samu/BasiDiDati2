-- Esercizio 1
SELECT posizione, COUNT(posizione) as numero FROM persona group by posizione;

-- Esercizio 2
SELECT COUNT(id) as numero FROM persona WHERE stipendio >= 40000;

-- Esercizio 3
SELECT count(id) as numero from progetto where budget > 50000 and fine < current_date; 

-- Esercizio 4
SELECT avg(oreDurata) as media, min(oreDurata) as minimo, max(oreDurata) as massimo FROM attivitaprogetto as ap, progetto as pr WHERE ap.progetto = pr.id and pr.nome = 'Pegasus';

-- Esercizio 5
select per.id as id_persona, per.nome, per.cognome, avg(ap.oreDurata) as media, min(ap.oreDurata) as minimo, max(ap.oreDurata) as massimo FROM persona as per, progetto as pro, attivitaprogetto as ap WHERE pro.id = ap.progetto AND pro.nome = 'Pegasus' AND ap.persona = per.id group by per.id;

-- Esercizio 6


-- Esercizio 7


-- Esercizio 8


-- Esercizio 9


-- Esercizio 10


-- Esercizio 11

