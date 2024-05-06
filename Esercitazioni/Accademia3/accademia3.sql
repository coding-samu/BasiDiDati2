create type Strutturato as enum ('Ricercatore','Professore Associato','Professore Ordinario');
create type LavoroProgetto as enum ('Ricerca e Sviluppo', 'Dimostrazione','Management','Altro');
create type LavoroNonProgettuale as enum ('Didattica','Ricerca','Missione','Incontro Dipartimentale','Incontro Accademico','Altro');
create type CausaAssenza as enum ('Chiusura Universitaria','Maternita','Malattia');

create domain PosInteger as integer check (value >= 0);
create domain StringaM as varchar(100);
create domain numeroOre as integer check (value >= 0 and value <= 8);
create domain denaro as real check (value >= 0);

create table persona(id PosInteger primary key, nome StringaM, cognome StringaM, posizione Strutturato, stipendio Denaro);
create table progetto (id PosInteger primary key, nome StringaM unique, inizio date, fine date, budget Denaro, check (inizio < fine));
create table wp (progetto PosInteger references Progetto(id), id PosInteger, nome StringaM, inizio date, fine date, primary key (progetto,id), unique(progetto, nome), check (inizio < fine));
create table AttivitaProgetto (id PosInteger primary key, persona PosInteger references Persona(id), progetto PosInteger, wp PosInteger, giorno date, tipo LavoroProgetto, oreDurata NumeroOre, foreign key (progetto,wp) references wp(progetto,id));
create table AttivitaNonProgettuale (id PosInteger primary key, persona PosInteger references Persona(id), tipo LavoroNonProgettuale, giorno date, oreDurata NumeroOre);
create table Assenza (id PosInteger primary key, persona PosInteger references Persona(id), tipo CausaAssenza, giorno date, unique(persona,giorno));
