-- Creazione dei domini e dei tipi
create domain StringaS as varchar(75);
create type TipAttr as enum('Strumento Leggero', 'Veicolo', 'Veicolo speciale');
create domain Prior as integer check(value between 1 and 10);
create type Rischio as enum('Trascurabile', 'Basso', 'Medio', 'Alto');
create type Grav as enum('Bassa', 'Media', 'Alta', 'Mortale');
create type Pos as (latitudine real, longitudine real);
create domain CF as varchar(16);
create domain CodSquadra as varchar(10);
create domain InteroGZ as integer check(value > 0);
create domain RealeGEZ as real check(value >= 0);

-- Creazione delle tabelle
create table TipologiaAttivita (
    nome StringaS primary key
);

create table Attrezzatura (
    nome StringaS primary key,
    tipologia TipAttr not null
);

create table attr_ta (
    attrezzatura StringaS not null,
    tipologiaAttivita StringaS not null,
    primary key (attrezzatura, tipologiaAttivita),
    foreign key (attrezzatura) references Attrezzatura(nome),
    foreign key (tipologiaAttivita) references TipologiaAttivita(nome)
);

create table Persona (
    codFisc CF primary key,
    nome StringaS not null,
    cognome StringaS not null
);

create table Operatore (
    id serial primary key,
    inizio timestamp not null,
    fine timestamp,
    persona CF not null,
    foreign key (persona) references Persona(codFisc),
    check (fine is null or inizio <= fine)
);

create table Squadra (
    codice CodSquadra primary key,
    inizio timestamp not null,
    fine timestamp,
    check (fine is null or inizio <= fine)
);

create table Partecipa (
    id serial primary key,
    inizio timestamp not null,
    fine timestamp,
    isCapo boolean not null,
    operatore integer not null,
    squadra CodSquadra not null,
    foreign key (operatore) references Operatore(id),
    foreign key (squadra) references Squadra(codice),
    check (fine is null or inizio <= fine)
);

create table PuoUtilizzare (
    id serial primary key,
    inizio timestamp not null,
    fine timestamp,
    attrezzatura StringaS not null,
    operatore integer not null,
    foreign key (attrezzatura) references Attrezzatura(nome),
    foreign key (operatore) references Operatore(id),
    check (fine is null or inizio <= fine)
);

create table AreaVerde (
    denominazione StringaS primary key,
    isFruibile boolean not null,
    isSensibile boolean not null,
    check (not isSensibile or isFruibile)
);

create table Intervento (
    id serial primary key,
    minimoOperatori InteroGZ not null,
    inizio timestamp not null,
    durataGiorniStimata InteroGZ not null,
    priorita Prior not null,
    areaVerde StringaS not null,
    foreign key (areaVerde) references AreaVerde(denominazione)
);

create table int_ta (
    intervento integer not null,
    tipologiaAttivita StringaS not null,
    primary key (intervento, tipologiaAttivita),
    foreign key (intervento) references Intervento(id),
    foreign key (tipologiaAttivita) references TipologiaAttivita(nome)
);

create table Assegnato (
    intervento integer not null,
    istanteAss timestamp not null,
    squadra CodSquadra not null,
    primary key (intervento),
    foreign key (intervento) references Intervento(id),
    foreign key (squadra) references Squadra(codice)
);

create table Completato (
    intervento integer not null,
    istanteCompl timestamp not null,
    primary key (intervento),
    foreign key (intervento) references Intervento(id)
);

create table Causa (
    nome StringaS primary key
);

create table Specie (
    nomeScientifico StringaS primary key,
    nomeComune StringaS not null
);

create table SoggettoVerde (
    id serial primary key,
    dataPiantumazione timestamp not null,
    posizione Pos not null,
    catRischio Rischio not null,
    rimozione timestamp,
    specie StringaS not null,
    causa StringaS,
    areaVerde StringaS not null,
    foreign key (specie) references Specie(nomeScientifico),
    foreign key (causa) references Causa(nome),
    foreign key (areaVerde) references AreaVerde(denominazione),
    check (rimozione is null or dataPiantumazione <= rimozione),
    check ((rimozione is null and causa is null) or (rimozione is not null and causa is not null))
);

create table int_sv (
    intervento integer not null,
    soggettoVerde integer not null,
    primary key (intervento, soggettoVerde),
    foreign key (intervento) references Intervento(id),
    foreign key (soggettoVerde) references SoggettoVerde(id)
);

create table TipologiaDimensione (
    nome StringaS primary key
);

create table Dimensione (
    soggettoVerde integer not null,
    tipologiaDimensione StringaS not null,
    valore real not null,
    primary key (soggettoVerde, tipologiaDimensione),
    foreign key (soggettoVerde) references SoggettoVerde(id),
    foreign key (tipologiaDimensione) references TipologiaDimensione(nome)
);

create table Malattia (
    nomeScientifico StringaS primary key,
    nomeVolgare StringaS not null,
    gravita Grav not null
);

create table StoricoMalattia (
    id serial primary key,
    scoperta timestamp not null,
    isRisolta boolean not null,
    malattia StringaS not null,
    soggettoVerde integer not null,
    intervento integer,
    foreign key (malattia) references Malattia(nomeScientifico),
    foreign key (soggettoVerde) references SoggettoVerde(id),
    foreign key (intervento) references Completato(intervento),
    check ((not isRisolta and intervento is null) or (isRisolta and intervento is not null))
);
