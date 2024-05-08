SELECT wp.id, wp.nome, wp.inizio, wp.fine FROM wp, progetto WHERE progetto.id = wp.progetto and progetto.nome = 'Pegasus';

SELECT DISTINCT persona.id, persona.nome, persona.cognome FROM persona, attivitaprogetto, progetto WHERE persona.id = attivitaprogetto.persona and attivitaprogetto.progetto = progetto.id and progetto.nome = 'Pegasus' ORDER BY cognome desc;

SELECT persona.id, persona.nome, persona.cognome, persona.posizione FROM persona, attivitaprogetto, progetto WHERE persona.id = attivitaprogetto.persona and attivitaprogetto.progetto = progetto.id and progetto.nome = 'Pegasus' GROUP BY persona.id HAVING COUNT(*)>1;

SELECT persona.id, persona.nome, persona.cognome FROM persona,assenza WHERE persona.id = assenza.persona AND persona.posizione = 'Professore Ordinario' and assenza.tipo = 'Malattia' GROUP BY persona.id HAVING COUNT(*) >= 1;

SELECT persona.id, persona.nome, persona.cognome FROM persona, assenza WHERE persona.id = assenza.persona and assenza.tipo = 'Malattia' and persona.posizione = 'Professore Ordinario' GROUP BY persona.id HAVING COUNT(*) > 1;

SELECT persona.id, persona.nome, persona.cognome FROM persona, attivitanonprogettuale WHERE persona.id = attivitanonprogettuale.persona AND attivitanonprogettuale.tipo = 'Didattica' AND persona.posizione = 'Ricercatore' GROUP BY persona.id HAVING COUNT(*) >= 1;

SELECT persona.id, persona.nome, persona.cognome FROM persona, attivitanonprogettuale WHERE persona.id = attivitanonprogettuale.persona AND attivitanonprogettuale.tipo = 'Didattica' AND persona.posizione = 'Ricercatore' GROUP BY persona.id HAVING COUNT(*) > 1;

SELECT persona.id, persona.nome, persona.cognome FROM persona, attivitaprogetto, attivitanonprogettuale WHERE persona.id = attivitanonprogettuale.persona and persona.id = attivitaprogetto.persona and attivitaprogetto.giorno = attivitanonprogettuale.giorno GROUP BY persona.id HAVING COUNT(*) >= 1;

SELECT persona.id, persona.nome, persona.cognome, attivitaprogetto.giorno as giorno, progetto.nome as prj, attivitaprogetto.oredurata as h_prj, attivitanonprogettuale.tipo as att_noprj, attivitanonprogettuale.oredurata as h_noprj FROM persona, attivitaprogetto, attivitanonprogettuale, progetto WHERE persona.id = attivitaprogetto.persona and persona.id = attivitanonprogettuale.persona and attivitanonprogettuale.giorno = attivitaprogetto.giorno and progetto.id = attivitaprogetto.progetto;

SELECT progetto.nome as pnome, attivitanonprogettuale.tipo as nptipo, attivitaprogetto.giorno as giorno FROM attivitaprogetto, attivitanonprogettuale, persona, progetto WHERE persona.id = attivitaprogetto.persona and attivitaprogetto.progetto = progetto.id and persona.id = attivitanonprogettuale.persona and attivitaprogetto.giorno = attivitanonprogettuale.giorno;

SELECT persona.id, persona.nome, persona.cognome FROM persona, attivitaprogetto, assenza WHERE attivitaprogetto.persona = persona.id and assenza.persona = persona.id and assenza.giorno = attivitaprogetto.giorno;

SELECT per.id, per.nome, per.cognome, ap.giorno as giorno, ass.tipo as causa_ass, pr.nome as progetto, ap.oredurata FROM persona as per, attivitaprogetto as ap, assenza as ass, progetto as pr WHERE ass.giorno = ap.giorno and per.id = ass.persona and per.id = ap.persona and pr.id = ap.progetto;

SELECT DISTINCT wp1.nome FROM wp as wp1, wp as wp2, progetto WHERE wp1.nome = wp2.nome and wp1.progetto != wp2.progetto;
