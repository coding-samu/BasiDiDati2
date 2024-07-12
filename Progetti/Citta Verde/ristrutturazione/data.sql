begin transaction;

-- Inserimento dati di esempio per le tabelle

-- Inserimento dati per la tabella Persona
INSERT INTO Persona (codFisc, nome, cognome) VALUES
    ('ABCDEF01A', 'Mario', 'Rossi'),
    ('GHILMN02B', 'Luigi', 'Verdi'),
    ('OPQRST03C', 'Anna', 'Bianchi'),
    ('UVWXYZ04D', 'Giulia', 'Neri');

-- Inserimento dati per la tabella Operatore
INSERT INTO Operatore (inizio, fine, persona)
VALUES
    ('2023-01-15 08:00:00', '2023-12-31 17:00:00', 'ABCDEF01A'),
    ('2023-02-01 09:00:00', '2023-12-31 16:30:00', 'GHILMN02B'),
    ('2023-03-10 07:30:00', NULL, 'OPQRST03C'),
    ('2023-04-05 08:30:00', NULL, 'UVWXYZ04D');

-- Inserimento dati per la tabella Squadra
INSERT INTO Squadra (codice, inizio, fine) VALUES
    ('SQUAD001', '2023-01-01 00:00:00', NULL),
    ('SQUAD002', '2023-02-01 00:00:00', NULL),
    ('SQUAD003', '2023-03-01 00:00:00', '2023-06-30 23:59:59'),
    ('SQUAD004', '2023-04-01 00:00:00', '2023-05-31 23:59:59');

-- Inserimento dati per la tabella Partecipa
INSERT INTO Partecipa (inizio, fine, isCapo, operatore, squadra) VALUES
    ('2023-01-01 08:00:00', '2023-12-31 17:00:00', true, 1, 'SQUAD001'),
    ('2023-02-01 09:00:00', '2023-12-31 16:30:00', false, 2, 'SQUAD001'),
    ('2023-03-01 08:00:00', '2023-06-30 17:00:00', true, 3, 'SQUAD003'),
    ('2023-04-01 09:00:00', '2023-05-31 16:30:00', false, 4, 'SQUAD004');

-- Inserimento dati per la tabella Attrezzatura
INSERT INTO Attrezzatura (nome, tipologia) VALUES
    ('Motozappa', 'Strumento Leggero'),
    ('Escavatore', 'Veicolo'),
    ('Motosega', 'Strumento Leggero'),
    ('Autobotte', 'Veicolo speciale');

-- Inserimento dati per la tabella PuoUtilizzare
INSERT INTO PuoUtilizzare (inizio, fine, attrezzatura, operatore) VALUES
    ('2023-01-01 08:00:00', '2023-12-31 17:00:00', 'Motozappa', 1),
    ('2023-02-01 09:00:00', '2023-12-31 16:30:00', 'Escavatore', 2),
    ('2023-03-01 08:00:00', '2023-06-30 17:00:00', 'Motosega', 3),
    ('2023-04-01 09:00:00', '2023-05-31 16:30:00', 'Autobotte', 4);

-- Inserimento dati per la tabella AreaVerde
INSERT INTO AreaVerde (denominazione, isFruibile, isSensibile) VALUES
    ('Parco Nord', true, true),
    ('Giardino Villa Rossi', true, false),
    ('Parco Centrale', true, true),
    ('Area Verde San Pietro', true, true);

-- Inserimento dati per la tabella Intervento
INSERT INTO Intervento (minimoOperatori, inizio, durataGiorniStimata, priorita, areaVerde) VALUES
    (3, '2023-01-15 08:00:00', 5, 7, 'Parco Nord'),
    (2, '2023-02-01 09:00:00', 3, 5, 'Giardino Villa Rossi'),
    (4, '2023-03-10 07:30:00', 7, 8, 'Parco Centrale'),
    (3, '2023-04-05 08:30:00', 4, 6, 'Area Verde San Pietro');

-- Inserimento dati per la tabella Assegnato
INSERT INTO Assegnato (intervento, istanteAss, squadra) VALUES
    (1, '2023-01-16 08:00:00', 'SQUAD001'),
    (2, '2023-02-02 09:00:00', 'SQUAD002'),
    (3, '2023-03-11 07:30:00', 'SQUAD003'),
    (4, '2023-04-06 08:30:00', 'SQUAD004');

-- Inserimento dati per la tabella Completato
INSERT INTO Completato (intervento, istanteCompl) VALUES
    (1, '2023-01-20 16:00:00'),
    (2, '2023-02-04 15:30:00'),
    (3, '2023-03-18 16:00:00'),
    (4, '2023-04-09 15:00:00');

