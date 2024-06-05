-- Populating Cliente
INSERT INTO Cliente (codice, nome, cognome, dataN) VALUES
('C1', 'Mario', 'Rossi', '1980-01-01'),
('C2', 'Luigi', 'Verdi', '1990-02-02'),
('C3', 'Anna', 'Bianchi', '1975-03-03'),
('C4', 'Maria', 'Neri', '1985-04-04');

-- Populating Personale
INSERT INTO Personale (nome, cognome, dataN) VALUES
('Giuseppe', 'De Luca', '1982-05-05'),
('Federica', 'Galli', '1992-06-06'),
('Luca', 'Moretti', '1988-07-07'),
('Silvia', 'Conti', '1986-08-08');

-- Populating Contratto
INSERT INTO Contratto (inizio, ral, livello, fine, tipo, persona) VALUES
('2022-01-01', 30000, 1, NULL, 'Indeterminato', 1),
('2022-02-01', 32000, 2, '2023-02-01', 'Determinato', 2),
('2023-03-01', 34000, 3, NULL, 'Indeterminato', 3),
('2023-04-01', 36000, 4, '2024-04-01', 'Determinato', 4);

-- Populating RuoloPersonale
INSERT INTO RuoloPersonale (nome) VALUES
('Manager'),
('Istruttore'),
('Receptionist');

-- Populating Dipendente
INSERT INTO Dipendente (persona, ruolo) VALUES
(1, 'Manager'),
(2, 'Istruttore'),
(3, 'Receptionist'),
(4, 'Istruttore');

-- Populating Istruttore
INSERT INTO Istruttore (persona) VALUES
(2),
(4);

-- Populating AttivitaSportiva
INSERT INTO AttivitaSportiva (nome) VALUES
('Yoga'),
('Pilates'),
('Zumba'),
('CrossFit');

-- Populating TipologiaAbbonamento
INSERT INTO TipologiaAbbonamento (nome, durataMesi, prezzoEur) VALUES
('Mensile', 1, 50),
('Trimestrale', 3, 140),
('Semestrale', 6, 270),
('Annuale', 12, 500);

-- Populating Abbonamento
INSERT INTO Abbonamento (inizio, tipologia, cliente) VALUES
('2023-01-01', 1, 'C1'),
('2023-02-01', 2, 'C2'),
('2023-03-01', 3, 'C3'),
('2023-04-01', 4, 'C4');

-- Populating Area
INSERT INTO Area (nome) VALUES
('Reception'),
('Palestra'),
('Piscina'),
('Sala Yoga'),
('Sala Pilates');

-- Populating AreaComune
INSERT INTO AreaComune (area) VALUES
(1);

-- Populating AreaAttivita
INSERT INTO AreaAttivita (area, capienza) VALUES
(2, 20),
(3, 15),
(4, 10),
(5, 10);

-- Populating Lezione
INSERT INTO Lezione (inizio, fine, attivita, area) VALUES
('2023-06-01 09:00', '2023-06-01 10:00', 'Yoga', 4),
('2023-06-02 10:00', '2023-06-02 11:00', 'Pilates', 5),
('2023-06-03 11:00', '2023-06-03 12:00', 'Zumba', 2),
('2023-06-04 12:00', '2023-06-04 13:00', 'CrossFit', 2);

-- Populating Supervisiona
INSERT INTO Supervisiona (istruttore, attivita) VALUES
(2, 'Yoga'),
(4, 'Pilates'),
(2, 'Zumba'),
(4, 'CrossFit');

-- Populating Accede
INSERT INTO Accede (tipologia, attivita) VALUES
(1, 'Yoga'),
(2, 'Pilates'),
(3, 'Zumba'),
(4, 'CrossFit');

-- Populating Varco
INSERT INTO Varco (entraDa, entraIn) VALUES
(1, 2),
(2, 3),
(3, 4),
(4, 5);

-- Populating StoricoIngressi
INSERT INTO StoricoIngressi (entrata, uscita, cliente, varco) VALUES
('2023-06-01 08:00', '2023-06-01 10:00', 'C1', 1),
('2023-06-02 09:00', '2023-06-02 11:00', 'C2', 2),
('2023-06-03 10:00', '2023-06-03 12:00', 'C3', 3),
('2023-06-04 11:00', '2023-06-04 13:00', 'C4', 4);
