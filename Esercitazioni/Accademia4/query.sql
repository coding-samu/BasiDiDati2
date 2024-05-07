SELECT DISTINCT id, cognome FROM persona;

SELECT id, nome, cognome FROM persona WHERE posizione = 'Ricercatore';

SELECT id, nome, cognome FROM persona WHERE posizione = 'Professore Associato' and cognome like 'V%';

SELECT id, nome, cognome FROM persona WHERE (posizione = 'Professore Associato' or posizione = 'Professore Ordinario') and cognome like 'V%';

SELECT id, nome, inizio, fine, budget FROM progetto WHERE fine < current_date;

SELECT id, nome FROM progetto ORDER BY inizio asc;

SELECT id, nome FROM wp ORDER BY nome asc;

SELECT DISTINCT tipo from assenza;

SELECT DISTINCT tipo from attivitaprogetto;

SELECT DISTINCT giorno FROM attivitanonprogettuale WHERE tipo = 'Didattica';
