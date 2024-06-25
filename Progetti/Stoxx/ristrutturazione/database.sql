-- Creazione dei domini
create domain Denaro as real;
create domain Perc as real check (value >= 0 and value <= 1);
create domain RealeGZ as real check (value > 0);
create domain InteroGEZ as integer check (value >= 0);
create domain StringaS as varchar(75);
create domain codFisc as varchar(16);
create domain nDoc as text;
create domain MatProm as text;
create domain IndEmail as text;
create domain Tel as text;

-- Creazione dei tipi ENUM
create type Rischio as enum('basso','moderato','alto','aggressivo');
create type tipoTitolo as enum('Azionario','Obbligazionario','DiStato');
create type tipoEmittente as enum('Azienda','Stato');

-- Creazione delle tabelle
create table RecapitoTelefonico (
    telefono Tel primary key
);

create table Promotore (
    matricola MatProm primary key,
    nome StringaS not null,
    cognome StringaS not null
);

create table TipologiaDocumento (
    nome StringaS primary key
);

create table Emittente (
    nome StringaS primary key,
    tipo tipoEmittente not null
);

create table StrumentoFinanziario (
    id serial primary key,
    emittente StringaS not null references Emittente(nome)
);

create table Rilevazione (
    id serial primary key,
    istante timestamp not null,
    valore Denaro not null check (valore > 0),
    sf integer not null references StrumentoFinanziario(id),
    unique (istante, sf)
);

create table Titolo (
    sf integer primary key references StrumentoFinanziario(id),
    tipo tipoTitolo not null
);

create table FondoGestito (
    sf integer primary key references StrumentoFinanziario(id),
    titoliAzionari InteroGEZ not null,
    titoliObbligazionari InteroGEZ not null,
    titoliDiStato InteroGEZ not null,
    check (titoliAzionari + titoliObbligazionari + titoliDiStato > 0)
);

create table Cliente (
    cf codFisc primary key,
    email IndEmail unique,
    numDoc nDoc not null,
    nome StringaS not null,
    cognome StringaS not null,
    tipoDocumento StringaS not null references TipologiaDocumento(nome)
);

create table cli_rt (
    telefono Tel not null references RecapitoTelefonico(telefono),
    cliente codFisc not null references Cliente(cf),
    primary key (telefono, cliente)
);

create table Gestione (
    id serial primary key,
    inizio timestamp not null,
    isTerminata boolean not null,
    fine timestamp,
    motivazione text,
    cliente codFisc not null references Cliente(cf),
    promotore MatProm not null references Promotore(matricola),
    check (fine is null or inizio <= fine),
    check ((isTerminata and fine is not null and motivazione is not null) or (not isTerminata and fine is null and motivazione is null))
);

create table Investimento (
    id serial primary key,
    istante timestamp not null,
    quantita RealeGZ not null,
    gestione integer not null references Gestione(id),
    sf integer not null references StrumentoFinanziario(id)
);

create table Disinvestimento (
    id serial primary key,
    istante timestamp not null,
    quantita RealeGZ not null,
    investimento integer not null references Investimento(id)
);
