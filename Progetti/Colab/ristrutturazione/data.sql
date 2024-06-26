-- Popola la tabella Nazione
INSERT INTO Nazione (nome) VALUES 
('Italia'), 
('Francia'), 
('Germania'), 
('Spagna'), 
('Regno Unito');

-- Popola la tabella Citta
INSERT INTO Citta (nome, nazione) VALUES 
('Roma', 'Italia'), 
('Milano', 'Italia'), 
('Parigi', 'Francia'), 
('Berlino', 'Germania'), 
('Madrid', 'Spagna'), 
('Londra', 'Regno Unito');

-- Popola la tabella Utente
INSERT INTO Utente (email, nome, cognome, dataN, indirizzo, citta) VALUES 
('mario.rossi@example.com', 'Mario', 'Rossi', '1985-01-15', ROW('Via Roma', '10'), 1), 
('luigi.bianchi@example.com', 'Luigi', 'Bianchi', '1990-07-23', ROW('Corso Milano', '20'), 2), 
('jean.dupont@example.com', 'Jean', 'Dupont', '1980-04-12', ROW('Rue de Paris', '5'), 3), 
('anna.schmidt@example.com', 'Anna', 'Schmidt', '1992-11-30', ROW('Strasse Berlin', '7'), 4), 
('carlos.garcia@example.com', 'Carlos', 'Garcia', '1988-03-18', ROW('Calle Madrid', '12'), 5), 
('john.smith@example.com', 'John', 'Smith', '1975-06-25', ROW('Street London', '15'), 6);

-- Popola la tabella Cliente
INSERT INTO Cliente DEFAULT VALUES; -- 1
INSERT INTO Cliente DEFAULT VALUES; -- 2
INSERT INTO Cliente DEFAULT VALUES; -- 3
INSERT INTO Cliente DEFAULT VALUES; -- 4
INSERT INTO Cliente DEFAULT VALUES; -- 5
INSERT INTO Cliente DEFAULT VALUES; -- 6

-- Popola la tabella PartitaIVA
INSERT INTO PartitaIVA (cliente, val) VALUES 
(1, 'IT12345678901'), 
(2, 'IT98765432101'), 
(3, 'FR12345678901'), 
(4, 'DE12345678901'), 
(5, 'ES12345678901'), 
(6, 'UK12345678901');

-- Popola la tabella Azienda
INSERT INTO Azienda (cliente, ragioneSociale) VALUES 
(1, 'Azienda Rossi S.p.A.'), 
(2, 'Bianchi & Co. S.r.l.'), 
(3, 'Dupont Enterprises'), 
(4, 'Schmidt GmbH'), 
(5, 'Garcia S.L.'), 
(6, 'Smith Ltd.');

-- Popola la tabella PersonaFisica
INSERT INTO PersonaFisica (utente, cliente) VALUES 
('mario.rossi@example.com', 1), 
('luigi.bianchi@example.com', 2), 
('jean.dupont@example.com', 3), 
('anna.schmidt@example.com', 4), 
('carlos.garcia@example.com', 5), 
('john.smith@example.com', 6);

-- Popola la tabella Accesso
INSERT INTO Accesso (entrata, uscita, utente) VALUES 
('2024-06-25 08:00:00', '2024-06-25 17:00:00', 'mario.rossi@example.com'), 
('2024-06-25 09:00:00', '2024-06-25 18:00:00', 'luigi.bianchi@example.com'), 
('2024-06-25 08:30:00', NULL, 'jean.dupont@example.com'), 
('2024-06-25 09:15:00', '2024-06-25 17:30:00', 'anna.schmidt@example.com'), 
('2024-06-25 10:00:00', NULL, 'carlos.garcia@example.com'), 
('2024-06-25 07:45:00', '2024-06-25 16:45:00', 'john.smith@example.com');

-- Popola la tabella PostazioneLavoro
INSERT INTO PostazioneLavoro (id) VALUES 
(1), 
(2), 
(3), 
(4), 
(5), 
(6);

-- Popola la tabella ServizioOfferto
INSERT INTO ServizioOfferto (nome, descrizione, prezzo) VALUES 
('Servizio Base', 'Servizio di base per tutti i clienti', 50.0), 
('Servizio Premium', 'Servizio premium con maggiori benefici', 100.0), 
('Servizio VIP', 'Servizio VIP per clienti esclusivi', 200.0);

-- Popola la tabella Utilizzo
INSERT INTO Utilizzo (inizio, fine, quantitaUtilizzata, servizio, utente) VALUES 
('2024-06-25 10:00:00', '2024-06-25 12:00:00', 2, 1, 'mario.rossi@example.com'), 
('2024-06-25 13:00:00', '2024-06-25 14:00:00', 1, 2, 'luigi.bianchi@example.com'), 
('2024-06-25 09:00:00', '2024-06-25 11:30:00', 3, 3, 'jean.dupont@example.com');

-- Popola la tabella TipologiaAbbonamento
INSERT INTO TipologiaAbbonamento (prezzo, durataGiorni, maxAbbonati) VALUES 
(100.0, 30, 10), 
(200.0, 60, 20), 
(300.0, 90, 30);

-- Popola la tabella IntervalloDate
INSERT INTO IntervalloDate (inizio, fine, tab) VALUES 
('2024-07-01', '2024-07-31', 1), 
('2024-08-01', '2024-09-30', 2), 
('2024-10-01', '2024-12-31', 3);

-- Popola la tabella ta_so
INSERT INTO ta_so (servizio, tab, sconto, utilizzoGratis) VALUES 
(1, 1, 0.1, 1), 
(2, 2, 0.2, 2), 
(3, 3, 0.3, 3);

-- Popola la tabella Abbonamento
INSERT INTO Abbonamento (inizio, tab, acquirente) VALUES 
('2024-07-01', 1, 1), 
('2024-08-01', 2, 2), 
('2024-10-01', 3, 3);

-- Popola la tabella ab_ut
INSERT INTO ab_ut (utente, abbonamento, postazione) VALUES 
('mario.rossi@example.com', 1, 1), 
('luigi.bianchi@example.com', 2, 2), 
('jean.dupont@example.com', 3, 3);
