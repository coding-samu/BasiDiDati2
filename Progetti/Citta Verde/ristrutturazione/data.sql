-- Inserimento dati in TipologiaAttivita
insert into TipologiaAttivita (_nome) values
    ('Pulizia'), ('Manutenzione'), ('Piantumazione');

-- Inserimento dati in Attrezzatura
insert into Attrezzatura (_nome, tipologia) values
    ('Trattorino', 'Veicolo speciale'),
    ('Rasaerba', 'Strumento Leggero'),
    ('Pala', 'Strumento Leggero');

-- Inserimento dati in Persona
insert into Persona (_codFisc, nome, cognome) values
    ('ABC12345', 'Mario', 'Rossi'),
    ('DEF67890', 'Luca', 'Verdi'),
    ('GHI54321', 'Giulia', 'Bianchi');

-- Inserimento dati in Operatore
insert into Operatore (_id, inizio, fine, persona) values
    (1, '2023-01-01 08:00:00', '2023-01-01 16:00:00', 'ABC12345'),
    (2, '2023-01-02 08:30:00', '2023-01-02 17:30:00', 'DEF67890'),
    (3, '2023-01-03 07:45:00', NULL, 'GHI54321');

-- Inserimento dati in Squadra
insert into Squadra (_codice, inizio, fine) values
    ('SQUADRA1', '2023-01-01', '2023-01-31'),
    ('SQUADRA2', '2023-02-01', '2023-02-28'),
    ('SQUADRA3', '2023-03-01', NULL);

-- Inserimento dati in Partecipa
insert into Partecipa (_id, inizio, fine, isCapo, operatore, squadra) values
    (1, '2023-01-01', '2023-01-31', true, 1, 'SQUADRA1'),
    (2, '2023-02-01', '2023-02-28', false, 2, 'SQUADRA2'),
    (3, '2023-03-01', NULL, true, 3, 'SQUADRA3');

-- Inserimento dati in AreaVerde
insert into AreaVerde (_denominazione, isFruibile, isSensibile) values
    ('Parco Centrale', true, true),
    ('Giardino Botanico', true, false),
    ('Area di Conservazione', false, true);

-- Inserimento dati in Intervento
insert into Intervento (_id, minimoOperatori, inizio, durataGiorniStimata, priorita, areaVerde) values
    (1, 5, '2023-01-05', 3, 7, 'Parco Centrale'),
    (2, 3, '2023-02-10', 1, 5, 'Giardino Botanico'),
    (3, 8, '2023-03-15', 5, 10, 'Area di Conservazione');

-- Inserimento dati in SoggettoVerde
insert into SoggettoVerde (_id, dataPiantumazione, posizione, catRischio, specie, areaVerde) values
    (1, '2021-05-15', (45.123, 9.456), 'Medio', 'Quercus robur', 'Parco Centrale'),
    (2, '2022-04-20', (45.678, 9.789), 'Basso', 'Ficus benjamina', 'Giardino Botanico'),
    (3, '2020-06-30', (45.890, 9.012), 'Alto', 'Pinus nigra', 'Area di Conservazione');

-- Inserimento dati in Completato
insert into Completato (_intervento, istanteCompl) values
    (1, '2023-01-08 16:30:00'),
    (2, '2023-02-11 12:00:00'),
    (3, '2023-03-20 14:45:00');

-- Inserimento dati in StoricoMalattia
insert into StoricoMalattia (_id, scoperta, isRisolta, malattia, soggettoVerde, intervento) values
    (1, '2022-12-10', true, 'Phytophthora', 1, NULL),
    (2, '2023-02-20', false, 'Xylella', 2, 2),
    (3, '2023-03-25', true, 'Ciclosporina', 3, 3);
