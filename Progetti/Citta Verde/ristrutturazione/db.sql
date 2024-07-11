-- Creazione dei domain
create domain StringaS as varchar(75);
create domain Prior as integer check(value between 1 and 10);
create domain CF as varchar(16);
create domain CodSquadra as varchar(10);
create domain InteroGZ as integer check(value > 0);
create domain RealeGEZ as real check(value >= 0);

-- Creazione dei tipi
create type TipAttr as enum('Strumento Leggero','Veicolo','Veicolo speciale');
create type Rischio as enum('Trascurabile','Basso','Medio','Alto');
create type Grav as enum('Bassa','Media','Alta','Mortale');
create type Pos as (latitudine real, longitudine real);

-- Creazione delle tabelle
create table TipologiaAttivita (
    _nome StringaS primary key
);

create table Attrezzatura (
    _nome StringaS primary key,
    tipologia TipAttr
);

create table attr_ta (
    _attrezzatura StringaS,
    _tipologiaAttivita StringaS,
    foreign key (_attrezzatura) references Attrezzatura(_nome),
    foreign key (_tipologiaAttivita) references TipologiaAttivita(_nome),
    primary key (_attrezzatura, _tipologiaAttivita)
);

create table Persona (
    _codFisc CF primary key,
    nome StringaS,
    cognome StringaS
);

create table Operatore (
    _id serial primary key,
    inizio timestamp,
    fine timestamp,
    persona CF references Persona(_codFisc)
);

create table Squadra (
    _codice CodSquadra primary key,
    inizio timestamp,
    fine timestamp
);

create table Partecipa (
    _id serial primary key,
    inizio timestamp,
    fine timestamp,
    isCapo boolean,
    operatore integer references Operatore(_id),
    squadra CodSquadra references Squadra(_codice)
);

create table PuoUtilizzare (
    _id serial primary key,
    inizio timestamp,
    fine timestamp,
    attrezzatura StringaS references Attrezzatura(_nome),
    operatore integer references Operatore(_id)
);

create table AreaVerde (
    _denominazione StringaS primary key,
    isFruibile boolean,
    isSensibile boolean,
    check (not isSensibile or isFruibile)
);

create table Intervento (
    _id serial primary key,
    minimoOperatori InteroGZ,
    inizio timestamp,
    durataGiorniStimata InteroGZ,
    priorita Prior,
    areaVerde StringaS references AreaVerde(_denominazione)
);

create table int_ta (
    _intervento integer,
    _tipologiaAttivita StringaS,
    foreign key (_intervento) references Intervento(_id),
    foreign key (_tipologiaAttivita) references TipologiaAttivita(_nome),
    primary key (_intervento, _tipologiaAttivita)
);

create table Assegnato (
    _intervento integer,
    istanteAss timestamp,
    squadra CodSquadra references Squadra(_codice),
    foreign key (_intervento) references Intervento(_id),
    primary key (_intervento)
);

create table Completato (
    _intervento integer primary key,
    istanteCompl timestamp,
    foreign key (_intervento) references Intervento(_id)
);

create table Causa (
    _nome StringaS primary key
);

create table Specie (
    _nomeScientifico StringaS primary key,
    nomeComune StringaS
);

create table SoggettoVerde (
    _id serial primary key,
    dataPiantumazione timestamp,
    posizione Pos,
    catRischio Rischio,
    rimozione timestamp,
    specie StringaS references Specie(_nomeScientifico),
    causa StringaS references Causa(_nome),
    areaVerde StringaS references AreaVerde(_denominazione),
    check ((rimozione is null and causa is null) or (rimozione is not null and causa is not null))
);

create table int_sv (
    _intervento integer,
    _soggettoVerde integer,
    foreign key (_intervento) references Intervento(_id),
    foreign key (_soggettoVerde) references SoggettoVerde(_id),
    primary key (_intervento, _soggettoVerde)
);

create table TipologiaDimensione (
    _nome StringaS primary key
);

create table Dimensione (
    _soggettoVerde integer,
    _tipologiaDimensione StringaS,
    valore real,
    foreign key (_soggettoVerde) references SoggettoVerde(_id),
    foreign key (_tipologiaDimensione) references TipologiaDimensione(_nome),
    primary key (_soggettoVerde, _tipologiaDimensione)
);

create table Malattia (
    _nomeScientifico StringaS primary key,
    nomeVolgare StringaS,
    gravita Grav
);

create table StoricoMalattia (
    _id serial primary key,
    scoperta timestamp,
    isRisolta boolean,
    malattia StringaS references Malattia(_nomeScientifico),
    soggettoVerde integer references SoggettoVerde(_id),
    intervento integer references Completato(_intervento),
    check ((not isRisolta and intervento is null) or (isRisolta and intervento is not null))
);
