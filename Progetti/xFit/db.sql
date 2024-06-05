-- Creating Domains
CREATE DOMAIN InteroGZ AS INTEGER CHECK (VALUE > 0);
CREATE DOMAIN InteroGEZ AS INTEGER CHECK (VALUE >= 0);
CREATE DOMAIN RealeGZ AS REAL CHECK (VALUE > 0);
CREATE DOMAIN StringaS AS VARCHAR(75);
CREATE DOMAIN Codice AS TEXT; -- (CHECK (value IS NOT NULL)); -- Assuming IS NOT NULL check for now

-- Creating Enum Type
CREATE TYPE TipoContratto AS ENUM('Indeterminato', 'Determinato');

-- Creating Tables

-- Cliente
CREATE TABLE Cliente (
    codice Codice PRIMARY KEY,
    nome StringaS NOT NULL,
    cognome StringaS NOT NULL,
    dataN DATE NOT NULL
);

-- Personale
CREATE TABLE Personale (
    id SERIAL PRIMARY KEY,
    nome StringaS NOT NULL,
    cognome StringaS NOT NULL,
    dataN DATE NOT NULL
);

-- Contratto
CREATE TABLE Contratto (
    id SERIAL PRIMARY KEY,
    inizio DATE NOT NULL,
    ral RealeGZ NOT NULL,
    livello InteroGZ NOT NULL,
    fine DATE,
    tipo TipoContratto NOT NULL,
    persona INTEGER NOT NULL,
    FOREIGN KEY (persona) REFERENCES Personale(id),
    UNIQUE (inizio, persona)
);

-- RuoloPersonale
CREATE TABLE RuoloPersonale (
    nome StringaS PRIMARY KEY
);

-- Dipendente
CREATE TABLE Dipendente (
    persona INTEGER NOT NULL,
    ruolo StringaS NOT NULL,
    FOREIGN KEY (persona) REFERENCES Personale(id),
    FOREIGN KEY (ruolo) REFERENCES RuoloPersonale(nome),
    PRIMARY KEY (persona, ruolo)
);

-- Istruttore
CREATE TABLE Istruttore (
    persona INTEGER PRIMARY KEY,
    FOREIGN KEY (persona) REFERENCES Personale(id)
    -- CHECK (Istruttore(persona) occorre in supervisiona(istruttore)) -- This check is conceptual and cannot be directly enforced in SQL
);

-- AttivitaSportiva
CREATE TABLE AttivitaSportiva (
    nome StringaS PRIMARY KEY
);

-- TipologiaAbbonamento
CREATE TABLE TipologiaAbbonamento (
    id SERIAL PRIMARY KEY,
    nome StringaS NOT NULL,
    durataMesi InteroGZ NOT NULL,
    prezzoEur RealeGZ NOT NULL,
    UNIQUE (nome, durataMesi, prezzoEur)
    -- CHECK (TipologiaAbbonamento(id) occorre in Accede(tipologia)) -- This check is conceptual and cannot be directly enforced in SQL
);

-- Abbonamento
CREATE TABLE Abbonamento (
    id SERIAL PRIMARY KEY,
    inizio DATE NOT NULL,
    tipologia INTEGER NOT NULL,
    cliente Codice NOT NULL,
    FOREIGN KEY (tipologia) REFERENCES TipologiaAbbonamento(id),
    FOREIGN KEY (cliente) REFERENCES Cliente(codice)
);

-- Area
CREATE TABLE Area (
    id SERIAL PRIMARY KEY,
    nome StringaS NOT NULL
);

-- AreaComune
CREATE TABLE AreaComune (
    area INTEGER PRIMARY KEY,
    FOREIGN KEY (area) REFERENCES Area(id)
);

-- AreaAttivita
CREATE TABLE AreaAttivita (
    area INTEGER PRIMARY KEY,
    capienza InteroGZ NOT NULL,
    FOREIGN KEY (area) REFERENCES Area(id)
);

-- Lezione
CREATE TABLE Lezione (
    id SERIAL PRIMARY KEY,
    inizio TIMESTAMP NOT NULL,
    fine TIMESTAMP NOT NULL,
    attivita StringaS NOT NULL,
    area INTEGER NOT NULL,
    FOREIGN KEY (attivita) REFERENCES AttivitaSportiva(nome),
    FOREIGN KEY (area) REFERENCES AreaAttivita(area)
);

-- Supervisiona
CREATE TABLE Supervisiona (
    istruttore INTEGER NOT NULL,
    attivita StringaS NOT NULL,
    FOREIGN KEY (istruttore) REFERENCES Istruttore(persona),
    FOREIGN KEY (attivita) REFERENCES AttivitaSportiva(nome),
    PRIMARY KEY (istruttore, attivita)
);

-- Accede
CREATE TABLE Accede (
    tipologia INTEGER NOT NULL,
    attivita StringaS NOT NULL,
    FOREIGN KEY (tipologia) REFERENCES TipologiaAbbonamento(id),
    FOREIGN KEY (attivita) REFERENCES AttivitaSportiva(nome),
    PRIMARY KEY (tipologia, attivita)
);

-- Varco
CREATE TABLE Varco (
    id SERIAL PRIMARY KEY,
    entraDa INTEGER NOT NULL,
    entraIn INTEGER NOT NULL,
    FOREIGN KEY (entraDa) REFERENCES Area(id),
    FOREIGN KEY (entraIn) REFERENCES Area(id)
);

-- StoricoIngressi
CREATE TABLE StoricoIngressi (
    id SERIAL PRIMARY KEY,
    entrata TIMESTAMP NOT NULL,
    uscita TIMESTAMP,
    cliente Codice NOT NULL,
    varco INTEGER NOT NULL,
    FOREIGN KEY (cliente) REFERENCES Cliente(codice),
    FOREIGN KEY (varco) REFERENCES Varco(id)
);
