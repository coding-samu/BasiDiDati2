-- Definizione dei domini
CREATE DOMAIN StringaS AS VARCHAR(75);
CREATE DOMAIN StringaSNotNull AS VARCHAR(75) CHECK (VALUE IS NOT NULL);
CREATE DOMAIN PIVA AS TEXT; -- CHECK (isPIVA(value))
CREATE DOMAIN RagSoc AS TEXT; -- CHECK (isRagSoc(value))
CREATE DOMAIN IndEmail AS StringaS; -- CHECK (isEmail(value))
CREATE DOMAIN Civ AS TEXT; -- CHECK (isCiv(value))
CREATE TYPE Ind AS (via StringaSNotNull, civico Civ);
CREATE DOMAIN Denaro AS REAL CHECK (VALUE >= 0);
CREATE DOMAIN InteroGEZ AS INTEGER CHECK (VALUE >= 0);
CREATE DOMAIN InteroGZ AS INTEGER CHECK (VALUE > 0);
CREATE DOMAIN Perc AS REAL CHECK (VALUE >= 0 AND VALUE <= 1);
CREATE TYPE intervallo AS (inizio TIME, fine TIME);

-- Creazione delle tabelle
CREATE TABLE Nazione (
    nome StringaS PRIMARY KEY
);

CREATE TABLE Citta (
    id SERIAL PRIMARY KEY,
    nome StringaS,
    nazione StringaS,
    FOREIGN KEY (nazione) REFERENCES Nazione(nome)
);

CREATE TABLE Utente (
    email IndEmail PRIMARY KEY,
    nome StringaS NOT NULL,
    cognome StringaS NOT NULL,
    dataN DATE NOT NULL,
    indirizzo Ind NOT NULL,
    citta INTEGER NOT NULL,
    FOREIGN KEY (citta) REFERENCES Citta(id)
);

CREATE TABLE Cliente (
    id SERIAL PRIMARY KEY
);

CREATE TABLE PartitaIVA (
    cliente INTEGER PRIMARY KEY,
    val PIVA NOT NULL UNIQUE,
    FOREIGN KEY (cliente) REFERENCES Cliente(id)
);

CREATE TABLE Azienda (
    cliente INTEGER PRIMARY KEY,
    ragioneSociale RagSoc NOT NULL,
    FOREIGN KEY (cliente) REFERENCES PartitaIVA(cliente)
);

CREATE TABLE PersonaFisica (
    utente IndEmail PRIMARY KEY,
    cliente INTEGER NOT NULL,
    FOREIGN KEY (utente) REFERENCES Utente(email),
    FOREIGN KEY (cliente) REFERENCES Cliente(id)
);

CREATE TABLE Accesso (
    id SERIAL PRIMARY KEY,
    entrata TIMESTAMP NOT NULL,
    uscita TIMESTAMP,
    utente IndEmail NOT NULL,
    FOREIGN KEY (utente) REFERENCES Utente(email),
    CHECK (uscita IS NULL OR entrata <= uscita)
);

CREATE TABLE PostazioneLavoro (
    id InteroGEZ PRIMARY KEY
);

CREATE TABLE ServizioOfferto (
    id SERIAL PRIMARY KEY,
    nome StringaS NOT NULL,
    descrizione TEXT NOT NULL,
    prezzo Denaro NOT NULL
);

CREATE TABLE Utilizzo (
    id SERIAL PRIMARY KEY,
    inizio TIMESTAMP NOT NULL,
    fine TIMESTAMP NOT NULL,
    quantitaUtilizzata InteroGZ NOT NULL,
    servizio INTEGER NOT NULL,
    utente IndEmail NOT NULL,
    FOREIGN KEY (servizio) REFERENCES ServizioOfferto(id),
    FOREIGN KEY (utente) REFERENCES Utente(email),
    CHECK (inizio <= fine)
);

CREATE TABLE TipologiaAbbonamento (
    id SERIAL PRIMARY KEY,
    prezzo Denaro NOT NULL,
    durataGiorni InteroGZ NOT NULL,
    maxAbbonati InteroGZ NOT NULL
);

CREATE TABLE IntervalloDate (
    id SERIAL PRIMARY KEY,
    inizio DATE NOT NULL,
    fine DATE NOT NULL,
    tab INTEGER NOT NULL,
    FOREIGN KEY (tab) REFERENCES TipologiaAbbonamento(id),
    CHECK (inizio <= fine)
);

CREATE TABLE ta_so (
    servizio INTEGER NOT NULL,
    tab INTEGER NOT NULL,
    sconto Perc NOT NULL,
    utilizzoGratis InteroGEZ NOT NULL,
    PRIMARY KEY (tab, servizio),
    FOREIGN KEY (servizio) REFERENCES ServizioOfferto(id),
    FOREIGN KEY (tab) REFERENCES TipologiaAbbonamento(id)
);

CREATE TABLE Abbonamento (
    id SERIAL PRIMARY KEY,
    inizio DATE NOT NULL,
    tab INTEGER NOT NULL,
    acquirente INTEGER NOT NULL,
    FOREIGN KEY (tab) REFERENCES TipologiaAbbonamento(id),
    FOREIGN KEY (acquirente) REFERENCES Cliente(id)
    -- Nota: Il vincolo di inclusione "Abbonamento(id) occorre in ab_ut(abbonamento)"
    -- non può essere espresso direttamente in SQL standard.
);

CREATE TABLE ab_ut (
    utente IndEmail NOT NULL,
    abbonamento INTEGER NOT NULL,
    postazione InteroGEZ NOT NULL,
    PRIMARY KEY (abbonamento, utente),
    FOREIGN KEY (utente) REFERENCES Utente(email),
    FOREIGN KEY (abbonamento) REFERENCES Abbonamento(id),
    FOREIGN KEY (postazione) REFERENCES PostazioneLavoro(id)
);
