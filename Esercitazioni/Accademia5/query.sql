SELECT wp.id, wp.nome, wp.inizio, wp.fine FROM wp, progetto WHERE progetto.id = wp.progetto and progetto.nome = 'Pegasus';

SELECT DISTINCT persona.id, persona.nome, persona.cognome FROM persona, attivitaprogetto, progetto WHERE persona.id = attivitaprogetto.persona and attivitaprogetto.progetto = progetto.id and progetto.nome = 'Pegasus' ORDER BY cognome desc;

SELECT persona.id, persona.nome, persona.cognome, persona.posizione FROM persona, attivitaprogetto, progetto WHERE persona.id = attivitaprogetto.persona and attivitaprogetto.progetto = progetto.id and progetto.nome = 'Pegasus' GROUP BY persona.id HAVING COUNT(*)>1;

SELECT persona.id, persona.nome, persona.cognome FROM persona,assenza WHERE persona.id = assenza.persona AND persona.posizione = 'Professore Ordinario' and assenza.tipo = 'Malattia' GROUP BY persona.id HAVING COUNT(*) >= 1;

SELECT persona.id, persona.nome, persona.cognome FROM persona, assenza WHERE persona.id = assenza.persona and assenza.tipo = 'Malattia' and persona.posizione = 'Professore Ordinario' GROUP BY persona.id HAVING COUNT(*) > 1;

SELECT persona.id, persona.nome, persona.cognome FROM persona, attivitanonprogettuale WHERE persona.id = attivitanonprogettuale.persona AND attivitanonprogettuale.tipo = 'Didattica' AND persona.posizione = 'Ricercatore' GROUP BY persona.id HAVING COUNT(*) >= 1;

SELECT persona.id, persona.nome, persona.cognome FROM persona, attivitanonprogettuale WHERE persona.id = attivitanonprogettuale.persona AND attivitanonprogettuale.tipo = 'Didattica' AND persona.posizione = 'Ricercatore' GROUP BY persona.id HAVING COUNT(*) > 1;

SELECT persona.id, persona.nome, persona.cognome FROM persona, attivitaprogetto, attivitanonprogettuale WHERE persona.id = attivitanonprogettuale.persona and persona.id = attivitaprogetto.persona and attivitaprogetto.giorno = attivitanonprogettuale.giorno GROUP BY persona.id HAVING COUNT(*) >= 1;


