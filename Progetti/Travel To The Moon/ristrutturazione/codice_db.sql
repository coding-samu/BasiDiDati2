create type StatoPrenotazione as enum('Pending','Accettata','Rifiutata');

create type TipoDestinazione as enum('Romantica','Divertente','RomanticaDivertente');

create domain InteroGEZ as integer
    check (value >= 0);

create domain StringaS as varchar(100);

create domain ValutazioneNave as integer
    check (value >= 3 and value <= 5);

create domain InteroGZ as integer
    check (value > 0);

create domain StringaM as varchar(500);

create domain InteroGZ_not_null as InteroGZ
    check (value is not null);

create domain time_not_null as time
    check (value is not null);

create type DeltaOra as (
    giorno InteroGZ_not_null,
    ora time_not_null
);

create or replace function minoreDeltaOra(a DeltaOra,b DeltaOra) -- a < b
returns boolean as
$$
begin
    if a.giorno < b.giorno then return true;
    elsif a.giorno = b.giorno then return a.ora < b.ora;
    else
        return false;
    end if;
end;
$$
language plpgsql;

create domain StringaS_not_null as StringaS
    check(value is not null);

create domain Civico_not_null as StringaS
    check(value is not null /*and isCivico(value)*/);

create type Indirizzo as (
    via StringaS_not_null,
    civico Civico_not_null
);

create type Giorno as enum('Lunedi','Martedi','Mercoledi','Giovedi','Venerdi','Sabato','Domenica')

-- Creazione delle tabelle
CREATE TABLE Continente (
    nome StringaS PRIMARY KEY
);

CREATE TABLE Nazione (
    nome StringaS PRIMARY KEY,
    continente StringaS not null,
    FOREIGN KEY (continente) REFERENCES Continente(nome)
);

CREATE TABLE Citta (
    id SERIAL PRIMARY KEY,
    nome StringaS_not_null,
    nazione StringaS_not_null,
    FOREIGN KEY (nazione) REFERENCES Nazione(nome)
);

CREATE TABLE Porto (
    id SERIAL PRIMARY KEY,
    nome StringaS_not_null,
    citta INTEGER not null,
    UNIQUE (nome, citta),
    FOREIGN KEY (citta) REFERENCES Citta(id)
);

CREATE TABLE Destinazione (
    id SERIAL PRIMARY KEY,
    nome StringaS_not_null,
    tipo TipoDestinazione not null,
    porto INTEGER not null,
    FOREIGN KEY (porto) REFERENCES Porto(id)
);

CREATE TABLE Itinerario (
    nome StringaS_not_null PRIMARY KEY,
    arrivo INTEGER not null,
    istante_arrivo DeltaOra not null,
    partenza INTEGER not null,
    ora_partenza TIME not null,
    FOREIGN KEY (arrivo) REFERENCES Destinazione(id),
    FOREIGN KEY (partenza) REFERENCES Destinazione(id)
);

CREATE TABLE Nave (
    nome StringaS_not_null PRIMARY KEY,
    grado_di_comfort ValutazioneNave not null,
    numero_massimo_passeggeri InteroGZ not null
);

CREATE TABLE Crociera (
    codice StringaS_not_null PRIMARY KEY,
    data_inizio DATE not null,
    nave StringaS_not_null,
    itinerario StringaS_not_null,
    FOREIGN KEY (nave) REFERENCES Nave(nome),
    FOREIGN KEY (itinerario) REFERENCES Itinerario(nome)
);

CREATE TABLE PostoDaVedere (
    nome StringaS_not_null PRIMARY KEY,
    descrizione TEXT not null,
    citta INTEGER not null,
    FOREIGN KEY (citta) REFERENCES Citta(id)
);

CREATE TABLE dest_pdv (
    destinazione INTEGER,
    postoDaVedere StringaS_not_null,
    FOREIGN KEY (destinazione) REFERENCES Destinazione(id),
    FOREIGN KEY (postoDaVedere) REFERENCES PostoDaVedere(nome),
    PRIMARY KEY (destinazione, postoDaVedere)
);

CREATE TABLE OrarioPdv (
    id SERIAL PRIMARY KEY,
    giorno Giorno not null,
    ora_inizio TIME not null,
    ora_fine TIME not null,
    postoDaVedere StringaS_not_null,
    FOREIGN KEY (postoDaVedere) REFERENCES PostoDaVedere(nome),
    UNIQUE (giorno, ora_inizio, postoDaVedere)
);

CREATE TABLE Tappa (
    id SERIAL PRIMARY KEY,
    arrivo DeltaOra not null,
    partenza DeltaOra not null,
    itinerario StringaS_not_null not null,
    destinazione INTEGER not null,
    FOREIGN KEY (itinerario) REFERENCES Itinerario(nome),
    FOREIGN KEY (destinazione) REFERENCES Destinazione(id),
    UNIQUE (itinerario, arrivo)
);

CREATE TABLE CrocLunaDiMiele (
    crociera StringaS_not_null PRIMARY KEY,
    FOREIGN KEY (crociera) REFERENCES Crociera(codice)
);

CREATE TABLE CrocPerFamiglia (
    crociera StringaS_not_null PRIMARY KEY,
    adatta_ai_bambini BOOLEAN not null,
    FOREIGN KEY (crociera) REFERENCES Crociera(codice)
);

CREATE TABLE Utente (
    id SERIAL PRIMARY KEY,
    nome StringaS_not_null,
    cognome StringaS_not_null,
    indirizzo Indirizzo not null,
    dataN DATE not null,
    citta INTEGER not null,
    FOREIGN KEY (citta) REFERENCES Citta(id)
);

CREATE TABLE Prenotazione (
    id SERIAL PRIMARY KEY,
    istante_prenotazione TIMESTAMP not null,
    num_posti_prenotati InteroGZ not null,
    tipo StatoPrenotazione not null,
    crociera StringaS_not_null,
    utente INTEGER not null,
    FOREIGN KEY (crociera) REFERENCES Crociera(codice),
    FOREIGN KEY (utente) REFERENCES Utente(id),
    UNIQUE (istante_prenotazione, crociera)
);
