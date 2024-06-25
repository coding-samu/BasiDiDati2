-- Inserimento dati nella tabella RecapitoTelefonico
insert into RecapitoTelefonico (telefono) values 
('1234567890'), ('0987654321'), ('5555555555'), ('6666666666'), ('7777777777');

-- Inserimento dati nella tabella Promotore
insert into Promotore (matricola, nome, cognome) values 
('P001', 'Marco', 'Rossi'), 
('P002', 'Luca', 'Bianchi'), 
('P003', 'Giulia', 'Verdi');

-- Inserimento dati nella tabella TipologiaDocumento
insert into TipologiaDocumento (nome) values 
('CartaIdentita'), 
('Patente'), 
('Passaporto');

-- Inserimento dati nella tabella Emittente
insert into Emittente (nome, tipo) values 
('StatoItalia', 'Stato'), 
('AziendaAlpha', 'Azienda'), 
('AziendaBeta', 'Azienda');

-- Inserimento dati nella tabella StrumentoFinanziario
insert into StrumentoFinanziario (emittente) values 
('StatoItalia'), 
('AziendaAlpha'), 
('AziendaBeta');

-- Inserimento dati nella tabella Rilevazione
insert into Rilevazione (istante, valore, sf) values 
('2023-01-01 10:00:00', 100.50, 1), 
('2023-01-01 11:00:00', 200.75, 2), 
('2023-01-01 12:00:00', 300.00, 3);

-- Inserimento dati nella tabella Titolo
insert into Titolo (sf, tipo) values 
(1, 'DiStato'), 
(2, 'Azionario'), 
(3, 'Obbligazionario');

-- Inserimento dati nella tabella FondoGestito
insert into FondoGestito (sf, titoliAzionari, titoliObbligazionari, titoliDiStato) values 
(2, 10, 20, 0), 
(3, 5, 15, 0);

-- Inserimento dati nella tabella Cliente
insert into Cliente (cf, email, numDoc, nome, cognome, tipoDocumento) values 
('RSSMRC80A01H501Z', 'marco.rossi@example.com', 'AB123456', 'Marco', 'Rossi', 'CartaIdentita'), 
('BNCGLL85T01L219Y', 'giulia.bianchi@example.com', 'CD789012', 'Giulia', 'Bianchi', 'Passaporto');

-- Inserimento dati nella tabella cli_rt
insert into cli_rt (telefono, cliente) values 
('1234567890', 'RSSMRC80A01H501Z'), 
('0987654321', 'BNCGLL85T01L219Y');

-- Inserimento dati nella tabella Gestione
insert into Gestione (inizio, isTerminata, fine, motivazione, cliente, promotore) values 
('2023-01-01 09:00:00', false, null, null, 'RSSMRC80A01H501Z', 'P001'), 
('2023-01-01 09:00:00', true, '2023-02-01 09:00:00', 'Completata', 'BNCGLL85T01L219Y', 'P002');

-- Inserimento dati nella tabella Investimento
insert into Investimento (istante, quantita, gestione, sf) values 
('2023-01-01 10:30:00', 150.00, 1, 1), 
('2023-01-01 11:30:00', 100.00, 2, 2);

-- Inserimento dati nella tabella Disinvestimento
insert into Disinvestimento (istante, quantita, investimento) values 
('2023-01-01 11:00:00', 50.00, 1), 
('2023-01-01 12:00:00', 25.00, 2);
