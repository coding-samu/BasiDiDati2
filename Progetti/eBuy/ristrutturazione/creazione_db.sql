create domain StringaM as varchar(100);

create domain StringaS as varchar(50);

create domain  InteroGEZ as integer
    check(value >= 0);

create domain InteroGZ as integer
    check (value > 0);

create type tipoPagamento as enum('ContoCorrente','Bonifico','Altro');

create domain Valutazione as InteroGEZ
    check(value <= 5);

create domain denaro as real
    check(value > 0);

create domain ValAffidabilita as real
    check(value >= 0 and value <= 1);

create domain MesiGaranziaNuovo as integer
    check(value >= 24);

create domain MesiGaranzia as InteroGEZ;

create type condizioniUsato as enum('Ottimo','Buono','Discreto','DaSistemare');

create type ValVendProf as enum('Bassa','Media','Alta');

create domain MediaValutazione as real
    check(value >= 0 and value <= 5);

create domain PercentualeFeedbackNegativi as real 
    check(value >= 0 and value <= 1);

create domain Valuta as varchar(3);
    -- check(isValuta(value));

-- Tabella Utente
create table Utente (
    nome StringaS not null,
    data_reg timestamp not null,
    primary key (nome)
);

-- Tabella MetodoPagamento
create table MetodoPagamento (
    nome StringaS not null,
    tipo tipoPagamento not null,
    primary key (nome)
);

-- Tabella Categoria
create table Categoria (
    nome StringaS not null,
    super_categoria StringaS,
    primary key (nome),
    foreign key (super_categoria) references Categoria(nome)
);

-- Tabella Valuta
create table Valute (
    nome Valuta not null,
    primary key (nome)
);

-- Tabella Post
create table Post (
    id serial not null,
    nome StringaS not null,
    descrizione text not null,
    garanziaMesi MesiGaranzia,
    prezzo_iniziale Denaro not null,
    istante_pubblicazione timestamp not null,
    valuta StringaS not null,
    categoria StringaS not null,
    venditore StringaS not null,
    primary key (id),
    foreign key (categoria) references Categoria(nome),
    foreign key (valuta) references Valute(nome),
    foreign key (venditore) references Utente(nome),
    unique (nome, venditore)
);

-- Tabella mp_post
create table mp_post (
    metodoPagamento StringaS not null,
    post integer not null,
    primary key (metodoPagamento, post),
    foreign key (metodoPagamento) references MetodoPagamento(nome),
    foreign key (post) references Post(id)
);

-- Tabella PostNuovo
create table PostNuovo (
    post integer not null,
    garanziaMesi MesiGaranziaNuovo not null,
    primary key (post),
    foreign key (post) references Post(id)
);

-- Tabella PostUsato
create table PostUsato (
    post integer not null,
    condizioni condizioniUsato not null,
    primary key (post),
    foreign key (post) references Post(id)
);

-- Tabella PostConFeedback
create table PostConFeedback (
    post integer not null,
    voto Valutazione not null,
    commento text,
    primary key (post),
    foreign key (post) references Post(id)
);

-- Tabella UtentePrivato
create table UtentePrivato (
    utente StringaS not null,
    primary key (utente),
    foreign key (utente) references Utente(nome)
);

-- Tabella VendProf
create table VendProf (
    utente StringaS not null,
    url StringaM not null,
    primary key (utente),
    foreign key (utente) references Utente(nome)
);

-- Tabella PostCS
create table PostCS (
    post integer not null,
    acquirente StringaS,
    primary key (post),
    foreign key (post) references Post(id),
    foreign key (acquirente) references UtentePrivato(utente)
);

-- Tabella PostAsta
create table PostAsta (
    post integer not null,
    rialzo Denaro not null,
    istante_scad timestamp not null,
    primary key (post),
    foreign key (post) references Post(id)
);

-- Tabella Bid
create table Bid (
    id serial not null,
    istante timestamp not null,
    bidder StringaS not null,
    post integer not null,
    primary key (id),
    foreign key (bidder) references UtentePrivato(utente),
    foreign key (post) references Post(id),
    unique (istante, post)
);
