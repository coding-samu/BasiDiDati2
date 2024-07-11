-- Inserimento di dati nella tabella TipologiaAttivita
INSERT INTO TipologiaAttivita (descrizione)
VALUES ('Piantagione'), ('Potatura'), ('Monitoraggio');

-- Inserimento di dati nella tabella Attrezzatura
INSERT INTO Attrezzatura (nome)
VALUES ('Pala'), ('Tagliaerba'), ('Scala');

-- Inserimento di dati nella tabella Persona
INSERT INTO Persona (codice_fiscale, nome, cognome)
VALUES ('CF001', 'Mario', 'Rossi'),
       ('CF002', 'Anna', 'Verdi'),
       ('CF003', 'Luigi', 'Bianchi');

-- Inserimento di dati nella tabella Operatore
INSERT INTO Operatore (id, inizio, fine, codice_fiscale)
VALUES (1, '2023-01-01 08:00:00', NULL, 'CF001'),
       (2, '2023-01-02 09:00:00', '2023-01-02 17:00:00', 'CF002'),
       (3, '2023-01-03 10:00:00', NULL, 'CF003');

-- Inserimento di dati nella tabella Squadra
INSERT INTO Squadra (id, inizio, fine)
VALUES ('S001', '2023-01-01 08:00:00', NULL),
       ('S002', '2023-01-02 09:00:00', '2023-01-02 17:00:00'),
       ('S003', '2023-01-03 10:00:00', NULL);

-- Inserimento di dati nella tabella Partecipa
INSERT INTO Partecipa (id, inizio, fine, capo, operatore_id, squadra_id)
VALUES (1, '2023-01-01 08:00:00', NULL, TRUE, 1, 'S001'),
       (2, '2023-01-02 09:00:00', '2023-01-02 17:00:00', FALSE, 2, 'S002'),
       (3, '2023-01-03 10:00:00', NULL, TRUE, 3, 'S003');

-- Inserimento di dati nella tabella PuoUtilizzare
INSERT INTO PuoUtilizzare (id, inizio, fine, attrezzatura, operatore_id)
VALUES (1, '2023-01-01 08:00:00', NULL, 'Pala', 1),
       (2, '2023-01-02 09:00:00', '2023-01-02 17:00:00', 'Tagliaerba', 2),
       (3, '2023-01-03 10:00:00', NULL, 'Scala', 3);

-- Inserimento di dati nella tabella AreaVerde
INSERT INTO AreaVerde (nome, isFruibile, isSensibile)
VALUES ('Giardino pubblico', TRUE, TRUE),
       ('Parco naturale', TRUE, FALSE),
       ('Orto botanico', FALSE, TRUE);

-- Inserimento di dati nella tabella Intervento
INSERT INTO Intervento (id, durata, inizio, fine, squadra_id, area_verde)
VALUES (1, 5, '2023-01-01 08:00:00', '2023-01-01 13:00:00', 'S001', 'Giardino pubblico'),
       (2, 3, '2023-01-02 09:00:00', '2023-01-02 12:00:00', 'S002', 'Parco naturale'),
       (3, 4, '2023-01-03 10:00:00', '2023-01-03 14:00:00', 'S003', 'Orto botanico');
