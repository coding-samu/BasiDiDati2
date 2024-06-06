-- Creazione dei domini
create domain InteroGZ as integer
    check (value > 0);

create domain InteroGEZ as integer
    check (value >= 0);

create domain StringaS as varchar(100);

create domain CF as varchar(16);
    -- check (isCF(value));

create domain Sconto as real
    check (value > 0 and value <= 1);

create domain Civico_not_null as StringaS
    check (value is not null /*and isCivico(value)*/);

create domain StringaS_not_null as StringaS
    check (value is not null);

create domain PartitaIva as StringaS;
    -- check (isPartitaIva(value));

create domain Email as StringaS;
    -- check (isEmail(value));

-- Creazione dei tipi
create type Ind as (
    via StringaS_not_null,
    civico Civico_not_null
);

create type StatoPrenotazione as enum ('Pending', 'Accettata', 'Rifiutata');

create type StatoAccettazione as enum ('Completata', 'NonUtilizzata');

-- Creazione delle tabelle
create table Nazione (
    nome StringaS primary key
);

create table Citta (
    id serial primary key,
    nome StringaS not null,
    nazione StringaS not null,
    foreign key (nazione) references Nazione(nome)
);

create table Cliente (
    indirizzoEmail Email primary key,
    nome StringaS not null,
    cognome StringaS not null
);

create table UtenteRistoratore (
    indirizzoEmail Email primary key,
    nome StringaS not null,
    cognome StringaS not null
);

create table CucinaTipo (
    nome StringaS primary key
);

create table Ristorante (
    pIva PartitaIva primary key,
    nome StringaS not null,
    indirizzo Ind not null,
    citta integer not null,
    ristoratore Email not null,
    foreign key (citta) references Citta(id),
    foreign key (ristoratore) references UtenteRistoratore(indirizzoEmail)
);

create table cuc_rist (
    ristorante PartitaIva not null,
    tipoCucina StringaS not null,
    primary key (ristorante, tipoCucina),
    foreign key (ristorante) references Ristorante(pIva),
    foreign key (tipoCucina) references CucinaTipo(nome)
);

create table Promozione (
    id serial primary key,
    nome StringaS not null,
    percentuale Sconto not null,
    numCoperti InteroGZ not null,
    ristorante PartitaIva not null,
    foreign key (ristorante) references Ristorante(pIva)
);

create table GiornoPromozione (
    id serial primary key,
    giorno date not null,
    inizio time not null,
    fine time not null,
    promozione integer not null,
    foreign key (promozione) references Promozione(id)
);

create table Prenotazione (
    id serial primary key,
    data timestamp not null,
    coperti InteroGZ not null,
    istantePren timestamp not null,
    statoPren StatoPrenotazione not null,
    statoAcc StatoAccettazione,
    annullata boolean not null,
    giornoProm integer,
    ristorante PartitaIva not null,
    cliente Email not null,
    foreign key (giornoProm) references GiornoPromozione(id),
    foreign key (ristorante) references Ristorante(pIva),
    foreign key (cliente) references Cliente(indirizzoEmail)
);

create table ChiusuraPrenotazione (
    id serial primary key,
    inizio timestamp not null,
    fine timestamp not null,
    istanteInserimento timestamp not null,
    ristorante PartitaIva not null,
    foreign key (ristorante) references Ristorante(pIva)
);