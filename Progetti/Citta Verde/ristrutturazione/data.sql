-- Inserimento dei dati nella tabella TipologiaAttivita
INSERT INTO TipologiaAttivita (nome)
VALUES ('Piantagione'), ('Potatura'), ('Monitoraggio');

-- Inserimento dei dati nella tabella Attrezzatura
INSERT INTO Attrezzatura (nome)
VALUES ('Pala'), ('Tagliaerba'), ('Scala');

-- Inserimento dei dati nella tabella attr_ta
INSERT INTO attr_ta (attr, ta)
VALUES ('Pala', 'Piantagione'),
       ('Tagliaerba', 'Potatura'),
       ('Scala', 'Monitoraggio');

-- Inserimento dei dati nella tabella Persona
INSERT INTO Persona (cf, nome, cognome)
VALUES ('CF001', 'Mario', 'Rossi'),
       ('CF002', 'Anna', 'Verdi'),
       ('CF003', 'Luigi', 'Bianchi');

-- Inserimento dei dati nella tabella Operatore
INSERT INTO Operatore (id, inizio, fine, cf_persona)
VALUES (1, '2023-01-01 08:00:00', NULL, 'CF001'),
       (2, '2023-01-02 09:00:00', '2023-01-02 17:00:00', 'CF002'),
       (3, '2023-01-03 10:00:00', NULL, 'CF003');

-- Inserimento dei dati nella tabella Squadra
INSERT INTO Squadra (id, inizio, fine)
VALUES ('S001', '2023-01-01 08:00:00', NULL),
       ('S002', '2023-01-02 09:00:00', '2023-01-02 17:00:00'),
       ('S003', '2023-01-03 10:00:00', NULL);

-- Inserimento dei dati nella tabella Partecipa
INSERT INTO Partecipa (id, inizio, fine, capo, id_operatore, id_squadra)
VALUES (1, '2023-01-01 08:00:00', NULL, TRUE, 1, 'S001'),
       (2, '2023-01-02 09:00:00', '2023-01-02 17:00:00', FALSE, 2, 'S002'),
       (3, '2023-01-03 10:00:00', NULL, TRUE, 3, 'S003');

-- Inserimento dei dati nella tabella PuoUtilizzare
INSERT INTO PuoUtilizzare (id, inizio, fine, attr, id_operatore)
VALUES (1, '2023-01-01 08:00:00', NULL, 'Pala', 1),
       (2, '2023-01-02 09:00:00', '2023-01-02 17:00:00', 'Tagliaerba', 2),
       (3, '2023-01-03 10:00:00', NULL, 'Scala', 3);

-- Inserimento dei dati nella tabella AreaVerde
INSERT INTO AreaVerde (nome, isFruibile, isSensibile)
VALUES ('Giardino pubblico', TRUE, TRUE),
       ('Parco naturale', TRUE, FALSE),
       ('Orto botanico', FALSE, TRUE);

-- Inserimento dei dati nella tabella Intervento
INSERT INTO Intervento (id, id_attivita, inizio, fine, id_operatore, area_verde)
VALUES (1, 5, '2023-01-01 08:00:00', '2023-01-01 12:00:00', 3, 'Giardino pubblico'),
       (2, 3, '2023-01-02 09:00:00', '2023-01-02 13:00:00', 2, 'Parco naturale'),
       (3, 4, '2023-01-03 10:00:00', '2023-01-03 14:00:00', 1, 'Orto botanico');
