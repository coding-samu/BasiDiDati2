-- Creazione dei domini
CREATE DOMAIN RealeGEZ AS REAL CHECK (VALUE >= 0);
CREATE DOMAIN StringaS AS VARCHAR(75);
CREATE DOMAIN StringaSNotNull AS VARCHAR(75) CHECK (VALUE IS NOT NULL);
CREATE DOMAIN Denaro AS REAL CHECK (VALUE >= 0);
CREATE DOMAIN InteroGZ AS INTEGER CHECK (VALUE > 0);
CREATE DOMAIN InteroGO AS INTEGER CHECK (VALUE > 1);
CREATE DOMAIN CC AS TEXT; -- CHECK (VALUE isCC);
CREATE DOMAIN Civ AS StringaSNotNull; -- CHECK (VALUE isCiv);
CREATE TYPE Ind AS (via StringaSNotNull, civico Civ);
CREATE DOMAIN IndEmail AS TEXT; -- CHECK (VALUE isEmail);
CREATE DOMAIN Identificativo AS TEXT; -- CHECK (VALUE isIdentificativo);
CREATE DOMAIN Tel AS TEXT; -- CHECK (VALUE isTel);
CREATE TYPE TipoWish AS ENUM('Pubblica', 'Privata');

-- Creazione delle tabelle
CREATE TABLE Categoria (
    nome StringaS PRIMARY KEY
);

CREATE TABLE Tag (
    nome StringaS PRIMARY KEY
);

CREATE TABLE Marca (
    nome StringaS PRIMARY KEY
);

CREATE TABLE Nazione (
    nome StringaS PRIMARY KEY
);

CREATE TABLE Citta (
    id SERIAL PRIMARY KEY,
    nome StringaS NOT NULL,
    nazione StringaS NOT NULL,
    FOREIGN KEY (nazione) REFERENCES Nazione(nome)
);

CREATE TABLE Negozio (
    ragioneSociale StringaS PRIMARY KEY,
    indirizzo Ind NOT NULL,
    telefono Tel,
    citta INTEGER NOT NULL,
    FOREIGN KEY (citta) REFERENCES Citta(id)
);

CREATE TABLE em_neg (
    email IndEmail PRIMARY KEY,
    negozio StringaS NOT NULL,
    FOREIGN KEY (negozio) REFERENCES Negozio(ragioneSociale)
);

CREATE TABLE Utente (
    nickname StringaS PRIMARY KEY,
    reg TIMESTAMP NOT NULL,
    nome StringaS NOT NULL,
    cognome StringaS NOT NULL
);

CREATE TABLE amiciziaPending (
    invia StringaS NOT NULL,
    riceve StringaS NOT NULL,
    PRIMARY KEY (invia, riceve),
    FOREIGN KEY (invia) REFERENCES Utente(nickname),
    FOREIGN KEY (riceve) REFERENCES Utente(nickname),
    CHECK (invia <> riceve)
);

CREATE TABLE amicizia (
    da StringaS NOT NULL,
    a StringaS NOT NULL,
    PRIMARY KEY (da, a),
    FOREIGN KEY (da) REFERENCES Utente(nickname),
    FOREIGN KEY (a) REFERENCES Utente(nickname),
    CHECK (da <> a)
);

CREATE TABLE Wishlist (
    id SERIAL PRIMARY KEY,
    nome StringaS NOT NULL,
    tipo TipoWish NOT NULL,
    utente StringaS NOT NULL,
    FOREIGN KEY (utente) REFERENCES Utente(nickname),
    UNIQUE (nome, utente)
);

CREATE TABLE TipologiaBuonoRegalo (
    nome StringaS PRIMARY KEY,
    saldo Denaro NOT NULL,
    durataGiorni InteroGZ NOT NULL
);

CREATE TABLE CartaDiCredito (
    numero CC PRIMARY KEY,
    scadenza DATE NOT NULL,
    utente StringaS NOT NULL,
    FOREIGN KEY (utente) REFERENCES Utente(nickname)
);

CREATE TABLE Articolo (
    codId Identificativo PRIMARY KEY,
    nome StringaS NOT NULL,
    modello StringaS NOT NULL,
    descrizione TEXT,
    categoria StringaS NOT NULL,
    marca StringaS NOT NULL,
    FOREIGN KEY (categoria) REFERENCES Categoria(nome),
    FOREIGN KEY (marca) REFERENCES Marca(nome),
    UNIQUE (modello, marca)
);