-- Inserimento dati per la tabella Specie
INSERT INTO Specie (nomeScientifico, nomeComune) VALUES
    ('Picea abies', 'Abete rosso'),
    ('Quercus robur', 'Quercia peduncolata'),
    ('Platanus hybrida', 'Platano'),
    ('Fraxinus excelsior', 'Frassino comune');

-- Inserimento dati per la tabella Causa
INSERT INTO Causa (nome) VALUES
    ('Infezione fungina'),
    ('Parassiti'),
    ('Taglio preventivo'),
    ('Condizioni meteorologiche estreme');


-- Inserimento dati per la tabella SoggettoVerde
INSERT INTO SoggettoVerde (dataPiantumazione, posizione, catRischio, rimozione, specie, causa, areaVerde) VALUES
    ('2022-12-15 10:00:00', '(45.4654, 9.1865)', 'Basso', NULL, 'Picea abies', NULL, 'Parco Nord'),
    ('2023-01-25 09:30:00', '(45.4643, 9.1818)', 'Medio', NULL, 'Quercus robur', NULL, 'Giardino Villa Rossi'),
    ('2023-03-20 11:15:00', '(45.4712, 9.1757)', 'Alto', '2023-04-02 14:00:00', 'Platanus hybrida', 'Taglio preventivo', 'Parco Centrale'),
    ('2023-04-10 08:45:00', '(45.4688, 9.1911)', 'Basso', NULL, 'Fraxinus excelsior', NULL, 'Area Verde San Pietro');

-- Inserimento dati per la tabella Malattia
INSERT INTO Malattia (nomeScientifico, nomeVolgare, gravita) VALUES
    ('Ceratocystis platani', 'Cancro colorato del platano', 'Alta'),
    ('Oidium mangiferae', 'Oidio', 'Media'),
    ('Phytophthora infestans', 'Peronospora', 'Bassa'),
    ('Xylella fastidiosa', 'Xylella', 'Mortale'),
    ('Armillaria mellea', 'Marciume radicale', 'Media'),
    ('Venturia inaequalis', 'Ticchiolatura', 'Bassa'),
    ('Pseudomonas syringae', 'Cancro batterico', 'Alta'),
    ('Verticillium dahliae', 'Verticillosi', 'Media'),
    ('Erysiphe necator', 'Mal bianco', 'Bassa'),
    ('Fusariosi', 'Fusariosi', 'Alta'),
    ('Aphididae', 'Afidi', 'Bassa'),
    ('Xylella', 'Xylella', 'Mortale'),
    ('Phytophthora', 'Phytophthora', 'Alta'),
    ('Botrytis cinerea', 'Muffa grigia', 'Media');

-- Inserimento dati per la tabella StoricoMalattia
INSERT INTO StoricoMalattia (scoperta, isRisolta, malattia, soggettoVerde, intervento) VALUES
    ('2023-01-18 12:00:00', true, 'Fusariosi', 1, 1),
    ('2023-02-05 14:30:00', false, 'Xylella', 2, NULL),
    ('2023-03-25 11:00:00', true, 'Aphididae', 3, 3),
    ('2023-04-12 09:00:00', false, 'Phytophthora', 4, NULL);

-- Inserimento dati per la tabella int_sv
INSERT INTO int_sv (intervento, soggettoVerde) VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4);

-- Inserimento dati per la tabella TipologiaAttivita
INSERT INTO TipologiaAttivita (nome) VALUES
    ('Potatura'),
    ('Ripiantumazione'),
    ('Monitoraggio'),
    ('Ripristino ambientale'),
    ('Trattamento fitosanitario');

-- Inserimento dati per la tabella int_ta
INSERT INTO int_ta (intervento, tipologiaAttivita) VALUES
    (1, 'Potatura'),
    (1, 'Ripiantumazione'),
    (2, 'Monitoraggio'),
    (3, 'Ripristino ambientale'),
    (4, 'Trattamento fitosanitario');

-- Inserimento dati per la tabella attr_ta
INSERT INTO attr_ta (tipologiaAttivita, attrezzatura) VALUES
    ('Potatura', 'Motozappa'),
    ('Potatura', 'Motosega'),
    ('Ripiantumazione', 'Autobotte'),
    ('Monitoraggio', 'Motosega'),
    ('Ripristino ambientale', 'Escavatore'),
    ('Trattamento fitosanitario', 'Motozappa');

commit;