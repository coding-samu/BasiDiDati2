create domain StringaS as varchar(75);
create type TipAttr as enum('Strumento Leggero','Veicolo','Veicolo speciale');
create domain Prior as integer check(value between 1 and 10);
create type Rischio as enum('Trascurabile','Basso','Medio','Alto');
create type Grav as enum('Bassa','Media','Alta','Mortale');
create type Pos as (latitudine real, longitudine real);
create domain CF as varchar(16);
create domain CodSquadra as varchar(10);
create domain InteroGZ as integer check(value > 0);