-- Continente
INSERT INTO Continente (nome) VALUES
('Europa'),
('Asia'),
('America'),
('Africa'),
('Oceania');

-- Nazione
INSERT INTO Nazione (nome, continente) VALUES
('Italia', 'Europa'),
('Francia', 'Europa'),
('Spagna', 'Europa'),
('Giappone', 'Asia'),
('USA', 'America');

-- Citta
INSERT INTO Citta (nome, nazione) VALUES
('Roma', 'Italia'),
('Milano', 'Italia'),
('Parigi', 'Francia'),
('Madrid', 'Spagna'),
('Tokyo', 'Giappone');

-- Porto
INSERT INTO Porto (nome, citta) VALUES
('Porto di Roma', 1),
('Porto di Milano', 2),
('Porto di Parigi', 3),
('Porto di Madrid', 4),
('Porto di Tokyo', 5);

-- Destinazione
INSERT INTO Destinazione (nome, tipo, porto) VALUES
('Destinazione Romantica 1', 'Romantica', 1),
('Destinazione Divertente 1', 'Divertente', 2),
('Destinazione Romantica e Divertente 1', 'RomanticaDivertente', 3),
('Destinazione Romantica 2', 'Romantica', 4),
('Destinazione Divertente 2', 'Divertente', 5);

-- Itinerario
INSERT INTO Itinerario (nome, arrivo, istante_arrivo, partenza, ora_partenza) VALUES
('Itinerario 1', 1, ROW(1, '08:00:00')::DeltaOra, 2, '09:00:00'),
('Itinerario 2', 2, ROW(2, '09:00:00')::DeltaOra, 3, '10:00:00'),
('Itinerario 3', 3, ROW(3, '10:00:00')::DeltaOra, 4, '11:00:00'),
('Itinerario 4', 4, ROW(4, '11:00:00')::DeltaOra, 5, '12:00:00'),
('Itinerario 5', 5, ROW(5, '12:00:00')::DeltaOra, 1, '13:00:00');

-- Nave
INSERT INTO Nave (nome, grado_di_comfort, numero_massimo_passeggeri) VALUES
('Nave 1', 3, 1000),
('Nave 2', 4, 1500),
('Nave 3', 5, 2000),
('Nave 4', 3, 1200),
('Nave 5', 4, 1800);

-- Crociera
INSERT INTO Crociera (codice, data_inizio, nave, itinerario) VALUES
('Crociera 1', '2024-06-01', 'Nave 1', 'Itinerario 1'),
('Crociera 2', '2024-06-02', 'Nave 2', 'Itinerario 2'),
('Crociera 3', '2024-06-03', 'Nave 3', 'Itinerario 3'),
('Crociera 4', '2024-06-04', 'Nave 4', 'Itinerario 4'),
('Crociera 5', '2024-06-05', 'Nave 5', 'Itinerario 5');

-- PostoDaVedere
INSERT INTO PostoDaVedere (nome, descrizione, citta) VALUES
('Colosseo', 'Anfiteatro romano a Roma', 1),
('Duomo di Milano', 'Cattedrale di Milano', 2),
('Torre Eiffel', 'Monumento a Parigi', 3),
('Plaza Mayor', 'Piazza principale di Madrid', 4),
('Tempio Sensoji', 'Tempio a Tokyo', 5);

-- dest_pdv
INSERT INTO dest_pdv (destinazione, postoDaVedere) VALUES
(1, 'Colosseo'),
(2, 'Duomo di Milano'),
(3, 'Torre Eiffel'),
(4, 'Plaza Mayor'),
(5, 'Tempio Sensoji');

-- OrarioPdv
INSERT INTO OrarioPdv (giorno, ora_inizio, ora_fine, postoDaVedere) VALUES
('Lunedi', '09:00:00', '17:00:00', 'Colosseo'),
('Martedi', '10:00:00', '18:00:00', 'Duomo di Milano'),
('Mercoledi', '11:00:00', '19:00:00', 'Torre Eiffel'),
('Giovedi', '12:00:00', '20:00:00', 'Plaza Mayor'),
('Venerdi', '13:00:00', '21:00:00', 'Tempio Sensoji');

-- Tappa
INSERT INTO Tappa (arrivo, partenza, itinerario, destinazione) VALUES
(ROW(1, '08:00:00')::DeltaOra, ROW(1, '09:00:00')::DeltaOra, 'Itinerario 1', 1),
(ROW(2, '09:00:00')::DeltaOra, ROW(2, '10:00:00')::DeltaOra, 'Itinerario 2', 2),
(ROW(3, '10:00:00')::DeltaOra, ROW(3, '11:00:00')::DeltaOra, 'Itinerario 3', 3),
(ROW(4, '11:00:00')::DeltaOra, ROW(4, '12:00:00')::DeltaOra, 'Itinerario 4', 4),
(ROW(5, '12:00:00')::DeltaOra, ROW(5, '13:00:00')::DeltaOra, 'Itinerario 5', 5);

-- CrocLunaDiMiele
INSERT INTO CrocLunaDiMiele (crociera) VALUES
('Crociera 1'),
('Crociera 3');

-- CrocPerFamiglia
INSERT INTO CrocPerFamiglia (crociera, adatta_ai_bambini) VALUES
('Crociera 2', TRUE),
('Crociera 4', FALSE),
('Crociera 5', TRUE);

-- Utente
INSERT INTO Utente (nome, cognome, indirizzo, dataN, citta) VALUES
('Mario', 'Rossi', ROW('Via Roma', '123')::Indirizzo, '1980-01-01', 1),
('Luigi', 'Verdi', ROW('Via Milano', '456')::Indirizzo, '1985-02-02', 2),
('Giovanni', 'Bianchi', ROW('Via Parigi', '789')::Indirizzo, '1990-03-03', 3),
('Francesca', 'Neri', ROW('Via Madrid', '321')::Indirizzo, '1995-04-04', 4),
('Anna', 'Gialli', ROW('Via Tokyo', '654')::Indirizzo, '2000-05-05', 5);

-- Prenotazione
INSERT INTO Prenotazione (istante_prenotazione, num_posti_prenotati, tipo, crociera, utente) VALUES
('2024-05-01 10:00:00', 2, 'Pending', 'Crociera 1', 1),
('2024-05-02 11:00:00', 3, 'Accettata', 'Crociera 2', 2),
('2024-05-03 12:00:00', 1, 'Rifiutata', 'Crociera 3', 3),
('2024-05-04 13:00:00', 4, 'Pending', 'Crociera 4', 4),
('2024-05-05 14:00:00', 5, 'Accettata', 'Crociera 5', 5);