create domain StringaS as varchar(50);

create domain StringaM as varchar(100);

create domain StringaL as text;

create domain InteroGEZ as integer
    check(value >= 0);

create domain InteroGZ as integer
    check(value > 0);

create domain Voto as integer
    check(value >= 0 and value <= 5);

create domain RealeGEZ as real
    check(value >= 0);

create type StatoPlaylist as enum('Pubblica','Privata');

create domain FileVideo as bytea;