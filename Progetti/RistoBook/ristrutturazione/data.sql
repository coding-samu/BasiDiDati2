-- Inserimento dei dati di esempio

-- Nazioni
insert into Nazione (nome) values ('Italia'), ('Francia');

-- Città
insert into Citta (nome, nazione) values ('Roma', 'Italia'), ('Parigi', 'Francia');

-- Clienti
insert into Cliente (indirizzoEmail, nome, cognome) values 
('mario.rossi@example.com', 'Mario', 'Rossi'),
('luigi.bianchi@example.com', 'Luigi', 'Bianchi');

-- Utenti Ristoratori
insert into UtenteRistoratore (indirizzoEmail, nome, cognome) values 
('giovanni.verdi@example.com', 'Giovanni', 'Verdi'),
('paolo.neri@example.com', 'Paolo', 'Neri');

-- Tipi di Cucina
insert into CucinaTipo (nome) values ('Italiana'), ('Francese');

-- Ristoranti
insert into Ristorante (pIva, nome, indirizzo, citta, ristoratore) values 
('IT12345678901', 'Ristorante Roma', ('Via Roma', '10'), 1, 'giovanni.verdi@example.com'),
('FR98765432109', 'Ristorante Parigi', ('Rue de Paris', '20'), 2, 'paolo.neri@example.com');

-- Associazione ristoranti e tipi di cucina
insert into cuc_rist (ristorante, tipoCucina) values 
('IT12345678901', 'Italiana'),
('FR98765432109', 'Francese');

-- Promozioni
insert into Promozione (nome, percentuale, numCoperti, ristorante) values 
('Sconto Pranzo', 0.2, 4, 'IT12345678901'),
('Sconto Cena', 0.3, 2, 'FR98765432109');

-- Giorni di Promozione
insert into GiornoPromozione (giorno, inizio, fine, promozione) values 
(current_date, '12:00:00', '14:00:00', 1), -- Oggi
(current_date + interval '1 day', '19:00:00', '21:00:00', 2); -- Domani

-- Prenotazioni
insert into Prenotazione (data, coperti, istantePren, statoPren, annullata, giornoProm, ristorante, cliente) values 
(current_timestamp + interval '1 hour', 2, current_timestamp, 'Pending', false, 1, 'IT12345678901', 'mario.rossi@example.com'),
(current_timestamp + interval '2 hours', 4, current_timestamp, 'Accettata', false, 1, 'IT12345678901', 'luigi.bianchi@example.com'),
(current_timestamp + interval '3 hours', 2, current_timestamp, 'Pending', false, 2, 'FR98765432109', 'mario.rossi@example.com'),
(current_timestamp + interval '1 day', 3, current_timestamp, 'Accettata', false, 2, 'FR98765432109', 'luigi.bianchi@example.com');

-- Chiusure Prenotazioni
insert into ChiusuraPrenotazione (inizio, fine, istanteInserimento, ristorante) values 
(current_timestamp + interval '1 day', current_timestamp + interval '2 days', current_timestamp, 'IT12345678901'),
(current_timestamp + interval '2 days', current_timestamp + interval '3 days', current_timestamp, 'FR98765432109');