CREATE TABLE Acquisto (
    id SERIAL PRIMARY KEY,
    indirizzo Ind NOT NULL,
    istante TIMESTAMP NOT NULL,
    citta INTEGER NOT NULL,
    utente StringaS NOT NULL,
    carta CC,
    FOREIGN KEY (citta) REFERENCES Citta(id),
    FOREIGN KEY (utente) REFERENCES Utente(nickname),
    FOREIGN KEY (carta) REFERENCES CartaDiCredito(numero)
);

CREATE TABLE art_wish (
    articolo Identificativo NOT NULL,
    wishlist INTEGER NOT NULL,
    PRIMARY KEY (articolo, wishlist),
    FOREIGN KEY (articolo) REFERENCES Articolo(codId),
    FOREIGN KEY (wishlist) REFERENCES Wishlist(id)
);

CREATE TABLE art_tag (
    articolo Identificativo NOT NULL,
    tag StringaS NOT NULL,
    PRIMARY KEY (articolo, tag),
    FOREIGN KEY (articolo) REFERENCES Articolo(codId),
    FOREIGN KEY (tag) REFERENCES Tag(nome)
);

CREATE TABLE SegnalazioneErrore (
    id SERIAL PRIMARY KEY,
    istante TIMESTAMP NOT NULL,
    descrizione TEXT NOT NULL,
    articolo Identificativo NOT NULL,
    negozio StringaS NOT NULL,
    FOREIGN KEY (articolo) REFERENCES Articolo(codId),
    FOREIGN KEY (negozio) REFERENCES Negozio(ragioneSociale)
);

CREATE TABLE Offerta (
    id INTEGER PRIMARY KEY,
    prezzo Denaro NOT NULL,
    inizio TIMESTAMP NOT NULL,
    fine TIMESTAMP,
    negozio StringaS NOT NULL,
    articolo Identificativo NOT NULL,
    FOREIGN KEY (negozio) REFERENCES Negozio(ragioneSociale),
    FOREIGN KEY (articolo) REFERENCES Articolo(codId),
    CHECK (fine IS NULL OR inizio <= fine)
);

CREATE TABLE acq_of (
    acquisto INTEGER NOT NULL,
    offerta INTEGER NOT NULL,
    quantita InteroGZ NOT NULL,
    PRIMARY KEY (acquisto, offerta),
    FOREIGN KEY (acquisto) REFERENCES Acquisto(id),
    FOREIGN KEY (offerta) REFERENCES Offerta(id)
);

CREATE TABLE Spedizione (
    id SERIAL PRIMARY KEY,
    nazione StringaS NOT NULL,
    offerta INTEGER NOT NULL,
    prezzo Denaro NOT NULL,
    FOREIGN KEY (nazione) REFERENCES Nazione(nome),
    FOREIGN KEY (offerta) REFERENCES Offerta(id),
    UNIQUE (nazione, offerta)
);

CREATE TABLE Riduzione (
    id SERIAL PRIMARY KEY,
    inizio InteroGO NOT NULL,
    fine InteroGO,
    prezzo Denaro NOT NULL,
    spedizione INTEGER NOT NULL,
    FOREIGN KEY (spedizione) REFERENCES Spedizione(id),
    CHECK (fine IS NULL OR inizio <= fine)
);

CREATE TABLE BuonoRegalo (
    id SERIAL PRIMARY KEY,
    inizio TIMESTAMP NOT NULL,
    tipo StringaS NOT NULL,
    acquista StringaS NOT NULL,
    possiede StringaS NOT NULL,
    acquisto INTEGER,
    FOREIGN KEY (tipo) REFERENCES TipologiaBuonoRegalo(nome),
    FOREIGN KEY (acquista) REFERENCES Utente(nickname),
    FOREIGN KEY (possiede) REFERENCES Utente(nickname),
    FOREIGN KEY (acquisto) REFERENCES Acquisto(id)
);

CREATE TABLE Rilevazione (
    id SERIAL PRIMARY KEY,
    istante timestamp not null,
    articolo Identificativo not null,
    foreign key (articolo) references Articolo(codId)
);