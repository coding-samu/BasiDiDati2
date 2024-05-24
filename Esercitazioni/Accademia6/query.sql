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
select per.id as id_persona, per.nome, per.cognome, sum(anp.oreDurata) as ore_didattica FROM persona as per, attivitanonprogettuale as anp WHERE per.id = anp.persona and anp.tipo = 'Didattica' GROUP BY per.id;

-- Esercizio 7
select avg(stipendio) as media, min(stipendio) as minimo, max(stipendio) as massimo FROM persona WHERE posizione = 'Ricercatore'; 

-- Esercizio 8
select posizione, avg(stipendio) as media, min(stipendio) as minimo, max(stipendio) as massimo FROM persona GROUP BY posizione;

-- Esercizio 9
select pr.id as id_progetto, pr.nome as progetto, sum(ap.oreDurata) FROM progetto as pr, attivitaprogetto as ap, persona as per WHERE pr.id = ap.progetto AND ap.persona = per.id AND per.nome = 'Ginevra' and per.cognome = 'Riva' GROUP BY pr.id;

-- Esercizio 10
select id_progetto, progetto from (select pr.id as id_progetto, pr.nome as progetto, count(ap.persona) as somma FROM progetto as pr, attivitaprogetto as ap WHERE ap.progetto = pr.id group by pr.id) as ta WHERE somma > 2;

-- Esercizio 11
select id_persona, nome, cognome FROM (select per.id as id_persona, per.nome, per.cognome, sum(ap.progetto) as somma FROM persona as per, attivitaprogetto as ap WHERE per.posizione = 'Professore Associato' and ap.persona = per.id group by per.id) as ta WHERE somma > 1;
