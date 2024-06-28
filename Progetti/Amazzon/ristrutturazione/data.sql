-- Inserimento dati nelle tabelle principali

-- Nazioni
INSERT INTO Nazione (nome) VALUES 
('Italia'), 
('Francia'), 
('Germania');

-- Città
INSERT INTO Citta (nome, nazione) VALUES 
('Roma', 'Italia'), 
('Milano', 'Italia'), 
('Parigi', 'Francia'), 
('Berlino', 'Germania');

-- Utenti
INSERT INTO Utente (nickname, reg, nome, cognome) VALUES 
('user1', '2022-01-01 10:00:00', 'Mario', 'Rossi'), 
('user2', '2022-02-01 11:00:00', 'Luigi', 'Verdi'), 
('user3', '2022-03-01 12:00:00', 'Anna', 'Bianchi');

-- Amicizia
INSERT INTO amicizia (da, a) VALUES 
('user1', 'user2'), 
('user2', 'user3');

-- Categoria
INSERT INTO Categoria (nome) VALUES 
('Elettronica'), 
('Casa'), 
('Sport');

-- Tag
INSERT INTO Tag (nome) VALUES 
('Nuovo'), 
('In Offerta'), 
('Popolare');

-- Marca
INSERT INTO Marca (nome) VALUES 
('Sony'), 
('Samsung'), 
('Adidas');

-- Negozi
INSERT INTO Negozio (ragioneSociale, indirizzo, telefono, citta) VALUES 
('MediaWorld', ROW('Via Roma', '10'), '1234567890', 1), 
('Unieuro', ROW('Via Milano', '20'), '0987654321', 2);

-- Email negozi
INSERT INTO em_neg (email, negozio) VALUES 
('contact@mediaworld.it', 'MediaWorld'), 
('info@unieuro.it', 'Unieuro');

-- Articoli
INSERT INTO Articolo (codId, nome, modello, descrizione, categoria, marca) VALUES 
('A001', 'Smartphone', 'X100', 'Smartphone con display 6.5', 'Elettronica', 'Sony'), 
('A002', 'Televisore', 'TV200', 'Televisore 4K', 'Elettronica', 'Samsung'), 
('A003', 'Scarpe Sportive', 'RunX', 'Scarpe per il running', 'Sport', 'Adidas');

-- Wishlist
INSERT INTO Wishlist (nome, tipo, utente) VALUES 
('Desideri di Mario', 'Privata', 'user1'), 
('Regali di Anna', 'Pubblica', 'user3');

-- Articoli nelle wishlist
INSERT INTO art_wish (articolo, wishlist) VALUES 
('A001', 1), 
('A003', 2);

-- Offerte
INSERT INTO Offerta (id, prezzo, inizio, fine, negozio, articolo) VALUES 
(1, 299.99, '2022-05-01 00:00:00', '2022-05-31 23:59:59', 'MediaWorld', 'A001'), 
(2, 499.99, '2022-06-01 00:00:00', '2022-06-30 23:59:59', 'Unieuro', 'A002');

-- Spedizioni
INSERT INTO Spedizione (nazione, offerta, prezzo) VALUES 
('Italia', 1, 9.99), 
('Francia', 2, 19.99);

-- Acquisti
INSERT INTO Acquisto (indirizzo, istante, citta, utente, carta) VALUES 
(ROW('Via Roma', '10'), '2022-06-15 14:00:00', 1, 'user1', NULL), 
(ROW('Via Milano', '20'), '2022-06-16 15:00:00', 2, 'user2', NULL);

-- Acquisto-Offerta
INSERT INTO acq_of (acquisto, offerta, quantita) VALUES 
(1, 1, 1), 
(2, 2, 1);

-- Buoni regalo
INSERT INTO TipologiaBuonoRegalo (nome, saldo, durataGiorni) VALUES 
('Buono 50€', 50.00, 365);

INSERT INTO BuonoRegalo (inizio, tipo, acquista, possiede, acquisto) VALUES 
('2022-06-01 00:00:00', 'Buono 50€', 'user1', 'user1', 1), 
('2022-06-01 00:00:00', 'Buono 50€', 'user2', 'user2', 2);

-- Segnalazioni di errori
INSERT INTO SegnalazioneErrore (istante, descrizione, articolo, negozio) VALUES 
('2022-06-10 10:00:00', 'Descrizione errata', 'A001', 'MediaWorld');

-- Associazioni articolo-tag
INSERT INTO art_tag (articolo, tag) VALUES 
('A001', 'Nuovo'), 
('A002', 'In Offerta'), 
('A003', 'Popolare');
